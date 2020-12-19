"=============================================================================
" FILE: tab.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#tab#define() abort "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'tab',
      \ 'default_action' : 'open',
      \ 'action_table': {},
      \ 'alias_table': { 'edit' : 'rename' },
      \}

" Actions "{{{
let s:kind.action_table.open = {
      \ 'description' : 'open this tab',
      \ }
function! s:kind.action_table.open.func(candidate) abort "{{{
  execute 'tabnext' a:candidate.action__tab_nr
endfunction"}}}

let s:kind.action_table.delete = {
      \ 'description' : 'delete tabs',
      \ 'is_selectable' : 1,
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.delete.func(candidates) abort "{{{
  for candidate in sort(a:candidates, 's:compare')
    execute 'tabclose' candidate.action__tab_nr
  endfor
endfunction"}}}

let s:kind.action_table.preview = {
      \ 'description' : 'preview tab',
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.preview.func(candidate) abort "{{{
  let tabnr = tabpagenr()
  execute 'tabnext' a:candidate.action__tab_nr
  redraw
  sleep 500m
  execute 'tabnext' tabnr
endfunction"}}}

let s:kind.action_table.unite__new_candidate = {
      \ 'description' : 'create new tab',
      \ 'is_invalidate_cache' : 1,
      \ }
function! s:kind.action_table.unite__new_candidate.func(candidate) abort "{{{
  let title = input('Please input tab title: ', '',
        \ 'customlist,' . s:SID_PREFIX() . 'history_complete')

  tabnew
  if title != ''
    let t:title = title
  endif
endfunction"}}}

" Anywhere SID.
function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:history_complete(arglead, cmdline, cursorpos) abort
  return filter(map(reverse(range(1, histnr('input'))),
  \                     'histget("input", v:val)'),
  \                 'v:val != "" && stridx(v:val, a:arglead) == 0')
endfunction

if exists('*gettabvar')
  " Enable cd action.
  let s:kind.parents = ['cdable']

  let s:kind.action_table.rename = {
      \ 'description' : 'rename tabs',
      \ 'is_selectable' : 1,
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
        \ }
  function! s:kind.action_table.rename.func(candidates) abort "{{{
    for candidate in a:candidates
      let old_title = gettabvar(candidate.action__tab_nr, 'title')
      let title = input(printf('New title: %s -> ', old_title), old_title)
      if title != '' && title !=# old_title
        call settabvar(candidate.action__tab_nr, 'title', title)
      endif
    endfor
  endfunction"}}}
endif
"}}}

" Misc
function! s:compare(candidate_a, candidate_b) abort "{{{
  return a:candidate_b.action__tab_nr - a:candidate_a.action__tab_nr
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
