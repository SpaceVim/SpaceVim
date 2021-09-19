function! neoformat#formatters#javascript#enabled() abort
    return ['jsbeautify', 'standard', 'semistandard', 'prettier', 'prettydiff', 'clangformat', 'esformatter', 'prettiereslint', 'eslint_d', 'denofmt']
endfunction

function! neoformat#formatters#javascript#jsbeautify() abort
    return {
            \ 'exe': 'js-beautify',
            \ 'args': ['--indent-size ' .shiftwidth()],
            \ 'stdin': 1,
            \ }
endfunction

function! neoformat#formatters#javascript#clangformat() abort
    return {
            \ 'exe': 'clang-format',
            \ 'args': ['-assume-filename=' . expand('%:t')],
            \ 'stdin': 1
            \ }
endfunction

function! neoformat#formatters#javascript#prettydiff() abort
    return {
        \ 'exe': 'prettydiff',
        \ 'args': ['mode:"beautify"',
                 \ 'lang:"javascript"',
                 \ 'readmethod:"filescreen"',
                 \ 'endquietly:"quiet"',
                 \ 'source:"%:p"'],
        \ 'no_append': 1
        \ }
endfunction

function! neoformat#formatters#javascript#esformatter() abort
    return {
        \ 'exe': 'esformatter',
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascript#prettier() abort
    return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin-filepath', '"%:p"'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascript#prettiereslint() abort
    return {
        \ 'exe': 'prettier-eslint',
        \ 'args': ['--stdin', '--stdin-filepath', '"%:p"'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascript#eslint_d() abort
    return {
        \ 'exe': 'eslint_d',
        \ 'args': ['--stdin', '--stdin-filename', '"%:p"', '--fix-to-stdout'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascript#standard() abort
    return {
        \ 'exe': 'standard',
        \ 'args': ['--stdin','--fix'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascript#denofmt() abort
    return {
        \ 'exe': 'deno',
        \ 'args': ['fmt','-'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascript#semistandard() abort
    return {
        \ 'exe': 'semistandard',
        \ 'args': ['--stdin','--fix'],
        \ 'stdin': 1,
        \ }
endfunction
