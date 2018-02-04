---
title: "FAQ" 
description: "A list of latest blog about the feature of SpaceVim and tutorials of using vim." 
---

# SpaceVim FAQ

this is a list of most asked questions about SpaceVim.

## Where should I put my configration?

SpaceVim load custom global configuration from `~/.SpaceVim.d/init.vim`. It also support project specific configration, 
That means it will load `.SpaceVim.d/init.vim` from the root of your project.

## E492: Not an editor command: ^M

The problem was git auto added ^M when cloning, solved by:

```sh
git config --global core.autocrlf input
```

## Why SpaceVim can not display default colorscheme?

By default, SpaceVim use true colors, so you should make sure your terminal support true colors, This is an articl about
what is true colors and the terminals which support true colors.
