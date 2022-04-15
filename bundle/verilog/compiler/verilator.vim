" Vim compiler file
" Compiler: Verilator

if exists("current_compiler")
  finish
endif
let current_compiler = "verilator"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Error level formats
CompilerSet errorformat=%%%trror%.%#:\ %f:%l:%c:\ %m
CompilerSet errorformat+=%%%trror%.%#:\ %f:%l:\ %m

" Warning level formats
if (!exists("g:verilog_efm_level") || g:verilog_efm_level != "error")
  CompilerSet errorformat+=%%%tarning%.%#:\ %f:%l:%c:\ %m
  CompilerSet errorformat+=%%%tarning%.%#:\ %f:%l:\ %m
endif

" Load common errorformat configurations
runtime compiler/verilog_common.vim

let &cpo = s:cpo_save
unlet s:cpo_save

" vi: sw=2 sts=2:
