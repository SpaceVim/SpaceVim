"=============================================================================
" FILE: neosnippet.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

if !exists('b:undo_ftplugin')
    let b:undo_ftplugin = ''
else
    let b:undo_ftplugin = '|'
endif

setlocal expandtab
let &l:shiftwidth=&tabstop
let &l:softtabstop=&tabstop
let &l:commentstring="#%s"

let b:undo_ftplugin .= '
    \ setlocal expandtab< shiftwidth< softtabstop< tabstop< commentstring<
    \'
