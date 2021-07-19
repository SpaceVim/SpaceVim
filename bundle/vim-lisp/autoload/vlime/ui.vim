let g:vlime_default_window_settings = {
            \ 'sldb': {'pos': 'botright', 'size': v:null, 'vertical': v:false},
            \ 'repl': {'pos': 'botright', 'size': v:null, 'vertical': v:false},
            \ 'mrepl': {'pos': 'botright', 'size': v:null, 'vertical': v:false},
            \ 'inspector': {'pos': 'botright', 'size': v:null, 'vertical': v:false},
            \ 'trace': {'pos': 'botright', 'size': v:null, 'vertical': v:false},
            \ 'xref': {'pos': 'botright', 'size': 12, 'vertical': v:false},
            \ 'notes': {'pos': 'botright', 'size': 12, 'vertical': v:false},
            \ 'threads': {'pos': 'botright', 'size': 12, 'vertical': v:false},
            \ 'preview': {'pos': 'aboveleft', 'size': 12, 'vertical': v:false},
            \ 'arglist': {'pos': 'topleft', 'size': 2, 'vertical': v:false},
            \ 'input': {'pos': 'botright', 'size': 4, 'vertical': v:false},
            \ 'server': {'pos': 'botright', 'size': v:null, 'vertical': v:false},
            \ }

""
" @dict VlimeUI
" The @dict(VlimeUI) object is a singleton. It's meant to be injected into
" @dict(VlimeConnection) objects, to grant them access to the user interface.
" See @function(vlime#New).
"

""
" @public
"
" Create a @dict(VlimeUI) object. One should probably use
" @function(vlime#ui#GetUI) instead.
function! vlime#ui#New()
    let obj = {
                \ 'buffer_package_map': {},
                \ 'buffer_thread_map': {},
                \ 'GetCurrentPackage': function('vlime#ui#GetCurrentPackage'),
                \ 'SetCurrentPackage': function('vlime#ui#SetCurrentPackage'),
                \ 'GetCurrentThread': function('vlime#ui#GetCurrentThread'),
                \ 'SetCurrentThread': function('vlime#ui#SetCurrentThread'),
                \ 'OnDebug': function('vlime#ui#OnDebug'),
                \ 'OnDebugActivate': function('vlime#ui#OnDebugActivate'),
                \ 'OnDebugReturn': function('vlime#ui#OnDebugReturn'),
                \ 'OnWriteString': function('vlime#ui#OnWriteString'),
                \ 'OnReadString': function('vlime#ui#OnReadString'),
                \ 'OnReadFromMiniBuffer': function('vlime#ui#OnReadFromMiniBuffer'),
                \ 'OnIndentationUpdate': function('vlime#ui#OnIndentationUpdate'),
                \ 'OnNewFeatures': function('vlime#ui#OnNewFeatures'),
                \ 'OnInvalidRPC': function('vlime#ui#OnInvalidRPC'),
                \ 'OnInspect': function('vlime#ui#OnInspect'),
                \ 'OnTraceDialog': function('vlime#ui#OnTraceDialog'),
                \ 'OnXRef': function('vlime#ui#OnXRef'),
                \ 'OnCompilerNotes': function('vlime#ui#OnCompilerNotes'),
                \ 'OnThreads': function('vlime#ui#OnThreads'),
                \ }
    return obj
endfunction

""
" @public
"
" Return the UI singleton.
function! vlime#ui#GetUI()
    if !exists('g:vlime_ui')
        let g:vlime_ui = vlime#ui#New()
    endif
    return g:vlime_ui
endfunction

""
" @dict VlimeUI.GetCurrentPackage
" @usage [buffer]
" @public
"
" Return the Common Lisp package bound to the specified [buffer]. If no
" package is bound yet, try to guess one by looking into the buffer content.
" [buffer], if specified, should be an expression as described in |bufname()|.
" When [buffer] is omitted, work on the current buffer.
"
" The returned value is a list of two strings. The first string is the full
" name of the package, and the second string is one of the package's
" nicknames.
function! vlime#ui#GetCurrentPackage(...) dict
    let buf_spec = get(a:000, 0, '%')
    let cur_buf = bufnr(buf_spec)
    let buf_pkg = get(self.buffer_package_map, cur_buf, v:null)
    if type(buf_pkg) != v:t_list
        let in_pkg = vlime#ui#WithBuffer(cur_buf, function('vlime#ui#CurInPackage'))
        if len(in_pkg) > 0
            let buf_pkg = [in_pkg, in_pkg]
        else
            let buf_pkg = ['COMMON-LISP-USER', 'CL-USER']
        endif
    endif
    return buf_pkg
endfunction

""
" @dict VlimeUI.SetCurrentPackage
" @usage {pkg} [buffer]
" @public
"
" Bind a Common Lisp package {pkg} to the specified [buffer].
" {pkg} should be a list of two strings, i.e. in the same format as the return
" value of @function(VlimeUI.GetCurrentPackage).
" See @function(VlimeUI.GetCurrentPackage) for the use of [buffer].
"
" Note that this method doesn't check the validity of {pkg}.
function! vlime#ui#SetCurrentPackage(pkg, ...) dict
    let buf_spec = get(a:000, 0, '%')
    let cur_buf = bufnr(buf_spec)
    let self.buffer_package_map[cur_buf] = a:pkg
endfunction

""
" @dict VlimeUI.GetCurrentThread
" @usage [buffer]
" @public
"
" Return the thread bound to [buffer]. See @function(VlimeUI.GetCurrentPackage)
" for the use of [buffer].
"
" Currently, this method only makes sense in the debugger buffer.
function! vlime#ui#GetCurrentThread(...) dict
    let buf_spec = get(a:000, 0, '%')
    let cur_buf = bufnr(buf_spec)
    return get(self.buffer_thread_map, cur_buf, v:true)
endfunction

""
" @dict VlimeUI.SetCurrentThread
" @usage {thread} [buffer]
" @public
"
" Bind a thread to [buffer]. See @function(VlimeUI.GetCurrentPackage) for the
" use of [buffer].
function! vlime#ui#SetCurrentThread(thread, ...) dict
    let buf_spec = get(a:000, 0, '%')
    let cur_buf = bufnr(buf_spec)
    let self.buffer_thread_map[cur_buf] = a:thread
endfunction

function! vlime#ui#OnDebug(conn, thread, level, condition, restarts, frames, conts) dict
    let dbg_buf = vlime#ui#sldb#InitSLDBBuf(self, a:conn, a:thread, a:level, a:frames)
    call vlime#ui#WithBuffer(
                \ dbg_buf,
                \ function('vlime#ui#sldb#FillSLDBBuf',
                    \ [a:thread, a:level, a:condition, a:restarts, a:frames]))
endfunction

function! vlime#ui#OnDebugActivate(conn, thread, level, select) dict
    let dbg_buf = vlime#ui#OpenBufferWithWinSettings(
                \ vlime#ui#SLDBBufName(a:conn, a:thread), v:false, 'sldb')
    if dbg_buf > 0
        call setpos('.', [0, 1, 1, 0, 1])
    endif
endfunction

function! vlime#ui#OnDebugReturn(conn, thread, level, stepping) dict
    let buf_name = vlime#ui#SLDBBufName(a:conn, a:thread)
    let bufnr = bufnr(buf_name)
    if bufnr > 0
        let buf_level = getbufvar(bufnr, 'vlime_sldb_level', -1)
        if buf_level == a:level
            call setbufvar(bufnr, '&buflisted', 0)
            " Clear the content instead of unloading the buffer, to preserve the
            " syntax highlighting settings and everything set by FileType
            " autocmds.
            call setbufvar(bufnr, '&modifiable', 1)
            call vlime#ui#WithBuffer(bufnr, {-> vlime#ui#ReplaceContent('')})
            call setbufvar(bufnr, '&modifiable', 0)
            call vlime#ui#CloseBuffer(bufnr)
        endif
    endif
