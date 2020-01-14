if exists('b:current_syntax')
    finish
endif
let b:current_syntax = 'HelpDescribe'
syntax case ignore
syn match FileName /\(Definition:\ \)\@<=.*/
syn match KeyBindings /\[.*\]/

hi def link FileName Comment
hi def link KeyBindings String
