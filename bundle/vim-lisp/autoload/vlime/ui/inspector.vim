function! vlime#ui#inspector#InitInspectorBuf(ui, conn, thread)
    let buf = bufnr(vlime#ui#InspectorBufName(a:conn), v:true)
    if !vlime#ui#VlimeBufferInitialized(buf)
        call vlime#ui#SetVlimeBufferOpts(buf, a:conn)
        call setbufvar(buf, '&filetype', 'vlime_inspector')
        call vlime#ui#WithBuffer(buf, function('s:InitInspectorBuf'))
    endif
    if type(a:thread) != type(v:null)
        call a:ui.SetCurrentThread(a:thread, buf)
    endif
    return buf
endfunction

function! vlime#ui#inspector#FillInspectorBuf(content, thread, itag)
    let b:vlime_inspector_title = a:content['TITLE']
    let b:vlime_inspector_content_start = a:content['CONTENT'][2]
    let b:vlime_inspector_content_end = a:content['CONTENT'][3]
    let b:vlime_inspector_content_more =
                \ a:content['CONTENT'][1] > b:vlime_inspector_content_end

    setlocal modifiable

    call vlime#ui#ReplaceContent(a:content['TITLE'] . "\n"
                \ . repeat('=', len(a:content['TITLE'])) . "\n\n")
    let eof_coord = vlime#ui#GetEndOfFileCoord()
    call setpos('.', [0, eof_coord[0], eof_coord[1], 0])

    let coords = []
    call vlime#ui#inspector#FillInspectorBufContent(
                \ a:content['CONTENT'][0], coords)

    let range_buttons = []
    if b:vlime_inspector_content_start > 0
        call add(range_buttons,
                    \ [{'name': 'RANGE', 'package': 'KEYWORD'},
                        \ "[prev range]", -1])
    endif
    if b:vlime_inspector_content_more
        if len(range_buttons) > 0
            call add(range_buttons, '  ')
        endif
        call add(range_buttons,
                    \ [{'name': 'RANGE', 'package': 'KEYWORD'},
                        \ "[next range]", 1])
    endif
    if len(range_buttons) > 0
        call add(range_buttons, '  ')
        call add(range_buttons,
                    \ [{'name': 'RANGE', 'package': 'KEYWORD'},
                        \ "[all content]", 0])
        if len(getline('.')) > 0
            let range_buttons = ["\n", range_buttons]
        endif
        call vlime#ui#inspector#FillInspectorBufContent(range_buttons, coords)
    endif

    setlocal nomodifiable

    let b:vlime_inspector_coords = coords
    if exists('b:vlime_inspector_coords_match')
        call vlime#ui#MatchDeleteList(b:vlime_inspector_coords_match)
    endif

    let action_coords = []
    let value_coords = []
    for co in coords
        if co['type'] == 'VALUE'
            call add(value_coords, co)
        else
            call add(action_coords, co)
        endif
    endfor

    let b:vlime_inspector_coords_match =
                \ vlime#ui#MatchAddCoords('vlime_inspectorAction', action_coords) +
                \ vlime#ui#MatchAddCoords('vlime_inspectorValue', value_coords)

    augroup VlimeInspectorLeaveAu
        autocmd!
        execute 'autocmd BufWinLeave <buffer> call vlime#ui#inspector#ResetInspectorBuffer('
                    \ . bufnr('%') . ')'
        if type(a:thread) != type(v:null) && type(a:itag) != type(v:null)
            execute 'autocmd BufWinLeave <buffer> call b:vlime_conn.Return('
                        \ . a:thread . ', ' . a:itag . ', v:null)'
        endif
    augroup end
endfunction

function! vlime#ui#inspector#FillInspectorBufContent(content, coords)
    if type(a:content) == v:t_string
        call vlime#ui#AppendString(a:content)
        let eof_coord = vlime#ui#GetEndOfFileCoord()
        call setpos('.', [0, eof_coord[0], eof_coord[1], 0])
    elseif type(a:content) == v:t_list
        if len(a:content) == 3 && type(a:content[0]) == v:t_dict
            let begin_pos = getcurpos()
            if begin_pos[2] != 1 || len(getline('.')) > 0
                let begin_pos[2] += 1
            endif
            call vlime#ui#inspector#FillInspectorBufContent(
                        \ a:content[1], a:coords)
            let end_pos = getcurpos()
            call add(a:coords, {
                        \ 'begin': [begin_pos[1], begin_pos[2]],
                        \ 'end': [end_pos[1], end_pos[2]],
                        \ 'type': a:content[0]['name'],
                        \ 'id': a:content[2],
                        \ })
        else
            for c in a:content
                call vlime#ui#inspector#FillInspectorBufContent(c, a:coords)
            endfor
        endif
    endif
