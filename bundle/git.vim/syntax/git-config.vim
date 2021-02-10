if exists('b:current_syntax')
    finish
endif
let b:current_syntax = 'git-config'
syntax case ignore
syn match GitConfigKey /.*\(=\)\@=/

hi def link GitConfigKey Statement
