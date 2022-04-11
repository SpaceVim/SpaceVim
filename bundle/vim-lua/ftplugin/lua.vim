setlocal omnifunc=lua#complete

if &l:foldmethod ==# 'expr'
  setlocal foldexpr=lua#fold#foldlevel(v:lnum)
endif
setlocal nofoldenable