endfunction

""
" @public
"
" Write an arbitrary string {str} to the REPL buffer.
" {conn} should be a valid @dict(VlimeConnection). {str_type} is currently
" ignored.
function! vlime#ui#OnWriteString(conn, str, str_type) dict
    let repl_buf = vlime#ui#repl#InitREPLBuf(a:conn)
    if len(win_findbuf(repl_buf)) <= 0
        call vlime#ui#KeepCurWindow(
                    \ function('vlime#ui#OpenBufferWithWinSettings',
                        \ [repl_buf, v:false, 'repl']))
    endif
    call vlime#ui#repl#AppendOutput(repl_buf, a:str)
endfunction

function! vlime#ui#OnReadString(conn, thread, ttag) dict
    call vlime#ui#input#FromBuffer(
                \ a:conn, 'Input string:', v:null,
                \ function('s:ReadStringInputComplete', [a:thread, a:ttag]))
endfunction

function! vlime#ui#OnReadFromMiniBuffer(conn, thread, ttag, prompt, init_val) dict
    call vlime#ui#input#FromBuffer(
                \ a:conn, a:prompt, a:init_val,
                \ function('s:ReturnMiniBufferContent', [a:thread, a:ttag]))
endfunction

function! vlime#ui#OnIndentationUpdate(conn, indent_info) dict
    if !has_key(a:conn.cb_data, 'indent_info')
        let a:conn.cb_data['indent_info'] = {}
    endif
    for i in a:indent_info
        let a:conn.cb_data['indent_info'][i[0]] = [i[1], i[2]]
    endfor
endfunction

function! vlime#ui#OnNewFeatures(conn, new_features)
    let new_features = (type(a:new_features) == type(v:null)) ? [] : a:new_features
    let a:conn.cb_data['features'] = new_features
endfunction

function! vlime#ui#OnInvalidRPC(conn, rpc_id, err_msg) dict
    call vlime#ui#ErrMsg(a:err_msg)
endfunction

function! vlime#ui#OnInspect(conn, i_content, i_thread, i_tag) dict
    let insp_buf = vlime#ui#inspector#InitInspectorBuf(
                \ a:conn.ui, a:conn, a:i_thread)
    call vlime#ui#OpenBufferWithWinSettings(insp_buf, v:false, 'inspector')

    let r_content = vlime#PListToDict(a:i_content)
    let old_title = getline(1)
    if get(r_content, 'TITLE', v:null) == old_title
        let old_cur = getcurpos()
    else
        let old_cur = [0, 1, 1, 0, 1]
    endif

    call vlime#ui#inspector#FillInspectorBuf(r_content, a:i_thread, a:i_tag)
    call setpos('.', old_cur)
    " Needed for displaying the content of the current buffer correctly
    redraw
endfunction

function! vlime#ui#OnTraceDialog(conn, spec_list, trace_count) dict
    let trace_buf = vlime#ui#trace_dialog#InitTraceDialogBuf(a:conn)
    call vlime#ui#OpenBufferWithWinSettings(trace_buf, v:false, 'trace')
    call vlime#ui#trace_dialog#FillTraceDialogBuf(a:spec_list, a:trace_count)
endfunction

function! vlime#ui#OnXRef(conn, xref_list, orig_win) dict
    if type(a:xref_list) == type(v:null)
        call vlime#ui#ErrMsg('No xref found.')
    elseif type(a:xref_list) == v:t_dict &&
                \ a:xref_list['name'] == 'NOT-IMPLEMENTED'
        call vlime#ui#ErrMsg('Not implemented.')
    else
        let xref_buf = vlime#ui#xref#InitXRefBuf(a:conn, a:orig_win)
        call vlime#ui#OpenBufferWithWinSettings(xref_buf, v:false, 'xref')
        call vlime#ui#xref#FillXRefBuf(a:xref_list)
    endif
endfunction

function! vlime#ui#OnCompilerNotes(conn, note_list, orig_win) dict
    let notes_buf = vlime#ui#compiler_notes#InitCompilerNotesBuffer(a:conn, a:orig_win)
    let buf_opened = len(win_findbuf(notes_buf)) > 0
    if buf_opened || type(a:note_list) != type(v:null)
        let old_win_id = win_getid()
        call vlime#ui#OpenBufferWithWinSettings(notes_buf, v:false, 'notes')
        call vlime#ui#compiler_notes#FillCompilerNotesBuf(a:note_list)
        if type(a:note_list) == type(v:null)
            " There's no message. Don't stay in the notes window.
            call win_gotoid(old_win_id)
        endif
    endif
endfunction

function! vlime#ui#OnThreads(conn, thread_list) dict
    let threads_buf = vlime#ui#threads#InitThreadsBuffer(a:conn)
    call vlime#ui#OpenBufferWithWinSettings(threads_buf, v:false, 'threads')
    call vlime#ui#threads#FillThreadsBuf(a:thread_list)
endfunction

function! s:ReturnMiniBufferContent(thread, ttag)
    let content = vlime#ui#CurBufferContent()
    call b:vlime_conn.Return(a:thread, a:ttag, content)
endfunction

""
" @public
"
" Return the current character under the cursor. If there's no character, an
" empty string is returned.
function! vlime#ui#CurChar()
    return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

""
" @public
"
" If there is a parentheses-enclosed expression under the cursor, return it.
" Otherwise look for an atom under the cursor. Return an empty string if
" nothing is found.
function! vlime#ui#CurExprOrAtom()
    let str = vlime#ui#CurExpr()
    if len(str) <= 0
        let str = vlime#ui#CurAtom()
    endif
    return str
endfunction

""
" @public
"
" Return the atom under the cursor, or an empty string if there is no atom.
function! vlime#ui#CurAtom()
    let old_kw = &iskeyword
    try
        setlocal iskeyword+=+,-,*,/,%,<,=,>,:,$,?,!,@-@,94,~,#,\|,&,.,{,},[,]
        return expand('<cword>')
    finally
        let &l:iskeyword = old_kw
    endtry
endfunction

""
" @usage [return_pos]
" @public
"
" Return the parentheses-enclosed expression under the cursor, or an empty
" string, when there is no expression.
" If [return_pos] is specified and |TRUE|, return a list containing the
" expression, as well as the beginning and ending positions.
function! vlime#ui#CurExpr(...)
    let return_pos = get(a:000, 0, v:false)

    let cur_char = vlime#ui#CurChar()
    let from_pos = vlime#ui#CurExprPos(cur_char, 'begin')
    let to_pos = vlime#ui#CurExprPos(cur_char, 'end')
    let expr = vlime#ui#GetText(from_pos, to_pos)
    return return_pos ? [expr, from_pos, to_pos] : expr
endfunction

let s:cur_expr_pos_search_flags = {
            \ 'begin': ['cbnW', 'bnW', 'bnW'],
            \ 'end':   ['nW', 'cnW', 'nW'],
            \ }

""
" @usage {cur_char} [side]
" @public
"
" Return the beginning or ending position of the parentheses-enclosed
" expression under the cursor.
" {cur_char} is the character under the cursor, which can be obtained by
" calling @function(vlime#ui#CurChar).
" If [side] is "begin", the beginning position is returned. If [side] is
" "end", the ending position is returned. "begin" is the default when [side]
" is omitted.
function! vlime#ui#CurExprPos(cur_char, ...)
    let side = get(a:000, 0, 'begin')
    if a:cur_char == '('
        return searchpairpos('(', '', ')', s:cur_expr_pos_search_flags[side][0])
    elseif a:cur_char == ')'
        return searchpairpos('(', '', ')', s:cur_expr_pos_search_flags[side][1])
    else
        return searchpairpos('(', '', ')', s:cur_expr_pos_search_flags[side][2])
    endif
