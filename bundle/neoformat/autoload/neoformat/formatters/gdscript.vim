function! neoformat#formatters#gdscript#enabled() abort
    return ['gdformat']
endfunction

function! neoformat#formatters#gdscript#gdformat() abort
    return {
        \ 'exe': 'gdformat',
        \ 'args': ['-'],
		\ 'stdin': 1
        \ }
endfunction
