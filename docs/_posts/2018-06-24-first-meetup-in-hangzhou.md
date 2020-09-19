---
title: "SpaceVim MeetUp in HangZhou"
categories: [meetup, blog]
description: "Our first meetup in hangzhou, general discussion about features of SpaceVim."
image: https://user-images.githubusercontent.com/13142418/80610943-8de64180-8a6c-11ea-9e0b-bdc3c9d8dbd3.jpg
commentsID: "SpaceVim MeetUp in HangZhou"
comments: true
---

# First meetup in Hangzhou

> members: [Arith](https://github.com/icearith), BTS, [wsdjeg](https://github.com/wsdjeg)  
> location: HangZhou  
> time: {{ page.date | date_to_string }}

We just make a general discussion about how to use SpaceVim, and what feature need to be improved in next release.

<!-- vim-markdown-toc GFM -->

- [Improve Tab manager](#improve-tab-manager)
- [Improve flygrep](#improve-flygrep)
- [Add doc of SpaceVim APIs](#add-doc-of-spacevim-apis)
- [Reduce the number of default plugins.](#reduce-the-number-of-default-plugins)
- [Development doc for language specific key bindings](#development-doc-for-language-specific-key-bindings)
- [call for layer maintainers](#call-for-layer-maintainers)

<!-- vim-markdown-toc -->

### Improve Tab manager

These new features have been added to tab manager in [#1887](https://github.com/SpaceVim/SpaceVim/pull/1887)

- Display tab name on tabline and tab manager, you can also rename the tab via key binding `r` in tab manager buffer.
![rename](https://user-images.githubusercontent.com/13142418/80611134-ce45bf80-8a6c-11ea-8c1a-1a50ffea3880.gif)
- Move cursor tab forward and backword, default key binding is `<C-S-Up>/<C-S-Down>`
![movetab](https://user-images.githubusercontent.com/13142418/80611339-0d741080-8a6d-11ea-890c-f8b389cee866.gif)
- Create new tab after the tab under the cursor, key bindings: (`n`: create named tab / `N` : create anonymous tab)
![newtab](https://user-images.githubusercontent.com/13142418/80611475-398f9180-8a6d-11ea-9aa5-a975d61ebab9.gif)
- copy / paste tab, include tab layout and tab name
![copytab](https://user-images.githubusercontent.com/13142418/80611654-78bde280-8a6d-11ea-9cc0-ac41851882bd.gif)
- Display windows id of each item.

### Improve flygrep

- remove the unneeded `!` after redraw in flygrep and other plugins which is using prompt API.
- improve the flygrep 

Just open a new pull request [#1898](https://github.com/SpaceVim/SpaceVim/pull/1898) which is based on [#1802](https://github.com/SpaceVim/SpaceVim/pull/1802).

### Add doc of SpaceVim APIs

In [#1896](https://github.com/SpaceVim/SpaceVim/pull/1896), we will add documentation of SpaceVim APIs. These APIs provides
compatible functions for neovim/vim.


### Reduce the number of default plugins.

Discussion about this topic happened in [#1897](https://github.com/SpaceVim/SpaceVim/pull/1897)

### Development doc for language specific key bindings

Discussion about this topic happened in [#1899](https://github.com/SpaceVim/SpaceVim/pull/1899)

### call for layer maintainers

- go
- python
- java
- js
- php
- lua

