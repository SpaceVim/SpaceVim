"=============================================================================
" FILE: tag.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
"=============================================================================

if exists('g:loaded_neocomplete_tag')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" Add commands. "{{{
command! -nargs=0 -bar
      \ NeoCompleteTagMakeCache
      \ call neocomplete#sources#tag#make_cache(1)
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_neocomplete_tag = 1

" vim: foldmethod=marker
