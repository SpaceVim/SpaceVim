if exists('b:current_syntax')
    finish
endif
let b:current_syntax = 'git-blame'
syntax case ignore
syn match GitBlameTime /[^ ]*\s\+[^ ]*\s\+[^ ]*\s\+\d\+:\d\+:\d\+$/

hi def link GitBlameTime Statement

