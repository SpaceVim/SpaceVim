" vim: ts=4 sw=4 et

function! neomake#makers#ft#clojure#EnabledMakers() abort
    return ['clj_kondo']
endfunction

function! neomake#makers#ft#clojure#clj_kondo() abort
    let maker = {
        \ 'exe': 'clj-kondo',
        \ 'args': ['--lint'],
        \ 'errorformat':
            \ '%f:%l:%c: Parse %t%*[^:]: %m,'.
            \ '%f:%l:%c: %t%*[^:]: %m,'.
            \ '%-Glinting took %.%#'
        \ }

    function! maker.supports_stdin(_jobinfo) abort
        let self.args = ['--filename', '%'] + self.args
        return 1
    endfunction

    return maker
endfunction
