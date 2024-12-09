# git.vim

> _git.vim_ is a plugin to use _git_ command in vim and neovim.

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Usage](#usage)
- [Screenshot](#screenshot)
- [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Install

1. Using `git.vim` in SpaceVim:

```toml
[[layers]]
  name = 'git'
```

2. Using `git.vim` without SpaceVim:

```
Plug 'wsdjeg/git.vim'
```

## Usage

- `:Git add %`: stage current file.
- `:Git add .`: stage all files
- `:Git commit`: edit commit message
- `:Git push`: push to remote
- `:Git pull`: pull updates from remote
- `:Git fetch`: fetch remotes
- `:Git checkout`: checkout branches
- `:Git log %`: view git log of current file
- `:Git config`: list all git config
- `:Git reflog`: manage reflog information
- `:Git branch`: list, create, or delete branches
- `:Git rebase`: rebase git commit
- `:Git diff`: view git-diff info

## Screenshot

**`:Git status`**

![git-status](https://img.spacevim.org/70063320-85efb600-1622-11ea-9aad-88d8b5b0f6d6.png)

**`:Git commit`**

![git-commit](https://img.spacevim.org/70335089-96519c00-1881-11ea-9c96-84c32566a002.png)

**`:Git push`**

![git-push](https://img.spacevim.org/70335203-d0bb3900-1881-11ea-8bf3-85b248c20dae.png)

**`:Git push`** completion

![git-push-complete](https://img.spacevim.org/70384670-7de69c00-19bd-11ea-91fe-9e8ced9775db.gif)

**`:Git diff`**

![git-diff](https://img.spacevim.org/70369625-7c52a080-18f7-11ea-9ee9-a1ba499b3d1f.png)

**`:Git log`**

![git-log](https://img.spacevim.org/70444048-39015900-1ad4-11ea-9522-1711c0c67098.png)

## Feedback

The development of this plugin is in [`SpaceVim/bundle/git.vim`](https://github.com/SpaceVim/SpaceVim/tree/master/bundle/git.vim) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/SpaceVim/SpaceVim/issues)
