function! neoformat#formatters#lua#enabled() abort
    return ['luaformatter', 'luafmt']
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
