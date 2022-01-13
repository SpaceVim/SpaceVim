function! neoformat#formatters#purescript#enabled() abort
    return ['purstidy', 'purty']
endfunction

function! neoformat#formatters#purescript#purstidy() abort
    return {
        \ 'exe': 'purs-tidy',
        \ 'args': ['format'],
        \ 'stdin': 1,
        \ 'try_node_exe': 1,
        \ }
endfunction

function! neoformat#formatters#purescript#purty() abort
    return {
        \ 'exe': 'purty',
        \ 'args': ['-'],
        \ 'stdin': 1,
        \ 'try_node_exe': 1,
        \ }
endfunction
