scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


" Workaround issues #12
function! s:escape_substitute_sub(str)
	return substitute(a:str, '&', '\\&', "g")
endfunction


function! s:extend_list(list)
	return empty(a:list)    ? {}
\		 : len(a:list) == 1 ? a:list[0]
\		 : extend(deepcopy(a:list[0]), s:extend_list(a:list[1:]))
endfunction



function! jplus#getchar()
	let c = nr2char(getchar())
	return c =~ '[[:print:]]' ? c : ""
endfunction


function! s:join_list(list, c, ignore, left_match, right_match)
	let list = filter(a:list, 'len(v:val) && !(a:ignore != "" && (v:val =~ a:ignore))')

	if empty(list)
		return []
	endif

	let result = list[0]
	for i in list[1:]
		let result = matchstr(result, a:left_match) . a:c . matchstr(i, a:right_match)
	endfor
	return result
endfunction



function! s:add_comment_leader_pattern(current_pattern)
	if &formatoptions !~ 'j'
		return a:current_pattern
	endif

	let flags = '\(^:\|m\)'
	let to_consider = filter(split(&comments, ','), 'v:val =~ flags')
	call map(to_consider, 'split(v:val, ":")[-1]')

	if len(to_consider) == 0
		return a:current_pattern
	endif

	" Escape special characters
	let to_escape = '\([*.]\)'
	let replace_with = '\\\1'
	call map(to_consider, 'substitute(v:val, to_escape, replace_with, "g")')

	" Construct patterns
	let before = '^\s*'
	let after = '\s*\zs.*'
	call map(to_consider, 'before . v:val . after')

	" Note: a:current_pattern MUST come at the end since it might contain '.*'
	" in the pattern, which will match even to comment leaders
	return '\%(' . join(to_consider, '\|') . '\|' . a:current_pattern . '\)'
endfunction



function! s:join(config)
	let ignore =  a:config.ignore_pattern
	let left_matchstr = a:config.left_matchstr_pattern
	let right_matchstr = s:add_comment_leader_pattern(a:config.right_matchstr_pattern)
	let delimiter = s:escape_substitute_sub(a:config.delimiter)
	let c = substitute(a:config.delimiter_format, '%d', delimiter, "g")
	let start = a:config.firstline
	let lastline = a:config.firstline + a:config.line_num
	let end = lastline + (start == lastline)

	if end > line("$")
		return
	endif

	let line = s:join_list(getline(start, end), c, ignore, left_matchstr, right_matchstr)

	let view = winsaveview()
	let new_col = len(line) - len(matchstr(getline(end), right_matchstr))
	let view['col'] = new_col - 1
	call setline(start, line)

	if start+1 <= end
		silent execute start+1 . ',' . end 'delete _'
	endif

	if end <= line("$")
		normal! -1
	endif
	call winrestview(view)
endfunction



let g:jplus#default_config = {
\	"_" : {
\		"left_matchstr_pattern" : '.\{-}\ze\s*$',
\		"right_matchstr_pattern" : '\s*\zs.*',
\		"ignore_pattern" : '',
\		"delimiter" : " ",
\		"delimiter_format" : "%d",
\	},
\	"bash" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\	"c" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\	"cpp" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\	"ruby" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\	"python" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\	"vim" : {
\		"right_matchstr_pattern" : '^\s*\\\s*\zs.*\|\s*\zs.*',
\	},
\	"zsh" : {
\		"left_matchstr_pattern" : '^.\{-}\%(\ze\s*\\$\|$\)',
\	},
\}


let g:jplus#config = get(g:, "jplus#config", {})

function! jplus#get_config(filetype, ...)
	return s:extend_list([
\		get(g:jplus#default_config, "_", {}),
\		get(g:jplus#config, "_", {}),
\		get(g:jplus#default_config, a:filetype, {}),
\		get(g:jplus#config, a:filetype, {}),
\		get(a:, 1, {})
\	])
endfunction


let g:jplus#input_config = get(g:, "jplus#input_config", {})

function! jplus#get_input_config(input, filetype, ...)
	let empty_keyword = a:input ==# "" ? "__EMPTY__" : a:input
	return s:extend_list([
\		get(g:jplus#default_config, "_", {}),
\		get(g:jplus#config, "_", {}),
\		get(g:jplus#input_config, "__DEFAULT__", {}),
\		get(g:jplus#default_config, a:filetype, {}),
\		get(g:jplus#config, a:filetype, {}),
\		{ "delimiter" : a:input },
\		get(g:jplus#input_config, empty_keyword, {}),
\		get(a:, 1, {})
\	])
endfunction


function! jplus#join(config) range
	if &modifiable == 0
		return
	endif
	let config = extend({
\		"firstline" : a:firstline,
\		"line_num"  : a:lastline - a:firstline,
\	}, a:config)
	let s:latest_config = a:config
	let s:latest_config.line_num = config.line_num
	let &operatorfunc = "jplus#operatorfunc_latest_repeat"
	call feedkeys("g@g@", "n")
" 	execute "normal!" (mode() =~# "[vV\<C-v>]") ? "g@" : "g@g@"
endfunction


function! jplus#join_latest_repeat()
	if exists("s:latest_config")
		let config = extend({
	\		"firstline" : a:firstline,
	\		"line_num"  : a:lastline - a:firstline,
	\	}, s:latest_config)
		call s:join(config)
	endif
endfunction


function! jplus#mapexpr_join(...)
	let g:jplus_tmp_config = get(a:, 1, {})
	return ":call jplus#join(g:jplus_tmp_c, g:jplus_tmp_config)\<CR>"
endfunction


function! s:operatorfunc(wise, ...)
	let base = get(a:, 1, {})
	let first = getpos("'[")[1]
	let last = getpos("']")[1]
	let config = base
	call jplus#join(extend({
\		"firstline" : first,
\		"lastline"  : last,
\	}, config))
endfunction


function! jplus#operatorfunc(wise)
	return s:operatorfunc(a:wise, jplus#get_config(&filetype))
endfunction


function! jplus#operatorfunc_input(wise)
	return s:operatorfunc(a:wise, jplus#get_input_config(input("Input joint delimiter : "), &filetype))
endfunction


function! jplus#operatorfunc_getchar(wise)
	return s:operatorfunc(a:wise, jplus#get_input_config(jplus#getchar(), &filetype))
endfunction


function! jplus#operatorfunc_latest_repeat(...)
	return jplus#join_latest_repeat()
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
