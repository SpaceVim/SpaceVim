"=============================================================================
" filetype.vim --- filetype detect for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

au BufRead,BufNewFile *.rs set filetype=rust
au BufNewFile,BufRead *.sol setf solidity

" vim:set et sw=2
