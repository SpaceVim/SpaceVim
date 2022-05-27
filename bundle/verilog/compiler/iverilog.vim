" Vim compiler file
" Compiler: Icarus Verilog

if exists("current_compiler")
  finish
endif
let current_compiler = "iverilog"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Error level formats
CompilerSet errorformat=%f\\:%l:\ %m

" Load common errorformat configurations
runtime compiler/verilog_common.vim

let &cpo = s:cpo_save
unlet s:cpo_save

" vi: sw=2 sts=2:
