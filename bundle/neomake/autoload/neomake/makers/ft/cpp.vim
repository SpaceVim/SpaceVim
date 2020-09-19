" vim: ts=4 sw=4 et

function! neomake#makers#ft#cpp#EnabledMakers() abort
    let makers = executable('clang++') ? ['clang', 'clangtidy', 'clangcheck'] : ['gcc']
    call add(makers, 'cppcheck')
    return makers
endfunction

function! neomake#makers#ft#cpp#clang() abort
    let maker = neomake#makers#ft#c#clang()
    let maker.exe = 'clang++'
    let maker.args += ['-std=c++1z']
    return maker
endfunction

function! neomake#makers#ft#cpp#gcc() abort
    let maker = neomake#makers#ft#c#gcc()
    let maker.exe = 'g++'
    let maker.args += ['-std=c++1z']
    return maker
endfunction

function! neomake#makers#ft#cpp#clangtidy() abort
    return neomake#makers#ft#c#clangtidy()
endfunction

function! neomake#makers#ft#cpp#clangcheck() abort
    return neomake#makers#ft#c#clangcheck()
endfunction

function! neomake#makers#ft#cpp#cppcheck() abort
    let maker = neomake#makers#ft#c#cppcheck()
    let maker.args[0] = '--language=c++'
    return maker
endfunction

function! neomake#makers#ft#cpp#cpplint() abort
    return {
        \ 'exe': executable('cpplint') ? 'cpplint' : 'cpplint.py',
        \ 'args': ['--verbose=3'],
        \ 'errorformat':
        \     '%A%f:%l:  %m [%t],' .
        \     '%-G%.%#',
        \ 'postprocess': function('neomake#makers#ft#cpp#CpplintEntryProcess')
        \ }
endfunction

function! neomake#makers#ft#cpp#CpplintEntryProcess(entry) abort
    let a:entry.type = str2nr(a:entry.type) < 5 ? 'W' : 'E'
endfunction
