" This vimrc is for manual test, is not relavant with themis
" $ vim -N -u test/test.vimrc

set nocompatible
let s:path = expand("<sfile>:h:h")
set runtimepath&
let &runtimepath .= ',' . s:path

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
