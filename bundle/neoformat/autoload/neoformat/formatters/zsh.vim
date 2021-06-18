function! neoformat#formatters#zsh#enabled() abort
    return ['shfmt']
endfunction

function! neoformat#formatters#zsh#shfmt() abort
    let opts = get(g:, 'shfmt_opt', '')

    return {
            \ 'exe': 'shfmt',
            \ 'args': ['-i ' . shiftwidth(), opts],
            \ 'stdin': 1,
            \ }
endfunction
