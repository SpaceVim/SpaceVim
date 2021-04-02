""
" @public
"
" Close the connection bound to the current buffer. If no connection is bound,
" show a menu to choose one.
function! vlime#plugin#CloseCurConnection()
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let server = get(conn.cb_data, 'server', v:null)
    if type(server) == type(v:null)
        call vlime#connection#Close(conn)
        echom conn.cb_data['name'] . ' disconnected.'
    else
        let answer = input('Also stop server ' . string(server['name']) . '? (y/n) ')
        if tolower(answer) == 'y' || tolower(answer) == 'yes'
            call vlime#server#Stop(server)
        elseif tolower(answer) == 'n' || tolower(answer) == 'no'
            call vlime#connection#Close(conn)
            echom conn.cb_data['name'] . ' disconnected.'
            call remove(server['connections'], conn.cb_data['id'])
        else
            call vlime#ui#ErrMsg('Canceled.')
        endif
    endif
endfunction

""
" @public
"
" Rename the connection bound to the current buffer. If no connection is
" bound, show a menu to choose one.
function! vlime#plugin#RenameCurConnection()
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif
    let new_name = input('New name: ', conn.cb_data['name'])
    if len(new_name) > 0
        call vlime#connection#Rename(conn, new_name)
    else
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction

""
" @public
"
" Show the output buffer for a server started by Vlime.
function! vlime#plugin#ShowSelectedServer()
    let server = vlime#server#Select()
    if type(server) == type(v:null)
        return
    endif
    call vlime#server#Show(server)
endfunction

""
" @public
"
" Stop a server started by Vlime.
function! vlime#plugin#StopSelectedServer()
    let server = vlime#server#Select()
    if type(server) == type(v:null)
        return
    endif

    let answer = input('Stop server ' . string(server['name']) . '? (y/n) ')
    if tolower(answer) == 'y' || tolower(answer) == 'yes'
        call vlime#server#Stop(server)
    else
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction

""
" @public
"
" Rename a server started by Vlime. Prompt for the new server name.
function! vlime#plugin#RenameSelectedServer()
    let server = vlime#server#Select()
    if type(server) == type(v:null)
        return
    endif
    let new_name = input('New name: ', server['name'])
    if len(new_name) > 0
        call vlime#server#Rename(server, new_name)
    else
        call vlime#ui#ErrMsg('Canceled.')
    endif
endfunction

""
" @usage [host] [port] [remote_prefix] [timeout] [name]
" @public
"
" Connect to a server, and return a connection object (see
" @dict(VlimeConnection)).
"
" [host] and [port] specify the server to connect to. If they are omitted,
" prompt for these values, using the values in |g:vlime_address| as the
" default.
" [remote_prefix], if specified, is an SFTP URL prefix, to tell Vlime to open
" remote files via SFTP (see |vlime-remote-server|).
" [timeout] is the time to wait for the connection to be made, in
" milliseconds.
" [name] gives the new connection a name. Omit this argument to use an
" automatically generated name.
function! vlime#plugin#ConnectREPL(...)
    let [def_host, def_port] = exists('g:vlime_address') ?
                \ g:vlime_address : ['127.0.0.1', 7002]
    let def_timeout = exists('g:vlime_connect_timeout') ?
                \ g:vlime_connect_timeout : v:null

    let host = get(a:000, 0, v:null)
    let port = get(a:000, 1, v:null)
    let remote_prefix = get(a:000, 2, '')
    let timeout = get(a:000, 3, def_timeout)
    let name = get(a:000, 4, v:null)

    if type(host) == type(v:null)
        let host = input('Host: ', def_host)
        if len(host) <= 0
            call vlime#ui#ErrMsg('Canceled.')
            return
        endif
    endif

    if type(port) == type(v:null)
        let port = input('Port: ', def_port)
        if len(port) <= 0
            call vlime#ui#ErrMsg('Canceled.')
            return
        endif
        let port = str2nr(port)
    endif

    if type(name) == type(v:null)
        let conn = vlime#connection#New()
    else
        let conn = vlime#connection#New(name)
    endif
    try
        call conn.Connect(host, port, remote_prefix, timeout)
    catch
        call vlime#connection#Close(conn)
        call vlime#ui#ErrMsg(v:exception)
        return v:null
    endtry
    call s:CleanUpNullBufConnections()

    let contribs = exists('g:vlime_contribs') ?
                \ g:vlime_contribs : [
                    \ 'SWANK-ASDF', 'SWANK-PACKAGE-FU',
                    \ 'SWANK-PRESENTATIONS', 'SWANK-FANCY-INSPECTOR',
                    \ 'SWANK-C-P-C', 'SWANK-ARGLISTS', 'SWANK-REPL',
                    \ 'SWANK-FUZZY']

    call s:MaybeSendSecret(conn)
    call vlime#ChainCallbacks(
                \ function(conn.ConnectionInfo, [v:true]),
                \ function('s:OnConnectionInfoComplete'),
                \ function(conn.SwankRequire, [contribs]),
                \ function('s:OnSwankRequireComplete', [v:false]),
                \ function('vlime#contrib#CallInitializers', [conn, v:null]),
                \ function('s:OnCallInitializersComplete'))
    return conn
endfunction

""
" @public
"
" Create a new REPL thread using SWANK-MREPL. This function needs the
" SWANK-MREPL contrib module. See |g:vlime_contribs| and
" @function(vlime#plugin#SwankRequire).
function! vlime#plugin#CreateMREPL()
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    if !s:ConnHasContrib(conn, 'SWANK-MREPL')
        call vlime#ui#ErrMsg('The SWANK-MREPL contrib module is not available')
        return
    endif

    call conn.CreateMREPL(v:null, function('s:OnCreateMREPLComplete'))
endfunction

""
" @public
"
" Show a menu to let you choose a connection, and bind this connection to the
" current buffer.
function! vlime#plugin#SelectCurConnection()
    let conn = vlime#connection#Select(v:false)
    if type(conn) != type(v:null)
        " XXX: Cleanup buffers & windows for the old connection?
        let b:vlime_conn = conn
    endif
