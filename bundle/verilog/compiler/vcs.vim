" Vim compiler file
" Compiler: Synopsys VCS

if exists("current_compiler")
  finish
endif
let current_compiler = "vcs"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

" Error level formats
CompilerSet errorformat =%EError-\[%.%\\+\]\ %m
CompilerSet errorformat+=%C%m\"%f\"\\,\ %l%.%#
CompilerSet errorformat+=%C%f\\,\ %l
CompilerSet errorformat+=%C%\\s%\\+%l:\ %m\\,\ column\ %c
CompilerSet errorformat+=%C%\\s%\\+%l:\ %m
CompilerSet errorformat+=%C%m\"%f\"\\,%.%#
CompilerSet errorformat+=%Z%p^                      "Column pointer
CompilerSet errorformat+=%C%m                       "Catch all rule
CompilerSet errorformat+=%Z                         "Error message end on empty line

" Warning level formats
if (!exists("g:verilog_efm_level") || g:verilog_efm_level != "error")
  CompilerSet errorformat+=%WWarning-\[%.%\\+]\\$
  CompilerSet errorformat+=%-WWarning-[LCA_FEATURES_ENABLED]\ Usage\ warning    "Ignore LCA enabled warning
  CompilerSet errorformat+=%WWarning-\[%.%\\+\]\ %m
endif

" Lint level formats
if (!exists("g:verilog_efm_level") || g:verilog_efm_level == "lint")
  CompilerSet errorformat+=%I%tint-\[%.%\\+\]\ %m
endif

" Load common errorformat configurations
runtime compiler/verilog_common.vim

let &cpo = s:cpo_save
unlet s:cpo_save

" vi: sw=2 sts=2:
