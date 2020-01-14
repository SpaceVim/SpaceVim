"=============================================================================
" sql.vim --- lang#sql layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#sql#plugins() abort
  let plugins = []
  call add(plugins, ['tpope/vim-dadbod', {'merged' : 0}])
  return plugins
endfunction
