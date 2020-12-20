let s:makers = ['writegood']

let s:slash = neomake#utils#Slash()
let s:vimhelplint_exe = ''
if executable('vimhelplint')
    let s:vimhelplint_exe = 'vimhelplint'
else
    let s:neomake_root = expand('<sfile>:p:h:h:h:h:h', 1)
    if !empty(glob(join([s:neomake_root, 'build', 'vimhelplint'], s:slash)))
        let s:vimhelplint_exe = join([s:neomake_root, 'contrib', 'vimhelplint'], s:slash)
    endif
endif
if !empty(s:vimhelplint_exe)
    let s:makers += ['vimhelplint']
endif

function! neomake#makers#ft#help#EnabledMakers() abort
    return s:makers
endfunction

function! neomake#makers#ft#help#vimhelplint() abort
    " NOTE: does not support/uses arg from wrapper script (i.e. no support for
    "       tempfiles).  It will use the arg only to expand/glob `*.txt`
    "       (which does not include the hidden tempfile).
    return {
        \ 'exe': s:vimhelplint_exe,
        \ 'errorformat': '%f:%l:%c:%trror:%n:%m,%f:%l:%c:%tarning:%n:%m',
        \ 'postprocess': function('neomake#postprocess#generic_length'),
        \ 'output_stream': 'stdout',
        \ }
endfunction

function! neomake#makers#ft#help#proselint() abort
    return neomake#makers#ft#text#proselint()
endfunction

function! neomake#makers#ft#help#writegood() abort
    return neomake#makers#ft#text#writegood()
endfunction
" vim: ts=4 sw=4 et
