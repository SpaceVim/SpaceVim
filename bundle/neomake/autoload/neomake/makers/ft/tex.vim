" vim: ts=4 sw=4 et

function! neomake#makers#ft#tex#EnabledMakers() abort
    return ['chktex', 'lacheck', 'rubberinfo', 'proselint']
endfunction

function! neomake#makers#ft#tex#chktex() abort
    let maker = {
                \ 'args': [],
                \ 'errorformat':
                \ '%EError %n in %f line %l: %m,' .
                \ '%WWarning %n in %f line %l: %m,' .
                \ '%WMessage %n in %f line %l: %m,' .
                \ '%Z%p^,' .
                \ '%-G%.%#'
                \ }
    let rcfile = neomake#utils#FindGlobFile('.chktexrc')
    if !empty(rcfile)
        let maker.args += ['-l', fnamemodify(rcfile, ':h')]
    endif
    return maker
endfunction

function! neomake#makers#ft#tex#lacheck() abort
    return {
                \ 'errorformat':
                \ '%-G** %f:,' .
                \ '%E"%f"\, line %l: %m'
                \ }
endfunction

function! neomake#makers#ft#tex#rubber() abort
    return {
                \ 'args': ['--pdf', '-f', '--warn=all'],
                \ 'errorformat':
                \ '%f:%l: %m,' .
                \ '%f: %m'
                \ }
endfunction

function! neomake#makers#ft#tex#rubberinfo() abort
    return {
                \ 'exe': 'rubber-info',
                \ 'errorformat':
                \ '%f:%l: %m,' .
                \ '%f:%l-%\d%\+: %m,' .
                \ '%f: %m'
                \ }
endfunction

function! neomake#makers#ft#tex#latexrun() abort
    return {
                \ 'args': ['--color', 'never'],
                \ 'errorformat':
                \ '%f:%l: %m'
                \ }
endfunction

function! neomake#makers#ft#tex#pdflatex() abort
    return {
                \ 'exe': 'pdflatex',
                \ 'args': ['-shell-escape', '-file-line-error', '-interaction', 'nonstopmode'],
                \ 'errorformat': '%E%f:%l: %m'
                \ }
endfunction

function! neomake#makers#ft#tex#proselint() abort
    return neomake#makers#ft#text#proselint()
endfunction
