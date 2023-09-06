---
title: "Use lua to reimplement core plugins"
categories: [blog]
description: "The core plugins of spacevim have been reimplemented with lua."
type: article
---

# [Blogs](../blog/) >> Use Lua to Reimplement Core Plugins

After comparing the speed of vim script and lua, I want to rewrite SpaceVim with Lua.

**NOTE:** All vim scripts will be retained to ensure support for older versions of Vim and NeoVim

<!-- vim-markdown-toc GFM -->

- [How to compare speed](#how-to-compare-speed)
- [Which version of neovim should I use?](#which-version-of-neovim-should-i-use)
- [What has been done?](#what-has-been-done)
- [The next step](#the-next-step)

<!-- vim-markdown-toc -->

### How to compare speed

with following vim script, and run:

- `:TestFunc Fibo 1000`
- `:TestFunc Fibo 10000000`
- `:TestFunc LuaFibo 1000`
- `:TestFunc LuaFibo 10000000`

```viml
function! Fibo(N) abort
    let t = a:N
    let b = 0
    while t > 0
        let t = t - 1
        let a = 1
        let b = 1
        let c = 73
        while c > 0
            let c = c - 1
            let tmp = a + b
            let a = b
            let b = tmp
        endwhile
    endwhile
    echo b
endfunction

function! LuaFibo(N) abort
lua << EOF
local a, b, r, c, t
t = vim.api.nvim_eval("str2nr(a:N)")
while t > 0 do
        t = t - 1
        a = 1
        b = 1
        c = 73
        while c > 0 do
                c = c - 1
                r = a + b
                a = b
                b = r
        end
end

print(string.format("%d", b))
EOF
endfunction
function! s:test(...) abort
        " for func in a:000
                let start = reltime()
                call call(a:1,[a:2])
                let sec = reltimefloat(reltime(start))
                echom printf('%s(%d): %.6g sec', a:1, a:2, sec)
        " endfor
endfunction

command! -nargs=+ TestFunc call s:test(<f-args>)
```

results:

```
Fibo(1000): 0.410364 sec
Fibo(10000000): 1470.280914 sec
LuaFibo(1000): 9.052000e-4 sec
LuaFibo(10000000): 1.235385 sec
```


### Which version of neovim should I use?

It is recommended to use neovim 0.9.0 or 0.9.1

### What has been done?

**Basic:**

- The spacevim runtime logger

The default runtime logger can be used in in both vim script and lua script. For example:

```lua
-- in lua script test.lua

local log = require('spacevim.logger').derive('test')

local function test_foo()
  log.debug('this is debug message')
end

test_foo()
```

Then the runtime log via `SPC h L`, and you should be able to see:

```
[     test ] [17:14:56:907] [ Debug ] this is debug message
```

**APIs:**

- [file](../api/file/)
- [system](../api/system/)
- [logger](../api/logger/) 
- [job](../api/job/)
- [data#toml](../api/data/toml/)
- [notify](../api/notify/)

**Built-in Plugins:**

These plugins are very commonly used in SpaceVim, so they are rewritten using lua for a better experience.

- alternate file manager

  Use `:A {type}` to jump to alternate file quickly.

- projectmanager

  The project manager provides the function of quickly switching to the project root directory.

- key binding guide
- code runner
- flygrep
- The REPL plugin

### The next step

Please subscribe to the [SpaceVim blog](../blog/) to get the latest updates.
