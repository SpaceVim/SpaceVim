if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "HelpDescribe"
syntax case ignore
syn match FileName /[^:]*:\d\+:/

hi def link FileName Comment
