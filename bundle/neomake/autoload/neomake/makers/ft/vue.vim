" vim: ts=4 sw=4 et

function! neomake#makers#ft#vue#EnabledMakers() abort
    return ['eslint', 'standard']
endfunction

function! neomake#makers#ft#vue#eslint() abort
    let maker = neomake#makers#ft#javascript#eslint()
    call extend(get(maker, 'args', []), ['--plugin', 'html'])
    return maker
endfunction

function! neomake#makers#ft#vue#eslint_d() abort
    return neomake#makers#ft#vue#eslint()
endfunction

function! neomake#makers#ft#vue#standard() abort
    let maker = neomake#makers#ft#javascript#standard()
    call extend(get(maker, 'args', []), ['--plugin', 'html'])
    return maker
endfunction

function! neomake#makers#ft#vue#semistandard() abort
    let maker = neomake#makers#ft#javascript#semistandard()
    call extend(get(maker, 'args', []), ['--plugin', 'html'])
    return maker
endfunction

