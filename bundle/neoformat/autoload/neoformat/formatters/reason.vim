function! neoformat#formatters#reason#enabled() abort
    return ['refmt', 'bsrefmt']
endfunction

function! neoformat#formatters#reason#refmt() abort
    return {
        \ 'exe': 'refmt',
        \ 'stdin': 1,
        \ 'args': ["--interface=" . (expand('%:e') == "rei" ? "true" : "false")],
        \ }
endfunction

function! neoformat#formatters#reason#bsrefmt() abort
    return {
        \ 'exe': 'bsrefmt',
        \ 'stdin': 1,
        \ 'args': ["--interface=" . (expand('%:e') == "rei" ? "true" : "false")],
        \ }
endfunction