endfunction

""
" @usage [return_pos]
" @public
"
" Return the top-level parentheses-enclosed expression. See
" @function(vlime#ui#CurExpr) for the use of [return_pos].
function! vlime#ui#CurTopExpr(...)
    let return_pos = get(a:000, 0, v:false)

    let [s_line, s_col] = vlime#ui#CurTopExprPos('begin')
    if s_line > 0 && s_col > 0
        let old_cur_pos = getcurpos()
        try
            call setpos('.', [0, s_line, s_col, 0])
            return vlime#ui#CurExpr(return_pos)
        finally
            call setpos('.', old_cur_pos)
        endtry
    else
        return return_pos ? ['', [0, 0], [0, 0]] : ''
    endif
endfunction

""
" @usage [side] [max_level] [max_lines]
" @public
"
" Return the beginning or ending position of the top-level
" parentheses-enclosed expression under the cursor. See
" @function(vlime#ui#CurExprPos) for the use of [side].
"
" Stop when [max_level] parentheses are seen, or [max_lines] lines have been
" searched. Pass v:null or ommit these two arguments to impose no limit at
" all.
function! vlime#ui#CurTopExprPos(...)
    let side = get(a:000, 0, 'begin')
    let max_level = get(a:000, 1, v:null)
    let max_lines = get(a:000, 2, v:null)

    if side == 'begin'
        let search_flags = 'bW'
    elseif side == 'end'
        let search_flags = 'W'
    endif

    let last_pos = [0, 0]

    let old_cur_pos = getcurpos()
    let cur_level = 1
    try
        while type(max_level) == type(v:null) || cur_level <= max_level
            let cur_pos = searchpairpos('(', '', ')', search_flags)
            if cur_pos[0] <= 0 || cur_pos[1] <= 0 ||
                        \ (type(max_lines) != type(v:null) && abs(old_cur_pos[1] - cur_pos[0]) > max_lines)
                break
            endif
            if !s:InComment(cur_pos) && !s:InString(cur_pos)
                let last_pos = cur_pos
                let cur_level += 1
            endif
        endwhile
        if last_pos[0] > 0 && last_pos[1] > 0
            return last_pos
        else
            let cur_char = vlime#ui#CurChar()
            if cur_char == '(' || cur_char == ')'
                return searchpairpos('(', '', ')', search_flags . 'c')
            else
                return [0, 0]
            endif
        endif
    finally
        call setpos('.', old_cur_pos)
    endtry
endfunction

""
" @usage [max_level] [max_lines]
" @public
"
" Retrieve the parentheses-enclosed expression under the cursor, and parse it
" into a "raw form" usable by @function(VlimeConnection.Autodoc). See the
" source of SWANK:AUTODOC for an explanation of the raw forms.
"
" The raw-form-parsing operation is quite slow, you can pass [max_level] and
" [max_lines] to impose some limits when searching for expressions. See
" @function(vlime#ui#CurTopExprPos) for the use of these arguments.
function! vlime#ui#CurRawForm(...)
    " Note that there may be an incomplete expression
    let max_level = get(a:000, 0, v:null)
    let max_lines = get(a:000, 1, v:null)

    let s_pos = vlime#ui#CurTopExprPos('begin', max_level, max_lines)
    let [s_line, s_col] = s_pos
    if s_line <= 0 || s_col <= 0
        return []
    endif

    let cur_pos = getcurpos()[1:2]
    let cur_pos[1] -= 1
    let partial_expr = vlime#ui#GetText(s_pos, cur_pos)
    let partial_expr = substitute(partial_expr, '\v(\_s)+$', ' ', '')

    if len(partial_expr) <= 0
        return []
    endif

    return vlime#Memoize({-> vlime#ToRawForm(partial_expr)[0]},
                \ partial_expr, 'raw_form_cache', s:, 1024)
endfunction

