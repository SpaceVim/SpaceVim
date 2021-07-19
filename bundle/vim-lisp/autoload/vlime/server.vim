if !exists('g:vlime_cl_wait_time')
    let g:vlime_cl_wait_time = 10 " seconds
endif

if !exists('g:vlime_cl_wait_interval')
    let g:vlime_cl_wait_interval = 500 " milliseconds
endif

if !exists('g:vlime_servers')
    let g:vlime_servers = {}
endif

if !exists('g:vlime_next_server_id')
    let g:vlime_next_server_id = 1
endif

let s:cur_src_path = resolve(expand('<sfile>:p'))
let s:vlime_home = fnamemodify(s:cur_src_path, ':h:h:h:h')
let s:path_sep = s:cur_src_path[len(s:vlime_home)]

" vlime#server#New([auto_connect[, use_terminal[, name]]])
function! vlime#server#New(...)
    let auto_connect = get(a:000, 0, v:true)
    let use_terminal = get(a:000, 1, v:false)
    let name = get(a:000, 2, v:null)

    if type(name) != type(v:null)
        let server_name = name
    else
        let server_name = 'Vlime Server ' . g:vlime_next_server_id
    endif
    let server_buf_name = vlime#ui#ServerBufName(server_name)
    let dummy_server_buf = vlime#ui#OpenBufferWithWinSettings(server_buf_name, v:true, 'server')
    call vlime#ui#SetVlimeBufferOpts(dummy_server_buf, v:null)

    let server_obj = {
                \ 'id': g:vlime_next_server_id,
                \ 'name': server_name,
                \ }

    let server_job = vlime#compat#job_start(
                \ vlime#server#BuildServerCommand(),
                \ {
                    \ 'buf_name': server_buf_name,
                    \ 'callback': function('s:ServerOutputCB', [server_obj, auto_connect]),
                    \ 'exit_cb': function('s:ServerExitCB', [server_obj]),
                    \ 'use_terminal': use_terminal,
                \ })
    if vlime#compat#job_status(server_job) != 'run'
        call vlime#ui#WithBuffer(dummy_server_buf,
                    \ {-> s:AppendToServerBuf('Failed to start server.')})
        throw 'vlime#server#New: failed to start server job'
    endif

    let server_obj['job'] = server_job
    let g:vlime_servers[g:vlime_next_server_id] = server_obj
    let g:vlime_next_server_id += 1

    let server_buf = vlime#compat#job_getbufnr(server_job)
    call vlime#ui#WithBuffer(server_buf, function('vlime#ui#MapBufferKeys', ['server']))
    call setbufvar(server_buf, '&filetype', 'vlime_server')
    call setbufvar(server_buf, 'vlime_server', server_obj)

    return server_obj
endfunction

function! vlime#server#Stop(server)
    let server_id = s:NormalizeServerID(a:server)
    let r_server = g:vlime_servers[server_id]

    if !vlime#compat#job_stop(r_server['job'])
        call vlime#ui#ErrMsg('vlime#server#Stop: failed to stop ' . r_server['name'])
    endif
endfunction

