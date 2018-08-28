if exists("b:current_syntax")
  finish
endif
let b:current_syntax = "SpaceVimFindArgv"
syntax case ignore

syn match CMDFindArgvOpt /-[a-zA-Z]*\ /
syn match CMDFindSecArgvOpt /^\s\+[a-z]\s\+/
syn match CMDFindArgvDesc /\(-[a-zA-Z0-1]*\ \)\@<=.*/
hi def link CMDFindArgvOpt Number
hi def link CMDFindSecArgvOpt Number
hi def link CMDFindArgvDesc Comment
