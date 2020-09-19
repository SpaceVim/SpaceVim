function! neoformat#formatters#crystal#enabled() abort
    return ['crystalformat']
endfunction

function! neoformat#formatters#crystal#crystalformat() abort
    return {
        \ 'exe': 'crystal',
        \ 'args': ['tool', 'format'],
        \ 'replace': 1
        \ }
endfunction
