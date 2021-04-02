function! vlime#ui#mrepl#InitMREPLBuf(conn, chan_obj)
    let mrepl_buf = bufnr(vlime#ui#MREPLBufName(a:conn, a:chan_obj), v:true)
    if !vlime#ui#VlimeBufferInitialized(mrepl_buf)
        call vlime#ui#SetVlimeBufferOpts(mrepl_buf, a:conn)
        call setbufvar(mrepl_buf, 'vlime_mrepl_channel', a:chan_obj)
        call setbufvar(mrepl_buf, '&filetype', 'vlime_mrepl')
        call vlime#ui#WithBuffer(mrepl_buf,
                    \ function('s:InitMREPLBuf', [a:conn, a:chan_obj]))
    endif
    return mrepl_buf
endfunction

function! vlime#ui#mrepl#ShowPrompt(buf, prompt)
    call vlime#ui#WithBuffer(a:buf, function('s:ShowPromptOrResult', [a:prompt]))
    if bufnr('%') == a:buf
        normal! G
        call feedkeys("\<End>", 'n')
    endif
endfunction

function! vlime#ui#mrepl#ShowResult(buf, result)
    call vlime#ui#WithBuffer(a:buf, function('s:ShowPromptOrResult', [a:result]))
endfunction

function! s:ShowPromptOrResult(content)
    let last_line = getline('$')
    if len(last_line) > 0
        call vlime#ui#AppendString("\n" . a:content)
    else
        call vlime#ui#AppendString(a:content)
    endif
endfunction

function! s:InitMREPLBuf(conn, chan_obj)
    " Excessive indentation may mess up the prompt and the result strings.
    setlocal noautoindent
    setlocal nocindent
    setlocal nosmartindent
    setlocal iskeyword=@,48-57,_,192-255,+,-,*,/,%,<,=,>,:,$,?,!,@-@,94
    setlocal omnifunc=vlime#plugin#CompleteFunc
    " TODO: Use another indentexpr that dosn't search past the last prompt
    setlocal indentexpr=vlime#plugin#CalcCurIndent()

    call s:ShowBanner(a:conn, a:chan_obj)
    call vlime#ui#MapBufferKeys('mrepl')
endfunction

function! vlime#ui#mrepl#Submit()
    let read_mode = b:vlime_mrepl_channel['mrepl']['mode']
    let insert_newline = v:true

    if read_mode == 'EVAL'
        let prompt = vlime#contrib#mrepl#BuildPrompt(b:vlime_mrepl_channel)
        let old_pos = getcurpos()
        try
            normal! G$
            let eof_pos = getcurpos()
            if (old_pos[0] < eof_pos[0]) || (old_pos[0] == eof_pos[0] && old_pos[1] <= eof_pos[1])
                let insert_newline = v:false
            endif
            let last_prompt_pos = searchpos('\V' . prompt, 'bcenW')
        finally
            call setpos('.', old_pos)
        endtry

        let last_prompt_pos[1] += 1
        let to_send = vlime#ui#GetText(last_prompt_pos, eof_pos[1:2])
    elseif read_mode == 'READ'
        let last_line = getline('$')
        let to_send = last_line . "\n"
    endif

    let msg = b:vlime_conn.EmacsChannelSend(
                \ b:vlime_mrepl_channel['mrepl']['peer'],
                \ [vlime#KW('PROCESS'), to_send])
    call b:vlime_conn.Send(msg)

    return insert_newline ? "\<CR>" : "\<Esc>GA\<CR>"
endfunction

function! vlime#ui#mrepl#Clear()
    1,$delete _
    call s:ShowBanner(b:vlime_conn, b:vlime_mrepl_channel)
    let prompt = vlime#contrib#mrepl#BuildPrompt(b:vlime_mrepl_channel)
    call vlime#ui#mrepl#ShowPrompt(bufnr('%'), prompt)
endfunction

function! vlime#ui#mrepl#Disconnect()
    let remote_chan_id = b:vlime_mrepl_channel['mrepl']['peer']
    let remote_chan = b:vlime_conn['remote_channels'][remote_chan_id]
    let remote_thread = remote_chan['mrepl']['thread']
    let cmd = [vlime#KW('EMACS-REX'),
                \ [vlime#SYM('SWANK/BACKEND', 'KILL-THREAD'),
                    \ [vlime#SYM('SWANK/BACKEND', 'FIND-THREAD'), remote_thread]],
                \ v:null, v:true]
    call b:vlime_conn.Send(cmd,
                \ function('vlime#SimpleSendCB',
                    \ [b:vlime_conn,
                        \ function('s:KillThreadComplete', [bufnr('%')]),
                        \ 'vlime#ui#mrepl#Disconnect']))
endfunction

function! vlime#ui#mrepl#Interrupt()
    let remote_chan_id = b:vlime_mrepl_channel['mrepl']['peer']
    let remote_chan = b:vlime_conn['remote_channels'][remote_chan_id]
    call b:vlime_conn.Interrupt(remote_chan['mrepl']['thread'])
    return ''
endfunction

function! s:KillThreadComplete(mrepl_buf, conn, _result)
    let local_chan = getbufvar(a:mrepl_buf, 'vlime_mrepl_channel')
    execute 'bunload!' a:mrepl_buf

    call a:conn.RemoveRemoteChannel(local_chan['mrepl']['peer'])
    call a:conn.RemoveLocalChannel(local_chan['id'])
endfunction

function! s:ShowBanner(conn, chan_obj)
    let banner = 'MREPL - SWANK'
    if has_key(a:conn.cb_data, 'version')
        let banner .= ' version ' . a:conn.cb_data['version']
    endif
    if has_key(a:conn.cb_data, 'pid')
        let banner .= ', pid ' . a:conn.cb_data['pid']
    endif
    let remote_chan_id = a:chan_obj['mrepl']['peer']
    let remote_chan_obj = a:conn['remote_channels'][remote_chan_id]
    let banner .= ', thread ' . remote_chan_obj['mrepl']['thread']
    let banner_len = len(banner)
    let banner .= ("\n" . repeat('=', banner_len) . "\n")
    call vlime#ui#AppendString(banner)
endfunction
