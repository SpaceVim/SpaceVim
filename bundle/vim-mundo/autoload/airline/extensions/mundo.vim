scriptencoding utf-8

function! airline#extensions#mundo#inactive_statusline(...)
    let builder = a:1
    if getwinvar(a:2.winnr, '&filetype') == 'Mundo'
        return -1
    endif
    if getwinvar(a:2.winnr, '&filetype') == 'MundoDiff'
        return 1
    endif
endfunction

function! airline#extensions#mundo#statusline(...)
    let builder = a:1
    if &filetype == 'Mundo'
        call builder.add_section('airline_a',
                    \ get(g:, 'mundo_tree_statusline', 'Mundo'))
        call builder.split()
        call builder.add_section('airline_z', '%p%%')
        return 1
    endif
    if &filetype == 'MundoDiff'
        call builder.add_section('airline_a',
                    \ get(g:, 'mundo_preview_statusline', 'Mundo Diff'))
        call builder.split()
        return 1
    endif
endfunction

function! airline#extensions#mundo#init(...)
    call airline#add_statusline_func('airline#extensions#mundo#statusline')
    call airline#add_inactive_statusline_func(
                \ 'airline#extensions#mundo#inactive_statusline')
endfunction

