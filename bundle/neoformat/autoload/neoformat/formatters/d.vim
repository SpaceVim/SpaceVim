function! neoformat#formatters#d#enabled() abort
    return ['uncrustify', 'dfmt']
endfunction

function! neoformat#formatters#d#dfmt() abort
    return {
        \ 'exe': 'dfmt',
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#d#uncrustify() abort
    return {
        \ 'exe': 'uncrustify',
        \ 'args': ['-q', '-l D'],
        \ 'stdin': 1,
        \ }
endfunction
