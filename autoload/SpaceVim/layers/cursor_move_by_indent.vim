function! SpaceVim#layers#cursor_move_by_indent#plugins() abort
    return [
                \ ['ZSaberLv0/ZFVimIndentMove', { 'merged' : 0}],
                \ ]
endfunction

function! SpaceVim#layers#cursor_move_by_indent#config() abort
    nnoremap E <nop>
    nnoremap EE ``
    nnoremap EH :call ZF_IndentMoveParent('n')<cr>
    xnoremap EH :<c-u>call ZF_IndentMoveParent('v')<cr>
    nnoremap EL :call ZF_IndentMoveParentEnd('n')<cr>
    xnoremap EL :<c-u>call ZF_IndentMoveParentEnd('v')<cr>
    nnoremap EK :call ZF_IndentMovePrev('n')<cr>
    xnoremap EK :<c-u>call ZF_IndentMovePrev('v')<cr>
    nnoremap EJ :call ZF_IndentMoveNext('n')<cr>
    xnoremap EJ :<c-u>call ZF_IndentMoveNext('v')<cr>
    nnoremap EI :call ZF_IndentMoveChild('n')<cr>
    xnoremap EI :<c-u>call ZF_IndentMoveChild('v')<cr>
endfunction

