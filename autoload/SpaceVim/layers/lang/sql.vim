"=============================================================================
" sql.vim --- lang#sql layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#sql#plugins() abort
  let plugins = []
  call add(plugins, ['tpope/vim-dadbod', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#sql#health() abort
  call SpaceVim#layers#lang#sql#plugins()
  return 1
endfunction
