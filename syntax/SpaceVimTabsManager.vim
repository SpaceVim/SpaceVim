"=============================================================================
" SpaceVimTabsManager.vim --- syntax file for SpaceVim's tabmanger
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


scriptencoding utf-8
sy match TabManTName '^[▷▼]  Tab \d\+'
sy match TabManCurTName '^[▷▼] \*Tab \d\+'
sy match TabManTNr /\(^[▷▼] [ *]Tab \d\+\)\@<=.*/
sy match TabManWNr /^ \+\d\+/
sy match TabManAtv '\*$'
sy match TabManLead '[|`]-'
sy match TabManTag '+$'
sy match TabManHKey '" \zs[^:]*\ze[:,]'
sy match TabManHSpecial '\[[^ ]\+\]'
sy match TabManHelp '^".*' contains=TabManHKey,TabManTName,TabManHSpecial

hi def link TabManTName Directory
hi def link TabManTNr String
hi def link TabManWNr Number
hi def link TabManCurTName Identifier
hi def link TabManAtv Title
hi def link TabManLead Special
hi def link TabManTag Title
hi def link TabManHKey Identifier
hi def link TabManHSpecial Special
hi def link TabManHelp String
