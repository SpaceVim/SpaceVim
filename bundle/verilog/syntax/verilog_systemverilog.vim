" Vim syntax file
" Language:	SystemVerilog (superset extension of Verilog)

" Extends Verilog syntax
" Requires $VIMRUNTIME/syntax/verilog.vim to exist

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
   syntax clear
elseif exists("b:current_syntax")
   finish
endif

" Override 'iskeyword'
if version >= 600
   setlocal iskeyword=@,48-57,_,192-255
else
   set iskeyword=@,48-57,_,192-255
endif

" Store cpoptions
let oldcpo=&cpoptions
set cpo-=C

syn sync lines=1000

"##########################################################
"       SystemVerilog Syntax
"##########################################################

syn keyword verilogStatement   always and assign automatic buf
syn keyword verilogStatement   bufif0 bufif1 cell cmos
syn keyword verilogStatement   config deassign defparam design
syn keyword verilogStatement   disable edge endconfig
syn keyword verilogStatement   endgenerate
syn keyword verilogStatement   endprimitive endtable
syn keyword verilogStatement   event force fork join
syn keyword verilogStatement   join_any join_none forkjoin
syn keyword verilogStatement   generate genvar highz0 highz1 ifnone
syn keyword verilogStatement   incdir include initial inout input
syn keyword verilogStatement   instance integer large liblist
syn keyword verilogStatement   library localparam macromodule medium
syn keyword verilogStatement   nand negedge nmos nor
syn keyword verilogStatement   noshowcancelled not notif0 notif1 or
syn keyword verilogStatement   output parameter pmos posedge primitive
syn keyword verilogStatement   pull0 pull1 pulldown pullup
syn keyword verilogStatement   pulsestyle_onevent pulsestyle_ondetect
syn keyword verilogStatement   rcmos real realtime reg release
syn keyword verilogStatement   rnmos rpmos rtran rtranif0 rtranif1
syn keyword verilogStatement   scalared showcancelled signed small
syn keyword verilogStatement   specparam strong0 strong1
syn keyword verilogStatement   supply0 supply1 table time tran
syn keyword verilogStatement   tranif0 tranif1 tri tri0 tri1 triand
syn keyword verilogStatement   trior trireg unsigned use vectored wait
syn keyword verilogStatement   wand weak0 weak1 wire wor xnor xor
syn keyword verilogStatement   semaphore mailbox

syn keyword verilogStatement   always_comb always_ff always_latch
syn keyword verilogStatement   checker endchecker
syn keyword verilogStatement   virtual local const protected
syn keyword verilogStatement   package endpackage
syn keyword verilogStatement   rand randc constraint randomize
syn keyword verilogStatement   with inside dist
syn keyword verilogStatement   randcase
syn keyword verilogStatement   randsequence
syn keyword verilogStatement   get_randstate set_randstate
syn keyword verilogStatement   srandom
syn keyword verilogStatement   logic bit byte time
syn keyword verilogStatement   int longint shortint
syn keyword verilogStatement   struct packed
syn keyword verilogStatement   final
syn keyword verilogStatement   import
syn keyword verilogStatement   context pure
syn keyword verilogStatement   void shortreal chandle string
syn keyword verilogStatement   modport
syn keyword verilogStatement   cover coverpoint
syn keyword verilogStatement   program endprogram
syn keyword verilogStatement   bins binsof illegal_bins ignore_bins
syn keyword verilogStatement   alias matches solve static assert
syn keyword verilogStatement   assume before expect bind
syn keyword verilogStatement   extends tagged extern
syn keyword verilogStatement   first_match throughout timeprecision
syn keyword verilogStatement   timeunit priority type union
syn keyword verilogStatement   uwire var cross ref wait_order intersect
syn keyword verilogStatement   wildcard within
syn keyword verilogStatement   triggered
syn keyword verilogStatement   std
syn keyword verilogStatement   accept_on eventually global implements implies
syn keyword verilogStatement   interconnect let nettype nexttime reject_on restrict soft
syn keyword verilogStatement   s_always s_eventually s_nexttime s_until s_until_with
syn keyword verilogStatement   strong sync_accept_on sync_reject_on unique unique0
syn keyword verilogStatement   until until_with untyped weak

