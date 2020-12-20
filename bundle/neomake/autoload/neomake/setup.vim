if has('signs')
    let g:neomake_place_signs = get(g:, 'neomake_place_signs', 1)
else
    let g:neomake_place_signs = 0
    lockvar g:neomake_place_signs
endif

function! neomake#setup#define_highlights() abort
    if g:neomake_place_signs
        call neomake#signs#DefineHighlights()
    endif
    if get(g:, 'neomake_highlight_columns', 1)
                \ || get(g:, 'neomake_highlight_lines', 0)
        call neomake#highlights#DefineHighlights()
    endif
endfunction

function! neomake#setup#setup_autocmds() abort
    augroup neomake
        au!
        if !exists('*nvim_buf_add_highlight')
            autocmd BufEnter * call neomake#highlights#ShowHighlights()
        endif
        if has('timers')
            autocmd CursorMoved * call neomake#CursorMovedDelayed()
            " Force-redraw display of current error after resizing Vim, which appears
            " to clear the previously echoed error.
            autocmd VimResized * call timer_start(100, function('neomake#EchoCurrentError'))
        else
            autocmd CursorHold,CursorHoldI * call neomake#CursorMoved()
        endif
        autocmd VimLeave * call neomake#VimLeave()
        autocmd ColorScheme * call neomake#setup#define_highlights()
    augroup END
endfunction

" vim: ts=4 sw=4 et
