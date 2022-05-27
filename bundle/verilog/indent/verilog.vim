" Language: Verilog/SystemVerilog HDL
"
" Credits:
"   Originally created by
"       Lewis Russell <lewis6991@gmail.com>
"
"   Inspired from script originally created by
"       Chih-Tsun Huang <cthuang@larc.ee.nthu.edu.tw>
"

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetVerilogSystemVerilogIndent()
setlocal indentkeys=!^F,o,O,0),0},=begin,=end,=join,=endcase,=join_any,=join_none
setlocal indentkeys+==endmodule,=endfunction,=endtask,=endspecify
setlocal indentkeys+==endclass,=endpackage,=endsequence,=endclocking
setlocal indentkeys+==endinterface,=endgroup,=endprogram,=endproperty
setlocal indentkeys+==endgenerate,=endchecker,=endconfig,=endprimitive,=endtable
setlocal indentkeys+==`else,=`endif
setlocal indentkeys+=;

let s:vlog_open_statement = '\([<>:!=?&|^%/*+]\|-[^>]\)'
let s:vlog_end_statement  = ')\s*;'
let s:vlog_comment        = '\(//.*\|/\*.*\*/\)'
let s:vlog_macro          = '`\k\+\((.*)\)\?\s*$'
let s:vlog_statement      = '.*;\s*$\|'. s:vlog_macro
let s:vlog_sens_list      = '\(@\s*(.*)\)'
let s:vlog_always         = '\<always\(_ff\|_comb\|_latch\)\?\>\s*' . s:vlog_sens_list . '\?'
let s:vlog_method         = '^\(\s*pure\s\+virtual\|\s*extern\)\@!.*\<\(function\|task\)\>\s\+\(\[.*\]\s*\)\?\w\+'

let s:vlog_block_start    = '\<\(begin\|case\|^\s*fork\)\>\|{\|('
let s:vlog_block_end      = '\<\(end\|endcase\|join\(_all\|_none\)\?\)\>\|}\|)'

let s:vlog_module         = '\<\(extern\s\+\)\@<!module\>'
let s:vlog_interface      = '\(virtual\s\+\)\@<!\<interface\>\s*\(\<class\>\)\@!\w\+.*[^,]$'
let s:vlog_package        = '\<package\>'
let s:vlog_covergroup     = '\<covergroup\>'
let s:vlog_program        = '\<program\>'
let s:vlog_generate       = '\<generate\>'
let s:vlog_class          = '\<\(typedef\s\+\)\@<!class\>'
let s:vlog_property       = g:verilog_syntax['property'][0]['match_start']
let s:vlog_sequence       = g:verilog_syntax['sequence'][0]['match_start']
let s:vlog_clocking       = g:verilog_syntax['clocking'][0]['match_start']
let s:vlog_preproc        = '^\s*`ifn\?def\>'
let s:vlog_define         = '^\s*`define\>'

let s:vlog_case           = '\<case[zx]\?\>\s*('
let s:vlog_join           = '\<join\(_any\|_none\)\?\>'

let s:vlog_block_decl     = '\(\<\(while\|if\|foreach\|for\)\>\s*(\)\|\<\(else\|do\)\>\|' . s:vlog_always

let s:vlog_context_end    = '\<end\(package\|function\|class\|module\|group\|generate\|program\|property\|sequence\|clocking\|interface\|task\)\>\|`endif\>'

let s:vlog_assign         = '\([^=!]=\([^=]\|$\)\|return\||[-=]>\)'
let s:vlog_conditional    = '?.*:.*$'

" Only define the function once.
if exists("*GetVerilogSystemVerilogIndent")
  finish
endif

set cpo-=C