function! vlime#server#Rename(server, new_name)
    let server_id = s:NormalizeServerID(a:server)
    let r_server = g:vlime_servers[server_id]
    let old_buf_name = vlime#ui#ServerBufName(r_server['name'])
    let r_server['name'] = a:new_name
    let old_buf = bufnr(old_buf_name)
    call vlime#ui#WithBuffer(old_buf,
                \ function('s:RenameBuffer',
                    \ [vlime#ui#ServerBufName(a:new_name)]))
endfunction

function! vlime#server#Show(server)
    let server_id = s:NormalizeServerID(a:server)
    let r_server = g:vlime_servers[server_id]
    let buf = vlime#compat#job_getbufnr(r_server['job'])
    call vlime#ui#OpenBufferWithWinSettings(buf, v:false, 'server')
    " XXX: split/vsplit commands in Vim doesn't work properly when opening
    "      terminal buffers. This is a hack for switching to the correct
    "      terminal buffer.
    if !has('nvim')
        execute 'buffer' buf
    endif
endfunction

function! vlime#server#Select()
    if len(g:vlime_servers) == 0
        call vlime#ui#ErrMsg('No server started.')
        return v:null
    endif

    let server_names = []
    for k in sort(keys(g:vlime_servers), 'n')
        let server = g:vlime_servers[k]
        let port = get(server, 'port', 0)
        call add(server_names, k . '. ' . server['name'] .
                    \ ' (' . port . ')')
    endfor

    echohl Question
    echom 'Select server:'
    echohl None
    let server_nr = inputlist(server_names)
    if server_nr == 0
        call vlime#ui#ErrMsg('Canceled.')
        return v:null
    else
        let server = get(g:vlime_servers, server_nr, v:null)
        if type(server) == type(v:null)
            call vlime#ui#ErrMsg('Invalid server ID: ' . server_nr)
            return v:null
        else
            return server
        endif
    endif
endfunction

function! vlime#server#ConnectToCurServer()
    let port = v:null
    if vlime#compat#job_status(b:vlime_server['job']) == 'run'
        let port = get(b:vlime_server, 'port', v:null)
        if type(port) == type(v:null)
            call vlime#ui#ErrMsg(b:vlime_server['name'] . ' is not ready.')
        endif
    else
        call vlime#ui#ErrMsg(b:vlime_server['name'] . ' is not running.')
    endif

    if type(port) == type(v:null)
        return
    endif

    let conn = vlime#plugin#ConnectREPL('127.0.0.1', port)
    if type(conn) != type(v:null)
        let conn.cb_data['server'] = b:vlime_server
        let conn_list = get(b:vlime_server, 'connections', {})
        let conn_list[conn.cb_data['id']] = conn
        let b:vlime_server['connections'] = conn_list
    endif
endfunction

function! vlime#server#StopCurServer()
    if type(get(g:vlime_servers, b:vlime_server['id'], v:null)) == type(v:null)
        call vlime#ui#ErrMsg(b:vlime_server['name'] . ' is not running.')
        return
    endif

    let answer = input('Stop server ' . string(b:vlime_server['name']) . '? (y/n) ')
    if tolower(answer) == 'y' || tolower(answer) == 'yes'
        call vlime#server#Stop(b:vlime_server)
    else
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction

function! vlime#server#BuildServerCommandFor_sbcl(vlime_loader, vlime_eval)
    return ['sbcl', '--load', a:vlime_loader, '--eval', a:vlime_eval]
endfunction

function! vlime#server#BuildServerCommandFor_ccl(vlime_loader, vlime_eval)
    return ['ccl', '--load', a:vlime_loader, '--eval', a:vlime_eval]
endfunction

function! vlime#server#BuildServerCommand()
    let cl_impl = exists('g:vlime_cl_impl') ? g:vlime_cl_impl : 'sbcl'
    let vlime_loader = join([s:vlime_home, 'lisp', 'load-vlime.lisp'], s:path_sep)

    let user_func_name = 'VlimeBuildServerCommandFor_' . cl_impl
    let default_func_name = 'vlime#server#BuildServerCommandFor_' . cl_impl

    if exists('*' . user_func_name)
        let Builder = function(user_func_name)
    elseif exists('*' . default_func_name)
        let Builder = function(default_func_name)
    else
        throw 'vlime#server#BuildServerCommand: implementation ' .
                    \ string(cl_impl) . ' not supported'
    endif

    return Builder(vlime_loader, '(vlime:main)')
endfunction

function! s:MatchServerCreatedPort()
    let pattern = 'Server created: (#([[:digit:][:blank:]]\+)\s\+\(\d\+\))'
    let old_pos = getcurpos()
    try
        call setpos('.', [0, 1, 1, 0, 1])
        let port_line_nr = search(pattern, 'n')
    finally
        call setpos('.', old_pos)
    endtry
    if port_line_nr > 0
        let port_line = getline(port_line_nr)
        let matched = matchlist(port_line, pattern)
        return str2nr(matched[1])
    else
        return v:null
    endif
endfunction

function! s:NormalizeServerID(id)
    if type(a:id) == v:t_dict
        return a:id['id']
    else
        return a:id
    endif
endfunction

function! s:RenameBuffer(new_name)
    " Use silent! to supress the 'Cannot rename swapfile' message on Windows
    silent! 0file
    silent! execute 'file' escape(a:new_name, ' |\''"')
endfunction

function! s:ServerOutputCB(server_obj, auto_connect, data)
    if get(a:server_obj, 'port', 0) > 0
        " TODO: unregister this callback
        return
    endif

    for line in a:data
        let matched = matchlist(line, 'Server created: (#([[:digit:][:blank:]]\+)\s\+\(\d\+\))')
        if len(matched) > 0
            let port = str2nr(matched[1])
            let a:server_obj['port'] = port
            echom 'Vlime server listening on port ' . port

            if a:auto_connect
                let auto_conn = vlime#plugin#ConnectREPL('127.0.0.1', port)
                if type(auto_conn) != type(v:null)
                    let auto_conn.cb_data['server'] = a:server_obj
                    let a:server_obj['connections'] =
                                \ {auto_conn.cb_data['id']: auto_conn}
                endif
            endif

            break
        endif
    endfor
endfunction

function! s:ServerExitCB(server_obj, exit_status)
    call remove(g:vlime_servers, a:server_obj['id'])
    echom a:server_obj['name'] . ' stopped.'

    let conn_dict = get(a:server_obj, 'connections', {})
    for conn_id in keys(conn_dict)
        call vlime#connection#Close(conn_dict[conn_id])
    endfor
    let a:server_obj['connections'] = {}
endfunction

function! s:AppendToServerBuf(content)
    setlocal modifiable
    call vlime#ui#AppendString(a:content)
    setlocal nomodifiable
endfunction
