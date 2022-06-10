scriptencoding utf-8
if exists('g:loaded_over')
  finish
endif
let g:loaded_over = 1

let s:save_cpo = &cpo
set cpo&vim


let g:over_enable_auto_nohlsearch    = get(g:, "over_enable_auto_nohlsearch", 1)
let g:over_enable_cmd_window         = get(g:, "over_enable_cmd_window", 1)
let g:over_command_line_prompt       = get(g:, "over_command_line_prompt", "> ")
let g:over_command_line_key_mappings = get(g:, "over_command_line_key_mappings", {})


augroup plugin-over
	autocmd!
	autocmd CmdwinEnter * if g:over_enable_cmd_window | call over#setup() | endif
	autocmd CmdwinLeave * if g:over_enable_cmd_window | call over#unsetup() | endif
augroup END


command! -range -nargs=*
\	OverCommandLine
\	call over#command_line(
\		g:over_command_line_prompt,
\		<line1> != <line2> ? printf("'<,'>%s", <q-args>) : <q-args>,
\		{ "line1" : <line1>, "line2" : <line2> }
\	)


function! s:key_mapping(lhs, rhs, noremap)
	let g:over_command_line_key_mappings[a:lhs] = {
\		"key" : a:rhs,
\		"noremap" : a:noremap,
\	}
endfunction

function! s:as_keymapping(key)
	execute 'let result = "' . substitute(a:key, '\(<.\{-}>\)', '\\\1', 'g') . '"'
	return result
endfunction

function! s:unmapping(key)
	execute 'let key = "' . substitute(a:key, '\(<.\{-}>\)', '\\\1', 'g') . '"'
	unlet g:over_command_line_key_mappings[key]
endfunction

command! -nargs=*
\	OverCommandLineNoremap
\	call call("s:key_mapping", map([<f-args>], "s:as_keymapping(v:val)") + [1])

command! -nargs=*
\	OverCommandLineMap
\	call call("s:key_mapping", map([<f-args>], "s:as_keymapping(v:val)") + [0])

command! -nargs=*
\	OverCommandLineUnmap call s:unmapping(<q-args>)


let &cpo = s:save_cpo
unlet s:save_cpo
