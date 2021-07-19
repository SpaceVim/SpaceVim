let s:indent_level_width = 2

function! vlime#ui#trace_dialog#InitTraceDialogBuf(conn)
    let buf = bufnr(vlime#ui#TraceDialogBufName(a:conn), v:true)
    if !vlime#ui#VlimeBufferInitialized(buf)
        call vlime#ui#SetVlimeBufferOpts(buf, a:conn)
        call setbufvar(buf, '&filetype', 'vlime_trace')
        call vlime#ui#WithBuffer(buf, function('s:InitTraceDialogBuffer'))
    endif
    return buf
endfunction

function! vlime#ui#trace_dialog#FillTraceDialogBuf(spec_list, trace_count)
    setlocal modifiable

    let b:vlime_trace_specs_coords = []
    call s:DrawSpecList(a:spec_list, b:vlime_trace_specs_coords)

    let b:vlime_trace_entries_header_coords = []
    let cached_entries = get(b:, 'vlime_trace_cached_entries', {})
    call s:DrawTraceEntryHeader(
                \ a:trace_count, len(cached_entries),
                \ b:vlime_trace_entries_header_coords)

    setlocal nomodifiable
endfunction

function! vlime#ui#trace_dialog#RefreshSpecs()
    call b:vlime_conn.ReportSpecs(
                \ function('s:ReportSpecsComplete', [bufnr('%')]))
endfunction

" vlime#ui#trace_dialog#Select([action])
function! vlime#ui#trace_dialog#Select(...)
    let action = get(a:000, 0, 'button')

    let coord = s:GetCurCoord()

    if type(coord) == type(v:null)
        return
    endif

    if action == 'button'
        if coord['type'] == 'REFRESH-SPECS'
            call vlime#ui#trace_dialog#RefreshSpecs()
        elseif coord['type'] == 'UNTRACE-ALL-SPECS'
            call b:vlime_conn.DialogUntraceAll(
                        \ function('s:DialogUntraceAllComplete', [bufnr('%')]))
        elseif coord['type'] == 'UNTRACE-SPEC'
            call b:vlime_conn.DialogUntrace([vlime#CL('QUOTE'), coord['id']],
                        \ function('s:DialogUntraceComplete', [bufnr('%')]))
        elseif coord['type'] == 'REFRESH-TRACE-ENTRY-HEADER'
            call b:vlime_conn.ReportTotal(
                        \ function('s:ReportTotalComplete', [bufnr('%')]))
        elseif coord['type'] == 'FETCH-NEXT-TRACE-ENTRIES-BATCH'
            call b:vlime_conn.ReportPartialTree(
                        \ s:GetFetchKey(),
                        \ function('s:ReportPartialTreeComplete', [bufnr('%'), v:false]))
        elseif coord['type'] == 'FETCH-ALL-TRACE-ENTRIES'
            call b:vlime_conn.ReportPartialTree(
                        \ s:GetFetchKey(),
                        \ function('s:ReportPartialTreeComplete', [bufnr('%'), v:true]))
        elseif coord['type'] == 'CLEAR-TRACE-ENTRIES'
            call b:vlime_conn.ClearTraceTree(
                        \ function('s:ClearTraceTreeComplete', [bufnr('%')]))
        endif

    elseif coord['type'] == 'TRACE-ENTRY-ARG' || coord['type'] == 'TRACE-ENTRY-RETVAL'
        if action == 'inspect'
            let part_type = (coord['type'] == 'TRACE-ENTRY-ARG') ? 'ARG' : 'RETVAL'
            call b:vlime_conn.InspectTracePart(
                        \ coord['id'][0], coord['id'][1], part_type,
                        \ {c, r -> c.ui.OnInspect(c, r, v:null, v:null)})
        elseif action == 'to_repl'
            let part_type = (coord['type'] == 'TRACE-ENTRY-ARG') ? ':arg' : ':retval'
            call b:vlime_conn.ui.OnWriteString(b:vlime_conn,
                        \ "--\n", {'name': 'REPL-SEP', 'package': 'KEYWORD'})
            let args_str = join([coord['id'][0], coord['id'][1], part_type])
            call b:vlime_conn.WithThread({'name': 'REPL-THREAD', 'package': 'KEYWORD'},
                        \ function(b:vlime_conn.ListenerEval,
                            \ ['(nth-value 0 (swank-trace-dialog:find-trace-part ' . args_str . '))']))
        endif
    endif
endfunction

function! vlime#ui#trace_dialog#NextField(forward)
    let coord_groups = [
                \ [get(b:, 'vlime_trace_specs_line_range', v:null),
                    \ sort(copy(get(b:, 'vlime_trace_specs_coords', [])),
                        \ function('vlime#ui#CoordSorter', [a:forward]))],
                \ [get(b:, 'vlime_trace_entries_header_line_range', v:null),
                    \ sort(copy(get(b:, 'vlime_trace_entries_header_coords', [])),
                        \ function('vlime#ui#CoordSorter', [a:forward]))],
                \ [get(b:, 'vlime_trace_entries_line_range', v:null),
                    \ sort(copy(get(b:, 'vlime_trace_entries_coords', [])),
                        \ function('vlime#ui#CoordSorter', [a:forward]))]]

    if !a:forward
        let coord_groups = reverse(coord_groups)
    endif

    let cur_pos = getcurpos()
    let next_coord = v:null
    let next_line_range = v:null
    for [line_range, sorted_coords] in coord_groups
        if type(line_range) == type(v:null)
            continue
        endif

        let shifted_line = cur_pos[1] - line_range[0] + 1
        let next_coord = vlime#ui#FindNextCoord(
                    \ [shifted_line, cur_pos[2]], sorted_coords, a:forward)
        if type(next_coord) != type(v:null)
            let next_line_range = line_range
            break
        endif
    endfor

    if type(next_coord) == type(v:null)
        let non_empty_groups = filter(copy(coord_groups),
                    \ {idx, val -> len(val[1]) > 0})
        let next_coord = non_empty_groups[0][1][0]
        let next_line_range = non_empty_groups[0][0]
    endif

    let next_line = next_coord['begin'][0] + next_line_range[0] - 1
    let next_col = next_coord['begin'][1]
    call setpos('.', [0, next_line, next_col, 0, next_col])
endfunction

let s:trace_entry_fold_pattern = '^\(\s*\d*[[:space:]|]\+\)\(\(`-\)\|\( >\)\|\( <\)\)'

" vlime#ui#trace_dialog#CalcFoldLevel([line_nr])
function! vlime#ui#trace_dialog#CalcFoldLevel(...)
    let line_nr = get(a:000, 0, v:lnum)

    let line = getline(line_nr)
    let matched = matchlist(line, s:trace_entry_fold_pattern)
    if len(matched) > 0
        let id_width = exists('b:vlime_trace_max_id') ?
                    \ len(string(b:vlime_trace_max_id)) : 0
        return (len(matched[1]) - id_width) / 2
    else
        return 0
    endif
endfunction

" vlime#ui#trace_dialog#BuildFoldText([fold_start])
function! vlime#ui#trace_dialog#BuildFoldText(...)
    let fold_start = get(a:000, 0, v:foldstart)

    let s_line = getline(fold_start)
    let matched = matchlist(s_line, s:trace_entry_fold_pattern)
    if len(matched) > 0
        return matched[1] . ' '
    else
        return '...'
    endif
endfunction

function! s:InitTraceDialogBuffer()
    execute 'setlocal shiftwidth=' . s:indent_level_width
    setlocal foldtext=vlime#ui#trace_dialog#BuildFoldText(v:foldstart)
    setlocal foldexpr=vlime#ui#trace_dialog#CalcFoldLevel(v:lnum)
    setlocal foldmethod=expr
    call vlime#ui#MapBufferKeys('trace')
endfunction

function! s:DrawSpecList(spec_list, coords)
    let line_range = get(b:, 'vlime_trace_specs_line_range', v:null)
    if type(line_range) == type(v:null)
        let first_line = 1
        let last_line = line('$')
    else
        let [first_line, last_line] = line_range
    endif

    let spec_list = (type(a:spec_list) == type(v:null)) ? [] : a:spec_list
    let title = 'Traced (' . len(spec_list) . ')'
    let content = title . "\n" . repeat('=', len(title)) . "\n\n"
    let cur_line = 4

    let header_buttons = s:AddButton(
                \ '', '[refresh]', 'REFRESH-SPECS', v:null, cur_line, a:coords)
    let header_buttons .= ' '
    let header_buttons = s:AddButton(
                \ header_buttons, '[untrace all]',
                \ 'UNTRACE-ALL-SPECS', v:null, cur_line, a:coords)

    let content .= (header_buttons . "\n\n")
    let cur_line += 2

    let untrace_button = '[untrace]'
    for spec in spec_list
        let untrace_button = s:AddButton(
                    \ '', '[untrace]', 'UNTRACE-SPEC', spec, cur_line, a:coords)
        let content .= (untrace_button . ' ' . s:NameObjToStr(spec) . "\n")
        let cur_line += 1
    endfor

    let content .= "\n"

    let old_cur_pos = getcurpos()
    try
        let new_lines_count = vlime#ui#ReplaceContent(content, first_line, last_line)
    finally
        call setpos('.', old_cur_pos)
    endtry

    let b:vlime_trace_specs_line_range = [first_line, first_line + new_lines_count - 1]

    let delta = s:CalcLineRangeShift(b:vlime_trace_specs_line_range, line_range)
    let b:vlime_trace_entries_header_line_range =
                \ s:ShiftLineRange(
                    \ get(b:, 'vlime_trace_entries_header_line_range', v:null),
                    \ delta)
    let b:vlime_trace_entries_line_range =
                \ s:ShiftLineRange(
                    \ get(b:, 'vlime_trace_entries_line_range', v:null),
                    \ delta)
endfunction

function! s:DrawTraceEntryHeader(entry_count, cached_entry_count, coords)
    let line_range = get(b:, 'vlime_trace_entries_header_line_range', v:null)
    if type(line_range) == type(v:null)
        let first_line = line('$')
        let last_line = line('$')
    else
        let [first_line, last_line] = line_range
    endif

    let title = 'Trace Entries (' . a:cached_entry_count . '/' . a:entry_count . ')'
    let content = title . "\n" . repeat('=', len(title)) . "\n\n"
    let cur_line = 4

    let header_buttons = s:AddButton(
                \ '', '[refresh]',
                \ 'REFRESH-TRACE-ENTRY-HEADER', v:null, cur_line, a:coords)
    let header_buttons .= ' '

    if a:cached_entry_count != a:entry_count
        let header_buttons = s:AddButton(
                    \ header_buttons, '[fetch next batch]',
                    \ 'FETCH-NEXT-TRACE-ENTRIES-BATCH', v:null, cur_line, a:coords)
        let header_buttons .= ' '
        let header_buttons = s:AddButton(
                    \ header_buttons, '[fetch all]',
                    \ 'FETCH-ALL-TRACE-ENTRIES', v:null, cur_line, a:coords)
        let header_buttons .= ' '
    endif

    let header_buttons = s:AddButton(
                \ header_buttons, '[clear]',
                \ 'CLEAR-TRACE-ENTRIES', v:null, cur_line, a:coords)
    let content .= (header_buttons . "\n\n")

    let old_cur_pos = getcurpos()
    try
        let new_lines_count = vlime#ui#ReplaceContent(content, first_line, last_line)
    finally
        call setpos('.', old_cur_pos)
    endtry

    if type(line_range) == type(v:null)
        let b:vlime_trace_entries_header_line_range =
                    \ [first_line, first_line + new_lines_count - 2]
    else
        let b:vlime_trace_entries_header_line_range =
                    \ [first_line, first_line + new_lines_count - 1]
    endif
endfunction

" s:DrawTraceEntries(
"     toplevel, cached_entries,
"     coords[, cur_level[, acc_content[, cur_line[, line_prefix[, id_width]]]])
"
" This is a recursive function, with "isomeric" return values. The toplevel
" call returns nothing meaningful, but the nested calls return the constructed
" text content.
function! s:DrawTraceEntries(toplevel, cached_entries, coords, ...)
    let cur_level = get(a:000, 0, 0)
    let acc_content = get(a:000, 1, '')
    let cur_line = get(a:000, 2, 1)
    let line_prefix = get(a:000, 3, '')
    let id_width = get(a:000, 4, v:null)

    if type(id_width) == type(v:null)
        let sorted_keys = sort(keys(a:cached_entries), 'N')
        if len(sorted_keys) > 0
            let id_width = len(sorted_keys[-1])
        else
            let id_width = 0
        endif
    endif

    let extra_prefix = repeat(' ', s:indent_level_width - 1) . '|'
    let next_line_prefix = line_prefix . extra_prefix

    let line_range = get(b:, 'vlime_trace_entries_line_range', v:null)
    if type(line_range) == type(v:null)
        let first_line = line('$')
        let last_line = line('$')
    else
        let [first_line, last_line] = line_range
    endif

    let content = ''
    for tid in a:toplevel
        let entry = a:cached_entries[tid]

        if tid == a:toplevel[-1] && len(line_prefix) > 0
            let line_prefix = line_prefix[:-2] . ' '
            let next_line_prefix = line_prefix . extra_prefix
        endif

        let connector_char = (acc_content == '') ? ' ' : '`'
        let str_id = string(entry['id'])
        let name_line = s:AlignTraceID(entry['id'], id_width) . line_prefix .
                    \ connector_char . repeat('-', s:indent_level_width - 1) . ' ' .
                    \ s:NameObjToStr(entry['name']) . "\n"
        let content .= name_line
        let cur_line += 1

        if len(entry['children']) > 0
            let arg_ret_prefix = repeat(' ', id_width) . next_line_prefix
        else
            let arg_ret_prefix = repeat(' ', id_width) . next_line_prefix[:-2] . ' '
        endif

        let [arg_content, cur_line] = s:ConstructTraceEntryArgs(
                    \ entry['id'], entry['args'], arg_ret_prefix . ' > ',
                    \ 'TRACE-ENTRY-ARG', cur_line, a:coords)
        let content .= arg_content

        let [ret_content, cur_line] = s:ConstructTraceEntryArgs(
                    \ entry['id'], entry['retvals'], arg_ret_prefix . ' < ',
                    \ 'TRACE-ENTRY-RETVAL', cur_line, a:coords)
        let content .= ret_content

        if len(entry['children']) > 0
            let [content, cur_line] = s:DrawTraceEntries(
                        \ entry['children'], a:cached_entries,
                        \ a:coords, cur_level + 1, content,
                        \ cur_line, next_line_prefix, id_width)
        endif
    endfor

    if acc_content == ''
        let old_cur_pos = getcurpos()
        try
            let new_lines_count = vlime#ui#ReplaceContent(content, first_line, last_line)
        finally
            call setpos('.', old_cur_pos)
        endtry
        let b:vlime_trace_entries_line_range =
                    \ [first_line, first_line + new_lines_count - 1]
    else
        return [acc_content . content, cur_line]
    endif
endfunction

function! s:AddButton(buttons_str, name, co_type, co_id, cur_line, coords)
    let button_begin = [a:cur_line, len(a:buttons_str) + 1]
    let buttons_str = a:buttons_str . a:name
    let button_end = [a:cur_line, len(buttons_str)]
    call add(a:coords, {
                \ 'begin': button_begin,
                \ 'end': button_end,
                \ 'type': a:co_type,
                \ 'id': a:co_id
                \})
    return buttons_str
endfunction

function! s:CalcLineRangeShift(new, old)
    if type(a:old) == type(v:null)
        return 0
    endif
    return a:new[1] - a:old[1]
endfunction

function! s:ShiftLineRange(line_range, delta)
    if type(a:line_range) == type(v:null)
        return a:line_range
    endif
    return [a:line_range[0] + a:delta, a:line_range[1] + a:delta]
endfunction

function! s:GetCurCoord()
    let cur_pos = getcurpos()

    if cur_pos[1] >= b:vlime_trace_specs_line_range[0] &&
                \ cur_pos[1] <= b:vlime_trace_specs_line_range[1]
        let line_delta = b:vlime_trace_specs_line_range[0] - 1
        let shifted_line = cur_pos[1] - line_delta
        for c in b:vlime_trace_specs_coords
            if vlime#ui#MatchCoord(c, shifted_line, cur_pos[2])
                return c
            endif
        endfor
    elseif cur_pos[1] >= b:vlime_trace_entries_header_line_range[0] &&
                \ cur_pos[1] <= b:vlime_trace_entries_header_line_range[1]
        let line_delta = b:vlime_trace_entries_header_line_range[0] - 1
        let shifted_line = cur_pos[1] - line_delta
        for c in b:vlime_trace_entries_header_coords
            if vlime#ui#MatchCoord(c, shifted_line, cur_pos[2])
                return c
            endif
        endfor
    elseif exists('b:vlime_trace_entries_line_range') &&
                \ cur_pos[1] >= b:vlime_trace_entries_line_range[0] &&
                \ cur_pos[1] <= b:vlime_trace_entries_line_range[1]
        let line_delta = b:vlime_trace_entries_line_range[0] - 1
        let shifted_line = cur_pos[1] - line_delta
        for c in b:vlime_trace_entries_coords
            if vlime#ui#MatchCoord(c, shifted_line, cur_pos[2])
                return c
            endif
        endfor
    endif

    return v:null
endfunction

function! s:ReportSpecsComplete(trace_buf, conn, result)
    let coords = []
    call setbufvar(a:trace_buf, '&modifiable', 1)
    call vlime#ui#WithBuffer(a:trace_buf,
                \ function('s:DrawSpecList', [a:result, coords]))
    call setbufvar(a:trace_buf, '&modifiable', 0)
    call setbufvar(a:trace_buf, 'vlime_trace_specs_coords', coords)
