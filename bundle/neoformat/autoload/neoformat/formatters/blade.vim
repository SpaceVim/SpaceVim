function! neoformat#formatters#blade#enabled() abort
    return ['blade_formatter']
endfunction

function! neoformat#formatters#blade#blade_formatter() abort
    return {
        \ 'exe': 'blade-formatter',
        \ 'args': ['--stdin', '-q'],
        \ 'stdin': 1
        \ }
endfunction
