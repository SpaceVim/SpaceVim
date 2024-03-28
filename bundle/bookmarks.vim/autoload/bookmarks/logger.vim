let s:LOGGER = SpaceVim#logger#derive('bookmarks')


function! bookmarks#logger#info(msg) abort

  call s:LOGGER.info(a:msg)

endfunction