""
" @public
"
" Search for an "in-package" expression in the current buffer, and return the
" package name specified in that expression. If no such an expression can be
" found, an empty string is returned.
function! vlime#ui#CurInPackage()
    let pattern = '(\_s*in-package\_s\+\(.\+\)\_s*)'
    let old_cur_pos = getcurpos()
    try
        let package_line = search(pattern, 'bcW')
        if package_line <= 0
            let package_line = search(pattern, 'cW')
        endif
        if package_line > 0
            let matches = matchlist(vlime#ui#CurExpr(), pattern)
            " The pattern used here does not check for lone parentheses,
            " so there may not be a match.
            let package = (len(matches) > 0) ? s:NormalizePackageName(matches[1]) : ''
        else
            let package = ''
        endif
        return package
    finally
        call setpos('.', old_cur_pos)
    endtry
endfunction

""
" @public
"
" Return the operator symbol name of the parentheses-enclosed expression under
" the cursor. If no expression is found, return an empty string.
function! vlime#ui#CurOperator()
    let expr = vlime#ui#CurExpr()
    if len(expr) > 0
        let matches = matchlist(expr, '^(\_s*\(\k\+\)\_s*\_.*)$')
        if len(matches) > 0
            return matches[1]
        endif
    else
        " There may be an incomplete expression
        let [s_line, s_col] = searchpairpos('(', '', ')', 'cbnW')
        if s_line > 0 && s_col > 0
            let op_line = getline(s_line)[(s_col-1):]
            let matches = matchlist(op_line, '^(\s*\(\k\+\)\s*')
            if len(matches) > 0
                return matches[1]
            endif
        endif
    endif
    return ''
endfunction

""
" @public
"
" Similar to @function(vlime#ui#CurOperator), but return the operator of the
" surrounding expression instead, if the cursor is on the left enclosing
" parentheses.
function! vlime#ui#SurroundingOperator()
    let [s_line, s_col] = searchpairpos('(', '', ')', 'bnW')
    if s_line > 0 && s_col > 0
        let op_line = getline(s_line)[(s_col-1):]
        let matches = matchlist(op_line, '^(\s*\(\k\+\)\s*')
        if len(matches) > 0
            return matches[1]
        endif
    endif
    return ''
endfunction

function! vlime#ui#ParseOuterOperators(max_count)
    let stack = []
    let old_cur_pos = getcurpos()
    try
        while len(stack) < a:max_count
            let [p_line, p_col] = searchpairpos('(', '', ')', 'bnW')
            if p_line <= 0 || p_col <= 0
                break
            endif
            let cur_pos = vlime#ui#CurArgPos([p_line, p_col])

            call setpos('.', [0, p_line, p_col, 0])
            let cur_op = vlime#ui#CurOperator()
            call add(stack, [cur_op, cur_pos, [p_line, p_col]])
        endwhile
    finally
        call setpos('.', old_cur_pos)
    endtry

    return stack
endfunction

""
" @usage [return_pos]
" @public
"
" Return the content of current/last selection. See
" @function(vlime#ui#CurExpr) for the use of [return_pos].
function! vlime#ui#CurSelection(...)
    let return_pos = get(a:000, 0, v:false)
    let sel_start = getpos("'<")
    let sel_end = getpos("'>")
    let lines = getline(sel_start[1], sel_end[1])
    if sel_start[1] == sel_end[1]
        let lines[0] = lines[0][(sel_start[2]-1):(sel_end[2]-1)]
    else
        let lines[0] = lines[0][(sel_start[2]-1):]
        let last_idx = len(lines) - 1
        let lines[last_idx] = lines[last_idx][:(sel_end[2]-1)]
    endif

    if return_pos
        return [join(lines, "\n"), sel_start[1:2], sel_end[1:2]]
    else
        return join(lines, "\n")
    endif
endfunction

""
" @usage [raw]
" @public
"
" Get the text content of the current buffer. Lines starting with ";" will be
" dropped, unless [raw] is specified and |TRUE|.
function! vlime#ui#CurBufferContent(...)
    let raw = get(a:000, 0, v:false)

    let lines = getline(1, '$')
    if !raw
        let lines = filter(lines, "match(v:val, '^\s*;.*$') < 0")
    endif

    return join(lines, "\n")
endfunction

""
" @public
"
" Retrieve the text in the current buffer from {from_pos} to {to_pos}.
" These positions should be lists in the form [<line>, <col>].
function! vlime#ui#GetText(from_pos, to_pos)
    let [s_line, s_col] = a:from_pos
    let [e_line, e_col] = a:to_pos

    let lines = getline(s_line, e_line)
    if len(lines) == 1
        let lines[0] = strpart(lines[0], s_col - 1, e_col - s_col + 1)
    elseif len(lines) > 1
        let lines[0] = strpart(lines[0], s_col - 1)
        let lines[-1] = strpart(lines[-1], 0, e_col)
    endif

    return join(lines, "\n")
endfunction

function! vlime#ui#GetCurWindowLayout()
    let old_win = win_getid()
    let layout = []
    let old_ei = &eventignore
    let &eventignore = 'all'
    try
        windo call add(layout,
                    \ {'id': win_getid(),
                        \ 'height': winheight(0),
                        \ 'width': winwidth(0)})
        return layout
    finally
        call win_gotoid(old_win)
        let &eventignore = old_ei
    endtry
endfunction

function! vlime#ui#RestoreWindowLayout(layout)
    if len(a:layout) != winnr('$')
        return
    endif

    let old_win = win_getid()
    let old_ei = &eventignore
    let &eventignore = 'all'
    try
        for ws in a:layout
            if win_gotoid(ws['id'])
                execute 'resize' ws['height']
                execute 'vertical resize' ws['width']
            endif
        endfor
    finally
        call win_gotoid(old_win)
        let &eventignore = old_ei
    endtry
endfunction

""
" @public
"
" Call {Func}. When {Func} returns, move the cursor back to the current
" window.
function! vlime#ui#KeepCurWindow(Func)
    let cur_win_id = win_getid()
    try
        return a:Func()
    finally
        call win_gotoid(cur_win_id)
    endtry
endfunction

""
" @usage {buf} {Func} [ev_ignore]
" @public
"
" Call {Func} with {buf} set as the current buffer. {buf} should be an
" expression as described in |bufname()|. [ev_ignore] specifies what
" autocmd events to ignore when switching buffers. When [ev_ignore] is
" omitted, all events are ignored by default.
function! vlime#ui#WithBuffer(buf, Func, ...)
    let ev_ignore = get(a:000, 0, 'all')

    let buf_win = bufwinid(a:buf)
    let buf_visible = (buf_win >= 0) ? v:true : v:false

    let old_win = win_getid()

    let old_lazyredraw = &lazyredraw
    let &lazyredraw = 1

    let old_ei = &eventignore
    let &eventignore = ev_ignore

    try
        if buf_visible
            call win_gotoid(buf_win)
            try
                let &eventignore = old_ei
                return a:Func()
            finally
                let &eventignore = ev_ignore
            endtry
        else
            let old_layout = vlime#ui#GetCurWindowLayout()
            try
                silent call vlime#ui#OpenBuffer(a:buf, v:false, v:true)
                let tmp_win_id = win_getid()
                try
                    let &eventignore = old_ei
                    return a:Func()
                finally
                    let &eventignore = ev_ignore
                    execute win_id2win(tmp_win_id) . 'wincmd c'
                endtry
            finally
                call vlime#ui#RestoreWindowLayout(old_layout)
            endtry
        endif
    finally
        call win_gotoid(old_win)
        let &lazyredraw = old_lazyredraw
        let &eventignore = old_ei
    endtry
endfunction

""
" @usage {name} {create} {show} [vertical] [initial_size]
" @public
"
" Open a buffer with the specified {name}.
" {name} should be an expression as described in |bufname()|. Return -1 if the
" buffer doesn't exist, unless {create} is |TRUE|. In that case, a new buffer
" is created.
"
" When {show} is |TRUE| or a non-empty string, the buffer will be shown in a
" new window, but if the buffer is already visible, move the cursor to it's
" window instead. The string values can be "aboveleft", "belowright",
" "topleft", or "botright", to further specify the window position. See
" |aboveleft| and the alike to get explanations of these positions.
"
" [vertical], if specified and |TRUE|, indicates that the new window should be
" created vertically. [initial_size] assigns an initial size to the newly
" created window.
function! vlime#ui#OpenBuffer(name, create, show, ...)
    let vertical = get(a:000, 0, v:false)
    let initial_size = get(a:000, 1, v:null)
    let buf = bufnr(a:name, a:create)
    if buf > 0
        if (type(a:show) == v:t_string && len(a:show) > 0) || a:show
            " Found it. Try to put it in a window
            let win_nr = bufwinnr(buf)
            if win_nr < 0
                if type(a:show) == v:t_string
                    let split_cmd = 'split #' . buf
                    if vertical
                        let split_cmd = join(['vertical', split_cmd])
                    endif
                    " Use silent! to suppress the 'Illegal file name' message
                    " and E303: Unable to open swap file...
                    silent! execute a:show split_cmd
                else
                    silent! execute 'split #' . buf
                endif
                if type(initial_size) != type(v:null)
                    let resize_cmd = join(['resize', initial_size])
                    if vertical
                        let resize_cmd = join(['vertical', resize_cmd])
                    endif
                    execute resize_cmd
                endif
            else
                execute win_nr . 'wincmd w'
            endif
        endif
    endif
    return buf
endfunction

""
" @public
"
" Like @function(vlime#ui#OpenBuffer), but consult |g:vlime_window_settings|
" when creating a new window. {buf_name} should be an expression as described
" in |bufname()|. {buf_create} specifies whether to create a new buffer or
" not. {win_name} is the type of the window to create. See
" |g:vlime_window_settings| for a list of Vlime window types.
function! vlime#ui#OpenBufferWithWinSettings(buf_name, buf_create, win_name)
    let [win_pos, win_size, win_vert] = vlime#ui#GetWindowSettings(a:win_name)
    return vlime#ui#OpenBuffer(a:buf_name, a:buf_create,
                \ win_pos, win_vert, win_size)
endfunction

""
" @public
"
" Close all windows that contain {buf}. It's like "execute 'bunload!' {buf}",
" but the buffer remains loaded, and the local settings for {buf} are kept.
" {buf} should be a buffer number as returned by |bufnr()|.
function! vlime#ui#CloseBuffer(buf)
    let win_id_list = win_findbuf(a:buf)
    if len(win_id_list) <= 0
        return
    endif

    let cur_win_id = win_getid()
    let close_cur_win = v:false
    let old_lazyredraw = &lazyredraw

    try
        let &lazyredraw = 1
        for win_id in win_id_list
            if win_id == cur_win_id
                let close_cur_win = v:true
            elseif win_gotoid(win_id)
                wincmd c
            endif
        endfor
    finally
        if win_gotoid(cur_win_id) && close_cur_win
            wincmd c
        endif
        let &lazyredraw = old_lazyredraw
    endtry
