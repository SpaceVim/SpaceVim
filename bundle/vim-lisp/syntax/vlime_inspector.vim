if exists('b:current_syntax')
    finish
endif

syntax region vlime_inspectorObject start=/\m#</ end=/\m>/ contains=vlime_inspectorObject,vlime_inspectorString
syntax region vlime_inspectorString start=/\m"/ skip=/\m\\\\\|\\"/ end=/\m"/
syntax match vlime_inspectorNumber "-\=\(\.\d\+\|\d\+\(\.\d*\)\=\)\([dDeEfFlL][-+]\=\d\+\)\="
syntax match vlime_inspectorNumber "-\=\(\d\+/\d\+\)"

hi def link vlime_inspectorObject Constant
hi def link vlime_inspectorString String
hi def link vlime_inspectorNumber Number
hi def link vlime_inspectorAction Operator
hi def link vlime_inspectorValue Constant

let b:current_syntax = 'vlime_inspector'
