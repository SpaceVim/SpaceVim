let s:save_cpo = &cpo
set cpo&vim

function! grammarous#info_win#action_return()
    call grammarous#move_to_checked_buf(b:grammarous_preview_error.fromy+1, b:grammarous_preview_error.fromx+1)
endfunction

function! grammarous#info_win#action_fixit()
    call grammarous#fixit(b:grammarous_preview_error)
endfunction

function! grammarous#info_win#action_remove_error()
    let e = b:grammarous_preview_error
    if !grammarous#move_to_checked_buf(
        \ b:grammarous_preview_error.fromy+1,
        \ b:grammarous_preview_error.fromx+1 )
        return
    endif

    call grammarous#remove_error(e, b:grammarous_result)
endfunction

function! grammarous#info_win#action_disable_rule()
    let e = b:grammarous_preview_error
    if !grammarous#move_to_checked_buf(
        \ b:grammarous_preview_error.fromy+1,
        \ b:grammarous_preview_error.fromx+1 )
        return
    endif

    call grammarous#disable_rule(e.ruleId, b:grammarous_result)
endfunction

function! grammarous#info_win#action_next_error()
    if !grammarous#move_to_checked_buf(
        \ b:grammarous_preview_error.fromy+1,
        \ b:grammarous_preview_error.fromx+1 )
        return
    endif

    if !grammarous#move_to_next_error(getpos('.')[1 : 2], b:grammarous_result)
        wincmd p
    endif
endfunction

function! grammarous#info_win#action_previous_error()
    if !grammarous#move_to_checked_buf(
        \ b:grammarous_preview_error.fromy+1,
        \ b:grammarous_preview_error.fromx+1 )
        return
    endif

    if !grammarous#move_to_previous_error(getpos('.')[1 : 2], b:grammarous_result)
        wincmd p
    endif
endfunction

function! grammarous#info_win#action_help()
    echo join([
            \   '| Mappings | Description                                    |',
            \   '| -------- |:---------------------------------------------- |',
            \   '|    q     | Quit the info window                           |',
            \   '|   <CR>   | Move to the location of the error              |',
            \   '|    f     | Fix the error automatically                    |',
            \   '|    r     | Remove the error without fix                   |',
            \   '|    R     | Disable the grammar rule in the checked buffer |',
            \   '|    n     | Move to the next error                         |',
            \   '|    p     | Move to the previous error                     |',
            \ ], "\n")
endfunction

function! s:get_info_buffer(e)
    let lines = 
        \ [
        \   'Error: ' . a:e.category,
        \   '    ' . a:e.msg,
        \   '',
        \ ]
    if a:e.replacements !=# ''
        let lines +=
        \ [
        \   'Corrections:',
        \   '    ' . join(split(a:e.replacements, '#', 1), '; '),
        \   '',
        \ ]
    endif
    let lines +=
        \ [
        \   'Context:',
        \   '    ' . a:e.context,
        \   '',
        \   "Press '?' in this window to show help",
        \ ]
    return lines
endfunction

function! grammarous#info_win#action_quit()
    let s:do_not_preview = 1
    let preview_bufnr = bufnr('%')

    quit!

    " Consider the case where :quit! does not navigate to the buffer
    " where :GrammarousCheck checked.
    for bufnr in tabpagebuflist()
        let b = getbufvar(bufnr, 'grammarous_preview_bufnr', -1)
        if b != preview_bufnr
            continue
        endif

        let winnr = bufwinnr(bufnr)
        if winnr == -1
            continue
        endif

        execute winnr . 'wincmd w'
        unlet b:grammarous_preview_bufnr
        return
    endfor
    " Reach here when the original buffer was already closed
endfunction

function! grammarous#info_win#update(e)
    let b:grammarous_preview_error = a:e
    silent normal! gg"_dG
    silent %delete _
    call setline(1, s:get_info_buffer(a:e))
    execute 1
    setlocal modified

    return bufnr('%')
endfunction

function! grammarous#info_win#open(e, bufnr)
    execute g:grammarous#info_win_direction g:grammarous#info_window_height . 'new' '[Grammarous]'
    let b:grammarous_preview_original_bufnr = a:bufnr
    let b:grammarous_preview_error = a:e
    call setline(1, s:get_info_buffer(a:e))
    execute 1
    syntax match GrammarousInfoSection "\%(Context\|Correction\):"
    syntax match GrammarousInfoError "Error:.*$"
    syntax match GrammarousInfoHelp "^Press '?' in this window to show help$"
    execute 'syntax match GrammarousError "' . escape(grammarous#generate_highlight_pattern(a:e), '"') . '"'
    setlocal nonumber
    setlocal bufhidden=hide
    setlocal buftype=nofile
    setlocal readonly
    setlocal nolist
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nospell
    setlocal nomodeline
    setlocal nofoldenable
    setlocal noreadonly
    setlocal foldcolumn=0
    setlocal nomodified
    nnoremap <silent><buffer>q :<C-u>call grammarous#info_win#action_quit()<CR>
    nnoremap <silent><buffer><CR> :<C-u>call grammarous#info_win#action_return()<CR>
    nnoremap <buffer>f :<C-u>call grammarous#info_win#action_fixit()<CR>
    nnoremap <silent><buffer>r :<C-u>call grammarous#info_win#action_remove_error()<CR>
    nnoremap <silent><buffer>R :<C-u>call grammarous#info_win#action_disable_rule()<CR>
    nnoremap <silent><buffer>n :<C-u>call grammarous#info_win#action_next_error()<CR>
    nnoremap <silent><buffer>p :<C-u>call grammarous#info_win#action_previous_error()<CR>
    nnoremap <silent><buffer>? :<C-u>call grammarous#info_win#action_help()<CR>
    return bufnr('%')
endfunction

function! s:lookup_preview_bufnr()
    for b in tabpagebuflist()
        let the_buf = getbufvar(b, 'grammarous_preview_bufnr', -1)
        if the_buf != -1
            return the_buf
        endif
    endfor
    return -1
endfunction

function! grammarous#info_win#close()
    let cur_win = winnr()
    if exists('b:grammarous_preview_bufnr')
        let prev_win = bufwinnr(b:grammarous_preview_bufnr)
    else
        let the_buf = s:lookup_preview_bufnr()
        if the_buf == -1
            return 0
        endif
        let prev_win = bufwinnr(the_buf)
    endif

    if prev_win == -1
        return 0
    end

    execute prev_win . 'wincmd w'
    wincmd c
    execute cur_win . 'wincmd w'

    return 1
endfunction

function! s:do_auto_preview()
    let mode = mode()
    if mode ==? 'v' || mode ==# "\<C-v>"
        return
    endif

    if exists('s:do_not_preview')
        unlet s:do_not_preview
        return
    endif

    if !exists('b:grammarous_result') || empty(b:grammarous_result)
        autocmd! plugin-grammarous-auto-preview
        return
    endif

    call grammarous#create_update_info_window_of(b:grammarous_result)
endfunction

function! grammarous#info_win#start_auto_preview()
    augroup plugin-grammarous-auto-preview
        autocmd!
        autocmd CursorMoved <buffer> call <SID>do_auto_preview()
    augroup END
endfunction

function! grammarous#info_win#stop_auto_preview()
    silent! autocmd! plugin-grammarous-auto-preview
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