endfunction

function! s:ReportTotalComplete(trace_buf, conn, result)
    let cached_entries =
                \ getbufvar(a:trace_buf, 'vlime_trace_cached_entries', {})

    let coords = []
    call setbufvar(a:trace_buf, '&modifiable', 1)
    call vlime#ui#WithBuffer(a:trace_buf,
                \ function('s:DrawTraceEntryHeader',
                    \ [a:result, len(cached_entries), coords]))
    call setbufvar(a:trace_buf, '&modifiable', 0)
    call setbufvar(a:trace_buf, 'vlime_trace_entries_header_coords', coords)
endfunction

function! s:DialogUntraceAllComplete(trace_buf, conn, result)
    if type(a:result) != type(v:null)
        for r in a:result
            echom r
        endfor
    endif

    call b:vlime_conn.ReportSpecs(
                \ function('s:ReportSpecsComplete', [a:trace_buf]))
endfunction

function! s:DialogUntraceComplete(trace_buf, conn, result)
    echom a:result
    call b:vlime_conn.ReportSpecs(
                \ function('s:ReportSpecsComplete', [a:trace_buf]))
endfunction

function! s:ReportPartialTreeComplete(trace_buf, fetch_all, conn, result)
    let [entry_list, remaining, fetch_key] = a:result
    let entry_list = (type(entry_list) == type(v:null)) ? [] : entry_list

    let cached_entries =
                \ getbufvar(a:trace_buf, 'vlime_trace_cached_entries', {})
    let toplevel_entries =
                \ getbufvar(a:trace_buf, 'vlime_trace_toplevel_entries', [])
    let max_id = getbufvar(a:trace_buf, 'vlime_trace_max_id', 0)

    for t_entry in entry_list
        let [id, parent, name, arg_list, retval_list] = t_entry
        let entry_obj = get(cached_entries, id, {'id': id, 'children': []})
        let entry_obj['parent'] = parent
        let entry_obj['name'] = name
        let entry_obj['args'] = s:ArgListToDict(arg_list)
        let entry_obj['retvals'] = s:ArgListToDict(retval_list)
        let parent_obj = (type(parent) == type(v:null)) ?
                    \ v:null : get(cached_entries, parent, v:null)
        if type(parent_obj) == type(v:null)
            if index(toplevel_entries, id) < 0
                call add(toplevel_entries, id)
            endif
        else
            if index(parent_obj['children'], id) < 0
                call add(parent_obj['children'], id)
            endif
        endif
        let cached_entries[id] = entry_obj

        if id > max_id
            let max_id = id
        endif
    endfor

    call setbufvar(a:trace_buf, 'vlime_trace_cached_entries', cached_entries)
    call setbufvar(a:trace_buf, 'vlime_trace_toplevel_entries', toplevel_entries)
    call setbufvar(a:trace_buf, 'vlime_trace_max_id', max_id)

    if a:fetch_all && remaining > 0
        call a:conn.ReportPartialTree(
                    \ fetch_key,
                    \ function('s:ReportPartialTreeComplete', [a:trace_buf, a:fetch_all]))
    else
        let coords = []
        call setbufvar(a:trace_buf, '&modifiable', 1)
        call vlime#ui#WithBuffer(a:trace_buf,
                    \ function('s:DrawTraceEntryHeader',
                        \ [len(cached_entries) + remaining,
                            \ len(cached_entries),
                            \ coords]))
        call setbufvar(a:trace_buf, 'vlime_trace_entries_header_coords', coords)

        let coords = []
        call vlime#ui#WithBuffer(a:trace_buf,
                    \ function('s:DrawTraceEntries',
                        \ [toplevel_entries, cached_entries, coords]))
        call setbufvar(a:trace_buf, '&modifiable', 0)
        call setbufvar(a:trace_buf, 'vlime_trace_entries_coords', coords)
    endif