function! GetVerilogSystemVerilogIndent()

  let s:verilog_disable_indent = verilog#VariableGetValue('verilog_disable_indent_lst')

  if verilog#VariableExists('verilog_indent_width')
    let s:offset = verilog#VariableGetValue('verilog_indent_width')
  else
    let s:offset = &sw
  endif

  " At the start of the file use zero indent.
  if v:lnum == 1
    return 0
  endif

  let s:curr_line = getline(v:lnum)

  if s:curr_line =~ '^\s*)'
    let l:extra_offset = 0
    if s:curr_line =~ '^\s*'.s:vlog_end_statement.'\s*$' &&
          \ index(s:verilog_disable_indent, 'eos') < 0
      let l:extra_offset = s:offset
    endif
    call verilog#Verbose("Indenting )")
    return indent(s:SearchForBlockStart('(', '', ')', v:lnum, 0)) + l:extra_offset
  elseif s:curr_line =~ '^\s*}'
    call verilog#Verbose("Indenting }")
    return indent(s:SearchForBlockStart('{', '', '}', v:lnum, 0))
  endif

  " Reset indent for end blocks.
  if s:curr_line =~ '^\s*\<end'
    if s:curr_line =~ '^\s*\<endfunction\>'
      return indent(s:SearchBackForPattern('\<function\>'  , v:lnum))
    elseif s:curr_line =~ '^\s*\<endtask\>'
      return indent(s:SearchBackForPattern('\<task\>'      , v:lnum))
    elseif s:curr_line =~ '^\s*\<endclocking\>'
      return indent(s:SearchBackForPattern('\<clocking\>'  , v:lnum))
    elseif s:curr_line =~ '^\s*\<endpackage\>'
      return indent(s:SearchBackForPattern('\<package\>'   , v:lnum))
    elseif s:curr_line =~ '^\s*\<endinterface\>'
      return indent(s:SearchBackForPattern('\<interface\>' , v:lnum))
    elseif s:curr_line =~ '^\s*\<endproperty\>'
      return indent(s:SearchBackForPattern('\<property\>'  , v:lnum))
    elseif s:curr_line =~ '^\s*\<endgroup\>'
      return indent(s:SearchBackForPattern('\<covergroup\>', v:lnum))
    elseif s:curr_line =~ '^\s*\<endgenerate\>'
      return indent(s:SearchBackForPattern('\<generate\>', v:lnum))
    elseif s:curr_line =~ '^\s*\<endprogram\>'
      return indent(s:SearchBackForPattern('\<program\>', v:lnum))
    elseif s:curr_line =~ '^\s*\<endspecify\>'
      return indent(s:SearchBackForPattern('\<specify\>'   , v:lnum))
    elseif s:curr_line =~ '^\s*\<endsequence\>'
      return indent(s:SearchBackForPattern('\<sequence\>'  , v:lnum))
    elseif s:curr_line =~ '^\s*\<endmodule\>'
      return indent(s:SearchForBlockStart('\<module\>', '', '\<endmodule\>', v:lnum, 0))
    elseif s:curr_line =~ '^\s*\<endclass\>'
      return indent(s:SearchForBlockStart('\<class\>' , '', '\<endclass\>' , v:lnum, 0))
    elseif s:curr_line =~ '^\s*\<end\>'
      return indent(s:SearchForBlockStart('\<begin\>' , '', '\<end\>'      , v:lnum, 1))
    elseif s:curr_line =~ '^\s*\<endcase\>'
      return indent(s:SearchForBlockStart(s:vlog_case , '', '\<endcase\>'  , v:lnum, 0))
    endif
  endif

  if s:curr_line =~ '^\s*\<while\>\s*(.*'.s:vlog_end_statement
    return indent(s:SearchForBlockStart('\<do\>', '', '\<while\>\s*(.*'.s:vlog_end_statement, v:lnum, 1))
  elseif s:curr_line =~ '^\s*`\(endif\|else\|elsif\)\>'
    return indent(s:SearchForBlockStart(s:vlog_preproc, '`else\>\|`elsif\>', '`endif\>', v:lnum, 1))
  elseif s:curr_line =~ '^\s*' . s:vlog_join
    return indent(s:SearchForBlockStart('^\s*\<fork\>', '', s:vlog_join, v:lnum, 1))
  endif

  if s:InsideSynPattern('verilogDefine', v:lnum) && s:curr_line !~ s:vlog_define
    return (indent(s:SearchBackForPattern(s:vlog_define, v:lnum)) + s:offset)
  endif

  if s:curr_line =~ '^\s*'.s:vlog_comment.'\s*$' &&
        \ getline(v:lnum + 1) =~ '^\s*else'
    return indent(v:lnum + 1)
  endif

  if s:curr_line =~ s:vlog_statement &&
        \ getline(v:lnum - 1) =~ '^\s*\(end\s*\)\?else\s*$'
    return indent(v:lnum - 1) + s:offset
  endif

  return s:GetContextIndent()

