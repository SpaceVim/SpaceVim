"=============================================================================
" FILE: vimfiler/history.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! unite#sources#vimfiler_history#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name' : 'vimfiler/history',
      \ 'description' : 'candidates from vimfiler history',
      \ 'default_action' : 'lcd',
      \ 'action_table' : {},
      \ 'hooks' : {},
      \ 'is_listed' : 0,
      \ }

function! s:source.hooks.on_init(args, context) abort
  if &filetype !=# 'vimfiler'
    return
  endif
endfunction

function! s:source.gather_candidates(args, context) abort
  let num = 0
  let candidates = []
  for [bufname, history] in reverse(vimfiler#get_histories())
    let history = vimfiler#util#substitute_path_separator(history)

    call add(candidates, {
          \ 'word' : bufname . ' '  . history,
          \ 'kind' : (history =~# '^ssh:' ?
          \        'directory/ssh' : 'directory'),
          \ 'action__path' : history,
          \ 'action__directory' : history,
          \ 'action__nr' : num,
          \ })

    let num += 1
  endfor

  return candidates
endfunction

" Actions
let s:action_table = {}

let s:action_table.delete = {
      \ 'description' : 'delete vimfiler directories history',
      \ 'is_selectable' : 1,
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:action_table.delete.func(candidates) abort
  let histories = vimfiler#get_histories()
  for candidate in sort(a:candidates, 's:compare')
    call remove(histories, candidate.action__nr)
  endfor

  call vimfiler#set_histories(histories)
endfunction

let s:source.action_table['*'] = s:action_table
unlet! s:action_table


function! s:compare(candidate_a, candidate_b) abort
  return a:candidate_b.action__nr - a:candidate_a.action__nr
endfunction
