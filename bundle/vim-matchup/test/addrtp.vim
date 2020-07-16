
" rtp for testing files

let s:path = expand('<sfile>:h')
let &rtp  = s:path.'/rtp,' . &rtp

runtime! ftdetect/matchuptest.vim

