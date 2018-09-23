---
title: "logger API"
description: "logger API provides some basic functions for log message when create plugins"
---

# [Available APIs](../) >> logger

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [functions](#functions)

<!-- vim-markdown-toc -->

## Intro

`logger` API provides some functions to create logger for plugin.

In vim script, loading the API before using it. You can also config the options of the API.

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

## functions

| name            | description                    |
| --------------- | ------------------------------ |
| `set_name(str)` | set the name of current logger |
