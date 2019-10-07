"=============================================================================
" window.vim --- window api for vim and neovim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}

function! s:self.get_cursor(winid) abort
  
endfunction

function! SpaceVim#api#vim#window#get() abort
    return deepcopy(s:self)
endfunction