syn keyword verilogTypeDef     enum

syn keyword verilogConditional iff
syn keyword verilogConditional if else case casex casez default endcase

syn keyword verilogRepeat      forever repeat while for
syn keyword verilogRepeat      return break continue
syn keyword verilogRepeat      do while foreach

syn match   verilogGlobal      "`[a-zA-Z_][a-zA-Z0-9_$]\+"
syn match   verilogGlobal      "$[a-zA-Z0-9_$]\+"

if !exists('g:verilog_disable_constant_highlight')
    syn match   verilogConstant    "\<[A-Z][A-Z0-9_$]*\>"
endif

syn match   verilogNumber      "\(\d\+\)\?'[sS]\?[bB]\s*[0-1_xXzZ?]\+"
syn match   verilogNumber      "\(\d\+\)\?'[sS]\?[oO]\s*[0-7_xXzZ?]\+"
syn match   verilogNumber      "\(\d\+\)\?'[sS]\?[dD]\s*[0-9_xXzZ?]\+"
syn match   verilogNumber      "\(\d\+\)\?'[sS]\?[hH]\s*[0-9a-fA-F_xXzZ?]\+"
syn match   verilogNumber      "\<[+-]\?[0-9_]\+\(\.[0-9_]*\)\?\(e[0-9_]*\)\?\>"
syn match   verilogNumber      "\<\d[0-9_]*\(\.[0-9_]\+\)\=\([fpnum]\)\=s\>"
syn keyword verilogNumber      1step

syn keyword verilogTodo        contained TODO FIXME

syn match   verilogOperator    "[&|~><!)(*#%@+/=?:;}{,.\^\-\[\]]"

