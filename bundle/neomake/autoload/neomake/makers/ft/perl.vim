" vim: ts=4 sw=4 et
function! neomake#makers#ft#perl#EnabledMakers() abort
    return ['perl', 'perlcritic']
endfunction

function! neomake#makers#ft#perl#perlcritic() abort
    return {
         \ 'args' : ['--quiet', '--nocolor', '--verbose',
         \           '\\%f:\\%l:\\%c:(\\%s) \\%m (\\%e)\\n'],
         \ 'errorformat': '%f:%l:%c:%m,'
     \}
endfunction

function! neomake#makers#ft#perl#perl() abort
    return {
         \ 'args' : ['-c', '-X', '-Mwarnings'],
         \ 'errorformat': '%-G%.%#had too many errors.,'
         \  . '%-G%.%#had compilation errors.,'
         \  . '%-G%.%#syntax OK,'
         \  . '%m at %f line %l.,'
         \  . '%+E%.%# at %f line %l\,%.%#,'
         \  . '%+C%.%#',
         \ 'postprocess': function('neomake#makers#ft#perl#PerlEntryProcess'),
     \}
endfunction

function! neomake#makers#ft#perl#PerlEntryProcess(entry) abort
    let extramsg = substitute(a:entry.pattern, '\^\\V', '', '')
    let extramsg = substitute(extramsg, '\\\$', '', '')

    if !empty(extramsg)
        let a:entry.text .= ' ' . extramsg
    endif
endfunction
