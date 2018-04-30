autocmd User asyncomplete_setup call asyncomplete#register_source(
    \ asyncomplete#sources#clang#get_source_options({
    \     'config': {
    \         'clang_path': '/opt/llvm/bin/clang',
    \         'clang_args': {
    \             'default': ['-I/opt/llvm/include'],
    \             'cpp': ['-std=c++11', '-I/opt/llvm/include']
    \         }
    \     }
    \ }))
