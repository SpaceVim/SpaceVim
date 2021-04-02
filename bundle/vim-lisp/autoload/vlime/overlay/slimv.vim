function! vlime#overlay#slimv#SendToREPL(content)
    if v:register != '"' && v:register != '+'
        call setreg(v:register, a:content)
    endif
    call vlime#plugin#SendToREPL(a:content)
endfunction

function! vlime#overlay#slimv#CurTopExprOrAtom()
    let expr = vlime#ui#CurTopExpr()
    if len(expr) <= 0
        let expr = vlime#ui#CurAtom()
    endif
    return expr
endfunction

function! vlime#overlay#slimv#SendSelection()
    if v:register == '"' || v:register == '+'
        call vlime#plugin#SendToREPL(vlime#ui#CurSelection())
    else
        call vlime#plugin#SendToREPL(getreg(v:register))
    endif
endfunction

function! vlime#overlay#slimv#CompileSelection()
    if v:register == '"' || v:register == '+'
        call vlime#plugin#Compile(vlime#ui#CurSelection(v:true))
    else
        call vlime#plugin#Compile(getreg(v:register))
    endif
endfunction

function! vlime#overlay#slimv#UntraceAll()
    let conn = vlime#connection#Get()
    if type(conn) == type(v:null)
        return
    endif

    call conn.DialogUntraceAll(function('s:DialogUntraceAllComplete'))
endfunction

if exists('mapleader') && len(mapleader) > 0
    let s:slimv_leader = '<Leader>'
else
    let s:slimv_leader = ','
