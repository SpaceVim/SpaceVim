"=============================================================================
" logger.vim --- logger of vim-chat
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:LOGGER =SpaceVim#logger#derive('vim-chat')

function! chat#logger#info(msg)
  call s:LOGGER.info(a:msg)
endfunction

function! chat#logger#error(msg)
  call s:LOGGER.error(a:msg)
endfunction

function! chat#logger#debug(msg) abort

  call s:LOGGER.debug(a:msg)

endfunction

function! chat#logger#warn(msg)

  call s:LOGGER.warn(a:msg)
  
endfunction

