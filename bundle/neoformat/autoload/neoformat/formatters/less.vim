function! neoformat#formatters#less#enabled() abort
    return ['stylelint', 'prettier', 'csscomb', 'prettydiff']
endfunction

function! neoformat#formatters#less#csscomb() abort
    return neoformat#formatters#css#csscomb()
endfunction

function! neoformat#formatters#less#prettydiff() abort
    return neoformat#formatters#css#prettydiff()
endfunction

function! neoformat#formatters#less#prettier() abort
    return neoformat#formatters#css#prettier()
endfunction

function! neoformat#formatters#less#stylelint() abort
    return neoformat#formatters#css#stylelint()
endfunction
