"=============================================================================
" FILE: file_point.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#file_point#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'file_point',
      \ 'description' : 'file candidate from cursor point',
      \ 'hooks' : {},
      \}
function! s:source.hooks.on_init(args, context) abort "{{{
  let filename_pattern = '[[:alnum:];/?:@&=+$_.!~|()#-]\+'
  let filename = unite#util#expand(
        \ matchstr(getline('.')[: col('.')-1], filename_pattern . '$')
        \ . matchstr(getline('.')[col('.') :], '^'.filename_pattern))
  let a:context.source__filename =
        \ (filename =~ '^\%(https\?\|ftp\)://') ?
        \ filename : fnamemodify(filename, ':p')
endfunction"}}}

function! s:source.gather_candidates(args, context) abort "{{{
  if a:context.source__filename =~ '^\%(https\?\|ftp\)://'
    if exists('*vimproc#host_exists') &&
          \ !vimproc#host_exists(a:context.source__filename)
      " URI is invalid.
      return []
    endif

    " URI.
    return [{
          \   'word' : a:context.source__filename,
          \   'kind' : ['file', 'uri'],
          \   'action__path' : a:context.source__filename,
          \ }]
  elseif filereadable(a:context.source__filename)
    return [{
          \   'word' : a:context.source__filename,
          \   'kind' : 'file',
          \   'action__path' : a:context.source__filename,
          \ }]
  else
    " File not found.
    return []
  endif
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
