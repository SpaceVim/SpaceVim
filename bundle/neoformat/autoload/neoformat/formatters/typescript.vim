function! neoformat#formatters#typescript#enabled() abort
   return ['tsfmt', 'prettier', 'prettiereslint', 'tslint', 'eslint_d', 'clangformat', 'denofmt']
endfunction

function! neoformat#formatters#typescript#tsfmt() abort
    return {
        \ 'exe': 'tsfmt',
        \ 'args': ['--replace', '--baseDir=%:h'],
        \ 'replace': 1
        \ }
endfunction

function! neoformat#formatters#typescript#prettier() abort
    return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin-filepath', '"%:p"', '--parser', 'typescript'],
        \ 'stdin': 1
        \ }
endfunction

function! neoformat#formatters#typescript#prettiereslint() abort
    return {
        \ 'exe': 'prettier-eslint',
        \ 'args': ['--stdin', '--stdin-filepath', '"%:p"', '--parser', 'typescript'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#typescript#tslint() abort
    let args = ['--fix', '--force']

    if filereadable('tslint.json')
        let args = ['-c tslint.json'] + args
    endif

    return {
        \ 'exe': 'tslint',
        \ 'args': args,
        \ 'replace': 1
        \ }
endfunction

function! neoformat#formatters#typescript#eslint_d() abort
    return {
        \ 'exe': 'eslint_d',
        \ 'args': ['--stdin', '--stdin-filename', '"%:p"', '--fix-to-stdout'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#typescript#clangformat() abort
    return {
            \ 'exe': 'clang-format',
            \ 'args': ['-assume-filename=' . expand('%:t')],
            \ 'stdin': 1
            \ }
endfunction

function! neoformat#formatters#typescript#denofmt() abort
    return neoformat#formatters#javascript#denofmt()
endfunction