endfunction

function! vlime#ui#inspector#ResetInspectorBuffer(bufnr)
    " Clear the content instead of unloading the buffer, to preserve the
    " syntax highlighting settings
    call setbufvar(a:bufnr, 'vlime_inspector_coords', [])
    let coords_match = getbufvar(a:bufnr, 'vlime_inspector_coords_match', [])
    call setbufvar(a:bufnr, 'vlime_inspector_coords_match', [])
    call setbufvar(a:bufnr, '&modifiable', 1)
    call vlime#ui#WithBuffer(a:bufnr,
                \ {->
                    \ vlime#ui#ReplaceContent('') &&
                    \ vlime#ui#MatchDeleteList(coords_match)})
    call setbufvar(a:bufnr, '&modifiable', 0)

    " This function is called in an autocmd in this particular augroup we are
    " clearing, but it seemed okay to do so.
    augroup VlimeInspectorLeaveAu
        autocmd!
    augroup end
endfunction

function! vlime#ui#inspector#InspectorSelect()
    let coord = s:GetCurCoord()

    if type(coord) == type(v:null)
        return
    endif

    if coord['type'] == 'ACTION'
        call b:vlime_conn.InspectorCallNthAction(coord['id'],
                    \ {c, r -> c.ui.OnInspect(c, r, v:null, v:null)})
    elseif coord['type'] == 'VALUE'
        call b:vlime_conn.InspectNthPart(coord['id'],
                    \ {c, r -> c.ui.OnInspect(c, r, v:null, v:null)})
    elseif coord['type'] == 'RANGE'
        let range_size = b:vlime_inspector_content_end -
                    \ b:vlime_inspector_content_start
        if coord['id'] > 0
            let next_start = b:vlime_inspector_content_end
            let next_end = b:vlime_inspector_content_end + range_size
            call b:vlime_conn.InspectorRange(next_start, next_end,
                        \ {c, r -> c.ui.OnInspect(c,
                            \ [{'name': 'TITLE', 'package': 'KEYWORD'}, b:vlime_inspector_title,
                                \ {'name': 'CONTENT', 'package': 'KEYWORD'}, r],
                            \ v:null, v:null)})
        elseif coord['id'] < 0
            let next_start = max([0, b:vlime_inspector_content_start - range_size])
            let next_end = b:vlime_inspector_content_start
            call b:vlime_conn.InspectorRange(next_start, next_end,
                        \ {c, r -> c.ui.OnInspect(c,
                            \ [{'name': 'TITLE', 'package': 'KEYWORD'}, b:vlime_inspector_title,
                                \ {'name': 'CONTENT', 'package': 'KEYWORD'}, r],
                            \ v:null, v:null)})
        else
            echom 'Fetching all inspector content, please wait...'
            let acc = {'TITLE': b:vlime_inspector_title, 'CONTENT': [[], 0, 0, 0]}
            call b:vlime_conn.InspectorRange(0, range_size,
                        \ function('s:InspectorFetchAllCB', [acc]))
        endif
    endif
endfunction

function! vlime#ui#inspector#SendCurValueToREPL()
    let coord = s:GetCurCoord()

    if type(coord) == type(v:null) || coord['type'] != 'VALUE'
        return
    endif

    call b:vlime_conn.ui.OnWriteString(b:vlime_conn,
                \ "--\n", {'name': 'REPL-SEP', 'package': 'KEYWORD'})
    call b:vlime_conn.WithThread({'name': 'REPL-THREAD', 'package': 'KEYWORD'},
                \ function(b:vlime_conn.ListenerEval,
                    \ ['(nth-value 0 (swank:inspector-nth-part ' . coord['id'] . '))']))
endfunction

function! vlime#ui#inspector#SendCurInspecteeToREPL()
    call b:vlime_conn.ui.OnWriteString(b:vlime_conn,
                \ "--\n", {'name': 'REPL-SEP', 'package': 'KEYWORD'})
    call b:vlime_conn.WithThread({'name': 'REPL-THREAD', 'package': 'KEYWORD'},
                \ function(b:vlime_conn.ListenerEval,
                    \ ['(swank::istate.object swank::*istate*)']))
endfunction

" vlime#ui#inspector#FindSource(type[, edit_cmd])
function! vlime#ui#inspector#FindSource(type, ...)
    let edit_cmd = get(a:000, 0, 'hide edit')

    if a:type == 'inspectee'
        let id = 0
    elseif a:type == 'part'
        let coord = s:GetCurCoord()
        if type(coord) == type(v:null) || coord['type'] != 'VALUE'
            return
        endif
        let id = coord['id']
    endif

    let [win_to_go, count_specified] = vlime#ui#ChooseWindowWithCount(v:null)
    if win_to_go <= 0 && count_specified
        return
    endif

    call b:vlime_conn.FindSourceLocationForEmacs(['INSPECTOR', id],
                \ function('s:FindSourceCB', [edit_cmd, win_to_go, count_specified]))
endfunction

function! vlime#ui#inspector#NextField(forward)
    if len(b:vlime_inspector_coords) <= 0
        return
    endif

    let cur_pos = getcurpos()
    let sorted_coords = sort(copy(b:vlime_inspector_coords),
                \ function('vlime#ui#CoordSorter', [a:forward]))
    let next_coord = vlime#ui#FindNextCoord(
                \ cur_pos[1:2], sorted_coords, a:forward)
    if type(next_coord) == type(v:null)
        let next_coord = sorted_coords[0]
    endif

    call setpos('.', [0, next_coord['begin'][0],
                    \ next_coord['begin'][1], 0,
                    \ next_coord['begin'][1]])
