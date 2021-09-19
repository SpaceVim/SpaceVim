function! neoformat#formatters#rust#enabled() abort
    return ['rustfmt']
endfunction

function! neoformat#formatters#rust#rustfmt() abort
    return {
        \ 'exe': 'rustfmt',
        \ 'args': ['--config hard_tabs=' . (&expandtab ? 'false' : 'true') .
        \                  ',tab_spaces=' . shiftwidth() .
        \                  ',max_width=' . &textwidth
        \         ],
        \ 'stdin': 1,
        \ }
endfunction
