"=============================================================================
" FILE: runtimepath.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
"}}}

function! unite#sources#runtimepath#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'runtimepath',
      \ 'description' : 'candidates from Vim runtimepath',
      \ 'default_action' : 'lcd',
      \ 'default_kind' : 'directory',
      \ 'action_table' : {},
      \ }

function! s:source.gather_candidates(args, context) abort "{{{
  return map(map(s:split_rtp(), 'unite#util#expand(v:val)'), "{
        \ 'word' : unite#util#expand(v:val),
        \ 'abbr' : unite#util#substitute_path_separator(
        \         fnamemodify(unite#util#expand(v:val), ':~')),
        \ 'action__path' : unite#util#expand(v:val),
        \ 'source__runtimepath' : v:val,
        \ }")
endfunction"}}}

" Actions "{{{
let s:source.action_table.delete = {
      \ 'description' : 'delete from runtimepath',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ 'is_selectable' : 1,
      \ }
function! s:source.action_table.delete.func(candidates) abort "{{{
  for candidate in a:candidates
    execute 'set runtimepath-=' . fnameescape(candidate.action__path)
  endfor
endfunction"}}}
"}}}

function! s:split_rtp(...) abort "{{{
  let rtp = a:0 ? a:1 : &runtimepath
  if type(rtp) == type([])
    return rtp
  endif
  let split = split(rtp, '\\\@<!\%(\\\\\)*\zs,')
  return map(split,'substitute(v:val, ''\\\([\\,]\)'', "\\1", "g")')
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
