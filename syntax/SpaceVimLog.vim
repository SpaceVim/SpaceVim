if exists('b:current_syntax') && b:current_syntax ==# 'SpaceVimLog'
  finish
endif
let b:current_syntax = 'SpaceVimLog'
syntax case ignore

syn match SPCLogHead /^###.*/
syn match SPCLogWarn /^.*\[ Warn ].*/
syn match SPCLogError /^.*\[ Error].*/
hi def link SPCLogHead TODO
hi def link SPCLogWarn WarningMsg
hi def link SPCLogError Error

