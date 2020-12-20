function! neoformat#formatters#matlab#enabled() abort
    return ['matlabformatter']
endfunction

function! neoformat#formatters#matlab#matlabformatter() abort
    return {
        \ 'exe': 'matlab_formatter.py',
        \ 'stdin': 0
        \ }
endfunction

