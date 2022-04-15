"-----------------------------------------------------------------------
" Global configurations
"-----------------------------------------------------------------------
" Configure custom syntax
let g:verilog_syntax_custom = {
    \ 'spyglass' : [{
        \ 'match_start' : '\/\/\s*spyglass\s\+disable_block\s\+\z(\(\w\|-\)\+\(\s\+\(\w\|-\)\+\)*\)',
        \ 'match_end'   : '\/\/\s*spyglass\s\+enable_block\s\+\z1',
        \ 'syn_argument': 'transparent keepend',
        \ }],
    \ }

"-----------------------------------------------------------------------
" Syntax folding test
"-----------------------------------------------------------------------
function! RunTestFold()
    let test_result=0

    " Enable all syntax folding
    let g:verilog_syntax_fold_lst="all"
    set foldmethod=syntax
    set noautochdir

    " Open syntax fold test file in read-only mode
    silent view test/folding.v

    " Verify folding
    let test_result=TestFold(0) || test_result
    echo ''

    " Test with "block_nested"
    let g:verilog_syntax_fold_lst="all,block_nested"
    silent view!
    let test_result=TestFold(1) || test_result
    echo ''

    " Test with "block_named"
    let g:verilog_syntax_fold_lst="all,block_named"
    silent view!
    let test_result=TestFold(2) || test_result
    echo ''

    " Check test results and exit accordingly
    if test_result
        cquit
    else
        qall!
    endif
endfunction

"-----------------------------------------------------------------------
" Syntax indent test
"-----------------------------------------------------------------------
function! RunTestIndent()
    let g:verilog_disable_indent_lst = "module,eos"
    let test_result=0

    " Open syntax indent test file
    silent edit test/indent.sv

    " Verify indent
    let test_result=TestIndent() || test_result
    echo ''
    silent edit!

    " Test again with 'ignorecase' enabled
    setlocal ignorecase
    let test_result=TestIndent() || test_result
    echo ''
    silent edit!

    " Make file read-only to guarantee that vim quits with exit status 0
    silent view!

    " Check test results and exit accordingly
    if test_result
        cquit
    else
        qall!
    endif
endfunction

"-----------------------------------------------------------------------
" Error format test
"-----------------------------------------------------------------------
function! RunTestEfm()
    let test_result=0

    set nomore "Disable pager to avoid issues with Travis

    let g:verilog_efm_quickfix_clean = 1

    for check_uvm in [0, 1]
        if check_uvm
            let g:verilog_efm_uvm_lst = 'all'
        else
            unlet! g:verilog_efm_uvm_lst
        endif

        let test_result = TestEfm('iverilog',  1, check_uvm) || test_result
        let test_result = TestEfm('verilator', 1, check_uvm) || test_result
        let test_result = TestEfm('verilator', 3, check_uvm) || test_result
        let test_result = TestEfm('ncverilog', 1, check_uvm) || test_result
        let test_result = TestEfm('ncverilog', 3, check_uvm) || test_result
        let test_result = TestEfm('spyglass',  1, check_uvm) || test_result
    endfor

    " Check test results and exit accordingly
    if test_result
        cquit
    else
        qall!
    endif
endfunction

"-----------------------------------------------------------------------
" Syntax test
"-----------------------------------------------------------------------
function! RunTestSyntax()
    let test_result=0

    set nomore "Disable pager to avoid issues with Travis
    set foldmethod=syntax
    set foldlevel=99

    " Run syntax test for various folding configurations
    let g:verilog_syntax_fold_lst=''
    let test_result = TestSyntax('syntax.sv', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all'
    let test_result = TestSyntax('syntax.sv', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all,block_nested'
    let test_result = TestSyntax('syntax.sv', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all,block_named'
    let test_result = TestSyntax('syntax.sv', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all,instance'
    let test_result = TestSyntax('syntax.sv', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst=''
    let test_result = TestSyntax('folding.v', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all'
    let test_result = TestSyntax('folding.v', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all,block_nested'
    let test_result = TestSyntax('folding.v', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all,block_named'
    let test_result = TestSyntax('folding.v', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all,instance'
    let test_result = TestSyntax('folding.v', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst=''
    let test_result = TestSyntax('indent.sv', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all'
    let test_result = TestSyntax('indent.sv', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all,block_nested'
    let test_result = TestSyntax('indent.sv', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all,block_named'
    let test_result = TestSyntax('indent.sv', g:verilog_syntax_fold_lst) || test_result

    let g:verilog_syntax_fold_lst='all,instance'
    let test_result = TestSyntax('indent.sv', g:verilog_syntax_fold_lst) || test_result

    " Check test results and exit accordingly
    if test_result
        cquit
    else
        qall!
    endif
endfunction

" vi: set expandtab softtabstop=4 shiftwidth=4:
