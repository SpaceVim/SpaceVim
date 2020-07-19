function! neomake#makers#ft#lua#EnabledMakers() abort
    return executable('luacheck') ? ['luacheck'] : ['luac']
endfunction

" luacheck: postprocess: use pattern (%s) for end column.
function! neomake#makers#ft#lua#PostprocessLuacheck(entry) abort
    if !(a:entry.type ==# 'W' && a:entry.nr ==# 631)
        " Add length, but not with W631 (line too long).
        let end_col = matchstr(a:entry.pattern, '\v\d+')
        if !empty(end_col)
            let a:entry.length = end_col - a:entry.col + 1
        endif
    endif
    let a:entry.pattern = ''
endfunction

function! neomake#makers#ft#lua#luacheck() abort
    " cwd: luacheck looks for .luacheckrc upwards from there.
    return {
        \ 'args': ['--no-color', '--formatter=plain', '--ranges', '--codes', '--filename', '%:p'],
        \ 'cwd': '%:p:h',
        \ 'errorformat': '%E%f:%l:%c-%s: \(%t%n\) %m',
        \ 'postprocess': function('neomake#makers#ft#lua#PostprocessLuacheck'),
        \ 'supports_stdin': 1,
        \ }
endfunction

function! neomake#makers#ft#lua#luac() abort
    return {
        \ 'args': ['-p'],
        \ 'errorformat': '%*\f: %#%f:%l: %m',
        \ }
endfunction
" vim: ts=4 sw=4 et
