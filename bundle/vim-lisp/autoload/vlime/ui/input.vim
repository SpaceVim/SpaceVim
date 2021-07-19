function! vlime#ui#input#FromBuffer(conn, prompt, init_val, complete_cb)
    let orig_win = win_getid()
    let buf = vlime#ui#OpenBufferWithWinSettings(
                \ vlime#ui#InputBufName(a:conn, a:prompt), v:true, 'input')
    call vlime#ui#SetVlimeBufferOpts(buf, a:conn)
    call setbufvar(buf, '&buflisted', 0)
    call setbufvar(buf, '&filetype', 'vlime_input')
    setlocal winfixheight
    setlocal winfixwidth
    call vlime#ui#input#ResetBufferHistory()

    call vlime#ui#AppendString('; ' . a:prompt . "\n")
    if type(a:init_val) != type(v:null) && len(a:init_val) > 0
        call vlime#ui#AppendString(a:init_val)
    endif

    augroup VlimeInputBufferLeaveAu
        autocmd!
        execute 'autocmd BufWinLeave <buffer> bunload!' buf
    augroup end

    call setbufvar(buf, 'vlime_input_complete_cb', a:complete_cb)
    call setbufvar(buf, 'vlime_input_orig_win', orig_win)
    nnoremap <buffer> <silent> <cr> :call vlime#ui#input#FromBufferComplete()<cr>
    call vlime#ui#MapBufferKeys('input')
endfunction

" vlime#ui#input#MaybeInput(str, str_cb, prompt[, default[, conn[, completion_type]]])
function! vlime#ui#input#MaybeInput(str, str_cb, prompt, ...)
    if type(a:str) == type(v:null)
        let default = get(a:000, 0, '')
        let conn = get(a:000, 1, v:null)
        if type(conn) == type(v:null)
            let comp_type = get(a:000, 2, v:null)
            if type(comp_type) == type(v:null)
                let content = input(a:prompt, default)
            else
                let content = input(a:prompt, default, comp_type)
            endif
            call s:CheckInputValidity(content, a:str_cb, v:true)
        else
            let cur_package = conn.GetCurrentPackage()
            let cur_buf = bufnr('%')
            " Oh yeah we LOVE callbacks. You don't go to the hell. The hell
            " comes to you.
            call vlime#ui#input#FromBuffer(
                        \ conn, a:prompt,
                        \ default,
                        \ { ->
                            \ s:CheckInputValidity(vlime#ui#CurBufferContent(),
                                \ { str -> vlime#ui#WithBuffer(cur_buf, function(a:str_cb, [str]))},
                                \ v:true)})
            if bufnr('%') != cur_buf
                " We set the current package, so that the input buffer has the
                " same context as the the buffer where we initiated the input
                " operation, and completions etc. in the input buffer can work
                " as expected.
                call conn.SetCurrentPackage(cur_package)
            endif
        endif
    else
        call s:CheckInputValidity(a:str, a:str_cb, v:false)
    endif
endfunction

function! vlime#ui#input#FromBufferComplete()
    " Should always be called in the input buffer
    let input_buf = bufnr('%')

    let Callback = getbufvar(input_buf, 'vlime_input_complete_cb', v:null)
    let orig_win = getbufvar(input_buf, 'vlime_input_orig_win', v:null)

    if type(Callback) == type(v:null)
        return
    endif

    if len(vlime#ui#CurBufferContent()) > 0
        call vlime#ui#input#SaveHistory(vlime#ui#CurBufferContent(v:true))
    endif
    call Callback()
    execute 'bdelete!' input_buf

    if type(orig_win) != type(v:null)
        call win_gotoid(orig_win)
    endif
endfunction

function! vlime#ui#input#SaveHistory(text)
    if exists('g:vlime_input_history_limit')
        if g:vlime_input_history_limit <= 0
            return
        endif
        let max_items = g:vlime_input_history_limit
    else
        let max_items = 200
    endif

    let history = get(g:, 'vlime_input_history', [])

    if len(history) > 0 && history[-1] == a:text
        return
    endif

    let prev_idx = index(history, a:text)
    while prev_idx >= 0
        call remove(history, prev_idx)
        let prev_idx = index(history, a:text)
    endwhile

    call add(history, a:text)
    if len(history) > max_items
        let delta = len(history) - max_items
        let history = history[delta:-1]
    endif

    let g:vlime_input_history = history
endfunction

" vlime#ui#input#GetHistory([direction[, idx]])
function! vlime#ui#input#GetHistory(...)
    let history = get(g:, 'vlime_input_history', [])

    let direction = get(a:000, 0, 'backward')
    let idx = get(a:000, 1, len(history))

    if direction == 'backward'
        if idx <= 0
            return [0, '']
        elseif idx > len(history)
            let idx = len(history)
        endif
        return (len(history) > 0) ? [idx - 1, history[idx - 1]] : [0, '']
    elseif direction == 'forward'
        if idx >= len(history) - 1
            return [len(history), '']
        elseif idx < -1
            let idx = -1
        endif
        return (len(history) > 0) ? [idx + 1, history[idx + 1]] : [0, '']
    endif
endfunction

" vlime#ui#input#NextHistoryItem([direction])
function! vlime#ui#input#NextHistoryItem(...)
    let direction = get(a:000, 0, 'backward')

    if exists('b:vlime_input_history_idx')
        let [next_idx, text] = vlime#ui#input#GetHistory(
                    \ direction, b:vlime_input_history_idx)
    else
        let b:vlime_input_orig_text = vlime#ui#CurBufferContent(v:true)
        let [next_idx, text] = vlime#ui#input#GetHistory(direction)
    endif

    let b:vlime_input_history_idx = next_idx
    let cur_pos = getcurpos()
    if len(text) > 0
        1,$delete _
        call vlime#ui#AppendString(text)
    elseif next_idx > 0 && exists('b:vlime_input_orig_text')
        unlet b:vlime_input_history_idx
        1,$delete _
        call vlime#ui#AppendString(b:vlime_input_orig_text)
        unlet b:vlime_input_orig_text
    endif
    call setpos('.', cur_pos)
endfunction

function! vlime#ui#input#ResetBufferHistory()
    for buf_var in ['b:vlime_input_history_idx',
                    \ 'b:vlime_input_orig_text',
                    \ 'b:vlime_input_complete_cb']
        if exists(buf_var)
            execute 'unlet' buf_var
        endif
    endfor
endfunction

function! s:CheckInputValidity(str_val, cb, cancellable)
    if len(a:str_val) > 0
        call a:cb(a:str_val)
    elseif a:cancellable
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction
