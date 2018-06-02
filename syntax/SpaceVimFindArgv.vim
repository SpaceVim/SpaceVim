if exists("b:current_syntax")
  finish
endif
let b:current_syntax = "SpaceVimFindArgv"
syntax case ignore

syn match CMDFindArgvs /-[a-zA-Z]*\ /
hi def link CMDFindArgvs Comment
