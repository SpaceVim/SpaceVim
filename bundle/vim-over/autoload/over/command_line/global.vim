scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" 0 = match just the pattern
" 1 = match whole line
let g:over#command_line#global#highlight_line = get(g:, "over#command_line#global#highlight_line", 0)

" 0 = do nothing
" 1 = highlight all lines not matching pattern
let g:over#command_bang#global#highlight_bang = get(g:, "over#command_bang#global#highlight_bang", 1)

function! over#command_line#global#load()
	" load
endfunction


function! s:search_hl_off()
	if exists("s:search_id") && s:search_id != -1
		call matchdelete(s:search_id)
		unlet s:search_id
	endif
endfunction


function! s:search_hl_on(pattern, bang)
	let pattern = g:over#command_line#global#highlight_line ?
				\ '.*' . a:pattern . '.*' : a:pattern
	let pattern = a:bang && g:over#command_bang#global#highlight_bang ?
				\ '^\%(\%(' . pattern . '\)\@!.\)*$' : pattern
	silent! let s:search_id = matchadd("IncSearch", a:pattern)
endfunction


function! s:main()
	call s:search_hl_off()
	let line = over#command_line#backward()
	if line =~ '\v^\%g!?\/.'
		let bang = line =~ 'g!\/'
		let pattern = matchstr(line, '\v\%g!?\/\zs%(\\\/|[^/])+')
		call s:search_hl_on((&ignorecase ? '\c' : '') . pattern, bang)
	endif
endfunction


augroup over-cmdline-global
	autocmd!
	autocmd User OverCmdLineChar call s:main()
	autocmd User OverCmdLineLeave call s:search_hl_off()
	autocmd User OverCmdLineEnter let s:old_pos = getpos(".")
	autocmd User OverCmdLineExecutePre call setpos(".", s:old_pos)
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

