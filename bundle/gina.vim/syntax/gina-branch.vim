if exists('b:current_syntax')
  finish
endif

let s:ANSI = vital#gina#import('Vim.Buffer.ANSI')
call s:ANSI.define_syntax()

let b:current_syntax = 'gina-branch'
