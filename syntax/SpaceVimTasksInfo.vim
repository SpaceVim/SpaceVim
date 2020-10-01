if exists('b:current_syntax') && b:current_syntax ==# 'SpaceVimTasksInfo'
  finish
endif
let b:current_syntax = 'SpaceVimTasksInfo'
syntax case ignore

syn match TaskName /^\[.*\]/
syn match TaskType  /^\[.*\]\s*\zs[a-z]*/
syn match TaskDescription  /^\[.*\]\s*[a-z]*\s\+\zs.*/
hi def link TaskName Title
hi def link TaskType Todo
hi def link TaskDescription Comment


