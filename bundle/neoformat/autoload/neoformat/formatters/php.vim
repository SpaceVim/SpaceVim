function! neoformat#formatters#php#enabled() abort
    return ['phpbeautifier', 'phpcsfixer', 'phpcbf']
endfunction

function! neoformat#formatters#php#phpbeautifier() abort
    return {
        \ 'exe': 'php_beautifier',
        \ }
endfunction

function! neoformat#formatters#php#phpcsfixer() abort
    return {
           \ 'exe': 'php-cs-fixer',
           \ 'args': ['fix', '-q'],
           \ 'replace': 1,
           \ }
endfunction

function! neoformat#formatters#php#phpcbf() abort
    return {
           \ 'exe': 'phpcbf',
           \ 'stdin': 1,
           \ 'args': ['-'],
           \ 'valid_exit_codes': [0,1],
           \ }
endfunction