syn region  verilogString      start=+"+ skip=+\\"+ end=+"+ contains=verilogEscape,@Spell
syn match   verilogEscape      +\\[nt"\\]+ contained
syn match   verilogEscape      "\\\o\o\=\o\=" contained

syn keyword verilogMethod      new
if v:version >= 704
    syn match   verilogMethod  "\(\(\s\|[(/]\|^\)\.\)\@2<!\<\w\+\ze#\?("
else
    syn match   verilogMethod  "\(\(\s\|[(/]\|^\)\.\)\@<!\<\w\+\ze#\?("
endif

syn match   verilogLabel       "\<\k\+\>\ze\s*:\s*\<\(assert\|assume\|cover\(point\)\?\|cross\)\>"
if v:version >= 704
    syn match   verilogLabel   "\(\<\(begin\|end\)\>\s*:\s*\)\@20<=\<\k\+\>"
else
    syn match   verilogLabel   "\(\<\(begin\|end\)\>\s*:\s*\)\@<=\<\k\+\>"
endif

syn keyword verilogObject      super null this
syn match   verilogObject      "\<\w\+\ze\(::\|\.\)" contains=verilogNumber


" Create syntax definition from g:verilog_syntax dictionary
function! s:SyntaxCreate(name, verilog_syntax)
    if exists('a:verilog_syntax[a:name]')
        let verilog_syn_region_name = 'verilog'.substitute(a:name, '.*', '\u&', '')
        for entry in a:verilog_syntax[a:name]
            if exists('entry["match"]')
                " syn-match definitions
                let match = entry["match"]
                let verilog_syn_match_cmd = 'syn match '.verilog_syn_region_name.' "'.match.'"'

                if exists('entry["syn_argument"]')
                    let verilog_syn_match_cmd .= ' '.entry["syn_argument"]
                endif

                execute verilog_syn_match_cmd
            elseif exists('entry["match_start"]') && exists('entry["match_end"]')
                " syn-region definitions

                let region_start = entry["match_start"]
                let region_end = entry["match_end"]

                if verilog_systemverilog#VariableExists('verilog_quick_syntax')
                    execute 'syn keyword verilogStatement '.region_start.' '.region_end
                else
                    let verilog_syn_region_cmd = 'syn region '.verilog_syn_region_name

                    if exists('entry["highlight"]')
                        let verilog_syn_region_cmd .= ' matchgroup='.entry["highlight"]
                    endif

                    let verilog_syn_region_cmd .=
                        \  ' start="'.region_start.'"'
                        \ .' end="'.region_end.'"'

                    " Always skip inline comments
                    if a:name != "comment" && exists('a:verilog_syntax["comment"]')
                        let verilog_syn_region_cmd .= ' skip="'
                        for comment_entry in a:verilog_syntax["comment"]
                            if exists('comment_entry["match"]')
                                let verilog_syn_region_cmd .= comment_entry["match"]
                            endif
                        endfor
                        let verilog_syn_region_cmd .= '"'
                    endif

                    if exists('entry["syn_argument"]')
                        let verilog_syn_region_cmd .= ' '.entry["syn_argument"]
                    endif

                    if !exists('entry["no_fold"]')
                        if (index(s:verilog_syntax_fold, a:name) >= 0 || index(s:verilog_syntax_fold, "all") >= 0)
                            let verilog_syn_region_cmd .= ' fold'
                        endif
                    endif

                    execute verilog_syn_region_cmd
                endif
            elseif exists('entry["cluster"]')
                " syn-cluster definitions

                execute 'syn cluster '.verilog_syn_region_name.' contains='.entry["cluster"]
            elseif exists('entry["keyword"]')
                " syn-cluster definitions

                execute 'syn keyword '.verilog_syn_region_name.' '.entry["keyword"]
            else
                echoerr 'Incorrect syntax defintion for '.a:name
            endif
        endfor
    end
endfunction

" Only enable folding if verilog_syntax_fold_lst is defined
let s:verilog_syntax_fold=verilog_systemverilog#VariableGetValue("verilog_syntax_fold_lst")

" Syntax priority list
let s:verilog_syntax_order = [
            \ 'baseCluster',
            \ 'statement',
            \ 'assign',
            \ 'attribute',
            \ 'instance',
            \ 'prototype',
            \ 'class',
            \ 'clocking',
            \ 'covergroup',
            \ 'define',
            \ 'export',
            \ 'expression',
            \ 'function',
            \ 'interface',
            \ 'module',
            \ 'property',
            \ 'sequence',
            \ 'specify',
            \ 'task',
            \ 'typedef',
            \ ]

" Generate syntax definitions for supported types
for name in s:verilog_syntax_order
    call s:SyntaxCreate(name, g:verilog_syntax)
endfor

if index(s:verilog_syntax_fold, "block_nested") >= 0 || index(s:verilog_syntax_fold, "block_named") >= 0
    if index(s:verilog_syntax_fold, "block_nested") >= 0
        syn region verilogBlock
            \ matchgroup=verilogStatement
            \ start="\<begin\>"
            \ end="\<end\>.*\<begin\>"ms=s-1,me=s-1
            \ fold
            \ transparent
            \ contained
            \ nextgroup=verilogBlockEnd
            \ contains=TOP
        syn region verilogBlockEnd
            \ matchgroup=verilogStatement
            \ start="\<end\>.*\<begin\>"
            \ end="\<end\>\ze.*\(\<begin\>\)\@!"
            \ fold
            \ transparent
            \ contained
            \ contains=TOP
        syn match verilogStatement "\<end\>"
    else "block_named
        syn region verilogBlock
            \ matchgroup=verilogStatement
            \ start="\<begin\>"
            \ end="\<end\>"
            \ transparent
            \ contained
            \ contains=TOP
        syn region verilogBlockNamed
            \ matchgroup=verilogStatement
            \ start="\<begin\>\ze\s*:\s*\z(\w\+\)"
            \ end="\<end\>"
            \ transparent
            \ fold
            \ contained
            \ contains=TOP
        "TODO break up if...else statements
    endif
    syn region verilogBlockContainer
        \ start="\<begin\>"
        \ end="\<end\>"
        \ skip="/[*/].*"
        \ transparent
        \ keepend extend
        \ contains=verilogBlock,verilogBlockNamed,verilogBlockEnd
elseif index(s:verilog_syntax_fold, "block") >= 0 || index(s:verilog_syntax_fold, "all") >= 0
    syn region verilogBlock
        \ matchgroup=verilogStatement
        \ start="\<begin\>"
        \ end="\<end\>"
        \ transparent
        \ fold
else
    syn keyword verilogStatement  begin end
endif

if index(s:verilog_syntax_fold, "define") >= 0 || index(s:verilog_syntax_fold, "all") >= 0
    syn region verilogIfdef
        \ start="`ifn\?def\>"
        \ end="^\s*`els\(e\|if\)\>"ms=s-1,me=s-1
        \ fold transparent
        \ keepend
        \ contained
        \ nextgroup=verilogIfdefElse,verilogIfdefEndif
        \ contains=TOP
    syn region verilogIfdefElse
        \ start="`els\(e\|if\)\>"
        \ end="^\s*`els\(e\|if\)\>"ms=s-1,me=s-1
        \ fold transparent
        \ keepend
        \ contained
        \ nextgroup=verilogIfdefElse,verilogIfdefEndif
        \ contains=TOP
    syn region verilogIfdefEndif
        \ start="`else\>"
        \ end="`endif\>"
        \ fold transparent
        \ keepend
        \ contained
        \ contains=TOP
    syn region verilogIfdefContainer
        \ start="`ifn\?def\>"
        \ end="`endif\>"
        \ skip="/[*/].*"
        \ transparent
        \ keepend extend
        \ contains=verilogIfdef,verilogIfdefElse,verilogIfdefEndif
endif

" Generate syntax definitions for comments after other standard syntax
" definitions to guarantee highest priority
for name in ['comment']
    call s:SyntaxCreate(name, g:verilog_syntax)
endfor

" Generate syntax definitions for custom types last to allow overriding
" standard syntax
if exists('g:verilog_syntax_custom')
    for name in keys(g:verilog_syntax_custom)
        call s:SyntaxCreate(name, g:verilog_syntax_custom)
    endfor
endif

" Special comments: Synopsys directives
syn match   verilogDirective   "//\s*synopsys\>.*$"
syn region  verilogDirective   start="/\*\s*synopsys\>" end="\*/"
syn region  verilogDirective   start="//\s*synopsys \z(\w*\)begin\>" end="//\s*synopsys \z1end\>"

syn match   verilogDirective   "//\s*\$s\>.*$"
syn region  verilogDirective   start="/\*\s*\$s\>" end="\*/"
syn region  verilogDirective   start="//\s*\$s dc_script_begin\>" end="//\s*\$s dc_script_end\>"

"Modify the following as needed.  The trade-off is performance versus
"functionality.
syn sync minlines=50

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_verilog_syn_inits")
   if version < 508
      let did_verilog_syn_inits = 1
      command -nargs=+ HiLink hi link <args>
   else
      command -nargs=+ HiLink hi def link <args>
   endif

   " The default highlighting.
   HiLink verilogCharacter       Character
   HiLink verilogConditional     Conditional
   HiLink verilogRepeat          Repeat
   HiLink verilogString          String
   HiLink verilogTodo            Todo
   HiLink verilogComment         Comment
   HiLink verilogConstant        Constant
   HiLink verilogLabel           Tag
   HiLink verilogNumber          Number
   HiLink verilogOperator        Special
   HiLink verilogPrototype       Statement
   HiLink verilogStatement       Statement
   HiLink verilogGlobal          Define
   HiLink verilogDirective       SpecialComment
   HiLink verilogEscape          Special
   HiLink verilogMethod          Function
   HiLink verilogTypeDef         TypeDef
   HiLink verilogObject          Type

   delcommand HiLink
endif

let b:current_syntax = "verilog_systemverilog"

" Restore cpoptions
let &cpoptions=oldcpo

" vim: sts=4 sw=4
