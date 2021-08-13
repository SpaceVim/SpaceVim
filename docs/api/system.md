---
title: "system API"
description: "system API provides some basic functions and values for current os."
---

# [Available APIs](../) >> system

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Valuables](#valuables)
- [Functions](#functions)
- [Usage](#usage)

<!-- vim-markdown-toc -->

## Intro

The `system` provides basic functions for os detection. 

## Valuables

| name      | values | description                |
| --------- | :----: | -------------------------- |
| isWindows | 0 or 1 | check if the os is windows |
| isLinux   | 0 or 1 | check if the os is linux   |
| isOSX     | 0 or 1 | check if the os is OSX     |
| isDarwin  | 0 or 1 | check if the os is Darwin  |

## Functions

| name       | description                            |
| ---------- | -------------------------------------- |
| fileformat | return the icon of current file format |

## Usage

This api can be used in both vim script and lua script.

**vim script:**

```vim

```

**lua script:**

```lua
local sys = require('spacevim.api').import('system')

if sys.isWindows == 1 then
    print('this is windows os!')
end

```