endfunction

""
" @usage [content] [edit]
" @public
"
" Evaluate [content] in the REPL and show the result in the REPL buffer. If
" [content] is omitted, or [edit] is present and |TRUE|, show an input buffer.
function! vlime#plugin#SendToREPL(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [content, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ content,
                \ function('s:SendToREPLInputComplete', [conn]),
                \ 'Send to REPL: ',
                \ default,
                \ conn)
endfunction

""
" @usage [content] [policy] [edit]
" @public
"
" Compile [content], with the specified [policy], and show the result in the
" REPL buffer. If [content] is omitted or v:null, or [edit] is present and
" |TRUE|, show an input buffer. If [policy] is omitted, try to use
" |g:vlime_compiler_policy|. Open the compiler notes window when there are
" warnings or errors etc.
function! vlime#plugin#Compile(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [content, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 2, v:false),
                    \ get(a:000, 0, v:null))
    let policy = get(a:000, 1, v:null)
    let win = win_getid()
    call vlime#ui#input#MaybeInput(
                \ content,
                \ function('s:CompileInputComplete', [conn, win, policy]),
                \ 'Compile: ',
                \ default,
                \ conn)
endfunction

""
" @usage [content] [edit]
" @public
"
" Evaluate [content] and launch the inspector with the evaluation result
" loaded. If [content] is omitted, or [edit] is present and |TRUE|, show an
" input buffer.
function! vlime#plugin#Inspect(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [content, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ content,
                \ { str ->
                    \ conn.InitInspector(str,
                        \ {c, r -> c.ui.OnInspect(c, r, v:null, v:null)})},
                \ 'Inspect: ',
                \ default,
                \ conn)
endfunction

""
" @usage [func] [edit]
" @public
"
" Toggle the traced state of [func]. [func] should be a string specifying a
" plain function name, or in the form "(setf <name>)", to trace a
" setf-expander. If [func] is omitted, or [edit] is present and |TRUE|, show an
" input buffer.
"
" This function needs the SWANK-TRACE-DIALOG contrib module. See
" |g:vlime_contribs| and @function(vlime#plugin#SwankRequire).
function! vlime#plugin#DialogToggleTrace(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    if index(conn.cb_data['contribs'], 'SWANK-TRACE-DIALOG') < 0
        call vlime#ui#ErrMsg('SWANK-TRACE-DIALOG is not available.')
        return
    endif

    let [content, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ content,
                \ function('s:DialogToggleTraceInputComplete', [conn]),
                \ 'Toggle tracing: ',
                \ default,
                \ conn)
endfunction

""
" @public
"
" Show the trace dialog.
function! vlime#plugin#OpenTraceDialog()
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    if index(conn.cb_data['contribs'], 'SWANK-TRACE-DIALOG') < 0
        call vlime#ui#ErrMsg('SWANK-TRACE-DIALOG is not available.')
    endif

    call conn.ReportSpecs(function('s:OpenTraceDialogReportComplete', [v:null]))
endfunction

""
" @usage [file_name] [policy] [load] [edit]
" @public
"
" Compile a file named [file_name], with the specified [policy], and show the
" result in the REPL buffer. If [file_name] is omitted or v:null, or [edit] is
" present and |TRUE|, prompt for the file name. If [policy] is omitted, try to
" use |g:vlime_compiler_policy|. If [load] is present and |FALSE|, do not load
" the compiled file after successful compilation. Open the compiler notes
" window when there are warnings or errors etc.
function! vlime#plugin#CompileFile(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [file_name, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 3, v:false),
                    \ get(a:000, 0, v:null))
    if type(default) == type(v:null)
        let default = ''
    endif
    let policy = get(a:000, 1, v:null)
    let load = get(a:000, 2, v:true)
    let win = win_getid()
    call vlime#ui#input#MaybeInput(
                \ file_name,
                \ function('s:CompileFileInputComplete', [conn, win, policy, load]),
                \ 'Compile file: ',
                \ default,
                \ v:null,
                \ 'file')
endfunction

""
" @usage [expr] [type] [edit]
" @public
"
" Perform macro expansion on [expr] and show the result in the preview window.
" If [expr] is omitted or v:null, or [edit] is present and |TRUE|, show an
" input buffer.
"
" [type] specifies the type of expansion to perform. It can be "expand",
" "one", or "all". When it's omitted or "expand", repeatedly expand [expr]
" until the resulting form cannot be expanded anymore. When it's "one", only
" expand once. And "all" means to recursively expand all macros contained in
" [expr].
function! vlime#plugin#ExpandMacro(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [expr, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 2, v:false),
                    \ get(a:000, 0, v:null))
    let type = get(a:000, 1, v:null)

    if type(type) == type(v:null) || type == 'expand'
        let CB = { e -> conn.SwankMacroExpand(e, function('s:ShowAsyncResult'))}
    elseif type == 'all'
        let CB = { e -> conn.SwankMacroExpandAll(e, function('s:ShowAsyncResult'))}
    elseif type == 'one'
        let CB = { e -> conn.SwankMacroExpandOne(e, function('s:ShowAsyncResult'))}
    endif

    call vlime#ui#input#MaybeInput(expr, CB, 'Expand macro: ', default, conn)
endfunction

""
" @usage [content] [edit]
" @public
"
" Compile and disassemble [content]. Show the result in the preview window. If
" [content] is omitted, or [edit] is present and |TRUE|, show an input buffer.
function! vlime#plugin#DisassembleForm(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [content, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ content,
                \ { expr ->
                    \ conn.DisassembleForm(expr, function('s:ShowAsyncResult'))},
                \ 'Disassemble: ',
                \ default,
                \ conn)
endfunction