endfunction

function! s:ClearTraceTreeComplete(trace_buf, conn, result)
    call vlime#ui#WithBuffer(a:trace_buf, function('s:ResetTraceEntries'))
    call b:vlime_conn.ReportTotal(
                \ function('s:ReportTotalComplete', [a:trace_buf]))
endfunction

function! s:ResetTraceEntries()
    silent! unlet b:vlime_trace_fetch_key
    silent! unlet b:vlime_trace_cached_entries
    silent! unlet b:vlime_trace_toplevel_entries
    silent! unlet b:vlime_trace_max_id
    silent! unlet b:vlime_trace_entries_coords

    let line_range = get(b:, 'vlime_trace_entries_line_range', v:null)
    silent! unlet b:vlime_trace_entries_line_range

    if type(line_range) != type(v:null)
        let [first_line, last_line] = line_range
        setlocal modifiable
        execute first_line . ',' . last_line . 'delete _'
        call append(first_line - 1, '')
        setlocal nomodifiable
    endif
endfunction

function! s:GetFetchKey()
    if !exists('b:vlime_trace_fetch_key')
        let fetch_key = get(s:, 'next_fetch_key', 0)
        let s:next_fetch_key = fetch_key + 1
        if s:next_fetch_key > 65535
            let s:next_fetch_key = 0
        endif
        let b:vlime_trace_fetch_key = getpid() . '_' . fetch_key
    endif
    return b:vlime_trace_fetch_key
