if exists('b:current_syntax')
    finish
endif

syntax region vlime_mreplComment start=/\m\([^\\]\@<=;\)\|\(^;\)/ end=/\m$/ contains=vlime_mreplWarning,vlime_mreplError,vlime_mreplConditionSummary keepend
syntax match vlime_mreplConditionSummary /\m\(\s\|^\)\@<=caught \d\+ .\+ conditions*\(\s\|$\)\@=/
syntax match vlime_mreplWarning /\m\(\s\|^\)\@<=\(\(WARNING\)\|\(STYLE-WARNING\)\):\(\s\|$\)\@=/
syntax match vlime_mreplError /\m\(\s\|^\)\@<=ERROR:\(\s\|$\)\@=/
syntax region vlime_mreplObject start=/\m#</ end=/\m>/ contains=vlime_mreplObject,vlime_mreplString
syntax region vlime_mreplString start=/\m"/ skip=/\m\\\\\|\\"/ end=/\m"/
syntax match vlime_mreplNumber "-\=\(\.\d\+\|\d\+\(\.\d*\)\=\)\([dDeEfFlL][-+]\=\d\+\)\="
syntax match vlime_mreplNumber "-\=\(\d\+/\d\+\)"
syntax match vlime_mreplPrompt /\m^[^>]\+> /

hi def link vlime_mreplPrompt Comment
hi def link vlime_mreplObject Constant
hi def link vlime_mreplString String
hi def link vlime_mreplNumber Constant
hi def link vlime_mreplComment Comment
hi def link vlime_mreplConditionSummary WarningMsg
hi def link vlime_mreplWarning WarningMsg
hi def link vlime_mreplError ErrorMsg

let b:current_syntax = 'vlime_mrepl'
