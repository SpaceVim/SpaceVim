let &rtp = expand('<sfile>:p:h:h') . ',' . &rtp . ',' . expand('<sfile>:p:h:h') . '/after'

exe "so " . expand('<sfile>:p:h:h') . '/plugin/vrs.vim'
