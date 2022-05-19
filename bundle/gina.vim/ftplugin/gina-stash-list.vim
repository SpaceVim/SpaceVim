setlocal nomodeline
setlocal nobuflisted
setlocal nolist nospell
setlocal nowrap nofoldenable
setlocal nonumber norelativenumber
setlocal foldcolumn=0 colorcolumn=0

call gina#action#include('diff')
call gina#action#include('stash')
call gina#action#include('yank')

if g:gina#command#stash#list#use_default_aliases
  call gina#action#shorten('stash')
endif

if g:gina#command#stash#list#use_default_mappings
  nmap <buffer> <Return> <Plug>(gina-stash-show)zv
endif
