"=============================================================================
" FILE: time.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! vimfiler#columns#time#define() abort
  return s:column
endfunction

let s:column = {
      \ 'name' : 'time',
      \ 'description' : 'get filetime',
      \ 'syntax' : 'vimfilerColumn__Time',
      \ }

function! s:column.length(files, context) abort
  return len(strftime(g:vimfiler_time_format, 0)) + 1
endfunction

function! s:column.define_syntax(context) abort
  syntax match   vimfilerColumn__TimeNormal
        \ '#[^#]\+' contained
        \ containedin=vimfilerColumn__Time
        \ contains=vimfilerColumn__TimeIgnore
  syntax match   vimfilerColumn__TimeToday
        \ '\~[^~]\+' contained
        \ containedin=vimfilerColumn__Time
        \ contains=vimfilerColumn__TimeIgnore
  syntax match   vimfilerColumn__TimeWeek
        \ '![^!]\+' contained
        \ containedin=vimfilerColumn__Time
        \ contains=vimfilerColumn__TimeIgnore

  if has('conceal')
    " Supported conceal features.
    syntax match   vimfilerColumn__TimeIgnore
          \ '[#~!]' contained conceal
  endif

  highlight def link vimfilerColumn__TimeNormal Identifier
  highlight def link vimfilerColumn__TimeToday Statement
  highlight def link vimfilerColumn__TimeWeek Special
  highlight def link vimfilerColumn__TimeIgnore Ignore
endfunction

function! s:column.get(file, context) abort
  let datemark = s:get_datemark(a:file)
  return (a:file.vimfiler__filetime =~ '^-\?\d\+$' ?
        \  (a:file.vimfiler__filetime == -1 ? '' :
        \    datemark . strftime(g:vimfiler_time_format, a:file.vimfiler__filetime))
        \ : datemark . a:file.vimfiler__filetime)
endfunction

function! s:get_datemark(file) abort
  if a:file.vimfiler__filetime !~ '^\d\+$'
    return '~'
  endif

  let time = localtime() - a:file.vimfiler__filetime
  if time < 86400
    " 60 * 60 * 24
    return '!'
  elseif time < 604800
    " 60 * 60 * 24 * 7
    return '#'
  else
    return '~'
  endif
endfunction
