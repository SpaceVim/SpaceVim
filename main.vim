"=============================================================================
" main.vim --- Main file of SpaceVim
" Copyright (c) 2016-2021 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

call SpaceVim#logger#info('start to loading SpaceVim!')

" Enable nocompatible
if has('vim_starting')
  " set default encoding to utf-8

  " Let Vim use utf-8 internally, because many scripts require this
  set encoding=utf-8
  scriptencoding utf-8
  if &compatible
    " compatible mode is not supported in SpaceVim
    set nocompatible
  endif
  " python host
  if !empty($PYTHON_HOST_PROG)
    let g:python_host_prog  = $PYTHON_HOST_PROG
    call SpaceVim#logger#info('$PYTHON_HOST_PROG is not empty, setting g:python_host_prog:' . g:python_host_prog)
  endif
  if !empty($PYTHON3_HOST_PROG)
    let g:python3_host_prog = $PYTHON3_HOST_PROG
    call SpaceVim#logger#info('$PYTHON3_HOST_PROG is not empty, setting g:python3_host_prog:' . g:python3_host_prog)
    if !has('nvim') 
          \ && (has('win16') || has('win32') || has('win64'))
          \ && exists('&pythonthreedll')
          \ && exists('&pythonthreehome')
      let &pythonthreedll = get(split(globpath(fnamemodify($PYTHON3_HOST_PROG, ':h'), 'python*.dll'), '\n'), -1, '')
      call SpaceVim#logger#info('init &pythonthreedll:' . &pythonthreedll)
      let &pythonthreehome = fnamemodify($PYTHON3_HOST_PROG, ':h')
      call SpaceVim#logger#info('init &pythonthreehome:' . &pythonthreehome)
    endif
  endif
endif
" Detect root directory of SpaceVim
if has('win16') || has('win32') || has('win64')
  " this function is too slow.
  " and will be deleted soon.
  function! s:resolve(path) abort
    let cmd = 'dir /a "' . a:path . '" | findstr SYMLINK'
    " 2018/12/07 周五  下午 10:23    <SYMLINK>      vimfiles [C:\Users\Administrator\.SpaceVim]
    " ref: https://superuser.com/questions/524669/checking-where-a-symbolic-link-points-at-in-windows-7
    silent let rst = system(cmd)
    if !v:shell_error
      let dir = split(rst)[-1][1:-2]
      return dir
    endif
    return a:path
  endfunction
else
  function! s:resolve(path) abort
    return resolve(a:path)
  endfunction
endif
let g:_spacevim_root_dir = escape(fnamemodify(resolve(fnamemodify(expand('<sfile>'),
      \ ':p:h:gs?\\?'.((has('win16') || has('win32')
      \ || has('win64'))?'\':'/') . '?')), ':p:gs?[\\/]?/?'), ' ')
call SpaceVim#logger#info('init spacevim root dir:' . g:_spacevim_root_dir)
lockvar g:_spacevim_root_dir
if has('nvim')
  let s:qtdir = split(&rtp, ',')[-1]
  if s:qtdir =~# 'nvim-qt'
    let &rtp = s:qtdir . ',' . g:_spacevim_root_dir . ',' . $VIMRUNTIME
  else
    let &rtp = g:_spacevim_root_dir . ',' . $VIMRUNTIME
  endif
else
  let &rtp = g:_spacevim_root_dir . ',' . $VIMRUNTIME
endif

call SpaceVim#begin()

call SpaceVim#custom#load()

call SpaceVim#default#keyBindings()

call SpaceVim#end()

call SpaceVim#logger#info('finished loading SpaceVim!')
" vim:set et sw=2 cc=80:
