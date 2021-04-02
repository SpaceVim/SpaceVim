if exists('b:current_syntax')
    finish
endif

syntax region vlime_traceObject start=/\m#</ end=/\m>/ contains=vlime_traceObject,vlime_traceString
syntax region vlime_traceString start=/\m"/ skip=/\m\\\\\|\\"/ end=/\m"/
syntax match vlime_traceNumber "-\=\(\.\d\+\|\d\+\(\.\d*\)\=\)\([dDeEfFlL][-+]\=\d\+\)\="
syntax match vlime_traceNumber "-\=\(\d\+/\d\+\)"
syntax region vlime_traceButton start=/\m\[/ end=/\m\]/
syntax match vlime_traceCallChart "\m\(^\s*\d\+ \)\@<=-\( [^ ]\)\@="
syntax match vlime_traceCallChart "\m\(\(^\|[^ ]\) \+\)\@<=|\( \+[^ ]\)\@="
syntax match vlime_traceCallChart "\m\([^ ]\+ \+\)\@<=|\?`-\( [^ ]\)\@="
syntax match vlime_traceArgMarker "\m\(\(^\|[^ ]\) \+\)\@<=>\( [^ ]\)\@="
syntax match vlime_traceRetValMarker "\m\(\(^\|[^ ]\) \+\)\@<=<\( [^ ]\)\@="

hi def link vlime_traceObject Constant
hi def link vlime_traceString String
hi def link vlime_traceNumber Number
hi def link vlime_traceButton Operator
hi def link vlime_traceCallChart Comment
hi def link vlime_traceArgMarker Comment
hi def link vlime_traceRetValMarker Comment

let b:current_syntax = 'vlime_trace'
