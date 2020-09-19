function! neoformat#formatters#sbt#enabled() abort
    return ['scalafmt']
endfunction

"  To understand sbt files on stdin, scalafmt needs to assume any old filename
"  that ends in .sbt.  Using a dummy filename instead of the actual one is
"  required to support buffers of sbt filetype without the extension.
function! neoformat#formatters#sbt#scalafmt() abort
    return {
        \ 'exe': 'scalafmt',
        \ 'args': ['--stdin', '--assume-filename', 'foo.sbt'],
        \ 'stdin': 1,
        \ }
endfunction
