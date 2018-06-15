---
title: "FAQ" 
description: "A list of questions and answers relating to SpaceVim, especially one most asked in SpaceVim community" 
---

# SpaceVim FAQ

this is a list of most asked questions about SpaceVim.

<!-- vim-markdown-toc GFM -->

- [Why use toml file as default configuration file?](#why-use-toml-file-as-default-configuration-file)
- [Where should I put my configuration?](#where-should-i-put-my-configuration)
- [E492: Not an editor command: ^M](#e492-not-an-editor-command-m)
- [Why SpaceVim can not display default colorscheme?](#why-spacevim-can-not-display-default-colorscheme)
- [Why I can not update plugins?](#why-i-can-not-update-plugins)

<!-- vim-markdown-toc -->

### Why use toml file as default configuration file?

In the old version of SpaceVim, we use vim script as configuration file, but this brings many bug.
When using vim file, the configuration are executed when loading the configuration file, that means
if there is error in the configuration file, the content before the error line also will be executed.
This will cause unknown issue.

So, we are going to using another language to config SpaceVim, SpaceVim will load the whole configuration
file. If there is error in this configuration file, all the configuration will be abandoned.

1. yaml relies on indentation and is error-prone when configuring transitions, regardless
2. XML lacks a vim parsing library, so it is not considered
3. json is a relatively good configuration information transmission format, and Vim has a
parsing function, but the json format does not support annotations.

We compared toml, yaml, XML, and json, and finally chose toml as the default configuration language.
The yaml file is parsed into json and cached in the cache folder, and when SpaceVim is started
again, the configuration file inside the cache is read directly



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
