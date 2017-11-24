au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'B',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))
