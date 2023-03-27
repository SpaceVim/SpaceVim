"=============================================================================
" log.vim --- xmake logger
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
let s:LOGGER = SpaceVim#logger#derive('xmake')


function! xmake#log#info(msg) abort
  call s:LOGGER.info(a:msg)
endfunction


function! xmake#log#debug(msg) abort
  call s:LOGGER.debug(a:msg)
endfunction
