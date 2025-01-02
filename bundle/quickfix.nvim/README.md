# quickfix.nvim

> _quickfix.nvim_ is a plugin which provides default key bindings for quickfix window and location list window.

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Key bindings in quickfix window](#key-bindings-in-quickfix-window)
- [Options](#options)
- [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Install

1. Using `quickfix.nvim` in SpaceVim:

```toml
[[layers]]
  name = 'core'
  enable_quickfix_key_bindings = true
```

2. Using `quickfix.nvim` without SpaceVim:

```
Plug 'wsdjeg/quickfix.nvim'
```

## Key bindings in quickfix window

| Key bindings | description                                                |
| ------------ | ---------------------------------------------------------- |
| `dd`         | remove item under cursor line in normal mode               |
| `d`          | remove selected items in visual mode                       |
| `c`          | remove items which filename match input regex              |
| `C`          | remove items which filename not match input regex          |
| `o`          | remove items which error description match input regex     |
| `O`          | remove items which error description not match input regex |
| `u`          | undo last change                                           |

## Options

- `g:quickfix_mapping_delete`: default is `dd`
- `g:quickfix_mapping_visual_delete`: default is `d`
- `g:quickfix_mapping_filter_filename`: default is `c`
- `g:quickfix_mapping_rfilter_filename`: default is `C`
- `g:quickfix_mapping_filter_text`: default is `o`
- `g:quickfix_mapping_rfilter_text`: default is `O`
- `g:quickfix_mapping_undo`: default is `u`

## Feedback

The development of this plugin is in [`SpaceVim/bundle/quickfix.nvim`](https://github.com/SpaceVim/SpaceVim/tree/master/bundle/quickfix.nvim) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/SpaceVim/SpaceVim/issues)
