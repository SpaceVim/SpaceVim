set rtp+=.
set rtp+=../plenary.nvim/
set rtp+=../tree-sitter-lua/

runtime! plugin/plenary.vim
runtime! plugin/telescope.lua

let g:telescope_test_delay = 100
