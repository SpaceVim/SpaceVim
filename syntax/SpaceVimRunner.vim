if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "SpaceVimRunner"
syntax case ignore
syn match KeyBindings /\[Running\]/
syn match KeyBindings /\[Compile\]/
syn match RunnerCmd /\(\[Running\]\ \)\@<=.*/
syn match RunnerCmd /\(\[Compile\]\ \)\@<=.*/
syn match DoneSucceeded /\[Done]\(\ exited\ with\ code=0\)\@=/
syn match DoneFailed /\[Done]\(\ exited\ with\ code=[^0]\)\@=/
syn match ExitCode /\(\[Done\]\ exited\ with \)\@<=code=0/
syn match ExitCodeFailed /\(\[Done\]\ exited\ with \)\@<=code=[^0]/

hi def link RunnerCmd Comment
hi def link KeyBindings String
hi def link DoneSucceeded String
hi def link DoneFailed WarningMsg
hi def link ExitCode MoreMsg
hi def link ExitCodeFailed WarningMsg