endfunction

" vlime#ui#ShowTransientWindow(
"       conn, content, append, buf_name, win_name[, file_type])
function! vlime#ui#ShowTransientWindow(
            \ conn, content, append, buf_name, win_name, ...)
    let file_type = get(a:000, 0, v:null)
    let old_win_id = win_getid()
    try
        let buf = vlime#ui#OpenBufferWithWinSettings(
                    \ a:buf_name, v:true, a:win_name)
        if buf > 0
            " We already switched to the transient window
            setlocal winfixheight
            setlocal winfixwidth

            if !vlime#ui#VlimeBufferInitialized(buf)
                call vlime#ui#SetVlimeBufferOpts(buf, a:conn)
                if type(file_type) != type(v:null)
                    call setbufvar(buf, '&filetype', file_type)
                endif
            else
                call setbufvar(buf, 'vlime_conn', a:conn)
            endif

            setlocal modifiable
            if a:append
                call vlime#ui#AppendString(a:content)
            else
                call vlime#ui#ReplaceContent(a:content)
            endif
            setlocal nomodifiable
        endif
        return buf
    finally
        call win_gotoid(old_win_id)
    endtry
endfunction

""
" @public
"
" Show {content} in the preview buffer. {conn} should be a
" @dict(VlimeConnection). When {append} is |TRUE|, append {content} to the
" existing content in the preview buffer.
function! vlime#ui#ShowPreview(conn, content, append)
    return vlime#ui#ShowTransientWindow(
                \ a:conn, a:content, a:append,
                \ vlime#ui#PreviewBufName(), 'preview', 'vlime_preview')
endfunction

