if exists("b:current_syntax")
  finish
endif
let b:current_syntax = "SpaceVimFlyGrep"
syntax case ignore

hi def link FileName Comment
call matchadd('FileName', '[^:]*:\d\+:', 2)
