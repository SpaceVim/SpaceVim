" vim: ts=4 sw=4 et

function! neomake#makers#ft#racket#EnabledMakers() abort
    return ['raco']
endfunction

" This is the same form of syntax-checking used by DrRacket as well. The
" downside is that it will only catch the first error, but none of the
" subsequent ones. This is due to how evaluation in Racket works.
"
" About the error format: raco will print the first line as
"     <file>:<line>:<column> <message>
" Every successive line will be indented by two spaces:
"       in: <keyword>
"       context...:
"       <file>:<line>:<column>: <keyword>
" The last pattern will be repeated as often as necessary. Example:
"     foo.rkt:4:1: dfine: unbound identifier in modulemessage
"       in: dfine
"       context...:
"        /usr/local/Cellar/racket/6.5/share/racket/pkgs/compiler-lib/compiler/commands/expand.rkt:34:15: loop
"        /usr/local/Cellar/racket/6.5/share/racket/pkgs/compiler-lib/compiler/commands/expand.rkt:10:2: show-program
"        /usr/local/Cellar/racket/6.5/share/racket/pkgs/compiler-lib/compiler/commands/expand.rkt: [running body]
"        /usr/local/Cellar/minimal-racket/6.6/share/racket/collects/raco/raco.rkt: [running body]
"        /usr/local/Cellar/minimal-racket/6.6/share/racket/collects/raco/main.rkt: [running body]
function! neomake#makers#ft#racket#raco() abort
    return {
        \ 'exe': 'raco',
        \ 'args': ['expand'],
        \ 'errorformat': '%-G %.%#,%E%f:%l:%c: %m'
    \ }
endfunction
