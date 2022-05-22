" we need a clean environment

" remove user's .vimrc - what else?
set runtimepath-=~/.vimrc

" add .. as vim-plugin-path (for syntax)
set runtimepath^=../

" nocompat is needed for html-output
set nocompatible

syntax on
