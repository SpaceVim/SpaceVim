if exists('b:current_syntax')
    finish
endif

syntax region vlime_arglistMarkedArg start=/\m\(\(^\|[^=]\)===>\(\_s\+\)\)\@<=/ end=/\m\(\(\_s\+\)<===\($\|[^=]\)\)\@=/
syntax region vlime_arglistMarkedArg start=/\m\(\(^\|[^=]\)===>\(\_s\+\)(\)\@<=/ end=/\m\(\_s\+\)\@=/
syntax match vlime_arglistArgMarker /\m\(^\|[^=]\)\@<====>\(\_s\+\)/ conceal
syntax match vlime_arglistArgMarker /\m\(\_s\+\)<===\($\|[^=]\)\@=/ conceal
syntax match vlime_arglistOperator /\m\(^(\)\@<=[^[:space:]]\+\(\_s\+\)\@=/

hi def link vlime_arglistOperator Operator
hi def link vlime_arglistArgMarker Comment
hi def link vlime_arglistMarkedArg Identifier

let b:current_syntax = 'vlime_arglist'
