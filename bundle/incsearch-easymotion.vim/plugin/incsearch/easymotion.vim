"=============================================================================
" FILE: plugin/incsearch/easymotion.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_incsearch_easymotion
endif
if exists('g:loaded_incsearch_easymotion')
  finish
endif
let g:loaded_incsearch_easymotion = 1
let s:save_cpo = &cpo
set cpo&vim

function! s:config(...) abort
  return incsearch#config#easymotion#make(get(a:, 1, {}))
endfunction

noremap <silent><expr> <Plug>(incsearch-easymotion-/)    incsearch#go(<SID>config())
noremap <silent><expr> <Plug>(incsearch-easymotion-?)    incsearch#go(<SID>config({'command': '?'}))
noremap <silent><expr> <Plug>(incsearch-easymotion-stay) incsearch#go(<SID>config({'is_stay': 1}))


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
