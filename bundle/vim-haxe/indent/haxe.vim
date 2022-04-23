" Language:     Haxe
" Maintainer:   None!  Wanna improve this?
" Last Change:  2007 Jan 22

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

" C indenting is not too bad.
setlocal cindent
setlocal cinoptions+=j1,J1
setlocal indentkeys=0{,0},0),0],!^F,o,O,e
let b:undo_indent = "setl cin<"
