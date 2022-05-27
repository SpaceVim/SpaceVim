setlocal nomodeline
setlocal nobuflisted
setlocal nolist nospell
setlocal nowrap nofoldenable
setlocal nonumber norelativenumber
setlocal foldcolumn=0 colorcolumn=0

call gina#action#include('browse')
call gina#action#include('changes')
call gina#action#include('commit')
call gina#action#include('compare')
call gina#action#include('diff')
call gina#action#include('edit')
call gina#action#include('show')
call gina#action#include('yank')
call gina#action#include('ls')

if g:gina#command#log#use_default_aliases
  call gina#action#shorten('commit')
  call gina#action#shorten('show')
endif

if g:gina#command#log#use_default_mappings
  nmap <buffer> <Return> <Plug>(gina-show)zv
endif
