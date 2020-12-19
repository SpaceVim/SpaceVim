function! neoformat#formatters#glsl#enabled() abort
   return ['clangformat']
endfunction

function! neoformat#formatters#glsl#clangformat() abort
    return {
            \ 'exe': 'clang-format',
            \ 'args': ['-assume-filename=' . expand('%:t')],
            \ 'stdin': 1,
            \ }
endfunction
