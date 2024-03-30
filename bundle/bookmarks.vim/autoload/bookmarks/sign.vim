"=============================================================================
" sign.vim --- sign for bookmarks
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:sign_name = 'bookmarks'

call sign_define(s:sign_name, {
      \ 'text' : g:bookmarks_sign_text,
      \ 'texthl' : g:bookmarks_sign_highlight
      \ })


function! bookmarks#sign#add(file, lnum) abort
  return sign_place(0, '', s:sign_name, a:file, {'lnum':a:lnum} )
endfunction

function! bookmarks#sign#get_lnums(buf) abort

  let signs = filter(sign_getplaced(a:buf)[0].signs, 'v:val.name == "bookmarks"')

  let map = {}

  for sign in signs
    call extend(map, { sign.id : sign.lnum })
  endfor
  
  return map
endfunction
