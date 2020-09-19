function! neoformat#formatters#xml#enabled() abort
   return ['tidy', 'prettydiff', 'prettier']
endfunction

function! neoformat#formatters#xml#tidy() abort
    return {
            \ 'exe': 'tidy',
            \ 'args': ['-quiet',
            \          '-xml',
            \          '--indent auto',
            \          '--indent-spaces ' . shiftwidth(),
            \          '--vertical-space yes',
            \          '--tidy-mark no'
            \         ],
            \ 'stdin': 1,
            \ }
endfunction

function! neoformat#formatters#xml#prettydiff() abort
    return neoformat#formatters#html#prettydiff()
endfunction

function! neoformat#formatters#xml#prettier() abort
    return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin', '--stdin-filepath', '"%:p"'],
        \ 'stdin': 1,
        \ }
endfunction


