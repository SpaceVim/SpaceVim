if exists('b:current_syntax') && b:current_syntax ==# 'SpaceVimGitLogPopup'
  finish
endif
let b:current_syntax = 'SpaceVimGitLogPopup'
syntax case ignore

" option title
syn match GitLogPopupTitle /^[A-Z].*/
" key binding
syn match GitLogKey /\ [-=]\?[a-zA-Z]\ /
" desc
syn match GitLogDesc /\(\ [-=]\?[a-zA-Z]\ \)\@<=[A-Z][a-z]*\s\([a-zA-Z-]\+\s\)*\([a-zA-Z]\)\+/
syn match GitLogOption /\((\)\@<=[^(^)]*/
hi def link GitLogPopupTitle ModeMsg
hi def link GitLogKey Type
hi def link GitLogDesc Identifier
hi def link GitLogOption Comment

