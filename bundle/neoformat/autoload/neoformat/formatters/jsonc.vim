function! neoformat#formatters#jsonc#enabled() abort
    return ['prettier', 'denofmt']
endfunction

function! neoformat#formatters#jsonc#prettier() abort
    return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin-filepath', '"%:p"'],
        \ 'stdin': 1,
        \ 'try_node_exe': 1,
        \ }
endfunction

function! neoformat#formatters#jsonc#denofmt() abort
    return {
        \ 'exe': 'deno',
        \ 'args': ['fmt','-'],
        \ 'stdin': 1,
        \ }
endfunction
