function! neoformat#formatters#javascriptreact#enabled() abort
    return ['jsbeautify', 'standard', 'semistandard', 'prettier', 'prettydiff', 'esformatter', 'prettiereslint', 'eslint_d', 'denofmt']
endfunction

function! neoformat#formatters#javascriptreact#jsbeautify() abort
    return {
            \ 'exe': 'js-beautify',
            \ 'args': ['--indent-size ' .shiftwidth()],
            \ 'stdin': 1,
            \ }
endfunction

function! neoformat#formatters#javascriptreact#prettydiff() abort
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

function! neoformat#formatters#javascriptreact#esformatter() abort
    return {
        \ 'exe': 'esformatter',
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascriptreact#prettier() abort
    return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin-filepath', '"%:p"'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascriptreact#prettiereslint() abort
    return {
        \ 'exe': 'prettier-eslint',
        \ 'args': ['--stdin', '--stdin-filepath', '"%:p"'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascriptreact#eslint_d() abort
    return {
        \ 'exe': 'eslint_d',
        \ 'args': ['--stdin', '--stdin-filename', '"%:p"', '--fix-to-stdout'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascriptreact#standard() abort
    return {
        \ 'exe': 'standard',
        \ 'args': ['--stdin','--fix'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascriptreact#denofmt() abort
    return {
        \ 'exe': 'deno',
        \ 'args': ['fmt','-'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#javascriptreact#semistandard() abort
    return {
        \ 'exe': 'semistandard',
        \ 'args': ['--stdin','--fix'],
        \ 'stdin': 1,
        \ }
endfunction
