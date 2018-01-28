---
title: "异步协同 API"
---

# [APIs](https://spacevim.org/cn/apis) : job

`job` API 提供了一套可以兼容 neovim 和 vim 的异步控制机制，具体实现模型是参考的 neovim 的模型，具体示例如下：

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

以上代码可以在 vim 或者 neovim 中异步运行命令，甚至对于老版本的 vim 也兼容，但是在老版本 vim 中执行的时候不是异步的。


## functions

| 名称               | 描述                         |
| ------------------ | ---------------------------- |
| `start(cmd, argv)` | 开始一个 job, 并返回 job id. |
