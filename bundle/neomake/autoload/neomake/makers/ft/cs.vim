" vim: ts=4 sw=4 et

function! neomake#makers#ft#cs#EnabledMakers() abort
    return ['mcs']
endfunction

function! neomake#makers#ft#cs#mcs() abort
    return {
        \ 'args': ['--parse', '--unsafe'],
        \ 'errorformat': '%f(%l\,%c): %trror %m',
        \ }
endfunction

function! neomake#makers#ft#cs#msbuild() abort
    return {
        \ 'exe': 'msbuild',
        \ 'args': ['-nologo', '-v:q', '-property:GenerateFullPaths=true', neomake#utils#FindGlobFile('*.sln')],
        \ 'errorformat': '%E%f(%l\,%c): error CS%n: %m [%.%#],'.
        \                '%W%f(%l\,%c): warning CS%n: %m [%.%#]',
        \ 'append_file' : 0,
        \ }
endfunction
