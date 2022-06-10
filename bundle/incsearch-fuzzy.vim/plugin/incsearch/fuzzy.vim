"=============================================================================
" FILE: plugin/incsearch/fuzzy.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_incsearch_fuzzy
endif
if exists('g:loaded_incsearch_fuzzy')
  finish
endif
let g:loaded_incsearch_fuzzy = 1
let s:save_cpo = &cpo
set cpo&vim

function! s:config_fuzzy(...) abort
  return incsearch#config#fuzzy#make(get(a:, 1, {}))
endfunction

function! s:config_fuzzyword(...) abort
  return incsearch#config#fuzzyword#make(get(a:, 1, {}))
endfunction

function! s:config_fuzzyspell(...) abort
  return incsearch#config#fuzzyspell#make(get(a:, 1, {}))
endfunction

noremap <silent><expr> <Plug>(incsearch-fuzzy-/) incsearch#go(<SID>config_fuzzy())
noremap <silent><expr> <Plug>(incsearch-fuzzy-?) incsearch#go(<SID>config_fuzzy({'command': '?'}))
noremap <silent><expr> <Plug>(incsearch-fuzzy-stay) incsearch#go(<SID>config_fuzzy({'is_stay': 1}))

noremap <silent><expr> <Plug>(incsearch-fuzzyword-/) incsearch#go(<SID>config_fuzzyword())
noremap <silent><expr> <Plug>(incsearch-fuzzyword-?) incsearch#go(<SID>config_fuzzyword({'command': '?'}))
noremap <silent><expr> <Plug>(incsearch-fuzzyword-stay) incsearch#go(<SID>config_fuzzyword({'is_stay': 1}))

noremap <silent><expr> <Plug>(incsearch-fuzzyspell-/) incsearch#go(<SID>config_fuzzyspell())
noremap <silent><expr> <Plug>(incsearch-fuzzyspell-?) incsearch#go(<SID>config_fuzzyspell({'command': '?'}))
noremap <silent><expr> <Plug>(incsearch-fuzzyspell-stay) incsearch#go(<SID>config_fuzzyspell({'is_stay': 1}))

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
