setlocal nomodeline
setlocal nobuflisted
setlocal nolist
setlocal nowrap nofoldenable
setlocal nonumber norelativenumber
setlocal foldcolumn=0 colorcolumn=0

if g:gina#command#commit#use_default_mappings
  nmap <buffer> ! <Plug>(gina-commit-amend)
endif
