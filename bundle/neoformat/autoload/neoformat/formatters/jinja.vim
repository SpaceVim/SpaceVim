function! neoformat#formatters#jinja#enabled() abort
    return ['prettydiff', 'htmlbeautify']
endfunction

function! neoformat#formatters#jinja#htmlbeautify() abort
    return neoformat#formatters#html#htmlbeautify()
endfunction

function! neoformat#formatters#jinja#prettydiff() abort
    return neoformat#formatters#html#prettydiff()
endfunction
