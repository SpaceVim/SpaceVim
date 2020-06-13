function! neoformat#formatters#vala#uncrustify() abort
    return {
        \ 'exe': 'uncrustify',
        \ 'args': ['-q', '-l VALA'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#vala#enabled() abort
    return ['uncrustify']
endfunction
