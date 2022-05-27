vim.cmd [[set runtimepath+=.]]
vim.cmd [[runtime! plugin/plenary.vim]]
vim.cmd [[runtime! plugin/nvim-treesitter.vim]]

vim.cmd [[au BufRead,BufNewFile *.conf set filetype=hocon]]
vim.cmd [[au BufRead,BufNewFile *.gleam set filetype=gleam]]

vim.o.swapfile = false
vim.bo.swapfile = false

require("nvim-treesitter.configs").setup {
  indent = { enable = true },
  highlight = { enable = true },
}
