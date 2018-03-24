"=============================================================================
" main.vim --- Main file of SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Detect root directory of SpaceVim
let g:_spacevim_root_dir = fnamemodify(expand('<sfile>'),
      \ ':p:h:gs?\\?'.((has('win16') || has('win32')
      \ || has('win64'))?'\':'/') . '?')
lockvar g:_spacevim_root_dir
try
  call SpaceVim#begin()
catch
  " Update the rtp only when SpaceVim is not contained in runtimepath.
  execute 'set rtp +=' . fnamemodify(g:_spacevim_root_dir, ':p:h:h')
  call SpaceVim#begin()
endtry

call SpaceVim#loadCustomConfig()

call SpaceVim#end()
" vim:set et sw=2 cc=80:
