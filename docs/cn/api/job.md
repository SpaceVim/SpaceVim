---
title: "异步协同 API"
description: "兼容 neovim 和 vim 的异步协同 API，对于旧版 vim 采用非异步机制"
lang: cn
---

# [SpaceVim 公共函数](https://spacevim.org/cn/apis) - 异步协同（job）

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
| `send(id, data)`   | 传递数据至指定 id 的 job     |
| `stop(id)`         | 终止指定 id 的 job           |
| `status(id)`       | 查看指定 id 的 job 的状态    |
| `list()`           | 列出所有 job                 |

以上这个 api 仅提供了基础的 job 函数，当你的脚本需要用到 job 高级功能时，建议直接使用 neovim 或 vim 内置函数。
