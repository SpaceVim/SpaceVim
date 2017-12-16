"=============================================================================
" vimrc --- Entry file for vim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

" Note: Skip initialization for vim-tiny or vim-small.
if 1
  execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/main.vim'
endif
" vim:set et sw=2
