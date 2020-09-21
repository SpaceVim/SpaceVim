"=============================================================================
" scrollbar.vim --- scrollbar support for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:default = {
      \    'max_size' : 10,
      \    'min_size' : 3,
      \    'width' : 1,
      \    'right_offset' : 1,
      \    'excluded_filetypes' : {},
      \    'shape' : {
      \        'head' : '▲',
      \        'body' : '█',
      \        'tail' : '▼',
      \    },
      \    'highlight' : {
      \        'head' : 'Normal',
      \        'body' : 'Normal',
      \        'tail' : 'Normal',
      \    }
      \ }

function! SpaceVim#plugins#scrollbar#clear() abort

  let bufnr = 0
  let state = getbufver(bufnr, 'scrollbar_state')

endfunction

