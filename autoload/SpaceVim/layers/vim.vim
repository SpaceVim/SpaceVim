"=============================================================================
" vim.vim --- SpaceVim vim layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#vim#plugins() abort
    return [
            \ ['Shougo/vimshell.vim',                { 'on_cmd':['VimShell']}],
            \ ['mattn/vim-terminal',                 { 'on_cmd':['Terminal']}],
            \ ]
endfunction
