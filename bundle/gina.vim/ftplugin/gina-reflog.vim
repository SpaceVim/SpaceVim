setlocal nomodeline
setlocal nobuflisted
setlocal nolist nospell
setlocal nowrap nofoldenable
setlocal nonumber norelativenumber
setlocal foldcolumn=0 colorcolumn=0

call gina#action#include('changes')
call gina#action#include('commit')
call gina#action#include('show')
call gina#action#include('yank')

if g:gina#command#reflog#use_default_aliases
  call gina#action#shorten('commit')
  call gina#action#shorten('show')
endif

if g:gina#command#reflog#use_default_mappings
  nmap <buffer> <Return> <Plug>(gina-show)zv
endif
