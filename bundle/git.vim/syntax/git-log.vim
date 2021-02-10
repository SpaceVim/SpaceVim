if exists('b:current_syntax')
    finish
endif
let b:current_syntax = 'git-log'
syntax case ignore
syn match GitLogCommitHash /^[*|\\ \/]\+\zs[a-z0-9]\+/
syn match GitLogCommitBranchLog /\(^*\s\+[a-z0-9A-Z]*\s\+-\s\+\)\@<=([^)]*)/
syn match GitLogCommitAuthorDate /([^(]*)$/

hi def link GitLogCommitHash Statement
hi def link GitLogCommitBranchLog Comment
hi def link GitLogCommitAuthorDate Comment
