"WolfgangMehner/lua-support
"http://lua-users.org/wiki/LuaEditorSupport
"
function! SpaceVim#layers#lang#lua#plugins() abort
    let plugins = []
    " Lua reference manual, wsdjeg's fork
    call add(plugins, ['wsdjeg/luarefvim'])
    " Improved Lua 5.3 syntax and indentation support for Vim
    call add(plugins, ['tbastos/vim-lua', {'on_ft' : 'lua'}])
    call add(plugins, ['WolfgangMehner/lua-support', {'on_ft' : 'lua'}])
    return plugins
endfunction

function! SpaceVim#layers#lang#lua#config() abort
    
endfunction
