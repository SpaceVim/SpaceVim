augroup filetypedetect
  " Since templates can be anything, check any file.
  autocmd BufRead,BufNewFile * call djangoplus#detect#filetype(expand('<afile>:p'))
augroup END
