if exists('b:current_syntax')
    finish
endif

syntax match vlime_sldbSection /\m^Thread: \d\+; Level: \d\+$/ contains=vlime_sldbNumber
syntax match vlime_sldbSection /\m^Restarts:$/
syntax match vlime_sldbSection /\m^Frames:$/
syntax match vlime_sldbRestart /\m\(^\s*\d\+\.\s\+\)\@<=[^[:space:]]\+\(\s\+-\)\@=/
syntax match vlime_sldbNumber "-\=\(\.\d\+\|\d\+\(\.\d*\)\=\)\([dDeEfFlL][-+]\=\d\+\)\="
syntax match vlime_sldbNumber "-\=\(\d\+/\d\+\)"
syntax region vlime_sldbString start=/\m"/ skip=/\m\\\\\|\\"/ end=/\m"/
syntax region vlime_sldbObject start=/\m#</ end=/\m>/ contains=vlime_sldbObject,vlime_sldbString

hi def link vlime_sldbSection Comment
hi def link vlime_sldbRestart Operator
hi def link vlime_sldbNumber Number
hi def link vlime_sldbString String
hi def link vlime_sldbObject Constant

let b:current_syntax = 'vlime_sldb'
