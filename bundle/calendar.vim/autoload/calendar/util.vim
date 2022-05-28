" =============================================================================
" Filename: autoload/calendar/util.vim
" Author: itchyny
" License: MIT License
" Last Change: 2019/07/30 22:37:39.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Utility functions.

" Version of this application.
function! calendar#util#version() abort
  return '0.0'
endfunction

" Name of this application.
function! calendar#util#name() abort
  return 'calendar.vim'
endfunction

" License of this application.
function! calendar#util#license() abort
  return 'MIT License'
endfunction

" Name of the author.
function! calendar#util#author() abort
  return 'itchyny (https://github.com/itchyny)'
endfunction

" Repository URL.
function! calendar#util#repository() abort
  return 'https://github.com/itchyny/calendar.vim'
endfunction

" Bug tracker URL.
function! calendar#util#issue() abort
  return 'https://github.com/itchyny/calendar.vim/issues'
endfunction

" winwidth
" Take the minimum width if the calendar buffer is displayed in multiple
" windows. For example, a calendar is viewed on a vertically splitted window
" and execute top new.
function! calendar#util#winwidth() abort
  return min(map(filter(range(1,winnr('$')),'winbufnr(v:val)==winbufnr(0)'),'winwidth(v:val)'))-1
endfunction

" winheight
" Take the minimum height.
function! calendar#util#winheight() abort
  return min(map(filter(range(1,winnr('$')),'winbufnr(v:val)==winbufnr(0)'),'winheight(v:val)'))
endfunction

" Used for the return value of cnoremap.
function! calendar#util#update_keys() abort
  silent! call histadd(':', getcmdline())
  return "\<End>\<C-u>silent call b:calendar.update()\<CR>"
endfunction

" Get the command line, substituting the leading colons.
function! calendar#util#getcmdline() abort
  return substitute(getcmdline(), '^\(\s*:\)*\s*', '', '')
endfunction

" Yank text
function! calendar#util#yank(text) abort
  let @" = a:text
  if has('clipboard') || has('xterm_clipboard')
    let @+ = a:text
  endif
endfunction

" Id generator
let s:id = 0
function! calendar#util#id() abort
  let [y, m, d] = calendar#day#today().get_ymd()
  let [h, i, s] = calendar#time#now().get_hms()
  let s:id = (s:id + 1) % 10000
  return printf('%04d%02d%02d%02d%02d%02d%04d', y, m, d, h, i, s, s:id)
endfunction

" Execute shell command.
function! calendar#util#system(cmd) abort
  silent! return system(a:cmd)
endfunction

" Remove directory.
if has('unix')
  function! calendar#util#rmdir(path, ...) abort
    let flags = a:0 ? a:1 : ''
    let cmd = flags =~# 'r' ? 'rm -r' : 'rmdir'
    let cmd .= flags =~# 'f' && cmd ==# 'rm -r' ? ' -f' : ''
    let ret = system(cmd . ' ' . shellescape(a:path))
  endfunction
elseif has('win32')
  function! calendar#util#rmdir(path, ...) abort
    let flags = a:0 ? a:1 : ''
    if &shell =~? 'sh$'
      let cmd = flags =~# 'r' ? 'rm -r' : 'rmdir'
      let cmd .= flags =~# 'f' && cmd ==# 'rm -r' ? ' -f' : ''
      let ret = system(cmd . ' ' . shellescape(a:path))
    else
      let cmd = 'rmdir /Q'
      let cmd .= flags =~# 'r' ? ' /S' : ''
      let ret = system(cmd . ' "' . a:path . '"')
    endif
  endfunction
else
  function! calendar#util#rmdir(path, ...) abort
  endfunction
endif

let &cpo = s:save_cpo
unlet s:save_cpo
