"=============================================================================
" FILE: bookmark.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_unite_source_bookmark')
      \ || ($SUDO_USER != '' && $USER !=# $SUDO_USER
      \     && $HOME !=# expand('~'.$USER)
      \     && $HOME ==# expand('~'.$SUDO_USER))
  finish
endif

command! -nargs=? -complete=file UniteBookmarkAdd
      \ call unite#sources#bookmark#_append(<q-args>)

" Add custom action table. "{{{
let s:file_bookmark_action = {
      \ 'description' : 'append files to bookmark list',
      \ }
function! s:file_bookmark_action.func(candidate) abort "{{{
  " Add to bookmark.
  call unite#sources#bookmark#_append(a:candidate.action__path)
endfunction"}}}

let s:buffer_bookmark_action = {
      \ 'description' : 'append buffers to bookmark list',
      \ }
function! s:buffer_bookmark_action.func(candidate) abort "{{{
  let filetype = getbufvar(
        \ a:candidate.action__buffer_nr, '&filetype')
  if filetype ==# 'vimfiler'
    let filename = getbufvar(
          \ a:candidate.action__buffer_nr, 'vimfiler').current_dir
  elseif filetype ==# 'vimshell'
    let filename = getbufvar(
          \ a:candidate.action__buffer_nr, 'vimshell').current_dir
  else
    let filename = a:candidate.action__path
  endif

  " Add to bookmark.
  call unite#sources#bookmark#_append(filename)
endfunction"}}}

call unite#custom#action('file', 'bookmark', s:file_bookmark_action)
call unite#custom#action('buffer', 'bookmark', s:buffer_bookmark_action)
unlet! s:file_bookmark_action
unlet! s:buffer_bookmark_action
"}}}

let g:loaded_unite_source_bookmark = 1

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__
" vim: foldmethod=marker