""
" @usage [file_name] [edit]
" @public
"
" Load a file named [file_name]. If [file_name] is omitted, or [edit] is
" present and |TRUE|, prompt for the file name.
function! vlime#plugin#LoadFile(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [file_name, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    if type(default) == type(v:null)
        let default = ''
    endif
    call vlime#ui#input#MaybeInput(
                \ file_name,
                \ { fname ->
                    \ conn.LoadFile(fname, function('s:OnLoadFileComplete', [fname]))},
                \ 'Load file: ',
                \ default,
                \ v:null,
                \ 'file')
endfunction

""
" @usage [pkg]
" @public
"
" Bind a Common Lisp package [pkg] to the current buffer. If [pkg] is omitted,
" show an input buffer.
function! vlime#plugin#SetPackage(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let pkg = get(a:000, 0, v:null)
    let cur_pkg = conn.GetCurrentPackage()
    call vlime#ui#input#MaybeInput(
                \ pkg,
                \ { p -> conn.SetPackage(p)},
                \ 'Set package: ',
                \ cur_pkg[0],
                \ conn)
endfunction

""
" @usage {contribs} [do_init]
" @public
"
" Require Swank contrib modules. {contribs} should be a plain string or a list
" of strings. Each string is a contrib module name. These names are
" case-sensitive. Normally you should use uppercase. If [do_init] is present
" and |FALSE|, suppress initialization for newly loaded contrib modules.
function! vlime#plugin#SwankRequire(contribs, ...)
    let do_init = get(a:000, 0, v:true)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif
    call conn.SwankRequire(a:contribs,
                \ function('s:OnSwankRequireComplete', [do_init]))
endfunction

""
" @usage [op] [edit]
" @public
"
" Show the arglist description for operator [op] in the arglist window. If
" [op] is omitted, or [edit] is present and |TRUE|, show an input buffer.
function! vlime#plugin#ShowOperatorArgList(...)
    let conn = vlime#connection#Get(v:true)
    if type(conn) == type(v:null)
        return
    endif

    let [operator, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ operator,
                \ { op ->
                    \ conn.OperatorArgList(op, function('s:OnOperatorArgListComplete', [op]))},
                \ 'Arglist for operator: ',
                \ default,
                \ conn)
endfunction

""
" @public
"
" Show the arglist description for the current expression and cursor position,
" in the arglist window. If the SWANK-ARGLISTS contrib module is available,
" the current argument will be marked in the arglist.
function! vlime#plugin#CurAutodoc()
    let conn = vlime#connection#Get(v:true)
    if type(conn) == type(v:null)
        return
    endif

    if s:ConnHasContrib(conn, 'SWANK-ARGLISTS')
        let raw_form = vlime#ui#CurRawForm(
                    \ get(g:, 'vlime_autodoc_max_level', 5),
                    \ get(g:, 'vlime_autodoc_max_lines', 50))
        if s:NeedToShowArgList(raw_form)
            let autodoc_cache = get(s:, 'autodoc_cache', {})
            let cached_result = get(autodoc_cache, string(raw_form), v:null)
            if type(cached_result) == type(v:null)
                let quoted_raw_form = [{'package': 'COMMON-LISP', 'name': 'QUOTE'}, raw_form]
                let margin = s:GetArgListWinWidth()
                if type(margin) != type(v:null) &&
                            \ (&number || &relativenumber) &&
                            \ margin > &numberwidth
                    let margin -= &numberwidth
                endif
                call conn.Autodoc(quoted_raw_form, margin,
                            \ function('s:OnCurAutodocComplete', [raw_form]))
            else
                call vlime#ui#ShowArgList(conn, cached_result)
            endif
        endif
    else
        let op = vlime#ui#SurroundingOperator()
        if s:NeedToShowArgList(op)
            call vlime#plugin#ShowOperatorArgList(op)
        endif
    endif
endfunction

""
" @usage [symbol] [edit]
" @public
"
" Show a description for [symbol] in the preview window. If [symbol] is
" omitted, or [edit] is present and |TRUE|, show an input buffer.
function! vlime#plugin#DescribeSymbol(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [symbol, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ symbol,
                \ { sym ->
                    \ conn.DescribeSymbol(sym, function('s:ShowAsyncResult'))},
                \ 'Describe symbol: ',
                \ default,
                \ conn)
endfunction

""
" @usage {ref_type} [sym] [edit]
" @public
"
" Lookup cross references for [sym], and show the results in the xref window.
" If [sym] is omitted, or [edit] is present and |TRUE|, show an input buffer.
" See @function(VlimeConnection.XRef) for possible values for {ref_type}.
function! vlime#plugin#XRefSymbol(ref_type, ...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [sym, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    let win = win_getid()
    call vlime#ui#input#MaybeInput(
                \ sym,
                \ { s ->
                    \ conn.XRef(a:ref_type, s, function('s:OnXRefComplete', [win]))},
                \ 'XRef symbol: ',
                \ default,
                \ conn)
endfunction

""
" @public
"
" A wrapper function for @function(vlime#plugin#XRefSymbol) and
" @function(vlime#plugin#FindDefinition). Pick the type of cross reference
" interactively.
function! vlime#plugin#XRefSymbolWrapper()
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let ref_types = ['calls', 'calls-who', 'references', 'binds', 'sets', 'macroexpands', 'specializes', 'definition']

    if v:count > 0
        let answer = v:count
    else
        let options = []
        let i = 0
        while i < len(ref_types)
            call add(options, string(i + 1) . '. ' . ref_types[i])
            let i += 1
        endwhile

        echohl Question
        echom 'What kind of xref?'
        echohl None
        let answer = inputlist(options)
    endif

    if answer <= 0
        call vlime#ui#ErrMsg('Canceled.')
        return
    elseif answer > len(ref_types)
        call vlime#ui#ErrMsg('Invalid xref type: ' . answer)
        return
    endif

    let rtype = ref_types[answer - 1]
    if rtype == 'definition'
        call vlime#plugin#FindDefinition()
    else
        call vlime#plugin#XRefSymbol(toupper(rtype))
    endif
