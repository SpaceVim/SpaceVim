" Vim compiler file
" Compiler: Cadence NCVerilog

if exists("current_compiler")
  finish
endif
let current_compiler = "ncverilog"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Error level formats
" Based on https://github.com/vhda/verilog_systemverilog.vim/issues/88
CompilerSet errorformat =%.%#:\ *%t\\,%.%#\ %#\(%f\\,%l\|%c\):\ %m
CompilerSet errorformat+=%.%#:\ *%t\\,%.%#\ %#\(%f\\,%l\):\ %m
" Multi-line error messages
CompilerSet errorformat+=%A%.%#\ *%t\\,%.%#:\ %m,%ZFile:\ %f\\,\ line\ =\ %l\\,\ pos\ =\ %c

" Ignore Warning level formats
if (!exists("g:verilog_efm_level") || g:verilog_efm_level == "error")
  CompilerSet errorformat^=%-G%.%#\ *W\\,%.%#:\ %m
endif

" Load common errorformat configurations
runtime compiler/verilog_common.vim

let &cpo = s:cpo_save
unlet s:cpo_save

" vi: sw=2 sts=2:
