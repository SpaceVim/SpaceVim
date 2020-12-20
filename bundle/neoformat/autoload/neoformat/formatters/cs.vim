function! neoformat#formatters#cs#enabled() abort
    return ['uncrustify', 'astyle']
endfunction

function! neoformat#formatters#cs#uncrustify() abort
    return {
        \ 'exe': 'uncrustify',
        \ 'args': ['-q', '-l CS'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#cs#astyle() abort
    return {
        \ 'exe': 'astyle',
        \ 'args': ['--mode=cs'],
        \ 'stdin': 1,
        \ }
endfunction
