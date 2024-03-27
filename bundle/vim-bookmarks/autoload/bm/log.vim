"=============================================================================
" log.vim --- log for bookmark
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:LOG = SpaceVim#logger#derive('bookmark')


function! bm#info(log) abort

  call s:LOG.info(a:log)

endfunction

function! bm#warn(log) abort
  call s:LOG.warn(a:log)
endfunction

function! bm#error(log) abort

  call s:LOG.error(a:log)

endfunction


function! bm#debug(log) abort

  call s:LOG.debug(a:log)

endfunction
