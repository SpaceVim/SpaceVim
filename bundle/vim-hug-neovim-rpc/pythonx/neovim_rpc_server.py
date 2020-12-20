# vim:set et sw=4 ts=8:

import json
import socket
import sys
import os
import threading
import vim
import logging
import msgpack
import neovim_rpc_server_api_info
import neovim_rpc_methods
import neovim_rpc_protocol

vim_error = vim.Function('neovim_rpc#_error')
vim_py = vim.eval('g:neovim_rpc#py')


if sys.version_info.major == 2:
    from Queue import Queue, Empty as QueueEmpty
else:
    from queue import Queue, Empty as QueueEmpty

# NVIM_PYTHON_LOG_FILE=nvim.log NVIM_PYTHON_LOG_LEVEL=INFO vim test.md

try:
    # Python 3
    import socketserver
except ImportError:
    # Python 2
    import SocketServer as socketserver

# globals
logger = logging.getLogger(__name__)
# supress the annoying error message:
#     No handlers could be found for logger "neovim_rpc_server"
logger.addHandler(logging.NullHandler())

request_queue = Queue()
responses = {}


def _channel_id_new():
    with _channel_id_new._lock:
        _channel_id_new._counter += 1
        return _channel_id_new._counter


# static local
_channel_id_new._counter = 0
_channel_id_new._lock = threading.Lock()


class VimHandler(socketserver.BaseRequestHandler):

    _lock = threading.Lock()
    _sock = None

    @classmethod
    def notify(cls, cmd=None):
        try:
            if cmd is None:
                cmd = vim_py + " neovim_rpc_server.process_pending_requests()"
            if not VimHandler._sock:
                return
            with VimHandler._lock:
                encoded = json.dumps(['ex', cmd])
                logger.info("sending notification: %s", encoded)
                VimHandler._sock.send(encoded.encode('utf-8'))
        except Exception as ex:
            logger.exception(
                'VimHandler notify exception for [%s]: %s', cmd, ex)

    @classmethod
    def notify_exited(cls, channel):
        try:
            cls.notify("call neovim_rpc#_on_exit(%s)" % channel)
        except Exception as ex:
            logger.exception(
                'notify_exited for channel [%s] exception: %s', channel, ex)

    # each connection is a thread
    def handle(self):
        logger.info("=== socket opened ===")
        data = None
        while True:
            try:
                rcv = self.request.recv(4096)
                # 16k buffer by default
                if data:
                    data += rcv
                else:
                    data = rcv
            except socket.error:
                logger.info("=== socket error ===")
                break
            except IOError:
                logger.info("=== socket closed ===")
                break
            if len(rcv) == 0:
                logger.info("=== socket closed ===")
                break
            logger.info("received: %s", data)
            try:
                decoded = json.loads(data.decode('utf-8'))
            except ValueError:
                logger.exception("json decoding failed, wait for more data")
                continue
            data = None

            # Send a response if the sequence number is positive.
            # Negative numbers are used for "eval" responses.
            if (len(decoded) >= 2 and decoded[0] >= 0 and
                    decoded[1] == 'neovim_rpc_setup'):

                VimHandler._sock = self.request

                # initial setup
                encoded = json.dumps(['ex', "call neovim_rpc#_callback()"])
                logger.info("sending {0}".format(encoded))
                self.request.send(encoded.encode('utf-8'))

            else:
                # recognize as rpcrequest
                reqid = decoded[0]
                channel = decoded[1][1]
                event = decoded[1][2]
                args = decoded[1][3]
                rspid = decoded[1][4]
                NvimHandler.request(self.request,
                                    channel,
                                    reqid,
                                    event,
                                    args,
                                    rspid)


class SocketToStream():

    def __init__(self, sock):
        self._sock = sock

    def read(self, cnt):
        if cnt > 4096:
            cnt = 4096
        return self._sock.recv(cnt)

    def write(self, w):
        return self._sock.send(w)


