"=============================================================================
" FILE: process.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
call unite#util#set_default(
      \ 'g:unite_source_process_enable_confirm', 1)
"}}}

function! unite#sources#process#define() abort "{{{
  return executable('ps') || (unite#util#is_windows() && executable('tasklist')) ?
        \ s:source : {}
endfunction"}}}

let s:source = {
      \ 'name' : 'process',
      \ 'description' : 'candidates from processes',
      \ 'default_action' : 'sigterm',
      \ 'action_table' : {},
      \ 'alias_table' : { 'delete' : 'sigkill' },
      \ }

function! s:source.gather_candidates(args, context) abort "{{{
  " Get process list.
  let _ = []

  " In Windows, use tasklist.
  let command = unite#util#is_windows() ? 'tasklist' : 'ps auxww'

  let result = split(unite#util#system(command), '\n')
  if empty(result)
    return []
  endif

  if unite#util#is_windows()
    let [message_linenr, start_result, min_len] = [0, 2, 5]
  else
    let [message_linenr, start_result, min_len] = [0, 1, 2]
  endif

  call unite#print_source_message(
        \ result[message_linenr], s:source.name)
  call add(_, { 'word' : result[message_linenr], 'is_dummy' : 1})

  for line in result[start_result :]
    let process = split(line)
    if len(process) < min_len
      " Invalid output.
      continue
    endif

    call add(_, {
          \ 'word' : (unite#util#is_windows() ?
          \           process[0] : join(process[10:])),
          \ 'abbr' : line,
          \ 'action__pid' : process[1],
          \})
  endfor

  return _
endfunction"}}}

" Actions "{{{
let s:source.action_table.sigkill = {
      \ 'description' : 'send the KILL signal to processes',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ 'is_selectable' : 1,
      \ }
function! s:source.action_table.sigkill.func(candidates) abort "{{{
  call s:kill('KILL', a:candidates)
endfunction"}}}

let s:source.action_table.sigterm = {
      \ 'description' : 'send the TERM signal to processes',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ 'is_selectable' : 1,
      \ }
function! s:source.action_table.sigterm.func(candidates) abort "{{{
  call s:kill('TERM', a:candidates)
endfunction"}}}

let s:source.action_table.sigint = {
      \ 'description' : 'send the INT signal to processes',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ 'is_selectable' : 1,
      \ }
function! s:source.action_table.sigint.func(candidates) abort "{{{
  call s:kill('INT', a:candidates)
endfunction"}}}

let s:source.action_table.unite__new_candidate = {
      \ 'description' : 'create new process',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:source.action_table.unite__new_candidate.func(candidate) abort "{{{
  let cmdline = unite#util#input(
        \ 'Please input command args : ', '', 'shellcmd')

  if unite#util#is_windows()
    silent execute ':!start' cmdline
  else
    call system(cmdline . ' &')
  endif
endfunction"}}}

function! s:kill(signal, candidates) abort "{{{
  if g:unite_source_process_enable_confirm
    if !unite#util#input_yesno(
          \ 'Really send the ' . a:signal .' signal to the processes?')
      echo 'Canceled.'
      return
    endif
  endif

  for candidate in a:candidates
    call unite#util#system(unite#util#is_windows() ?
          \ printf('taskkill /PID %d', candidate.action__pid) :
          \  printf('kill -%s %d', a:signal, candidate.action__pid)
          \ )
    if unite#util#get_last_status()
      call unite#print_error(unite#util#get_last_errmsg())
    endif
  endfor
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
