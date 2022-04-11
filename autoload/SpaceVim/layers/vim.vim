"=============================================================================
" vim.vim --- SpaceVim vim layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#vim#plugins() abort
    return [
            \ ['Shougo/vimshell.vim',                { 'on_cmd':['VimShell']}],
            \ ['mattn/vim-terminal',                 { 'on_cmd':['Terminal']}],
            \ ]
endfunction

function! SpaceVim#layers#vim#config() abort
  augroup spacevim_vim_layer
    autocmd!
    " @todo clear vim comment string highlight
    " autocmd Syntax vim syntax clear vimCommentString
  augroup END
endfunction

function! SpaceVim#layers#vim#health() abort
  call SpaceVim#layers#vim#plugins()
  call SpaceVim#layers#vim#config()
  return 1
endfunction
