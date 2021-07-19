function! vlime#ui#sldb#InitSLDBBuf(ui, conn, thread, level, frames)
    let buf = bufnr(vlime#ui#SLDBBufName(a:conn, a:thread), v:true)
    if !vlime#ui#VlimeBufferInitialized(buf)
        call vlime#ui#SetVlimeBufferOpts(buf, a:conn)
        call setbufvar(buf, '&filetype', 'vlime_sldb')
        call vlime#ui#WithBuffer(buf, function('s:InitSLDBBuf'))
    endif
    call setbufvar(buf, 'vlime_sldb_level', a:level)
    call setbufvar(buf, 'vlime_sldb_frames', a:frames)
    call a:ui.SetCurrentThread(a:thread, buf)
    return buf
endfunction

" Operates on current buffer. Should be called with vlime#ui#WithBuffer(...)
function! vlime#ui#sldb#FillSLDBBuf(thread, level, condition, restarts, frames)
    setlocal modifiable

    1,$delete _

    call vlime#ui#AppendString(
                \ 'Thread: ' . a:thread . '; Level: ' . a:level . "\n\n")

    let condition_str = ''
    for c in a:condition
        if type(c) == v:t_string
            let condition_str .= (c . "\n")
        endif
    endfor
    let condition_str .= "\n"
    call vlime#ui#AppendString(condition_str)

    let restarts_str = "Restarts:\n"
    let [max_name_len, has_star] = s:FindMaxRestartNameLen(a:restarts)
    let max_digits = len(string(len(a:restarts) - 1))
    let ri = 0
    while ri < len(a:restarts)
        let r = a:restarts[ri]
        let idx_str = vlime#ui#Pad(string(ri), '.', max_digits)
        let restart_line = s:FormatRestartLine(r, max_name_len, has_star)
        let restarts_str .= ('  ' . idx_str . restart_line . "\n")
        let ri += 1
    endwhile
    let restarts_str .= "\n"
    call vlime#ui#AppendString(restarts_str)

    let frames_str = "Frames:\n"
    let max_digits = len(string(len(a:frames) - 1))
    for f in a:frames
        let idx_str = vlime#ui#Pad(string(f[0]), '.', max_digits)
        let frames_str .= ('  ' . idx_str . f[1] . "\n")
    endfor
    call vlime#ui#AppendString(frames_str)

    setlocal nomodifiable
endfunction

function! vlime#ui#sldb#ChooseCurRestart()
    let nth = s:MatchRestart()
    if nth >= 0
        call b:vlime_conn.InvokeNthRestartForEmacs(b:vlime_sldb_level, nth)
    endif
endfunction

function! vlime#ui#sldb#ShowFrameDetails()
    let nth = s:MatchFrame()
    if nth < 0
        let nth = 0
    endif
    let frame = b:vlime_sldb_frames[nth]
    let restartable = s:FrameRestartable(frame)

    call vlime#ChainCallbacks(
                \ function(b:vlime_conn.FrameLocalsAndCatchTags, [nth]),
                \ function('s:ShowFrameLocalsCB', [nth, restartable]),
                \ function(b:vlime_conn.FrameSourceLocation, [nth]),
                \ function('s:ShowFrameSourceLocationCB', [nth, v:true]))
endfunction

" vlime#ui#sldb#OpenFrameSource([edit_cmd])
function! vlime#ui#sldb#OpenFrameSource(...)
    let edit_cmd = get(a:000, 0, 'hide edit')
    let nth = s:MatchFrame()
    if nth < 0
        let nth = 0
    endif

    let [win_to_go, count_specified] = vlime#ui#ChooseWindowWithCount(v:null)
    if win_to_go <= 0 && count_specified
        return
    endif

    call b:vlime_conn.FrameSourceLocation(nth,
                \ function('s:OpenFrameSourceCB', [edit_cmd, win_to_go, count_specified]))
endfunction

" vlime#ui#sldb#FindSource([edit_cmd])
function! vlime#ui#sldb#FindSource(...)
    let edit_cmd = get(a:000, 0, 'hide edit')
    let nth = s:MatchFrame()
    if nth < 0
        let nth = 0
    endif

    let [win_to_go, count_specified] = vlime#ui#ChooseWindowWithCount(v:null)
    if win_to_go <= 0 && count_specified
        return
    endif

    call b:vlime_conn.FrameLocalsAndCatchTags(nth,
                \ function('s:FindSourceCB',
                    \ [edit_cmd, win_to_go, count_specified, nth]))
endfunction

function! vlime#ui#sldb#RestartCurFrame()
    let nth = s:MatchFrame()
    if nth >= 0 && nth < len(b:vlime_sldb_frames)
        let frame = b:vlime_sldb_frames[nth]
        if s:FrameRestartable(frame)
            call b:vlime_conn.RestartFrame(nth)
        else
            call vlime#ui#ErrMsg('Frame ' . nth . ' is not restartable.')
        endif
    endif
endfunction

