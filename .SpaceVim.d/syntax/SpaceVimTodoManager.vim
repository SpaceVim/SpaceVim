if exists('b:current_syntax') && b:current_syntax ==# 'SpaceVimTodoManager'
  finish
endif
let b:current_syntax = 'SpaceVimTodoManager'
syntax case ignore

syn match FileName /^[^ ]*/
syn match TODOTAG  /^\s*@[a-zA-Z]*/
" syn match TODOCHECKBOX /[\d\+/\d\+\]/
syn match TODOINDEX /^\s\+\d\+\.\s/
syn match TODOCHECKBOXPANDING /\s\+√\s\+/
syn match TODOCHECKBOXDONE /\s\+□\s\+/
syn match TODOCHECKBOXNOTE /\s\+·\s\+/
syn match TODODUETIME /\d\+[d]$\|\d\+[d]\s\*$/
hi def link FileName Comment
