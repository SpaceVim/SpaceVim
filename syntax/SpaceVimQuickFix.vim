if exists('b:current_syntax')
    finish
endif
let b:current_syntax = 'SpaceVimQuickFix'
syntax case ignore
syn match FileName /^[^ ]*/

hi def link FileName String
