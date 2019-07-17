"=============================================================================
" solidity.vim --- SpaceVim solidity layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#solidity#plugins() abort
  let plugins = [
        \ ['tomlion/vim-solidity', {'merged' : 0, 'on_ft' : 'solidity'}]
        \ ]
  return plugins
endfunction

function! SpaceVim#layers#lang#solidity#config() abort
  
endfunction
