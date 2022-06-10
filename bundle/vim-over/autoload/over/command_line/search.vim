scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let g:over#command_line#search#enable_incsearch = get(g:, "over#command_line#search#enable_incsearch", 1)
let g:over#command_line#search#enable_move_cursor = get(g:, "over#command_line#search#enable_move_cursor", 0)


function! over#command_line#search#load()
	" load
endfunction


function! s:search_hl_off()
	if exists("s:search_id") && s:search_id != -1
		call matchdelete(s:search_id)
		unlet s:search_id
	endif
endfunction


function! s:search_hl_on(pattern)
	call s:search_hl_off()
	silent! let s:search_id = matchadd("IncSearch", a:pattern)
endfunction


function! s:main()
	call s:search_hl_off()
	let line = over#command_line#backward()
	if line =~ '^/.\+'
\	|| line =~ '^?.\+'
		let pattern = matchstr(line, '^\(/\|?\)\zs.\+')
		if g:over#command_line#search#enable_incsearch
			call s:search_hl_on((&ignorecase ? '\c' : "") . pattern)
		endif
		if g:over#command_line#search#enable_move_cursor
			if line =~ '^/.\+'
				silent! call search(pattern, "c")
			else
				silent! call search(pattern, "cb")
			endif
		endif
	endif
endfunction


augroup over-cmdline-search
	autocmd!
	autocmd User OverCmdLineChar call s:main()
	autocmd User OverCmdLineLeave call s:search_hl_off()
	autocmd User OverCmdLineEnter let s:old_pos = getpos(".")
	autocmd User OverCmdLineExecutePre call setpos(".", s:old_pos)
augroup END



let &cpo = s:save_cpo
unlet s:save_cpo

