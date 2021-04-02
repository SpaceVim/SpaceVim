function! vlime#ui#compiler_notes#InitCompilerNotesBuffer(conn, orig_win)
    let buf = bufnr(vlime#ui#CompilerNotesBufName(a:conn), v:true)
    if !vlime#ui#VlimeBufferInitialized(buf)
        call vlime#ui#SetVlimeBufferOpts(buf, a:conn)
        call setbufvar(buf, '&filetype', 'vlime_notes')
        call vlime#ui#WithBuffer(buf, function('s:InitCompilerNotesBuffer'))
    endif
    call setbufvar(buf, 'vlime_notes_orig_win', a:orig_win)
    return buf
endfunction

function! vlime#ui#compiler_notes#FillCompilerNotesBuf(note_list)
    setlocal modifiable

    if type(a:note_list) == type(v:null)
        call vlime#ui#ReplaceContent('No message from the compiler.')
        let b:vlime_compiler_note_coords = []
        let b:vlime_compiler_note_list = []
        return
    endif

    let coords = []
    let nlist = []
    1,$delete _
    let idx = 0
    let note_count = len(a:note_list)
    for note in a:note_list
        let note_dict = vlime#PListToDict(note)
        call add(nlist, note_dict)

        let begin_pos = getcurpos()
        call vlime#ui#AppendString(note_dict['SEVERITY']['name'] . ': ' . note_dict['MESSAGE'])
        let eof_coord = vlime#ui#GetEndOfFileCoord()
        if idx < note_count - 1
            call vlime#ui#AppendString("\n--\n")
        endif
        call add(coords, {
                    \ 'begin': [begin_pos[1], begin_pos[2]],
                    \ 'end': eof_coord,
                    \ 'type': 'NOTE',
                    \ 'id': idx,
                    \ })
        let idx += 1
    endfor
    call setpos('.', [0, 1, 1, 0, 1])

    setlocal nomodifiable

    let b:vlime_compiler_note_coords = coords
    let b:vlime_compiler_note_list = nlist
endfunction

" vlime#ui#compiler_notes#OpenCurNote([edit_cmd])
function! vlime#ui#compiler_notes#OpenCurNote(...)
    let edit_cmd = get(a:000, 0, 'hide edit')

    let cur_pos = getcurpos()
    let note_coord = v:null
    for c in b:vlime_compiler_note_coords
        if vlime#ui#MatchCoord(c, cur_pos[1], cur_pos[2])
            let note_coord = c
            break
        endif
    endfor

    if type(note_coord) == type(v:null)
        return
    endif

    let raw_note_loc = b:vlime_compiler_note_list[note_coord['id']]['LOCATION']
    try
        let note_loc = vlime#ParseSourceLocation(raw_note_loc)
        let valid_loc = vlime#GetValidSourceLocation(note_loc)
    catch
        let valid_loc = []
    endtry

    if len(valid_loc) > 0 && type(valid_loc[1]) != type(v:null)
        let orig_win = getbufvar('%', 'vlime_notes_orig_win', v:null)
        let [win_to_go, count_specified] = vlime#ui#ChooseWindowWithCount(orig_win)
        if win_to_go > 0
            call win_gotoid(win_to_go)
        elseif count_specified
            return
        endif
        call vlime#ui#ShowSource(b:vlime_conn, valid_loc, edit_cmd, count_specified)
    elseif type(raw_note_loc) != type(v:null) && raw_note_loc[0]['name'] == 'ERROR'
        call vlime#ui#ErrMsg(raw_note_loc[1])
    else
        call vlime#ui#ErrMsg('No source available.')
    endif
endfunction

function! s:FindNoteLocationProp(key, loc)
    if type(a:loc) != type(v:null)
        for p in a:loc[1:]
            if type(p) == v:t_list && p[0]['name'] == a:key
                return p[1:]
            endif
        endfor
    endif
    return v:null
endfunction

function! s:InitCompilerNotesBuffer()
    call vlime#ui#MapBufferKeys('notes')
endfunction
