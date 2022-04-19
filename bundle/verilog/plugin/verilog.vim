" Global plugin settings
let g:verilog_disable_indent_lst="eos"

" Command definitions
command! -nargs=* VerilogErrorFormat call verilog#VerilogErrorFormat(<f-args>)
command!          VerilogFollowInstance call verilog#FollowInstanceTag(line('.'), col('.'))
command!          VerilogReturnInstance call verilog#ReturnFromInstanceTag()
command!          VerilogFollowPort call verilog#FollowInstanceSearchWord(line('.'), col('.'))
command!          VerilogGotoInstanceStart call verilog#GotoInstanceStart(line('.'), col('.'))
command! -nargs=+ -complete=customlist,verilog#CompleteCommand
            \ VerilogFoldingAdd
            \ call verilog#PushToVariable('verilog_syntax_fold_lst', '<args>')
command! -nargs=+ -complete=customlist,verilog#CompleteCommand
            \ VerilogFoldingRemove
            \ call verilog#PopFromVariable('verilog_syntax_fold_lst', '<args>')
command! -nargs=+ -complete=customlist,verilog#CompleteCommand
            \ VerilogDisableIndentAdd
            \ call verilog#PushToVariable('verilog_disable_indent_lst', '<args>')
command! -nargs=+ -complete=customlist,verilog#CompleteCommand
            \ VerilogDisableIndentRemove
            \ call verilog#PopFromVariable('verilog_disable_indent_lst', '<args>')
command! -nargs=+ -complete=customlist,verilog#CompleteCommand
            \ VerilogErrorUVMAdd
            \ call verilog#PushToVariable('verilog_efm_uvm_lst', '<args>')
command! -nargs=+ -complete=customlist,verilog#CompleteCommand
            \ VerilogErrorUVMRemove
            \ call verilog#PopFromVariable('verilog_efm_uvm_lst', '<args>')

" Configure tagbar
if !exists("g:tagbar_type_verilog")
    " This requires a recent version of universal-ctags
    let g:tagbar_type_verilog = {
        \ 'ctagstype'   : 'SystemVerilog',
        \ 'kinds'       : [
            \ 'b:blocks:1:1',
            \ 'c:constants:1:0',
            \ 'e:events:1:0',
            \ 'f:functions:1:1',
            \ 'm:modules:0:1',
            \ 'n:nets:1:0',
            \ 'p:ports:1:0',
            \ 'r:registers:1:0',
            \ 't:tasks:1:1',
            \ 'A:assertions:1:1',
            \ 'C:classes:0:1',
            \ 'V:covergroups:0:1',
            \ 'I:interfaces:0:1',
            \ 'M:modport:0:1',
            \ 'K:packages:0:1',
            \ 'P:programs:0:1',
            \ 'R:properties:0:1',
            \ 'T:typedefs:0:1'
        \ ],
        \ 'sro'         : '.',
        \ 'kind2scope'  : {
            \ 'm' : 'module',
            \ 'b' : 'block',
            \ 't' : 'task',
            \ 'f' : 'function',
            \ 'C' : 'class',
            \ 'V' : 'covergroup',
            \ 'I' : 'interface',
            \ 'K' : 'package',
            \ 'P' : 'program',
            \ 'R' : 'property'
        \ },
    \ }
endif

" Define regular expressions for Verilog/SystemVerilog statements
let s:verilog_function_task_dequalifier =
    \  '\%('
    \ .    '\%('
    \ .        'extern\s\+\%(\%(pure\s\+\)\?virtual\s\+\)\?'
    \ .        '\|'
    \ .        'pure\s\+virtual\s\+'
    \ .        '\|'
    \ .        'import\s\+\"DPI\%(-[^\"]\+\)\?\"\s\+\%(context\s\+\)\?'
    \ .    '\)'
    \ .    '\%(\%(static\|protected\|local\)\s\+\)\?'
    \ .'\)'