endfunction

function! vlime#ui#inspector#InspectorPop()
    call b:vlime_conn.InspectorPop(function('s:OnInspectorPopComplete', ['previous']))
endfunction

function! vlime#ui#inspector#InspectorNext()
    call b:vlime_conn.InspectorNext(function('s:OnInspectorPopComplete', ['next']))
endfunction

function! s:OnInspectorPopComplete(which, conn, result)
    if type(a:result) == type(v:null)
        call vlime#ui#ErrMsg('No ' . a:which . ' object.')
    else
        call a:conn.ui.OnInspect(a:conn, a:result, v:null, v:null)
    endif
endfunction

function! s:InspectorFetchAllCB(acc, conn, result)
    if type(a:result[0]) != type(v:null)
        let a:acc['CONTENT'][0] += a:result[0]
    endif
    if a:result[1] > a:result[3]
        let range_size = a:result[3] - a:result[2]
        call a:conn.InspectorRange(a:result[3], a:result[3] + range_size,
                    \ function('s:InspectorFetchAllCB', [a:acc]))
    else
        let a:acc['CONTENT'][1] = len(a:acc['CONTENT'][0])
        let a:acc['CONTENT'][3] = a:acc['CONTENT'][1]
        let full_content = [{'name': 'TITLE', 'package': 'KEYWORD'}, a:acc['TITLE'],
                    \ {'name': 'CONTENT', 'package': 'KEYWORD'}, a:acc['CONTENT']]
        call a:conn.ui.OnInspect(a:conn, full_content, v:null, v:null)
        echom 'Done fetching inspector content.'
    endif
endfunction

function! s:FindSourceCB(edit_cmd, win_to_go, force_open, conn, msg)
    try
        let loc = vlime#ParseSourceLocation(a:msg)
        let valid_loc = vlime#GetValidSourceLocation(loc)
    catch
        let valid_loc = []
    endtry

    if len(valid_loc) > 0 && type(valid_loc[1]) != type(v:null)
        if a:win_to_go > 0
            if win_id2win(a:win_to_go) <= 0
                return
            endif
            call win_gotoid(a:win_to_go)
        endif

        call vlime#ui#ShowSource(a:conn, valid_loc, a:edit_cmd, a:force_open)
    elseif type(a:msg) != type(v:null) && a:msg[0]['name'] == 'ERROR'
        call vlime#ui#ErrMsg(a:msg[1])
    else
        call vlime#ui#ErrMsg('No source available.')
    endif
endfunction

function! s:InitInspectorBuf()
    call vlime#ui#MapBufferKeys('inspector')
endfunction

function! s:GetCurCoord()
    let cur_pos = getcurpos()
    let coord = v:null
    for c in b:vlime_inspector_coords
        if vlime#ui#MatchCoord(c, cur_pos[1], cur_pos[2])
            let coord = c
            break
        endif
    endfor
    return coord
endfunction
