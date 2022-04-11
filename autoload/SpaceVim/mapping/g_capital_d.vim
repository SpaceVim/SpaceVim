"=============================================================================
" g_capital_d.vim --- gD key binding
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: sisynb < bsixxxx at gmail.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:g_capital_d = {}
function! SpaceVim#mapping#g_capital_d#add(ft, func) abort
    call extend(s:g_capital_d,{a:ft : a:func})
endfunction

function! SpaceVim#mapping#g_capital_d#get() abort
    return get(s:g_capital_d, &filetype, '')
endfunction
