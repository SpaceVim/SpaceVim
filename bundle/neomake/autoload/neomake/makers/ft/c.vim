" vim: ts=4 sw=4 et

function! neomake#makers#ft#c#EnabledMakers() abort
    let makers = executable('clang') ? ['clang', 'clangtidy', 'clangcheck'] : ['gcc']
    call add(makers, 'checkpatch')
    call add(makers, 'cppcheck')
    return makers
endfunction

let g:neomake#makers#ft#c#project_root_files = ['configure', 'CMakeLists.txt']

function! neomake#makers#ft#c#clang() abort
    " as a single-file maker, include the current directory in the default
    " search path
    return {
        \ 'args': ['-fsyntax-only', '-Wall', '-Wextra', '-I./'],
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

function! neomake#makers#ft#c#clangcheck() abort
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

function! neomake#makers#ft#c#gcc() abort
    " as a single-file maker, include the current directory in the default
    " search path
    return {
        \ 'args': ['-fsyntax-only', '-Wall', '-Wextra', '-I./'],
        \ 'errorformat':
            \ '%-G%f:%s:,' .
            \ '%-G%f:%l: %#error: %#(Each undeclared identifier is reported only%.%#,' .
            \ '%-G%f:%l: %#error: %#for each function it appears%.%#,' .
            \ '%-GIn file included%.%#,' .
            \ '%-G %#from %f:%l\,,' .
            \ '%f:%l:%c: %trror: %m,' .
            \ '%f:%l:%c: %tarning: %m,' .
            \ '%I%f:%l:%c: note: %m,' .
            \ '%f:%l:%c: %m,' .
            \ '%f:%l: %trror: %m,' .
            \ '%f:%l: %tarning: %m,'.
            \ '%I%f:%l: note: %m,'.
            \ '%f:%l: %m',
        \ }
endfunction

" The -p option followed by the path to the build directory should be set in
" the maker's arguments. That directory should contain the compile command
" database (compile_commands.json).
function! neomake#makers#ft#c#clangtidy() abort
    return {
        \ 'exe': 'clang-tidy',
        \ 'errorformat':
            \ '%E%f:%l:%c: fatal error: %m,' .
            \ '%E%f:%l:%c: error: %m,' .
            \ '%W%f:%l:%c: warning: %m,' .
            \ '%-G%\m%\%%(LLVM ERROR:%\|No compilation database found%\)%\@!%.%#,' .
            \ '%E%m',
        \ 'short_name': 'ctdy',
        \ }
endfunction

function! neomake#makers#ft#c#checkpatch() abort
    return {
        \ 'exe': 'checkpatch.pl',
        \ 'args': ['--no-summary', '--no-tree', '--terse', '--file'],
        \ 'errorformat':
            \ '%f:%l: %tARNING: %m,' .
            \ '%f:%l: %tRROR: %m',
        \ }
endfunction

function! neomake#makers#ft#c#cppcheck() abort
    " NOTE: '--language=c' should be the first args, it gets replaced in
    "       neomake#makers#ft#cpp#cppcheck.
    return {
        \ 'args': ['--language=c', '--quiet', '--enable=warning',
        \          '--template={file}:{line}:{column}:{severity}:{message}'],
        \ 'errorformat':
            \ 'nofile:0:0:%trror:%m,' .
            \ '%f:%l:%c:%trror:%m,' .
            \ 'nofile:0:0:%tarning:%m,'.
            \ '%f:%l:%c:%tarning:%m,'.
            \ 'nofile:0:0:%tnformation:%m,'.
            \ '%f:%l:%c:%tnformation:%m',
        \ }
endfunction