endfunction

""
" @usage [sym] [edit]
" @public
"
" Find the definition for [sym], and show the results in the xref window. If
" [sym] is omitted, or [edit] is present and |TRUE|, show an input buffer.
function! vlime#plugin#FindDefinition(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [sym, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    let win = win_getid()
    call vlime#ui#input#MaybeInput(
                \ sym,
                \ { s ->
                    \ conn.FindDefinitionsForEmacs(s, function('s:OnXRefComplete', [win]))},
                \ 'Definition of symbol: ',
                \ default,
                \ conn)
endfunction

""
" @usage [pattern] [edit]
" @public
"
" Apropos search for [pattern]. Show the results in the preview window. If
" [pattern] is omitted, or [edit] is present and |TRUE|, show an input buffer.
function! vlime#plugin#AproposList(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [pattern, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ pattern,
                \ { pattern ->
                    \ conn.AproposListForEmacs(
                        \ pattern, v:false, v:false, v:null,
                        \ function('s:OnAproposListComplete'))},
                \ 'Apropos search: ',
                \ default,
                \ conn)
endfunction

""
" @usage [symbol] [edit]
" @public
"
" Show the documentation for [symbol] in the preview window. If [symbol] is
" omitted, or [edit] is present and |TRUE|, show an input buffer.
function! vlime#plugin#DocumentationSymbol(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [symbol, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ symbol,
                \ { sym ->
                    \ conn.DocumentationSymbol(sym, function('s:ShowAsyncResult'))},
                \ 'Documentation for symbol: ',
                \ default,
                \ conn)
endfunction

""
" @usage [sym] [edit]
" @public
"
" Set a breakpoint at entry to a function with the name [sym]. If [sym] is
" omitted, or [edit] is present and |TRUE|, show an input buffer.
function! vlime#plugin#SetBreakpoint(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [symbol, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ symbol,
                \ { sym ->
                    \ conn.SLDBBreak(sym, function('s:OnSLDBBreakComplete'))},
                \ 'Set breakpoint at function: ',
                \ default,
                \ conn)
endfunction

""
" @public
"
" Show the thread list window.
function! vlime#plugin#ListThreads()
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    call conn.ListThreads(function('s:OnListThreadsComplete'))
endfunction

""
" @usage [sym] [edit]
" @public
"
" Undefine a function with the name [sym]. If [sym] is omitted, or [edit] is
" present and |TRUE|, show an input buffer.
function! vlime#plugin#UndefineFunction(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [symbol, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ symbol,
                \ { sym ->
                    \ conn.UndefineFunction(sym, function('s:OnUndefineFunctionComplete'))},
                \ 'Undefine function: ',
                \ default,
                \ conn)
endfunction

""
" @usage [sym] [edit]
" @public
"
" Unintern a symbol [sym]. If [sym] is omitted, or [edit] is present and
" |TRUE|, show an input buffer.
function! vlime#plugin#UninternSymbol(...)
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    let [symbol, default] =
                \ s:InputCheckEditFlag(
                    \ get(a:000, 1, v:false),
                    \ get(a:000, 0, v:null))
    call vlime#ui#input#MaybeInput(
                \ symbol,
                \ function('s:UninternSymbolInputComplete', [conn]),
                \ 'Unintern symbol: ',
                \ default,
                \ conn)
endfunction

""
" @public
"
" A wrapper function for @function(vlime#plugin#UndefineFunction) and
" @function(vlime#plugin#UninternSymbol). Pick the type of action to perform
" interactively.
function! vlime#plugin#UndefineUninternWrapper()
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    if v:count > 0
        let answer = v:count
    else
        let options = ['1. Undefine a function', '2. Unintern a symbol']
        echohl Question
        echom 'What to do?'
        echohl None
        let answer = inputlist(options)
    endif

    if answer <= 0
        call vlime#ui#ErrMsg('Canceled.')
    elseif answer == 1
        call vlime#plugin#UndefineFunction()
    elseif answer == 2
        call vlime#plugin#UninternSymbol()
    else
        call vlime#ui#ErrMsg('Invalid action: ' . answer)
    endif
endfunction

""
" @usage [win_name]
" @public
"
" Close Vlime special windows. [win_name] is the type of windows to close. See
" @function(vlime#ui#GetWindowList) for valid values for [win_name]. If
" [win_name] is omitted, show a menu to let you choose which window to close.
function! vlime#plugin#CloseWindow(...)
    let win_name = get(a:000, 0, v:null)
    if type(win_name) == type(v:null)
        let win_list = vlime#ui#GetWindowList(v:null, '')
        if len(win_list) <= 0
            call vlime#ui#ErrMsg('Cannot find any Vlime window.')
            return
        endif

        let win_choices = []
        let idx = 1
        for [winid, bufname] in win_list
            call add(win_choices, idx . '. ' . bufname . ' (' . winid . ')')
            let idx += 1
        endfor

        echohl Question
        echom 'Which window to close?'
        echohl None
        let idx = inputlist(win_choices)
        if idx <= 0
            call vlime#ui#ErrMsg('Canceled.')
        else
            let idx -= 1
            if idx >= len(win_list)
                call vlime#ui#ErrMsg('Invalid window number: ' . idx)
            else
                let winnr = win_id2win(win_list[idx][0])
                execute winnr . 'wincmd c'
            endif
        endif
    else
        call vlime#ui#CloseWindow(v:null, win_name)
    endif
endfunction

