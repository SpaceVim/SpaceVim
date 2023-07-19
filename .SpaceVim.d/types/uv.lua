---@meta

---@meta
---@diagnostic disable: duplicate-set-field

-- TODO: define @source for all sections and methods

-- TODO: things like uv.tty_set_mode has in the description-
-- "look below for possible values" and then we rely on lls to list the alias
-- we need a way to list those off when generating the docs

---
---The [luv](https://github.com/luvit/luv/) project provides access to the multi-platform support library
---[libuv](http://libuv.org/) in Lua code. It was primarily developed for the [luvit](https://github.com/luvit/luvit/) project as
---the built-in `uv` module, but can be used in other Lua environments.
---
---More information about the core libuv library can be found at the original
---[libuv documentation page](http://docs.libuv.org/en/v1.x/).
---
---### TCP Echo Server Example
---
---Here is a small example showing a TCP echo server:
---
---```lua
---local uv = require("luv") -- "luv" when stand-alone, "uv" in luvi apps
---
---local server = uv.new_tcp()
---server:bind("127.0.0.1", 1337)
---server:listen(128, function (err)
---  assert(not err, err)
---  local client = uv.new_tcp()
---  server:accept(client)
---  client:read_start(function (err, chunk)
---    assert(not err, err)
---    if chunk then
---      client:write(chunk)
---    else
---      client:shutdown()
---      client:close()
---    end
---  end)
---end)
---print("TCP server listening at 127.0.0.1 port 1337")
---uv.run() -- an explicit run call is necessary outside of luvit
---```
---
---### Module Layout
---
---The luv library contains a single Lua module referred to hereafter as `uv` for
---simplicity. This module consists mostly of functions with names corresponding to
---their original libuv versions. For example, the libuv function `uv_tcp_bind` has
---a luv version at `uv.tcp_bind`. Currently, only two non-function fields exists:
---`uv.constants` and `uv.errno`, which are tables.
---
---### Functions vs Methods
---
---In addition to having simple functions, luv provides an optional method-style
---API. For example, `uv.tcp_bind(server, host, port)` can alternatively be called
---as `server:bind(host, port)`. Note that the first argument `server` becomes the
---object and `tcp_` is removed from the function name. Method forms are
---documented below where they exist.
---
---### Synchronous vs Asynchronous Functions
---
---Functions that accept a callback are asynchronous. These functions may
---immediately return results to the caller to indicate their initial status, but
---their final execution is deferred until at least the next libuv loop iteration.
---After completion, their callbacks are executed with any results passed to it.
---
---Functions that do not accept a callback are synchronous. These functions
---immediately return their results to the caller.
---
---Some (generally FS and DNS) functions can behave either synchronously or
---asynchronously. If a callback is provided to these functions, they behave
---asynchronously; if no callback is provided, they behave synchronously.
---
---### Pseudo-Types
---
---Some unique types are defined. These are not actual types in Lua, but they are
---used here to facilitate documenting consistent behavior:
---- `fail`: an assertable `nil, string, string` tuple (see [Error handling][])
---- `callable`: a `function`; or a `table` or `userdata` with a `__call`
---  metamethod
---- `buffer`: a `string` or a sequential `table` of `string`s
---- `threadargs`: variable arguments (`...`) of type `nil`, `boolean`, `number`,
---  `string`, or `userdata`
---
---@namespace
---@class uv
---@section Libuv in Lua
local uv = {}

---@alias uv.aliases.buffer string|string[]

---@alias uv.aliases.threadargs userdata|string|number|boolean|nil



---
---@section Contents
---
---This documentation is mostly a retelling of the [libuv API documentation][]
---within the context of luv's Lua API. Low-level implementation details and
---unexposed C functions and types are not documented here except for when they
---are relevant to behavior seen in the Lua module.
---
--- - [Error handling][]
--- - [Version checking][]
--- - [`uv_loop_t`][] — Event loop
--- - [`uv_req_t`][] — Base request
--- - [`uv_handle_t`][] — Base handle
---   - [`uv_timer_t`][] — Timer handle
---   - [`uv_prepare_t`][] — Prepare handle
---   - [`uv_check_t`][] — Check handle
---   - [`uv_idle_t`][] — Idle handle
---   - [`uv_async_t`][] — Async handle
---   - [`uv_poll_t`][] — Poll handle
---   - [`uv_signal_t`][] — Signal handle
---   - [`uv_process_t`][] — Process handle
---   - [`uv_stream_t`][] — Stream handle
---     - [`uv_tcp_t`][] — TCP handle
---     - [`uv_pipe_t`][] — Pipe handle
---     - [`uv_tty_t`][] — TTY handle
---   - [`uv_udp_t`][] — UDP handle
---   - [`uv_fs_event_t`][] — FS Event handle
---   - [`uv_fs_poll_t`][] — FS Poll handle
--- - [File system operations][]
--- - [Thread pool work scheduling][]
--- - [DNS utility functions][]
--- - [Threading and synchronization utilities][]
--- - [Miscellaneous utilities][]
--- - [Metrics operations][]
---

-- TODO: above section should probably not be hardcoded



---
---In libuv, errors are negative numbered constants; however, while those errors are exposed through `uv.errno`,
---the functions used to handle them are not exposed to luv users. Instead, if an
---internal error is encountered, the luv function will return to the caller an
---assertable `nil, err, name` tuple.
---
---- `nil` idiomatically indicates failure
---- `err` is a string with the format `{name}: {message}`
---  - `{name}` is the error name provided internally by `uv_err_name`
---  - `{message}` is a human-readable message provided internally by `uv_strerror`
---- `name` is the same string used to construct `err`
---
---This tuple is referred to below as the `fail` pseudo-type.
---
---When a function is called successfully, it will return either a value that is
---relevant to the operation of the function, or the integer `0` to indicate
---success, or sometimes nothing at all. These cases are documented below.
---
---@alias uv.errno {E2BIG: integer, EACCES: integer, EADDRINUSE: integer, EADDRNOTAVAIL: integer, EAFNOSUPPORT: integer, EAGAIN: integer, EAI_ADDRFAMILY: integer, EAI_AGAIN: integer, EAI_BADFLAGS: integer, EAI_BADHINTS: integer, EAI_CANCELED: integer, EAI_FAIL: integer, EAI_FAMILY: integer, EAI_MEMORY: integer, EAI_NODATA: integer, EAI_NONAME: integer, EAI_OVERFLOW: integer, EAI_PROTOCOL: integer, EAI_SERVICE: integer, EAI_SOCKTYPE: integer, EALREADY: integer, EBADF: integer, EBUSY: integer, ECANCELED: integer, ECHARSET: integer, ECONNABORTED: integer, ECONNREFUSED: integer, ECONNRESET: integer, EDESTADDRREQ: integer, EEXIST: integer, EFAULT: integer, EFBIG: integer, EFTYPE: integer, EHOSTDOWN: integer, EHOSTUNREACH: integer, EILSEQ: integer, EINTR: integer, EINVAL: integer, EIO: integer, EISCONN: integer, EISDIR: integer, ELOOP: integer, EMFILE: integer, EMLINK: integer, EMSGSIZE: integer, ENAMETOOLONG: integer, ENETDOWN: integer, ENETUNREACH: integer, ENFILE: integer, ENOBUFS: integer, ENODATA: integer, ENODEV: integer, ENOENT: integer, ENOMEM: integer, ENONET: integer, ENOPROTOOPT: integer, ENOSPC: integer, ENOSYS: integer, ENOTCONN: integer, ENOTDIR: integer, ENOTEMPTY: integer, ENOTSOCK: integer, ENOTSUP: integer, ENOTTY: integer, ENXIO: integer, EOF: integer, EOVERFLOW: integer, EPERM: integer, EPIPE: integer, EPROTO: integer, EPROTONOSUPPORT: integer, EPROTOTYPE: integer, ERANGE: integer, EREMOTEIO: integer, EROFS: integer, ESHUTDOWN: integer, ESOCKTNOSUPPORT: integer, ESPIPE: integer, ESRCH: integer, ETIMEDOUT: integer, ETXTBSY: integer, EXDEV: integer, UNKNOWN: integer}
---@section Error Handling

-- TODO: errno fields should have descriptions!

---
---A table value which exposes error constants as a map, where the key is the
---error name (without the `UV_` prefix) and its value is a negative number.
---See Libuv's "Error constants" page for further details.
---(https://docs.libuv.org/en/v1.x/errors.html#error-constants)
---
---@type uv.errno
uv.errno = {}



---
---@section Version Checking
---

---
---Returns the libuv version packed into a single integer. 8 bits are used for each
---component, with the patch number stored in the 8 least significant bits. For
---example, this would be 0x010203 in libuv 1.2.3.
---
---@return integer
---@nodiscard
function uv.version() end

---
---Returns the libuv version number as a string. For example, this would be "1.2.3"
---in libuv 1.2.3. For non-release versions, the version suffix is included.
---
---@return string
---@nodiscard
function uv.version_string() end



---
---The event loop is the central part of libuv's functionality. It takes care of
-- polling for I/O and scheduling callbacks to be run based on different sources of events.
---
---In luv, there is an implicit uv loop for every Lua state that loads the library.
---You can use this library in an multi-threaded environment as long as each thread
---has it's own Lua state with its corresponding own uv loop. This loop is not
---directly exposed to users in the Lua module.
---
---@class uv_loop_t: userdata
---@section Event loop
local uv_loop_t = {}

---@alias uv.aliases.run_mode
---Runs the event loop until there are no more active and referenced handles or requests.
---Returns `true` if `uv.stop()` was called and there are still active handles or requests.
---Returns `false` in all other cases.
---|>'default'
---Poll for I/O once. Note that this function blocks if there are no
---pending callbacks. Returns `false` when done (no active handles or requests
---left), or `true` if more callbacks are expected (meaning you should run the
---event loop again sometime in the future).
---|'once'
---Poll for I/O once but don't block if there are no pending callbacks.
---Returns `false` if done (no active handles or requests left),
---or `true` if more callbacks are expected (meaning you should run the event loop again sometime in the future).
---|'nowait'

---@alias uv.aliases.loop_configure_option
---Block a signal when polling for new events.
---The second argument to loop_configure() is the signal name (as a lowercase string) or the signal number.
---This operation is currently only implemented for `"sigprof"` signals, to suppress unnecessary wakeups when using a sampling profiler.
---Requesting other signals will fail with `EINVAL`.
---|'block_signal'
---Accumulate the amount of idle time the event loop spends in the event provider.
---This option is necessary to use `metrics_idle_time()`.
---|'metrics_idle_time'

---
---Closes all internal loop resources. In normal execution, the loop will
---automatically be closed when it is garbage collected by Lua, so it is not
---necessary to explicitly call `loop_close()`. Call this function only after the
---loop has finished executing and all open handles and requests have been closed,
---or it will return `EBUSY`.
---
---@return 0|nil success, string? err_name, string? err_msg
function uv.loop_close() end

---
---This function runs the event loop. It will act differently depending on the
---specified mode:
---- `"default"`: Runs the event loop until there are no more active and
---referenced handles or requests. Returns `true` if `uv.stop()` was called and
---there are still active handles or requests. Returns `false` in all other
---cases.
---- `"once"`: Poll for I/O once. Note that this function blocks if there are no
---pending callbacks. Returns `false` when done (no active handles or requests
---left), or `true` if more callbacks are expected (meaning you should run the
---event loop again sometime in the future).
---- `"nowait"`: Poll for I/O once but don't block if there are no pending
---callbacks. Returns `false` if done (no active handles or requests left),
---or `true` if more callbacks are expected (meaning you should run the event
---loop again sometime in the future).
---
---**Note**: Luvit will implicitly call `uv.run()` after loading user code, but if
---you use the luv bindings directly, you need to call this after registering
---your initial set of event callbacks to start the event loop.
---
---@param mode uv.aliases.run_mode|nil
---@return boolean|nil, string? err_name, string? err_msg
function uv.run(mode) end

---
---Set additional loop options. You should normally call this before the first call
---to uv_run() unless mentioned otherwise.
---Supported options:
---- `"block_signal"`: Block a signal when polling for new events. The second argument
---to loop_configure() is the signal name (as a lowercase string) or the signal number.
---This operation is currently only implemented for `"sigprof"` signals, to suppress
---unnecessary wakeups when using a sampling profiler. Requesting other signals will
---fail with `EINVAL`.
---- `"metrics_idle_time"`: Accumulate the amount of idle time the event loop spends
---in the event provider. This option is necessary to use `metrics_idle_time()`.
---An example of a valid call to this function is:
---```lua
---uv.loop_configure("block_signal", "sigprof")
---```
---
---**Note**: Be prepared to handle the `ENOSYS` error; it means the loop option is
---not supported by the platform.
---
---@param option uv.aliases.loop_configure_option
---@param ... any
---@return 0|nil success, string? err_name, string? err_msg
function uv.loop_configure(option, ...) end

---
---If the loop is running, returns a string indicating the mode in use. If the loop
---is not running, `nil` is returned instead.
---
---@return uv.aliases.run_mode|nil
---@nodiscard
function uv.loop_mode() end

---
---Returns `true` if there are referenced active handles, active requests, or
---closing handles in the loop; otherwise, `false`.
---
---@return boolean|nil, string? err_name, string? err_msg
---@nodiscard
function uv.loop_alive() end

---
---Stop the event loop, causing `uv.run()` to end as soon as possible. This
---will happen not sooner than the next loop iteration. If this function was called
---before blocking for I/O, the loop won't block for I/O on this iteration.
---
function uv.stop() end

---
---Get backend file descriptor. Only kqueue, epoll, and event ports are supported.
---This can be used in conjunction with `uv.run("nowait")` to poll in one thread
---and run the event loop's callbacks in another
---
---**Note**: Embedding a kqueue fd in another kqueue pollset doesn't work on all
---platforms. It's not an error to add the fd but it never generates events.
---
---@return integer|nil
---@nodiscard
function uv.backend_fd() end

---
---Get the poll timeout. The return value is in milliseconds, or -1 for no timeout.
---
---@return integer
---@nodiscard
function uv.backend_timeout() end

---
---Returns the current timestamp in milliseconds. The timestamp is cached at the
---start of the event loop tick, see `uv.update_time()` for details and rationale.
---The timestamp increases monotonically from some arbitrary point in time. Don't
---make assumptions about the starting point, you will only get disappointed.
---
---**Note**: Use `uv.hrtime()` if you need sub-millisecond granularity.
---
---@return integer
---@nodiscard
function uv.now() end

---
---Update the event loop's concept of "now". Libuv caches the current time at the
---start of the event loop tick in order to reduce the number of time-related
---system calls.
---You won't normally need to call this function unless you have callbacks that
---block the event loop for longer periods of time, where "longer" is somewhat
---subjective but probably on the order of a millisecond or more.
---
function uv.update_time() end

---
---Walk the list of handles: `callback` will be executed with each handle.
---
---Example usage of uv.walk to close all handles that aren't already closing.
---```lua
---uv.walk(function (handle)
---  if not handle:is_closing() then
---    handle:close()
---  end
---end)
---```
---
---@param callback fun(handle: uv.aliases.handle_instances)
function uv.walk(callback) end



---
---`uv_req_t` is the base type for all libuv request types.
---
---@class uv_req_t: userdata
---@section Base request
local uv_req_t = {}

---@alias uv.aliases.req_struct_name
---|'unknown'     0
---|'req'         1
---|'connect'     2
---|'write'       3
---|'shutdown'    4
---|'udp_send'    5
---|'fs'          6
---|'work'        7
---|'getaddrinfo' 8
---|'getnameinfo' 9
---|'random'      10

---@alias uv.aliases.req_struct_type
---|0   unknown
---|1   req
---|2   connect
---|3   write
---|4   shutdown
---|5   udp_send
---|6   fs
---|7   work
---|8   getaddrinfo
---|9   getnameinfo
---|10  random

---
---Cancel a pending request. Fails if the request is executing or has finished
---executing. Only cancellation of `uv_fs_t`, `uv_getaddrinfo_t`,
---`uv_getnameinfo_t` and `uv_work_t` requests is currently supported.
---
---@param req uv_fs_t|uv_getaddrinfo_t|uv_getnameinfo_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.cancel(req) end
uv_req_t.cancel = uv.cancel

---
---Returns the name of the struct for a given request (e.g. `"fs"` for `uv_fs_t`)
---and the libuv enum integer for the request's type (`uv_req_type`).
---
---@param req uv_req_t
---@return uv.aliases.req_struct_name
---@return uv.aliases.req_struct_type
function uv.req_get_type(req) end
uv_req_t.get_type = uv.req_get_type



---
---`uv_handle_t` is the base type for all libuv handle types. All API functions
---defined here work with any handle type.
---
---@class uv_handle_t: userdata
---@section Base handle
local uv_handle_t = {}

---@alias uv.aliases.handle_instances
---|uv_handle_t
---|uv_stream_t
---|uv_tcp_t
---|uv_pipe_t
---|uv_tty_t
---|uv_udp_t
---|uv_fs_event_t
---|uv_fs_poll_t

---@alias uv.aliases.handle_struct_name
---|'unknown'   0
---|'"async"'   1
---|'check'     2
---|'fs_event'  3
---|'fs_poll'   4
---|'handle'    5
---|'idle'      6
---|'pipe'      7
---|'poll'      8
---|'prepare'   9
---|'process'   10
---|'stream'    11
---|'tcp'       12
---|'timer'     13
---|'tty'       14
---|'udp'       15
---|'signal'    16
---|'file'      17

---@alias uv.aliases.handle_struct_type
---|0   unknown
---|1   async
---|2   check
---|3   fs_event
---|4   fs_poll
---|5   handle
---|6   idle
---|7   pipe
---|8   poll
---|9   prepare
---|10  process
---|11  stream
---|12  tcp
---|13  timer
---|14  tty
---|15  udp
---|16  signal
---|17  file

---
---Returns `true` if the handle is active, `false` if it's inactive. What "active”
---means depends on the type of handle:
---
--- - A `uv_async_t` handle is always active and cannot be deactivated, except
--- by closing it with `uv.close()`.
---
--- - A `uv_pipe_t`, `uv_tcp_t`, `uv_udp_t`, etc. handle - basically
--- any handle that deals with I/O - is active when it is doing something that
--- involves I/O, like reading, writing, connecting, accepting new connections,
--- etc.
---
--- - A `uv_check_t`, `uv_idle_t`, `uv_timer_t`, etc. handle is active
--- when it has been started with a call to `uv.check_start()`, `uv.idle_start()`,
--- `uv.timer_start()` etc. until it has been stopped with a call to its
--- respective stop function.
---
---@param handle uv_handle_t # `userdata` for sub-type of `uv_handle_t`
---@return boolean|nil, string? err_name, string? err_msg
---@nodiscard
function uv.is_active(handle) end
uv_handle_t.is_active = uv.is_active

---
---Returns `true` if the handle is closing or closed, `false` otherwise.
---
---**Note**: This function should only be used between the initialization of the
---handle and the arrival of the close callback.
---
---@param handle uv_handle_t # `userdata` for sub-type of `uv_handle_t`
---@return boolean|nil, string? err_name, string? err_msg
---@nodiscard
function uv.is_closing(handle) end
uv_handle_t.is_closing = uv.is_closing

---
---Request handle to be closed. `callback` will be called asynchronously after this
---call. This MUST be called on each handle before memory is released.
---
---Handles that wrap file descriptors are closed immediately but `callback` will
---still be deferred to the next iteration of the event loop. It gives you a chance
---to free up any resources associated with the handle.
---
---In-progress requests, like `uv_connect_t` or `uv_write_t`, are cancelled and
---have their callbacks called asynchronously with `ECANCELED`.
---
---@param handle uv_handle_t # `userdata` for sub-type of `uv_handle_t`
---@param callback? function
function uv.close(handle, callback) end
uv_handle_t.close = uv.close

---
---Reference the given handle. References are idempotent, that is, if a handle is
---already referenced calling this function again will have no effect.
---
---@param handle uv_handle_t # `userdata` for sub-type of `uv_handle_t`
function uv.ref(handle) end
uv_handle_t.ref = uv.ref

---
---Un-reference the given handle. References are idempotent, that is, if a handle
---is not referenced calling this function again will have no effect.
---
---@param handle uv_handle_t # `userdata` for sub-type of `uv_handle_t`
function uv.unref(handle) end
uv_handle_t.unref = uv.unref

---
---Returns `true` if the handle referenced, `false` if not.
---
---@param handle uv_handle_t # `userdata` for sub-type of `uv_handle_t`
---@return boolean|nil, string? err_name, string? err_msg
---@nodiscard
function uv.has_ref(handle) end
uv_handle_t.has_ref = uv.has_ref

---
---Gets or sets the size of the send buffer that the operating system uses for the socket.
---
---If `size` is omitted (or `0`), this will return the current send buffer size; otherwise, this will use `size` to set the new send buffer size.
---
---This function works for TCP, pipe and UDP handles on Unix and for TCP and UDP
---handles on Windows.
---
---**Note**: Linux will set double the size and return double the size of the
---original set value.
---
---@param handle uv_handle_t # `userdata` for sub-type of `uv_handle_t`
---@return integer|nil, string? err_name, string? err_msg
---@nodiscard
function uv.send_buffer_size(handle) end
---@param size? integer # (default: `0`)
---@return 0|nil, string? err_name, string? err_msg
function uv.send_buffer_size(handle, size) end
uv_handle_t.send_buffer_size = uv.send_buffer_size

---
---Gets or sets the size of the receive buffer that the operating system uses for the socket.
---
---If `size` is omitted (or `0`), this will return the current send buffer size; otherwise, this will use `size` to set the new send buffer size.
---
---This function works for TCP, pipe and UDP handles on Unix and for TCP and UDP
---handles on Windows.
---
---**Note**: Linux will set double the size and return double the size of the
---original set value.
---
---@param handle uv_handle_t `userdata` for sub-type of `uv_handle_t`
---@return integer|nil, string? err_name, string? err_msg
---@nodiscard
function uv.recv_buffer_size(handle) end
---@param size? integer # (default: `0`)
---@return 0|nil, string? err_name, string? err_msg
function uv.recv_buffer_size(handle, size) end
uv_handle_t.recv_buffer_size = uv.recv_buffer_size

---
---Gets the platform dependent file descriptor equivalent.
---
---The following handles are supported: TCP, pipes, TTY, UDP and poll. Passing any
---other handle type will fail with `EINVAL`.
---
---If a handle doesn't have an attached file descriptor yet or the handle itself
---has been closed, this function will return `EBADF`.
---
---**Warning**: Be very careful when using this function. libuv assumes it's in
---control of the file descriptor so any change to it may lead to malfunction.
---
---@param handle uv_handle_t `userdata` for sub-type of `uv_handle_t`
---@return integer|nil, string? err_name, string? err_msg
---@nodiscard
function uv.fileno(handle) end
uv_handle_t.fileno = uv.fileno

---
---Returns the name of the struct for a given handle (e.g. `"pipe"` for `uv_pipe_t`)
---and the libuv enum integer for the handle's type (`uv_handle_type`).
---
---@param handle uv_handle_t # `userdata` for sub-type of `uv_handle_t`
---@return uv.aliases.handle_struct_name
---@return uv.aliases.handle_struct_type
function uv.handle_get_type(handle) end
uv_handle_t.get_type = uv.handle_get_type



---
---@section Reference counting
---
---The libuv event loop (if run in the default mode) will run until there are no
---active and referenced handles left. The user can force the loop to exit early by
---unreferencing handles which are active, for example by calling `uv.unref()`
---after calling `uv.timer_start()`.
---
---A handle can be referenced or unreferenced, the refcounting scheme doesn't use a
---counter, so both operations are idempotent.
---
---All handles are referenced when active by default, see `uv.is_active()` for a
---more detailed explanation on what being active involves.
---



---
---Timer handles are used to schedule callbacks to be called in the future.
---
---@class uv_timer_t: uv_handle_t
---@section Timer handle
local uv_timer_t = {}

---
---Creates and initializes a new `uv_timer_t`. Returns the Lua userdata wrapping it.
---
---Some examples:
---```lua
----- Creating a simple setTimeout wrapper
---local function setTimeout(timeout, callback)
---  local timer = uv.new_timer()
---  timer:start(timeout, 0, function ()
---    timer:stop()
---    timer:close()
---    callback()
---  end)
---  return timer
---end
---
----- Creating a simple setInterval wrapper
---local function setInterval(interval, callback)
---  local timer = uv.new_timer()
---  timer:start(interval, interval, function ()
---    callback()
---  end)
---  return timer
---end
---
----- And clearInterval
---local function clearInterval(timer)
---  timer:stop()
---  timer:close()
---end
---```
---
---@return uv_timer_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_timer() end

-- TODO: make sure that the above method can indeed return nil + error.

---
---Start the timer. `timeout` and `repeat_n` are in milliseconds.
---
---If `timeout` is zero, the callback fires on the next event loop iteration. If
---`repeat_n` is non-zero, the callback fires first after `timeout` milliseconds and
---then repeatedly after `repeat_n` milliseconds.
---
---@param timer uv_timer_t
---@param timeout integer
---@param repeat_n integer
---@param callback fun()
---@return 0|nil success, string? err_name, string? err_msg
function uv.timer_start(timer, timeout, repeat_n, callback) end
uv_timer_t.start = uv.timer_start

---
---Stop the timer, the callback will not be called anymore.
---
---@param timer uv_timer_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.timer_stop(timer) end
uv_timer_t.stop = uv.timer_stop

---
---Stop the timer, and if it is repeating restart it using the repeat value as the
---timeout. If the timer has never been started before it raises `EINVAL`.
---
---@param timer uv_timer_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.timer_again(timer) end
uv_timer_t.again = uv.timer_again

---
---Set the repeat interval value in milliseconds. The timer will be scheduled to
---run on the given interval, regardless of the callback execution duration, and
---will follow normal timer semantics in the case of a time-slice overrun.
---
---For example, if a 50 ms repeating timer first runs for 17 ms, it will be
---scheduled to run again 33 ms later. If other tasks consume more than the 33 ms
---following the first timer callback, then the callback will run as soon as
---possible.
---
---@param timer uv_timer_t
---@param repeat_n integer
function uv.timer_set_repeat(timer, repeat_n) end
uv_timer_t.set_repeat = uv.timer_set_repeat

---
---Get the timer repeat value.
---
---@param timer uv_timer_t
---@return integer
---@nodiscard
function uv.timer_get_repeat(timer) end
uv_timer_t.get_repeat = uv.timer_get_repeat

---
---Get the timer due value or 0 if it has expired. The time is relative to `uv.now()`.
---
---**Note**: New in libuv version 1.40.0.
---
---@param timer uv_timer_t
---@return integer
---@nodiscard
function uv.timer_get_due_in(timer) end
uv_timer_t.get_due_in = uv.timer_get_due_in



---
---Prepare handles will run the given callback once per loop iteration, right
---before polling for I/O.
---
---```lua
---local prepare = uv.new_prepare()
---prepare:start(function()
---  print("Before I/O polling")
---end)
---```
---
---@class uv_prepare_t: uv_handle_t
---@section Prepare handle
local uv_prepare_t = {}

---
---Creates and initializes a new `uv_prepare_t`.
---Returns the Lua userdata wrapping it.
---
---@return uv_prepare_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_prepare() end

-- TODO: make sure that the above method can indeed return nil + error.

---
---Start the handle with the given callback.
---
---@param prepare uv_prepare_t
---@param callback fun()
---@return 0|nil success, string? err_name, string? err_msg
function uv.prepare_start(prepare, callback) end
uv_prepare_t.start = uv.prepare_start

---
---Stop the handle, the callback will no longer be called.
---
---@param prepare uv_prepare_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.prepare_stop(prepare) end
uv_prepare_t.stop = uv.prepare_stop


---
---Check handles will run the given callback once per loop iteration, right after
---polling for I/O.
---
---```lua
---local check = uv.new_check()
---check:start(function()
---  print("After I/O polling")
---end)
---```
---
---@class uv_check_t: uv_handle_t
---@section Check handle
local uv_check_t = {}

---
---Creates and initializes a new `uv_check_t`. Returns the Lua userdata wrapping it.
---
---@return uv_check_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_check() end

-- TODO: make sure that the above method can indeed return nil + error.

---
---Start the handle with the given callback.
---
---@param check uv_check_t
---@param callback fun()
---@return 0|nil success, string? err_name, string? err_msg
function uv.check_start(check, callback) end
uv_check_t.start = uv.check_start

---
---Stop the handle, the callback will no longer be called.
---
---@param check uv_check_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.check_stop(check) end
uv_check_t.stop = uv.check_stop



---
---Idle handles will run the given callback once per loop iteration, right before
---the `uv_prepare_t` handles.
---
---**Note**: The notable difference with prepare handles is that when there are
---active idle handles, the loop will perform a zero timeout poll instead of
---blocking for I/O.
---
---**Warning**: Despite the name, idle handles will get their callbacks called on
---every loop iteration, not when the loop is actually "idle".
---
---```lua
---local idle = uv.new_idle()
---idle:start(function()
---  print("Before I/O polling, no blocking")
---end)
---```
---
---@class uv_idle_t: uv_handle_t
---@section Idle handle
local uv_idle_t = {}

---
---Creates and initializes a new `uv_idle_t`. Returns the Lua userdata wrapping it.
---
---@return uv_idle_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_idle() end

-- TODO: make sure that the above method can indeed return nil + error.

---
---Start the handle with the given callback.
---
---@param idle uv_idle_t
---@param callback fun()
---@return 0|nil success, string? err_name, string? err_msg
function uv.idle_start(idle, callback) end
uv_idle_t.start = uv.idle_start

---
---Stop the handle, the callback will no longer be called.
---
---@param idle uv_idle_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.idle_stop(idle) end
uv_idle_t.stop = uv.idle_stop



---
---Async handles allow the user to "wakeup" the event loop and get a callback
---called from another thread.
---
---```lua
---local async
---async = uv.new_async(function()
---  print("async operation ran")
---  async:close()
---end)
---
---async:send()
---```
---
---@class uv_async_t: uv_handle_t
---@section Async handle
local uv_async_t = {}

---
---Creates and initializes a new `uv_async_t`. Returns the Lua userdata wrapping
---it. A `nil` callback is allowed.
---
---**Note**: Unlike other handle initialization functions, this immediately starts
---the handle.
---
---@param callback fun(...: uv.aliases.threadargs)|nil
---@return uv_async_t|nil handle, string? err_name, string? err_msg
---@nodiscard
function uv.new_async(callback) end

-- TODO: make sure that the above method can indeed return nil + error.

---
---Wakeup the event loop and call the async handle's callback.
---
---**Note**: It's safe to call this function from any thread. The callback will be
---called on the loop thread.
---
---**Warning**: libuv will coalesce calls to `uv.async_send(async)`, that is, not
---every call to it will yield an execution of the callback. For example: if
---`uv.async_send()` is called 5 times in a row before the callback is called, the
---callback will only be called once. If `uv.async_send()` is called again after
---the callback was called, it will be called again.
---
---@param async uv_async_t
---@param ... uv.aliases.threadargs
---@return 0|nil success, string? err_name, string? err_msg
function uv.async_send(async, ...) end
uv_async_t.send = uv.async_send



---
---Poll handles are used to watch file descriptors for readability and writability,
---similar to the purpose of [poll(2)](http://linux.die.net/man/2/poll).
---
---The purpose of poll handles is to enable integrating external libraries that
---rely on the event loop to signal it about the socket status changes, like c-ares
---or libssh2. Using `uv_poll_t` for any other purpose is not recommended;
---`uv_tcp_t`, `uv_udp_t`, etc. provide an implementation that is faster and more
---scalable than what can be achieved with `uv_poll_t`, especially on Windows.
---
---It is possible that poll handles occasionally signal that a file descriptor is
---readable or writable even when it isn't. The user should therefore always be
---prepared to handle EAGAIN or equivalent when it attempts to read from or write
---to the fd.
---
---It is not okay to have multiple active poll handles for the same socket, this
---can cause libuv to busyloop or otherwise malfunction.
---
---The user should not close a file descriptor while it is being polled by an
---active poll handle. This can cause the handle to report an error, but it might
---also start polling another socket. However the fd can be safely closed
---immediately after a call to `uv.poll_stop()` or `uv.close()`.
---
---**Note**: On windows only sockets can be polled with poll handles. On Unix any
---file descriptor that would be accepted by poll(2) can be used.
---
---@class uv_poll_t: uv_handle_t
---@section Poll handle
local uv_poll_t = {}

---@alias uv.aliases.poll_events
---|'"r"'
---|'"w"'
---|>'"rw"'
---|'"d"'
---|'"rd"'
---|'"wd"'
---|'"rwd"'
---|'"p"'
---|'"rp"'
---|'"wp"'
---|'"rwp"'
---|'"dp"'
---|'"rdp"'
---|'"wdp"'
---|'"rwdp"'

---
---Initialize the handle using a file descriptor.
---The file descriptor is set to non-blocking mode.
---
---@param fd integer # the file descriptor
---@return uv_poll_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_poll(fd) end

---
---Initialize the handle using a socket descriptor. On Unix this is identical to
---`uv.new_poll()`. On windows it takes a SOCKET handle.
---The socket is set to non-blocking mode.
---
---@param fd integer # the file descriptor
---@return uv_poll_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_socket_poll(fd) end

---
---Starts polling the file descriptor.
---See alias below for accepted `events`, where `r` is `READABLE`, `w` is `WRITABLE`, `d` is
---`DISCONNECT`, and `p` is `PRIORITIZED`.
---As soon as an event is detected
---the callback will be called with status set to 0, and the detected events set on
---the events field.
---
---The user should not close the socket while the handle is active. If the user
---does that anyway, the callback may be called reporting an error status, but this
---is not guaranteed.
---
---**Note** Calling `uv.poll_start()` on a handle that is already active is fine.
---Doing so will update the events mask that is being watched for.
---
---@param poll uv_poll_t
---@param events uv.aliases.poll_events|nil # (default: `"rw"`)
---@param callback fun(err?: string, events?: uv.aliases.poll_events)
---@return 0|nil success, string? err_name, string? err_msg
function uv.poll_start(poll, events, callback) end
uv_poll_t.start = uv.poll_start

---
---Stop polling the file descriptor, the callback will no longer be called.
---
---@param poll uv_poll_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.poll_stop(poll) end
uv_poll_t.stop = uv.poll_stop



---
---Signal handles implement Unix style signal handling on a per-event loop bases.
---
---**Windows Notes:**
---
---Reception of some signals is emulated on Windows:
---  - SIGINT is normally delivered when the user presses CTRL+C. However, like on
---  Unix, it is not generated when terminal raw mode is enabled.
---  - SIGBREAK is delivered when the user pressed CTRL + BREAK.
---  - SIGHUP is generated when the user closes the console window. On SIGHUP the
---  program is given approximately 10 seconds to perform cleanup. After that
---  Windows will unconditionally terminate it.
---  - SIGWINCH is raised whenever libuv detects that the console has been resized.
---  SIGWINCH is emulated by libuv when the program uses a uv_tty_t handle to write
---  to the console. SIGWINCH may not always be delivered in a timely manner; libuv
---  will only detect size changes when the cursor is being moved. When a readable
---  [`uv_tty_t`][] handle is used in raw mode, resizing the console buffer will
---  also trigger a SIGWINCH signal.
---  - Watchers for other signals can be successfully created, but these signals
---  are never received. These signals are: SIGILL, SIGABRT, SIGFPE, SIGSEGV,
---  SIGTERM and SIGKILL.
---  - Calls to raise() or abort() to programmatically raise a signal are not
---  detected by libuv; these will not trigger a signal watcher.
---
---**Unix Notes:**
---
---  - SIGKILL and SIGSTOP are impossible to catch.
---  - Handling SIGBUS, SIGFPE, SIGILL or SIGSEGV via libuv results into undefined
---  behavior.
---  - SIGABRT will not be caught by libuv if generated by abort(), e.g. through
---  assert().
---  - On Linux SIGRT0 and SIGRT1 (signals 32 and 33) are used by the NPTL pthreads
---  library to manage threads. Installing watchers for those signals will lead to
---  unpredictable behavior and is strongly discouraged. Future versions of libuv
---  may simply reject them.
---
---```lua
----- Create a new signal handler
---local signal = uv.new_signal()
----- Define a handler function
---uv.signal_start(signal, "sigint", function(signal)
---  print("got " .. signal .. ", shutting down")
---  os.exit(1)
---end)
---```
---
---@class uv_signal_t: uv_handle_t
---@section Signal handle
local uv_signal_t = {}

---@alias uv.aliases.signals
---| "sigabrt"    Abort signal from abort(3)
---| "sigalrm"    Timer signal from alarm(2)
---| "sigbus"     Bus error (bad memory access)
---| "sigchld"    Child stopped or terminated
---| "sigcont"    Continue if stopped
---| "sigfpe"     Floating-point exception
---| "sighup"     Hangup detected on controlling terminal or death of controlling process
---| "sigill"     Illegal Instruction
---| "sigint"     Interrupt from keyboard
---| "sigio"      I/O now possible (4.2BSD)
---| "sigiot"     IOT trap. A synonym for sigabrt
---| "sigkill"    Kill signal
---| "sigpipe"    Broken pipe: write to pipe with no readers; see pipe(7)
---| "sigpoll"    Pollable event (Sys V); synonym for sigIO
---| "sigprof"    Profiling timer expired
---| "sigpwr"     Power failure (System V)
---| "sigquit"    Quit from keyboard
---| "sigsegv"    Invalid memory reference
---| "sigstkflt"  Stack fault on coprocessor
---| "sigstop"    Stop process
---| "sigtstp"    Stop typed at terminal
---| "sigsys"     Bad system call (SVr4); see also seccomp(2)
---| "sigterm"    Termination signal
---| "sigtrap"    Trace/breakpoint trap
---| "sigttin"    Terminal input for background process
---| "sigttou"    Terminal output for background process
---| "sigurg"     Urgent condition on socket (4.2BSD)
---| "sigusr1"    User-defined signal 1
---| "sigusr2"    User-defined signal 2
---| "sigvtalrm"  Virtual alarm clock (4.2BSD)
---| "sigxcpu"    CPU time limit exceeded (4.2BSD); see setrlimit(2)
---| "sigxfsz"    File size limit exceeded (4.2BSD);see setrlimit(2)
---| "sigwinch"   Window resize signal (4.3BSD, Sun)
---| "sigbreak"   CTRL + BREAK has been pressed
---| "siglost"    File lock lost

---
---Creates and initializes a new `uv_signal_t`.
---Returns the Lua userdata wrapping it.
---
---@return uv_signal_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_signal() end

-- TODO: make sure that the above method can indeed return nil + error.

---
---Start the handle with the given callback, watching for the given signal.
---
---@param signal uv_signal_t
---@param signum integer|uv.aliases.signals
---@param callback? fun(signum: uv.aliases.signals)
---@return 0|nil success, string? err_name, string? err_msg
function uv.signal_start(signal, signum, callback) end
uv_signal_t.start = uv.signal_start

---
---Same functionality as `uv.signal_start()` but the signal handler is reset the moment the signal is received.
---
---@param signal uv_signal_t
---@param signum integer|uv.aliases.signals
---@param callback? fun(signum: uv.aliases.signals)
---@return 0|nil success, string? err_name, string? err_msg
function uv.signal_start_oneshot(signal, signum, callback) end
uv_signal_t.start_oneshot = uv.signal_start_oneshot

---
---Stop the handle, the callback will no longer be called.
---
---@param signal uv_signal_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.signal_stop(signal) end
uv_signal_t.stop = uv.signal_stop



---
---Process handles will spawn a new process and allow the user to control it and
---establish communication channels with it using streams.
---
---@class uv_process_t: uv_handle_t
---@section Process handle
local uv_process_t = {}

---@alias uv.aliases.spawn_options {args?: string[], stdio?: table<integer, integer|uv_stream_t|nil>, env?: table<string, any>, cwd?: string, uid?: integer, gid?: integer, verbatim?: boolean, detached?: boolean, hide?: boolean}

-- TODO: add descriptions to above fields

---
---Disables inheritance for file descriptors / handles that this process inherited
---from its parent. The effect is that child processes spawned by this process
---don't accidentally inherit these handles.
---It is recommended to call this function as early in your program as possible,
---before the inherited file descriptors can be closed or duplicated.
---
---**Note:** This function works on a best-effort basis: there is no guarantee that
---libuv can discover all file descriptors that were inherited. In general it does
---a better job on Windows than it does on Unix.
---
function uv.disable_stdio_inheritance() end

---
---Initializes the process handle and starts the process. If the process is
---successfully spawned, this function will return the handle and pid of the child
---process.
---Possible reasons for failing to spawn would include (but not be limited to) the
---file to execute not existing, not having permissions to use the setuid or setgid
---specified, or not having enough memory to allocate for the new process.
---
---```lua
---local stdin = uv.new_pipe()
---local stdout = uv.new_pipe()
---local stderr = uv.new_pipe()
---
---print("stdin", stdin)
---print("stdout", stdout)
---print("stderr", stderr)
---
---local handle, pid = uv.spawn("cat", {
---   stdio = {stdin, stdout, stderr}
---}, function(code, signal) -- on exit
---   print("exit code", code)
---   print("exit signal", signal)
---end)
---
---print("process opened", handle, pid)
---
---uv.read_start(stdout, function(err, data)
---   assert(not err, err)
---   if data then
---     print("stdout chunk", stdout, data)
---   else
---     print("stdout end", stdout)
---   end
---end)
---
---uv.read_start(stderr, function(err, data)
---   assert(not err, err)
---   if data then
---     print("stderr chunk", stderr, data)
---   else
---     print("stderr end", stderr)
---   end
---end)
---
---uv.write(stdin, "Hello World")
---
---uv.shutdown(stdin, function()
---   print("stdin shutdown", stdin)
---   uv.close(handle, function()
---     print("process closed", handle, pid)
---   end)
---end)
---```
---
---The `options` table accepts the following fields:
---
--- - `options.args` - Command line arguments as a list of string. The first
---string should be the path to the program. On Windows, this uses CreateProcess
---which concatenates the arguments into a string. This can cause some strange
---errors. (See `options.verbatim` below for Windows.)
---
--- - `options.stdio` - Set the file descriptors that will be made available to
---  the child process. The convention is that the first entries are stdin, stdout,
---  and stderr. (**Note**: On Windows, file descriptors after the third are
---  available to the child process only if the child processes uses the MSVCRT
---  runtime.)
---
--- - `options.env` - Set environment variables for the new process.
---
--- - `options.cwd` - Set the current working directory for the sub-process.
---
--- - `options.uid` - Set the child process' user id.
---
--- - `options.gid` - Set the child process' group id.
---
--- - `options.verbatim` - If true, do not wrap any arguments in quotes, or
---  perform any other escaping, when converting the argument list into a command
---  line string. This option is only meaningful on Windows systems. On Unix it is
---  silently ignored.
---
--- - `options.detached` - If true, spawn the child process in a detached state -
---  this will make it a process group leader, and will effectively enable the
---  child to keep running after the parent exits. Note that the child process
---  will still keep the parent's event loop alive unless the parent process calls
---  `uv.unref()` on the child's process handle.
---
--- - `options.hide` - If true, hide the subprocess console window that would
---  normally be created. This option is only meaningful on Windows systems. On
---  Unix it is silently ignored.
---The `options.stdio` entries can take many shapes.
---
---  - If they are numbers, then the child process inherits that same zero-indexed
---  fd from the parent process.
---
--- - If `uv_stream_t` handles are passed in, those are used as a read-write pipe
---  or inherited stream depending if the stream has a valid fd.
---
--- - Including `nil` placeholders means to ignore that fd in the child process.
---
---When the child process exits, `on_exit` is called with an exit code and signal.
---
---@param path string
---@param options uv.aliases.spawn_options
---@param on_exit fun(code: integer, signal: integer)?
---@return uv_process_t|nil, integer|string, string?
function uv.spawn(path, options, on_exit) end

---
---Sends the specified signal to the given process handle.
---
---@param process uv_process_t
---@param signum integer|uv.aliases.signals
---@return 0|nil success, string? err_name, string? err_msg
function uv.process_kill(process, signum) end
uv_process_t.kill = uv.process_kill

---
---Sends the specified signal to the given PID.
---
---@param pid integer
---@param signum integer|uv.aliases.signals
---@return 0|nil success, string? err_name, string? err_msg
function uv.kill(pid, signum) end

---
---Returns the handle's pid.
---
---@param process uv_process_t
---@return integer
---@nodiscard
function uv.process_get_pid(process) end
uv_process_t.get_pid = uv.process_get_pid



---
---Stream handles provide an abstraction of a duplex communication channel.
---`uv_stream_t` is an abstract type, libuv provides 3 stream implementations
---in the form of `uv_tcp_t`, `uv_pipe_t` and `uv_tty_t`.
---
---@class uv_stream_t: uv_handle_t
---@section Stream handle
local uv_stream_t = {}

---@class uv_shutdown_t: uv_req_t

---@class uv_write_t: uv_req_t

---
---Shutdown the outgoing (write) side of a duplex stream. It waits for pending
---write requests to complete. The callback is called after shutdown is complete.
---
---@param stream uv_stream_t
---@param callback fun(err?: string)|nil
---@return uv_shutdown_t|nil stream, string? err_name, string? err_msg
function uv.shutdown(stream, callback) end
uv_stream_t.shutdown = uv.shutdown

---
---Start listening for incoming connections. `backlog` indicates the number of
---connections the kernel might queue, same as `listen(2)`. When a new incoming
---connection is received the callback is called.
---
---@param stream uv_stream_t
---@param backlog integer
---@param callback fun(err?: string)
---@return 0|nil success, string? err_name, string? err_msg
function uv.listen(stream, backlog, callback) end
uv_stream_t.listen = uv.listen

---
---This call is used in conjunction with `uv.listen()` to accept incoming
---connections. Call this function after receiving a callback to accept the
---connection.
---
---When the connection callback is called it is guaranteed that this function
---will complete successfully the first time. If you attempt to use it more than
---once, it may fail. It is suggested to only call this function once per
---connection call.
---
---```lua
---server:listen(128, function (err)
---  local client = uv.new_tcp()
---  server:accept(client)
---end)
---```
---
---@param stream uv_stream_t
---@param client_stream uv_stream_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.accept(stream, client_stream) end
uv_stream_t.accept = uv.accept

---
---Read data from an incoming stream. The callback will be made several times until
---there is no more data to read or `uv.read_stop()` is called. When we've reached
---EOF, `data` will be `nil`.
---
---```lua
---stream:read_start(function (err, chunk)
---  if err then
---    -- handle read error
---  elseif chunk then
---    -- handle data
---  else
---    -- handle disconnect
---  end
---end)
---```
---
---@param stream uv_stream_t
---@param callback fun(err?: string, data?: string)
---@return 0|nil success, string? err_name, string? err_msg
function uv.read_start(stream, callback) end
uv_stream_t.read_start = uv.read_start

---
---Stop reading data from the stream. The read callback will no longer be called.
---This function is idempotent and may be safely called on a stopped stream.
---
---@param stream uv_stream_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.read_stop(stream) end
uv_stream_t.read_stop = uv.read_stop

---
---Write data to stream.
---`data` can either be a Lua string or a table of strings. If a table is passed
---in, the C backend will use writev to send all strings in a single system call.
---The optional `callback` is for knowing when the write is complete.
---
---@param stream uv_stream_t
---@param data uv.aliases.buffer
---@param callback fun(err?: string)|nil
---@return uv_write_t|nil stream, string? err_name, string? err_msg
function uv.write(stream, data, callback) end
uv_stream_t.write = uv.write

---
---Extended write function for sending handles over a pipe. The pipe must be
---initialized with `ipc` option `true`.
---
---**Note:** `send_handle` must be a TCP socket or pipe, which is a server or a
---connection (listening or connected state). Bound sockets or pipes will be
---assumed to be servers.
---
---@param stream uv_stream_t
---@param data uv.aliases.buffer
---@param send_handle uv_tcp_t|uv_pipe_t
---@param callback fun()|nil
---@return uv_write_t|nil stream, string? err_name, string? err_msg
function uv.write2(stream, data, send_handle, callback) end
uv_stream_t.write2 = uv.write2

---
---Same as `uv.write()`, but won't queue a write request if it can't be completed
---immediately.
---Will return number of bytes written (can be less than the supplied buffer size).
---
---@param stream uv_stream_t
---@param data uv.aliases.buffer
---@return integer|nil, string? err_name, string? err_msg
function uv.try_write(stream, data) end
uv_stream_t.try_write = uv.try_write

---
---Like `uv.write2()`, but with the properties of `uv.try_write()`. Not supported on Windows, where it returns `UV_EAGAIN`.
---Will return number of bytes written (can be less than the supplied buffer size).
---
---@param stream uv_stream_t
---@param data uv.aliases.buffer
---@param send_handle uv_tcp_t|uv_pipe_t
---@return integer|nil, string? err_name, string? err_msg
function uv.try_write2(stream, data, send_handle) end
uv_stream_t.try_write2 = uv.try_write2

---
---Returns `true` if the stream is readable, `false` otherwise.
---
---@param stream uv_stream_t
---@return boolean
---@nodiscard
function uv.is_readable(stream) end
uv_stream_t.is_readable = uv.is_readable

---
---Returns `true` if the stream is writable, `false` otherwise.
---
---@param stream uv_stream_t
---@return boolean
---@nodiscard
function uv.is_writable(stream) end
uv_stream_t.is_writable = uv.is_writable

---
---Enable or disable blocking mode for a stream.
---When blocking mode is enabled all writes complete synchronously. The interface
---remains unchanged otherwise, e.g. completion or failure of the operation will
---still be reported through a callback which is made asynchronously.
---
---**Warning**: Relying too much on this API is not recommended. It is likely to
---change significantly in the future. Currently this only works on Windows and
---only for `uv_pipe_t` handles. Also libuv currently makes no ordering guarantee
---when the blocking mode is changed after write requests have already been
---submitted. Therefore it is recommended to set the blocking mode immediately
---after opening or creating the stream.
---
---@param stream uv_stream_t
---@param blocking boolean
---@return 0|nil success, string? err_name, string? err_msg
function uv.stream_set_blocking(stream, blocking) end
uv_stream_t.set_blocking = uv.stream_set_blocking

---
---Returns the stream's write queue size.
---
---@return integer
---@nodiscard
function uv.stream_get_write_queue_size() end
uv_stream_t.get_write_queue_size = uv.stream_get_write_queue_size



---
---TCP handles are used to represent both TCP streams and servers.
---
---@class uv_tcp_t: uv_stream_t
---@section TCP handle
local uv_tcp_t = {}

---@class uv_connect_t: uv_req_t

---@alias uv.aliases.network_family
---|'"unix"'
---|'"inet"'
---|'"inet6"'
---|'"ipx"'
---|'"netlink"'
---|'"x25"'
---|'"ax25"'
---|'"atmpvc"'
---|'"appletalk"'
---|'"packet"'

---@alias uv.aliases.network_protocols
---|'"ip"'         # internet protocol, pseudo protocol number
---|'"hopopt"'     # hop-by-hop options for ipv6
---|'"icmp"'       # internet control message protocol
---|'"igmp"'       # internet group management protocol
---|'"ggp"'        # gateway-gateway protocol
---|'"ipv4"'       # IPv4 encapsulation
---|'"st"'         # ST datagram mode
---|'"tcp"'        # transmission control protocol
---|'"cbt"'        # CBT, Tony Ballardie <A.Ballardie@cs.ucl.ac.uk>
---|'"egp"'        # exterior gateway protocol
---|'"igp"'        # any private interior gateway (Cisco: for IGRP)
---|'"bbn-rcc"'    # BBN RCC Monitoring
---|'"nvp"'        # Network Voice Protocol
---|'"pup"'        # PARC universal packet protocol
---|'"argus"'      # ARGUS (deprecated)
---|'"emcon"'      # EMCON
---|'"xnet"'       # Cross Net Debugger
---|'"chaos"'      # Chaos
---|'"udp"'        # user datagram protocol
---|'"mux"'        # Multiplexing protocol
---|'"dcn"'        # DCN Measurement Subsystems
---|'"hmp"'        # host monitoring protocol
---|'"prm"'        # packet radio measurement protocol
---|'"xns-idp"'    # Xerox NS IDP
---|'"trunk-1"'    # Trunk-1
---|'"trunk-2"'    # Trunk-2
---|'"leaf-1"'     # Leaf-1
---|'"leaf-2"'     # Leaf-2
---|'"rdp"'        # "reliable datagram" protocol
---|'"irtp"'       # Internet Reliable Transaction Protocol
---|'"iso-tp4"'    # ISO Transport Protocol Class 4
---|'"netblt"'     # Bulk Data Transfer Protocol
---|'"mfe-nsp"'    # MFE Network Services Protocol
---|'"merit-inp"'  # MERIT Internodal Protocol
---|'"dccp"'       # Datagram Congestion Control Protocol
---|'"3pc"'        # Third Party Connect Protocol
---|'"idpr"'       # Inter-Domain Policy Routing Protocol
---|'"xtp"'        # Xpress Tranfer Protocol
---|'"ddp"'        # Datagram Delivery Protocol
---|'"idpr-cmtp"'  # IDPR Control Message Transport Proto
---|'"tp++"'       # TP++ Transport Protocol
---|'"il"'         # IL Transport Protocol
---|'"ipv6"'       # IPv6 encapsulation
---|'"sdrp"'       # Source Demand Routing Protocol
---|'"ipv6-route"' # Routing Header for IPv6
---|'"ipv6-frag"'  # Fragment Header for IPv6
---|'"idrp"'       # Inter-Domain Routing Protocol
---|'"rsvp"'       # Resource ReSerVation Protocol
---|'"gre"'        # Generic Routing Encapsulation
---|'"dsr"'        # Dynamic Source Routing Protocol
---|'"bna"'        # BNA
---|'"esp"'        # Encap Security Payload
---|'"ipv6-crypt"' # Encryption Header for IPv6 (not in official list)
---|'"ah"'         # Authentication Header
---|'"ipv6-auth"'  # Authentication Header for IPv6 (not in official list)
---|'"i-nlsp"'     # Integrated Net Layer Security TUBA
---|'"swipe"'      # IP with Encryption
---|'"narp"'       # NBMA Address Resolution Protocol
---|'"mobile"'     # IP Mobility
---|'"tlsp"'       # Transport Layer Security Protocol
---|'"skip"'       # SKIP
---|'"ipv6-icmp"'  # ICMP for IPv6
---|'"ipv6-nonxt"' # No Next Header for IPv6
---|'"ipv6-opts"'  # Destination Options for IPv6
---|'"#"'          # any host internal protocol
---|'"cftp"'       # CFTP
---|'"#"'          # any local network
---|'"sat-expak"'  # SATNET and Backroom EXPAK
---|'"kryptolan"'  # Kryptolan
---|'"rvd"'        # MIT Remote Virtual Disk Protocol
---|'"ippc"'       # Internet Pluribus Packet Core
---|'"#"'          # any distributed file system
---|'"sat-mon"'    # SATNET Monitoring
---|'"visa"'       # VISA Protocol
---|'"ipcv"'       # Internet Packet Core Utility
---|'"cpnx"'       # Computer Protocol Network Executive
---|'"cphb"'       # Computer Protocol Heart Beat
---|'"wsn"'        # Wang Span Network
---|'"pvp"'        # Packet Video Protocol
---|'"br-sat-mon"' # Backroom SATNET Monitoring
---|'"sun-nd"'     # SUN ND PROTOCOL-Temporary
---|'"wb-mon"'     # WIDEBAND Monitoring
---|'"wb-expak"'   # WIDEBAND EXPAK
---|'"iso-ip"'     # ISO Internet Protocol
---|'"vmtp"'       # Versatile Message Transport
---|'"secure-vmtp"' # SECURE-VMTP
---|'"vines"'      # VINES
---|'"ttp"'        # TTP
---|'"nsfnet-igp"' # NSFNET-IGP
---|'"dgp"'        # Dissimilar Gateway Protocol
---|'"tcf"'        # TCF
---|'"eigrp"'      # Enhanced Interior Routing Protocol (Cisco)
---|'"ospf"'       # Open Shortest Path First IGP
---|'"sprite-rpc"' # Sprite RPC Protocol
---|'"larp"'       # Locus Address Resolution Protocol
---|'"mtp"'        # Multicast Transport Protocol
---|'"ax.25"'      # AX.25 Frames
---|'"ipip"'       # Yet Another IP encapsulation
---|'"micp"'       # Mobile Internetworking Control Pro.
---|'"scc-sp"'     # Semaphore Communications Sec. Pro.
---|'"etherip"'    # Ethernet-within-IP Encapsulation
---|'"encap"'      # Yet Another IP encapsulation
---|'"#"'          # any private encryption scheme
---|'"gmtp"'       # GMTP
---|'"ifmp"'       # Ipsilon Flow Management Protocol
---|'"pnni"'       # PNNI over IP
---|'"pim"'        # Protocol Independent Multicast
---|'"aris"'       # ARIS
---|'"scps"'       # SCPS
---|'"qnx"'        # QNX
---|'"a/n"'        # Active Networks
---|'"ipcomp"'     # IP Payload Compression Protocol
---|'"snp"'        # Sitara Networks Protocol
---|'"compaq-peer"' # Compaq Peer Protocol
---|'"ipx-in-ip"'  # IPX in IP
---|'"vrrp"'       # Virtual Router Redundancy Protocol
---|'"pgm"'        # PGM Reliable Transport Protocol
---|'"#"'          # any 0-hop protocol
---|'"l2tp"'       # Layer Two Tunneling Protocol
---|'"ddx"'        # D-II Data Exchange
---|'"iatp"'        # Interactive Agent Transfer Protocol
---|'"stp"'        # Schedule Transfer
---|'"srp"'        # SpectraLink Radio Protocol
---|'"uti"'        # UTI
---|'"smp"'        # Simple Message Protocol
---|'"sm"'         # SM (deprecated)
---|'"ptp"'        # Performance Transparency Protocol
---|'"isis"'       # ISIS over IPv4
---|'"crtp"'       # Combat Radio Transport Protocol
---|'"crudp"'      # Combat Radio User Datagram
---|'"sps"'        # Secure Packet Shield
---|'"pipe"'       # Private IP Encapsulation within IP
---|'"sctp"'       # Stream Control Transmission Protocol
---|'"fc"'         # Fibre Channel
---|'"mobility-header"' # Mobility Header
---|'"manet"'      # MANET Protocols
---|'"hip"'        # Host Identity Protocol
---|'"shim6"'      # Shim6 Protocol
---|'"wesp"'       # Wrapped Encapsulating Security Payload
---|'"rohc"'       # Robust Header Compression

---@alias uv.aliases.tcp_socket_type
---|>'"stream"'
---|'"dgram"'
---|'"raw"'
---|'"rdm"'
---|'"seqpacket"'

---@alias uv.aliases.tcp_bind_flags {ipv6only?: boolean}

---@alias uv.aliases.getpeername_rtn {ip: string, family: uv.aliases.network_family, port: integer}

---@alias uv.aliases.getsockname_rtn uv.aliases.getpeername_rtn

---@alias uv.aliases.socketpair_flags {nonblock: boolean}

---
---Creates and initializes a new `uv_tcp_t`.
---Returns the Lua userdata wrapping it.
---
---@param flags uv.aliases.network_family|integer
---@return uv_tcp_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_tcp(flags) end
---@return uv_tcp_t
---@nodiscard
function uv.new_tcp() end

---
---Open an existing file descriptor or SOCKET as a TCP handle.
---
---**Note:** The passed file descriptor or SOCKET is not checked for its type, but it's required that it represents a valid stream socket.
---
---@param tcp uv_tcp_t
---@param sock integer
---@return 0|nil success, string? err_name, string? err_msg
function uv.tcp_open(tcp, sock) end
uv_tcp_t.open = uv.tcp_open

---
---Enable / disable Nagle's algorithm.
---
---@param tcp uv_tcp_t
---@param enable boolean
---@return 0|nil success, string? err_name, string? err_msg
function uv.tcp_nodelay(tcp, enable) end
uv_tcp_t.nodelay = uv.tcp_nodelay

---
---Enable / disable TCP keep-alive. `delay` is the initial delay in seconds,
---ignored when enable is `false`.
---
---@param tcp uv_tcp_t
---@param enable boolean
---@param delay integer|nil
---@return 0|nil success, string? err_name, string? err_msg
function uv.tcp_keepalive(tcp, enable, delay) end
uv_tcp_t.keepalive = uv.tcp_keepalive

---
---Enable / disable simultaneous asynchronous accept requests that are queued by
---the operating system when listening for new TCP connections.
---
---This setting is used to tune a TCP server for the desired performance. Having
---simultaneous accepts can significantly improve the rate of accepting connections
---(which is why it is enabled by default) but may lead to uneven load distribution
---in multi-process setups.
---
---@param tcp uv_tcp_t
---@param enable boolean
---@return 0|nil success, string? err_name, string? err_msg
function uv.tcp_simultaneous_accepts(tcp, enable) end
uv_tcp_t.simultaneous_accepts = uv.tcp_simultaneous_accepts

---
---Bind the handle to an host and port. `host` should be an IP address and
---not a domain name. Any `flags` are set with a table with field `ipv6only`
---equal to `true` or `false`.
---
---When the port is already taken, you can expect to see an `EADDRINUSE` error
---from either `uv.tcp_bind()`, `uv.listen()` or `uv.tcp_connect()`. That is, a
---successful call to this function does not guarantee that the call to `uv.listen()`
---or `uv.tcp_connect()` will succeed as well.
---
---Use a port of `0` to let the OS assign an ephemeral port.  You can look it up
---later using `uv.tcp_getsockname()`.
---
---@param tcp uv_tcp_t
---@param host string
---@param port integer
---@param flags uv.aliases.tcp_bind_flags|nil
---@return 0|nil success, string? err_name, string? err_msg
function uv.tcp_bind(tcp, host, port, flags) end
uv_tcp_t.bind = uv.tcp_bind

---
---Get the address of the peer connected to the handle.
---
---@param tcp uv_tcp_t
---@return uv.aliases.getpeername_rtn|nil, string? err_name, string? err_msg
---@nodiscard
function uv.tcp_getpeername(tcp) end
uv_tcp_t.getpeername = uv.tcp_getpeername

---
---Get the current address to which the handle is bound.
---
---@param tcp uv_tcp_t
---@return uv.aliases.getsockname_rtn|nil, string? err_name, string? err_msg
---@nodiscard
function uv.tcp_getsockname(tcp) end
uv_tcp_t.getsockname = uv.tcp_getsockname

---
---Establish an IPv4 or IPv6 TCP connection.
---
---```lua
---local client = uv.new_tcp()
---client:connect("127.0.0.1", 8080, function (err)
---  -- check error and carry on.
---end)
---```
---
---@param tcp uv_tcp_t
---@param host string
---@param port integer
---@param callback fun(err?: string)
---@return uv_connect_t|nil stream, string? err_name, string? err_msg
function uv.tcp_connect(tcp, host, port, callback) end
uv_tcp_t.connect = uv.tcp_connect

---
---Please use `uv.stream_get_write_queue_size()` instead.
---
---@param tcp uv_tcp_t
---@deprecated
function uv.tcp_write_queue_size(tcp) end
uv_tcp_t.write_queue_size = uv.tcp_write_queue_size

---
---Resets a TCP connection by sending a RST packet. This is accomplished by setting
---the SO_LINGER socket option with a linger interval of zero and then calling
---`uv.close()`. Due to some platform inconsistencies, mixing of `uv.shutdown()`
---and `uv.tcp_close_reset()` calls is not allowed.
---
---@param tcp uv_tcp_t
---@param callback fun()|nil
---@return 0|nil success, string? err_name, string? err_msg
function uv.tcp_close_reset(tcp, callback) end
uv_tcp_t.close_reset = uv.tcp_close_reset

---
---Create a pair of connected sockets with the specified properties. The resulting handles can be passed to `uv.tcp_open`, used with `uv.spawn`, or for any other purpose.
---When specified as a string, `socktype` must be one of `"stream"`, `"dgram"`, `"raw"`,
---`"rdm"`, or `"seqpacket"`.
---
---When `protocol` is set to 0 or nil, it will be automatically chosen based on the socket's domain and type. When `protocol` is specified as a string, it will be looked up using the `getprotobyname(3)` function (examples: `"ip"`, `"icmp"`, `"tcp"`, `"udp"`, etc).
---
---Flags:
---- `nonblock`: Opens the specified socket handle for `OVERLAPPED` or `FIONBIO`/`O_NONBLOCK` I/O usage. This is recommended for handles that will be used by libuv, and not usually recommended otherwise.
---
---Equivalent to `socketpair(2)` with a domain of `AF_UNIX`.
---
---```lua
----- Simple read/write with tcp
---local fds = uv.socketpair(nil, nil, {nonblock=true}, {nonblock=true})
---
---local sock1 = uv.new_tcp()
---sock1:open(fds[1])
---
---local sock2 = uv.new_tcp()
---sock2:open(fds[2])
---
---sock1:write("hello")
---sock2:read_start(function(err, chunk)
---  assert(not err, err)
---  print(chunk)
---end)
---```
---
---@param socktype uv.aliases.tcp_socket_type|integer|nil # (default: `"stream"`)
---@param protocol uv.aliases.network_protocols|integer|nil # (default: `0`)
---@param flags1 uv.aliases.socketpair_flags|nil # (nonblock default: `false`)
---@param flags2 uv.aliases.socketpair_flags|nil # (nonblock default: `false`)
---@return {[1]: integer, [2]: integer}|nil, string? err_name, string? err_msg # [1, 2] file descriptor
function uv.socketpair(socktype, protocol, flags1, flags2) end



---
---Pipe handles provide an abstraction over local domain sockets on Unix and named pipes on Windows.
---
---```lua
---local pipe = uv.new_pipe(false)
---
---pipe:bind('/tmp/sock.test')
---
---pipe:listen(128, function()
---  local client = uv.new_pipe(false)
---  pipe:accept(client)
---  client:write("hello!\n")
---  client:close()
---end)
---```
---
---@class uv_pipe_t: uv_stream_t
---@section Pipe handle
local uv_pipe_t = {}

---@alias uv.aliases.pipe_chmod_flags
---|'"r"'
---|'"w"'
---|'"rw"'
---|'"wr"'

---@alias uv.aliases.pipe_flags {nonblock: boolean} # (nonblock default: `false`)

---@alias uv.aliases.pipe_rtn {read: integer, write: integer}

---
---Creates and initializes a new `uv_pipe_t`. Returns the Lua userdata wrapping
---it. The `ipc` argument is a boolean to indicate if this pipe will be used for
---handle passing between processes.
---
---@param ipc boolean|nil
---@return uv_pipe_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_pipe(ipc) end

-- TODO: make sure the above method can indeed return nil + error message.

---
---Open an existing file descriptor or `uv_handle_t` as a pipe.
---
---**Note**: The file descriptor is set to non-blocking mode.
---
---@param pipe uv_pipe_t
---@param fd integer
---@return 0|nil success, string? err_name, string? err_msg
function uv.pipe_open(pipe, fd) end
uv_pipe_t.open = uv.pipe_open

---
---Bind the pipe to a file path (Unix) or a name (Windows).
---
---**Note**: Paths on Unix get truncated to sizeof(sockaddr_un.sun_path) bytes,
---typically between 92 and 108 bytes.
---
---@param pipe uv_pipe_t
---@param name string
---@return 0|nil success, string? err_name, string? err_msg
function uv.pipe_bind(pipe, name) end
uv_pipe_t.bind = uv.pipe_bind

---
---Connect to the Unix domain socket or the named pipe.
---
---**Note**: Paths on Unix get truncated to sizeof(sockaddr_un.sun_path) bytes,
---typically between 92 and 108 bytes.
---
---@param pipe uv_pipe_t
---@param name string
---@param callback fun(err?: string)|nil
---@return uv_connect_t|nil stream, string? err_name, string? err_msg
function uv.pipe_connect(pipe, name, callback) end
uv_pipe_t.connect = uv.pipe_connect

---
---Get the name of the Unix domain socket or the named pipe.
---
---@param pipe uv_pipe_t
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.pipe_getsockname(pipe) end
uv_pipe_t.getsockname = uv.pipe_getsockname

---
---Get the name of the Unix domain socket or the named pipe to which the handle is
---connected.
---
---@param pipe uv_pipe_t
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.pipe_getpeername(pipe) end
uv_pipe_t.getpeername = uv.pipe_getpeername

---
---Set the number of pending pipe instance handles when the pipe server is waiting
---for connections.
---
---**Note**: This setting applies to Windows only.
---
---@param pipe uv_pipe_t
---@param count integer
function uv.pipe_pending_instances(pipe, count) end
uv_pipe_t.pending_instances = uv.pipe_pending_instances

---
---Returns the pending pipe count for the named pipe.
---
---@param pipe uv_pipe_t
---@return integer
---@nodiscard
function uv.pipe_pending_count(pipe) end
uv_pipe_t.pending_count = uv.pipe_pending_count

---
---Used to receive handles over IPC pipes.
---
---First - call `uv.pipe_pending_count()`, if it's > 0 then initialize a handle of
---the given type, returned by `uv.pipe_pending_type()` and call
---`uv.accept(pipe, handle)`.
---
---@param pipe uv_pipe_t
---@return string
---@nodiscard
function uv.pipe_pending_type(pipe) end
uv_pipe_t.pending_type = uv.pipe_pending_type

---
---Alters pipe permissions, allowing it to be accessed from processes run by different users.
---Makes the pipe writable or readable by all users.
---See below for accepted flags, where `r` is `READABLE` and `w` is `WRITABLE`.
---This function is blocking.
---
---@param pipe uv_pipe_t
---@param flags uv.aliases.pipe_chmod_flags
---@return 0|nil success, string? err_name, string? err_msg
function uv.pipe_chmod(pipe, flags) end
uv_pipe_t.chmod = uv.pipe_chmod

---
---Create a pair of connected pipe handles. Data may be written to the `write` fd and read from the `read` fd.
---The resulting handles can be passed to `pipe_open`, used with `spawn`, or for any other purpose.
---
---Flags:
--- - `nonblock`: Opens the specified socket handle for `OVERLAPPED` or `FIONBIO`/`O_NONBLOCK` I/O usage.
--- This is recommended for handles that will be used by libuv, and not usually recommended otherwise.
---
---Equivalent to `pipe(2)` with the `O_CLOEXEC` flag set.
---
---```lua
----- Simple read/write with pipe_open
---local fds = uv.pipe({nonblock=true}, {nonblock=true})
---
---local read_pipe = uv.new_pipe()
---read_pipe:open(fds.read)
---
---local write_pipe = uv.new_pipe()
---write_pipe:open(fds.write)
---
---write_pipe:write("hello")
---read_pipe:read_start(function(err, chunk)
---  assert(not err, err)
---  print(chunk)
---end)
---```
---
---@param read_flags uv.aliases.pipe_flags|nil  # (nonblock default: `false`)
---@param write_flags uv.aliases.pipe_flags|nil # (nonblock default: `false`)
---@return uv.aliases.pipe_rtn|nil, string? err_name, string? err_msg
---@nodiscard
function uv.pipe(read_flags, write_flags) end



---
---TTY handles represent a stream for the console.
---
---```lua
----- Simple echo program
---local stdin = uv.new_tty(0, true)
---local stdout = uv.new_tty(1, false)
---
---stdin:read_start(function (err, data)
---  assert(not err, err)
---  if data then
---    stdout:write(data)
---  else
---    stdin:close()
---    stdout:close()
---  end
---end)
---```
---
---@class uv_tty_t: uv_stream_t
---@section TTY handle
local uv_tty_t = {}

---@alias uv.aliases.tty_fd
---|0 # stdin
---|1 # stdout
---|2 # stderr

---@alias uv.aliases.tty_mode
---|0 # UV_TTY_MODE_NORMAL: Initial/normal terminal mode
---|1 # UV_TTY_MODE_RAW: Raw input mode (On Windows, ENABLE_WINDOW_INPUT is also enabled)
---|2 # UV_TTY_MODE_IO: Binary-safe I/O mode for IPC (Unix-only)

---@alias uv.aliases.tty_vsterm_state
---|'supported'
---|'unsupported'

---
---Initialize a new TTY stream with the given file descriptor.
---See below for possible file descriptors.
---
---On Unix this function will determine the path of the fd of the terminal using
---ttyname_r(3), open it, and use it if the passed file descriptor refers to a TTY.
---
---This lets libuv put the tty in non-blocking mode without affecting other
---processes that share the tty.
---
---This function is not thread safe on systems that don’t support ioctl TIOCGPTN or TIOCPTYGNAME, for instance OpenBSD and Solaris.
---
---**Note:** If reopening the TTY fails, libuv falls back to blocking writes.
---
---@param fd uv.aliases.tty_fd|integer
---@param readable boolean
---@return uv_tty_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_tty(fd, readable) end

---
---Set the TTY using the specified terminal mode.
---
---Parameter `mode` is a C enum with the values below.
---
---@param tty uv_tty_t
---@param mode uv.aliases.tty_mode
---@return 0|nil success, string? err_name, string? err_msg
function uv.tty_set_mode(tty, mode) end
uv_tty_t.set_mode = uv.tty_set_mode

---
---To be called when the program exits. Resets TTY settings to default values for
---the next process to take over.
---This function is async signal-safe on Unix platforms but can fail with error
---code `EBUSY` if you call it when execution is inside `uv.tty_set_mode()`.
---
---@return 0|nil success, string? err_name, string? err_msg
function uv.tty_reset_mode() end

---
---Gets the current Window width and height.
---
---@param tty uv_tty_t
---@return integer|nil width, integer|string height_or_errname, string? err_msg
---@nodiscard
function uv.tty_get_winsize(tty) end
uv_tty_t.get_winsize = uv.tty_get_winsize

---
---Controls whether console virtual terminal sequences are processed by libuv or
---console. Useful in particular for enabling ConEmu support of ANSI X3.64 and
---Xterm 256 colors. Otherwise Windows10 consoles are usually detected
---automatically. State should be one of: `"supported"` or `"unsupported"`.
---
---This function is only meaningful on Windows systems. On Unix it is silently
---ignored.
---
---@param state uv.aliases.tty_vsterm_state
function uv.tty_set_vterm_state(state) end

---
---Get the current state of whether console virtual terminal sequences are handled
---by libuv or the console. The return value is `"supported"` or `"unsupported"`.
---This function is not implemented on Unix, where it returns `ENOTSUP`.
---
---@return uv.aliases.tty_vsterm_state|nil, string? err_name, string? err_msg
---@nodiscard
function uv.tty_get_vterm_state() end



---
---UDP handles encapsulate UDP communication for both clients and servers.
---
---@class uv_udp_t: uv_handle_t
---@section UDP handle
local uv_udp_t = {}

---@class uv_udp_send_t: userdata

---@alias uv.aliases.new_udp_flags {family: uv.aliases.network_family, mmsgs: integer}

---@alias uv.aliases.udp_bind_flags {ipv6only: boolean, reuseaddr: boolean}

---@alias uv.aliases.udp_getsockname_rtn uv.aliases.getsockname_rtn

---@alias uv.aliases.udp_getpeername_rtn uv.aliases.getpeername_rtn

---@alias uv.aliases.udp_membership '"join"'|'"leave"'

---@alias uv.aliases.udp_recv_start_callback_flags {partial: boolean|nil, mmsg_chunk: boolean|nil}

---
---Creates and initializes a new `uv_udp_t`. Returns the Lua userdata wrapping
---it. The actual socket is created lazily.
---
---See below for accepted `family` values.
---
---When specified, `mmsgs` determines the number of messages able to be received
---at one time via `recvmmsg(2)` (the allocated buffer will be sized to be able
---to fit the specified number of max size dgrams). Only has an effect on
---platforms that support `recvmmsg(2)`.
---
---**Note:** For backwards compatibility reasons, `flags` can also be a string or
---integer. When it is a string, it will be treated like the `family` key above.
---When it is an integer, it will be used directly as the `flags` parameter when
---calling `uv_udp_init_ex`.
---
---@param flags uv.aliases.new_udp_flags|uv.aliases.network_family|integer # (mmsgs default: `1`)
---@return uv_udp_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_udp(flags) end
---@return uv_udp_t
---@nodiscard
function uv.new_udp() end

---
---Returns the handle's send queue size.
---
---@return integer
---@nodiscard
function uv.udp_get_send_queue_size() end
uv_udp_t.get_send_queue_size = uv.udp_get_send_queue_size

---
---Returns the handle's send queue count.
---
---@return integer
---@nodiscard
function uv.udp_get_send_queue_count() end
uv_udp_t.get_send_queue_count = uv.udp_get_send_queue_count

---
---Opens an existing file descriptor or Windows SOCKET as a UDP handle.
---
---Unix only: The only requirement of the sock argument is that it follows the
---datagram contract (works in unconnected mode, supports sendmsg()/recvmsg(),
---etc). In other words, other datagram-type sockets like raw sockets or netlink
---sockets can also be passed to this function.
---
---The file descriptor is set to non-blocking mode.
---
---**Note:** The passed file descriptor or SOCKET is not checked for its type, but
---it's required that it represents a valid datagram socket.
---
---@param udp uv_udp_t
---@param fd integer
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_open(udp, fd) end
uv_udp_t.open = uv.udp_open

---
---Bind the UDP handle to an IP address and port. Any `flags` are set with a table
---with fields `reuseaddr` or `ipv6only` equal to `true` or `false`.
---
---@param udp uv_udp_t
---@param host string
---@param port integer
---@param flags uv.aliases.udp_bind_flags|nil
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_bind(udp, host, port, flags) end
uv_udp_t.bind = uv.udp_bind

---
---Get the local IP and port of the UDP handle.
---
---@param udp uv_udp_t
---@return uv.aliases.udp_getsockname_rtn|nil, string? err_name, string? err_msg
---@nodiscard
function uv.udp_getsockname(udp) end
uv_udp_t.getsockname = uv.udp_getsockname

---
---Get the remote IP and port of the UDP handle on connected UDP handles.
---
---@param udp uv_udp_t
---@return uv.aliases.udp_getpeername_rtn|nil, string? err_name, string? err_msg
---@nodiscard
function uv.udp_getpeername(udp) end
uv_udp_t.getpeername = uv.udp_getpeername

---
---Set membership for a multicast address. `multicast_addr` is multicast address to
---set membership for. `interface_addr` is interface address. `membership` can be
---the string `"leave"` or `"join"`.
---
---@param udp uv_udp_t
---@param multicast_addr string
---@param interface_addr string|nil
---@param membership uv.aliases.udp_membership
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_set_membership(udp, multicast_addr, interface_addr, membership) end
uv_udp_t.set_membership = uv.udp_set_membership

---
---Set membership for a source-specific multicast group. `multicast_addr` is multicast
---address to set membership for. `interface_addr` is interface address. `source_addr`
---is source address. `membership` can be the string `"leave"` or `"join"`.
---
---@param udp uv_udp_t
---@param multicast_addr string
---@param interface_addr string|nil
---@param source_addr string
---@param membership uv.aliases.udp_membership
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_set_source_membership(udp, multicast_addr, interface_addr, source_addr, membership) end
uv_udp_t.set_source_membership = uv.udp_set_source_membership

---
---Set IP multicast loop flag. Makes multicast packets loop back to local
---sockets.
---
---@param udp uv_udp_t
---@param on boolean
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_set_multicast_loop(udp, on) end
uv_udp_t.set_multicast_loop = uv.udp_set_multicast_loop

---
---Set the multicast ttl.
---`ttl` is an integer 1 through 255.
---
---@param udp uv_udp_t
---@param ttl integer
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_set_multicast_ttl(udp, ttl) end
uv_udp_t.set_multicast_ttl = uv.udp_set_multicast_ttl

---
---Set the multicast interface to send or receive data on.
---
---@param udp uv_udp_t
---@param interface_addr string
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_set_multicast_interface(udp, interface_addr) end
uv_udp_t.set_multicast_interface = uv.udp_set_multicast_interface

---
---Set broadcast on or off.
---
---@param udp uv_udp_t
---@param on boolean
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_set_broadcast(udp, on) end
uv_udp_t.set_broadcast = uv.udp_set_broadcast

---
---Set the time to live.
---`ttl` is an integer 1 through 255.
---
---@param udp uv_udp_t
---@param ttl integer
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_set_ttl(udp, ttl) end
uv_udp_t.set_ttl = uv.udp_set_ttl

---
---Send data over the UDP socket. If the socket has not previously been bound
---with `uv.udp_bind()` it will be bound to `0.0.0.0` (the "all interfaces" IPv4
---address) and a random port number.
---
---@param udp uv_udp_t
---@param data uv.aliases.buffer
---@param host string
---@param port integer
---@param callback fun(err?: string)
---@return uv_udp_send_t|nil stream, string? err_name, string? err_msg
function uv.udp_send(udp, data, host, port, callback) end
uv_udp_t.send = uv.udp_send

---
---Same as `uv.udp_send()`, but won't queue a send request if it can't be
---completed immediately.
---
---@param udp uv_udp_t
---@param data uv.aliases.buffer
---@param host string
---@param port integer
---@return integer|nil, string? err_name, string? err_msg
function uv.udp_try_send(udp, data, host, port) end
uv_udp_t.try_send = uv.udp_try_send

---
---Prepare for receiving data. If the socket has not previously been bound with
---`uv.udp_bind()` it is bound to `0.0.0.0` (the "all interfaces" IPv4 address)
---and a random port number.
---
---@param udp uv_udp_t
---@param callback fun(err?: string, data?: string, add?: uv.aliases.udp_getpeername_rtn, flags: uv.aliases.udp_recv_start_callback_flags)
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_recv_start(udp, callback) end
uv_udp_t.recv_start = uv.udp_recv_start

---
---Stop listening for incoming datagrams.
---
---@param udp uv_udp_t
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_recv_stop(udp) end
uv_udp_t.recv_stop = uv.udp_recv_stop

---
---Associate the UDP handle to a remote address and port, so every message sent by
---this handle is automatically sent to that destination. Calling this function
---with a NULL addr disconnects the handle. Trying to call `uv.udp_connect()` on an
---already connected handle will result in an `EISCONN` error. Trying to disconnect
---a handle that is not connected will return an `ENOTCONN` error.
---
---@param udp uv_udp_t
---@param host string
---@param port integer
---@return 0|nil success, string? err_name, string? err_msg
function uv.udp_connect(udp, host, port) end
uv_udp_t.connect = uv.udp_connect



---
---FS Event handles allow the user to monitor a given path for changes, for
---example, if the file was renamed or there was a generic change in it. This
---handle uses the best backend for the job on each platform.
---
---@class uv_fs_event_t: uv_handle_t
---@section FS Event handle
local uv_fs_event_t = {}

---@alias uv.aliases.fs_event_start_flags {watch_entry?: boolean, stat?: boolean, recursive?: boolean}

---@alias uv.aliases.fs_event_start_callback_events {change?: boolean, rename?: boolean}

---
---Creates and initializes a new `uv_fs_event_t`.
---Returns the Lua userdata wrapping it.
---
---@return uv_fs_event_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_fs_event() end

-- TODO: make sure that the above method can indeed return nil + error.

---
---Start the handle with the given callback, which will watch the specified path
---for changes.
---
---@param fs_event uv_fs_event_t
---@param path string
---@param flags uv.aliases.fs_event_start_flags # (all flags have default of `false`)
---@param callback fun(err?: string, filename: string, events: uv.aliases.fs_event_start_callback_events)
---@return 0|nil success, string? err_name, string? err_msg
function uv.fs_event_start(fs_event, path, flags, callback) end
uv_fs_event_t.start = uv.fs_event_start

---
---Stop the handle, the callback will no longer be called.
---
---@return 0|nil success, string? err_name, string? err_msg
function uv.fs_event_stop() end
uv_fs_event_t.stop = uv.fs_event_stop

---
---Get the path being monitored by the handle.
---
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.fs_event_getpath() end
uv_fs_event_t.getpath = uv.fs_event_getpath



---
---FS Poll handles allow the user to monitor a given path for changes. Unlike
---`uv_fs_event_t`, fs poll handles use `stat` to detect when a file has changed so
---they can work on file systems where fs event handles can't.
---
---@class uv_fs_poll_t: uv_handle_t
---@section FS Poll handle
local uv_fs_poll_t = {}

---
---Creates and initializes a new `uv_fs_poll_t`.
---Returns the Lua userdata wrapping it.
---
---@return uv_fs_poll_t|nil, string? err_name, string? err_msg
---@nodiscard
function uv.new_fs_poll() end

-- TODO: make sure that the above methof can indeed return nil + error.

---
---Check the file at `path` for changes every `interval` milliseconds.
---
---**Note:** For maximum portability, use multi-second intervals. Sub-second
---intervals will not detect all changes on many file systems.
---
---@param fs_poll uv_fs_poll_t
---@param path string
---@param interval integer
---@param callback fun(err?: string, prev: uv.aliases.fs_stat_table, curr: uv.aliases.fs_stat_table)
---@return 0|nil success, string? err_name, string? err_msg
function uv.fs_poll_start(fs_poll, path, interval, callback) end
uv_fs_poll_t.start = uv.fs_poll_start

---
---Stop the handle, the callback will no longer be called.
---
---@return 0|nil success, string? err_name, string? err_msg
function uv.fs_poll_stop() end
uv_fs_poll_t.stop = uv.fs_poll_stop

---
---Get the path being monitored by the handle.
---
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.fs_poll_getpath() end
uv_fs_poll_t.getpath = uv.fs_poll_getpath



---
---@section File system operations
---
---Most file system functions can operate synchronously or asynchronously. When a synchronous version is called (by omitting a callback), the function will
---immediately return the results of the FS call. When an asynchronous version is
---called (by providing a callback), the function will immediately return a
---`uv_fs_t` and asynchronously execute its callback; if an error is encountered, the first and only argument passed to the callback will be the `err` error string; if the operation completes successfully, the first argument will be `nil` and the remaining arguments will be the results of the FS call.
---
---Synchronous and asynchronous versions of `readFile` (with naive error handling)
---are implemented below as an example:
---
---```lua
---local function readFileSync(path)
---  local fd = assert(uv.fs_open(path, "r", 438))
---  local stat = assert(uv.fs_fstat(fd))
---  local data = assert(uv.fs_read(fd, stat.size, 0))
---  assert(uv.fs_close(fd))
---  return data
---end
---
---local data = readFileSync("main.lua")
---print("synchronous read", data)
---```
---
---```lua
---local function readFile(path, callback)
---  uv.fs_open(path, "r", 438, function(err, fd)
---    assert(not err, err)
---    uv.fs_fstat(fd, function(err, stat)
---      assert(not err, err)
---      uv.fs_read(fd, stat.size, 0, function(err, data)
---        assert(not err, err)
---        uv.fs_close(fd, function(err)
---          assert(not err, err)
---          return callback(data)
---        end)
---      end)
---    end)
---  end)
---end
---
---readFile("main.lua", function(data)
---  print("asynchronous read", data)
---end)
---```
---

---@class uv_fs_t: uv_req_t

---@class luv_dir_t: userdata
local luv_dir_t = {}

---@alias uv.aliases.fs_access_flags
---Open file for reading.
---
---Fails if the file does not exist.
---
---Mode: O_RDONLY.
---|'"r"'
---Open file for reading in synchronous mode.
---Instructs the operating system to bypass the local file system cache.
---
---This is primarily useful for opening files on NFS mounts as it allows you to
---skip the potentially stale local cache. It has a very real impact on I/O
---performance so don't use this flag unless you need it.
---
---Note that this doesn't turn this call into a synchronous blocking call.
---
---Mode: O_RDONLY + O_SYNC.
---|'"rs"'
---Same as `'rs'`.
---|'"sr"'
---Open file for reading and writing.
---
---Fails if the file does not exist.
---
---Mode: O_RDWR.
---|'"r+"'
---Open file for reading and writing, telling the OS to open it synchronously.
---
---See notes for `'rs'` about using this with caution.
---
---Mode: O_RDWR + O_SYNC.
---|'"rs+"'
---Same as `'rs+'`.
---|'"sr+"'
---Open file for writing.
---
---The file is created (if it does not exist) or truncated (if it exists).
---
---Mode: O_TRUNC + O_CREAT + O_WRONLY.
---|'"w"'
---Open file for writing.
---
---Fails if the file exists.
---
---Mode: O_TRUNC + O_CREAT + O_WRONLY + O_EXCL.
---|'"wx"'
---Same as `'wx'`.
---|'"xw"'
---Open file for reading and writing.
---
---The file is created (if it does not exist) or truncated (if it exists).
---
---Mode: O_TRUNC + O_CREAT + O_RDWR.
---|'"w+"'
---Open file for reading and writing.
---
---Fails if file exists.
---
---Mode: O_TRUNC + O_CREAT + O_RDWR + O_EXCL.
---|'"wx+"'
---Same as `'wx+'`.
---|'"xw+"'
---Open file for appending.
---
---The file is created if it does not exist.
---
---Mode: O_APPEND + O_CREAT + O_WRONLY.
---|'"a"'
---Open file for appending.
---
---Fails if the file exists.
---
---Mode: O_APPEND + O_CREAT + O_WRONLY + O_EXCL.
---|'"ax"'
---Same as `'ax'`.
---|'"xa"'
---Open file for reading and appending.
---
---The file is created if it does not exist.
---
---Mode: O_APPEND + O_CREAT + O_RDWR.
---|'"a+"'
---Like `'a+'` but fails if `path` exists.
---
---Mode: O_APPEND + O_CREAT + O_RDWR + O_EXCL
---|'"ax+"'
---Same as `'ax+'`.
---|'"xa+"'

---@alias uv.aliases.fs_stat_types
---|'"file"'
---|'"directory"'
---|'"link"'
---|'"fifo"'
---|'"socket"'
---|'"char"'
---|'"block"'

---@alias uv.aliases.fs_stat_table {gen: integer, flags: integer, atime: {nsec: integer, sec: integer}, ctime: {nsec: integer, sec: integer}, birthtime: {nsec: integer, sec: integer}, uid: integer, gid: integer, mtime: {nsec: integer, sec: integer}, size: integer, type?: uv.aliases.fs_stat_types, nlink: integer, dev: integer, mode: integer, rdev: integer, ino: integer, blksize: integer, blocks: integer}

---@alias uv.aliases.fs_types
---|'"file"'
---|'"directory"'
---|'"link"'
---|'"fifo"'
---|'"socket"'
---|'"char"'
---|'"block"'
---|'"unknown"'

---@alias uv.aliases.fs_access_mode
---Tests for readbility.
---|'R'
---Tests for writiblity.
---|'W'
---Tests for executibility.
---|'X'
---Tests for readbility and writiblity.
---|'RW'
---Tests for readbility and executibility.
---|'RX'
---Tests for writiblity and executibility.
---|'WX'
---Tests for writiblity and readbility and executibility.
---|'WRX'
---A bitwise OR mask.
---|integer

---@alias uv.aliases.fs_readdir_entries {type: uv.aliases.fs_types, name: string}

---@alias uv.aliases.fs_symlink_flags {dir: boolean, junction: boolean}

---@alias uv.aliases.fs_copyfile_flags {excl: boolean, ficlone: boolean, ficlone_force: boolean}

---@alias uv.aliases.fs_statfs_stats_type
---Always 0 on Windows, sun, MVS, OpenBSD, NetBSD, HAIKU, QNK.
---|0
---ADFS_SUPER_MAGIC = 0xadf5
---|44533
---AFFS_SUPER_MAGIC = 0xadff
---|44543
---AFS_SUPER_MAGIC = 0x5346414f
---|1397113167
---ANON_INODE_FS_MAGIC = 0x09041934 | Anonymous inode FS (for pseudofiles that have no name; e.g., epoll, signalfd, bpf)
---|151263540
---AUTOFS_SUPER_MAGIC = 0x0187
---|391
---BDEVFS_MAGIC = 0x62646576
---|1650746742
---BEFS_SUPER_MAGIC = 0x42465331
---|1111905073
---BFS_MAGIC = 0x1badface
---|464386766
---BINFMTFS_MAGIC = 0x42494e4d
---|1112100429
---BPF_FS_MAGIC = 0xcafe4a11
---|3405662737
---BTRFS_SUPER_MAGIC = 0x9123683e
---|2435016766
---BTRFS_TEST_MAGIC = 0x73727279
---|1936880249
---CGROUP_SUPER_MAGIC = 0x27e0eb | Cgroup pseudo FS
---|2613483
---CGROUP2_SUPER_MAGIC = 0x63677270 | Cgroup v2 pseudo FS
---|1667723888
---CIFS_MAGIC_NUMBER = 0xff534d42
---|4283649346
---CODA_SUPER_MAGIC = 0x73757245
---|1937076805
---COH_SUPER_MAGIC = 0x012ff7b7
---|19920823
---CRAMFS_MAGIC = 0x28cd3d45
---|684539205
---DEBUGFS_MAGIC = 0x64626720
---|1684170528
---DEVFS_SUPER_MAGIC = 0x1373 | Linux 2.6.17 and earlier
---|4979
---DEVPTS_SUPER_MAGIC =	0x1cd1
---|7377
---ECRYPTFS_SUPER_MAGIC	=	0xf15f
---|61791
---EFIVARFS_MAGIC	=	0xde5e81e4
---|3730735588
---EFS_SUPER_MAGIC =	0x00414a53
---|4278867
---EXT_SUPER_MAGIC = 0x137d | Linux 2.0 and earlier
---|4989
---EXT2_OLD_SUPER_MAGIC = 0xef51
---|61265
---EXT2_SUPER_MAGIC = 0xef53
---|61267
---EXT3_SUPER_MAGIC = 0xef53
---|61267
---EXT4_SUPER_MAGIC = 0xef53
---|61267
---F2FS_SUPER_MAGIC = 0xf2f52010
---|4076150800
---FUSE_SUPER_MAGIC = 0x65735546
---|1702057286
---FUTEXFS_SUPER_MAGIC = 0xbad1dea | Unused
---|195894762
---HFS_SUPER_MAGIC = 0x4244
---|16964
---HOSTFS_SUPER_MAGIC = 0x00c0ffee
---|12648430
---HPFS_SUPER_MAGIC = 0xf995e849
---|4187351113
---HUGETLBFS_MAGIC = 0x958458f6
---|2508478710
---ISOFS_SUPER_MAGIC = 0x9660
---|38496
---JFFS2_SUPER_MAGIC = 0x72b6
---|29366
---JFS_SUPER_MAGIC = 0x3153464a
---|827541066
---MINIX_SUPER_MAGIC = 0x137f | original minix FS
---|4991
---MINIX_SUPER_MAGIC2 = 0x138f | 30 char minix FS
---|5007
---MINIX2_SUPER_MAGIC = 0x2468 | minix V2 FS
---|9320
---MINIX2_SUPER_MAGIC2 = 0x2478 | minix V2 FS, 30 char names
---|9336
---MINIX3_SUPER_MAGIC = 0x4d5a | minix V3 FS, 60 char names
---|19802
---MQUEUE_MAGIC = 0x19800202 | POSIX message queue FS
---|427819522
---MSDOS_SUPER_MAGIC = 0x4d44
---|19780
---MTD_INODE_FS_MAGIC = 0x11307854
---|288389204
---NCP_SUPER_MAGIC = 0x564c
---|22092
---NFS_SUPER_MAGIC = 0x6969
---|26985
---NILFS_SUPER_MAGIC = 0x3434
---|13364
---NSFS_MAGIC = 0x6e736673
---|1853056627
---NTFS_SB_MAGIC = 0x5346544e
---|1397118030
---OCFS2_SUPER_MAGIC = 0x7461636f
---|1952539503
---OPENPROM_SUPER_MAGIC = 0x9fa1
---|40865
---OVERLAYFS_SUPER_MAGIC = 0x794c7630
---|2035054128
---PIPEFS_MAGIC = 0x50495045
---|1346981957
---PROC_SUPER_MAGIC = 0x9fa0 | /proc FS
---|40864
---PSTOREFS_MAGIC = 0x6165676c
---|1634035564
---QNX4_SUPER_MAGIC = 0x002f
---|47
---QNX6_SUPER_MAGIC = 0x68191122
---|1746473250
---RAMFS_MAGIC = 0x858458f6
---|2240043254
---REISERFS_SUPER_MAGIC = 0x52654973
---|1382369651
---ROMFS_MAGIC = 0x7275
---|29301
---SECURITYFS_MAGIC = 0x73636673
---|1935894131
---SELINUX_MAGIC = 0xf97cff8c
---|4185718668
---SMACK_MAGIC = 0x43415d53
---|1128357203
---SMB_SUPER_MAGIC = 0x517b
---|20859
---SMB2_MAGIC_NUMBER = 0xfe534d42
---|4266872130
---SOCKFS_MAGIC = 0x534f434b
---|1397703499
---SQUASHFS_MAGIC = 0x73717368
---|1936814952
---SYSFS_MAGIC = 0x62656572
---|1650812274
---SYSV2_SUPER_MAGIC = 0x012ff7b6
---|19920822
---SYSV4_SUPER_MAGIC = 0x012ff7b5
---|19920821
---TMPFS_MAGIC = 0x01021994
---|16914836
---TRACEFS_MAGIC = 0x74726163
---|1953653091
---UDF_SUPER_MAGIC = 0x15013346
---|352400198
---UFS_MAGIC = 0x00011954
---|72020
---USBDEVICE_SUPER_MAGIC = 0x9fa2
---|40866
---V9FS_MAGIC = 0x01021997
---|16914839
---VXFS_SUPER_MAGIC = 0xa501fcf5
---|2768370933
---XENFS_SUPER_MAGIC = 0xabba1974
---|2881100148
---XENIX_SUPER_MAGIC = 0x012ff7b4
---|19920820
---XFS_SUPER_MAGIC = 0x58465342
---|1481003842
---_XIAFS_SUPER_MAGIC = 0x012fd16d | Linux 2.0 and earlier
---|19911021

---@alias uv.aliases.fs_statfs_stats {type: uv.aliases.fs_statfs_stats_type, bzise: integer, blocks: integer, bfree: integer, bavail: integer, files: integer, ffree: integer}

---
---Equivalent to `close(2)`.
---
---@param fd integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_close(fd, callback) end
---@param fd integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_close(fd) end

---
---Equivalent to `open(2)`.
---See below for available access `flags`.
---
---**Note:** On Windows, libuv uses `CreateFileW` and thus the file is always
---opened in binary mode. Because of this, the `O_BINARY` and `O_TEXT` flags are
---not supported.
---
---@param path string
---@param flags uv.aliases.fs_access_flags|integer
---@param mode integer
---@param callback fun(err: nil|string, fd: integer|nil)
---@return uv_fs_t
function uv.fs_open(path, flags, mode, callback) end
---@param path string
---@param flags uv.aliases.fs_access_flags|integer
---@param mode integer
---@return integer|nil fd, string? err_name, string? err_msg
---@nodiscard
function uv.fs_open(path, flags, mode) end

---
---Equivalent to `preadv(2)`. Returns any data. An empty string indicates EOF.
---
---If `offset` is nil or omitted, it will default to `-1`, which indicates 'use and update the current file offset.'
---
---**Note:** When `offset` is >= 0, the current file offset will not be updated by the read.
---
---@param fd integer
---@param size integer
---@param offset integer|nil
---@param callback fun(err: nil|string, data: string|nil)
---@return uv_fs_t
function uv.fs_read(fd, size, offset, callback) end
---@param fd integer
---@param size integer
---@param callback fun(err: nil|string, data: string|nil)
---@return uv_fs_t
function uv.fs_read(fd, size, callback) end
---@param fd integer
---@param size integer
---@param offset integer|nil
---@return string|nil data, string? err_name, string? err_msg
---@nodiscard
function uv.fs_read(fd, size, offset) end

---
---Equivalent to `unlink(2)`.
---
---@param path string
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_unlink(path, callback) end
---@param path string
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_unlink(path) end

---
---Equivalent to `pwritev(2)`. Returns the number of bytes written.
---
---If `offset` is nil or omitted, it will default to `-1`, which indicates 'use and update the current file offset.'
---
---**Note:** When `offset` is >= 0, the current file offset will not be updated by the write.
---
---@param fd integer
---@param data uv.aliases.buffer
---@param offset integer|nil
---@param callback fun(err: nil|string, bytes: integer|nil)
---@return uv_fs_t
function uv.fs_write(fd, data, offset, callback) end
---@param fd integer
---@param data uv.aliases.buffer
---@param callback fun(err: nil|string, bytes: integer|nil)
---@return uv_fs_t
function uv.fs_write(fd, data, callback) end
---@param fd integer
---@param data uv.aliases.buffer
---@param offset integer|nil
---@return integer|nil bytes, string? err_name, string? err_msg
function uv.fs_write(fd, data, offset) end

---
---Equivalent to `mkdir(2)`.
---
---@param path string
---@param mode integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_mkdir(path, mode, callback) end
---@param path string
---@param mode integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_mkdir(path, mode) end

---
---Equivalent to `mkdtemp(3)`.
---
---@param template string
---@param callback fun(err: nil|string, path: string|nil)
---@return uv_fs_t
function uv.fs_mkdtemp(template, callback) end
---@param template string
---@return string|nil path, string? err_name, string? err_msg
---@nodiscard
function uv.fs_mkdtemp(template) end

---
---Equivalent to `mkstemp(3)`. Returns a temporary file handle and filename.
---
---@param template string
---@param callback fun(err: nil|string, fd: integer|nil, path: string|nil)
---@return uv_fs_t
function uv.fs_mkstemp(template, callback) end
---@param template string
---@return integer|nil fd, string path_or_errname, string? err_msg
---@nodiscard
function uv.fs_mkstemp(template) end

---
---Equivalent to `rmdir(2)`.
---
---@param path string
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_rmdir(path, callback) end
---@param path string
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_rmdir(path) end

---
---Equivalent to `scandir(3)`, with a slightly different API. Returns a handle that
---the user can pass to `uv.fs_scandir_next()`.
---
---**Note:** This function can be used synchronously or asynchronously. The request
---userdata is always synchronously returned regardless of whether a callback is
---provided and the same userdata is passed to the callback if it is provided.
---
---@param path string
---@param callback fun(err: nil|string, success: uv_fs_t|nil)
---@return uv_fs_t|nil, string? err_name, string? err_msg
function uv.fs_scandir(path, callback) end
---@param path string
---@return uv_fs_t|nil success, string? err_name, string? err_msg
---@nodiscard
function uv.fs_scandir(path) end

---
---Called on a `uv_fs_t` returned by `uv.fs_scandir()` to get the next directory
---entry data as a `name, type` pair. When there are no more entries, `nil` is
---returned.
---
---**Note:** This function only has a synchronous version. See `uv.fs_opendir` and
---its related functions for an asynchronous version.
---
---@param fs uv_fs_t
---@return string|nil, string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.fs_scandir_next(fs) end

---
---Equivalent to `stat(2)`.
---
---@param path string
---@param callback fun(err: nil|string, stat: uv.aliases.fs_stat_table|nil)
---@return uv_fs_t
function uv.fs_stat(path, callback) end
---@param path string
---@return uv.aliases.fs_stat_table|nil stat, string? err_name, string? err_msg
---@nodiscard
function uv.fs_stat(path) end

---
---Equivalent to `fstat(2)`.
---
---@param fd integer
---@param callback fun(err: nil|string, stat: uv.aliases.fs_stat_table|nil)
---@return uv_fs_t
function uv.fs_fstat(fd, callback) end
---@param fd integer
---@return uv.aliases.fs_stat_table|nil stat, string? err_name, string? err_msg
---@nodiscard
function uv.fs_fstat(fd) end

---
---Equivalent to `lstat(2)`.
---
---@param fd integer
---@param callback fun(err: nil|string, stat: uv.aliases.fs_stat_table|nil)
---@return uv_fs_t
function uv.fs_lstat(fd, callback) end
---@param fd integer
---@return uv.aliases.fs_stat_table|nil stat, string? err_name, string? err_msg
---@nodiscard
function uv.fs_lstat(fd) end

---
---Equivalent to `rename(2)`.
---
---@param path string
---@param new_path string
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_rename(path, new_path, callback) end
---@param path string
---@param new_path string
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_rename(path, new_path) end

---
---Equivalent to `fsync(2)`.
---
---@param fd integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_fsync(fd, callback) end
---@param fd integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_fsync(fd) end

---
---Equivalent to `fdatasync(2)`.
---
---@param fd integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_fdatasync(fd, callback) end
---@param fd integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_fdatasync(fd) end

---
---Equivalent to `ftruncate(2)`.
---
---@param fd integer
---@param offset integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_ftruncate(fd, offset, callback) end
---@param fd integer
---@param offset integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_ftruncate(fd, offset) end

---
---Limited equivalent to `sendfile(2)`. Returns the number of bytes written.
---
---@param out_fd integer
---@param in_fd integer
---@param in_offset integer
---@param size integer
---@param callback fun(err: nil|string, bytes: integer|nil)
---@return uv_fs_t
function uv.fs_sendfile(out_fd, in_fd, in_offset, size, callback) end
---@param out_fd integer
---@param in_fd integer
---@param in_offset integer
---@param size integer
---@return integer|nil bytes, string? err_name, string? err_msg
function uv.fs_sendfile(out_fd, in_fd, in_offset, size) end

---
---Equivalent to `access(2)` on Unix. Windows uses `GetFileAttributesW()`. Access
---`mode` can be an integer or a string containing `"R"` or `"W"` or `"X"`.
---
---Returns `true` or `false` indicating access permission.
---
---@param path string
---@param mode uv.aliases.fs_access_mode|integer
---@param callback fun(err: nil|string, permission: boolean|nil)
---@return uv_fs_t
function uv.fs_access(path, mode, callback) end
---@param path string
---@param mode uv.aliases.fs_access_mode|integer
---@return boolean|nil permission, string? err_name, string? err_msg
---@nodiscard
function uv.fs_access(path, mode) end

---
---Equivalent to `chmod(2)`.
---
---@param path string
---@param mode integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_chmod(path, mode, callback) end
---@param path string
---@param mode integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_chmod(path, mode) end

---
---Equivalent to `fchmod(2)`.
---
---@param fd integer
---@param mode integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_fchmod(fd, mode, callback) end
---@param fd integer
---@param mode integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_fchmod(fd, mode) end

---
---Equivalent to `utime(2)`.
---
---@param path string
---@param atime number
---@param mtime number
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_utime(path, atime, mtime, callback) end
---@param path string
---@param atime number
---@param mtime number
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_utime(path, atime, mtime) end

---
---Equivalent to `futime(2)`.
---
---@param fd integer
---@param atime number
---@param mtime number
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_futime(fd, atime, mtime, callback) end
---@param fd integer
---@param atime number
---@param mtime number
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_futime(fd, atime, mtime) end

---
---Equivalent to `lutime(2)`.
---
---@param path string
---@param atime number
---@param mtime number
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_lutime(path, atime, mtime, callback) end
---@param path string
---@param atime number
---@param mtime number
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_lutime(path, atime, mtime) end

---
---Equivalent to `link(2)`.
---
---@param path string
---@param new_path string
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_link(path, new_path, callback) end
---@param path string
---@param new_path string
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_link(path, new_path) end

---
---Equivalent to `symlink(2)`.
---If the `flags` parameter is omitted, then the 3rd parameter will be treated as the `callback`.
---
---@param path string
---@param new_path string
---@param flags uv.aliases.fs_symlink_flags|integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_symlink(path, new_path, flags, callback) end
---@param path string
---@param new_path string
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_symlink(path, new_path, callback) end
---@param path string
---@param new_path string
---@param flags? uv.aliases.fs_symlink_flags|integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_symlink(path, new_path, flags) end

---
---Equivalent to `readlink(2)`.
---
---@param path string
---@param callback fun(err: nil|string, path: string|nil)
---@return uv_fs_t
function uv.fs_readlink(path, callback) end
---@param path string
---@return string|nil path, string? err_name, string? err_msg
---@nodiscard
function uv.fs_readlink(path) end

---
---Equivalent to `realpath(3)`.
---
---@param path string
---@param callback fun(err: nil|string, path: string|nil)
---@return uv_fs_t
function uv.fs_realpath(path, callback) end
---@param path string
---@return string|nil path, string? err_name, string? err_msg
---@nodiscard
function uv.fs_realpath(path) end

---
---Equivalent to `chown(2)`.
---
---@param path string
---@param uid integer
---@param gid integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_chown(path, uid, gid, callback) end
---@param path string
---@param uid integer
---@param gid integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_chown(path, uid, gid) end

---
---Equivalent to `fchown(2)`.
---
---@param fd integer
---@param uid integer
---@param gid integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_fchown(fd, uid, gid, callback) end
---@param fd integer
---@param uid integer
---@param gid integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_fchown(fd, uid, gid) end

---
---Equivalent to `lchown(2)`.
---
---@param fd integer
---@param uid integer
---@param gid integer
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_lchown(fd, uid, gid, callback) end
---@param fd integer
---@param uid integer
---@param gid integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_lchown(fd, uid, gid) end

---
---Copies a file from `path` to `new_path`.
---If the `flags` parameter is omitted, then the 3rd parameter will be treated as the `callback`.
---
---@param path string
---@param new_path string
---@param flags uv.aliases.fs_copyfile_flags
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_copyfile(path, new_path, flags, callback) end
---@param path string
---@param new_path string
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_copyfile(path, new_path, callback) end
---@param path string
---@param new_path string
---@param flags? uv.aliases.fs_copyfile_flags
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_copyfile(path, new_path, flags) end

---
---Opens path as a directory stream. Returns a handle that the user can pass to
---`uv.fs_readdir()`. The `entries` parameter defines the maximum number of entries
---that should be returned by each call to `uv.fs_readdir()`.
---
---@param path string
---@param entries integer|nil
---@param callback fun(err: nil|string, dir: luv_dir_t|nil)
---@return uv_fs_t
function uv.fs_opendir(path, entries, callback) end
---@param path string
---@param entries integer|nil
---@return luv_dir_t|nil dir, string? err_name, string? err_msg
---@nodiscard
function uv.fs_opendir(path, entries) end

---
---Iterates over the directory stream `uv_dir_t` returned by a successful
---`uv.fs_opendir()` call. A table of data tables is returned where the number
---of entries `n` is equal to or less than the `entries` parameter used in
---the associated `uv.fs_opendir()` call.
---
---@param dir luv_dir_t
---@param callback fun(err: nil|string, entries: uv.aliases.fs_readdir_entries|nil)
---@return uv_fs_t
function uv.fs_readdir(dir, callback) end
---@param dir luv_dir_t
---@return uv.aliases.fs_readdir_entries|nil entries, string? err_name, string? err_msg
---@nodiscard
function uv.fs_readdir(dir) end
luv_dir_t.readdir = uv.fs_readdir

---
---Closes a directory stream returned by a successful `uv.fs_opendir()` call.
---
---@param dir luv_dir_t
---@param callback fun(err: nil|string, success: boolean|nil)
---@return uv_fs_t
function uv.fs_closedir(dir, callback) end
---@param dir luv_dir_t
---@return boolean|nil success, string? err_name, string? err_msg
function uv.fs_closedir(dir) end
luv_dir_t.closedir = uv.fs_closedir

---
---Equivalent to `statfs(2)`.
---
---@param path string
---@param callback fun(err: nil|string, stats: uv.aliases.fs_statfs_stats|nil)
---@return uv_fs_t
function uv.fs_statfs(path, callback) end
---@param path string
---@return uv.aliases.fs_statfs_stats|nil stats, string? err_name, string? err_msg
---@nodiscard
function uv.fs_statfs(path) end



---
---Libuv provides a threadpool which can be used to run user code and get notified
---in the loop thread. This threadpool is internally used to run all file system
---operations, as well as `getaddrinfo` and `getnameinfo` requests.
---
---```lua
---local function work_callback(a, b)
---  return a + b
---end
---
---local function after_work_callback(c)
---  print("The result is: " .. c)
---end
---
---local work = uv.new_work(work_callback, after_work_callback)
---
---work:queue(1, 2)
---
----- output: "The result is: 3"
---```
---
---@class luv_work_ctx_t: userdata
---@section Thread pool work scheduling
local luv_work_ctx_t = {}

---
---Creates and initializes a new `luv_work_ctx_t` (not `uv_work_t`).
---`work_callback` is a Lua function or a string containing Lua code or bytecode dumped from a function.
---Returns the Lua userdata wrapping it.
---
---@generic T: uv.aliases.threadargs
---@param work_callback fun(...: T)|string # passed to/from `uv.queue_work(work_ctx, ...)`
---@param after_work_callback fun(...: uv.aliases.threadargs) # returned from `work_callback`
---@return luv_work_ctx_t
---@nodiscard
function uv.new_work(work_callback, after_work_callback) end

-- TODO: make sure that the above method can indeed return nil + error.

---
---Queues a work request which will run `work_callback` in a new Lua state in a
---thread from the threadpool with any additional arguments from `...`. Values
---returned from `work_callback` are passed to `after_work_callback`, which is
---called in the main loop thread.
---
---@param work_ctx luv_work_ctx_t
---@param ... uv.aliases.threadargs
---@return boolean|nil success, string? err_name, string? err_msg
function uv.queue_work(work_ctx, ...) end
luv_work_ctx_t.queue = uv.queue_work



---
---@section DNS utility functions
---

---@class uv_getaddrinfo_t: uv_req_t

---@alias uv.aliases.getaddrinfo_hint {family: uv.aliases.network_family|integer|nil, socktype: uv.aliases.tcp_socket_type|nil, protocol: uv.aliases.network_protocols|nil, addrconfig: boolean|nil, v4mapped: boolean|nil, all: boolean|nil, numberichost: boolean|nil, passive: boolean|nil, numericserv: boolean|nil, canonname: boolean|nil}

---@alias uv.aliases.getaddrinfo_rtn {addr: string, family: uv.aliases.network_family, port: integer|nil, socktype: uv.aliases.tcp_socket_type, protocol: uv.aliases.network_protocols, canonname: string|nil}[]

---@class uv_getnameinfo_t: uv_req_t

---@alias uv_getnameinfo_address {ip: string|nil, port: integer|nil, family: uv.aliases.network_family|integer|nil}

---
---Equivalent to `getaddrinfo(3)`.
---Either `host` or `service` may be `nil` but not both.
---
---@param host string|nil
---@param service string|nil
---@param hints uv.aliases.getaddrinfo_hint?
---@param callback fun(err?: string, addresses?: uv.aliases.getaddrinfo_rtn)
---@return uv_getaddrinfo_t
function uv.getaddrinfo(host, service, hints, callback) end
---@param host string|nil
---@param service string|nil
---@param hints uv.aliases.getaddrinfo_hint?
---@return uv.aliases.getaddrinfo_rtn|nil addresses, string? err_name, string? err_msg
function uv.getaddrinfo(host, service, hints) end

---
---Equivalent to `getnameinfo(3)`.
---
---@param address uv_getnameinfo_address
---@param callback fun(err?: string, host?: string, service?: string)
---@return uv_getnameinfo_t
function uv.getnameinfo(address, callback) end
---@param address uv_getnameinfo_address
---@return string|nil host, string service_or_errname, string? err_msg
function uv.getnameinfo(address) end



---
---Libuv provides cross-platform implementations for multiple threading an
--- synchronization primitives. The API largely follows the pthreads API.
---
---@class luv_thread_t: userdata
---@section Threading and synchronization utilities
local luv_thread_t = {}

---
---Creates and initializes a `luv_thread_t` (not `uv_thread_t`). Returns the Lua
---userdata wrapping it and asynchronously executes `entry`, which can be
---either a Lua function or a string containing Lua code or bytecode dumped from a function. Additional arguments `...`
---are passed to the `entry` function and an optional `options` table may be
---provided. Currently accepted `option` fields are `stack_size`.
---
---@generic T: uv.aliases.threadargs
---@param options? {stack_size?: integer}
---@param entry fun(...: T)|string
---@vararg T # varargs passed to `entry`
---@return luv_thread_t?, string? err_name, string? err_msg
function uv.new_thread(options, entry, ...) end
---@generic T: uv.aliases.threadargs
---@param entry fun(...: T)|string
---@vararg T # varargs passed to `entry`
---@return luv_thread_t?, string? err_name, string? err_msg
function uv.new_thread(entry, ...) end

-- TODO: make sure that the above method can indeed return nil + error.

---
---Returns a boolean indicating whether two threads are the same. This function is
---equivalent to the `__eq` metamethod.
---
---@param thread luv_thread_t
---@param other_thread luv_thread_t
---@return boolean
function uv.thread_equal(thread, other_thread) end
luv_thread_t.equal = uv.thread_equal

---
---Returns the handle for the thread in which this is called.
---
---@return luv_thread_t
function uv.thread_self() end

---
---Waits for the `thread` to finish executing its entry function.
---
---@param thread luv_thread_t
---@return boolean?, string? err_name, string? err_msg
function uv.thread_join(thread) end
luv_thread_t.join = uv.thread_join

---
---Pauses the thread in which this is called for a number of milliseconds.
---
---@param msec integer
function uv.sleep(msec) end



---
---@section Miscellaneous utilities
---@source misc.c
---

---@alias uv.aliases.os_passwd {username: string, uid: integer, gid: integer, shell: string, homedir: string}

---@alias uv.aliases.os_uname {sysname: string, release: string, version: string, machine: string}

---@alias uv.aliases.rusage {utime: {sec: integer, usec: integer}, stime: {sec: integer, usec: integer}, maxrss: integer, ixrss: integer, idrss: integer, isrss: integer, minflt: integer, majflt: integer, nswap: integer, inblock: integer, oublock: integer, msgsnd: integer, msgrcv: integer, nsignals: integer, nvcsw: integer, nivcsw: integer}

---@alias uv.aliases.cpu_info {[integer]: {modal: string, speed: number, times: {user: number, nice: number, sys: number, idle: number, irq: number}}}

---@alias uv.aliases.interface_addresses {[string]: {ip: string, family: uv.aliases.network_family, netmask: string, internal: boolean, mac: string}}

---
---Returns the executable path.
---
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.exepath() end

---
---Returns the current working directory.
---
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.cwd() end

---
---Sets the current working directory with the string `cwd`.
---
---@param cwd string
---@return 0|nil success, string? err_name, string? err_msg
function uv.chdir(cwd) end

---
---Returns the title of the current process.
---
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.get_process_title() end

---
---Sets the title of the current process with the string `title`.
---
---@param title string
---@return 0|nil success, string? err_name, string? err_msg
function uv.set_process_title(title) end

---
---Returns the current total system memory in bytes.
---
---@return integer
---@nodiscard
function uv.get_total_memory() end

---
---Returns the current free system memory in bytes.
---
---@return integer
---@nodiscard
function uv.get_free_memory() end

---
---Gets the amount of memory available to the process in bytes based on limits
---imposed by the OS. If there is no such constraint, or the constraint is unknown,
---0 is returned. Note that it is not unusual for this value to be less than or
---greater than the total system memory.
---
---@return integer
---@nodiscard
function uv.get_constrained_memory() end

---
---Returns the resident set size (RSS) for the current process.
---
---@return integer|nil, string? err_name, string? err_msg
---@nodiscard
function uv.resident_set_memory() end

---
---Returns the resource usage.
---
---@return uv.aliases.rusage|nil, string? err_name, string? err_msg
---@nodiscard
function uv.getrusage() end

---
---Returns an estimate of the default amount of parallelism a program should use. Always returns a non-zero value.
---
---On Linux, inspects the calling thread’s CPU affinity mask to determine if it has been pinned to specific CPUs.
---
---On Windows, the available parallelism may be underreported on systems with more than 64 logical CPUs.
---
---On other platforms, reports the number of CPUs that the operating system considers to be online.
---
---@return integer
---@nodiscard
function uv.available_parallelism() end

---
---Returns information about the CPU(s) on the system as a table of tables for each
---CPU found.
---
---@return uv.aliases.cpu_info|nil, string? err_name, string? err_msg
---@nodiscard
function uv.cpu_info() end

---
---**Deprecated:** Please use `uv.os_getpid()` instead.
---
---@return integer
---@nodiscard
---@deprecated
function uv.getpid() end

---
---Returns the user ID of the process.
---
---**Note:** This is not a libuv function and is not supported on Windows.
---
---@return integer
---@nodiscard
function uv.getuid() end

---
---Returns the group ID of the process.
---
---**Note:** This is not a libuv function and is not supported on Windows.
---
---@return integer
---@nodiscard
function uv.getgid() end

---
---Sets the user ID of the process with the integer `id`.
---
---**Note:** This is not a libuv function and is not supported on Windows.
---
---@param id integer
function uv.setuid(id) end

---
---Sets the group ID of the process with the integer `id`.
---
---**Note:** This is not a libuv function and is not supported on Windows.
---
---@param id integer
function uv.setgid(id) end

---
---Returns a current high-resolution time in nanoseconds as a number. This is
---relative to an arbitrary time in the past. It is not related to the time of day
---and therefore not subject to clock drift. The primary use is for measuring
---time between intervals.
---
---@return integer
---@nodiscard
function uv.hrtime() end

---
---Returns the current system uptime in seconds.
---
---@return number|nil, string? err_name, string? err_msg
---@nodiscard
function uv.uptime() end

---
---Prints all handles associated with the main loop to stderr. The format is
---`[flags] handle-type handle-address`. Flags are `R` for referenced, `A` for
---active and `I` for internal.
---
---**Note:** This is not available on Windows.
---
---**Warning:** This function is meant for ad hoc debugging, there are no API/ABI
---stability guarantees.
---
function uv.print_all_handles() end

---
---The same as `uv.print_all_handles()` except only active handles are printed.
---
---**Note:** This is not available on Windows.
---
---**Warning:** This function is meant for ad hoc debugging, there are no API/ABI
---stability guarantees.
---
function uv.print_active_handles() end

---
---Used to detect what type of stream should be used with a given file
---descriptor `fd`. Usually this will be used during initialization to guess the
---type of the stdio streams.
---
---@param fd integer
---@return uv.aliases.handle_struct_name|nil
---@nodiscard
function uv.guess_handle(fd) end

---
---Cross-platform implementation of `gettimeofday(2)`. Returns the seconds and
---microseconds of a unix time as a pair.
---
---@return integer|nil, integer|string, string?
---@nodiscard
function uv.gettimeofday() end

---
---Returns address information about the network interfaces on the system in a
---table. Each table key is the name of the interface while each associated value
---is an array of address information where fields are `ip`, `family`, `netmask`,
---`internal`, and `mac`.
---
---@return uv.aliases.interface_addresses
---@nodiscard
function uv.interface_addresses() end

---
---IPv6-capable implementation of `if_indextoname(3)`.
---
---@param ifindex integer
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.if_indextoname(ifindex) end

---
---Retrieves a network interface identifier suitable for use in an IPv6 scoped
---address. On Windows, returns the numeric `ifindex` as a string. On all other
---platforms, `uv.if_indextoname()` is used.
---
---@param ifindex integer
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.if_indextoiid(ifindex) end

---
---Returns the load average as a triad. Not supported on Windows.
---
---@return number, number, number
---@nodiscard
function uv.loadavg() end

---
---Returns system information.
---
---@return uv.aliases.os_uname
---@nodiscard
function uv.os_uname() end

---
---Returns the hostname.
---
---@return string
---@nodiscard
function uv.os_gethostname() end

---
---Returns the environment variable specified by `name` as string. The internal
---buffer size can be set by defining `size`. If omitted, `LUAL_BUFFERSIZE` is
---used. If the environment variable exceeds the storage available in the internal
---buffer, `ENOBUFS` is returned. If no matching environment variable exists,
---`ENOENT` is returned.
---
---**Warning:** This function is not thread safe.
---
---@param name string
---@param size integer # (default = `LUAL_BUFFERSIZE`)
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.os_getenv(name, size) end

---
---Sets the environmental variable specified by `name` with the string `value`.
---
---**Warning:** This function is not thread safe.
---
---@param name string
---@param value string
---@return boolean|nil success, string? err_name, string? err_msg
function uv.os_setenv(name, value) end

---
---**Warning:** This function is not thread safe.
---
---@return boolean|nil success, string? err_name, string? err_msg
function uv.os_unsetenv() end

---
---Returns all environmental variables as a dynamic table of names associated with
---their corresponding values.
---
---**Warning:** This function is not thread safe.
---
---@return {[string]: string}
---@nodiscard
function uv.os_environ() end

---
---**Warning:** This function is not thread safe.
---
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.os_homedir() end

---
---**Warning:** This function is not thread safe.
---
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.os_tmpdir() end

---
---Returns password file information.
---
---@return uv.aliases.os_passwd
---@nodiscard
function uv.os_get_passwd() end

---
---Returns the current process ID.
---
---@return integer
---@nodiscard
function uv.os_getpid() end

---
---Returns the parent process ID.
---
---@return integer
---@nodiscard
function uv.os_getppid() end

---
---Returns the scheduling priority of the process specified by `pid`.
---
---@param pid integer
---@return integer|nil, string? err_name, string? err_msg
---@nodiscard
function uv.os_getpriority(pid) end

---
---Sets the scheduling priority of the process specified by `pid`. The `priority`
---range is between -20 (high priority) and 19 (low priority).
---
---@param pid integer
---@param priority integer
---@return boolean|nil success, string? err_name, string? err_msg
function uv.os_setpriority(pid, priority) end

---
---Fills a string of length `len` with cryptographically strong random bytes
---acquired from the system CSPRNG. `flags` is reserved for future extension
---and must currently be `nil` or `0` or `{}`.
---
---Short reads are not possible. When less than `len` random bytes are available,
---a non-zero error value is returned or passed to the callback. If the callback
---is omitted, this function is completed synchronously.
---The synchronous version may block indefinitely when not enough entropy is
---available. The asynchronous version may not ever finish when the system is
---low on entropy.
---
---@param len integer
---@param flags nil|0|{}
---@param callback fun(err?: string, bytes?: string)
---@return 0|nil success, string? err_name, string? err_msg
function uv.random(len, flags, callback) end
---@param len integer
---@param flags nil|0|{}
---@return string|nil, string? err_name, string? err_msg
---@nodiscard
function uv.random(len, flags) end

---
---Returns the libuv error message and error name (both in string form, see `err` and `name` in Error Handling) equivalent to the given platform dependent error code: POSIX error codes on Unix (the ones stored in errno), and Win32 error codes on Windows (those returned by GetLastError() or WSAGetLastError()).
---
---@param errcode integer
---@return string|nil, string|nil
---@source util.c
---@nodiscard
function uv.translate_sys_error(errcode) end



---
---@section Metrics operations
---@source metrics.c
---

---
---Retrieve the amount of time the event loop has been idle in the kernel’s event
---provider (e.g. `epoll_wait`). The call is thread safe.
---
---The return value is the accumulated time spent idle in the kernel’s event
---provider starting from when the `uv_loop_t` was configured to collect the idle time.
---
---**Note:** The event loop will not begin accumulating the event provider’s idle
---time until calling `loop_configure` with `"metrics_idle_time"`.
---
---@return integer
---@nodiscard
function uv.metrics_idle_time() end



-- [[ constants ]]

-- TODO: make this its own section
-- TODO: how should this be reflected onto docs? field descriptions?

---@alias uv.constants {O_RDONLY: integer, O_WRONLY: integer, O_RDWR: integer, O_APPEND: integer, O_CREAT: integer, O_DSYNC: integer, O_EXCL: integer, O_NOCTTY: integer, O_NONBLOCK: integer, O_RSYNC: integer, O_SYNC: integer, O_TRUNC: integer, SOCK_STREAM: integer, SOCK_DGRAM: integer, SOCK_SEQPACKET: integer, SOCK_RAW: integer, SOCK_RDM: integer, AF_UNIX: integer, AF_INET: integer, AF_INET6: integer, AF_IPX: integer, AF_NETLINK: integer, AF_X25: integer, AF_AX25: integer, AF_ATMPVC: integer, AF_APPLETALK: integer, AF_PACKET: integer, AI_ADDRCONFIG: integer, AI_V4MAPPED: integer, AI_ALL: integer, AI_NUMERICHOST: integer, AI_PASSIVE: integer, AI_NUMERICSERV: integer, SIGHUP: integer, SIGINT: integer, SIGQUIT: integer, SIGILL: integer, SIGTRAP: integer, SIGABRT: integer, SIGIOT: integer, SIGBUS: integer, SIGFPE: integer, SIGKILL: integer, SIGUSR1: integer, SIGSEGV: integer, SIGUSR2: integer, SIGPIPE: integer, SIGALRM: integer, SIGTERM: integer, SIGCHLD: integer, SIGSTKFLT: integer, SIGCONT: integer, SIGSTOP: integer, SIGTSTP: integer, SIGTTIN: integer, SIGWINCH: integer, SIGIO: integer, SIGPOLL: integer, SIGXFSZ: integer, SIGVTALRM: integer, SIGPROF: integer, UDP_RECVMMSG: integer, UDP_MMSG_CHUNK: integer, UDP_REUSEADDR: integer, UDP_PARTIAL: integer, UDP_IPV6ONLY: integer, TCP_IPV6ONLY: integer, UDP_MMSG_FREE: integer, SIGSYS: integer, SIGPWR: integer, SIGTTOU: integer, SIGURG: integer, SIGXCPU: integer}

---@type uv.constants
uv.constants = {}

return uv
