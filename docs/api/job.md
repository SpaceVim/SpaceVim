---
title: "job API"
description: "job API provides some basic functions for running a job"
---

# [Available APIs](../) >> job

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Intro

job api provides a async job control api for vim and neovim.

```vim
let s:JOB = SpaceVim#api#import('job')

function! s:on_stdout(id, data, event) abort
   " do something with stdout
endfunction

function! s:on_stderr(id, data, event) abort
  " do something with stderr
endfunction

function! s:on_exit(id, data, event) abort
  " handle exit code
endfunction

let cmd = ['python', 'test.py']

call s:JOB.start(cmd,
    \ {
    \ 'on_stdout' : function('s:on_stdout'),
    \ 'on_stderr' : function('s:on_stderr'),
    \ 'on_exit' : function('s:on_exit'),
    \ }
    \ )
```


The lua job api:

```lua
local job = require('spacevim.api.job')

local jobid = job.start({'lua53', '-'}, {
  -- the on_stdout and on_stderr function can be:
  -- fun(id, data) end or fun(id, data, event) end
  on_stdout = function(id, data)
    vim.print(id)
    vim.print(vim.inspect(data))
  end,
  on_stderr = function(id, data)
    vim.print(id)
    vim.print(vim.inspect(data))
  end,
  on_exit = function(id, code, signal)
    vim.print(id)
    vim.print('exit code', code)
    vim.print('exit signal', signal)
  end,
})


job.send(jobid, 'print(1)\n')
job.send(jobid, 'print(1)\n')
job.send(jobid, 'print(1)\n')
job.send(jobid, 'print(1)\n')
job.chanclose(jobid, 'stdin')
job.stop(jobid)
```

## Functions

| function name      | description                                        |
| ------------------ | -------------------------------------------------- |
| `start(cmd, argv)` | start a job, return the job id                     |
| `send(id, data)`   | send data to a job                                 |
| `stop(id)`         | stop a jobe with specific job id                   |
| `status(id)`       | check the status of a job with the specific job id |
| `list()`           | list all the jobs                                  |
