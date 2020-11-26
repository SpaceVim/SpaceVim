augroup ctags_core
  autocmd!
  au BufWritePost * call ctags#update()
augroup END




