function! vlime#ui#xref#InitXRefBuf(conn, orig_win)
    let buf = bufnr(vlime#ui#XRefBufName(a:conn), v:true)
    if !vlime#ui#VlimeBufferInitialized(buf)
        call vlime#ui#SetVlimeBufferOpts(buf, a:conn)
        call setbufvar(buf, '&filetype', 'vlime_xref')
        call vlime#ui#WithBuffer(buf, function('s:InitXRefBuf'))
    endif
    call setbufvar(buf, 'vlime_xref_orig_win', a:orig_win)
    return buf
endfunction

function! vlime#ui#xref#FillXRefBuf(xref_list)
    setlocal modifiable

    if type(a:xref_list) == type(v:null)
        call vlime#ui#ReplaceContent('No xref found.')
        let b:vlime_xref_coords = []
        let b:vlime_xref_list = []
        return
    elseif type(a:xref_list) == v:t_dict &&
                \ a:xref_list['name'] == 'NOT-IMPLEMENTED'
        call vlime#ui#ReplaceContent('Not implemented.')
        let b:vlime_xref_coords = []
        let b:vlime_xref_list = []
        return
    else
        let xlist = a:xref_list
    endif

    let coords = []
    1,$delete _
    let idx = 0
    for xref in xlist
        let begin_pos = getcurpos()
        call vlime#ui#AppendString(xref[0])
        let eof_coord = vlime#ui#GetEndOfFileCoord()
        call vlime#ui#AppendString("\n")
        call add(coords, {
                    \ 'begin': [begin_pos[1], begin_pos[2]],
                    \ 'end': eof_coord,
                    \ 'type': 'XREF',
                    \ 'id': idx,
                    \ })
        let idx += 1
    endfor
    call setpos('.', [0, 1, 1, 0, 1])

    setlocal nomodifiable

    let b:vlime_xref_coords = coords
    let b:vlime_xref_list = xlist
endfunction

" vlime#ui#xref#OpenCurXref([close_xref[, edit_cmd]])
function! vlime#ui#xref#OpenCurXref(...)
    let close_xref = get(a:000, 0, v:true)
    let edit_cmd = get(a:000, 1, 'hide edit')

    let cur_pos = getcurpos()
    let xref_coord = v:null
    for c in b:vlime_xref_coords
        if vlime#ui#MatchCoord(c, cur_pos[1], cur_pos[2])
            let xref_coord = c
            break
        endif
    endfor

    if type(xref_coord) == type(v:null)
        return
    endif

    let raw_xref_loc = b:vlime_xref_list[xref_coord['id']][1]
    try
        let xref_loc = vlime#ParseSourceLocation(raw_xref_loc)
        let valid_loc = vlime#GetValidSourceLocation(xref_loc)
    catch
        let valid_loc = []
    endtry

    if len(valid_loc) > 0 && type(valid_loc[1]) != type(v:null)
        if type(valid_loc[0]) == v:t_string && valid_loc[0][0:6] != 'sftp://'
                    \ && !filereadable(valid_loc[0])
            call vlime#ui#ErrMsg('Not readable: ' . valid_loc[0])
            return
        endif

        let xref_win_id = win_getid()

        let orig_win = getbufvar('%', 'vlime_xref_orig_win', v:null)
        let [win_to_go, count_specified] = vlime#ui#ChooseWindowWithCount(orig_win)
        if win_to_go > 0
            call win_gotoid(win_to_go)
        elseif count_specified
            return
        endif

        if close_xref && win_getid() != xref_win_id
            execute win_id2win(xref_win_id) . 'wincmd c'
        endif

        call vlime#ui#ShowSource(b:vlime_conn, valid_loc, edit_cmd, count_specified)
    elseif type(raw_xref_loc) != type(v:null) && raw_xref_loc[0]['name'] == 'ERROR'
        call vlime#ui#ErrMsg(raw_xref_loc[1])
    else
        call vlime#ui#ErrMsg('No source available.')
    endif
endfunction

function! s:FindXRefLocationProp(key, prop_list)
    if type(a:prop_list) != type(v:null)
        for p in a:prop_list
            if type(p) == v:t_list && p[0]['name'] == a:key
                return p[1]
            endif
        endfor
    endif
    return v:null
endfunction

function! s:InitXRefBuf()
    call vlime#ui#MapBufferKeys('xref')
endfunction