function! vlime#ui#sldb#StepCurOrLastFrame(opr)
    let nth = s:MatchFrame()
    if nth < 0
        let nth = 0
    endif

    if a:opr == 'step'
        call b:vlime_conn.SLDBStep(nth)
    elseif a:opr == 'next'
        call b:vlime_conn.SLDBNext(nth)
    elseif a:opr == 'out'
        call b:vlime_conn.SLDBOut(nth)
    endif
endfunction

function! vlime#ui#sldb#InspectCurCondition()
    call b:vlime_conn.InspectCurrentCondition(
                \ {c, r -> c.ui.OnInspect(c, r, v:null, v:null)})
endfunction

function! vlime#ui#sldb#InspectInCurFrame()
    let nth = s:MatchFrame()
    if nth < 0
        let nth = 0
    endif

    let thread = b:vlime_conn.GetCurrentThread()
    call vlime#ui#input#FromBuffer(
                \ b:vlime_conn, 'Inspect in frame (evaluated):',
                \ v:null,
                \ function('s:InspectInCurFrameInputComplete',
                    \ [nth, thread]))
endfunction

function! s:InspectInCurFrameInputComplete(frame, thread)
    let content = vlime#ui#CurBufferContent()
    if len(content) > 0
        call b:vlime_conn.WithThread(a:thread,
                    \ function(b:vlime_conn.InspectInFrame,
                        \ [content, a:frame,
                            \ {c, r -> c.ui.OnInspect(c, r, v:null, v:null)}]))
    else
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction

function! vlime#ui#sldb#EvalStringInCurFrame()
    let nth = s:MatchFrame()
    if nth < 0
        let nth = 0
    endif

    let thread = b:vlime_conn.GetCurrentThread()
    call vlime#ui#input#FromBuffer(
                \ b:vlime_conn, 'Eval in frame:',
                \ v:null,
                \ function('s:EvalStringInCurFrameInputComplete',
                    \ [nth, thread, b:vlime_conn.GetCurrentPackage()[0]]))
endfunction

function! s:EvalStringInCurFrameInputComplete(frame, thread, package)
    let content = vlime#ui#CurBufferContent()
    if len(content) > 0
        call b:vlime_conn.WithThread(a:thread,
                    \ function(b:vlime_conn.EvalStringInFrame,
                        \ [content, a:frame, a:package,
                            \ {c, r -> c.ui.OnWriteString(c, r . "\n",
                                \ {'name': 'FRAME-EVAL-RESULT', 'package': 'KEYWORD'})}]))
    else
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction

function! vlime#ui#sldb#SendValueInCurFrameToREPL()
    let nth = s:MatchFrame()
    if nth < 0
        let nth = 0
    endif

    let thread = b:vlime_conn.GetCurrentThread()
    call vlime#ui#input#FromBuffer(
                \ b:vlime_conn, 'Eval in frame and send result to REPL:',
                \ v:null,
                \ function('s:SendValueInCurFrameToREPLInputComplete',
                    \ [nth, thread, b:vlime_conn.GetCurrentPackage()[0]]))
endfunction

function! s:SendValueInCurFrameToREPLInputComplete(frame, thread, package)
    let content = vlime#ui#CurBufferContent()
    if len(content) > 0
        call b:vlime_conn.WithThread(a:thread,
                    \ function(b:vlime_conn.EvalStringInFrame,
                        \ ['(setf cl-user::* #.(read-from-string "' . escape(content, '"') . '"))',
                            \ a:frame, a:package,
                            \ {c, r ->
                                \ c.WithThread({'name': 'REPL-THREAD', 'package': 'KEYWORD'},
                                    \ function(c.ListenerEval, ['cl-user::*']))}]))
    else
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction

function! vlime#ui#sldb#DisassembleCurFrame()
    let nth = s:MatchFrame()
    if nth < 0
        let nth = 0
    endif

    let thread = b:vlime_conn.GetCurrentThread()
    call b:vlime_conn.WithThread(thread,
                \ function(b:vlime_conn.SLDBDisassemble,
                    \ [nth,
                        \ {c, r ->
                            \ vlime#ui#ShowPreview(c, r, v:false)}]))
endfunction

function! vlime#ui#sldb#ReturnFromCurFrame()
    let nth = s:MatchFrame()
    if nth < 0
        let nth = 0
    endif

    let thread = b:vlime_conn.GetCurrentThread()
    call vlime#ui#input#FromBuffer(
                \ b:vlime_conn, 'Return from frame (evaluated):',
                \ v:null,
                \ function('s:ReturnFromCurFrameInputComplete',
                    \ [nth, thread]))
endfunction

function! s:ReturnFromCurFrameInputComplete(frame, thread)
    let content = vlime#ui#CurBufferContent()
    if len(content) > 0
        call b:vlime_conn.WithThread(a:thread,
                    \ function(b:vlime_conn.SLDBReturnFromFrame,
                        \ [a:frame, content]))
    else
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction

function! s:FindMaxRestartNameLen(restarts)
    let max_name_len = 0
    let has_star = v:false
    for r in a:restarts
        if r[0][0] == '*'
            let start = 1
            let has_star = v:true
        else
            let start = 0
        endif
        if len(r[0][start:]) > max_name_len
            let max_name_len = len(r[0][start:])
        endif
    endfor
    return [max_name_len, has_star]
endfunction

function! s:FormatRestartLine(r, max_name_len, has_star)
    if a:has_star
        if a:r[0][0] == '*'
            let spc = ''
            let start = 1
        else
            let spc = ' '
            let start = 0
        endif
    else
        let spc = ''
        let start = 0
    endif
    let pad = repeat(' ', a:max_name_len + 1 - len(a:r[0][start:]))
    return spc . a:r[0] . pad . '- ' . a:r[1]
endfunction

function! s:MatchRestart()
    let line = getline('.')
    let matches = matchlist(line,
                \ '^\s*\([0-9]\+\)\.\s\+\*\?[A-Z\-]\+\s\+-\s.\+$')
    return (len(matches) > 0) ? (matches[1] + 0) : -1
endfunction

function! s:MatchFrame()
    let line = getline('.')
    let matches = matchlist(line, '^\s*\([0-9]\+\)\.\s\+(.\+)$')
    return (len(matches) > 0) ? (matches[1] + 0) : -1
endfunction

function! s:ShowFrameLocalsCB(frame, restartable, conn, result)
    let content = 'Frame: ' . a:frame
    let restartable_str = a:restartable ? ' (Restartable)' : ' (Not restartable)'
    let content .= (restartable_str . "\n")

    let locals = a:result[0]
    if type(locals) != type(v:null)
        let content .= "\nLocals:\n"
        let rlocals = []
        let max_name_len = 0
        for lc in locals
            let rlc = vlime#PListToDict(lc)
            call add(rlocals, rlc)
            if len(rlc['NAME']) > max_name_len
                let max_name_len = len(rlc['NAME'])
            endif
        endfor
        for rlc in rlocals
            let content .= '  '     " Indentation
            let content .= vlime#ui#Pad(rlc['NAME'], ':', max_name_len)
            let content .= (rlc['VALUE'] . "\n")
        endfor
    endif
    let catch_tags = a:result[1]
    if type(catch_tags) != type(v:null)
        let content .= "\nCatch tags:\n"
        for ct in catch_tags
            let content .= '  ' . ct . "\n"
        endfor
    endif
    call vlime#ui#ShowPreview(a:conn, content, v:false)
endfunction

function! s:ShowFrameSourceLocationCB(frame, append, conn, result)
    if a:result[0]['name'] != 'LOCATION'
        call vlime#ui#ErrMsg(a:result[1])
        return
    endif

    if a:append
        let content = ''
    else
        let content = 'Frame: ' . a:frame . "\n"
    endif
    let content .= "\nLocation:\n"
    let content .= '  File: ' . a:result[1][1] . "\n"
    let content .= '  Position: ' . a:result[2][1] . "\n"

    if type(a:result[3]) != type(v:null)
        let snippet_lines = split(a:result[3][1], "\n")
        let snippet = join(map(snippet_lines, '"    " . v:val'), "\n")
        let content .= "  Snippet:\n" . snippet . "\n"
    endif

    if a:append
        call vlime#ui#ShowPreview(a:conn, content, v:true)
    else
        call vlime#ui#ShowPreview(a:conn, content, v:false)
    endif
endfunction

function! s:OpenFrameSourceCB(edit_cmd, win_to_go, force_open, conn, result)
    try
        let src_loc = vlime#ParseSourceLocation(a:result)
        let valid_loc = vlime#GetValidSourceLocation(src_loc)
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
    elseif type(a:result) != type(v:null) && a:result[0]['name'] == 'ERROR'
        call vlime#ui#ErrMsg(a:result[1])
    else
        call vlime#ui#ErrMsg('No source available.')
    endif
endfunction

function! s:FindSourceCB(edit_cmd, win_to_go, force_open, frame, conn, msg)
    let locals = a:msg[0]
    if type(locals) == type(v:null)
        call vlime#ui#ErrMsg('No local variable.')
        return
    endif

    let options = map(copy(locals),
                \ {idx, lc ->
                    \ string(idx + 1) . '. ' . vlime#PListToDict(lc)['NAME']})
    echohl Question
    echom 'Which variable?'
    echohl None
    let nth_var = inputlist(options)

    if nth_var > 0
        call a:conn.FindSourceLocationForEmacs(['SLDB', a:frame, nth_var - 1],
                    \ function('s:OpenFrameSourceCB',
                        \ [a:edit_cmd, a:win_to_go, a:force_open]))
    else
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction

function! s:InitSLDBBuf()
    call vlime#ui#MapBufferKeys('sldb')
endfunction

function! s:FrameRestartable(frame)
    if len(a:frame) > 2
        let flags = vlime#PListToDict(a:frame[2])
        return get(flags, 'RESTARTABLE', v:false)
    endif
    return v:false
endfunction
