let &rtp = expand('<sfile>:p:h:h') . ',' . &rtp . ',' . expand('<sfile>:p:h:h') . '/after'
set bs=2
ru plugin/delimitMate.vim
let runVimTests = expand('<sfile>:p:h').'/build/runVimTests'
if isdirectory(runVimTests)
  let &rtp = runVimTests . ',' . &rtp
endif
let vimTAP = expand('<sfile>:p:h').'/build/VimTAP'
if isdirectory(vimTAP)
  let &rtp = vimTAP . ',' . &rtp
endif

