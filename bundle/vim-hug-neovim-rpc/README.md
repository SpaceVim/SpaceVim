
# vim-hug-neovim-rpc

This is an **experimental project**, trying to build a compatibility layer for
[neovim rpc client](https://github.com/neovim/python-client) working on vim8.
I started this project because I want to fix the [vim8
support](https://github.com/roxma/nvim-completion-manager/issues/14) issue for
[nvim-completion-manager](https://github.com/roxma/nvim-completion-manager).

Since this is a general purpose module, other plugins needing rpc support may
benefit from this project. However, there're many neovim rpc methods I haven't
implemented yet, which make this an experimental plugin. **Please fork and
open a PR if you get any idea on improving it**.

***Tip: for porting neovim rplugin to vim8, you might need
[roxma/nvim-yarp](https://github.com/roxma/nvim-yarp)***

![screencast](https://cloud.githubusercontent.com/assets/4538941/23102626/9e1bd928-f6e7-11e6-8fa2-2776f70819d9.gif)

## Requirements


1. vim8
2. If `has('pythonx')` and `set pyxversion=3`
    - same requirements as `4. has('python3')`
2. Else if `has('pythonx')` and `set pyxversion=2`
    - same requirements as `5. has('python')`
4. Else if `has('python3')`
    - [pynvim](https://github.com/neovim/pynvim)
    - Pynvim is normally installed by `:py3 import pip; pip.main(['install',
        '--user', 'pynvim'])` or `python3 -m pip install pynvim`.
    - There should be no error for at least one of `:python3 import pynvim` and
        `:python3 import neovim`
5. Else if `has('python')`
    - [pynvim](https://github.com/neovim/pynvim)
    - Pynvim is normally installed by `:py import pip; pip.main(['install',
        '--user', 'pynvim'])` or `python2 -m pip install pynvim`.
    - There should be no error for at least one of `:python3 import pynvim` and
        `:python3 import neovim`
6. `set encoding=utf-8` in your vimrc.

***Use `:echo neovim_rpc#serveraddr()` to test the installation***. It should print
something like `127.0.0.1:51359` or `/tmp/vmrUX9X/2`.

## API

| Function                                     | Similar to neovim's                            |
|----------------------------------------------|------------------------------------------------|
| `neovim_rpc#serveraddr()`                    | `v:servername`                                 |
| `neovim_rpc#jobstart(cmd,...)`               | `jobstart({cmd}[, {opts}])`                    |
| `neovim_rpc#jobstop(jobid)`                  | `jobstop({job})`                               |
| `neovim_rpc#rpcnotify(channel,event,...)`    | `rpcnotify({channel}, {event}[, {args}...])`   |
| `neovim_rpc#rpcrequest(channel, event, ...)` | `rpcrequest({channel}, {method}[, {args}...])` |

Note that `neovim_rpc#jobstart` only support these options:

- `on_stdout`
- `on_stderr`
- `on_exit`
- `detach`

## Incompatibility issues

- Cannot pass `Funcref` object to python client. Pass function name instead.
- Python `None` will be converted to `''` instead of `v:null` into vimscript.
  See [vim#2246](https://github.com/vim/vim/issues/2246)
- The following neovim-only API will be ignored quietly:
    - `nvim_buf_add_highlight`
    - `nvim_buf_clear_highlight`

## Overall Implementation

```
   "vim-hug-neovim-rpc - Sequence Diagram"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


┌───┐            ┌──────────┐                  ┌───────────┐                    ┌──────┐
│VIM│            │VIM Server│                  │NVIM Server│                    │Client│
└─┬─┘            └────┬─────┘                  └─────┬─────┘                    └──┬───┘
  │   Launch thread   │                              │                             │
  │───────────────────>                              │                             │
  │                   │                              │                             │
  │                  Launch thread                   │                             │
  │─────────────────────────────────────────────────>│                             │
  │                   │                              │                             │
  │ `ch_open` connect │                              │                             │
  │───────────────────>                              │                             │
  │                   │                              │                             │
  │                   │────┐                         │                             │
  │                   │    │ Launch VimHandler thread│                             │
  │                   │<───┘                         │                             │
  │                   │                              │                             │
  │                   │                              │           Connect           │
  │                   │                              │<─────────────────────────────
  │                   │                              │                             │
  │                   │                              ────┐
  │                   │                                  │ Launch NvimHandler thread
  │                   │                              <───┘
  │                   │                              │                             │
  │                   │                              │    Request (msgpack rpc)    │
  │                   │                              │<─────────────────────────────
  │                   │                              │                             │
  │                   │                              ────┐                         │
  │                   │                                  │ Request enqueue         │
  │                   │                              <───┘                         │
  │                   │                              │                             │
  │                   │     notify (method call)     │                             │
  │                   │ <────────────────────────────│                             │
  │                   │                              │                             │
  │ notify (json rpc) │                              │                             │
  │<───────────────────                              │                             │
  │                   │                              │                             │
  ────┐                                              │                             │
      │ Request dequeue                              │                             │
  <───┘                                              │                             │
  │                   │                              │                             │
  ────┐               │                              │                             │
      │ Process       │                              │                             │
  <───┘               │                              │                             │
  │                   │                              │                             │
  │                   │      Send response (msgpack rpc)                           │
  │────────────────────────────────────────────────────────────────────────────────>
┌─┴─┐            ┌────┴─────┐                  ┌─────┴─────┐                    ┌──┴───┐
│VIM│            │VIM Server│                  │NVIM Server│                    │Client│
└───┘            └──────────┘                  └───────────┘                    └──────┘
```

<!-- 
@startuml

title "vim-hug-neovim-rpc - Sequence Diagram"

VIM -> "VIM Server": Launch thread
VIM -> "NVIM Server": Launch thread
VIM -> "VIM Server": `ch_open` connect
"VIM Server" -> "VIM Server": Launch VimHandler thread

Client-> "NVIM Server": Connect
"NVIM Server" -> "NVIM Server": Launch NvimHandler thread
Client -> "NVIM Server": Request (msgpack rpc)
"NVIM Server" -> "NVIM Server": Request enqueue
"NVIM Server" -> "VIM Server": notify (method call)
"VIM Server" -> VIM: notify (json rpc)
VIM -> VIM: Request dequeue 
VIM -> VIM: Process
VIM -> Client: Send response (msgpack rpc)

@enduml
-->

## Debugging

Add logging settigns to your vimrc. Log files will be generated with prefix
`/tmp/nvim_log`. An alternative is to export environment variables before
starting vim/nvim.

```vim
let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
```