""
" @public
"
" The completion function. This function is meant to be used as |omnifunc| or
" |completefunc|. It is asynchronous, and will NOT return the completion list
" immediately.
function! vlime#plugin#CompleteFunc(findstart, base)
    let start_col = s:CompleteFindStart()
    if a:findstart
        return start_col
    endif

    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return -1
    endif

    let cur_pos = [bufnr('%')] + getcurpos()[1:2]
    " Hairy detail: Vim may move the cursor before the second call of this
    " function. We make up the difference here.
    let cur_pos[2] += len(a:base)

    if s:ConnHasContrib(conn, 'SWANK-FUZZY')
        call conn.FuzzyCompletions(a:base,
                    \ function('s:OnFuzzyCompletionsComplete', [start_col + 1, cur_pos]))
    else
        call conn.SimpleCompletions(a:base,
                    \ function('s:OnSimpleCompletionsComplete', [start_col + 1, cur_pos]))
    endif
    " Actual completions are found in s:OnFuzzyCompletionsComplete(...)
    " XXX: The refresh option doesn't work, why?
    return {'words': [], 'refresh': 'always'}
endfunction

function! vlime#plugin#VlimeKey(key)
    let key = tolower(a:key)
    if key == 'space' || key == 'cr'
        if get(g:, 'vlime_enable_autodoc', v:false)
            call vlime#plugin#CurAutodoc()
        else
            let op = vlime#ui#SurroundingOperator()
            if s:NeedToShowArgList(op)
                call vlime#plugin#ShowOperatorArgList(op)
            endif
        endif
    elseif key == 'tab'
        let line = getline('.')
        let spaces = vlime#ui#CalcLeadingSpaces(line, v:true)
        let col = virtcol('.')
        if col <= spaces + 1
            let indent = vlime#plugin#CalcCurIndent()
            if spaces < indent
                call vlime#ui#IndentCurLine(indent)
            else
                return "\<tab>"
            endif
        else
            return "\<c-x>\<c-o>"
        endif
    else
        throw 'vlime#plugin#VlimeKey: Unknown key: ' . a:key
    endif
    return ''
endfunction

if !exists('g:vlime_default_indent_keywords')
    let g:vlime_default_indent_keywords = {
                \ 'defun': 2,
                \ 'defmacro': 2,
                \ 'defgeneric': 2,
                \ 'defmethod': 2,
                \ 'deftype': 2,
                \ 'lambda': 1,
                \ 'if': 1,
                \ 'unless': 1,
                \ 'when': 1,
                \ 'case': 1,
                \ 'ecase': 1,
                \ 'typecase': 1,
                \ 'etypecase': 1,
                \ 'eval-when': 1,
                \ 'let': 1,
                \ 'let*': 1,
                \ 'flet': 1,
                \ 'labels': 1,
                \ 'macrolet': 1,
                \ 'symbol-macrolet': 1,
                \ 'do': 2,
                \ 'do*': 2,
                \ 'do-all-symbols': 1,
                \ 'do-external-symbols': 1,
                \ 'do-symbols': 1,
                \ 'dolist': 1,
                \ 'dotimes': 1,
                \ 'destructuring-bind': 2,
                \ 'multiple-value-bind': 2,
                \ 'prog1': 1,
                \ 'progv': 2,
                \ 'with-input-from-string': 1,
                \ 'with-output-to-string': 1,
                \ 'with-open-file': 1,
                \ 'with-open-stream': 1,
                \ 'with-package-iterator': 1,
                \ 'unwind-protect': 1,
                \ 'handler-bind': 1,
                \ 'handler-case': 1,
                \ 'restart-bind': 1,
                \ 'restart-case': 1,
                \ 'with-simple-restart': 1,
                \ 'with-slots': 2,
                \ 'with-accessors': 2,
                \ 'print-unreadable-object': 1,
                \ }
endif

""
" @usage [shift_width]
" @public
"
" Calculate the indent size for the current line, in number of <space>
" characters. [shift_width] is the size for one indent level, defaults to 2 if
" omitted.
function! vlime#plugin#CalcCurIndent(...)
    let shift_width = get(a:000, 0, 2)
    let line_no = line('.')

    let conn = vlime#connection#Get(v:true)

    " The deepest special forms this function can handle are FLET/LABELS,
    " which are of depth 3, thus the magic number "3" here.
    let op_list = vlime#ui#ParseOuterOperators(3)
    if len(op_list) <= 0
        return lispindent(line_no)
    endif

    let vs_col = virtcol(op_list[0][2])

    let a_count = v:null

    " 1. Special forms such as FLET
    let a_count = s:IndentCheckSpecialForms(op_list)

    if type(a_count) == type(v:null)
        let matches = matchlist(op_list[0][0],
                    \ '\(\([^:|]\+\||[^|]\+|\):\{1,2}\)\?\([^:|]\+\||[^|]\+|\)$')
        if len(matches) == 0
            return lispindent(line_no)
        endif
        let op = tolower(s:NormalizeIdentifierForIndentInfo(matches[3]))
    endif

    " 2. User defined indent keywords
    if type(a_count) == type(v:null) && exists('g:vlime_indent_keywords')
        let a_count = get(g:vlime_indent_keywords, op, v:null)
    endif

    " 3. Swank-provided indent keywords
    if type(a_count) == type(v:null) && type(conn) != type(v:null)
        let op_pkg = toupper(s:NormalizeIdentifierForIndentInfo(matches[2]))
        if len(op_pkg) == 0 && type(conn) != type(v:null)
            let op_pkg = conn.GetCurrentPackage()
            if type(op_pkg) == v:t_list
                let op_pkg = op_pkg[0]
            endif
        endif

        let indent_info = get(conn.cb_data, 'indent_info', {})
        if has_key(indent_info, op) && index(indent_info[op][1], op_pkg) >= 0
            let a_count = indent_info[op][0]
        endif
    endif

    " 4. Default indent keywords
    if type(a_count) == type(v:null)
        let a_count = get(g:vlime_default_indent_keywords, op, v:null)
    endif

    if type(a_count) == v:t_number
        if a_count < 0
            return lispindent(line_no)
        endif

        let arg_pos = op_list[0][1]
        if arg_pos > a_count
            return vs_col + shift_width - 1
        elseif arg_pos > 0
            return vs_col + shift_width * 2 - 1
        else
            return lispindent(line_no)
        endif
    elseif type(a_count) == v:t_list
        return vs_col + a_count[1] - 1
    else
        return lispindent(line_no)
    endif
