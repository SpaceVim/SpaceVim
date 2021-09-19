function! neoformat#formatters#haskell#enabled() abort
    return ['hindent', 'stylishhaskell', 'hfmt', 'brittany', 'sortimports', 'floskell', 'ormolu']
endfunction

function! neoformat#formatters#haskell#hindent() abort
    return {
        \ 'exe' : 'hindent',
        \ 'args': ['--indent-size ' . shiftwidth()],
        \ 'stdin' : 1,
        \ }
endfunction

function! neoformat#formatters#haskell#stylishhaskell() abort
    return {
        \ 'exe': 'stylish-haskell',
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#haskell#hfmt() abort
    return {
        \ 'exe': 'hfmt',
        \ 'args': ['-'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#haskell#brittany() abort
    return {
        \ 'exe': 'brittany',
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#haskell#sortimports() abort
    return {
        \ 'exe': 'sort-imports',
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#haskell#floskell() abort
    return {
        \ 'exe': 'floskell',
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#haskell#ormolu() abort
    let opts = get(g:, 'ormolu_ghc_opt', [])
    if opts != []
        let opts = '-o' . join(opts, ' -o')
    else
        let opts = ''
    endif
    return {
        \ 'exe' : 'ormolu',
        \ 'args': [opts],
        \ 'stdin' : 1,
        \ }
endfunction
