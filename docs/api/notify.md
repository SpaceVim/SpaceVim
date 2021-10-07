---
title: "notify API"
description: "notify API provides some basic functions for generating notifications"
---

# [Available APIs](../) >> notify

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

This api provides some basic Functions for generating notifications.

```vim
let s:NOTIFY = SpaceVim#api#import('notify')
call s:NOTIFY.notify('This is a simple notification!')
```

## Functions

| function name               | description                                       |
| --------------------------- | ------------------------------------------------- |
| `notify(string)`            | generate notification with default color          |
| `notify(string, highlight)` | generate notification with custom highlight group |
