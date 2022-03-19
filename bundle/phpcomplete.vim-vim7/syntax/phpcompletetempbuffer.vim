" Vim syntax file
" Language: PHP - only with strings and comments for the autocomplete plugin
" Maintainer: Dávid Szabó ( complex857 AT gmail DOT com )
" URL: https://github.com/shawncplus/phpcomplete.vim
" Thanks: Paul Garvin <paul@paulgarvin.net>
"         Whos php.vim project where I've got all the code from.


if exists("b:current_syntax")
  finish
endif

syn match phpSpecialChar +\\"+   contained display
syn match phpSpecialChar "\\\$"  contained display
syn match phpStrEsc      "\\\\"  contained display
syn match phpStrEsc      "\\'"   contained display

" Comment
syn region phpComment start="/\*" end="\*/" contained extend

syn match phpComment  "#.\{-}\(?>\|$\)\@="  contained
syn match phpComment  "//.\{-}\(?>\|$\)\@=" contained

syn region phpStringDouble matchgroup=phpStringDelimiter start=+"+ skip=+\\\\\|\\"+ end=+"+  contains=phpSpecialChar,phpStrEsc contained extend keepend
syn region phpBacktick matchgroup=phpStringDelimiter start=+`+ skip=+\\\\\|\\"+ end=+`+  contains=phpSpecialChar,phpStrEsc contained extend keepend
syn region phpStringSingle matchgroup=phpStringDelimiter start=+'+ skip=+\\\\\|\\'+ end=+'+  contains=phpStrEsc contained keepend extend

" HereDoc
syn case match
syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\I\i*\)$" end="^\z1\(;\=$\)\@=" contained contains=phpSpecialChar,phpStrEsc keepend extend
syn region phpHereDoc matchgroup=Delimiter start=+\(<<<\)\@<="\z(\I\i*\)"$+ end="^\z1\(;\=$\)\@=" contained contains=phpSpecialChar,phpStrEsc keepend extend
" including HTML,JavaScript,SQL even if not enabled via options
syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(html\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=phpSpecialChar,phpStrEsc keepend extend
syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(sql\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@=" contained contains=phpSpecialChar,phpStrEsc keepend extend
syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(javascript\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=phpSpecialChar,phpStrEsc keepend extend
syn case ignore

" NowDoc
syn region phpNowDoc matchgroup=Delimiter start=+\(<<<\)\@<='\z(\I\i*\)'$+ end="^\z1\(;\=$\)\@=" contained keepend extend

" Clusters
syn cluster phpClConst contains=phpStringSingle,phpStringDouble,phpBacktick
syn cluster phpClInside contains=@phpClConst,phpComment,phpDocComment,phpHereDoc,phpNowDoc

syn region phpRegion matchgroup=Delimiter start="<?\(php\)\=" end="?>" contains=@phpClInside keepend

" Sync
if php_sync_method==-1
  syn sync match phpRegionSync grouphere phpRegion "^\s*<?\(php\)\=\s*$"
  syn sync match phpRegionSync grouphere NONE "^\s*?>\s*$"
  syn sync match phpRegionSync grouphere NONE "^\s*%>\s*$"
  syn sync match phpRegionSync grouphere phpRegion "function\s.*(.*\$"
elseif php_sync_method>0
  exec "syn sync minlines=" . php_sync_method
else
  exec "syn sync fromstart"
endif

" Define the default highlighting.
" For version 5.8 and later: only when an item doesn't have highlighting yet
if !exists("did_php_syn_inits")

  hi def link phpComment          Comment
  hi def link phpDocComment       Comment
  hi def link phpCommentStar      Comment
  hi def link phpStringSingle     String
  hi def link phpStringDouble     String
  hi def link phpBacktick         String
  hi def link phpStringDelimiter  String
  hi def link phpHereDoc          String
  hi def link phpNowDoc           String
  hi def link phpSpecialChar      String

endif

let b:current_syntax = "phpcompletetempbuffer"
