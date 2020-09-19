" vim: ts=4 sw=4 et

function! neomake#makers#ft#bib#EnabledMakers() abort
    return []
endfunction

function! neomake#makers#ft#bib#bibtex() abort
    return {
                \ 'exe': 'bibtex',
                \ 'args': ['-terse', '%:r'],
                \ 'append_file': 0,
                \ 'uses_filename': 0,
                \ 'errorformat': '%E%m---line %l of file %f',
                \ 'cwd': '%:p:h'
                \ }
endfunction
