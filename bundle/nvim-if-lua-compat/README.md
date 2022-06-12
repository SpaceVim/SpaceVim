# nvim-if-lua-compat

An `if_lua` compatibility layer for Neovim (WIP, needs testing)

## Goals

Maintain some amount of compatibility with the existing Vim interface for Lua (see also: [neovim/neovim#12537](https://github.com/neovim/neovim/issues/12537)).

## Progress

Items annotated with an asterisk `*` are only partially supported.

- [x] * `vim.list()` (actually a Lua table, `luaeval()` just makes a copy and transforms it into a Vim list...)
    - [x] `#l`
    - [x] `l[k]`
    - [x] `l()`
    - [x] `table.insert(l, newitem)`
    - [x] `table.insert(l, position, newitem)`
    - [x] `table.remove(l, position)`
    - [x] `l:add(item)`
    - [x] `l:insert(item[, pos])`
- [x] * `vim.dict()` (actually a Lua table, `luaeval()` just makes a copy and transforms it into a Vim dict...)
    - [x] * `#d` (Only works with Lua 5.2+ or LuaJIT built with 5.2 extensions)
    - [x] `d.key` or `d['key']`
    - [x] `d()`
- [x] * `vim.blob()` (actually a Lua table)
    - [x] * `#b` (Only works with Lua 5.2+ or LuaJIT built with 5.2 extensions)
    - [x] `b[k]`
    - [x] `b:add(bytes)`
- [x] `vim.funcref()` (exists in Neovim core, but the implementation is different here)
    - [x] * `#f` (Only works with Lua 5.2+ or LuaJIT built with 5.2 extensions)
    - [x] `f(...)`
- [x] `vim.buffer()`
    - [x] `b()`
    - [x] * `#b` (Only works with Lua 5.2+ or LuaJIT built with 5.2 extensions)
    - [x] `b[k]`
    - [x] `b.name`
    - [x] `b.fname`
    - [x] `b.number`
    - [x] `b:insert(newline[, pos])`
    - [x] `b:next()`
    - [x] `b:previous()`
    - [x] `b:isvalid()`
- [x] `vim.window()`
    - [x] `w()`
    - [x] `w.buffer`
    - [x] `w.line` (get and set)
    - [x] `w.col` (get and set)
    - [x] `w.width` (get and set)
    - [x] `w.height` (get and set)
    - [x] `w:next()`
    - [x] `w:previous()`
    - [x] `w:isvalid()`
- [x] `vim.type()`
    - [x] `list`
    - [x] `dict`
    - [x] `blob`
    - [x] `funcref`
    - [x] `buffer`
    - [x] `window`
- [x] `vim.command()` (alias to `vim.api.nvim_command()`)
- [x] * `vim.eval()` (alias to `vim.api.nvim_eval()`, doesn't actually return a `vim.list/dict/blob`)
- [x] `vim.line()` (alias to `vim.api.nvim_get_current_line()`)
- [x] `vim.beep()`
- [x] `vim.open()`
- [x] `vim.call()` (in Neovim core)
- [x] `vim.fn()` (in Neovim core)
