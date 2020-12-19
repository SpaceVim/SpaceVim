function! neomake#makers#ft#text#EnabledMakers() abort
    " No makers enabled by default, since text is used as fallback often.
    return []
endfunction

function! neomake#makers#ft#text#proselint() abort
    return {
                \ 'errorformat': '%W%f:%l:%c: %m',
                \ 'postprocess': function('neomake#postprocess#generic_length'),
                \ }
endfunction

function! neomake#makers#ft#text#PostprocessWritegood(entry) abort
    let a:entry.col += 1
    if a:entry.text[0] ==# '"'
        let matchend = match(a:entry.text, '\v^[^"]+\zs"', 1)
        if matchend != -1
            let a:entry.length = matchend - 1
        endif
    endif
endfunction

function! neomake#makers#ft#text#writegood() abort
    return {
                \ 'args': ['--parse'],
                \ 'errorformat': '%W%f:%l:%c:%m,%C%m,%-G',
                \ 'postprocess': function('neomake#makers#ft#text#PostprocessWritegood'),
                \ }
endfunction
" vim: ts=4 sw=4 et