endfunction

""
" @usage [force]
" @public
"
" Set up Vlime for the current buffer. Do nothing if the current buffer is
" already initialized. If [force] is present and |TRUE|, always perform the
" initialization.
function! vlime#plugin#Setup(...)
    let force = get(a:000, 0, v:false)

    if !force && exists('b:vlime_setup') && b:vlime_setup
        return
    endif
    let b:vlime_setup = v:true

    if exists('g:vlime_overlay') &&
                \ type(g:vlime_overlay) == v:t_string &&
                \ len(g:vlime_overlay) > 0
        let OverlayInitCB = function('vlime#overlay#' . g:vlime_overlay . '#Init')
        call OverlayInitCB()
    endif

    setlocal omnifunc=vlime#plugin#CompleteFunc
    setlocal indentexpr=vlime#plugin#CalcCurIndent()

    call vlime#ui#MapBufferKeys('lisp')
endfunction

""
" @public
"
" Toggle interaction mode.
function! vlime#plugin#InteractionMode()
    if getbufvar(bufnr('%'), 'vlime_interaction_mode', v:false)
        let b:vlime_interaction_mode = v:false
        nnoremap <buffer> <cr> <cr>
        vnoremap <buffer> <cr> <cr>
        echom 'Interaction mode disabled.'
    else
        let b:vlime_interaction_mode = v:true
        nnoremap <buffer> <silent> <cr> :call vlime#plugin#SendToREPL(vlime#ui#CurExprOrAtom())<cr>
        vnoremap <buffer> <silent> <cr> :<c-u>call vlime#plugin#SendToREPL(vlime#ui#CurSelection())<cr>
        echom 'Interaction mode enabled.'
    endif
endfunction

function! s:NormalizeIdentifierForIndentInfo(ident)
    let ident_len = len(a:ident)
    if ident_len >= 2 && a:ident[0] == '|' && a:ident[ident_len-1] == '|'
        return strpart(a:ident, 1, ident_len - 2)
    else
        return a:ident
    endif
endfunction

function! s:CompleteFindStart()
    let col = col('.') - 1
    let line = getline('.')
    while col > 0 && match(line[col-1], '\_s\|[()#;"'']') < 0
        let col -= 1
    endwhile
    return col
endfunction

function! s:ConnHasContrib(conn, contrib)
    return has_key(a:conn.cb_data, 'contribs') &&
                \ index(a:conn.cb_data['contribs'], a:contrib) >= 0
endfunction

function! s:OnCallInitializersComplete(conn)
    echom a:conn.cb_data['name'] . ' established.'
endfunction

function! s:OnSwankRequireComplete(do_init, conn, result)
    let new_contribs = (type(a:result) == type(v:null)) ? [] : a:result
    let old_contribs = get(a:conn.cb_data, 'contribs', [])
    let a:conn.cb_data['contribs'] = new_contribs

    if a:do_init
        let added = []
        for co in new_contribs
            if index(old_contribs, co) < 0
                call add(added, co)
            endif
        endfor

        call vlime#contrib#CallInitializers(a:conn, added,
                    \ function('s:OnSwankRequireCallInitializersComplete', [added]))
    endif
endfunction

function! s:OnSwankRequireCallInitializersComplete(added, conn)
    echom 'Loaded contrib modules: ' . string(a:added)
endfunction

function! s:OnConnectionInfoComplete(conn, result)
    let a:conn.cb_data['version'] = get(a:result, 'VERSION', '<unkown version>')
    let a:conn.cb_data['pid'] = get(a:result, 'PID', '<unknown pid>')
    let features = get(a:result, 'FEATURES', [])
    if type(features) == type(v:null)
        let features = []
    endif
    let a:conn.cb_data['features'] = copy(features)
endfunction

function! s:OnFuzzyCompletionsComplete(col, cur_pos, conn, result)
    let cur_pos = [bufnr('%')] + getcurpos()[1:2]
    if a:cur_pos != cur_pos
        " The cursor moved, abort.
        return
    endif

    let comps = a:result[0]
    if type(comps) == type(v:null)
        let comps = []
    endif
    let r_comps = []
    for c in comps
        let cobj = {'word': c[0],'menu': c[3]}
        call add(r_comps, cobj)
    endfor

    try
        call complete(a:col, r_comps)
    catch /^Vim\%((\a\+)\)\=:E785/  " complete() can only be used in Insert mode
        " There's nothing we can do. Just ignore it.
    endtry
endfunction

function! s:OnSimpleCompletionsComplete(col, cur_pos, conn, result)
    let cur_pos = [bufnr('%')] + getcurpos()[1:2]
    if a:cur_pos != cur_pos
        " The cursor moved, abort.
        return
    endif

    let comps = a:result[0]
    if type(comps) == type(v:null)
        let comps = []
    endif

    try
        call complete(a:col, comps)
    catch /^Vim\%((\a\+)\)\=:E785/  " complete() can only be used in Insert mode
        " There's nothing we can do. Just ignore it.
    endtry
endfunction

function! s:OnOperatorArgListComplete(sym, conn, result)
    if type(a:result) == type(v:null)
        return
    endif
    call vlime#ui#ShowArgList(a:conn, a:result)
    let s:last_imode_arglist_op = a:sym
endfunction

function! s:OnCurAutodocComplete(raw_form, conn, result)
    if type(a:result) == v:t_list && type(a:result[0]) == v:t_string
        call vlime#ui#ShowArgList(a:conn, a:result[0])
        if type(a:result[1]) != type(v:null) && a:result[1]
            let autodoc_cache = get(s:, 'autodoc_cache', {})
            let cache_limit = 1024
            if len(autodoc_cache) >= cache_limit
                let keys = keys(autodoc_cache)
                while len(keys) >= cache_limit
                    let idx = vlime#Rand() % len(keys)
                    call remove(cache, remove(keys, idx))
                endwhile
            endif
            let autodoc_cache[string(a:raw_form)] = a:result[0]
            let s:autodoc_cache = autodoc_cache
        endif
        let s:last_imode_arglist_op = a:raw_form
    endif
