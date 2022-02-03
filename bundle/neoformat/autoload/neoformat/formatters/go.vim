function! neoformat#formatters#go#enabled() abort
   return ['goimports', 'gofmt', 'gofumports', 'gofumpt']
endfunction

function! neoformat#formatters#go#gofmt() abort
    return {
            \ 'exe': 'gofmt',
            \ 'stdin': 1,
            \ }
 endfunction

function! neoformat#formatters#go#goimports() abort
    return {
            \ 'exe': 'goimports',
            \ 'stdin': 1,
            \ }
endfunction

function! neoformat#formatters#go#gofumpt() abort
    return {
            \ 'exe': 'gofumpt',
            \ 'stdin': 1,
            \ }
endfunction

function! neoformat#formatters#go#gofumports() abort
    return {
            \ 'exe': 'gofumports',
            \ 'stdin': 1,
            \ }
endfunction
