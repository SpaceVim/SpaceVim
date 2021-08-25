"=============================================================================
" main.vim --- Main file of SpaceVim
" Copyright (c) 2016-2020 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

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
  endif
  if !empty($PYTHON3_HOST_PROG)
    let g:python3_host_prog = $PYTHON3_HOST_PROG
    if !has('nvim') 
          \ && (has('win16') || has('win32') || has('win64'))
          \ && exists('&pythonthreedll')
          \ && exists('&pythonthreehome')
      let &pythonthreedll = get(split(globpath(fnamemodify($PYTHON3_HOST_PROG, ':h'), 'python*.dll'), '\n'), -1, '')
      let &pythonthreehome = fnamemodify($PYTHON3_HOST_PROG, ':h')
    endif
  endif
endif
let g:_spacevim_root_dir = escape(fnamemodify(fnamemodify(resolve(expand('<sfile>')),
      \ ':p:h:gs?\\?'.((has('win16') || has('win32')
      \ || has('win64'))?'\':'/') . '?'), ':p:gs?[\\/]?/?'), ' ')
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
" vim:set et sw=2 cc=80:
