setlocal nomodeline
setlocal nobuflisted
setlocal nolist nospell
setlocal nowrap nofoldenable
setlocal nonumber norelativenumber
setlocal foldcolumn=0 colorcolumn=0

call gina#action#include('browse')
call gina#action#include('compare')
call gina#action#include('diff')
call gina#action#include('edit')
call gina#action#include('show')
call gina#action#include('yank')

if g:gina#command#changes#use_default_aliases
  call gina#action#shorten('edit')
endif

if g:gina#command#changes#use_default_mappings
  nmap <buffer> <Return> <Plug>(gina-edit)zv

  nmap <buffer> dd <Plug>(gina-diff)
  nmap <buffer> DD <Plug>(gina-diff-vsplit)

  nmap <buffer> cc <Plug>(gina-compare)
  nmap <buffer> CC <Plug>(gina-compare-tab)
endif
