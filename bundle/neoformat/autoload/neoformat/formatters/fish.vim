function! neoformat#formatters#fish#enabled() abort
    return ['fish_indent']
endfunction

function! neoformat#formatters#fish#fish_indent() abort
    return {
            \ 'exe': 'fish_indent',
            \ 'stdin': 1,
            \ }
endfunction

