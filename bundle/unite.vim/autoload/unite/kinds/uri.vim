"=============================================================================
" FILE: uri.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#uri#define() abort "{{{
  return s:kind
endfunction"}}}

let s:System = unite#util#get_vital().import('System.File')

let s:kind = {
      \ 'name' : 'uri',
      \ 'default_action' : 'start',
      \ 'action_table' : {},
      \}

" Actions "{{{
let s:kind.action_table.start = {
      \ 'description' : 'open uri by browser',
      \ 'is_selectable' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.start.func(candidates) abort "{{{
  for candidate in a:candidates
    let path = has_key(candidate, 'action__uri') ?
          \ candidate.action__uri : candidate.action__path
    if unite#util#is_windows() && path =~ '^//'
      " substitute separator for UNC.
      let path = substitute(path, '/', '\\', 'g')
    endif

    call unite#util#open(path)
  endfor
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
