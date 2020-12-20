"=============================================================================
" FILE: vimfiler/popd.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! unite#sources#vimfiler_popd#define() abort
  return s:source
endfunction

function! unite#sources#vimfiler_popd#pushd() abort
  if &filetype !=# 'vimfiler'
    return
  endif

  let directories = vimfiler#exists_another_vimfiler() ?
        \ [b:vimfiler.current_dir, vimfiler#get_another_vimfiler().current_dir]
        \ : [b:vimfiler.current_dir]
  call insert(s:directory_stack, directories)
  echo 'Yanked directories:' string(directories)
endfunction

let s:directory_stack = []

let s:source = {
      \ 'name' : 'vimfiler/popd',
      \ 'description' : 'candidates from vimfiler history',
      \ 'default_action' : 'cd',
      \ 'action_table' : {},
      \ 'is_listed' : 0,
      \ 'alias_table' : { 'cd' : 'lcd' },
      \ }

function! s:source.gather_candidates(args, context) abort
  let num = 0
  let _ = []
  for stack in s:directory_stack
    call add(_, {
          \ 'word' : join(stack, ' : '),
          \ 'kind' : 'directory',
          \ 'action__path' : stack[0],
          \ 'action__directory' : stack[0],
          \ 'action__stack' : stack,
          \ 'action__nr' : num,
          \ })

    let num += 1
  endfor

  return _
endfunction

" Actions
let s:action_table = {}

let s:action_table.delete = {
      \ 'description' : 'delete vimfiler from directory stack',
      \ 'is_selectable' : 1,
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:action_table.delete.func(candidates) abort
  for candidate in sort(a:candidates, 's:compare')
    call remove(s:directory_stack,
          \ candidate.action__nr)
  endfor
endfunction

function! s:compare(candidate_a, candidate_b) abort
  return a:candidate_b.action__nr - a:candidate_a.action__nr
endfunction

let s:action_table.cd = {
      \ 'description' : 'cd vimfiler directory from directory stack',
      \ }
function! s:action_table.cd.func(candidate) abort
  if &filetype != 'vimfiler'
    return
  endif

  let stack = a:candidate.action__stack

  " Change current vimfiler directory.
  call vimfiler#mappings#cd(stack[0])
  if len(stack) > 1 && vimfiler#exists_another_vimfiler()
    " Change alternate vimfiler directory.
    execute vimfiler#winnr_another_vimfiler() . 'wincmd w'
    call vimfiler#mappings#cd(stack[1])
    wincmd p
  endif
endfunction

let s:source.action_table['*'] = s:action_table
unlet! s:action_table


function! s:compare(candidate_a, candidate_b) abort
  return a:candidate_b.action__nr - a:candidate_a.action__nr
endfunction
