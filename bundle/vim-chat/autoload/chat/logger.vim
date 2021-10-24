let s:LOGGER =SpaceVim#logger#derive('vim-chat')

function! chat#logger#info(msg)
  call s:LOGGER.info(a:msg)
endfunction

function! chat#logger#error(msg)
  call s:LOGGER.error(a:msg)
endfunction

function! chat#logger#warn(msg)

  call s:LOGGER.warn(a:msg)
  
endfunction

