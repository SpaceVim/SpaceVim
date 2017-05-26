function! SpaceVim#layers#lang#lisp#plugins() abort
    let plugins = []
    call add(plugins,['l04m33/vlime', {'on_ft' : 'lisp', 'rtp': 'vim'}])
    return plugins
endfunction


function! SpaceVim#layers#lang#lisp#config() abort
    "lisp            Normal Lisp source file.
    "vlime_sldb      The debugger buffer.
    "vlime_repl      The REPL buffer.
    "vlime_inspector The inspector buffer.
    "vlime_xref      The cross reference buffer.
    "vlime_notes     The compiler notes buffer.
    "vlime_threads   The threads buffer.
    "vlime_server    The server output buffer.
    "vlime_preview   The preview buffer.
    "vlime_arglist   The arglist buffer.
    "vlime_input     The input buffer.
    augroup LocalVlimeKeys
        autocmd!
        autocmd FileType lisp call s:lisp()
        autocmd FileType vlime_sldb call s:vlime_sldb()
        autocmd FileType vlime_repl call s:vlime_repl()
        autocmd FileType vlime_inspector call s:vlime_inspector()
        autocmd FileType vlime_xref call s:vlime_xref()
        autocmd FileType vlime_notes call s:vlime_notes()
        autocmd FileType vlime_threads call s:vlime_threads()
        autocmd FileType vlime_server call s:vlime_server()
        autocmd FileType vlime_preview call s:vlime_preview()
        autocmd FileType vlime_arglist call s:vlime_arglist()
        autocmd FileType vlime_input call s:vlime_input()
    augroup end
endfunction


fu! s:lisp()
    let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
    let g:_spacevim_mappings_space.l.c = {'name' : '+Connection Management'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'c'], "call VlimeConnectREPL()", 'Connect to Vlime server', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 's'], "call VlimeSelectCurConnection()", 'Switch Vlime connections', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'd'], "call VlimeCloseCurConnection()", 'Disconnect', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'R'], "call VlimeRenameCurConnection()", 'Rename the current connection', 1)

    let g:_spacevim_mappings_space.l.r = {'name' : '+Server Management'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'r'], "call VlimeNewServer()", 'Run a new Vlime server and connect to it', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'v'], "call VlimeShowSelectedServer()", 'View the console output of a server', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'R'], "call VlimeRenameSelectedServer()", 'Rename a server', 1)

    let g:_spacevim_mappings_space.l.s = {'name' : '+Sending Stuff To The REPL'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','s','s'], "call VlimeSendToREPL(vlime#ui#CurExprOrAtom())",
                \ 'Send s-expr or atom under the cursor to REPL', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','s','e'], "call VlimeSendToREPL(vlime#ui#CurExpr())",
                \ 'Send s-expr under the cursor to REPL', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','s','t'], "VlimeSendToREPL(vlime#ui#CurTopExpr())",
                \ 'Send to-level s-expr under the cursor to REPL', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','s','a'], "call VlimeSendToREPL(vlime#ui#CurAtom())",
                \ 'Send atom under the cursor to REPL', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','s','i'], "call VlimeSendToREPL()",
                \ 'Open vlime input buffer for REPL', 1)
    call SpaceVim#mapping#space#langSPC('vmap', ['l','s','v'], "call VlimeSendToREPL(vlime#ui#CurSelection())",
                \ 'Send the current selection to the REPL', 1)

    let g:_spacevim_mappings_space.l.m = {'name' : '+Expanding Macros'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','m','l'], "call VlimeExpandMacro(vlime#ui#CurExpr(), v:false)",
                \ 'Expand the macro under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','m','a'], "call VlimeExpandMacro(vlime#ui#CurExpr(), v:true)",
                \ 'Expand the macro under the cursor and all nested macros', 1)

    let g:_spacevim_mappings_space.l.o = {'name' : '+Compiling'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','o','e'], "call VlimeCompile(vlime#ui#CurExpr(v:true))",
                \ 'Compile the form under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','o','t'], "call VlimeCompile(vlime#ui#CurTopExpr(v:true))",
                \ 'Compile the top-level form under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','o','f'], "call VlimeCompileFile(expand('%:p'))",
                \ 'Compile the current file', 1)
    call SpaceVim#mapping#space#langSPC('vmap', ['l','o','v'], "call VlimeCompile(vlime#ui#CurSelection(v:true))",
                \ 'Compile the current selection', 1)

endf

fu! s:vlime_sldb()
endf
fu! s:vlime_repl()
endf
fu! s:vlime_inspector()
endf
fu! s:vlime_xref()
endf
fu! s:vlime_notes()
endf
fu! s:vlime_threads()
endf
fu! s:vlime_server()
endf
fu! s:vlime_preview()
endf
fu! s:vlime_arglist()
endf
fu! s:vlime_input()
endf
