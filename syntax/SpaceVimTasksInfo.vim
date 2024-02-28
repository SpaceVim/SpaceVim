if exists('b:current_syntax') && b:current_syntax ==# 'SpaceVimTasksInfo'
  finish
endif
let b:current_syntax = 'SpaceVimTasksInfo'
syntax case ignore

syn match TaskName /^\[.*\]/
syn match TaskTitle /^Task\s\+Type\s\+Command/

" ref:
" https://github.com/vim/vim/issues/598
" https://stackoverflow.com/questions/49323753/vim-syntax-file-not-matching-with-zs
" https://stackoverflow.com/questions/64153655/why-taskinfo-syntax-file-does-not-work-as-expect
" syn match TaskType  /^\[.*\]\s*\zs[a-z]*/
" syn match TaskDescription  /^\[.*\]\s*[a-z]*\s\+\zs.*/

syn match TaskType  /\(^\[.\+\]\s\+\)\@<=[a-z]*/
syn match TaskDescription  /\(^\[.*\]\s\+[a-z]\+\s\+\)\@<=.*/
hi def link TaskTitle Title
hi def link TaskName String
hi def link TaskType Todo
hi def link TaskDescription Comment


