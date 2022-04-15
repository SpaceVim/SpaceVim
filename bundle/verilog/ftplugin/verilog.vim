" Vim filetype plugin file
" Language:	SystemVerilog (superset extension of Verilog)

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Define include string
setlocal include=^\\s*`include

" Set omni completion function
setlocal omnifunc=verilog_systemverilog#Complete

" Store cpoptions
let oldcpo=&cpoptions
set cpo-=C

" Undo the plugin effect
let b:undo_ftplugin = "setlocal fo< com< tw<"
    \ . "| unlet! b:browsefilter b:match_ignorecase b:match_words"

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal fo-=t fo+=croqlm1

" Set 'comments' to format dashed lists in comments.
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://

" Win32 and GTK can filter files in the browse dialog
if (has("gui_win32") || has("gui_gtk")) && !exists("b:browsefilter")
  let b:browsefilter = ""
        \ . "Verilog Family Source Files\t*.v;*.vh;*.vp;*.sv;*.svh;*.svi;*.svp\n"
        \ . "Verilog Source Files (*.v *.vh)\t*.v;*.vh\n"
        \ . "SystemVerilog Source Files (*.sv *.svh *.svi *.sva)\t*.sv;*.svh;*.svi;*.sva\n"
        \ . "Protected Files (*.vp *.svp)\t*.vp;*.svp\n"
        \ . "All Files (*.*)\t*.*\n"
endif
" Override matchit configurations
if exists("loaded_matchit")
  let b:match_ignorecase=0
  let b:match_words=
    \ '\<begin\>:\<end\>,' .
    \ '\<case\>\|\<casex\>\|\<casez\>:\<endcase\>,' .
    \ '`if\(n\)\?def\>:`elsif\>:`else\>:`endif\>,' .
    \ '\<module\>:\<endmodule\>,' .
    \ '\<if\>:\<else\>,' .
    \ '\<fork\>\s*;\@!$:\<join\(_any\|_none\)\?\>,' .
    \ '\<function\>:\<endfunction\>,' .
    \ '\<task\>:\<endtask\>,' .
    \ '\<specify\>:\<endspecify\>,' .
    \ '\<config\>:\<endconfig\>,' .
    \ '\<specify\>:\<endspecify\>,' .
    \ '\<generate\>:\<endgenerate\>,' .
    \ '\<primitive\>:\<endprimitive\>,' .
    \ '\<table\>:\<endtable\>,' .
    \ '\<class\>:\<endclass\>,' .
    \ '\<checker\>:\<endchecker\>,' .
    \ '\<interface\>:\<endinterface\>,' .
    \ '\<clocking\>:\<endclocking\>,' .
    \ '\<covergroup\>:\<endgroup\>,' .
    \ '\<package\>:\<endpackage\>,' .
    \ '\<program\>:\<endprogram\>,' .
    \ '\<property\>:\<endproperty\>,' .
    \ '\<sequence\>:\<endsequence\>'
endif

" Restore cpoptions
let &cpoptions=oldcpo
unlet oldcpo

" Raise warning if smartindent is defined
if &smartindent
    echohl WarningMsg
    redraw
    echo "Option 'smartindent' should not be used in Verilog syntax, use 'autoindent' instead."
endif

" vi: set expandtab softtabstop=2 shiftwidth=2:
