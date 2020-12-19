augroup asyncomplete_omni
  autocmd!
  au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
        \ 'name': 'omni',
        \ 'whitelist': ['*'],
        \ 'blacklist': ['html', 'c', 'cpp'],
        \ 'completor': function('asyncomplete#sources#omni#completor')
        \  }))
augroup END
