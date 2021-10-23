function! neoformat#formatters#bib#enabled() abort
    return ['bibclean']
endfunction

function! neoformat#formatters#bib#bibclean() abort
    return {
                \ 'exe': 'bibclean',
                \ 'stdin': 1,
                \ }
endfunction
