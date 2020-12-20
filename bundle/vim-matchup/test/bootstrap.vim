set nocompatible

" load match-up
let s:path = simplify(expand('<sfile>:h').'/..')
let &rtp  = s:path.',' . &rtp
let &rtp .= ','.s:path.'/after'

" rtp for testing files
let &rtp  = s:path.'/test/rtp,' . &rtp

" load other plugins, if necessary
" let &rtp = '~/path/to/other/plugin,' . &rtp

filetype plugin indent on
syntax enable

" match-up options go here

