# scrollbar.vim

> _scrollbar.vim_ is floating scrollbar plugin for vim and neovim.

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

![scrollbar](https://img.spacevim.org/scrollbar-vim.png)

<!-- vim-markdown-toc GFM -->

- [Requirements](#requirements)
- [Installation](#installation)
- [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Requirements

- Vim: `exists('*popup_create')`
- Neovim: `exists('*nvim_open_win')`

## Installation

1. Using `scrollbar.vim` in SpaceVim:

```toml
[[layers]]
  name = 'ui'
  enable_scrollbar = true
```

2. Using `scrollbar.vim` without SpaceVim:

```
Plug 'wsdjeg/scrollbar.vim'
```

## Feedback

The development of this plugin is in [`SpaceVim/bundle/scrollbar.vim`](https://github.com/SpaceVim/SpaceVim/tree/master/bundle/scrollbar.vim) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/SpaceVim/SpaceVim/issues)
