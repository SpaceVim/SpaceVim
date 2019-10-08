"=============================================================================
" vimrc --- Entry file for vim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Note: Skip initialization for vim-tiny or vim-small.
if 1
    let g:_spacevim_if_lua = 0
    if has('lua')
        try
            let s:plugin_dir = fnamemodify(expand('<sfile>'), ':h').'\lua'
            let s:str = s:plugin_dir . '\?.lua;' . s:plugin_dir . '\?\init.lua;'
            lua package.path=vim.eval("s:str") .. package.path
            let g:_spacevim_if_lua = 1
        catch
            let g:_spacevim_if_lua = 0
        endtry
    endif
    execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/main.vim'
endif
" vim:set et sw=2
