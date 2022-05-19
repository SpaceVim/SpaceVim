setlocal nomodeline
setlocal nobuflisted
setlocal nolist nospell
setlocal nowrap nofoldenable
setlocal nonumber norelativenumber
setlocal foldcolumn=0 colorcolumn=0

call gina#action#include('blame')
call gina#action#include('browse')
call gina#action#include('changes')
call gina#action#include('compare')
call gina#action#include('diff')
call gina#action#include('show')
call gina#action#include('yank')
call gina#action#include('ls')

if g:gina#command#blame#use_default_aliases
  call gina#action#shorten('blame')
endif

if g:gina#command#blame#use_default_mappings
  nmap <buffer> <Return>    <Plug>(gina-blame-open)
  nmap <buffer> <Backspace> <Plug>(gina-blame-back)
  nmap <buffer> <C-L>       <Plug>(gina-blame-C-L)
endif
