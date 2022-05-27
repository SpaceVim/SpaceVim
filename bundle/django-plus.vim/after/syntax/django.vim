if exists('b:did_django_syntax') || &l:filetype =~# '^html'
  finish
endif

let b:did_django_syntax = 1
let b:django_orig_syntax = get(b:, 'current_syntax', 'django')
unlet! b:current_syntax
runtime! syntax/django.vim
let b:current_syntax = b:django_orig_syntax
unlet b:django_orig_syntax
