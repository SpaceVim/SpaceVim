" Insert Docstring.
" Author:      Shinya Ohyanagi <sohyanagi@gmail.com>
" WebPage:     http://github.com/heavenshell/vim-pydocstriong/
" Description: Generate Python docstring to your Python script file.
" License:     BSD, see LICENSE for more details.
" NOTE:        This module is heavily inspired by php-doc.vim and
"              sonictemplate.vim
let s:save_cpo = &cpo
set cpo&vim

let g:pydocstring_templates_path = get(g:, 'pydocstring_templates_path', '')
let g:pydocstring_formatter = get(g:, 'pydocstring_formatter', 'sphinx')
let g:pydocstring_doq_path = get(
  \ g:,
  \ 'pydocstring_doq_path',
  \ printf('%s/lib/doq', expand('<sfile>:p:h:h'))
  \ )
let g:pydocstring_ignore_init = get(g:, 'pydocstring_ignore_init', 0)

let s:results = []

function! s:get_indent_width() abort
  " Get indentation width
  return &smarttab ? &shiftwidth : &softtabstop
endfunction

function! s:get_range() abort
  " Get visual mode selection.
  let mode = visualmode(1)
  if mode == 'v' || mode == 'V' || mode == ''
    let start_lineno = line("'<")
    let end_lineno = line("'>")
    return {'start_lineno': start_lineno, 'end_lineno': end_lineno}
  endif
  let current = line('.')
  return {'start_lineno': 0, 'end_lineno': '$'}
endfunction

function! s:insert_docstring(docstrings, end_lineno) abort
  let paste = &g:paste
  let &g:paste = 1

  silent! execute 'normal! ' . a:end_lineno . 'G$'
  let current_lineno = line('.')
  " If current position is bottom, add docstring below.
  if a:end_lineno == current_lineno
    silent! execute 'normal! O' . a:docstrings['docstring']
  else
    silent! execute 'normal! o' . a:docstrings['docstring']
  endif

  let &g:paste = paste
  silent! execute 'normal! ' . a:end_lineno . 'G$'
endfunction

function! s:callback(msg, indent, start_lineno) abort
  let msg = join(a:msg, '')
  " Check needed for Neovim
  if len(msg) == 0
    return
  endif

  let docstrings = reverse(json_decode(msg))
  silent! execute 'normal! 0'
  let length = len(docstrings)
  for docstring in docstrings
    let lineno = 0
    if length > 1
      call cursor(a:start_lineno + docstring['start_lineno'] - 1, 1)
      let lineno = search('\:\(\s*#.*\)*$', 'n') + 1
    else
      let lineno = search('\:\(\s*#.*\)*$', 'n') + 1
    endif

    call s:insert_docstring(docstring, lineno)
  endfor
endfunction

function! s:format_callback(msg, indent, start_lineno) abort
  call extend(s:results, a:msg)
endfunction

function! s:exit_callback(msg) abort
  unlet s:job " Needed for Neovim
  let length = len(s:results)
  if length
    if length == 1 && s:results[0] == ''
      let s:results = []
      return
    endif
    let view = winsaveview()
    silent execute '% delete'

    " Hack for Neovima PydocstringFormat
    " Neovim add blank line to the end of list
    if has('nvim') && s:results[-1] == ''
      call remove(s:results, -1)
    endif
    call setline(1, s:results)
    call winrestview(view)
    let s:results = []
  endif
endfunction

function! s:execute(cmd, lines, indent, start_lineno, cb, ex_cb) abort
  if !executable(expand(g:pydocstring_doq_path))
    redraw
    echohl Error
    echo '`doq` not found. Install `doq`.'
    echohl None
    return
  endif

  let s:results = []
  if has('nvim')
    if exists('s:job')
      call jobstop(s:job)
    endif

    let s:job = jobstart(a:cmd, {
      \ 'on_stdout': {_c, m, _e -> a:cb(m, a:indent, a:start_lineno)},
      \ 'on_exit': {_c, m, _e -> a:ex_cb(m)},
      \ 'stdout_buffered': v:true,
      \ })

    if exists('*chansend')
      " Neovim >0.3.0
      call chansend(s:job, a:lines)
      call chanclose(s:job, 'stdin')
    else
      " Legacy API
      call jobsend(s:job, a:lines)
      call jobclose(s:job, 'stdin')
    endif

  else
    if exists('s:job') && job_status(s:job) != 'stop'
      call job_stop(s:job)
    endif

    let s:job = job_start(a:cmd, {
      \ 'callback': {_, m -> a:cb([m], a:indent, a:start_lineno)},
      \ 'exit_cb': {_, m -> a:ex_cb([m])},
      \ 'in_mode': 'nl',
      \ })

    let channel = job_getchannel(s:job)
    if ch_status(channel) ==# 'open'
      call ch_sendraw(channel, a:lines)
      call ch_close_in(channel)
    endif
  endif
endfunction

function! s:create_cmd(style, omissions) abort
  if a:omissions ==# ''
    let cmd = printf(
      \ '%s --style=%s --formatter=%s --indent=%s',
      \ expand(g:pydocstring_doq_path),
      \ a:style,
      \ g:pydocstring_formatter,
      \ s:get_indent_width()
      \ )
  else
    let cmd = printf(
      \ '%s --style=%s --formatter=%s --omit=%s --indent=%s',
      \ expand(g:pydocstring_doq_path),
      \ a:style,
      \ g:pydocstring_formatter,
      \ a:omissions,
      \ s:get_indent_width()
      \ )
  endif
  if g:pydocstring_templates_path !=# ''
    let cmd = printf('%s --template_path=%s', cmd, expand(g:pydocstring_templates_path))
  endif

  return cmd
endfunction

function! pydocstring#format() abort
  let lines = printf("%s\n", join(getbufline(bufnr('%'), 1, '$'), "\n"))
  let cmd = s:create_cmd('string', '')
  let cmd = g:pydocstring_ignore_init ? printf('%s --ignore_init', cmd) : cmd

  let indent = s:get_indent_width()
  let end_lineno = line('.')
  call s:execute(
    \ cmd,
    \ lines,
    \ indent,
    \ end_lineno,
    \ function('s:format_callback'),
    \ function('s:exit_callback')
    \ )
endfunction

function! pydocstring#insert(...) abort
  let range = s:get_range()
  let pos = getpos('.')

  let line = getline('.')
  let indent = matchstr(line, '^\(\s*\)')

  let space = repeat(' ', s:get_indent_width())
  let indent = indent . space
  if len(indent) == 0
    let indent = space
  endif

  silent! execute 'normal! 0'

  let is_not_range = range['start_lineno'] == 0 && range['end_lineno'] == '$'
  if is_not_range
    let start_lineno = line('.')
    let end_lineno = search('\:\(\s*#.*\)*$')
  else
    let start_lineno = range['start_lineno']
    let end_lineno = range['end_lineno']
  endif
  call setpos('.', pos)

  let cmd = s:create_cmd('json', 'self,cls')
  let lines = join(getline(start_lineno, end_lineno), "\n")
  if is_not_range
    let lines = printf("%s\n%s%s", lines, indent, 'pass')
    let cmd = printf('%s --ignore_exception', cmd)
  endif

  call s:execute(
    \ cmd,
    \ lines,
    \ indent,
    \ start_lineno,
    \ function('s:callback'),
    \ function('s:exit_callback')
    \ )
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
