function! neoformat#formatters#prisma#enabled() abort
    return ['prettier']
endfunction

function! neoformat#formatters#prisma#prettier() abort
    return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin-filepath', '"%:p"'],
        \ 'stdin': 1,
        \ }
endfunction
