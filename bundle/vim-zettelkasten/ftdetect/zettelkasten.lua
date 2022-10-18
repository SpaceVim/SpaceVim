vim.cmd([[augroup zettelkasten_ft]])
vim.cmd([[au!]])
vim.cmd([[autocmd BufNewFile,BufRead zk://browser setlocal filetype=zkbrowser]])
vim.cmd([[augroup END]])
