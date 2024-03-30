let s:LOGGER = SpaceVim#logger#derive('bookmark')

function! bookmarks#logger#info(msg) abort
  call s:LOGGER.info(a:msg)
endfunction

function! bookmarks#logger#debug(msg) abort
  call s:LOGGER.debug(a:msg)
endfunction

function! bookmarks#logger#warn(msg) abort
  call s:LOGGER.warn(a:msg)
endfunction