endfunction

function! s:GetLineStripped(lnum)
  if s:IsComment(a:lnum)
    return ""
  endif

  let l:temp = getline(a:lnum)

  " Remove inline comments unless the whole line is a comment
  if l:temp !~ '^\s*'.s:vlog_comment.'\s*$'
    let l:temp = substitute(l:temp, '/\*.\{-}\*/\|//.*', '', 'g')
  endif

  " Remove strings
  return substitute(l:temp, '".\{-}"', '""', 'g')
endfunction

function! s:SearchBackForPattern(pattern, current_line_no)
  let l:lnum = a:current_line_no

  while l:lnum > 0
    let l:lnum = search(a:pattern, 'bW')
    if getline(l:lnum) !~ s:vlog_comment
      call verilog#Verbose("Reset indent for context end -> " . a:keyword)
      return l:lnum
    endif
  endwhile

endfunction

" For any kind of block with a provided end pattern and start pattern, return the
" line of the start of the block.
function! s:SearchForBlockStart(start_wd, mid_wd, end_wd, current_line_no, skip_start_end)
  call cursor(a:current_line_no, 1)

  " Detect whether the cursor is on a comment.
  let l:skip_arg  = 'synIDattr(synID(".", col("."), 0), "name") == "verilogComment"'
  let l:skip_arg .= ' || synIDattr(synID(".", col("."), 0), "name") == "verilogString"'

  if a:skip_start_end == 1
    let l:skip_arg =
          \ l:skip_arg." || getline('.') =~ '".a:end_wd.'.\{-}'.a:start_wd."'"
  endif

  let l:lnum = searchpair(a:start_wd, a:mid_wd, a:end_wd, 'bnW', l:skip_arg)
  call verilog#Verbose('SearchForBlockStart: returning l:lnum ' . l:lnum)
  return l:lnum
endfunction

