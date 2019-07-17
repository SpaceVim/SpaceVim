"=============================================================================
" theme.vim --- theme API for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#mapping#guide#theme#hi() abort
    let name = get(g:, 'colors_name', 'gruvbox')
    try
        let t = SpaceVim#mapping#guide#theme#{name}#palette()
    catch /^Vim\%((\a\+)\)\=:E117/
        let t = SpaceVim#mapping#guide#theme#gruvbox#palette()
    endtry
    call s:hi(t)
endfunction

function! s:hi(t) abort
    exe 'hi! LeaderGuiderPrompt ctermbg=' . a:t[0][2] . ' ctermfg=' . a:t[0][3] . ' cterm=bold gui=bold guifg=' . a:t[0][0] . ' guibg=' . a:t[0][1]
    exe 'hi! LeaderGuiderSep1 ctermbg=' . a:t[1][2] . ' ctermfg=' . a:t[0][2] . ' cterm=bold gui=bold guifg=' . a:t[0][1] . ' guibg=' . a:t[1][1]
    exe 'hi! LeaderGuiderName ctermbg=' . a:t[1][2] . ' ctermfg=' . a:t[1][3] . ' cterm=bold gui=bold guifg=' . a:t[1][0] . ' guibg=' . a:t[1][1]
    exe 'hi! LeaderGuiderSep2 ctermbg=' . a:t[2][2] . ' ctermfg=' . a:t[1][2] . ' cterm=bold gui=bold guifg=' . a:t[1][1] . ' guibg=' . a:t[2][1]
    exe 'hi! LeaderGuiderFill ctermbg=' . a:t[2][2] . ' ctermfg=' . a:t[2][3] . ' guifg=' . a:t[2][0] . ' guibg=' . a:t[2][1]
endfunction
