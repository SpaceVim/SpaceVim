""
" @section indentmove, indentmove
" @parentsection layers
" move cursor quickly accorrding to indent
"
" mappings:
" >
"   Key         mode            function
"   EH          Normal/vasual   move up to nearest line with smaller
"                               indent level
"   EL          Normal/vasual   move down to nearest line with larger
"                               indent level
"   EJ          Normal/vasual   move down to nearest line with smaller
"                               or same indent level
"   EK          Normal/vasual   move down to nearest line with larger
"                               or same indent level
"   EI          Normal/vasual   move down to nearest child indent
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

