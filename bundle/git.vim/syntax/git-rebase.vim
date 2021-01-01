if exists('b:current_syntax')
    finish
endif
let b:current_syntax = 'git-rebase'
syntax case ignore
syn match GitRebaseIgnore /^\s*#.*/
syn keyword GitRebaseKeyword pick edit squash

hi def link GitRebaseIgnore Comment
hi def link GitRebaseKeyword	Statement