endif
let s:slimv_leader = get(g:, 'slimv_leader', s:slimv_leader)
let s:slimv_keybindings = get(g:, 'slimv_keybindings', 1)
if s:slimv_keybindings == 1
    let s:slimv_src_mappings = [
                \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("lisp")<cr>',
                    \ 'Show this quick reference.'],
                \
                \ ['i', '<tab>', '<c-r>=vlime#plugin#VlimeKey("tab")<cr>',
                    \ 'Trigger omni-completion.'],
                \ ['i', '<space>', '<space><c-r>=vlime#plugin#VlimeKey("space")<cr>',
                    \ 'Trigger the arglist hint.'],
                \ ['i', '<cr>', '<cr><c-r>=vlime#plugin#VlimeKey("cr")<cr>',
                    \ 'Trigger the arglist hint.'],
                \
                \ ['n', s:slimv_leader.'c', ':call vlime#plugin#ConnectREPL()<cr>',
                    \ 'Connect to a server.'],
                \ ['n', [s:slimv_leader.'Cs', s:slimv_leader.'CS'], ':call vlime#plugin#SelectCurConnection()<cr>',
                    \ 'Switch connections.'],
                \ ['n', [s:slimv_leader.'Cd', s:slimv_leader.'CD'], ':call vlime#plugin#CloseCurConnection()<cr>',
                    \ 'Disconnect.'],
                \ ['n', [s:slimv_leader.'Cr', s:slimv_leader.'CR'], ':call vlime#plugin#RenameCurConnection()<cr>',
                    \ 'Rename the current connection.'],
                \
                \ ['n', s:slimv_leader.'j', ':call vlime#plugin#FindDefinition(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show the definition for the name under the cursor.'],
                \
                \ ['n', s:slimv_leader.'d', ':call vlime#overlay#slimv#SendToREPL(vlime#overlay#slimv#CurTopExprOrAtom())<cr>',
                    \ 'Send the top-level expression under the cursor to the REPL.'],
                \ ['n', s:slimv_leader.'e', ':call vlime#overlay#slimv#SendToREPL(vlime#ui#CurExprOrAtom())<cr>',
                    \ 'Send the expression under the cursor to the REPL.'],
                \ ['v', s:slimv_leader.'r', ':<c-u>call vlime#overlay#slimv#SendToREPL(vlime#ui#CurSelection())<cr>',
                    \ 'Send the current selection to the REPL.'],
                \ ['n', s:slimv_leader.'r', ':call vlime#overlay#slimv#SendSelection()<cr>',
                    \ 'Send the last selection, or the content in a register, to the REPL.'],
                \ ['n', s:slimv_leader.'b', ':call vlime#plugin#SendToREPL(vlime#ui#CurBufferContent(v:true))<cr>',
                    \ 'Send the current buffer to the REPL.'],
                \ ['n', s:slimv_leader.'v', ':call vlime#plugin#SendToREPL()<cr>',
                    \ 'Send a snippet to the REPL.'],
                \ ['n', s:slimv_leader.'u', ':call vlime#plugin#UndefineFunction(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Undefine the function under the cursor.'],
                \
                \ ['n', s:slimv_leader.'1', ':call vlime#plugin#ExpandMacro(vlime#ui#CurExpr(), "one")<cr>',
                    \ 'Expand the macro under the cursor once.'],
                \ ['n', s:slimv_leader.'m', ':call vlime#plugin#ExpandMacro(vlime#ui#CurExpr(), "all")<cr>',
                    \ 'Expand the macro under the cursor and all nested macros.'],
                \
                \ ['n', s:slimv_leader.'t', ':call vlime#plugin#DialogToggleTrace(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Trace/untrace the function under the cursor.'],
                \ ['n', s:slimv_leader.'T', ':call vlime#overlay#slimv#UntraceAll()<cr>',
                    \ 'Untrace all functions.'],
                \ ['n', s:slimv_leader.'o', ':call vlime#plugin#OpenTraceDialog()<cr>',
                    \ 'Show the trace dialog.'],
                \
                \ ['n', s:slimv_leader.'B', ':call vlime#plugin#SetBreakpoint(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Set a breakpoint at entry to a function.'],
                \ ['n', s:slimv_leader.'l', ':call vlime#plugin#DisassembleForm("''" . vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Disassemble the function under the cursor.'],
                \ ['n', s:slimv_leader.'i', ':call vlime#plugin#Inspect(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Evaluate the atom under the cursor, and inspect the result.'],
                \ ['v', s:slimv_leader.'i', ':<c-u>call vlime#plugin#Inspect(vlime#ui#CurSelection())<cr>',
                    \ 'Evaluate the current selection, and inspect the result.'],
                \
                \ ['n', s:slimv_leader.'H', ':call vlime#plugin#ListThreads()<cr>',
                    \ 'Show a list of the running threads.'],
                \
                \ ['n', s:slimv_leader.'D', ':call vlime#plugin#Compile(vlime#ui#CurTopExpr(v:true))<cr>',
                    \ 'Compile the top-level expression under the cursor.'],
                \ ['n', s:slimv_leader.'L', ':call vlime#plugin#CompileFile(expand("%:p"))<cr>',
                    \ 'Compile and load the current file.'],
                \ ['n', s:slimv_leader.'F', ':call vlime#plugin#CompileFile(expand("%:p"), v:null, v:false)<cr>',
                    \ 'Compile the current file.'],
                \ ['v', s:slimv_leader.'R', ':<c-u>call vlime#plugin#Compile(vlime#ui#CurSelection())<cr>',
                    \ 'Compile the current selection.'],
                \ ['n', s:slimv_leader.'R', ':call vlime#overlay#slimv#CompileSelection()<cr>',
                    \ 'Compile the last selection, or the content of a register'],
                \
                \ ['n', s:slimv_leader.'xr', ':call vlime#plugin#XRefSymbol("REFERENCES", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show references to the variable under the cursor.'],
                \ ['n', s:slimv_leader.'xs', ':call vlime#plugin#XRefSymbol("SETS", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show locations where the variable under the cursor is set.'],
                \ ['n', s:slimv_leader.'xb', ':call vlime#plugin#XRefSymbol("BINDS", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show bindings for the variable under the cursor.'],
                \ ['n', s:slimv_leader.'xm', ':call vlime#plugin#XRefSymbol("MACROEXPANDS", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show locations where the macro under the cursor is called.'],
                \ ['n', s:slimv_leader.'xp', ':call vlime#plugin#XRefSymbol("SPECIALIZES", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show specialized methods for the class under the cursor.'],
                \ ['n', s:slimv_leader.'xl', ':call vlime#plugin#XRefSymbol("CALLS", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show callers of the function under the cursor.'],
                \ ['n', s:slimv_leader.'xe', ':call vlime#plugin#XRefSymbol("CALLS-WHO", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show callees of the function under the cursor.'],
                \ ['n', s:slimv_leader.'xi', ':<c-u>call vlime#plugin#XRefSymbolWrapper()<cr>',
                    \ 'Interactively prompt for the symbol to search for cross references.'],
                \
                \ ['n', s:slimv_leader.'s', ':call vlime#plugin#DescribeSymbol(vlime#ui#CurAtom())<cr>',
                    \ 'Describe the atom under the cursor.'],
                \ ['n', s:slimv_leader.'A', ':call vlime#plugin#AproposList(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Apropos search.'],
                \
                \ ['n', s:slimv_leader.'g', ':call vlime#plugin#SetPackage()<cr>',
                    \ 'Specify the package for the current buffer.'],
                \
                \ ['n', [s:slimv_leader.'Ss', s:slimv_leader.'SS'], ':call vlime#server#New()<cr>',
                    \ 'Start a new server and connect to it.'],
                \ ['n', [s:slimv_leader.'Sv', s:slimv_leader.'SV'], ':call vlime#plugin#ShowSelectedServer()<cr>',
                    \ 'View the console output of a server.'],
                \ ['n', [s:slimv_leader.'St', s:slimv_leader.'ST'], ':call vlime#plugin#StopSelectedServer()<cr>',
                    \ 'Stop a server.'],
                \ ['n', [s:slimv_leader.'Sr', s:slimv_leader.'SR'], ':call vlime#plugin#RenameSelectedServer()<cr>',
                    \ 'Rename a server.'],
                \
                \ ['n', s:slimv_leader.'wp', ':call vlime#plugin#CloseWindow("preview")<cr>',
                    \ 'Close all visible preview windows.'],
                \ ['n', s:slimv_leader.'wr', ':call vlime#plugin#CloseWindow("arglist")<cr>',
                    \ 'Close all visible arglist windows.'],
                \ ['n', s:slimv_leader.'wn', ':call vlime#plugin#CloseWindow("notes")<cr>',
                    \ 'Close all visible compiler notes windows.'],
                \ ['n', s:slimv_leader.'wR', ':call vlime#plugin#CloseWindow("repl")<cr>',
                    \ 'Close all visible REPL windows.'],
                \ ['n', s:slimv_leader.'wA', ':call vlime#plugin#CloseWindow("")<cr>',
                    \ 'Close all Vlime windows.'],
                \ ['n', s:slimv_leader.'wl', ':call vlime#plugin#CloseWindow()<cr>',
                    \ 'Show a list of visible Vlime windows, and choose which to close.'],
                \ ]
