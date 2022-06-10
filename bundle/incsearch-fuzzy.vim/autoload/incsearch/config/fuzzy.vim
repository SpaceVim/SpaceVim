"=============================================================================
" FILE: autoload/incsearch/config/fuzzy.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:C = vital#incsearch_fuzzy#import('Data.String.Converter')

function! incsearch#config#fuzzy#converter() abort
  return s:C.fuzzy
endfunction

function! incsearch#config#fuzzy#make(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'converters': [incsearch#config#fuzzy#converter()]
  \ }), get(a:, 1, {}))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
