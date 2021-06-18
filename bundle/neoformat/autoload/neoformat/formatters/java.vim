function! neoformat#formatters#java#enabled() abort
   return ['uncrustify', 'astyle', 'clangformat', 'prettier']
endfunction

function! neoformat#formatters#java#uncrustify() abort
     return {
            \ 'exe': 'uncrustify',
            \ 'args': ['-q', '-l JAVA'],
            \ 'stdin': 1,
            \ }
endfunction


function! neoformat#formatters#java#astyle() abort
    return {
            \ 'exe': 'astyle',
            \ 'args': ['--mode=java'],
            \ 'stdin': 1,
            \ }
endfunction


function! neoformat#formatters#java#clangformat() abort
    return {
            \ 'exe': 'clang-format',
            \ 'args': ['-assume-filename=' . expand('%:t')],
            \ 'stdin': 1,
            \ }
endfunction

function! neoformat#formatters#java#prettier() abort
    return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin-filepath', '"%:p"'],
        \ 'stdin': 1,
        \ }
endfunction