elseif s:slimv_keybindings == 2
    let s:slimv_src_mappings = [
                \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("lisp")<cr>',
                    \ 'Show this quick reference.'],
                \
                \ ['i', '<tab>', '<c-r>=vlime#plugin#VlimeKey("tab")<cr>',
                    \ 'Trigger omni-completion.'],
                \ ['i', '<space>', '<space><c-r>=vlime#plugin#VlimeKey("space")<cr>',
                    \ 'Trigger the arglist hint.'],
                \ ['i', '<cr>', '<cr><c-r>=vlime#plugin#VlimeKey("cr")<cr>',
                    \ 'Trigger the arglist hint.'],
                \
                \ ['n', s:slimv_leader.'rc', ':call vlime#plugin#ConnectREPL()<cr>',
                    \ 'Connect to a server.'],
                \ ['n', s:slimv_leader.'rs', ':call vlime#plugin#SelectCurConnection()<cr>',
                    \ 'Switch connections.'],
                \ ['n', s:slimv_leader.'rd', ':call vlime#plugin#CloseCurConnection()<cr>',
                    \ 'Disconnect.'],
                \ ['n', s:slimv_leader.'rr', ':call vlime#plugin#RenameCurConnection()<cr>',
                    \ 'Rename the current connection.'],
                \
                \ ['n', s:slimv_leader.'fd', ':call vlime#plugin#FindDefinition(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show the definition for the name under the cursor.'],
                \
                \ ['n', s:slimv_leader.'ed', ':call vlime#overlay#slimv#SendToREPL(vlime#overlay#slimv#CurTopExprOrAtom())<cr>',
                    \ 'Send the top-level expression under the cursor to the REPL.'],
                \ ['n', s:slimv_leader.'ee', ':call vlime#overlay#slimv#SendToREPL(vlime#ui#CurExprOrAtom())<cr>',
                    \ 'Send the expression under the cursor to the REPL.'],
                \ ['v', s:slimv_leader.'er', ':<c-u>call vlime#overlay#slimv#SendToREPL(vlime#ui#CurSelection())<cr>',
                    \ 'Send the current selection to the REPL.'],
                \ ['n', s:slimv_leader.'er', ':call vlime#overlay#slimv#SendSelection()<cr>',
                    \ 'Send the last selection, or the content in a register, to the REPL.'],
                \ ['n', s:slimv_leader.'eb', ':call vlime#plugin#SendToREPL(vlime#ui#CurBufferContent(v:true))<cr>',
                    \ 'Send the current buffer to the REPL.'],
                \ ['n', s:slimv_leader.'ei', ':call vlime#plugin#SendToREPL()<cr>',
                    \ 'Send a snippet to the REPL.'],
                \ ['n', s:slimv_leader.'eu', ':call vlime#plugin#UndefineFunction(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Undefine the function under the cursor.'],
                \
                \ ['n', s:slimv_leader.'m1', ':call vlime#plugin#ExpandMacro(vlime#ui#CurExpr(), "one")<cr>',
                    \ 'Expand the macro under the cursor once.'],
                \ ['n', s:slimv_leader.'ma', ':call vlime#plugin#ExpandMacro(vlime#ui#CurExpr(), "all")<cr>',
                    \ 'Expand the macro under the cursor and all nested macros.'],
                \
                \ ['n', s:slimv_leader.'dt', ':call vlime#plugin#DialogToggleTrace(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Trace/untrace the function under the cursor.'],
                \ ['n', s:slimv_leader.'du', ':call vlime#overlay#slimv#UntraceAll()<cr>',
                    \ 'Untrace all functions.'],
                \ ['n', s:slimv_leader.'do', ':call vlime#plugin#OpenTraceDialog()<cr>',
                    \ 'Show the trace dialog.'],
                \
                \ ['n', s:slimv_leader.'db', ':call vlime#plugin#SetBreakpoint(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Set a breakpoint at entry to a function.'],
                \ ['n', s:slimv_leader.'dd', ':call vlime#plugin#DisassembleForm("''" . vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Disassemble the function under the cursor.'],
                \ ['n', s:slimv_leader.'di', ':call vlime#plugin#Inspect(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Evaluate the atom under the cursor, and inspect the result.'],
                \ ['v', s:slimv_leader.'di', ':<c-u>call vlime#plugin#Inspect(vlime#ui#CurSelection())<cr>',
                    \ 'Evaluate the current selection, and inspect the result.'],
                \
                \ ['n', s:slimv_leader.'dl', ':call vlime#plugin#ListThreads()<cr>',
                    \ 'Show a list of the running threads.'],
                \
                \ ['n', s:slimv_leader.'cd', ':call vlime#plugin#Compile(vlime#ui#CurTopExpr(v:true))<cr>',
                    \ 'Compile the top-level expression under the cursor.'],
                \ ['n', s:slimv_leader.'cl', ':call vlime#plugin#CompileFile(expand("%:p"))<cr>',
                    \ 'Compile and load the current file.'],
                \ ['n', s:slimv_leader.'cf', ':call vlime#plugin#CompileFile(expand("%:p"), v:null, v:false)<cr>',
                    \ 'Compile the current file.'],
                \ ['v', s:slimv_leader.'cr', ':<c-u>call vlime#plugin#Compile(vlime#ui#CurSelection())<cr>',
                    \ 'Compile the current selection.'],
                \ ['n', s:slimv_leader.'cr', ':call vlime#overlay#slimv#CompileSelection()<cr>',
                    \ 'Compile the last selection, or the content of a register'],
                \
                \ ['n', s:slimv_leader.'xr', ':call vlime#plugin#XRefSymbol("REFERENCES", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show references to the variable under the cursor.'],
                \ ['n', s:slimv_leader.'xs', ':call vlime#plugin#XRefSymbol("SETS", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show locations where the variable under the cursor is set.'],
                \ ['n', s:slimv_leader.'xb', ':call vlime#plugin#XRefSymbol("BINDS", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show bindings for the variable under the cursor.'],
                \ ['n', s:slimv_leader.'xm', ':call vlime#plugin#XRefSymbol("MACROEXPANDS", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show locations where the macro under the cursor is called.'],
                \ ['n', s:slimv_leader.'xp', ':call vlime#plugin#XRefSymbol("SPECIALIZES", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show specialized methods for the class under the cursor.'],
                \ ['n', s:slimv_leader.'xl', ':call vlime#plugin#XRefSymbol("CALLS", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show callers of the function under the cursor.'],
                \ ['n', s:slimv_leader.'xe', ':call vlime#plugin#XRefSymbol("CALLS-WHO", vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Show callees of the function under the cursor.'],
                \ ['n', s:slimv_leader.'xi', ':<c-u>call vlime#plugin#XRefSymbolWrapper()<cr>',
                    \ 'Interactively prompt for the symbol to search for cross references.'],
                \
                \ ['n', s:slimv_leader.'ds', ':call vlime#plugin#DescribeSymbol(vlime#ui#CurAtom())<cr>',
                    \ 'Describe the atom under the cursor.'],
                \ ['n', s:slimv_leader.'da', ':call vlime#plugin#AproposList(vlime#ui#CurAtom(), v:true)<cr>',
                    \ 'Apropos search.'],
                \
                \ ['n', s:slimv_leader.'rp', ':call vlime#plugin#SetPackage()<cr>',
                    \ 'Specify the package for the current buffer.'],
                \
                \ ['n', [s:slimv_leader.'Ss', s:slimv_leader.'SS'], ':call vlime#server#New()<cr>',
                    \ 'Start a new server and connect to it.'],
                \ ['n', [s:slimv_leader.'Sv', s:slimv_leader.'SV'], ':call vlime#plugin#ShowSelectedServer()<cr>',
                    \ 'View the console output of a server.'],
                \ ['n', [s:slimv_leader.'St', s:slimv_leader.'ST'], ':call vlime#plugin#StopSelectedServer()<cr>',
                    \ 'Stop a server.'],
                \ ['n', [s:slimv_leader.'Sr', s:slimv_leader.'SR'], ':call vlime#plugin#RenameSelectedServer()<cr>',
                    \ 'Rename a server.'],
                \
                \ ['n', s:slimv_leader.'wp', ':call vlime#plugin#CloseWindow("preview")<cr>',
                    \ 'Close all visible preview windows.'],
                \ ['n', s:slimv_leader.'wr', ':call vlime#plugin#CloseWindow("arglist")<cr>',
                    \ 'Close all visible arglist windows.'],
                \ ['n', s:slimv_leader.'wn', ':call vlime#plugin#CloseWindow("notes")<cr>',
                    \ 'Close all visible compiler notes windows.'],
                \ ['n', s:slimv_leader.'wR', ':call vlime#plugin#CloseWindow("repl")<cr>',
                    \ 'Close all visible REPL windows.'],
                \ ['n', s:slimv_leader.'wA', ':call vlime#plugin#CloseWindow("")<cr>',
                    \ 'Close all Vlime windows.'],
                \ ['n', s:slimv_leader.'wl', ':call vlime#plugin#CloseWindow()<cr>',
                    \ 'Show a list of visible Vlime windows, and choose which to close.'],
                \ ]
