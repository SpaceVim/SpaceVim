function! neoformat#formatters#lua#enabled() abort
    return ['luaformatter', 'luafmt', 'luaformat', 'stylua']
endfunction

function! neoformat#formatters#lua#luaformatter() abort
    return {
        \ 'exe': 'luaformatter'
        \ }
endfunction

function! neoformat#formatters#lua#luafmt() abort
    return {
        \ 'exe': 'luafmt',
        \ 'args': ['--stdin'],
        \ 'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#lua#luaformat() abort
    return {
        \ 'exe': 'lua-format'
        \ }
endfunction

function! neoformat#formatters#lua#stylua() abort
    return {
        \ 'exe': 'stylua',
        \ 'args': ['--search-parent-directories', '--stdin-filepath', '"%:p"', '--', '-'],
        \ 'stdin': 1,
        \ }
endfunction
