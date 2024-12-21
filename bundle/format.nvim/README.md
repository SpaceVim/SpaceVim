# format.nvim

> _format.nvim_ is an asynchronous code formatting plugin based on SpaceVim job api.

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Configuration](#configuration)
- [Usage](#usage)
- [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Install

1. Using `format.nvim` in SpaceVim:

```toml
[[layers]]
  name = 'format'
  format_method = 'format.nvim'
```

2. Using `format.nvim` without SpaceVim:

```
Plug 'wsdjeg/format.nvim'
```

## Configuration

```lua
require('format').setup({
  custom_formatters = {
    lua = {
      exe = 'stylua',
      args = { '-' },
      stdin = true,
    },
  },
})
```


## Usage

- `:Format`: format current buffer

## Feedback

The development of this plugin is in [`SpaceVim/bundle/format.nvim`](https://github.com/SpaceVim/SpaceVim/tree/master/bundle/format.nvim) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/SpaceVim/SpaceVim/issues)
