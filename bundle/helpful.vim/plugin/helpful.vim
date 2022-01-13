augroup help_versions
  autocmd! FileType vim,help call helpful#setup()
augroup END

command! -nargs=+ -complete=help HelpfulVersion call helpful#lookup(<q-args>)
