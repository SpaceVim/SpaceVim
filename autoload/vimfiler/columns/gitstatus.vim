"=============================================================================
" gitstatus.vim --- git status support for vimfiler
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim
scriptencoding utf-8

let s:fish = &shell =~# 'fish'

function! vimfiler#columns#gitstatus#define() abort
  return s:column
endfunction"}}}

let s:column = {
      \ 'name' : 'gitstatus',
      \ 'description' : 'plugin for vimfiler that provides git status support',
      \ 'syntax' : 'vimfilerColumn__Git',
      \ }

" @vimlint(EVL103, 1, a:files)
" @vimlint(EVL103, 1, a:context)
function! s:column.length(files, context) abort
  return 3
endfunction
" @vimlint(EVL103, 0, a:files)
" @vimlint(EVL103, 0, a:context)

if !exists('g:VimFilerGitIndicatorMap')
  let g:VimFilerGitIndicatorMap = {
        \ 'Modified'  : '✹',
        \ 'Staged'    : '✚',
        \ 'Untracked' : '✭',
        \ 'Renamed'   : '➜',
        \ 'Unmerged'  : '═',
        \ 'Deleted'   : '✖',
        \ 'Dirty'     : '✗',
        \ 'Clean'     : '✔︎',
        \ 'Ignored'   : '☒',
        \ 'Unknown'   : '?'
        \ }
endif

" @vimlint(EVL103, 1, a:context)
function! s:column.define_syntax(context) abort
  for name in keys(g:VimFilerGitIndicatorMap)
    exe 'syntax match   vimfilerColumn__Git' . name
          \ . " '\[" . g:VimFilerGitIndicatorMap[name]
          \ . "\]' contained containedin=vimfilerColumn__Git"
  endfor
  highlight def link  vimfilerColumn__GitModified Special
  highlight def link  vimfilerColumn__GitStaged   Function
  highlight def link  vimfilerColumn__GitUnstaged Text
  highlight def link  vimfilerColumn__GitRenamed  Title
  highlight def link  vimfilerColumn__GitUnmerged Label
  highlight def link  vimfilerColumn__GitDeleted  Text
  highlight def link  vimfilerColumn__GitDirty    Tag
  highlight def link  vimfilerColumn__GitClean    DiffAdd   
  highlight def link  vimfilerColumn__GitUnknown  Text   
endfunction
" @vimlint(EVL103, 0, a:context)

function! s:directory_of_file(file) abort
  return fnamemodify(a:file, ':h')
endfunction


function! s:system(cmd, ...) abort
  silent let output = (a:0 == 0) ? system(a:cmd) : system(a:cmd, a:1)
  return output
endfunction

function! s:git_shellescape(arg) abort
  if a:arg =~# '^[A-Za-z0-9_/.-]\+$'
    return a:arg
  elseif &shell =~# 'cmd' || gitgutter#utility#using_xolox_shell()
    return '"' . substitute(substitute(a:arg, '"', '""', 'g'), '%', '"%"', 'g') . '"'
  else
    return shellescape(a:arg)
  endif
endfunction

function! s:cmd_in_directory_of_file(file, cmd) abort
  return 'cd '.s:git_shellescape(s:directory_of_file(a:file)) . (s:fish ? '; and ' : ' && ') . a:cmd
endfunction



function! s:git_state_to_name(symb)  abort
  if a:symb ==# '?'
    return 'Untracked'
  elseif a:symb ==# ' '
    return 'Modified'
  elseif a:symb =~# '[MAC]'
    return 'Staged'
  elseif a:symb ==# 'R'
    return 'Renamed'
  elseif a:symb ==# 'U' || a:symb ==# 'A' || a:symb ==# 'D' 
    return 'Unmerged'
  elseif a:symb ==# '!'
    return 'Ignored'
  else
    return 'Unknown'
  endif

endfunction

function! s:git_state_to_symbol(s) abort
  let name = s:git_state_to_name(a:s)
  return g:VimFilerGitIndicatorMap[name]
endfunction

" @vimlint(EVL103, 1, a:context)
function! s:column.get(file, context) abort
  let cmd = 'git -c color.status=false status -s ' .  fnamemodify(a:file.action__path, ':.')
  let output = systemlist(cmd)
  if v:shell_error
    return '   '
  endif
  if a:file.vimfiler__is_directory
    if !empty(output)
      return '[' . g:VimFilerGitIndicatorMap['Dirty'] . ']'
    else
      return '   '
    endif
  else
    if !empty(output)
      let symb = split(output[0])[0]
      return '[' . g:VimFilerGitIndicatorMap[s:git_state_to_name(symb)] . ']'
    else
      return '   '
    endif
  endif
endfunction
" @vimlint(EVL103, 0, a:context)

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et sw=2:
