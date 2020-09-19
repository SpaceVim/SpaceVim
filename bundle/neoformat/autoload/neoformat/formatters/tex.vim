function! neoformat#formatters#tex#enabled() abort
    return ['latexindent']
endfunction

function! neoformat#formatters#tex#latexindent() abort
    return {
        \ 'exe': 'latexindent',
        \ 'args': ['-sl', '-g /dev/stderr', '2>/dev/null'],
        \ 'stdin': 1,
        \ }
endfunction
