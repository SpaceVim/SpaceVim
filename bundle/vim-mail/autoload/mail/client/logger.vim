let s:LOGGER = SpaceVim#api#import('logger')

let g:wsd = keys(s:LOGGER)

call s:LOGGER.set_name('vim-mail')
call s:LOGGER.set_level(1)
let s:LOGGER.silent = 0


function! mail#client#logger#info(msg)
  call s:LOGGER.info(a:msg)
endfunction

function! mail#client#logger#error(msg)
  call s:LOGGER.error(a:msg)
endfunction

function! mail#client#logger#warn(msg)

  call s:LOGGER.warn(a:msg)
  
endfunction

function! mail#client#logger#view()

  call s:LOGGER.view()

endfunction
