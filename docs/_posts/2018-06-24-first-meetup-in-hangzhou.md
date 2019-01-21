---
title: "SpaceVim MeetUp in HangZhou"
categories: [meetup, blog]
excerpt: "Our first meetup in hangzhou, general discussion about features of SpaceVim."
image: https://user-images.githubusercontent.com/13142418/42164326-48994830-7e38-11e8-8bf5-44adc65b514a.jpg
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
![rename](https://user-images.githubusercontent.com/13142418/42123061-26d938aa-7c11-11e8-8e98-b089fbc53f30.gif)
- Move cursor tab forward and backword, default key binding is `<C-S-Up>/<C-S-Down>`
![movetab](https://user-images.githubusercontent.com/13142418/42123107-de3d10c0-7c11-11e8-8ddd-ed20b8925dee.gif)
- Create new tab after the tab under the cursor, key bindings: (`n`: create named tab / `N` : create anonymous tab)
![newtab](https://user-images.githubusercontent.com/13142418/42123504-d1c9e80c-7c18-11e8-8a51-a37fa55abb9b.gif)
- copy / paste tab, include tab layout and tab name
![copytab](https://user-images.githubusercontent.com/13142418/42134628-311b9648-7d72-11e8-9277-e63bbf42502c.gif)
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

