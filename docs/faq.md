---
title: "FAQ"
description: "A list of questions and answers relating to SpaceVim, especially those most asked in the SpaceVim community"
---

# [Home](../) >> FAQ

This is a list of the frequently asked questions about SpaceVim.

<!-- vim-markdown-toc GFM -->

- [Can I try SpaceVim without overwriting my vimrc?](#can-i-try-spacevim-without-overwriting-my-vimrc)
- [Why use toml as the default configuration file format?](#why-use-toml-as-the-default-configuration-file-format)
- [Where should I put my configuration?](#where-should-i-put-my-configuration)
- [E492: Not an editor command: ^M](#e492-not-an-editor-command-m)
- [Why SpaceVim can not display default colorscheme?](#why-spacevim-can-not-display-default-colorscheme)
- [Why can't I update plugins?](#why-cant-i-update-plugins)
- [How to enable +py and +py3 in Neovim?](#how-to-enable-py-and-py3-in-neovim)
- [Why does Vim freeze after pressing Ctrl-s?](#why-does-vim-freeze-after-pressing-ctrl-s)

<!-- vim-markdown-toc -->

### Can I try SpaceVim without overwriting my vimrc?

The SpaceVim install script will move your `~/.vimrc` to `~/.vimrc_back`. If you want to have a try SpaceVim without
overwriting your own Vim configuration you can:

Clone SpaceVim manually.

```sh
git clone https://github.com/SpaceVim/SpaceVim.git ~/.SpaceVim
```

Then, start Vim via `vim -u ~/.SpaceVim/vimrc`. You can also put this alias into your bashrc.

```sh
alias svim='vim -u ~/.SpaceVim/vimrc'
```
### Why use toml as the default configuration file format?

In the old version of SpaceVim, we used a Vim file (`init.vim`) for configuration. This introduced a lot of problems.
When loading a Vim file the file content is executed line by line. This means that when there was an error the content
before the error was still executed. This led to unforeseen problems.

We decided going forward to use a more robust configuration mechanism in SpaceVim. SpaceVim must be able to load the
whole configuration file and if there are syntax errors in the configuration file, the entire configuration needs to
be discarded.

We compared TOML, YAML, XML, and JSON. We chose TOML as the default configuration language. Here are some of the
drawbacks we found with the other choices considered:

1.  YAML: It is error-prone due to indentation being significant and when configuring transitions.
2.  XML: Vim lacks a parsing library for XML and XML is hard for humans to write.
3.  JSON: Is a good configuration format and Vim has a parsing function. However, JSON does not support comments.

### Where should I put my configuration?

SpaceVim loads custom global configuration from `~/.SpaceVim.d/init.toml`. It also supports project specific configuration.
That means it will load `.SpaceVim.d/init.toml` from the root of your project.

### E492: Not an editor command: ^M

The problem was git auto added ^M when cloning, solved by:

```sh
git config --global core.autocrlf input
```

### Why SpaceVim can not display default colorscheme?

By default, SpaceVim uses true colors, so you should make sure your terminal supports true colors. [This is an article about
what true colors are and which terminals support true colors.](https://gist.github.com/XVilka/8346728)

### Why can't I update plugins?

Sometimes you will see `Updating failed, The plugin dir is dirty`. Since the plugin dir is a git repo, if the
directory is dirty (has changes that haven't been committed to git) you can not use `git pull` to update plugin. To fix this
issue, just move your cursor to the error line, and press `gf`, then run `git reset --hard HEAD` or `git checkout .`. For
more info please read git documentation.

### How to enable +py and +py3 in Neovim?

In Neovim we can use `g:python_host_prog` and `g:python3_host_prog` to config python prog. In SpaceVim
the custom configuration file is loaded after SpaceVim core code. So in SpaceVim itself, if we using `:py` command, it may cause errors.
So we introduce two new environment variables: `PYTHON_HOST_PROG` and `PYTHON3_HOST_PROG`.

For example:

```sh
export PYTHON_HOST_PROG='/home/q/envs/neovim2/bin/python'
export PYTHON3_HOST_PROG='/home/q/envs/neovim3/bin/python'
```

### Why does Vim freeze after pressing Ctrl-s?

This is a [feature of terminal emulators](https://unix.stackexchange.com/a/137846). You can use `Ctrl-q` to unfreeze Vim. To disable
this feature you need the following in either `~/.bash_profile` or `~/.bashrc`:

```sh
stty -ixon
```
