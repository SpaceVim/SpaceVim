if exists('b:current_syntax')
  finish
endif

" Use Vim's builtin syntax for gitcommit
runtime! syntax/gitcommit.vim

let b:current_syntax = 'gina-commit'
