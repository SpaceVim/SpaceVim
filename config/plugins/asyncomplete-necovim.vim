augroup asyncomplete_necovim
  autocmd!
  au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
        \ 'name': 'necovim',
        \ 'whitelist': ['vim'],
        \ 'completor': function('asyncomplete#sources#necovim#completor'),
        \ }))
augroup END
