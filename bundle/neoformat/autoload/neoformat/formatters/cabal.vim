function! neoformat#formatters#cabal#enabled() abort
    return ['cabalfmt']
endfunction

function! neoformat#formatters#cabal#cabalfmt() abort
    return {
        \ 'exe' : 'cabal-fmt',
        \ 'stdin' : 1,
        \ }
endfunction
