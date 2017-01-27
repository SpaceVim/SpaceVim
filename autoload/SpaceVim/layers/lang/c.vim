""
" @section Layer_lang_c
"   this layer provide c family language code completion and syntax chaeck.you
"   need install clang.

function! SpaceVim#layers#lang#c#plugins() abort
    let plugins = []
    if has('nvim')
        call add(plugins, ['tweekmonster/deoplete-clang2'])
    else
        call add(plugins, ['Rip-Rip/clang_complete'])
    endif
    return plugins
endfunction

function! SpaceVim#layers#lang#c#config() abort
    
endfunction
