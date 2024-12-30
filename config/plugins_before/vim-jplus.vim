if index(get(g:, 'spacevim_disabled_plugins', []), 'vim-jplus') != 0
  " osyo-manga/vim-jplus {{{
  nmap <silent> J <Plug>(jplus)
  vmap <silent> J <Plug>(jplus)
  " }}}
endif
