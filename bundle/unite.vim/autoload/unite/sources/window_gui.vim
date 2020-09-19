"=============================================================================
" FILE: window/gui.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#window_gui#define() abort "{{{
  return executable('wmctrl') ? s:source : {}
endfunction"}}}

let s:source = {
      \ 'name' : 'window/gui',
      \ 'description' : 'candidates from GUI window list',
      \ 'syntax' : 'uniteSource__WindowGUI',
      \ 'hooks' : {},
      \ 'action_table' : {},
      \ 'alias_table': { 'edit' : 'rename' },
      \ 'default_action' : 'open',
      \}

function! s:source.hooks.on_syntax(args, context) abort "{{{
  syntax match uniteSource__WindowGUI_Class /\[\S\+\]/
        \ contained containedin=uniteSource__WindowGUI
  highlight default link uniteSource__WindowGUI_Class Type
endfunction"}}}
function! s:source.gather_candidates(args, context) abort "{{{
  let current = getpid()
  let _ = []
  let classes = []
  for line in split(unite#util#system('wmctrl -lpx'), '\n')
    let list = matchlist(line, '^\(\S\+\)\s\+\d\+\s\+\(\d\+\)\s\+'
          \ . '\(\S\+\)\s\+\S\+\s\+\(.*\)$')
    if len(list) < 6
      continue
    endif

    let [line, id, pid, class, title] = list[:4]

    " Skip current Vim and Desktop
    if pid != current && class !=# 'N/A'
          \ && class !=# 'desktop_window.Nautilus'
      call add(_, {
            \ 'id' : id,
            \ 'class' : class,
            \ 'title' : title,
            \ })
      call add(classes, len(class))
    endif
  endfor

  let max_class = max(classes) + 2
  return map(_, "{
            \ 'word' : v:val.class . ' ' . v:val.title,
            \ 'abbr' : printf('%-' . max_class . 's %s',
            \          '['.v:val.class.']', v:val.title),
            \ 'action__id' : v:val.id,
            \ 'action__title' : v:val.title,
            \ }")
endfunction"}}}
function! s:source.complete(args, context, arglead, cmdline, cursorpos) abort "{{{
  return ['no-current']
endfunction"}}}

" Actions "{{{
let s:source.action_table.open = {
      \ 'description' : 'move to this window',
      \ }
function! s:source.action_table.open.func(candidate) abort "{{{
  call unite#util#system(printf('wmctrl -i -a %s',
          \ a:candidate.action__id))
endfunction"}}}

let s:source.action_table.delete = {
      \ 'description' : 'delete windows',
      \ 'is_selectable' : 1,
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:source.action_table.delete.func(candidates) abort "{{{
  for candidate in a:candidates
    call unite#util#system(printf('wmctrl -i -c %s',
          \ candidate.action__id))
  endfor
  sleep 100m
endfunction"}}}

let s:source.action_table.rename = {
      \ 'description' : 'rename window title',
      \ 'is_invalidate_cache' : 1,
      \ 'is_quit' : 0,
      \ }
function! s:source.action_table.rename.func(candidate) abort "{{{
  let old_title = a:candidate.action__title
  let title = input(printf('New title: %s -> ', old_title), old_title)
  if title != '' && title !=# old_title
    call unite#util#system(printf('wmctrl -i -r %s -T %s',
          \ a:candidate.action__id, string(title)))
  endif
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
