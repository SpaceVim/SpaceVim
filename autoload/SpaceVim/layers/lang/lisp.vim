"=============================================================================
" lisp.vim --- SpaceVim lang#lisp layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#lisp#plugins() abort
    let plugins = []
    call add(plugins,['l04m33/vlime', {'on_ft' : 'lisp', 'rtp': 'vim'}])
    return plugins
endfunction


function! SpaceVim#layers#lang#lisp#config() abort
    let g:vlime_default_mappings = {
                \ 'lisp': [
                \ ['i', '<Space>', '<Space><c-r>=VlimeKey("space")<cr>'],
                \ ['i', '<cr>', '<cr><c-r>=VlimeKey("cr")<cr>'],
                \ ['i', '<tab>', '<c-r>=VlimeKey("tab")<cr>'],
                \
                \ ['n', '<LocalLeader>wp', ':call VlimeCloseWindow("preview")<cr>'],
                \ ['n', '<LocalLeader>wr', ':call VlimeCloseWindow("arglist")<cr>'],
                \ ['n', '<LocalLeader>wn', ':call VlimeCloseWindow("notes")<cr>'],
                \ ['n', '<LocalLeader>wR', ':call VlimeCloseWindow("repl")<cr>'],
                \ ['n', '<LocalLeader>wA', ':call VlimeCloseWindow("")<cr>'],
                \ ['n', '<LocalLeader>wl', ':call VlimeCloseWindow()<cr>'],
                \
                \ ['n', '<LocalLeader>i', ':call VlimeInteractionMode()<cr>'],
                \ ['n', '<LocalLeader>l', ':call VlimeLoadFile(expand("%:p"))<cr>'],
                \ ['n', '<LocalLeader>a', ':call VlimeDisassembleForm(vlime#ui#CurExpr())<cr>'],
                \ ['n', '<LocalLeader>p', ':call VlimeSetPackage()<cr>'],
                \ ['n', '<LocalLeader>b', ':call VlimeSetBreakpoint()<cr>'],
                \ ['n', '<LocalLeader>t', ':call VlimeListThreads()<cr>'],
                \ ],
                \
                \ 'sldb': [
                \ ['n', '<cr>', ':call vlime#ui#sldb#ChooseCurRestart()<cr>'],
                \ ['n', 'd', ':call vlime#ui#sldb#ShowFrameDetails()<cr>'],
                \ ['n', 'S', ':<c-u>call vlime#ui#sldb#OpenFrameSource()<cr>'],
                \ ['n', 'T', ':call vlime#ui#sldb#OpenFrameSource("tabedit")<cr>'],
                \ ['n', 'r', ':call vlime#ui#sldb#RestartCurFrame()<cr>'],
                \ ['n', 's', ':call vlime#ui#sldb#StepCurOrLastFrame("step")<cr>'],
                \ ['n', 'x', ':call vlime#ui#sldb#StepCurOrLastFrame("next")<cr>'],
                \ ['n', 'o', ':call vlime#ui#sldb#StepCurOrLastFrame("out")<cr>'],
                \ ['n', 'c', ':call b:vlime_conn.SLDBContinue()<cr>'],
                \ ['n', 'a', ':call b:vlime_conn.SLDBAbort()<cr>'],
                \ ['n', 'C', ':call vlime#ui#sldb#InspectCurCondition()<cr>'],
                \ ['n', 'i', ':call vlime#ui#sldb#InspectInCurFrame()<cr>'],
                \ ['n', 'e', ':call vlime#ui#sldb#EvalStringInCurFrame()<cr>'],
                \ ['n', 'D', ':call vlime#ui#sldb#DisassembleCurFrame()<cr>'],
                \ ['n', 'R', ':call vlime#ui#sldb#ReturnFromCurFrame()<cr>'],
                \ ],
                \
                \ 'repl': [
                \ ['n', '<c-c>', ':call b:vlime_conn.Interrupt({"name": "REPL-THREAD", "package": "KEYWORD"})<cr>'],
                \ ['n', '<LocalLeader>I', ':call vlime#ui#repl#InspectCurREPLPresentation()<cr>'],
                \ ['n', '<LocalLeader>y', ':call vlime#ui#repl#YankCurREPLPresentation()<cr>'],
                \ ['n', '<LocalLeader>C', ':call vlime#ui#repl#ClearREPLBuffer()<cr>'],
                \ ],
                \
                \ 'inspector': [
                \ ['n', ['<cr>', '<Space>'], ':call vlime#ui#inspector#InspectorSelect()<cr>'],
                \ ['n', ['<c-n>', '<tab>'], ':call vlime#ui#inspector#NextField(v:true)<cr>'],
                \ ['n', '<c-p>', ':call vlime#ui#inspector#NextField(v:false)<cr>'],
                \ ['n', 'p', ':call vlime#ui#inspector#InspectorPop()<cr>'],
                \ ['n', 'R', ':call b:vlime_conn.InspectorReinspect({c, r -> c.ui.OnInspect(c, r, v:null, v:null)})<cr>'],
                \ ],
                \
                \ 'xref': [
                \ ['n', '<cr>', ':<c-u>call vlime#ui#xref#OpenCurXref()<cr>'],
                \ ['n', 't', ':<c-u>call vlime#ui#xref#OpenCurXref(v:true, "tabedit")<cr>'],
                \ ['n', 's', ':<c-u>call vlime#ui#xref#OpenCurXref(v:true, "split")<cr>'],
                \ ['n', 'S', ':<c-u>call vlime#ui#xref#OpenCurXref(v:true, "vsplit")<cr>'],
                \ ],
                \
                \ 'notes': [
                \ ['n', '<cr>', ':<c-u>call vlime#ui#compiler_notes#OpenCurNote()<cr>'],
                \ ['n', 't', ':<c-u>call vlime#ui#compiler_notes#OpenCurNote("tabedit")<cr>'],
                \ ['n', 's', ':<c-u>call vlime#ui#compiler_notes#OpenCurNote("split")<cr>'],
                \ ['n', 'S', ':<c-u>call vlime#ui#compiler_notes#OpenCurNote("vsplit")<cr>'],
                \ ],
                \
                \ 'threads': [
                \ ['n', '<c-c>', ':call vlime#ui#threads#InterruptCurThread()<cr>'],
                \ ['n', 'K', ':call vlime#ui#threads#KillCurThread()<cr>'],
                \ ['n', 'D', ':call vlime#ui#threads#DebugCurThread()<cr>'],
                \ ['n', 'r', ':call vlime#ui#threads#Refresh()<cr>'],
                \ ],
                \
                \ 'server': [
                \ ['n', '<LocalLeader>c', ':call VlimeConnectToCurServer()<cr>'],
                \ ['n', '<LocalLeader>s', ':call VlimeStopCurServer()<cr>'],
                \ ],
                \
                \ 'input': [
                \ ['n', '<c-p>', ':call vlime#ui#input#NextHistoryItem("backward")<cr>'],
                \ ['n', '<c-n>', ':call vlime#ui#input#NextHistoryItem("forward")<cr>'],
                \ ],
                \ }
    call SpaceVim#mapping#space#regesit_lang_mappings('lisp', function('s:lisp'))
    augroup LocalVlimeKeys
        autocmd!
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


