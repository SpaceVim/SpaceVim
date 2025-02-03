function! neomake#makers#ft#dockerfile#EnabledMakers() abort
    return ['hadolint']
endfunction

function! neomake#makers#ft#dockerfile#hadolint() abort
    return {
          \ 'output_stream': 'stdout',
          \ 'uses_stdin': 1,
          \ 'args': ['--format', 'tty', '--no-color'],
          \ 'errorformat': '%f:%l %m',
          \ 'postprocess': [
          \   function('neomake#makers#ft#dockerfile#HadolintProcess'),
          \ ],
          \ }
endfunction

function! neomake#makers#ft#dockerfile#HadolintProcess(entry) abort
    let m = matchlist(a:entry.text, '\v^(DL|SC)(\d+) (warning|info|\w+): (.*)')
    if !empty(m)
        let a:entry.nr = str2nr(m[2])
        let matched_type = ''
        if m[3] ==# 'warning'
            let matched_type = 'W'
        elseif m[3] ==# 'info'
            let matched_type = 'I'
        endif
        if empty(matched_type)
            " Guess, but do not adjust text.
            let a:entry.type = m[3][0]
        else
            let a:entry.type = matched_type
            " Remove type ("warning"/"info") from text.
            let a:entry.text = printf('%s%s: %s', m[1], m[2], m[4])
        endif
    endif
endfunction

" vim: ts=4 sw=4 et
