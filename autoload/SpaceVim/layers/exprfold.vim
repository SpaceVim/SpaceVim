"=============================================================================
" exprfold.vim --- SpaceVim exprfold layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section exprfold, layer-exprfold
" @parentsection layers
" Fold code quickly according to expr.
"
" Mappings:
" >
"   Key         Mode            Function
"   ----------------------------------------------------
"   ZB          normal          Open fold block template
"   ZF          normal          Fold block
"   ZC          normal          Fold block comment
" <


function! SpaceVim#layers#exprfold#plugins() abort
    return [
                \ ['ZSaberLv0/ZFVimFoldBlock', {'merged' : 0}],
                \ ]
endfunction

function! SpaceVim#layers#exprfold#config() abort
    nnoremap ZB q::call ZF_FoldBlockTemplate()<cr>
    nnoremap ZF :ZFFoldBlock //<left>
    function! ZF_Plugin_ZFVimFoldBlock_comment() abort
        let expr='\(^\s*\/\/\)'
        if &filetype ==# 'vim'
            let expr.='\|\(^\s*"\)'
        endif
        if &filetype ==# 'c' || &filetype ==# 'cpp'
            let expr.='\|\(^\s*\(\(\/\*\)\|\(\*\)\)\)'
        endif
        if &filetype ==# 'make'
            let expr.='\|\(^\s*#\)'
        endif
        let disableE2vSaved = g:ZFVimFoldBlock_disableE2v
        let g:ZFVimFoldBlock_disableE2v = 1
        call ZF_FoldBlock('/' . expr . '//')
        let g:ZFVimFoldBlock_disableE2v = disableE2vSaved
        echo 'comments folded'
    endfunction
    nnoremap ZC :call ZF_Plugin_ZFVimFoldBlock_comment()<cr>
endfunction

