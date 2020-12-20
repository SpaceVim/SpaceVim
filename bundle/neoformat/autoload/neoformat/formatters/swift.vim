function! neoformat#formatters#swift#enabled() abort
    return ['swiftformat']
endfunction

function! neoformat#formatters#swift#swiftformat() abort
    return {
        \ 'exe': 'swiftformat',
        \ 'stdin': 1
        \ }
endfunction
