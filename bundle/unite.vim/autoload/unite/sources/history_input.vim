"=============================================================================
" FILE: history_input.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#history_input#define() abort
  return s:source
endfunction

let s:source = {
      \ 'name' : 'history/input',
      \ 'description' : 'candidates from unite input history',
      \ 'action_table' : {},
      \ 'default_action' : 'narrow',
      \ 'is_listed' : 0,
      \}

function! s:source.gather_candidates(args, context) abort "{{{
  let context = unite#get_context()
  let inputs = unite#get_profile(
        \ context.unite__old_buffer_info[0].profile_name, 'unite__inputs')
  let key = context.old_source_names_string
  if !has_key(inputs, key)
    return []
  endif

  return map(copy(inputs[key]), '{
        \ "word" : v:val
        \ }')
endfunction"}}}

" Actions "{{{
let s:source.action_table.narrow = {
      \ 'description' : 'narrow by history',
      \ 'is_quit' : 0,
      \ }
function! s:source.action_table.narrow.func(candidate) abort "{{{
  call unite#force_quit_session()
  call unite#mappings#narrowing(a:candidate.word, 0)
endfunction"}}}

let s:source.action_table.delete = {
      \ 'description' : 'delete from input history',
      \ 'is_selectable' : 1,
      \ 'is_quit' : 0,
      \ 'is_invalidate_cache' : 1,
      \ }
function! s:source.action_table.delete.func(candidates) abort "{{{
  let context = unite#get_context()
  let inputs = unite#get_profile(
        \ context.unite__old_buffer_info[0].profile_name, 'unite__inputs')
  let key = context.old_source_names_string
  if !has_key(inputs, key)
    return
  endif

  for candidate in a:candidates
    call filter(inputs[key], 'v:val !=# candidate.word')
  endfor
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
