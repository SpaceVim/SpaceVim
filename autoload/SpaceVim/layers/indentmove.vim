"=============================================================================
" indentmove.vim --- SpaceVim indentmove layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section indentmove, layer-indentmove
" @parentsection layers
" Move cursor quickly according to indent.
"
" @subsection Mappings
" >
"   Key         mode            function
"   -----------------------------------------------------------------
"   EH          normal/visual   move up to nearest line with smaller
"                               indent level
"   EL          normal/visual   move down to nearest line with larger
"                               indent level
"   EJ          normal/visual   move down to nearest line with smaller
"                               or same indent level
"   EK          normal/visual   move down to nearest line with larger
"                               or same indent level
"   EI          normal/visual   move down to nearest child indent
" <
"
" 


function! SpaceVim#layers#indentmove#plugins() abort
    return [
                \ ['ZSaberLv0/ZFVimIndentMove', { 'merged' : 0}],
                \ ]
endfunction

function! SpaceVim#layers#indentmove#config() abort
    nnoremap <silent> E <nop>
    nnoremap <silent> EE ``
    nnoremap <silent> EH :call ZF_IndentMoveParent('n')<cr>
    xnoremap <silent> EH :<c-u>call ZF_IndentMoveParent('v')<cr>
    nnoremap <silent> EL :call ZF_IndentMoveParentEnd('n')<cr>
    xnoremap <silent> EL :<c-u>call ZF_IndentMoveParentEnd('v')<cr>
    nnoremap <silent> EK :call ZF_IndentMovePrev('n')<cr>
    xnoremap <silent> EK :<c-u>call ZF_IndentMovePrev('v')<cr>
    nnoremap <silent> EJ :call ZF_IndentMoveNext('n')<cr>
    xnoremap <silent> EJ :<c-u>call ZF_IndentMoveNext('v')<cr>
    nnoremap <silent> EI :call ZF_IndentMoveChild('n')<cr>
    xnoremap <silent> EI :<c-u>call ZF_IndentMoveChild('v')<cr>
endfunction