endfunction

function! s:OnLoadFileComplete(fname, conn, result)
    echom 'Loaded: ' . a:fname
    call s:ResetArgListState()
endfunction

function! s:OnXRefComplete(orig_win, conn, result)
    if type(a:conn.ui) != type(v:null)
        call a:conn.ui.OnXRef(a:conn, a:result, a:orig_win)
    endif
endfunction

function! s:OnAproposListComplete(conn, result)
    if type(a:result) == type(v:null)
        call vlime#ui#ShowPreview(a:conn, 'No result found.', v:false)
    else
        let content = ''
        for item in a:result
            let item_dict = vlime#PListToDict(item)
            let content .= item_dict['DESIGNATOR']
            let flags = map(filter(keys(item_dict), {f -> f != 'DESIGNATOR'}), {i, f -> tolower(f)})
            if len(flags) > 0
                let content .= ' ('
                let content .= join(flags, ', ')
                let content .= ')'
            endif
            let content .= "\n"
        endfor
        call vlime#ui#ShowPreview(a:conn, content, v:false)
    endif
endfunction

function! s:OnSLDBBreakComplete(conn, result)
    echom 'Breakpoint set.'
endfunction

function! s:OnCompilationComplete(orig_win, conn, result)
    let [_msg_type, notes, successp, duration, loadp, faslfile] = a:result
    if successp
        echom 'Compilation finished in ' . string(duration) . ' second(s)'
        if loadp && type(faslfile) != v:null
            call a:conn.LoadFile(faslfile, function('s:OnLoadFileComplete', [faslfile]))
        endif
    else
        call vlime#ui#ErrMsg('Compilation failed.')
    endif

    if type(a:conn.ui) != type(v:null)
        call a:conn.ui.OnCompilerNotes(a:conn, notes, a:orig_win)
    endif
endfunction

function! s:OnListThreadsComplete(conn, result)
    if type(a:conn.ui) != type(v:null)
        call a:conn.ui.OnThreads(a:conn, a:result)
    endif
endfunction

function! s:OnUndefineFunctionComplete(conn, result)
    echom 'Undefined function ' . a:result
endfunction

function! s:OnUninternSymbolComplete(conn, result)
    echom a:result
endfunction

function! s:OnListenerEvalComplete(conn, result)
    if type(a:result) == v:t_list && len(a:result) > 0 &&
                \ type(a:result[0]) == v:t_dict && a:result[0]['name'] == 'VALUES' &&
                \ type(a:conn.ui) != type(v:null)
        let values = a:result[1:]
        if len(values) > 0
            for val in values
                call a:conn.ui.OnWriteString(
                            \ a:conn,
                            \ val . "\n",
                            \ {'name': 'REPL-RESULT', 'package': 'KEYWORD'})
            endfor
        else
            call a:conn.ui.OnWriteString(
                        \ a:conn,
                        \ "; No value\n",
                        \ {'name': 'REPL-RESULT', 'package': 'KEYWORD'})
        endif
    endif

    call s:ResetArgListState()
endfunction

function! s:OpenTraceDialogReportComplete(specs, conn, result)
    if type(a:specs) == type(v:null)
        let new_specs = (type(a:result) == type(v:null)) ? [] : a:result
        call a:conn.ReportTotal(function('s:OpenTraceDialogReportComplete', [new_specs]))
    else
        call a:conn.ui.OnTraceDialog(a:conn, a:specs, a:result)
    endif
endfunction

function! s:OnDialogToggleTraceComplete(conn, result)
    let trace_visible = v:false
    let trace_buffer_name = vlime#ui#TraceDialogBufName(a:conn)
    let trace_bufnr = bufnr(trace_buffer_name)
    if trace_bufnr >= 0
        let trace_visible = len(win_findbuf(trace_bufnr)) > 0
    endif

    if trace_visible
        call vlime#ui#WithBuffer(trace_bufnr,
                    \ function('vlime#ui#trace_dialog#RefreshSpecs'))
    endif

    echom a:result
endfunction

