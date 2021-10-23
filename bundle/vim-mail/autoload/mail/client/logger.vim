let s:LOGGER =SpaceVim#logger#derive('mail')

function! mail#client#logger#info(msg)
  call s:LOGGER.info(a:msg)
endfunction

function! mail#client#logger#error(msg)
  call s:LOGGER.error(a:msg)
endfunction

function! mail#client#logger#warn(msg)

  call s:LOGGER.warn(a:msg)
  
endfunction
