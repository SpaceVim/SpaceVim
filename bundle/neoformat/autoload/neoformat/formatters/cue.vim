function! neoformat#formatters#cue#enabled() abort
    return ['cue']
endfunction

function! neoformat#formatters#cue#cue() abort
    return {
        \ 'exe': 'cue',
        \ 'args': ['fmt', '-'],
        \ 'stdin': 1
        \ }
endfunction
