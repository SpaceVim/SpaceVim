function! neoformat#formatters#lua#enabled() abort
    return ['luaformatter', 'luafmt', 'luaformat']
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
