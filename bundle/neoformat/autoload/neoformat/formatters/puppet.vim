function! neoformat#formatters#puppet#enabled() abort
    return ['puppetlint']
endfunction

function! neoformat#formatters#puppet#puppetlint() abort
    return {
        \ 'exe': 'puppet-lint',
        \ 'args': ['--fix'],
        \ 'replace': 1,
        \ }
endfunction
