function! neoformat#formatters#reason#enabled() abort
    return ['refmt']
endfunction

function! neoformat#formatters#reason#refmt() abort
    return {
        \ 'exe': 'refmt',
        \ 'stdin': 1,
        \ 'args': ["--interface=" . (expand('%:e') == "rei" ? "true" : "false")],
        \ }
endfunction
