# flygrep.nvim

> _flygrep.nvim_ is a plugin to searching text in neovim floating window asynchronously 

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

![Image](https://github.com/user-attachments/assets/49638d4c-4828-4d46-9c24-165102ef61a7)

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Requirements](#requirements)
- [Install](#install)
- [Command](#command)
- [Configuration](#configuration)
- [Key Bindings](#key-bindings)
- [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Intro

`flygrep.nvim` is a neovim plugin that can be used to search code asynchronously in real time. 


## Requirements

- [neovim](https://github.com/neovim/neovim): >= v0.10.0
- [ripgrep](https://github.com/BurntSushi/ripgrep): If you are using other searching tool, you need to set command option of flygrep.

## Install

- use [vim-plug](https://github.com/junegunn/vim-plug) package manager

```
Plug 'wsdjeg/flygrep.nvim'
```

## Command

- `:FlyGrep`: open flygrep in current directory

## Configuration

```lua
require('flygrep').setup({
  color_templete = {
    a = {
      fg = '#2c323c',
      bg = '#98c379',
      ctermfg = 16,
      ctermbg = 114,
      bold = true,
    },
    b = {
      fg = '#abb2bf',
      bg = '#3b4048',
      ctermfg = 145,
      ctermbg = 16,
      bold = false,
    },
  },
  timeout = 200,
  command = {
    execute = 'rg',
    default_opts = {
      '--no-heading',
      '--color=never',
      '--with-filename',
      '--line-number',
      '--column',
      '-g',
      '!.git',
    },
    recursive_opt = {},
    expr_opt = { '-e' },
    fixed_string_opt = { '-F' },
    default_fopts = { '-N' },
    smart_case = { '-S' },
    ignore_case = { '-i' },
    hidden_opt = { '--hidden' },
  },
  matched_higroup = 'IncSearch',
})
```

## Key Bindings

| Key bindings | descretion                         |
| ------------ | ---------------------------------- |
| `<Enter>`    | open cursor item                   |
| `<Tab>`      | next item                          |
| `<S-Tab>`    | previous item                      |
| `<C-s>`      | open item in split window          |
| `<C-v>`      | open item in vertical split window |
| `<C-t>`      | open item in new tabpage           |

## Feedback

The development of this plugin is in [`SpaceVim/bundle/flygrep.nvim`](https://github.com/SpaceVim/SpaceVim/tree/master/bundle/flygrep.nvim) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/SpaceVim/SpaceVim/issues)
