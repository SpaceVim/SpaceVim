function! neoformat#formatters#go#enabled() abort
   return ['goimports', 'gofmt']
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