else
    let s:slimv_src_mappings = []
endif

if !exists('g:vlime_default_mappings')
    " buf_type: [
    "   [mode, key, command, description],
    "   ...
    " ]
    let g:vlime_default_mappings = {
                \ 'lisp': s:slimv_src_mappings,
                \
                \ 'sldb': [
                    \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("sldb")<cr>',
                        \ 'Show this quick reference.'],
                    \
                    \ ['n', '<cr>', ':call vlime#ui#sldb#ChooseCurRestart()<cr>',
                        \ 'Choose a restart.'],
                    \ ['n', 'd', ':call vlime#ui#sldb#ShowFrameDetails()<cr>',
                        \ 'Show the details of the frame under the cursor.'],
                    \ ['n', 'S', ':<c-u>call vlime#ui#sldb#OpenFrameSource()<cr>',
                        \ 'Open the source code for the frame under the cursor.'],
                    \ ['n', 'T', ':<c-u>call vlime#ui#sldb#OpenFrameSource("tabedit")<cr>',
                        \ 'Open the source code for the frame under the cursor, in a separate tab.'],
                    \ ['n', 'O', ':<c-u>call vlime#ui#sldb#FindSource()<cr>',
                        \ 'Open the source code for a local variable.'],
                    \ ['n', 'r', ':call vlime#ui#sldb#RestartCurFrame()<cr>',
                        \ 'Restart the frame under the cursor.'],
                    \ ['n', 's', ':call vlime#ui#sldb#StepCurOrLastFrame("step")<cr>',
                        \ 'Start stepping in the frame under the cursor.'],
                    \ ['n', 'x', ':call vlime#ui#sldb#StepCurOrLastFrame("next")<cr>',
                        \ 'Step over the current function call.'],
                    \ ['n', 'o', ':call vlime#ui#sldb#StepCurOrLastFrame("out")<cr>',
                        \ 'Step out of the current function.'],
                    \ ['n', 'c', ':call b:vlime_conn.SLDBContinue()<cr>',
                        \ 'Invoke the restart labeled CONTINUE.'],
                    \ ['n', 'a', ':call b:vlime_conn.SLDBAbort()<cr>',
                        \ 'Invoke the restart labeled ABORT.'],
                    \ ['n', 'C', ':call vlime#ui#sldb#InspectCurCondition()<cr>',
                        \ 'Inspect the current condition object.'],
                    \ ['n', 'i', ':call vlime#ui#sldb#InspectInCurFrame()<cr>',
                        \ 'Evaluate and inspect an expression in the frame under the cursor.'],
                    \ ['n', 'e', ':call vlime#ui#sldb#EvalStringInCurFrame()<cr>',
                        \ 'Evaluate an expression in the frame under the cursor.'],
                    \ ['n', 'E', ':call vlime#ui#sldb#SendValueInCurFrameToREPL()<cr>',
                        \ 'Evaluate an expression in the frame under the cursor, and send the result to the REPL.'],
                    \ ['n', 'D', ':call vlime#ui#sldb#DisassembleCurFrame()<cr>',
                        \ 'Disassemble the frame under the cursor.'],
                    \ ['n', 'R', ':call vlime#ui#sldb#ReturnFromCurFrame()<cr>',
                        \ 'Return a manually specified result from the frame under the cursor.'],
                \ ],
                \
                \ 'repl': [
                    \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("repl")<cr>',
                        \ 'Show this quick reference.'],
                    \
                    \ ['n', '<c-c>', ':call b:vlime_conn.Interrupt({"name": "REPL-THREAD", "package": "KEYWORD"})<cr>',
                        \ 'Interrupt the REPL thread.'],
                    \ ['n', s:slimv_leader.'-', ':call vlime#ui#repl#ClearREPLBuffer()<cr>',
                        \ 'Clear the REPL buffer.'],
                    \ ['n', s:slimv_leader.'i', ':call vlime#ui#repl#InspectCurREPLPresentation()<cr>',
                        \ 'Inspect the evaluation result under the cursor.'],
                    \ ['n', s:slimv_leader.'y', ':call vlime#ui#repl#YankCurREPLPresentation()<cr>',
                        \ 'Yank the evaluation result under the cursor.'],
                    \ ['n', ['<tab>', '<c-n>'], ':call vlime#ui#repl#NextField(v:true)<cr>',
                        \ 'Move the cursor to the next presented object.'],
                    \ ['n', '<c-p>', ':call vlime#ui#repl#NextField(v:false)<cr>',
                        \ 'Move the cursor to the previous presented object.'],
                \ ],
                \
                \ 'mrepl': [
                    \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("mrepl")<cr>',
                        \ 'Show this quick reference.'],
                    \
                    \ ['i', '<space>', '<space><c-r>=vlime#plugin#VlimeKey("space")<cr>',
                        \ 'Trigger the arglist hint.'],
                    \ ['i', '<cr>', '<c-r>=vlime#ui#mrepl#Submit()<cr>',
                        \ 'Submit the last input to the REPL.'],
                    \ ['i', '<c-j>', '<cr><c-r>=vlime#plugin#VlimeKey("cr")<cr>',
                        \ 'Insert a newline, and trigger the arglist hint.'],
                    \ ['i', '<tab>', '<c-r>=vlime#plugin#VlimeKey("tab")<cr>',
                        \ 'Trigger omni-completion.'],
                    \ ['i', '<c-c>', '<c-r>=vlime#ui#mrepl#Interrupt()<cr>',
                        \ 'Interrupt the MREPL thread.'],
                    \ ['n', s:slimv_leader.'-', ':call vlime#ui#mrepl#Clear()<cr>',
                        \ 'Clear the MREPL buffer.'],
                    \ ['n', s:slimv_leader.'Q', ':call vlime#ui#mrepl#Disconnect()<cr>',
                        \ 'Disconnect from this REPL.'],
                \ ],
                \
                \ 'inspector': [
                    \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("inspector")<cr>',
                        \ 'Show this quick reference.'],
                    \
                    \ ['n', ['<cr>', '<space>'], ':call vlime#ui#inspector#InspectorSelect()<cr>',
                        \ 'Activate the interactable field/button under the cursor.'],
                    \ ['n', 's', ':call vlime#ui#inspector#SendCurValueToREPL()<cr>',
                        \ 'Send the value of the field under the cursor, to the REPL.'],
                    \ ['n', 'S', ':call vlime#ui#inspector#SendCurInspecteeToREPL()<cr>',
                        \ 'Send the value being inspected to the REPL.'],
                    \ ['n', 'o', ':<c-u>call vlime#ui#inspector#FindSource("part")<cr>',
                        \ 'Open the source code for the value of the field under the cursor.'],
                    \ ['n', 'O', ':<c-u>call vlime#ui#inspector#FindSource("inspectee")<cr>',
                        \ 'Open the source code for the value being inspected.'],
                    \ ['n', ['<tab>', '<c-n>'], ':call vlime#ui#inspector#NextField(v:true)<cr>',
                        \ 'Select the next interactable field/button.'],
                    \ ['n', '<c-p>', ':call vlime#ui#inspector#NextField(v:false)<cr>',
                        \ 'Select the previous interactable field/button.'],
                    \ ['n', 'p', ':call vlime#ui#inspector#InspectorPop()<cr>',
                        \ 'Return to the previous inspected object.'],
                    \ ['n', 'P', ':call vlime#ui#inspector#InspectorNext()<cr>',
                        \ 'Move to the next inspected object.'],
                    \ ['n', 'R', ':call b:vlime_conn.InspectorReinspect({c, r -> c.ui.OnInspect(c, r, v:null, v:null)})<cr>',
                        \ 'Refresh the inspector.'],
                \ ],
                \
                \ 'trace': [
                    \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("trace")<cr>',
                        \ 'Show this quick reference.'],
                    \
                    \ ['n', ['<cr>', '<space>'], ':call vlime#ui#trace_dialog#Select()<cr>',
                        \ 'Activate the interactable field/button under the cursor.'],
                    \ ['n', 'i', ':call vlime#ui#trace_dialog#Select("inspect")<cr>',
                        \ 'Inspect the value of the field under the cursor.'],
                    \ ['n', 's', ':call vlime#ui#trace_dialog#Select("to_repl")<cr>',
                        \ 'Send the value of the field under the cursor to the REPL.'],
                    \ ['n', 'R', ':call vlime#plugin#OpenTraceDialog()<cr>',
                        \ 'Refresh the trace dialog.'],
                    \ ['n', ['<tab>', '<c-n>'], ':call vlime#ui#trace_dialog#NextField(v:true)<cr>',
                        \ 'Select the next interactable field/button.'],
                    \ ['n', '<c-p>', ':call vlime#ui#trace_dialog#NextField(v:false)<cr>',
                        \ 'Select the previous interactable field/button.'],
                \ ],
                \
                \ 'xref': [
                    \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("xref")<cr>',
                        \ 'Show this quick reference.'],
                    \
                    \ ['n', '<cr>', ':<c-u>call vlime#ui#xref#OpenCurXref()<cr>',
                        \ 'Open the selected source location.'],
                    \ ['n', 't', ':<c-u>call vlime#ui#xref#OpenCurXref(v:true, "tabedit")<cr>',
                        \ 'Open the selected source location, in a separate tab.'],
                    \ ['n', 's', ':<c-u>call vlime#ui#xref#OpenCurXref(v:true, "split")<cr>',
                        \ 'Open the selected source location, in a horizontal split window.'],
                    \ ['n', 'S', ':<c-u>call vlime#ui#xref#OpenCurXref(v:true, "vsplit")<cr>',
                        \ 'Open the selected source location, in a vertical split window.'],
                \ ],
                \
                \ 'notes': [
                    \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("notes")<cr>',
                        \ 'Show this quick reference.'],
                    \
                    \ ['n', '<cr>', ':<c-u>call vlime#ui#compiler_notes#OpenCurNote()<cr>',
                        \ 'Open the selected source location.'],
                    \ ['n', 't', ':<c-u>call vlime#ui#compiler_notes#OpenCurNote("tabedit")<cr>',
                        \ 'Open the selected source location, in a separate tab.'],
                    \ ['n', 's', ':<c-u>call vlime#ui#compiler_notes#OpenCurNote("split")<cr>',
                        \ 'Open the selected source location, in a horizontal split window.'],
                    \ ['n', 'S', ':<c-u>call vlime#ui#compiler_notes#OpenCurNote("vsplit")<cr>',
                        \ 'Open the selected source location, in a vertical split window.'],
                \ ],
                \
                \ 'threads': [
                    \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("threads")<cr>',
                        \ 'Show this quick reference.'],
                    \
                    \ ['n', '<c-c>', ':call vlime#ui#threads#InterruptCurThread()<cr>',
                        \ 'Interrupt the selected thread.'],
                    \ ['n', 'K', ':call vlime#ui#threads#KillCurThread()<cr>',
                        \ 'Kill the selected thread.'],
                    \ ['n', 'D', ':call vlime#ui#threads#DebugCurThread()<cr>',
                        \ 'Invoke the debugger in the selected thread.'],
                    \ ['n', 'r', ':call vlime#ui#threads#Refresh()<cr>',
                        \ 'Refresh the thread list.'],
                \ ],
                \
                \ 'server': [
                    \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("server")<cr>',
                        \ 'Show this quick reference.'],
                    \
                    \ ['n', s:slimv_leader.'c', ':call vlime#server#ConnectToCurServer()<cr>',
                        \ 'Connect to this server.'],
                    \ ['n', s:slimv_leader.'s', ':call vlime#server#StopCurServer()<cr>',
                        \ 'Stop this server.'],
                \ ],
                \
                \ 'input': [
                    \ ['n', s:slimv_leader.'?', ':call vlime#ui#ShowQuickRef("input")<cr>',
                        \ 'Show this quick reference.'],
                    \
                    \ ['n', '<c-p>', ':call vlime#ui#input#NextHistoryItem("backward")<cr>',
                        \ 'Show the previous item in input history.'],
                    \ ['n', '<c-n>', ':call vlime#ui#input#NextHistoryItem("forward")<cr>',
                        \ 'Show the next item in input history.'],
                \ ],
            \ }
endif


function! vlime#overlay#slimv#Init()
endfunction


function! s:DialogUntraceAllComplete(conn, result)
    if type(a:result) != type(v:null)
        for r in a:result
            echom r
        endfor
    endif
endfunction
