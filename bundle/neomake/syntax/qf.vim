" Uses syntax runtime file to clear default syntax, before later Syntax
" autocommands.

if !exists('*neomake#quickfix#FormatQuickfix')
  " customqf is not used.
  finish
endif

if neomake#quickfix#is_enabled()
  call neomake#quickfix#FormatQuickfix()
endif
