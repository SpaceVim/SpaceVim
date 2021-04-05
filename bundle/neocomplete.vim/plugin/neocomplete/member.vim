"=============================================================================
" FILE: member.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
"=============================================================================

if exists('g:loaded_neocomplete_member')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" Add commands. "{{{
command! -nargs=? -complete=file -bar
      \ NeoCompleteMemberMakeCache
      \ call neocomplete#sources#member#remake_cache(&l:filetype)
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_neocomplete_member = 1

" vim: foldmethod=marker
