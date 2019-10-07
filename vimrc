"=============================================================================
" vimrc --- Entry file for vim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Note: Skip initialization for vim-tiny or vim-small.
if 1
    if has('lua')
        let s:plugin_dir = fnamemodify(expand('<sfile>'), ':h:h').'\lua'
        let s:str = s:plugin_dir . '\?.lua;' . s:plugin_dir . '\?\init.lua;'
        lua package.path=vim.eval("s:str") .. package.path
    endif
    execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/main.vim'
endif
" vim:set et sw=2
