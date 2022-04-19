" Vim compiler file
" Compiler: Synopsys Spyglass

if exists("current_compiler")
  finish
endif
let current_compiler = "spyglass"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Error level formats
CompilerSet errorformat =%.%#\ %\\+%tATAL\ %\\+%[a-zA-Z0-9]%\\+\ %\\+%f\ %\\+%l\ %\\+%n\ %\\+%m
CompilerSet errorformat+=%.%#\ %\\+%tRROR\ %\\+%[a-zA-Z0-9]%\\+\ %\\+%f\ %\\+%l\ %\\+%n\ %\\+%m
CompilerSet errorformat+=%.%#\ %\\+Syntax\ %\\+%f\ %\\+%l\ %\\+%m

" Warning level formats
if (!exists("g:verilog_efm_level") || g:verilog_efm_level != "error")
  CompilerSet errorformat+=%.%#\ %\\+%tARNING\ %\\+%[a-zA-Z0-9]%\\+\ %\\+%f\ %\\+%l\ %\\+%n\ %\\+%m
endif

" Load common errorformat configurations
runtime compiler/verilog_common.vim

let &cpo = s:cpo_save
unlet s:cpo_save

" vi: sw=2 sts=2:
