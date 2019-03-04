augroup asyncomplete_clang
  autocmd!
  autocmd User asyncomplete_setup call asyncomplete#register_source(
        \ asyncomplete#sources#clang#get_source_options({
        \     'config': {
        \         'clang_path': get(g:, 'asyncomplete_clang_executable', 'clang'),
        \         'clang_args': {
        \             'default': ['-I/opt/llvm/include'],
        \         }
        \     }
        \ }))
augroup END