endfunction

function! s:ArgListToDict(arg_list)
    let arg_list = (type(a:arg_list) == type(v:null)) ? [] : a:arg_list
    let args = {}
    for r in arg_list
        let args[r[0]] = r[1]
    endfor
    return args
endfunction

function! s:Indent(str, count)
    return repeat(' ', a:count) . a:str
endfunction

function! s:NameObjToStr(name)
    if type(a:name) == v:t_dict
        return a:name['package'] . '::' . a:name['name']
    elseif type(a:name) == v:t_list
        let name_type = a:name[0]
        if name_type['package'] == 'KEYWORD'
            let name_type = ':' . name_type['name']
        elseif name_type['package'] == 'COMMON-LISP'
            let name_type = name_type['name']
        else
            let name_type = name_type['package'] . '::' . name_type['name']
        endif

        let name_list = [name_type]
        for rest_name in a:name[1:]
            call add(name_list, s:NameObjToStr(rest_name))
        endfor
        return '(' . join(name_list) . ')'
    else
        throw 'NameObjToStr: illegal name: ' . string(name)
    endif
endfunction

function! s:ConstructTraceEntryArgs(
            \ entry_id, arg_dict, prefix, button_type, cur_line, coords)
    let content = ''
    let cur_line = a:cur_line
    for i in sort(keys(a:arg_dict), 'N')
        let line = a:prefix
        let line = s:AddButton(
                    \ line, a:arg_dict[i],
                    \ a:button_type, [a:entry_id, str2nr(i)],
                    \ cur_line, a:coords)
        let line .= "\n"
        let content .= line
        let cur_line += 1
    endfor
    return [content, cur_line]
endfunction

function! s:AlignTraceID(id, width)
    let str_id = string(a:id)
    return repeat(' ', a:width - len(str_id)) . str_id
endfunction
