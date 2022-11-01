" Vim completion script for java
" Maintainer:	artur shaik <ashaihullin@gmail.com>
"
" Debug methods

let s:log = []
let s:loglevel = 1
if !exists('s:startupDate')
  let s:startupDate = reltime()
endif

" use spacevim log api, and make it easier to view log
let s:LOGGER =SpaceVim#logger#derive('jc2.vim')

function! javacomplete#logger#Enable()
  let s:loglevel = 0
endfunction

function! javacomplete#logger#Disable()
  let s:loglevel = 1
endfunction

function! javacomplete#logger#GetContent()
  new
  set modifiable
  put =s:log
  set nomodifiable
  set nomodified
endfunction

function! javacomplete#logger#Log(log)
  let log = type(a:log) == type("") ? a:log : string(a:log)
  call s:LOGGER.info(log)
endfunction

function! javacomplete#logger#warn(msg) abort
  call s:LOGGER.warn(a:msg)
endfunction

" vim:set fdm=marker sw=2 nowrap:
