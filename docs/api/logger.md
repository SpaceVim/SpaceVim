---
title: "logger API"
description: "logger API provides some basic functions for log message when create plugins"
---

# [Available APIs](../) >> logger

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)
- [Usage](#usage)

<!-- vim-markdown-toc -->

## Intro

`logger` API provides some functions to create logger for plugin.

## Functions

| name                  | description                       |
| --------------------- | --------------------------------- |
| `set_name(string)`    | set the name of current logger    |
| `set_silent(silent)`  | enable/disable silent mode, `silent` should be boolean or 0/1       |
| `set_verbose(number)` | set the verbose level             |
| `set_level(number)`   | set the logger level              |
| `error(string)`       | log error message                 |
| `warn(string)`        | log string only when `level <= 2` |
| `info(string)`        | log string only when `level <= 1` |
| `debug(string)`       | log string only when `level <= 0` |

## Usage

The `logger` api provides two versions, the vim script and lua:

**vim script:**

here is an example for creatting logger for plugin `foo.vim`.

`autoload/foo/log.vim`

```vim
let s:LOGGER = SpaceVim#api#import('logger')

" set the name of current logger, after that, the log just looks like:
"   name    time       level   message
" [ foo ] [11:31:26] [ Info ] log message here
call s:LOGGER.set_name('foo')

call s:LOGGER.set_level(1)
call s:LOGGER.set_silent(1)
call s:LOGGER.set_verbose(1)

function! foo#log#info(msg) abort
  call s:LOGGER.info(a:msg)
endfunction

function! foo#log#warn(msg, ...) abort
  let issilent = get(a:000, 0, 1)
  call s:LOGGER.warn(a:msg, issilent)
endfunction

function! foo#log#error(msg) abort
  call s:LOGGER.error(a:msg)
endfunction

function! foo#log#setLevel(level) abort
  call s:LOGGER.set_level(a:level)
endfunction

function! foo#log#setOutput(file) abort
  call s:LOGGER.set_file(a:file)
endfunction
```

**lua script:**

```lua
local logger = require('spacevim.api').import('logger')

logger.set_name('foo')
logger.set_level(1)
logger.set_silent(1)
logger.set_verbose(1)

local function warn(msg)
    logger.warn(msg)
end

```
