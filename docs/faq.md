---
title: "FAQ" 
description: "A list of latest blog about the feature of SpaceVim and tutorials of using vim." 
---

# SpaceVim FAQ

this is a list of most asked questions about SpaceVim.


<!-- vim-markdown-toc GFM -->

- [Where should I put my configuration?](#where-should-i-put-my-configuration)
- [E492: Not an editor command: ^M](#e492-not-an-editor-command-m)
- [Why SpaceVim can not display default colorscheme?](#why-spacevim-can-not-display-default-colorscheme)
- [Why I can not update plugins?](#why-i-can-not-update-plugins)

<!-- vim-markdown-toc -->

### Where should I put my configuration?

SpaceVim load custom global configuration from `~/.SpaceVim.d/init.vim`. It also support project specific configuration, 
That means it will load `.SpaceVim.d/init.vim` from the root of your project.

### E492: Not an editor command: ^M

The problem was git auto added ^M when cloning, solved by:

```sh
git config --global core.autocrlf input
```

### Why SpaceVim can not display default colorscheme?

By default, SpaceVim use true colors, so you should make sure your terminal support true colors, This is an articl about
what is true colors and the terminals which support true colors.

### Why I can not update plugins?

Sometimes you will see `Updating failed, The plugin dir is dirty`. Since the dir of a plugin is a git repo, if the directory is dirty, you can not use `git pull` to update plugin. To fix this issue, just move your cursor to the error line, and press `gf`, then run `git reset --hard HEAD` or `git checkout .`. for more info, please read documentation of git.
