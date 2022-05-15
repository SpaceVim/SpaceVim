
" Create command for running busted
command! -nargs=1 -complete=file PlenaryBustedFile
      \ lua require('plenary.busted').run(vim.fn.expand("<args>"))

command! -nargs=+ -complete=file PlenaryBustedDirectory
      \ lua require('plenary.test_harness').test_directory_command(vim.fn.expand("<args>"))

nnoremap <Plug>PlenaryTestFile :lua require('plenary.test_harness').test_directory(vim.fn.expand("%:p"))<CR>
