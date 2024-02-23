set rtp+=.
set rtp+=../plenary.nvim/
set rtp+=../tree-sitter-lua/

runtime! plugin/plenary.vim
runtime! plugin/telescope.lua
runtime! plugin/ts_lua.vim

let g:telescope_test_delay = 100
