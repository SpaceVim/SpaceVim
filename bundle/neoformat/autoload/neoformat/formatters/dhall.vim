function! neoformat#formatters#dhall#enabled() abort
    return ['dhall']
endfunction

function! neoformat#formatters#dhall#dhall() abort
    return {
        \ 'exe': 'dhall',
        \ 'args': ['format'],
        \ 'stdin': 1
        \ }
endfunction
