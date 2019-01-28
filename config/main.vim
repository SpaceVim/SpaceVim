"=============================================================================
" main.vim --- Main file of SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Enable nocompatible
if has('vim_starting')
  " set default encoding to utf-8
  " Let Vim use utf-8 internally, because many scripts require this
  scriptencoding utf-8
  set encoding=utf-8
  if &compatible
    set nocompatible
  endif
  " python host
  if !empty($PYTHON_HOST_PROG)
    let g:python_host_prog  = $PYTHON_HOST_PROG
  endif
  if !empty($PYTHON3_HOST_PROG)
    let g:python3_host_prog = $PYTHON3_HOST_PROG
  endif
endif
" Detect root directory of SpaceVim
let g:_spacevim_root_dir = fnamemodify(expand('<sfile>'),
      \ ':p:h:gs?\\?'.((has('win16') || has('win32')
      \ || has('win64'))?'\':'/') . '?')
lockvar g:_spacevim_root_dir
try
  call SpaceVim#begin()
catch
  " Update the rtp only when SpaceVim is not contained in runtimepath.
  let &runtimepath .= ',' . fnamemodify(g:_spacevim_root_dir, ':p:h:h')
  call SpaceVim#begin()
endtry

call SpaceVim#custom#load()

call SpaceVim#end()
" vim:set et sw=2 cc=80:
