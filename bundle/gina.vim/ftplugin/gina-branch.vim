setlocal nomodeline
setlocal nobuflisted
setlocal nolist nospell
setlocal nowrap nofoldenable
setlocal nonumber norelativenumber
setlocal foldcolumn=0 colorcolumn=0

call gina#action#include('branch')
call gina#action#include('browse')
call gina#action#include('changes')
call gina#action#include('commit')
call gina#action#include('show')
call gina#action#include('yank')
call gina#action#include('ls')

if g:gina#command#branch#use_default_aliases
  call gina#action#shorten('branch')
  call gina#action#alias('checkout', 'commit:checkout')
  call gina#action#alias('checkout:track', 'commit:checkout:track')
endif

if g:gina#command#branch#use_default_mappings
  nmap <buffer> <Return> <Plug>(gina-commit-checkout)
endif
