if exists('b:current_syntax') && b:current_syntax ==# 'SpaceVimTodoManager'
  finish
endif
let b:current_syntax = 'SpaceVimTodoManager'
syntax case ignore

syn match FileName /^[^ ]*/
hi def link FileName Comment
