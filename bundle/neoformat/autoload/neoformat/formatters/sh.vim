function! neoformat#formatters#sh#enabled() abort
    return ['shfmt']
endfunction

function! neoformat#formatters#sh#shfmt() abort
    let opts = get(g:, 'shfmt_opt', '')

    return {
            \ 'exe': 'shfmt',
            \ 'args': ['-i ' . shiftwidth(), opts],
            \ 'stdin': 1,
            \ }
endfunction
