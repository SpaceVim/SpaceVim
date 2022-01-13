if exists('b:current_syntax')
    finish
endif
let b:current_syntax = 'git-commit'
syntax case ignore
syn match GitCommitIgnore /^\s*#.*/

hi def link GitCommitIgnore Comment

