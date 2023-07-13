---
title: "notify API"
description: "notify API provides some basic functions for generating notifications"
---

# [Available APIs](../) >> notify

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions and variables](#functions-and-variables)
- [Usage](#usage)

<!-- vim-markdown-toc -->

## Intro

This api provides some basic Functions for generating notifications.

## Functions and variables

| function name               | description                                              |
| --------------------------- | -------------------------------------------------------- |
| `notify(string)`            | generate notification with default color                 |
| `notify(string, highlight)` | generate notification with custom highlight group        |
| `notify.notify_max_width`   | set the max width of notify windows                      |
| `notify.timeout`            | set the time in milliseconds to close the notify windows |

## Usage

Vim Script:

```vim
let s:NOTIFY = SpaceVim#api#import('notify')
let s:NOTIFY.notify_max_width = 40
let s:NOTIFY.timeout = 3000
call s:NOTIFY.notify('This is a simple notification!')
```

Lua:

**Note:** lua version can only be used in neovim

```lua
local noti = require('spacevim.api').import('notify')
noti.notify_max_width = 40
noti.timeout = 3000
noti.notify('This is a simple notification!')
```
