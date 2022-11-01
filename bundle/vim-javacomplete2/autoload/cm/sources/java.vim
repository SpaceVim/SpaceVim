func! cm#sources#java#register()
    " the omnifunc pattern is PCRE
    call cm#register_source({'name' : 'java',
            \ 'priority': 9, 
            \ 'scopes': ['java'],
            \ 'abbreviation': 'java',
            \ 'cm_refresh_patterns':['\.', '::'],
            \ 'cm_refresh': {'omnifunc': 'javacomplete#Complete' },
            \ })

endfunc
