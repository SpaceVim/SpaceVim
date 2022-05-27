"=============================================================================
" solidity.vim --- SpaceVim solidity layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
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

function! SpaceVim#layers#lang#solidity#health() abort
  call SpaceVim#layers#lang#solidity#plugins()
  call SpaceVim#layers#lang#solidity#config()
  return 1
endfunction
