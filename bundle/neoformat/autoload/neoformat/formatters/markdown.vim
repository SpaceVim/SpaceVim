function! neoformat#formatters#markdown#enabled() abort
   return ['remark', 'prettier', 'denofmt']
endfunction

function! neoformat#formatters#markdown#prettier() abort
    return {
        \ 'exe': 'prettier',
        \ 'args': ['--stdin-filepath', '"%:p"'],
        \ 'stdin': 1,
        \ 'try_node_exe': 1,
        \ }
endfunction

function! neoformat#formatters#markdown#remark() abort
    return {
            \ 'exe': 'remark',
            \ 'args': ['--no-color', '--silent'],
            \ 'stdin': 1,
            \ 'try_node_exe': 1,
            \ }
endfunction

function! neoformat#formatters#markdown#denofmt() abort
    return {
        \ 'exe': 'deno',
        \ 'args': ['fmt','-'],
        \ 'stdin': 1,
        \ }
endfunction
