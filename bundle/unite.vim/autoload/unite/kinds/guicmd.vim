"=============================================================================
" FILE: guicmd.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#guicmd#define() abort "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'guicmd',
      \ 'default_action' : 'execute',
      \ 'action_table': {},
      \ 'alias_table' : { 'ex' : 'nop' },
      \}

" Actions "{{{
let s:kind.action_table.execute = {
      \ 'description' : 'execute command',
      \ }
function! s:kind.action_table.execute.func(candidate) abort "{{{
  let args = [a:candidate.action__path]
  if has_key(a:candidate, 'action__args')
    let args += a:candidate.action__args
  endif

  if unite#util#is_windows()
    let args[0] = resolve(args[0])
  endif

  let cmdline = unite#util#is_windows() ?
        \ join(map(args, '"\"".v:val."\""')) :
        \ args[0] . ' ' . join(map(args[1:], "shellescape(v:val)"))

  if unite#util#is_windows()
    let cmdline = unite#util#iconv(cmdline, &encoding, 'char')
    silent execute ':!start' cmdline
  else
    call system(cmdline . ' &')
  endif
endfunction"}}}
let s:kind.action_table.edit = {
      \ 'description' : 'edit command args',
      \ }
function! s:kind.action_table.edit.func(candidate) abort "{{{
  let args = [a:candidate.action__path]
  if has_key(a:candidate, 'action__args')
    let args += a:candidate.action__args
  endif

  if unite#util#is_windows()
    let args[0] = resolve(args[0])
  endif

  let cmdline = unite#util#is_windows() ?
        \ join(map(args, '"\"".v:val."\""')) :
        \ args[0] . ' ' . join(map(args[1:], "''''.v:val.''''"))
  let cmdline = input('Edit command args :', cmdline, 'file')

  if unite#util#is_windows()
    silent execute ':!start' cmdline
  else
    call system(cmdline . ' &')
  endif
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
