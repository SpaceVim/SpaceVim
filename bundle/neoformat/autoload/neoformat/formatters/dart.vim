function! neoformat#formatters#dart#enabled() abort
    return ['dartfmt']
endfunction

function! neoformat#formatters#dart#dartfmt() abort
    return {
        \ 'exe': 'dartfmt',
        \ 'stdin': 1,
        \ }
endfunction
