" Vim compiler file
" Compiler: GPL cver

if exists("current_compiler")
  finish
endif
let current_compiler = "cver"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Error level formats
CompilerSet errorformat=\*\*%f(%l)\ ERROR\*\*\ \[%n\]\ %m

" Warning level formats
if (!exists("g:verilog_efm_level") || g:verilog_efm_level != "error")
  CompilerSet errorformat+=\*\*%f(%l)\ WARN\*\*\ \[%n\]\ %m
  CompilerSet errorformat+=\*\*\ WARN\*\*\ \[\%n\]\ %m
endif

" Load common errorformat configurations
runtime compiler/verilog_common.vim

let &cpo = s:cpo_save
unlet s:cpo_save

" vi: sw=2 sts=2:
