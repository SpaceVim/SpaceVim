if exists('b:current_syntax')
    finish
endif
let b:current_syntax = 'git-reflog'
syntax case ignore
syn match GitLogCommitHash /^[a-z0-9A-Z]*/

hi def link GitLogCommitHash Statement

