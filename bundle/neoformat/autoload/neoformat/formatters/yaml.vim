function! neoformat#formatters#yaml#enabled() abort
   return ['pyaml', 'prettier']
endfunction

function! neoformat#formatters#yaml#pyaml() abort
   return {
            \ 'exe': 'python3',
            \ 'args': ['-m', 'pyaml'],
            \ 'stdin': 1,
            \ }
endfunction

function! neoformat#formatters#yaml#prettier() abort
    return {
            \ 'exe': 'prettier',
            \ 'args': ['--stdin', '--stdin-filepath', '"%:p"', '--parser', 'yaml'],
            \ 'stdin': 1
            \ }
endfunction
