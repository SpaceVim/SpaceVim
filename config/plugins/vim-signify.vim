augroup signify_config
  autocmd!
  if has('nvim-0.9.5')
    autocmd User Signify let lua require('spacevim.plugin.statusline').active()
  else
    autocmd User Signify let &l:statusline = SpaceVim#layers#core#statusline#get(1)
  endif
augroup END

