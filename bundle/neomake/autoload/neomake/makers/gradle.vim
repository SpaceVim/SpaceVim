" vim: ts=4 sw=4 et

function! neomake#makers#gradle#gradle() abort
    let g:gradleBin = filereadable('./gradlew') ? './gradlew' : 'gradle'

    return {
        \ 'exe': g:gradleBin,
        \ 'append_file': 0,
        \ 'args': ['assemble', '--daemon'],
        \ 'errorformat': '\%+ATask\ %.%#\ not\ found\ %.%#.,'.
        \'%EExecution\ failed\ for\ task\ %m,'.
        \'findbugs:\ %tarning\ %f:%l:%c\ %m,'.
        \'pmd:\ %tarning\ %f:%l:%c\ %m,'.
        \'checkstyle:\ %tarning\ %f:%l:%c\ %m,'.
        \'lint:\ %tarning\ %f:%l:%c\ %m,'.
        \'%A>\ %f:%l:%c:\ %trror:\ %m,'.
        \'%A>\ %f:%l:%c:\ %tarning:\ %m,'.
        \'%A%f:%l:\ %trror:\ %m,'.
        \'%A%f:%l:\ %tarning:\ %m,'.
        \'%A%f:%l:\ %trror\ -\ %m,'.
        \'%A%f:%l:\ %tarning\ -\ %m,'.
        \'%E%f:%l\ :\ %m,'.
        \'%C>\ %m,'.
        \'%-G%p^,'.
        \'%+G\ \ %.%#,'.
        \'%-G%.%#'
        \ }
endfunction
