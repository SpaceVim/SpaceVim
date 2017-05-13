scriptencoding utf-8
sy match TabManTName '^[▷▼] Tab #\d\+$\|^".*\zsTab#'
sy match TabManCurTName '^Tab #\d\+\ze\*$'
sy match TabManAtv '\*$'
sy match TabManLead '[|`]-'
sy match TabManTag '+$'
sy match TabManHKey '" \zs[^:]*\ze[:,]'
sy match TabManHSpecial '\[[^ ]\+\]'
sy match TabManHelp '^".*' contains=TabManHKey,TabManTName,TabManHSpecial

hi def link TabManTName Directory
hi def link TabManCurTName Identifier
hi def link TabManAtv Title
hi def link TabManLead Special
hi def link TabManTag Title
hi def link TabManHKey Identifier
hi def link TabManHSpecial Special
hi def link TabManHelp String
