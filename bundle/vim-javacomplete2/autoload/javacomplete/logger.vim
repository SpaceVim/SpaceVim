" Vim completion script for java
" Maintainer:	artur shaik <ashaihullin@gmail.com>
"
" Debug methods

let s:log = []
let s:loglevel = 1
if !exists('s:startupDate')
  let s:startupDate = reltime()
endif

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
  if 0 >= s:loglevel
    let log = type(a:log) == type("") ? a:log : string(a:log)
    call add(s:log, reltimestr(reltime(s:startupDate)). " ". log)
  endif
endfunction

" vim:set fdm=marker sw=2 nowrap:
