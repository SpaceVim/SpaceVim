
# Yet Another Remote Plugin Framework for Neovim

This is my attempt on writing a remote plugin framework without
`:UpdateRemotePlugins`.

## Requirements

- `has('python3')`
- For Vim 8:
  - [roxma/vim-hug-neovim-rpc](https://github.com/roxma/vim-hug-neovim-rpc)
  - `g:python3_host_prog` pointed to your python3 executable, or `echo
      exepath('python3')` is not empty.
  - [pynvim](https://github.com/neovim/pynvim) (`pip3
      install pynvim`)

## Use case

- [shougo/deoplete.nvim](https://github.com/shougo/deoplete.nvim)
- [ncm2/ncm2](https://github.com/ncm2/ncm2) and most of its plugins

## Usage

pythonx/hello.py

```python
import vim, time
def greet():
    time.sleep(3)
    vim.command('echo "Hello world"')
```

plugin/hello.vim

```vim
" Create a python3 process running the hello module. The process is lazy load.
let s:hello = yarp#py3('hello')

com HelloSync call s:hello.request('greet')
com HelloAsync call s:hello.notify('greet')

" You could type :Hello greet
com -nargs=1 Hello call s:hello.request(<f-args>)
```

## Debugging

Add logging settigns to your vimrc. Log files will be generated with prefix
`/tmp/nvim_log`. An alternative is to export environment variables before
starting vim/nvim.

```vim
let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"
```

## Example for existing neovim rplugin porting to Vim 8

More realistic examples could be found at
[nvim-typescript#84](https://github.com/mhartington/nvim-typescript/pull/84),
[deoplete#553](https://github.com/Shougo/deoplete.nvim/pull/553),
[callmekohei/quickdebug](https://github.com/callmekohei/quickdebug).

Now let's consider the following simple rplugin.

After `UpdateRemotePlugins` and restarting neovim, you get `foobar` by `:echo
Bar()`.

```python
# rplugin/python3/foo.py
import pynvim

@pynvim.plugin
class Foo(object):

    def __init__(self, vim):
        self._vim = vim

    @pynvim.function("Bar", sync=True)
    def bar(self, args):
        return 'hello' + str(args)
```

For working on Vim 8, you need to add these two files:


```vim
" plugin/foo.vim
if has('nvim')
    finish
endif

let s:foo = yarp#py3('foo_wrap')

func! Bar(v)
    return s:foo.call('bar',a:v)
endfunc
```


```python
# pythonx/foo_wrap.py
from foo import Foo as _Foo
import vim

_obj = _Foo(vim)


def bar(*args):
    return _obj.bar(args)
```

How to use
```
$ vim

: echo bar('world')

hello('world',)
```
