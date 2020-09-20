function! neoformat#formatters#scala#enabled() abort
    return ['scalariform', 'scalafmt']
endfunction

function! neoformat#formatters#scala#scalariform() abort
    return {
        \ 'exe': 'scalariform',
        \ 'args': ['--stdin'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#scala#scalafmt() abort
    return {
        \ 'exe': 'scalafmt',
        \ 'args': ['--stdin'],
        \ 'stdin': 1,
        \ }
endfunction