let g:verilog_syntax = {
      \ 'assign'      : [{
                        \ 'match_start' : '[^><=!]\zs<\?=\%(=\)\@!',
                        \ 'match_end'   : '[;,]',
                        \ 'highlight'   : 'verilogOperator',
                        \ 'syn_argument': 'transparent contains=@verilogBaseCluster',
                        \ }],
      \ 'attribute'   : [{
                        \ 'match_start' : '\%(@\s*\)\@<!(\*',
                        \ 'match_end'   : '\*)',
                        \ 'highlight'   : 'verilogDirective',
                        \ 'syn_argument': 'transparent keepend contains=verilogComment,verilogNumber,verilogOperator,verilogString',
                        \ }],
      \ 'baseCluster' : [{
                        \ 'cluster'     : 'verilogComment,verilogNumber,verilogOperator,verilogString,verilogConstant,verilogGlobal,verilogMethod,verilogObject,verilogConditional,verilogIfdefContainer'
                        \ }],
      \ 'block'       : [{
                        \ 'match_start' : '\<begin\>',
                        \ 'match_end'   : '\<end\>',
                        \ 'syn_argument': 'transparent',
                        \ }],
      \ 'block_named' : [{
                        \ 'match_start' : '\<begin\>\s*:\s*\w\+',
                        \ 'match_end'   : '\<end\>',
                        \ 'syn_argument': 'transparent',
                        \ }],
      \ 'class'       : [{
                        \ 'match_start' : '\<class\>',
                        \ 'match_end'   : '\<endclass\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent',
                        \ }],
      \ 'clocking'    : [{
                        \ 'match_start' : '\<clocking\>',
                        \ 'match_end'   : '\<endclocking\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'comment'     : [{
                        \ 'match'       : '//.*',
                        \ 'syn_argument': 'contains=verilogTodo,verilogDirective,@Spell'
                        \ },
                        \ {
                        \ 'match_start' : '/\*',
                        \ 'match_end'   : '\*/',
                        \ 'syn_argument': 'contains=verilogTodo,verilogDirective,@Spell keepend extend'
                        \ }],
      \ 'covergroup'  : [{
                        \ 'match_start' : '\<covergroup\>',
                        \ 'match_end'   : '\<endgroup\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'define'      : [{
                        \ 'match_start' : '`define\>',
                        \ 'match_end'   : '\(\\\s*\)\@<!$',
                        \ 'syn_argument': 'contains=@verilogBaseCluster'
                        \ }],
      \ 'export'      : [{
                        \ 'match_start' : '\<export\>',
                        \ 'match_end'   : '\<task\|function\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent contains=ALLBUT,verilogFunction,verilogTask',
                        \ }],
      \ 'expression'  : [{
                        \ 'match_start' : '(',
                        \ 'match_end'   : ')',
                        \ 'highlight'   : 'verilogOperator',
                        \ 'syn_argument': 'transparent contains=@verilogBaseCluster,verilogExpression,verilogStatement',
                        \ 'no_fold'     : '1',
                        \ }],
      \ 'function'    : [{
                        \ 'match_start' : s:verilog_function_task_dequalifier.'\@<!\<function\>',
                        \ 'match_end'   : '\<endfunction\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'instance'    : [{
                        \ 'match_start' : '^\s*\zs\w\+\%(\s*#\s*(\%(.*)\s*\w\+\s*;\)\@!\|\s\+\%(\<if\>\)\@!\w\+\s*(\)',
                        \ 'match_end'   : ';',
                        \ 'syn_argument': 'transparent keepend contains=verilogListParam,verilogStatement,@verilogBaseCluster',
                        \ }],
      \ 'interface'   : [{
                        \ 'match_start' : '\%(\<virtual\s\+\)\@<!\<interface\>\%(\s\+class\)\@!',
                        \ 'match_end'   : '\<endinterface\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'module'      : [{
                        \ 'match_start' : '\<\%(extern\s\+\)\@<!\<module\>',
                        \ 'match_end'   : '\<endmodule\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend contains=ALLBUT,verilogInterface',
                        \ }],
      \ 'property'    : [{
                        \ 'match_start' : '\<\%(\%(assert\|assume\|cover\|restrict\)\s\+\)\@<!\<property\>',
                        \ 'match_end'   : '\<endproperty\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'prototype'   : [{
                        \ 'match'       : s:verilog_function_task_dequalifier.'\@<=\<\%(task\|function\)\>',
                        \ }],
      \ 'sequence'    : [{
                        \ 'match_start' : '\<\%(cover\s\+\)\@<!\<sequence\>',
                        \ 'match_end'   : '\<endsequence\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'specify'     : [{
                        \ 'match_start' : '\<specify\>',
                        \ 'match_end'   : '\<endspecify\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'statement'   : [{
                        \ 'match'       : '\<\%(interface\|property\|sequence\|class\)\>',
                        \ }],
      \ 'task'        : [{
                        \ 'match_start' : s:verilog_function_task_dequalifier.'\@<!\<task\>',
                        \ 'match_end'   : '\<endtask\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'typedef'     : [{
                        \ 'match_start' : '\<typedef\>',
                        \ 'match_end'   : '\ze;',
                        \ 'highlight'   : 'verilogTypeDef',
                        \ 'syn_argument': 'transparent keepend contains=ALLBUT,verilogClass',
                        \ }],
      \ }

" vi: set expandtab softtabstop=4 shiftwidth=4:
