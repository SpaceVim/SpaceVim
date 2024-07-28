---
title: "prompt API"
description: "create cmdline prompt and handle input"
---

# [Available APIs](../) >> prompt

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Intro

This api provides some basic Functions for generating cmdline prompt and handle input.

Example:

```lua
local pmt = require('spacevim.api.prompt')
local nt = require('spacevim.api.notify')

pmt._handle_fly = function(str)
  nt.notify(str)
end

pmt.open()
```

## Functions

| function name         | description                                    |
| --------------------- | ---------------------------------------------- |
| `_handle_fly(string)` | function to handle input, default is `''`      |
| `_onclose()`          | exit function, default is `''`                 |
| `_oninputpro()`       | function before `_handle_fly`, default is `''` |
| `_function_key`       | a dict of keys and handle functions            |

## Key bindings

| Key Bindings  | Descriptions                                  |
| ------------- | --------------------------------------------- |
| Ctrl-r        | read from register, need insert register name |
| Left / Right  | move cursor to left or right                  |
| BackSpace     | remove last character                         |
| Ctrl-w        | remove the Word before the cursor             |
| Ctrl-u        | remove the Line before the cursor             |
| Ctrl-k        | remove the Line after the cursor              |
| Ctrl-a / Home | Go to the beginning of the line               |
| Ctrl-e / End  | Go to the end of the line                     |
