"=============================================================================
" FILE: window.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#window#define() abort "{{{
  return s:kind
endfunction"}}}

let s:kind = {
      \ 'name' : 'window',
      \ 'default_action' : 'jump',
      \ 'action_table': {},
      \ 'parents' : ['common', 'openable', 'cdable'],
      \}

" Actions "{{{
let s:kind.action_table.open = {
      \ 'description' : 'open this window buffer',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.open.func(candidates) abort "{{{
  for candidate in a:candidates
    execute 'buffer' (has_key(candidate, 'action__tab_nr') ?
          \ tabpagebuflist(candidate.action__tab_nr)[
          \   candidate.action__window_nr - 1] :
          \ winbufnr(candidate.action__window_nr))
  endfor
endfunction"}}}

let s:kind.action_table.jump = {
      \ 'description' : 'move to this window',
      \ }
function! s:kind.action_table.jump.func(candidate) abort "{{{
  if has_key(a:candidate, 'action__tab_nr')
    execute 'tabnext' a:candidate.action__tab_nr
  endif
  execute a:candidate.action__window_nr.'wincmd w'
endfunction"}}}

let s:kind.action_table.only = {
      \ 'description' : 'only this window',
      \ }
function! s:kind.action_table.only.func(candidate) abort "{{{
  if has_key(a:candidate, 'action__tab_nr')
    execute 'tabnext' a:candidate.action__tab_nr
  endif
  execute a:candidate.action__window_nr.'wincmd w'
  only
endfunction"}}}

let s:kind.action_table.delete = {
      \ 'description' : 'delete windows',
      \ 'is_selectable' : 1,
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.delete.func(candidates) abort "{{{
  let tabnr = tabpagenr()
  for candidate in sort(a:candidates, 's:compare')
    if has_key(candidate, 'action__tab_nr')
      execute 'tabnext' candidate.action__tab_nr
    endif
    execute candidate.action__window_nr . 'wincmd w'
    close
  endfor

  if tabnr != tabpagenr()
    execute 'tabnext' tabnr
  endif
endfunction"}}}

let s:kind.action_table.preview = {
      \ 'description' : 'preview window',
      \ 'is_quit' : 0,
      \ }
function! s:kind.action_table.preview.func(candidate) abort "{{{
  let tabnr = tabpagenr()
  if has_key(a:candidate, 'action__tab_nr')
    execute 'tabnext' a:candidate.action__tab_nr
  endif

  if !has_key(a:candidate, 'action__buffer_nr')
        \ && !has_key(a:candidate, 'action__window_nr')
    return
  endif

  let winnr = winnr()
  try
    let unite_winnr = unite#get_current_unite().winnr
    let prevwinnr = has_key(a:candidate, 'action__window_nr') ?
          \ (a:candidate.action__window_nr >= unite_winnr ?
          \  a:candidate.action__window_nr + 1 :
          \  a:candidate.action__window_nr) :
          \ bufwinnr(a:candidate.action__buffer_nr)
    execute prevwinnr.'wincmd w'
    execute 'match Search /\%'.line('.').'l/'
    redraw
    sleep 500m
  finally
    match
    execute winnr.'wincmd w'

    if tabnr != tabpagenr()
      execute 'tabnext' tabnr
    endif
  endtry
endfunction"}}}
"}}}

" Misc
function! s:compare(candidate_a, candidate_b) abort "{{{
  return a:candidate_b.action__window_nr - a:candidate_a.action__window_nr
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
