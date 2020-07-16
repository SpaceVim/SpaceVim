from importlib.util import find_spec

if find_spec('pynvim'):
    from pynvim import attach, setup_logging
else:
    from neovim import attach, setup_logging

import sys
import importlib
from os import environ

assert __name__ == "__main__"

if "" in sys.path:
    sys.path.remove("")

serveraddr = sys.argv[1]
yarpid = int(sys.argv[2])
module = sys.argv[3]
module_obj = None
nvim = None

environ['NVIM_YARP_MODULE'] = module

setup_logging(module)

def on_request(method, args):
    if hasattr(module_obj, method):
        return getattr(module_obj, method)(*args)
    else:
        raise Exception('method %s not found' % method)


def on_notification(method, args):
    if hasattr(module_obj, method):
        getattr(module_obj, method)(*args)
    else:
        raise Exception('method %s not found' % method)
    pass


def on_setup():
    pass

try:
    # create another connection to avoid synchronization issue?
    if len(serveraddr.split(':')) == 2:
        serveraddr, port = serveraddr.split(':')
        port = int(port)
        nvim = attach('tcp', address=serveraddr, port=port)
    else:
        nvim = attach('socket', path=serveraddr)

    sys.modules['vim'] = nvim
    sys.modules['nvim'] = nvim

    paths = nvim.eval(r'globpath(&rtp,"pythonx",1) . "\n" .'
                      r' globpath(&rtp,"rplugin/python3",1)')
    for path in paths.split("\n"):
        if not path:
            continue
        if path not in sys.path:
            sys.path.append(path)

    module_obj = importlib.import_module(module)

    nvim.call('yarp#core#channel_started', yarpid, nvim.channel_id)

    nvim.run_loop(on_request, on_notification, on_setup)
finally:
    nvim.close()
