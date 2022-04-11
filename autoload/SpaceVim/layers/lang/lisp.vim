"=============================================================================
" lisp.vim --- SpaceVim lang#lisp layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#lisp, layers-lang-lisp
" @parentsection layers
" This layer is for Common Lisp development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#lisp'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for lisp, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#lisp#plugins() abort
  let plugins = []
  call add(plugins,['vlime/vlime', {'merged' : 0 , 'rtp': 'vim'}])
  return plugins
endfunction



function! SpaceVim#layers#lang#lisp#config() abort
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
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'c'], 'call vlime#plugin#ConnectREPL()', 'Connect to Vlime server', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 's'], 'call vlime#plugin#SelectCurConnection()', 'Switch Vlime connections', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'd'], 'call vlime#plugin#CloseCurConnection()', 'Disconnect', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','c', 'R'], 'call vlime#plugin#RenameCurConnection()', 'Rename the current connection', 1)

  let g:_spacevim_mappings_space.l.r = {'name' : '+Server Management'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'r'], 'call vlime#server#New(v:true, get(g:, "vlime_cl_use_terminal"))', 'Run a new Vlime server and connect to it', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'R'], 'call vlime#plugin#RenameSelectedServer()', 'Rename a server', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 's'], 'call vlime#plugin#StopCurrentServer()', 'Stop the current Vlime server', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'S'], 'call vlime#plugin#StopSelectedServer()', 'Stop a server', 1)
    call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'R'], 'call vlime#plugin#RenameSelectedServer()', 'Rename a server', 1)
      call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 't'], 'call vlime#plugin#RestartCurrentServer()', 'Select and Stop a server', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'v'], 'call vlime#plugin#ShowSelectedServer()', 'View the console output of a server', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r', 'c'], 'call vlime#ui#repl#ClearREPLBuffer()', 'Clear the REPL buffer', 1)

  let g:_spacevim_mappings_space.l.s = {'name' : '+Sending Stuff To The REPL'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s','s'], 'call vlime#plugin#SendToREPL(vlime#ui#CurExprOrAtom())',
        \ 'Send s-expr or atom under the cursor to REPL', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s','e'], 'call vlime#plugin#SendToREPL(vlime#ui#CurExpr())',
        \ 'Send s-expr under the cursor to REPL', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s','t'], 'vlime#plugin#SendToREPL(vlime#ui#CurTopExpr())',
        \ 'Send to-level s-expr under the cursor to REPL', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s','a'], 'call vlime#plugin#SendToREPL(vlime#ui#CurAtom())',
        \ 'Send atom under the cursor to REPL', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s','i'], 'call vlime#plugin#SendToREPL()',
        \ 'Open vlime input buffer for REPL', 1)
  call SpaceVim#mapping#space#langSPC('vmap', ['l','s','v'], 'call vlime#plugin#SendToREPL(vlime#ui#CurSelection())',
        \ 'Send the current selection to the REPL', 1)

  let g:_spacevim_mappings_space.l.m = {'name' : '+Expanding Macros'}
   call SpaceVim#mapping#space#langSPC('nmap', ['l','m','m'], 'call vlime#plugin#ExpandMacro(vlime#ui#CurExpr(), "expand")',
        \ 'Expand the macro under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','m','l'], 'call vlime#plugin#ExpandMacro(vlime#ui#CurExpr(), "one")',
        \ 'Expand the macro under the cursor once', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','m','a'], 'call vlime#plugin#ExpandMacro(vlime#ui#CurExpr(), "all")',
        \ 'Expand the macro under the cursor and all nested macros', 1)

  let g:_spacevim_mappings_space.l.o = {'name' : '+Compiling'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','o','e'], 'call vlime#plugin#Compile(vlime#ui#CurExpr(v:true))',
        \ 'Compile the form under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','o','t'], 'call vlime#plugin#Compile(vlime#ui#CurTopExpr(v:true))',
        \ 'Compile the top-level form under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','o','f'], "call vlime#plugin#CompileFile(expand('%:p'))",
        \ 'Compile the current file', 1)
  call SpaceVim#mapping#space#langSPC('vmap', ['l','o','v'], 'call vlime#plugin#Compile(vlime#ui#CurSelection(v:true))',
        \ 'Compile the current selection', 1)

  let g:_spacevim_mappings_space.l.x = {'name' : '+Cross references'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x','c'], "call vlime#plugin#XRefSymbol('CALLS', vlime#ui#CurAtom())",
        \ 'Show callers of the function under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x','C'], "call vlime#plugin#XRefSymbol('CALLS-WHO', vlime#ui#CurAtom())",
        \ 'Show callees of the function under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x','r'], 'call vlime#plugins#XRefSymbol("REFERENCES", vlime#ui#CurAtom())',
        \ 'Show references of the variable under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x','b'], 'call vlime#plugins#XRefSymbol("BINDS", vlime#ui#CurAtom())',
        \ 'Show bindings of the variable under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x','s'], 'call vlime#plugin#XRefSymbol("SETS", vlime#ui#CurAtom())',
        \ 'Show who sets the value of the variable under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x','e'], 'call vlime#plugin#XRefSymbol("MACROEXPANDS", vlime#ui#CurAtom())',
        \ 'Show who expands the macro under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x','m'], 'call vlime#plugin#XRefSymbol("SPECIALIZES", vlime#ui#CurAtom())',
        \ 'Show specialized methods for the class under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x','d'], 'call vlime#plugin#FindDefinition(vlime#ui#CurAtom())',
        \ 'Show the definition for the name under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','x','i'], 'call vlime#plugin#XRefSymbolWrapper()',
        \ 'Interactively prompt for the symbol to search', 1)

  let g:_spacevim_mappings_space.l.d = {'name' : '+Describing things'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d','o'], 'call vlime#plugin#DescribeSymbol(vlime#ui#CurOperator())',
        \ 'Describe the "operator"', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d','a'], 'call vlime#plugin#DescribeSymbol(vlime#ui#CurAtom())',
        \ 'Describe the atom under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d','i'], 'call vlime#plugin#DescribeSymbol()',
        \ 'Prompt for the symbol to describe', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d','s'], 'call vlime#plugin#AproposList()',
        \ 'apropos search', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d','r'], 'call vlime#plugin#ShowOperatorArgList(vlime#ui#CurOperator())',
        \ 'Show the arglist for the s-expression under the cursor', 1)

  let g:_spacevim_mappings_space.l.d.d = {'name' : '+Documentation'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d','d', 'o'], 'call vlime#plugin#DocumentationSymbol(vlime#ui#CurOperator())',
        \ 'Show the documentation for the "operator"', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d','d', 'a'], 'call vlime#plugin#DocumentationSymbol(vlime#ui#CurAtom())',
        \ 'Show the documentation for atom', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','d','d', 'i'], 'call vlime#plugin#DocumentationSymbol()',
        \ 'Show the documentation for the symbol entered in an input buffer', 1)

  let g:_spacevim_mappings_space.l.u = {'name' : '+Undefining'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','u','f'], 'call vlime#plugin#UndefineFunction(vlime#ui#CurAtom())',
        \ 'Undefine the function under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','u','s'], 'call vlime#plugin#UninternSymbol(vlime#ui#CurAtom())',
        \ 'Unintern the symbol under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','u','i'], 'call vlime#plugin#UndefineUninternWrapper()',
        \ 'Interactively prompt for the function/symbol to undefine/unintern', 1)

  let g:_spacevim_mappings_space.l.I = {'name' : '+Inspection'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','I','i'], 'call vlime#plugin#Inspect(vlime#ui#CurExprOrAtom())',
        \ 'evaluate the s-expr or atom under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','I','e'], 'call vlime#plugin#Inspect(vlime#ui#CurExpr())',
        \ 'evaluate and inspect the s-expr under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','I','t'], 'call vlime#plugin#Inspect(vlime#ui#CurTopExpr())',
        \ 'evaluate and inspect the top-level s-expr under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','I','a'], 'call vlime#plugin#Inspect(vlime#ui#CurAtom())',
        \ 'Evaluate and inspect the atom under the cursor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','I','n'], 'call vlime#plugin#Inspect()',
        \ 'Prompt for the expression to inspect', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','I','v'], 'call vlime#plugin#Inspect(vlime#ui#CurSelection())',
        \ 'Evaluate and inspect current selection', 1)

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

function! SpaceVim#layers#lang#lisp#health() abort
  call SpaceVim#layers#lang#lisp#plugins()
  call SpaceVim#layers#lang#lisp#config()
  return 1
endfunction
