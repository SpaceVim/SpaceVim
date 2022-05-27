" Only load this indent file when no other was loaded.
if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

" Not perfect, but mostly good enough...
setlocal autoindent nocindent cinwords= smartindent

let b:undo_indent = 'setlocal autoindent< cindent< cinwords< smartindent<'
