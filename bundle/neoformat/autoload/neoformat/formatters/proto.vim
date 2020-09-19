function! neoformat#formatters#proto#enabled() abort
    return ['clangformat']
endfunction

function! neoformat#formatters#proto#clangformat() abort
    return neoformat#formatters#c#clangformat()
endfunction
