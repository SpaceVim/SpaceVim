# deoplete-jedi


[deoplete.nvim](https://github.com/Shougo/deoplete.nvim) source for [jedi](https://github.com/davidhalter/jedi).

|| **Status** |
|:---:|:---:|
| **Travis CI** |[![Build Status](https://travis-ci.org/zchee/deoplete-jedi.svg?branch=master)](https://travis-ci.org/zchee/deoplete-jedi)|
| **Gitter** |[![Join the chat at https://gitter.im/zchee/deoplete-jedi](https://badges.gitter.im/zchee/deoplete-jedi.svg)](https://gitter.im/zchee/deoplete-jedi?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)|


## Required

- Neovim and neovim/python-client
  - https://github.com/neovim/neovim
  - https://github.com/neovim/python-client

- deoplete.nvim
  - https://github.com/Shougo/deoplete.nvim

- jedi (the latest is recommended)
  - https://github.com/davidhalter/jedi


## Install

```sh
pip3 install --user jedi --upgrade
```

And

```vim
NeoBundle 'deoplete-plugins/deoplete-jedi'
# or
Plug 'deoplete-plugins/deoplete-jedi'
```

**Note:** If you don't want to use a plugin manager, you will need to clone
this repo recursively:

```
git clone --recursive https://github.com/deoplete-plugins/deoplete-jedi
```

When updating the plugin, you will want to be sure that the Jedi submodule is
kept up to date with:

```
git submodule update --init
```


## Options

- `g:deoplete#sources#jedi#statement_length`: Sets the maximum length of
  completion description text.  If this is exceeded, a simple description is
  used instead.
  Default: `50`
- `g:deoplete#sources#jedi#enable_typeinfo`: Enables type information of
  completions.  If you disable it, you will get the faster results.
  Default: `1`
- `g:deoplete#sources#jedi#enable_short_types`: Enables short completion types.
  Default: `0`
- `g:deoplete#sources#jedi#short_types_map`: Short types mapping dictionary.
  Default: `{
    'import': 'imprt',
    'function': 'def',
    'globalstmt': 'var',
    'instance': 'var',
    'statement': 'var',
    'keyword': 'keywd',
    'module': 'mod',
    'param': 'arg',
    'property': 'prop',
    'bytes': 'byte',
    'complex': 'cmplx',
    'object': 'obj',
    'mappingproxy': 'dict',
    'member_descriptor': 'cattr',
    'getset_descriptor': 'cprop',
    'method_descriptor': 'cdef',
}`
- `g:deoplete#sources#jedi#show_docstring`: Shows docstring in preview window.
  Default: `0`
- `g:deoplete#sources#jedi#python_path`: Set the Python interpreter path to use
  for the completion server.  It defaults to "python", i.e. the first available
  `python` in `$PATH`.
  **Note**: This is different from Neovim's Python (`:python`) in general.
- `g:deoplete#sources#jedi#extra_path`: A list of extra paths to add to
  `sys.path` when performing completions.
- `g:deoplete#sources#jedi#ignore_errors`: Ignore jedi errors for completions.
  Default: `0`
- `g:deoplete#sources#jedi#ignore_private_members`: Ignore private members from
  completions.
  Default: `0`


## Virtual Environments

If you are using virtualenv, it is recommended that you create environments
specifically for Neovim.  This way, you will not need to install the neovim
package in each virtualenv.  Once you have created them, add the following to
your vimrc file:

```vim
let g:python_host_prog = '/full/path/to/neovim2/bin/python'
let g:python3_host_prog = '/full/path/to/neovim3/bin/python'
```

Deoplete only requires Python 3.  See `:help provider-python` for more
information.
