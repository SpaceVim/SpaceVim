"=============================================================================
" log.vim --- logger for tagbar
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:debug_enabled')
  finish
endif

let s:LOGGER = SpaceVim#logger#derive('tagbar')

" call s:LOGGER.stop_debug()

function! tagbar#log#start_debug(...) abort
  call s:LOGGER.info('enable debug mode!')
  call s:LOGGER.start_debug()
endfunction

function! tagbar#log#stop_debug() abort
  call s:LOGGER.info('disable debug mode!')
  call s:LOGGER.stop_debug()
endfunction

function! tagbar#log#debug(msg) abort
  call s:LOGGER.debug(a:msg)
endfunction

function! tagbar#log#info(msg) abort
  call s:LOGGER.info(a:msg)
endfunction

function! tagbar#log#warn(msg) abort

  call s:LOGGER.warn(a:msg)

endfunction

function! tagbar#log#debug_enabled() abort
  return s:LOGGER.debug_enabled()
endfunction