function! s:OnCreateMREPLComplete(conn, result)
    let chan_id = a:result[0]
    let remote_chan = a:conn['remote_channels'][chan_id]
    let local_chan = a:conn['local_channels'][remote_chan['mrepl']['peer']]
    call a:conn.ui.OnMREPLPrompt(a:conn, local_chan)
    let mrepl_winnr = bufwinnr(vlime#ui#MREPLBufName(a:conn, local_chan))
    if mrepl_winnr >= 0
        execute mrepl_winnr . 'wincmd w'
        normal! G$
    endif
endfunction

function! s:ShowAsyncResult(conn, result)
    call vlime#ui#ShowPreview(a:conn, a:result, v:false)
endfunction

function! s:SendToREPLInputComplete(conn, content)
    call a:conn.ui.OnWriteString(a:conn, "--\n", {'name': 'REPL-SEP', 'package': 'KEYWORD'})
    call a:conn.WithThread({'name': 'REPL-THREAD', 'package': 'KEYWORD'},
                \ function(a:conn.ListenerEval, [a:content, function('s:OnListenerEvalComplete')]))
endfunction

function! s:CompileInputComplete(conn, win, policy, content)
    if type(a:content) == v:t_list
        let str = a:content[0]
        let [str_line, str_col] = a:content[1]

        let buf = bufnr('%')
        let cur_byte = line2byte(str_line) + str_col - 1
        let cur_file = expand('%:p')
    elseif type(a:content) == v:t_string
        let str = a:content
    endif

    if type(a:policy) != type(v:null)
        let policy = a:policy
    elseif exists('g:vlime_compiler_policy')
        let policy = g:vlime_compiler_policy
    else
        let policy = v:null
    endif

    call a:conn.ui.OnWriteString(a:conn, "--\n", {'name': 'REPL-SEP', 'package': 'KEYWORD'})

    if type(a:content) == v:t_string
        call a:conn.CompileStringForEmacs(
                    \ str, v:null, 1, v:null,
                    \ policy, function('s:OnCompilationComplete', [a:win]))
    else
        call a:conn.CompileStringForEmacs(
                    \ str, buf, cur_byte, cur_file,
                    \ policy, function('s:OnCompilationComplete', [a:win]))
    endif
endfunction

function! s:CompileFileInputComplete(conn, win, policy, load, file_name)
    if type(a:policy) != type(v:null)
        let policy = a:policy
    elseif exists('g:vlime_compiler_policy')
        let policy = g:vlime_compiler_policy
    else
        let policy = v:null
    endif

    call a:conn.ui.OnWriteString(a:conn, "--\n", {'name': 'REPL-SEP', 'package': 'KEYWORD'})
    call a:conn.CompileFileForEmacs(a:file_name, a:load, policy,
                \ function('s:OnCompilationComplete', [a:win]))
endfunction

function! s:UninternSymbolInputComplete(conn, sym)
    let matched = matchlist(a:sym, '\(\([^:]\+\)\?::\?\)\?\(\k\+\)')
    if len(matched) > 0
        let sym_name = matched[3]
        let sym_pkg = matched[2]
        if matched[1] == ':'
            let sym_pkg = 'KEYWORD'
        elseif matched[1] == ''
            " Use the current package
            let sym_pkg = v:null
        endif
        call a:conn.UninternSymbol(sym_name, sym_pkg,
                    \ function('s:OnUninternSymbolComplete'))
    endif
endfunction

function! s:DialogToggleTraceInputComplete(conn, func_spec)
    call a:conn.DialogToggleTrace(a:func_spec,
                \ function('s:OnDialogToggleTraceComplete'))
endfunction

function! s:CleanUpNullBufConnections()
    let old_buf = bufnr('%')
    try
        bufdo! if exists('b:vlime_conn') && type(b:vlime_conn) == type(v:null)
                    \ | unlet b:vlime_conn | endif
    finally
        execute 'hide buffer' old_buf
    endtry
endfunction

if !exists('s:last_imode_arglist_op')
    let s:last_imode_arglist_op = ''
endif

function! s:NeedToShowArgList(op)
    " Note that {op} may be a string or a list
    if len(a:op) > 0
        let arglist_buf = bufnr(vlime#ui#ArgListBufName())
        let arglist_win_nr = bufwinnr(arglist_buf)
        let arglist_visible = (arglist_win_nr >= 0)
        if !arglist_visible || type(a:op) != type(s:last_imode_arglist_op) ||
                    \ a:op != s:last_imode_arglist_op
            return !!v:true
        else
            let conn = vlime#connection#Get(v:true)
            if type(conn) == type(v:null)
                " The current buffer doesn't have an active connection.
                " Close the arglist window explicitly, to avoid confusion.
                execute arglist_win_nr . 'wincmd c'
                return !!v:false
            else
                " If the current connection is different with the connection
                " used in arglist_buf, the arglist needs a refresh.
                let arglist_conn = getbufvar(
                            \ arglist_buf, 'vlime_conn',
                            \ {'cb_data': {'id': -1}})
                return conn.cb_data['id'] != arglist_conn.cb_data['id']
            endif
        endif
    else
        return !!v:false
    endif
endfunction

" Clear the cacehd states of the arglist. Should be called after an operation
" that potentially changes function signatures, e.g. loading a file or sending
" something to the REPL.
function! s:ResetArgListState()
    let s:autodoc_cache = {}
    let s:last_imode_arglist_op = ''
endfunction

function! s:GetArgListWinWidth()
    let arglist_buf = bufnr(vlime#ui#ArgListBufName())
    let arglist_win_nr = bufwinnr(arglist_buf)
    if arglist_win_nr >= 0
        return winwidth(arglist_win_nr)
    else
        return v:null
    endif
endfunction

function! s:MaybeSendSecret(conn)
    if exists('g:vlime_secret_file')
        let secret_file = g:vlime_secret_file
    else
        let script_path = expand('<sfile>:p')
        let script_dir = fnamemodify(script_path, ':h')
        let path_sep = script_path[len(script_dir)]
        let secret_file = join([$HOME, '.slime-secret'], path_sep)
    endif

    if filereadable(secret_file)
        let content = readfile(secret_file, '', 1)
        let secret = len(content) > 0 ? content[0] : ''
        call a:conn.Send([vlime#KW('VLIME-RAW-MSG'), secret])
    endif
endfunction

function! s:InputCheckEditFlag(edit, text)
    return a:edit ? [v:null, a:text] : [a:text, v:null]
endfunction

let s:local_func_op_list = ['flet', 'labels', 'macrolet']

function! s:IndentCheckSpecialForms(op_list)
    if len(a:op_list) >= 3 &&
                \ a:op_list[1][0] == '' &&
                \ index(s:local_func_op_list, a:op_list[2][0], 0, v:true) >= 0 &&
                \ a:op_list[2][1] == 1
        " function definitions in FLET etc.
        return 1
    elseif len(a:op_list) >= 2 &&
                \ tolower(a:op_list[0][0]) == ':method' &&
                \ tolower(a:op_list[1][0]) == 'defgeneric' &&
                \ a:op_list[1][1] >= 3
        " method definitions in DEFGENERIC
        return 1
    elseif len(a:op_list) >= 2 &&
                \ tolower(a:op_list[1][0]) == 'handler-case' &&
                \ a:op_list[1][1] >= 2
        " condition clauses in HANDLER-CASE
        return 1
    elseif len(a:op_list) >= 2 &&
                \ tolower(a:op_list[1][0]) == 'cond' &&
                \ len(a:op_list[0][0]) > 0 &&
                \ a:op_list[0][1] == 1
        " COND clauses with atomic test forms, such as (t ...)
        return ['rel', 1]
    else
        return v:null
    endif
endfunction
