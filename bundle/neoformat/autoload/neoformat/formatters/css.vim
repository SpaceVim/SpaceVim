function! neoformat#formatters#css#enabled() abort
    return ['stylelint', 'stylefmt', 'prettier', 'cssbeautify', 'prettydiff', 'csscomb']
endfunction

function! neoformat#formatters#css#cssbeautify() abort
    return {
            \ 'exe': 'css-beautify',
            \ 'args': ['--indent-size ' .shiftwidth()],
            \ 'stdin': 1,
            \ }
endfunction

function! neoformat#formatters#css#csscomb() abort
    return {
            \ 'exe': 'csscomb',
            \ 'replace': 1
            \ }
endfunction

function! neoformat#formatters#css#prettydiff() abort
    return {
            \ 'exe': 'prettydiff',
            \ 'args': ['mode:"beautify"',
                     \ 'lang:"css"',
                     \ 'insize:' .shiftwidth(),
                     \ 'readmethod:"filescreen"',
                     \ 'endquietly:"quiet"',
                     \ 'source:"%:p"'],
            \ 'no_append': 1
            \ }
endfunction

function! neoformat#formatters#css#stylefmt() abort
    return {
        \ 'exe': 'stylefmt',
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#css#prettier() abort
    return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin', '--stdin-filepath', '"%:p"', '--parser', 'css'],
        \ 'stdin': 1
        \ }
endfunction

function! neoformat#formatters#css#stylelint() abort
    return {
            \ 'exe': 'stylelint',
            \ 'args': ['--fix', '--stdin-filename', '"%:t"'],
            \ 'stdin': 1,
            \ }
endfunction