""
" @public
"
" Show {content} in the arglist buffer. {conn} should be a
" @dict(VlimeConnection).
function! vlime#ui#ShowArgList(conn, content)
    if !exists('#VlimeArgListInit')
        augroup VlimeArgListInit
            autocmd!
            let escaped_name = escape(vlime#ui#ArgListBufName(), ' |\' . g:vlime_buf_name_sep)
            execute 'autocmd BufWinEnter' escaped_name 'setlocal conceallevel=2'
        augroup end
    endif

    return vlime#ui#ShowTransientWindow(
                \ a:conn, a:content, v:false,
                \ vlime#ui#ArgListBufName(), 'arglist', 'vlime_arglist')
endfunction

""
" @public
"
" Return a list of Vlime windows. {conn} should be a @dict(VlimeConnection) or
" v:null. When {conn} is v:null, windows associated with all connections are
" returned. {win_name} is the type of window to look for, or an empty string to indicate
" all window types. See |g:vlime_window_settings| for a full list of window
" types.
function! vlime#ui#GetWindowList(conn, win_name)
    if a:win_name == 'preview' || a:win_name == 'arglist' ||
                \ a:win_name == 'server'
        " These buffers don't have a connection name suffix in their names
        let pattern = join(['vlime', a:win_name], g:vlime_buf_name_sep)
    elseif len(a:win_name) > 0
        if type(a:conn) == type(v:null)
            let pattern = join(['vlime', a:win_name], g:vlime_buf_name_sep)
        else
            let pattern = join(['vlime', a:win_name, a:conn.cb_data.name],
                        \ g:vlime_buf_name_sep)
        endif
    else
        " Match ALL Vlime windows
        let pattern = 'vlime' . g:vlime_buf_name_sep
    endif

    let winid_list = []
    let old_win_id = win_getid()
    try
        windo let bufname_prefix = bufname('%')[0:len(pattern)-1] |
                    \ if bufname_prefix == pattern |
                        \ call add(winid_list, [win_getid(), bufname('%')]) |
                    \ endif
    finally
        call win_gotoid(old_win_id)
    endtry

    return winid_list
endfunction

""
" @public
"
" Return a list of windows containing buffers of filetype {ft}.
function! vlime#ui#GetFiletypeWindowList(ft)
    let winid_list = []
    let old_win_id = win_getid()
    try
        windo if &filetype == a:ft |
                    \ call add(winid_list, [win_getid(), bufname('%')]) |
                \ endif
    finally
        call win_gotoid(old_win_id)
    endtry

    return winid_list
endfunction

""
" @public
"
" Close Vlime windows. See @function(vlime#ui#GetWindowList) for the use of
" {conn} and {win_name}.
function! vlime#ui#CloseWindow(conn, win_name)
    let winid_list = vlime#ui#GetWindowList(a:conn, a:win_name)
    for [winid, bufname] in winid_list
        let winnr = win_id2win(winid)
        if winnr > 0
            execute winnr . 'wincmd c'
        endif
    endfor
endfunction

""
" @usage {str} [line]
" @public
"
" Append {str} to [line] in the current buffer. Append to the last line if
" [line] is omitted. Elaborately handle newline characters.
function! vlime#ui#AppendString(str, ...)
    let last_line_nr = line('$')
    let to_append = get(a:000, 0, last_line_nr)

    let new_lines = split(a:str, "\n", v:true)
    let sidx = 0
    let eidx = -1

    if to_append > 0 " && len(new_lines) > 0
        let line_to_append = getline(to_append)
        call setline(to_append, line_to_append . new_lines[0])
        let sidx = 1
    endif

    if to_append < last_line_nr && len(new_lines) > 1
        let line_after_append = getline(to_append + 1)
        call setline(to_append + 1, new_lines[-1] . line_after_append)
        let eidx = -2
    endif

    call append(to_append, new_lines[sidx:eidx])

    let cur_line_nr = line('.')
    if cur_line_nr == last_line_nr
        call setpos('.', [0, line('$'), 1, 0, 1])
    endif

    " How many new lines are added.
    return len(new_lines) + eidx - sidx + 1
endfunction

""
" @usage {str} [first_line] [last_line]
" @public
"
" Replace the content of the current buffer, from [first_line] to [last_line]
" (inclusive), with {str}. If [first_line] is omitted, start from line 1. If
" [last_line] is omitted, stop at the last line of the current buffer.
function! vlime#ui#ReplaceContent(str, ...)
    let first_line = get(a:000, 0, 1)
    let last_line = get(a:000, 1, line('$'))

    execute first_line . ',' . last_line . 'delete _'

    if first_line > 1
        let str = "\n" . a:str
    else
        let str = a:str
    endif
    let ret = vlime#ui#AppendString(str, first_line - 1)
    call setpos('.', [0, first_line, 1, 0, 1])
    return ret
endfunction

""
" @public
"
" Adjust the indentation of the current line. {indent} is the amount to
" indent, in number of space characters.
function! vlime#ui#IndentCurLine(indent)
    if &expandtab
        let indent_str = repeat(' ', a:indent)
    else
        " Ah! So bad! Such evil!
        let indent_str = repeat("\<tab>", a:indent / &tabstop)
        let indent_str .= repeat(' ', a:indent % &tabstop)
    endif
    let line = getline('.')
    let new_line = substitute(line, '^\(\s*\)', indent_str, '')
    call setline('.', new_line)
    let spaces = vlime#ui#CalcLeadingSpaces(new_line)
    call setpos('.', [0, line('.'), spaces + 1, 0, a:indent + 1])
endfunction

""
" @usage [pos]
" @public
"
" Return the index of the argument under the cursor, inside a
" parentheses-enclosed expression. A returned value of zero means the cursor
" is on the operator. If no parentheses-enclosed expression is found, -1 is
" returned. [pos] should be the position where the parentheses-enclosed
" expression begins, in the form [<line>, <col>]. If [pos] is omitted, this
" function will try to find the beginning position.
function! vlime#ui#CurArgPos(...)
    let s_pos = get(a:000, 0, v:null)
    let arg_pos = -1

    if type(s_pos) == type(v:null)
        let [s_line, s_col] = searchpairpos('(', '', ')', 'bnW')
    else
        let [s_line, s_col] = s_pos
    endif
    if s_line <= 0 || s_col <= 0
        return arg_pos
    endif

    let cur_pos = getcurpos()
    let paren_count = 0
    let last_type = ''

    for ln in range(s_line, cur_pos[1])
        let line = getline(ln)
        let start_idx = (ln == s_line) ? (s_col - 1) : 0
        if ln == cur_pos[1]
            let end_idx = min([cur_pos[2], len(line)])
            if cur_pos[2] > len(line)
                let end_itr = end_idx + 1
            else
                let end_itr = end_idx
            endif
        else
            let end_idx = len(line)
            let end_itr = end_idx + 1
        endif

        let idx = start_idx
        while idx < end_itr
            if idx < end_idx
                let ch = line[idx]
            elseif idx < len(line)
                break
            else
                let ch = "\n"
            endif

            if ch == ' ' || ch == "\<tab>" || ch == "\n"
                if last_type != 's' && last_type != ')' && paren_count == 1
                    let arg_pos += 1
                endif
                let last_type = 's'
            elseif ch == '('
                let paren_count += 1
                if last_type == '(' && paren_count == 2
                    let arg_pos += 1
                endif
                let last_type = '('
            elseif ch == ')'
                let paren_count -= 1
                if paren_count == 1
                    let arg_pos += 1
                endif
                let last_type = ')'
            else
                " identifiers
                if last_type != 's' && last_type != ')' && last_type != 'i' && paren_count == 1
                    let arg_pos += 1
                endif
                let last_type = 'i'
            endif

            let idx += 1
        endwhile

        let last_type = 's'
    endfor

    return arg_pos
endfunction

function! vlime#ui#Pad(prefix, sep, max_len)
    return a:prefix . a:sep . repeat(' ', a:max_len + 1 - len(a:prefix))
endfunction

""
" @public
"
" Show an error message.
function! vlime#ui#ErrMsg(msg)
    echohl ErrorMsg
    echom a:msg
    echohl None
endfunction

function! vlime#ui#SetVlimeBufferOpts(buf, conn)
    call setbufvar(a:buf, '&buftype', 'nofile')
    call setbufvar(a:buf, '&bufhidden', 'hide')
    call setbufvar(a:buf, '&swapfile', 0)
    call setbufvar(a:buf, '&buflisted', 1)
    call setbufvar(a:buf, 'vlime_conn', a:conn)
endfunction

function! vlime#ui#VlimeBufferInitialized(buf)
    return type(getbufvar(a:buf, 'vlime_conn', v:null)) != type(v:null)
endfunction

function! vlime#ui#MatchCoord(coord, cur_line, cur_col)
    let c_begin = get(a:coord, 'begin', v:null)
    let c_end = get(a:coord, 'end', v:null)
    if type(c_begin) == type(v:null) || type(c_end) == type(v:null)
        return v:false
    endif

    if c_begin[0] == c_end[0] && a:cur_line == c_begin[0]
                \ && a:cur_col >= c_begin[1]
                \ && a:cur_col <= c_end[1]
        return v:true
    elseif c_begin[0] < c_end[0]
        if a:cur_line == c_begin[0] && a:cur_col >= c_begin[1]
            return v:true
        elseif a:cur_line == c_end[0] && a:cur_col <= c_end[1]
            return v:true
        elseif a:cur_line > c_begin[0] && a:cur_line < c_end[0]
            return v:true
        endif
    endif

    return v:false
endfunction

" vlime#ui#FindNextCoord(cur_pos, sorted_coords[, forward])
function! vlime#ui#FindNextCoord(cur_pos, sorted_coords, ...)
    let forward = get(a:000, 0, v:true)

    let next_coord = v:null
    for c in a:sorted_coords
        if forward
            if c['begin'][0] > a:cur_pos[0]
                return c
            elseif c['begin'][0] == a:cur_pos[0] && c['begin'][1] > a:cur_pos[1]
                return c
            endif
        else
            if c['begin'][0] < a:cur_pos[0]
                return c
            elseif c['begin'][0] == a:cur_pos[0] && c['begin'][1] < a:cur_pos[1]
                return c
            endif
        endif
    endfor

    return v:null
endfunction

function! vlime#ui#CoordSorter(direction, c1, c2)
    if a:c1['begin'][0] > a:c2['begin'][0]
        return a:direction ? 1 : -1
    elseif a:c1['begin'][0] == a:c2['begin'][0]
        if a:c1['begin'][1] > a:c2['begin'][1]
            return a:direction ? 1 : -1
        elseif a:c1['begin'][1] == a:c2['begin'][1]
            return 0
        else
            return a:direction ? -1 : 1
        endif
    else
        return a:direction ? -1 : 1
    endif
endfunction

function! vlime#ui#CoordsToMatchPos(coords)
    let pos_list = []
    for co in a:coords
        if co['begin'][0] == co['end'][0]
            let line = co['begin'][0]
            let col = co['begin'][1]
            let len = co['end'][1] - co['begin'][1] + 1
            call add(pos_list, [line, col, len])
        else
            for line in range(co['begin'][0], co['end'][0])
                if line == co['begin'][0]
                    let col = co['begin'][1]
                    let len = len(getline(line)) - col + 1
                    call add(pos_list, [line, col, len])
                elseif line == co['end'][0]
                    let col = 1
                    let len = co['end'][1]
                    call add(pos_list, [line, col, len])
                else
                    call add(pos_list, line)
                endif
            endfor
        endif
    endfor

    return pos_list
endfunction

function! vlime#ui#MatchAddCoords(group, coords)
    let pos_list = vlime#ui#CoordsToMatchPos(a:coords)
    let match_list = []
    let stride = 8
    for i in range(0, len(pos_list) - 1, stride)
        call add(match_list, matchaddpos(a:group, pos_list[i:i+stride-1]))
    endfor
    return match_list
endfunction

function! vlime#ui#MatchDeleteList(match_list)
    for m in a:match_list
        call matchdelete(m)
    endfor
endfunction

""
" @usage {file_path} {byte_pos} [snippet] [edit_cmd] [force_open]
" @public
"
" Open a file specified by {file_path}, and move the cursor to {byte_pos}. If
" the specified file is already loaded in a window, move the cursor to that
" window instead.
"
" [snippet] is used to fine-tune the cursor position to jump to. One can pass
" v:null to safely ignore the fine-tuning. [edit_cmd] is the command used to
" open the specified file, if it's not loaded in any window yet. The default
" is "hide edit". When [force_open] is specified and |TRUE|, always open the
" file with [edit_cmd].
function! vlime#ui#JumpToOrOpenFile(file_path, byte_pos, ...)
    let snippet = get(a:000, 0, v:null)
    let edit_cmd = get(a:000, 1, 'hide edit')
    let force_open = get(a:000, 2, v:false)

    " We are using setpos() to jump around the target file, and it doesn't
    " save the locations to the jumplist. We need to save the current location
    " explicitly with m' before running edit_cmd or jumping around in an
    " already-opened file (see :help jumplist).

    if force_open
        let buf_exists = v:false
    else
        let file_buf = bufnr(a:file_path)
        let buf_exists = v:true
        if file_buf > 0
            let buf_win = bufwinnr(file_buf)
            if buf_win > 0
                execute buf_win . 'wincmd w'
            else
                let win_list = win_findbuf(file_buf)
                if len(win_list) > 0
                    call win_gotoid(win_list[0])
                else
                    let buf_exists = v:false
                endif
            endif
        else
            let buf_exists = v:false
        endif
    endif

    if buf_exists
        normal! m'
    else
        " Actually the buffer may exist, but it's not shown in any window
        if type(a:file_path) == v:t_number
            if bufnr(a:file_path) > 0
                try
                    normal! m'
                    execute edit_cmd '#' . a:file_path
                catch /^Vim\%((\a\+)\)\=:E37/  " No write since last change
                    " Vim will raise E37 when editing the same buffer with
                    " unsaved changes. Double-check it IS the same buffer.
                    if bufnr('%') != a:file_path
                        throw v:exception
                    endif
                endtry
            else
                call vlime#ui#ErrMsg('Buffer ' . a:file_path . ' does not exist.')
                return
            endif
        elseif a:file_path[0:6] == 'sftp://' || filereadable(a:file_path)
            normal! m'
            execute edit_cmd escape(a:file_path, ' \')
        else
            call vlime#ui#ErrMsg('Not readable: ' . a:file_path)
            return
        endif
    endif

    if type(a:byte_pos) != type(v:null)
        let src_line = byte2line(a:byte_pos)
        call setpos('.', [0, src_line, 1, 0, 1])
        let cur_pos = line2byte('.') + col('.') - 1
        if a:byte_pos - cur_pos > 0
            call setpos('.', [0, src_line, a:byte_pos - cur_pos + 1, 0])
        endif
        if type(snippet) != type(v:null)
            let to_search = '\V' . substitute(escape(snippet, '\'), "\n", '\\n', 'g')
            call search(to_search, 'cW')
        endif
        " Vim may not update the screen when we move the cursor around like
        " this. Force a redraw.
        redraw
    endif
endfunction

""
" @usage {conn} {loc} [edit_cmd] [force_open]
" @public
"
" Open the source location specified by {loc}.
" {conn} should be a @dict(VlimeConnection), and {loc} a normalized source
" location returned by @function(vlime#GetValidSourceLocation). See
" @function(vlime#ui#JumpToOrOpenFile) for the use of [edit_cmd] and
" [force_open].
function! vlime#ui#ShowSource(conn, loc, ...)
    let edit_cmd = get(a:000, 0, 'hide edit')
    let force_open = get(a:000, 1, v:false)

    let file_name = a:loc[0]
    let byte_pos = a:loc[1]
    let snippet = a:loc[2]

    if type(file_name) == type(v:null)
        call vlime#ui#ShowPreview(a:conn, "Source form:\n\n" . snippet, v:false)
    else
        call vlime#ui#JumpToOrOpenFile(file_name, byte_pos, snippet, edit_cmd, force_open)
    endif
endfunction

function! vlime#ui#CalcLeadingSpaces(str, ...)
    let expand_tab = get(a:000, 0, v:false)
    if expand_tab
        let n_str = substitute(a:str, "\t", repeat(' ', &tabstop), 'g')
    else
        let n_str = a:str
    endif
    let spaces = match(n_str, '[^[:blank:]]')
    if spaces < 0
        let spaces = len(n_str)
    endif
    return spaces
endfunction

function! vlime#ui#GetEndOfFileCoord()
    let last_line_nr = line('$')
    let last_line = getline(last_line_nr)
    let last_col_nr = len(last_line)
    if last_col_nr <= 0
        let last_col_nr = 1
    endif
    return [last_line_nr, last_col_nr]
endfunction

if !exists('g:vlime_buf_name_sep')
    let g:vlime_buf_name_sep = ' | '
endif

function! vlime#ui#SLDBBufName(conn, thread)
    return join(['vlime', 'sldb', a:conn.cb_data.name, a:thread],
                \ g:vlime_buf_name_sep)
endfunction

function! vlime#ui#REPLBufName(conn)
    return join(['vlime', 'repl', a:conn.cb_data.name],
                \ g:vlime_buf_name_sep)
endfunction

function! vlime#ui#MREPLBufName(conn, chan_obj)
    return join(['vlime', 'mrepl ' . a:chan_obj['id'], a:conn.cb_data.name],
                \ g:vlime_buf_name_sep)
endfunction

function! vlime#ui#PreviewBufName()
    return join(['vlime', 'preview'], g:vlime_buf_name_sep)
endfunction

function! vlime#ui#ArgListBufName()
    return join(['vlime', 'arglist'], g:vlime_buf_name_sep)
endfunction

function! vlime#ui#InspectorBufName(conn)
    return join(['vlime', 'inspect', a:conn.cb_data.name],
                \ g:vlime_buf_name_sep)
endfunction

function! vlime#ui#TraceDialogBufName(conn)
    return join(['vlime', 'trace', a:conn.cb_data.name],
                \ g:vlime_buf_name_sep)
endfunction

function! vlime#ui#InputBufName(conn, prompt)
    return join(['vlime', 'input', a:conn.cb_data.name, a:prompt],
                \ g:vlime_buf_name_sep)
endfunction

function! vlime#ui#XRefBufName(conn)
    return join(['vlime', 'xref', a:conn.cb_data.name],
                \ g:vlime_buf_name_sep)
endfunction

function! vlime#ui#CompilerNotesBufName(conn)
    return join(['vlime', 'notes', a:conn.cb_data.name],
                \ g:vlime_buf_name_sep)
endfunction

function! vlime#ui#ThreadsBufName(conn)
    return join(['vlime', 'threads', a:conn.cb_data.name],
                \ g:vlime_buf_name_sep)
endfunction

function! vlime#ui#ServerBufName(server_name)
    return join(['vlime', 'server', a:server_name],
                \ g:vlime_buf_name_sep)
endfunction

""
" @public
"
" Return settings for a window type {win_name}. See |g:vlime_window_settings|
" for the format of the settings and a full list of window types.
function! vlime#ui#GetWindowSettings(win_name)
    let settings = get(g:vlime_default_window_settings, a:win_name, v:null)
    if type(settings) == type(v:null)
        throw 'vlime#ui#GetWindowSettings: unknown window ' . string(a:win_name)
    else
        let settings = copy(settings)
    endif

    if exists('g:vlime_window_settings')
        let UserSettings = get(g:vlime_window_settings, a:win_name, {})
        if type(UserSettings) == v:t_func
            let UserSettings = UserSettings()
        endif
        for sk in keys(UserSettings)
            let settings[sk] = UserSettings[sk]
        endfor
    endif

    return [get(settings, 'pos', 'botright'),
                \ get(settings, 'size', v:null),
                \ get(settings, 'vertical', v:false)]
endfunction

""
" @usage {mode} {key} {cmd} [force] [log] [flags]
" @public
"
" Ensure the specified {key} or {cmd} is mapped in {mode}. If both {key} and
" {cmd} are not mapped, map {key} to run {cmd}. If [force] is specified and
" |TRUE|, always do the mapping. [log] is the category for logging conflicting
" keys, should usually be the buffer type. See the value of
" g:vlime_default_mappings for all buffer types. [flags] is a string
" specifying |:map-arguments|.
function! vlime#ui#EnsureKeyMapped(mode, key, cmd, ...)
    let force = get(a:000, 0, v:false)
    let log = get(a:000, 1, v:null)
    let flags = get(a:000, 2, '<buffer> <silent>')
    if type(a:key) != v:t_list
        let key_list = [a:key]
    else
        let key_list = a:key
    endif

    if force
        for kk in key_list
            let map_cmd = a:mode . 'noremap'
            execute map_cmd flags kk a:cmd
        endfor
        return copy(key_list)
    else
        if !hasmapto(a:cmd, a:mode)
            let keys_mapped = []
            for kk in key_list
                if len(maparg(kk, a:mode)) <= 0
                    let map_cmd = a:mode . 'noremap'
                    execute map_cmd flags kk a:cmd
                    call add(keys_mapped, kk)
                else
                    call s:LogSkippedKey(log, a:mode, kk, a:cmd,
                                \ 'Key already mapped.')
                endif
            endfor
            return keys_mapped
        else
            for kk in key_list
                call s:LogSkippedKey(log, a:mode, kk, a:cmd,
                            \ 'Command already mapped.')
            endfor
            return []
        endif
    endif
endfunction

if !exists('g:vlime_key_descriptions')
    let g:vlime_key_descriptions = {}
endif

""
" @usage {buf_type} [force]
" @public
"
" Map default Vlime keys for buffer type {buf_type}. See the value of
" g:vlime_default_mappings for all buffer types. This function consults
" |g:vlime_force_default_keys| when trying to map the keys. If [force] is
" specified, it's value overrides the global variable.
function! vlime#ui#MapBufferKeys(buf_type, ...)
    let force = get(a:000, 0, v:null)
    if type(force) == type(v:null)
        let force = exists('g:vlime_force_default_keys') ? g:vlime_force_default_keys : v:false
    endif

    let build_key_desc = !has_key(g:vlime_key_descriptions, a:buf_type)

    if build_key_desc
        let key_descriptions = []
    endif

    for [mode, key, cmd, desc] in vlime#ui#mapping#GetBufferMappings(a:buf_type)
        let keys_mapped = vlime#ui#EnsureKeyMapped(mode, key, cmd, force, a:buf_type)
        if build_key_desc
            for kk in keys_mapped
                call add(key_descriptions, [mode, s:ExpandLeader(kk), desc])
            endfor
        endif
    endfor

    if build_key_desc
        let g:vlime_key_descriptions[a:buf_type] = key_descriptions
    endif
endfunction

function! vlime#ui#BuildKeyDescriptions(buf_type)
    let key_desc = get(g:vlime_key_descriptions, a:buf_type, v:null)
    if type(key_desc) != type(v:null) && len(key_desc) > 0
        let max_key_len = 3
        for dd in key_desc
            if len(dd[1]) > max_key_len
                let max_key_len = len(dd[1])
            endif
        endfor

        let content = 'MODE  ' . vlime#ui#Pad('KEY', '', max_key_len + 1) . 'DESCRIPTION' . "\n"
        for [mode, key, desc] in key_desc
            let content .= vlime#ui#Pad(mode, '', 5) . vlime#ui#Pad(key, '', max_key_len + 1) . desc . "\n"
        endfor
        return content
    else
        return '<No Vlime mapping defined for ' . a:buf_type . '>'
    endif
endfunction

function! vlime#ui#ShowQuickRef(buf_type)
    call vlime#ui#ShowPreview(v:null, vlime#ui#BuildKeyDescriptions(a:buf_type), v:false)
endfunction

""
" @public
"
" Choose a window with |v:count|. The special variable v:count should contain
" a valid window number (see |winnr()|) or zero when this function is called.
" The coresponding window ID is returned. If v:count is zero, try to use
" {default_win} as the result. In that case, if {default_win} is not a legal
" window number, try to find a window automatically.
"
" When all measures fail, zero is returned.
function! vlime#ui#ChooseWindowWithCount(default_win)
    let count_specified = v:false
    if v:count > 0
        let count_specified = v:true
        let win_to_go = win_getid(v:count)
        if win_to_go <= 0
            call vlime#ui#ErrMsg('Invalid window number: ' . v:count)
        endif
    elseif type(a:default_win) != type(v:null) && win_id2win(a:default_win) > 0
        let win_to_go = a:default_win
    else
        let win_list = vlime#ui#GetFiletypeWindowList('lisp')
        let win_to_go = (len(win_list) > 0) ? win_list[0][0] : 0
    endif

    return [win_to_go, count_specified]
endfunction

function! s:LogSkippedKey(log, mode, key, cmd, reason)
    if type(a:log) == type(v:null)
        return
    endif
    let buf_type = a:log

    if !exists('g:vlime_skipped_mappings')
        let g:vlime_skipped_mappings = {}
    endif

    let buf_skipped_keys = get(g:vlime_skipped_mappings, buf_type, {})
    let buf_skipped_keys[join([a:mode, a:key], ' ')] = [a:cmd, a:reason]
    let g:vlime_skipped_mappings[buf_type] = buf_skipped_keys
endfunction

function! s:NormalizePackageName(name)
    let pattern1 = '^\(\(#\?:\)\|''\)\(.\+\)'
    let pattern2 = '"\(.\+\)"'
    let matches = matchlist(a:name, pattern1)
    let r_name = ''
    if len(matches) > 0
        let r_name = matches[3]
    else
        let matches = matchlist(a:name, pattern2)
        if len(matches) > 0
            let r_name = matches[1]
        endif
    endif
    return toupper(r_name)
endfunction

function! s:ReadStringInputComplete(thread, ttag)
    let content = vlime#ui#CurBufferContent()
    if content[len(content)-1] != "\n"
        let content .= "\n"
    endif
    call b:vlime_conn.ReturnString(a:thread, a:ttag, content)
endfunction

function! s:InComment(cur_pos)
    let syn_id = synID(a:cur_pos[0], a:cur_pos[1], v:false)
    if syn_id > 0
        return synIDattr(syn_id, 'name') =~ '[Cc]omment'
    else
        if searchpair('#|', '', '|#', 'bnW') > 0
            return v:true
        else
            let line = getline(a:cur_pos[0])
            let semi_colon_idx = match(line, ';')
            if semi_colon_idx >= 0 && (a:cur_pos[1] - 1) > semi_colon_idx
                return v:true
            endif
            return v:false
        endif
    endif
endfunction

function! s:InString(cur_pos)
    let syn_id = synID(a:cur_pos[0], a:cur_pos[1], v:false)
    if syn_id > 0
        return synIDattr(syn_id, 'name') =~ '[Ss]tring'
    else
        let quote_count = 0
        let pattern = '\v((^|[^\\])@<=")|(((^|[^\\])((\\\\)+))@<=")'
        let old_pos = getcurpos()
        try
            let quote_pos = searchpos(pattern, 'bW')
            while quote_pos[0] > 0 && quote_pos[1] > 0
                let quote_count += 1
                let quote_pos = searchpos(pattern, 'bW')
            endwhile
            return (quote_count % 2) > 0
        finally
            call setpos('.', old_pos)
        endtry
    endif
endfunction

let s:special_leader_keys = [
            \ ['<', '<lt>'],
            \ ["\<space>", '<space>'],
            \ ["\<tab>", '<tab>'],
            \ ]

function! s:ExpandSpecialLeaderKeys(leader)
    let res = a:leader
    for [key, repr] in s:special_leader_keys
        let res = substitute(res, key, repr, 'g')
    endfor
    return res
endfunction

let s:default_leader = '\'

let s:leader = get(g:, 'mapleader', s:default_leader)
if len(s:leader) <= 0
    let s:leader = s:default_leader
endif
let s:leader = s:ExpandSpecialLeaderKeys(s:leader)

let s:local_leader = get(g:, 'maplocalleader', s:default_leader)
if len(s:local_leader) <= 0
    let s:local_leader = s:default_leader
endif
let s:local_leader = s:ExpandSpecialLeaderKeys(s:local_leader)

function! s:ExpandLeader(key)
    let to_expand = [['\c<Leader>', s:leader], ['\c<LocalLeader>', s:local_leader]]
    let res = a:key
    for [repr, lkey] in to_expand
        let res = substitute(res, repr, lkey, 'g')
    endfor
    return res
endfunction