" Calculates the current line's indent taking into account its context
"
" It checks all lines before the current and when it finds an indenting
" context adds an s:offset to its indent value. Extra indent offset
" related with open statement, for example, are stored in l:open_offset
" to caculate the final indent value.
function! s:GetContextIndent()
  let l:bracket_level  = 0
  let l:cbracket_level = 0

  let l:lnum = v:lnum
  let l:oneline_mode = 1
  let l:look_for_open_statement = 1
  let l:look_for_open_assign = 0
  let l:open_offset = 0

  " Loop that searches up the file to build a context and determine the correct
  " indentation.
  while l:lnum > 1

    let l:lnum = prevnonblank(l:lnum - 1)
    let l:line = getline(l:lnum)

    " Never use comments to determine indentation.
    if l:line =~ '^\s*' . s:vlog_comment
      continue
    endif

    let l:line = s:GetLineStripped(l:lnum)

    if l:line == ""
      continue
    endif

    call verilog#Verbose("GetContextIndent:" . l:lnum . ": " . l:line)

    if l:look_for_open_statement == 1
      if l:line =~ s:vlog_open_statement . '\s*$' &&
            \ l:line !~ '/\*\s*$' ||
            \ s:curr_line =~ '^\s*' . s:vlog_open_statement &&
            \ s:curr_line !~ '^\s*/\*' &&
            \ s:curr_line !~ s:vlog_comment && !s:IsComment(v:lnum) ||
            \ l:line =~ '\<or\>' && s:InsideSynPattern("verilogExpression", l:lnum, "$")
        let l:open_offset = s:offset
        call verilog#Verbose("Increasing indent for an open statement.")
        if (!verilog#VariableExists("verilog_indent_assign_fix"))
          let l:look_for_open_assign = 1
        endif
      endif
      let l:look_for_open_statement = 0
    endif

    if l:look_for_open_assign == 1
      if s:curr_line !~ s:vlog_conditional &&
            \ l:line =~ s:vlog_conditional &&
            \ index(s:verilog_disable_indent, 'conditional') < 0
        " Return the length of the last line up to the first character after the
        " first '?'
        return len(substitute(l:line, '?\s*\zs.*', '', ""))
      endif
      " Search for assignments (=, <=) that don't end in ";"
      if l:line =~ s:vlog_assign . '[^;]*$' && (!s:InsideAssign(l:lnum))
        if l:line !~ s:vlog_assign . '\s*$'
          " If there are values after the assignment, then use that column as
          " the indentation of the open statement.
          let l:assign = substitute(l:line, s:vlog_assign .'\s*\zs.*', '', "")
          let l:assign_offset = len(l:assign)
          call verilog#Verbose(
            "Increasing indent for an open assignment with values (by " . l:assign_offset .")."
          )
        else
          " If the assignment is empty, simply increment the indent by one
          " level.
          let l:assign_offset = indent(l:lnum) + s:offset
          call verilog#Verbose(
            "Increasing indent for an empty open assignment (by " . l:assign_offset .")."
          )
        endif
        return l:assign_offset
      endif
    endif

    if l:line =~ '\<begin\>' && l:line !~ '\<begin\>.*\<end\>'
      call verilog#Verbose("Inside a 'begin end' block.")
      return indent(l:lnum) + s:offset + l:open_offset
    elseif l:line =~ '^\s*\<fork\>'
      call verilog#Verbose("Inside a 'fork join' block.")
      return indent(l:lnum) + s:offset + l:open_offset
    elseif l:line =~ s:vlog_case
      call verilog#Verbose("Inside a 'case' block.")
      return indent(l:lnum) + s:offset + l:open_offset
    endif

    " If we hit an 'end', 'endcase' or 'join', skip past the whole block.
    if l:line =~ '\<end\>' && l:line !~ '\<begin\>.*\<end\>' && l:line !~ '\<begin\>\s*$'
      let l:lnum = s:SearchForBlockStart('\<begin\>', '', '\<end\>', l:lnum, 1)
      let l:oneline_mode = 0
      let l:line = s:GetLineStripped(l:lnum)
    endif

    if l:line =~ s:vlog_join
      let l:lnum = s:SearchForBlockStart('^\s*\<fork\>', '', s:vlog_join, l:lnum, 1)
      let l:oneline_mode = 0
      let l:line = s:GetLineStripped(l:lnum)
    endif

    if l:line =~ '\<endcase\>'
      let l:lnum = s:SearchForBlockStart(s:vlog_case, '', '\<endcase\>', l:lnum, 1)
      let l:oneline_mode = 0
      let l:line = s:GetLineStripped(l:lnum)
    endif

    " Store end-of-statement indent level in case this is an instance
    if l:line =~ s:vlog_end_statement
      let l:instance_indent = indent(l:lnum)
      if index(s:verilog_disable_indent, 'eos') < 0
        let l:instance_indent -= s:offset
      endif
      call verilog#Verbose("Found possible end of instance on line ".l:lnum." with level ".l:instance_indent)
    endif

    " If a instance port connection is found, then return previously detected instance indent level
    if l:line =~ '^\s*\.\k' && exists('l:instance_indent')
      call verilog#Verbose("Found instance at line ".l:lnum.". Returning previously stored indent level ".l:instance_indent)
      return l:instance_indent
    endif

    if l:line =~ '[()]'
      let l:bracket_level +=
            \ s:CountMatches(l:line, ')') - s:CountMatches(l:line, '(')
      if l:bracket_level < 0
        call verilog#Verbose("Inside a '()' block.")
        return indent(l:lnum) + s:offset
      endif
    endif

    if l:line =~ '[{}]'
      let l:cbracket_level +=
            \ s:CountMatches(l:line, '}') - s:CountMatches(l:line, '{')
      if l:cbracket_level < 0
        call verilog#Verbose("Inside a '{}' block.")
        return indent(l:lnum) + s:offset + l:open_offset
      endif
    endif

    if l:oneline_mode == 1 && l:line =~ s:vlog_statement
      let l:oneline_mode = 0
    elseif l:oneline_mode == 1 && l:line =~ '\<begin\>.*\<end\>'
      call verilog#Verbose("'begin'..'end' pair.")
      return indent(l:lnum)
    elseif l:oneline_mode == 1 && l:line =~ s:vlog_block_decl && l:line !~ '\<begin\>.*\<end\>'
      if s:curr_line =~ '^\s*\<begin\>'
        call verilog#Verbose("Standalone 'begin' after block declaration.")
        return indent(l:lnum)
      elseif s:curr_line =~ '^\s*{\s*$' && l:cbracket_level == 0
        call verilog#Verbose("Standalone '{' after block declaration.")
        return indent(l:lnum)
      elseif s:curr_line =~ '^\s*(\s*$' && l:bracket_level == 0
        call verilog#Verbose("Standalone '(' after block declaration.")
        return indent(l:lnum)
      else
        call verilog#Verbose("Indenting a single line block.")
        return indent(l:lnum) + s:offset + l:open_offset
      endif
    elseif s:curr_line =~ '^\s*else' && l:line =~ '\<\(if\|assert\)\>\s*(.*)'
      call verilog#Verbose("'else' of 'if' or 'assert'.")
      return indent(l:lnum)
    endif

    if l:line =~ s:vlog_module
      return s:GetContextStartIndent("module"    , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_interface
      return s:GetContextStartIndent("interface" , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_class
      return s:GetContextStartIndent("class"     , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_package
      return s:GetContextStartIndent("package"   , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_covergroup
      return s:GetContextStartIndent("covergroup", l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_program
      return s:GetContextStartIndent("program"   , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_generate
      return s:GetContextStartIndent("generate"  , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_sequence
      return s:GetContextStartIndent("sequence"  , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_clocking
      return s:GetContextStartIndent("clocking"  , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_property
      return s:GetContextStartIndent("property"  , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_method && s:InsideSynPattern('verilog\(Task\|Function\)', l:lnum, "$")
      return s:GetContextStartIndent("method"    , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_preproc
      return s:GetContextStartIndent("preproc"   , l:lnum) + l:open_offset
    elseif l:line =~ s:vlog_context_end
      call verilog#Verbose("After the end of a context.")
      return indent(l:lnum)
    endif

  endwhile

  " Return any calculated extra offset if no indenting context was found
  return l:open_offset
endfunction

function! s:GetContextStartIndent(name, lnum)
  call verilog#Verbose("Inside a " . a:name . ".")
  if index(s:verilog_disable_indent, a:name) >= 0
    return indent(a:lnum)
  else
    return indent(a:lnum) + s:offset
endfunction

function! s:CountMatches(line, pattern)
  return len(split(a:line, a:pattern, 1)) - 1
endfunction

function! s:IsComment(lnum)
  return synIDattr(synID(a:lnum, 1, 0), "name") == "verilogComment"
endfunction

function! s:InsideAssign(lnum)
  return synIDattr(synID(a:lnum, 1, 0), "name") == "verilogAssign"
endfunction

function! s:InsideSynPattern(pattern, lnum, ...)
  " Check for optional column number/pattern
  if a:0 >= 1
    let l:cnum = a:1
  else
    let l:cnum = 1
  endif
  " Determine column number if using a pattern
  if type(l:cnum) != 0
    let l:cnum = col([a:lnum, l:cnum])
  endif

  for id in synstack(a:lnum, l:cnum)
    if synIDattr(id, "name") =~ a:pattern
      return 1
    endif
  endfor
  return 0
endfunction

" vi: sw=2 sts=2:
