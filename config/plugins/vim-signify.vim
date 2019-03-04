augroup signify_config
  autocmd!
  autocmd User Signify let &l:statusline = SpaceVim#layers#core#statusline#get(1)
augroup END

