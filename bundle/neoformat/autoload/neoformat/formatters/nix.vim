function! neoformat#formatters#nix#enabled() abort
    return ['nixfmt']
endfunction

function! neoformat#formatters#nix#nixfmt() abort
    return {
        \ 'exe': 'nixfmt',
        \ 'stdin': 1,
        \ }
endfunction
