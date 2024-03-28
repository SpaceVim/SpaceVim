"=============================================================================
" sign.vim --- sign for bookmarks
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:sign_name = 'bookmarks'

call sign_define(s:sign_name, {
      \ 'text' : '=>',
      \ 'texthl' : 'Normal'
      \ })


function! bookmarks#sign#add(file, lnum) abort
  return sign_place(0, '', s:sign_name, a:file, {'lnum':a:lnum} )
endfunction
