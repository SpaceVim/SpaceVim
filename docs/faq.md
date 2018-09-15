---
title: "FAQ" 
description: "A list of questions and answers relating to SpaceVim, especially one most asked in SpaceVim community" 
---

# SpaceVim FAQ

this is a list of most asked questions about SpaceVim.

<!-- vim-markdown-toc GFM -->

- [Have a try with SpaceVim without overwrite vimrc?](#have-a-try-with-spacevim-without-overwrite-vimrc)
- [Why use toml as the default configuration file format?](#why-use-toml-as-the-default-configuration-file-format)
- [Where should I put my configuration?](#where-should-i-put-my-configuration)
- [E492: Not an editor command: ^M](#e492-not-an-editor-command-m)
- [Why SpaceVim can not display default colorscheme?](#why-spacevim-can-not-display-default-colorscheme)
- [Why I can not update plugins?](#why-i-can-not-update-plugins)
- [how to enable +py and +py3 in neovim?](#how-to-enable-py-and-py3-in-neovim)
- [Why vim freeze after pressing Ctrl-s?](#why-vim-freeze-after-pressing-ctrl-s)

<!-- vim-markdown-toc -->

### Have a try with SpaceVim without overwrite vimrc?

The install script of SpaceVim will move your `~/.vimrc` to `~/.vimrc_back`. If you want to have a try with SpaceVim without overwrite
your own vim configuration. you can clone SpaceVim manually.

```sh
git clone https://github.com/SpaceVim/SpaceVim.git ~/.SpaceVim
```

then, start vim via `vim -u ~/.SpaceVim/vimrc`. you can also put this alias into your bashrc.

```sh
alias svim='vim -u ~/.SpaceVim/vimrc'
```


### Why use toml as the default configuration file format?

In the old version of SpaceVim, we used a vim file (`init.vim`) for configuration. But this introduced a lot of problems. When loading the vim file the file content is executed line by line. That means if there is an error then the content before the error also will be executed. This will lead to unforeseen problems.

So we're going to use a more robust way to configure SpaceVim. SpaceVim will be able to load the whole configuration file; if there are syntax errors in the configuration file, the entire configuration will be discarded.

1.  YAML: It is error-prone due to indentation being significant and is error-prone when configuring transitions.
2.  XML: vim lacks a parsing library and is hard for humans to write.
3.  JSON is a good configuration format and Vim has a parsing function. However, JSON does not support comments.

After comparing TOML, YAML, XML, and JSON, we chose TOML as the default configuration language.

<!-- I don't understand this -->

The yaml file is parsed into json and cached in the cache folder, and when SpaceVim is started again, the configuration file inside the cache is read directly

### Where should I put my configuration?

SpaceVim load custom global configuration from `~/.SpaceVim.d/init.toml`. It also support project specific configuration, 
That means it will load `.SpaceVim.d/init.toml` from the root of your project.

### E492: Not an editor command: ^M

The problem was git auto added ^M when cloning, solved by:

```sh
git config --global core.autocrlf input
```

### Why SpaceVim can not display default colorscheme?

By default, SpaceVim use true colors, so you should make sure your terminal support true colors, This is an articl about
what is true colors and the terminals which support true colors.

### Why I can not update plugins?

Sometimes you will see `Updating failed, The plugin dir is dirty`. Since the dir of a plugin is a git repo, if the
directory is dirty, you can not use `git pull` to update plugin. To fix this issue, just move your cursor to the
error line, and press `gf`, then run `git reset --hard HEAD` or `git checkout .`. for more info, please read
documentation of git.

### how to enable +py and +py3 in neovim?

In neovim we can use `g:python_host_prog` and `g:python3_host_prog` to config python prog. but in SpaceVim
the custom configuration file is loaded after SpaceVim core code. so in SpaceVim itself, if we using `:py` command, it may cause errors.
so we intrude two new environment variable: `PYTHON_HOST_PROG` and `PYTHON3_HOST_PROG`.

for example:

```sh
export PYTHON_HOST_PROG='/home/q/envs/neovim2/bin/python'
export PYTHON3_HOST_PROG='/home/q/envs/neovim3/bin/python'
```

### Why vim freeze after pressing Ctrl-s?

This is feature of terminal emulator, you can use `Ctrl-q` to unfreeze your vim.
To disable this feature you need the following in either `~/.bash_profile` or `~/.bashrc`:

```sh
stty -ixon
```
