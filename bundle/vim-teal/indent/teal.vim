" Vim indent file
" Language: Teal

" Adapted from https://github.com/tbastos/vim-lua and the default lua file

" {{{ setup
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

let s:cpo_save = &cpo
set cpo&vim

setlocal autoindent
setlocal nosmartindent

setlocal indentexpr=GetTealIndent(v:lnum)
setlocal indentkeys+=0=end,0=until

if exists("*GetTealIndent")
	finish
endif
" }}}
" {{{ Patterns

" [\t ] seems to be faster than \s
let s:begin_block_open_patt = '\C^[\t ]*\%(if\|for\|while\|repeat\|else\|elseif\|do\|then\)\>'
let s:end_block_open_patt = '\C\%((\|{\|then\|do\)[\t ]*$'
let s:block_close_patt = '\C^[\t ]*\%(\%(end\|else\|elseif\|until\)\>\|}\|)\)'

let s:middle_patt = '\C\<\%(function\|record\|enum\)\>'
let s:ignore_patt = 'String$\|Comment$\|Type$'

let s:starts_with_bin_op = '\C^[\t ]*\([<>=~^&|*/%+-.:]\|\%(or\|and\|is\|as\)\>\)'

" }}}
" {{{ Helpers
function s:IsIgnorable(line_num, column)
	return synIDattr(synID(a:line_num, a:column, 1), 'name') =~# s:ignore_patt
		\ && !(getline(a:line_num) =~# '^[\t ]*\%(--\)\?\[=*\[')
endfunction

function s:PrevLineOfCode(line_num)
	let line_num = prevnonblank(a:line_num)
	while s:IsIgnorable(line_num, 1)
		let line_num = prevnonblank(line_num - 1)
	endwhile
	return line_num
endfunction

" strip comments
function s:GetLineContent(line_num)
	" remove trailing -- ...
	let content = getline(a:line_num)
	return substitute(content, '--.*$', '', '')
endfunction

function s:MatchPatt(line_num, line_content, patt, prev_match)
	if a:prev_match != -1
		return a:prev_match
	endif
	let match_index = match(a:line_content, a:patt)
	if match_index != -1 &&
		\ synIDattr(synID(a:line_num, match_index+1, 1), "name") =~# s:ignore_patt
		let match_index = -1
	endif
	return match_index
endfunction
" }}}
" {{{ The Indent function
function GetTealIndent(lnum)
	if s:IsIgnorable(a:lnum, 1)
		return indent(a:lnum - 1)
	endif
	let prev_line_num = s:PrevLineOfCode(a:lnum - 1)
	if prev_line_num == 0
		return 0
	endif

	let prev_line = s:GetLineContent(prev_line_num)

	let i = 0
	let match_index = s:MatchPatt(prev_line_num, prev_line, s:begin_block_open_patt, -1)
	let match_index = s:MatchPatt(prev_line_num, prev_line, s:end_block_open_patt, match_index)
	let match_index = s:MatchPatt(prev_line_num, prev_line, s:middle_patt, match_index)

	" If the previous line opens a block (and doesnt close it), >>
	if match_index != -1 && prev_line !~# '\C\<\%(end\|until\)\>'
		let i += 1
	endif

	" If the current line closes a block, <<
	let curr_line = s:GetLineContent(a:lnum)
	let match_index = s:MatchPatt(a:lnum, curr_line, s:block_close_patt, -1)
	if match_index != -1
		let i -= 1
	endif

	" if line starts with bin op and previous line doesnt, >>
	let current_starts_with_bin_op = 0
	let prev_starts_with_bin_op = 0
	let match_index = s:MatchPatt(a:lnum, curr_line, s:starts_with_bin_op, -1)
	if match_index != -1
		let current_starts_with_bin_op = 1
	endif

	let match_index = s:MatchPatt(prev_line_num, prev_line, s:starts_with_bin_op, -1)
	if match_index != -1
		let prev_starts_with_bin_op = 1
	endif

	if current_starts_with_bin_op && !prev_starts_with_bin_op
		let i += 1
	elseif !current_starts_with_bin_op && prev_starts_with_bin_op
		let i -= 1
	endif

	if i > 1

		let i = 1
  " elseif i < -1
	" 	let i = -1

	endif
	return indent(prev_line_num) + (shiftwidth() * i)
endfunction
" }}}

let &cpo = s:cpo_save
unlet s:cpo_save
