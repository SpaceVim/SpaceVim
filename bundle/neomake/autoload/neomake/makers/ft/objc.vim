" vim: ts=4 sw=4 et

function! neomake#makers#ft#objc#EnabledMakers() abort
    let makers = ['clang', 'clangtidy', 'clangcheck']
    return makers
endfunction

function! neomake#makers#ft#objc#clang() abort
    " We will enable ARC and disable warnings about unused parameters because
    " it is quite common in Cocoa not to use every method parameter.
    return {
        \ 'args': ['-fsyntax-only', '-fobjc-arc', '-Wall', '-Wextra', '-Wno-unused-parameter'],
        \ 'errorformat':
            \ '%-G%f:%s:,' .
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%I%f:%l:%c: note: %m,' .
            \ '%f:%l:%c: %m,'.
            \ '%f:%l: %trror: %m,'.
            \ '%f:%l: %tarning: %m,'.
            \ '%I%f:%l: note: %m,'.
            \ '%f:%l: %m'
        \ }
endfunction

" The -p option followed by the path to the build directory should be set in
" the maker's arguments. That directory should contain the compile command
" database (compile_commands.json).
function! neomake#makers#ft#objc#clangtidy() abort
    return {
        \ 'exe': 'clang-tidy',
        \ 'errorformat':
            \ '%E%f:%l:%c: fatal error: %m,' .
            \ '%E%f:%l:%c: error: %m,' .
            \ '%W%f:%l:%c: warning: %m,' .
            \ '%-G%\m%\%%(LLVM ERROR:%\|No compilation database found%\)%\@!%.%#,' .
            \ '%E%m',
        \ }
endfunction

function! neomake#makers#ft#objc#clangcheck() abort
    return {
        \ 'exe': 'clang-check',
        \ 'errorformat':
            \ '%-G%f:%s:,' .
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%I%f:%l:%c: note: %m,' .
            \ '%f:%l:%c: %m,'.
            \ '%f:%l: %trror: %m,'.
            \ '%f:%l: %tarning: %m,'.
            \ '%I%f:%l: note: %m,'.
            \ '%f:%l: %m',
        \ }
endfunction
