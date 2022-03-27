"=============================================================================
" followHEAD.vim --- generate follow HEAD page
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:AUTODOC = SpaceVim#api#import('dev#autodoc')
let s:AUTODOC.begin = '^<!-- SpaceVim follow HEAD en start -->$'
let s:AUTODOC.end = '^<!-- SpaceVim follow HEAD en end -->$'

function! s:generate_content(lang) abort
  let content = SpaceVim#dev#releases#parser_prs(a:lang)
  return content
endfunction

let s:AUTODOC.content_func = function('s:generate_content')
let s:AUTODOC.autoformat = 1

function! SpaceVim#dev#followHEAD#update(lang) abort
  call s:AUTODOC.update(a:lang)
endfunction


