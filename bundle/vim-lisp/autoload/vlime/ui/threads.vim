function! vlime#ui#threads#InitThreadsBuffer(conn)
    let buf = bufnr(vlime#ui#ThreadsBufName(a:conn), v:true)
    if !vlime#ui#VlimeBufferInitialized(buf)
        call vlime#ui#SetVlimeBufferOpts(buf, a:conn)
        call setbufvar(buf, '&filetype', 'vlime_threads')
        call vlime#ui#WithBuffer(buf, function('s:InitThreadsBuf'))
    endif
    return buf
endfunction

function! vlime#ui#threads#FillThreadsBuf(thread_list)
    setlocal modifiable

    if type(a:thread_list) == type(v:null)
        call vlime#ui#ReplaceContent('The thread list is empty.')
        let b:vlime_thread_coords = []
        return
    endif

    let field_widths = s:CalcAllFieldWidths(a:thread_list)
    let total_width = 0
    for w in field_widths
        let total_width += w
    endfor
    " Consider the column separators
    let total_width += (len(a:thread_list[0]) * 2)

    let coords = []
    1,$delete _
    let idx = -1
    for thread in a:thread_list
        let begin_pos = getcurpos()
        call map(thread, function('s:AppendThreadInfoField', [field_widths]))

        let eof_coord = vlime#ui#GetEndOfFileCoord()
        call setpos('.', [0, eof_coord[0], eof_coord[1], 0])

        if idx >= 0
            let end_pos = getcurpos()
            call add(coords, {
                        \ 'begin': [begin_pos[1], begin_pos[2]],
                        \ 'end': [end_pos[1], end_pos[2]],
                        \ 'type': 'THREAD',
                        \ 'id': thread[0],
                        \ 'nth': idx,
                        \ 'name': thread[1],
                        \ })
            call vlime#ui#AppendString("\n")
        else
            call vlime#ui#AppendString("\n" . repeat('-', total_width) . "\n")
        endif
        let idx += 1
    endfor
    call setpos('.', [0, 1, 1, 0, 1])

    setlocal nomodifiable

    let b:vlime_thread_coords = coords
endfunction

function! vlime#ui#threads#InterruptCurThread()
    let coord = s:FindCurCoord(
                \ getcurpos(), getbufvar('%', 'vlime_thread_coords', []))
    if type(coord) == type(v:null)
        return
    endif
    call b:vlime_conn.Interrupt(coord['id'])
endfunction

function! vlime#ui#threads#KillCurThread()
    let coord = s:FindCurCoord(
                \ getcurpos(), getbufvar('%', 'vlime_thread_coords', []))
    if type(coord) == type(v:null)
        return
    endif
    let answer = input('Kill thread ' . string(coord['name']) . '? (y/n) ')
    if tolower(answer) == 'y' || tolower(answer) == 'yes'
        call b:vlime_conn.KillNthThread(coord['nth'],
                    \ {c, _r -> vlime#ui#threads#Refresh(c)})
    else
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction

function! vlime#ui#threads#DebugCurThread()
    let coord = s:FindCurCoord(
                \ getcurpos(), getbufvar('%', 'vlime_thread_coords', []))
    if type(coord) == type(v:null)
        return
    endif
    call b:vlime_conn.DebugNthThread(coord['nth'])
endfunction

" vlime#ui#threads#Refresh([conn[, keep_cur_pos]])
function! vlime#ui#threads#Refresh(...)
    let conn = get(a:000, 0, v:null)
    let keep_cur_pos = get(a:000, 1, v:true)

    if keep_cur_pos
        let cur_pos = getcurpos()
    else
        let cur_pos = v:null
    endif

    if type(conn) == type(v:null)
        let conn = b:vlime_conn
    endif

    call conn.ListThreads(function('s:OnListThreadsComplete', [cur_pos]))
endfunction

function! s:OnListThreadsComplete(cur_pos, conn, result)
    call a:conn.ui.OnThreads(a:conn, a:result)
    if type(a:cur_pos) != type(v:null)
        call setpos('.', a:cur_pos)
    endif
endfunction

function! s:FindCurCoord(cur_pos, coords)
    for c in a:coords
        if vlime#ui#MatchCoord(c, a:cur_pos[1], a:cur_pos[2])
            return c
        endif
    endfor
    return v:null
endfunction

function! s:NormalizeFieldValue(val)
    if type(a:val) == v:t_string
        return a:val
    elseif type(a:val) == v:t_dict
        " headers
        return a:val['name']
    else
        return string(a:val)
    endif
endfunction

function! s:AppendThreadInfoField(field_widths, field_idx, field_val)
    let width = a:field_widths[a:field_idx]
    let n_str = s:NormalizeFieldValue(a:field_val)
    if a:field_idx > 0
        let padded_str = vlime#ui#Pad('| ' . n_str, '', width + 2)
    else
        let padded_str = vlime#ui#Pad(n_str, '', width)
    endif
    call vlime#ui#AppendString(padded_str)
    return a:field_val
endfunction

function! s:CalcFieldWidth(field, thread_list)
    let max_width = 0
    for thread in a:thread_list
        let n_str = s:NormalizeFieldValue(thread[a:field])
        if len(n_str) > max_width
            let max_width = len(n_str)
        endif
    endfor
    return  max_width
endfunction

function! s:CalcAllFieldWidths(thread_list)
    return map(copy(a:thread_list[0]),
                \ {idx, _val -> s:CalcFieldWidth(idx, a:thread_list)})
endfunction

function! s:InitThreadsBuf()
    call vlime#ui#MapBufferKeys('threads')
endfunction