class NvimHandler(socketserver.BaseRequestHandler):

    channel_sockets = {}

    def handle(self):

        logger.info("=== socket opened for client ===")

        channel = _channel_id_new()

        sock = self.request
        chinfo = dict(sock=sock)
        NvimHandler.channel_sockets[channel] = chinfo

        try:
            f = SocketToStream(sock)
            unpacker = msgpack.Unpacker(f)
            for unpacked in unpacker:
                logger.info("unpacked: %s", unpacked)

                # response format:
                #   - msg[0]: 1
                #   - msg[1]: the request id
                #   - msg[2]: error(if any), format: [code,str]
                #   - msg[3]: result(if not errored)
                if int(unpacked[0]) == 1:
                    unpacked = neovim_rpc_protocol.from_client(unpacked)
                    reqid = int(unpacked[1])
                    rspid, vimsock = chinfo[reqid]
                    err = unpacked[2]
                    result = unpacked[3]
                    # VIM fails to parse response when there a sleep in neovim
                    # client. I cannot figure out why. Use global responses to
                    # workaround this issue.
                    responses[rspid] = [err, result]
                    content = [reqid, '']
                    tosend = json.dumps(content)
                    # vimsock.send
                    vimsock.send(tosend.encode('utf-8'))
                    chinfo.pop(reqid)
                    continue

                request_queue.put((f, channel, unpacked))
                # notify vim in order to process request in main thread, and
                # avoiding the stupid json protocol
                VimHandler.notify()

            logger.info('channel %s closed.', channel)

        except Exception:
            logger.exception('unpacker failed.')
        finally:
            try:
                NvimHandler.channel_sockets.pop(channel)
                sock.close()
            except Exception:
                pass

    @classmethod
    def notify(cls, channel, event, args):
        try:
            channel = int(channel)
            if channel not in cls.channel_sockets:
                logger.info("channel[%s] not in NvimHandler", channel)
                return
            sock = cls.channel_sockets[channel]['sock']

            # notification format:
            #   - msg[0] type, which is 2
            #   - msg[1] method
            #   - msg[2] arguments
            content = [2, event, args]

            logger.info("notify channel[%s]: %s", channel, content)
            packed = msgpack.packb(neovim_rpc_protocol.to_client(content))
            sock.send(packed)
        except Exception as ex:
            logger.exception("notify failed: %s", ex)

    @classmethod
    def request(cls, vimsock, channel, reqid, event, args, rspid):
        try:
            reqid = int(reqid)
            channel = int(channel)
            chinfo = cls.channel_sockets[channel]

            if channel not in cls.channel_sockets:
                logger.info("channel[%s] not in NvimHandler", channel)
                return

            sock = chinfo['sock']
            # request format:
            #   - msg[0] type, which is 0
            #   - msg[1] request id
            #   - msg[2] method
            #   - msg[3] arguments
            content = [0, reqid, event, args]

            chinfo[reqid] = [rspid, vimsock]

            logger.info("request channel[%s]: %s", channel, content)
            packed = msgpack.packb(neovim_rpc_protocol.to_client(content))
            sock.send(packed)
        except Exception as ex:
            logger.exception("request failed: %s", ex)

    @classmethod
    def shutdown(cls):
        # close all sockets
        for channel in list(cls.channel_sockets.keys()):
            chinfo = cls.channel_sockets.get(channel, None)
            if chinfo:
                sock = chinfo['sock']
                logger.info("closing client %s", channel)
                # if don't shutdown the socket, vim will never exit because the
                # recv thread is still blocking
                sock.shutdown(socket.SHUT_RDWR)
                sock.close()


# copied from neovim python-client/neovim/__init__.py
def _setup_logging(name):
    """Setup logging according to environment variables."""
    logger = logging.getLogger(__name__)
    if 'NVIM_PYTHON_LOG_FILE' in os.environ:
        prefix = os.environ['NVIM_PYTHON_LOG_FILE'].strip()
        major_version = sys.version_info[0]
        logfile = '{}_py{}_{}'.format(prefix, major_version, name)
        handler = logging.FileHandler(logfile, 'w', encoding='utf-8')
        handler.formatter = logging.Formatter(
            '%(asctime)s [%(levelname)s @ '
            '%(filename)s:%(funcName)s:%(lineno)s] %(process)s - %(message)s')
        logging.root.addHandler(handler)
        level = logging.INFO
        if 'NVIM_PYTHON_LOG_LEVEL' in os.environ:
            lv = getattr(logging,
                         os.environ['NVIM_PYTHON_LOG_LEVEL'].strip(),
                         level)
            if isinstance(lv, int):
                level = lv
        logger.setLevel(level)


class ThreadedTCPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    pass


if sys.platform in ['linux', 'darwin']:
    class ThreadedUnixServer(socketserver.ThreadingMixIn,
                             socketserver.UnixStreamServer):
        pass
    has_unix = True
else:
    has_unix = False


def start():

    _setup_logging('neovim_rpc_server')

    # 0 for random port
    global _vim_server
    global _nvim_server

    _vim_server = ThreadedTCPServer(("127.0.0.1", 0), VimHandler)
    _vim_server.daemon_threads = True
    vim_server_addr = "{addr[0]}:{addr[1]}".format(
        addr=_vim_server.server_address)

    if 'NVIM_LISTEN_ADDRESS' in os.environ:
        nvim_server_addr = os.environ['NVIM_LISTEN_ADDRESS']
        if nvim_server_addr.find(':') >= 0:
            host, port = nvim_server_addr.split(':')
            port = int(port)
            _nvim_server = ThreadedTCPServer((host, port), NvimHandler)
        elif has_unix:
            if os.path.exists(nvim_server_addr):
                try:
                    os.unlink(nvim_server_addr)
                except Exception:
                    pass
            _nvim_server = ThreadedUnixServer(nvim_server_addr, NvimHandler)
        else:
            # FIXME named pipe server ?
            _nvim_server = ThreadedTCPServer(("127.0.0.1", 0), NvimHandler)
            nvim_server_addr = "{addr[0]}:{addr[1]}".format(
                addr=_nvim_server.server_address)
    elif not has_unix:
        _nvim_server = ThreadedTCPServer(("127.0.0.1", 0), NvimHandler)
        nvim_server_addr = "{addr[0]}:{addr[1]}".format(
            addr=_nvim_server.server_address)
    else:
        nvim_server_addr = vim.eval('tempname()')
        _nvim_server = ThreadedUnixServer(nvim_server_addr, NvimHandler)
    _nvim_server.daemon_threads = True

    # Start a thread with the server -- that thread will then start one
    # more thread for each request
    main_server_thread = threading.Thread(target=_vim_server.serve_forever)
    clients_server_thread = threading.Thread(target=_nvim_server.serve_forever)

    # Exit the server thread when the main thread terminates
    main_server_thread.daemon = True
    main_server_thread.start()
    clients_server_thread.daemon = True
    clients_server_thread.start()

    return [nvim_server_addr, vim_server_addr]


def process_pending_requests():

    logger.info("process_pending_requests")
    while True:

        item = None
        try:

            item = request_queue.get(False)

            f, channel, msg = item

            msg = neovim_rpc_protocol.from_client(msg)

            logger.info("get msg from channel [%s]: %s", channel, msg)

            # request format:
            #   - msg[0] type, which is 0
            #   - msg[1] request id
            #   - msg[2] method
            #   - msg[3] arguments

            # notification format:
            #   - msg[0] type, which is 2
            #   - msg[1] method
            #   - msg[2] arguments

            if msg[0] == 0:
                # request

                req_typed, req_id, method, args = msg

                try:
                    err = None
                    result = _process_request(channel, method, args)
                except Exception as ex:
                    logger.exception("process failed: %s", ex)
                    # error uccor
                    err = [1, str(ex)]
                    result = None

                result = [1, req_id, err, result]
                logger.info("sending result: %s", result)
                packed = msgpack.packb(neovim_rpc_protocol.to_client(result))
                f.write(packed)
                logger.info("sent")
            if msg[0] == 2:
                # notification
                req_typed, method, args = msg
                try:
                    result = _process_request(channel, method, args)
                    logger.info('notification process result: [%s]', result)
                except Exception as ex:
                    logger.exception("process failed: %s", ex)

        except QueueEmpty:
            pass
        except Exception as ex:
            logger.exception("exception during process: %s", ex)
        finally:
            if item:
                request_queue.task_done()
            else:
                # item==None means the queue is empty
                break


def _process_request(channel, method, args):
    if hasattr(neovim_rpc_methods, method):
        return getattr(neovim_rpc_methods, method)(*args)
    elif method in ['vim_get_api_info', 'nvim_get_api_info']:
        # the first request sent by neovim python client
        return [channel, neovim_rpc_server_api_info.API_INFO]
    else:
        logger.error("method %s not implemented", method)
        vim_error(
            "rpc method [%s] not implemented in "
            "pythonx/neovim_rpc_methods.py. "
            "Please send PR or contact the mantainer." % method)
        raise Exception('%s not implemented' % method)


def rpcnotify(channel, method, args):
    NvimHandler.notify(channel, method, args)


def stop():

    logger.info("stop begin")

    # close tcp channel server
    _nvim_server.shutdown()
    _nvim_server.server_close()

    # close the main channel
    try:
        vim.command('call ch_close(g:_neovim_rpc_main_channel)')
    except Exception as ex:
        logger.info("ch_close failed: %s", ex)

    # remove all sockets
    NvimHandler.shutdown()

    try:
        # stop the main channel
        _vim_server.shutdown()
    except Exception as ex:
        logger.info("_vim_server shutodwn failed: %s", ex)

    try:
        _vim_server.server_close()
    except Exception as ex:
        logger.info("_vim_server close failed: %s", ex)
