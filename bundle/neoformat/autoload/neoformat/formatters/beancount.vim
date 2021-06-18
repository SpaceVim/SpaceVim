function! neoformat#formatters#beancount#enabled() abort
    return ['beanformat']
endfunction

function! neoformat#formatters#beancount#beanformat() abort
    return {
        \ 'exe': 'bean-format',
        \ 'stdin': 1,
        \ }
endfunction
