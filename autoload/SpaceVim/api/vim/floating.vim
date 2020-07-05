"=============================================================================
" floating.vim --- vim floating api
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}

" this api is based on neovim#floating api
" options:
"   1. col
"   2. row
"   3. width
"   3. height
"   4. relative

function! s:self.open_wind(buffer, options) abort
  let col = get(a:options, 'col', 1)
  let row = get(a:options, 'row', 1)
  let width = get(a:options, 'width', 1)
  let height = get(a:options, 'height', 1) 
  let relative = get(a:options, 'relative', 1)
  return popup_creat(a:buffer, a:options)
endfunction



