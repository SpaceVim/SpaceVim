" Vim compiler file
" Compiler: Synopsys Leda

if exists("current_compiler")
  finish
endif
let current_compiler = "leda"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Error level formats
CompilerSet errorformat=%f\\:%l:\ %.%#\[%t%.%#\]\ %m

" Load common errorformat configurations
runtime compiler/verilog_common.vim

let &cpo = s:cpo_save
unlet s:cpo_save

" vi: sw=2 sts=2:
