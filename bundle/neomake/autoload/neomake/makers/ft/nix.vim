" vim: ts=4 sw=4 et
"
function! neomake#makers#ft#nix#EnabledMakers() abort
    return ['nix_instantiate']
endfunction

function! neomake#makers#ft#nix#nix_instantiate() abort
    return {
        \ 'exe': 'nix-instantiate',
        \ 'args': ['--parse-only'],
        \ 'errorformat': 'error: %m at %f:%l:%c'
        \ }
endfunction

