"=============================================================================
" FILE: register.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#register#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'register',
      \ 'description' : 'candidates from register',
      \ 'action_table' : {},
      \ 'default_kind' : 'word',
      \}

function! s:source.gather_candidates(args, context) abort "{{{
  let candidates = []

  let registers = split(get(a:args, 0, ''), '\zs')

  for reg in (has('clipboard') ? ['+', '*'] : []) + [
        \   '"',
        \   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        \   'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
        \   'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
        \   'u', 'v', 'w', 'x', 'y', 'z',
        \   '-', '.', ':', '#', '%', '/', '=',
        \ ]
    let register = getreg(reg, 1)
    if (empty(registers) && register != ''
          \ && register !~ '[\x01-\x08\x10-\x1a\x1c-\x1f]\{3,}')
          \ || index(registers, reg) >= 0
      call add(candidates, {
            \ 'word' : register,
            \ 'abbr' : printf('%-3s - %s', reg,
            \     substitute(register, '\n', '^@', 'g')),
            \ 'is_multiline' : 1,
            \ 'action__register' : reg,
            \ 'action__regtype' : getregtype(reg),
            \ })
    endif
  endfor

  return candidates
endfunction"}}}

" Actions "{{{
let s:source.action_table.delete = {
      \ 'description' : 'delete registers',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ 'is_selectable' : 1,
      \ }
function! s:source.action_table.delete.func(candidates) abort "{{{
  for candidate in a:candidates
    silent! call setreg(candidate.action__register, '')
  endfor
endfunction"}}}

let s:source.action_table.edit = {
      \ 'description' : 'change register value',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:source.action_table.edit.func(candidate) abort "{{{
  let register = getreg(a:candidate.action__register, 1)
  let register = substitute(register, '\r\?\n', '\\n', 'g')
  let new_value = substitute(input('', register), '\\n', '\n', 'g')
  " If the user cancels input, new_value is empty, so assume no change on empty.
  " User can delete explicity via the `delete` action.
  if new_value != ''
      silent! call setreg(a:candidate.action__register,
            \ new_value, a:candidate.action__regtype)
  endif
  endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
