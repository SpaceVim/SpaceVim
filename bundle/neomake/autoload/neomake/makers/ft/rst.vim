" vim: ts=4 sw=4 et

function! neomake#makers#ft#rst#SupersetOf() abort
    return 'text'
endfunction

" Get Sphinx source dir for the current buffer (determined by looking for
" conf.py, typically in docs/ or doc/).
" Caches the value in a buffer-local setting.
function! s:get_sphinx_srcdir() abort
    let srcdir = neomake#config#get('sphinx.source_dir')
    if srcdir isnot# g:neomake#config#undefined
        return srcdir
    endif

    let r = ''
    let project_root = neomake#utils#get_project_root()
    let bufname = bufname('%')
    if empty(bufname)
        call neomake#log#debug('sphinx: skipping setting of source_dir for empty bufname.', {'bufnr': bufnr('%')})
        return ''
    endif
    let f = findfile('conf.py', printf('%s;%s', fnamemodify(bufname, ':p:h'), project_root))
    if !empty(f)
        let r = fnamemodify(f, ':p:h')
    endif
    call neomake#log#debug(printf('sphinx: setting b:neomake.sphinx.source_dir=%s.', string(r)), {'bufnr': bufnr('%')})
    call neomake#config#set('b:sphinx.source_dir', r)
    return r
endfunction

function! neomake#makers#ft#rst#EnabledMakers() abort
    if executable('sphinx-build') && !empty(s:get_sphinx_srcdir())
        return ['sphinx']
    endif
    return ['rstlint', 'rstcheck']
endfunction

function! neomake#makers#ft#rst#rstlint() abort
    return {
        \ 'exe': 'rst-lint',
        \ 'errorformat':
            \ '%ESEVERE %f:%l %m,'.
            \ '%EERROR %f:%l %m,'.
            \ '%WWARNING %f:%l %m,'.
            \ '%IINFO %f:%l %m,'.
            \ '%C%m',
        \ 'postprocess': function('neomake#postprocess#compress_whitespace'),
        \ 'output_stream': 'stdout',
        \ }
endfunction

function! neomake#makers#ft#rst#rstcheck() abort
    return {
        \ 'errorformat':
            \ '%I%f:%l: (INFO/1) %m,'.
            \ '%W%f:%l: (WARNING/2) %m,'.
            \ '%E%f:%l: (ERROR/3) %m,'.
            \ '%E%f:%l: (SEVERE/4) %m',
        \ }
endfunction

function! neomake#makers#ft#rst#sphinx() abort
    " TODO:
    "  - project mode (after cleanup branch)
    let srcdir = s:get_sphinx_srcdir()
    if empty(srcdir)
        throw 'Neomake: sphinx: could not find conf.py (you can configure sphinx.source_dir)'
    endif
    if !exists('s:sphinx_cache')
        let s:sphinx_cache = tempname()
    endif
    " NOTE: uses '%Z%m,%-G%.%#' instead of '%C%m,%-G' to include next line in
    "       multiline errors (fixed in 7.4.203).
    return {
        \ 'exe': 'sphinx-build',
        \ 'args': ['-n', '-E', '-q', '-N', '-b', 'dummy', srcdir, s:sphinx_cache],
        \ 'append_file': 0,
        \ 'errorformat':
            \ '%A%f:%l: %tARNING: %m,' .
            \ '%EWARNING: %f:%l: (SEVER%t/4) %m,' .
            \ '%EWARNING: %f:%l: (%tRROR/3) %m,' .
            \ '%EWARNING: %f:%l: (%tARNING/2) %m,' .
            \ '%Z%m,' .
            \ '%-G%.%#',
        \ 'output_stream': 'stderr',
        \ 'postprocess': function('neomake#postprocess#compress_whitespace'),
        \ }
endfunction