fu! s:lisp() abort
    let g:_spacevim_mappings_space.l.c = {'name' : '+Connection Management'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'c'], 'call VlimeConnectREPL()', 'Connect to Vlime server', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 's'], 'call VlimeSelectCurConnection()', 'Switch Vlime connections', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'd'], 'call VlimeCloseCurConnection()', 'Disconnect', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'R'], 'call VlimeRenameCurConnection()', 'Rename the current connection', 1)

    let g:_spacevim_mappings_space.l.r = {'name' : '+Server Management'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'r'], 'call VlimeNewServer()', 'Run a new Vlime server and connect to it', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'v'], 'call VlimeShowSelectedServer()', 'View the console output of a server', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'R'], 'call VlimeRenameSelectedServer()', 'Rename a server', 1)

    let g:_spacevim_mappings_space.l.s = {'name' : '+Sending Stuff To The REPL'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','s','s'], 'call VlimeSendToREPL(vlime#ui#CurExprOrAtom())',
                \ 'Send s-expr or atom under the cursor to REPL', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','s','e'], 'call VlimeSendToREPL(vlime#ui#CurExpr())',
                \ 'Send s-expr under the cursor to REPL', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','s','t'], 'VlimeSendToREPL(vlime#ui#CurTopExpr())',
                \ 'Send to-level s-expr under the cursor to REPL', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','s','a'], 'call VlimeSendToREPL(vlime#ui#CurAtom())',
                \ 'Send atom under the cursor to REPL', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','s','i'], 'call VlimeSendToREPL()',
                \ 'Open vlime input buffer for REPL', 1)
    call SpaceVim#mapping#space#langSPC('vmap', ['l','s','v'], 'call VlimeSendToREPL(vlime#ui#CurSelection())',
                \ 'Send the current selection to the REPL', 1)

    let g:_spacevim_mappings_space.l.m = {'name' : '+Expanding Macros'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','m','l'], 'call VlimeExpandMacro(vlime#ui#CurExpr(), v:false)',
                \ 'Expand the macro under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','m','a'], 'call VlimeExpandMacro(vlime#ui#CurExpr(), v:true)',
                \ 'Expand the macro under the cursor and all nested macros', 1)

    let g:_spacevim_mappings_space.l.o = {'name' : '+Compiling'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','o','e'], 'call VlimeCompile(vlime#ui#CurExpr(v:true))',
                \ 'Compile the form under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','o','t'], 'call VlimeCompile(vlime#ui#CurTopExpr(v:true))',
                \ 'Compile the top-level form under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','o','f'], "call VlimeCompileFile(expand('%:p'))",
                \ 'Compile the current file', 1)
    call SpaceVim#mapping#space#langSPC('vmap', ['l','o','v'], 'call VlimeCompile(vlime#ui#CurSelection(v:true))',
                \ 'Compile the current selection', 1)

    let g:_spacevim_mappings_space.l.x = {'name' : '+Cross references'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','x','c'], "call VlimeXRefSymbol('CALLS', vlime#ui#CurAtom())",
                \ 'Show callers of the function under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','x','C'], "call VlimeXRefSymbol('CALLS-WHO', vlime#ui#CurAtom())",
                \ 'Show callees of the function under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','x','r'], 'call VlimeXRefSymbol("REFERENCES", vlime#ui#CurAtom())',
                \ 'Show references of the variable under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','x','b'], 'call VlimeXRefSymbol("BINDS", vlime#ui#CurAtom())',
                \ 'Show bindings of the variable under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','x','s'], 'call VlimeXRefSymbol("SETS", vlime#ui#CurAtom())',
                \ 'Show who sets the value of the variable under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','x','e'], 'call VlimeXRefSymbol("MACROEXPANDS", vlime#ui#CurAtom())',
                \ 'Show who expands the macro under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','x','m'], 'call VlimeXRefSymbol("SPECIALIZES", vlime#ui#CurAtom())',
                \ 'Show specialized methods for the class under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','x','d'], 'call VlimeFindDefinition(vlime#ui#CurAtom())',
                \ 'Show the definition for the name under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','x','i'], 'call VlimeXRefSymbolWrapper()',
                \ 'Interactively prompt for the symbol to search', 1)

    let g:_spacevim_mappings_space.l.d = {'name' : '+Describing things'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','d','o'], 'call VlimeDescribeSymbol(vlime#ui#CurOperator())',
                \ 'Describe the "operator"', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','d','a'], 'call VlimeDescribeSymbol(vlime#ui#CurAtom())',
                \ 'Describe the atom under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','d','i'], 'call VlimeDescribeSymbol()',
                \ 'Prompt for the symbol to describe', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','d','s'], 'call VlimeAproposList()',
                \ 'apropos search', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','d','r'], 'call VlimeShowOperatorArgList(vlime#ui#CurOperator())',
                \ 'Show the arglist for the s-expression under the cursor', 1)

    let g:_spacevim_mappings_space.l.d.d = {'name' : '+Documentation'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','d','d', 'o'], 'call VlimeDocumentationSymbol(vlime#ui#CurOperator())',
                \ 'Show the documentation for the "operator"', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','d','d', 'a'], 'call VlimeDocumentationSymbol(vlime#ui#CurAtom())',
                \ 'Show the documentation for atom', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','d','d', 'i'], 'call VlimeDocumentationSymbol()',
                \ 'Show the documentation for the symbol entered in an input buffer', 1)

    let g:_spacevim_mappings_space.l.u = {'name' : '+Undefining'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','u','f'], 'call VlimeUndefineFunction(vlime#ui#CurAtom())',
                \ 'Undefine the function under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','u','s'], 'call VlimeUninternSymbol(vlime#ui#CurAtom())',
                \ 'Unintern the symbol under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','u','i'], 'call VlimeUndefineUninternWrapper()',
                \ 'Interactively prompt for the function/symbol to undefine/unintern', 1)

    let g:_spacevim_mappings_space.l.I = {'name' : '+Inspection'}
    call SpaceVim#mapping#space#langSPC('nmap', ['l','I','i'], 'call VlimeInspect(vlime#ui#CurExprOrAtom())',
                \ 'evaluate the s-expr or atom under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','I','e'], 'call VlimeInspect(vlime#ui#CurExpr())',
                \ 'evaluate and inspect the s-expr under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','I','t'], 'call VlimeInspect(vlime#ui#CurTopExpr())',
                \ 'evaluate and inspect the top-level s-expr under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','I','a'], 'call VlimeInspect(vlime#ui#CurAtom())',
                \ 'Evaluate and inspect the atom under the cursor', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','I','n'], 'call VlimeInspect()',
                \ 'Prompt for the expression to inspect', 1)
endf

fu! s:vlime_sldb() abort
endf
fu! s:vlime_repl() abort
endf
fu! s:vlime_inspector() abort
endf
fu! s:vlime_xref() abort
endf
fu! s:vlime_notes() abort
endf
fu! s:vlime_threads() abort
endf
fu! s:vlime_server() abort
endf
fu! s:vlime_preview() abort
endf
fu! s:vlime_arglist() abort
endf
fu! s:vlime_input() abort
endf
