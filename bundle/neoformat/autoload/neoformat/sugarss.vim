function! neoformat#formatters#sugarss#enabled() abort
    return ['stylelint']
endfunction

function! neoformat#formatters#sugarss#stylelint() abort
    return neoformat#formatters#css#stylelint()
endfunction
