" use SpaceVim's log api

if exists('s:debug_enabled')
  finish
endif

let s:LOGGER =SpaceVim#logger#derive('tagbar')

let s:debug_enabled = 0

function! tagbar#debug#start_debug(...) abort
  call s:LOGGER.info('enable debug mode!')
  let s:debug_enabled = 1
endfunction

function! tagbar#debug#stop_debug() abort
  call s:LOGGER.info('disable debug mode!')
  let s:debug_enabled = 0
endfunction

function! tagbar#debug#log(msg) abort
  if s:debug_enabled
    call s:LOGGER.debug(a:msg)
  endif
endfunction

function! tagbar#debug#log_ctags_output(output) abort
endfunction

function! tagbar#debug#enabled() abort
  return s:debug_enabled
endfunction
