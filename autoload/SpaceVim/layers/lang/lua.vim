"WolfgangMehner/lua-support
"http://lua-users.org/wiki/LuaEditorSupport
"
function! SpaceVim#layers#lang#lua#plugins() abort
    let plugins = []
    " Improved Lua 5.3 syntax and indentation support for Vim
    call add(plugins, ['tbastos/vim-lua', {'on_ft' : 'lua'}])
    call add(plugins, ['WolfgangMehner/lua-support', {'on_ft' : 'lua'}])
    call add(plugins, ['SpaceVim/vim-luacomplete', {'on_ft' : 'lua', 'if' : has('lua')}])
    return plugins
endfunction

function! SpaceVim#layers#lang#lua#config() abort
    augroup spacevim_lua
        autocmd FileType lua setlocal omnifunc=luacomplete#complete
    augroup END
endfunction
