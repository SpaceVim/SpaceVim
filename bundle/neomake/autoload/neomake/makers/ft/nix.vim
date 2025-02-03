" vim: ts=4 sw=4 et
"
function! neomake#makers#ft#nix#EnabledMakers() abort
    return ['nix_instantiate']
endfunction

" there is a single %C last in errorformat because nix >= 2.4 emits multiline
" error messages with empty lines in the middle.
function! neomake#makers#ft#nix#nix_instantiate() abort
    return {
        \ 'exe': 'nix-instantiate',
        \ 'args': ['--parse-only'],
        \ 'errorformat': 'error: %m at %f:%l:%c,%Eerror: %m,%Z       at %f:%l:%c:,%C'
        \ }
endfunction

