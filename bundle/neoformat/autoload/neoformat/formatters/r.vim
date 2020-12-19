function! neoformat#formatters#r#enabled() abort
    return ['styler', 'formatR']
endfunction

function! neoformat#formatters#r#styler() abort
    return {
        \ 'exe': 'R',
        \ 'args': ['--slave', '--no-restore', '--no-save', '-e "styler::style_text(readr::read_file((file(\"stdin\"))))"', '2>/dev/null'],
        \ 'replace': 1,
        \}
endfunction

function! neoformat#formatters#r#formatR() abort
    return {
        \ 'exe': 'R',
        \ 'args': ['--slave', '--no-restore', '--no-save', '-e "formatR::tidy_source(\"stdin\", arrow=FALSE)"', '2>/dev/null'],
        \ 'stdin': 1,
        \}
endfunction
