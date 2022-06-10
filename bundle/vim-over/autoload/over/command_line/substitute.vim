scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! over#command_line#substitute#load()
	" load
endfunction


let s:V = over#vital()
let s:Rocker = s:V.import("Unlocker.Rocker")
let s:Undo = s:V.import("Unlocker.Rocker.Undotree")


let s:hl_mark_begin = ''
let s:hl_mark_center = ''
let s:hl_mark_end   = ''


let g:over#command_line#substitute#highlight_pattern = get(g:, "over#command_line#substitute#highlight_pattern", "Search")

if hlexists("Error")
	let g:over#command_line#substitute#highlight_string = get(g:, "over#command_line#substitute#highlight_string", "Error")
else
	let g:over#command_line#substitute#highlight_string = get(g:, "over#command_line#substitute#highlight_string", "ErrorMsg")
endif


function! s:init()
	if &modifiable == 0
		return
	endif
	let s:undo_flag = 0

	let hl_f = "syntax match %s '%s' conceal containedin=.*"
	execute printf(hl_f, "OverCmdLineSubstituteHiddenBegin", s:hl_mark_begin)
	execute printf(hl_f, "OverCmdLineSubstituteHiddenCenter", s:hl_mark_center)
	execute printf(hl_f, "OverCmdLineSubstituteHiddenEnd", s:hl_mark_end)
" 	syntax match OverCmdLineSubstituteHiddenBegin  '`os`' conceal containedin=ALL
" 	syntax match OverCmdLineSubstituteHiddenMiddle '`om`' conceal containedin=ALL
" 	syntax match OverCmdLineSubstituteHiddenEnd    '`oe`' conceal containedin=ALL
	
" 	let s:undo_file = tempname()
" 	execute "wundo" s:undo_file

" 	let s:old_pos = getpos(".")

	let s:locker = s:Rocker.lock(
\		"&scrolloff",
\		"&l:conceallevel",
\		"&l:concealcursor",
\		"&l:modified",
\		"&l:undolevels",
\	)
	let &scrolloff = 0
	let s:old_modified = &l:modified

	let s:undo_locker = s:Undo.make().lock()

	" Workaround https://github.com/osyo-manga/vim-over/issues/43
	" substitute use undo
	setlocal undolevels=0

	let s:finished = 0
" 	let s:buffer_text = getline(1, "$")
endfunction


function! s:finish()
	if &modifiable == 0 || s:finished
		return
	endif
	call s:reset_match()
	let s:finished = 1
" 	call setpos(".", s:old_pos)
	call s:locker.unlock()
	
" 	highlight link OverCmdLineSubstitute NONE
" 	highlight link OverCmdLineSubstitutePattern NONE
" 	highlight link OverCmdLineSubstituteString  NONE
endfunction


function! s:undojoin()
	if exists("s:undo_locker")
		call s:undo()
" 		call setline(1, s:buffer_text)
		call s:undo_locker.unlock()
" 		if filereadable(s:undo_file)
" 			silent execute "rundo" s:undo_file
" 		endif
		unlet s:undo_locker
" 		unlet s:undo_file
	endif
endfunction


function! s:silent_undo()
	let pos = getpos(".")
	redir => _
	silent undo
	redir END
	call setpos(".", pos)
endfunction


function! s:undo()
	if s:undo_flag
		call s:silent_undo()
		let s:undo_flag = 0
	endif
endfunction


function! s:matchadd(group, pat)
	if hlID(a:group)
		try
			let id = matchadd(a:group, a:pat, 1)
		catch
			return
		endtry
		call add(s:matchlist, id)
	endif
endfunction


let s:matchlist = []
function! s:reset_match()
	for id in s:matchlist
		if id != -1
			silent! call matchdelete(id)
		endif
	endfor
	let s:matchlist = []
endfunction


function! s:silent_substitute(range, pattern, string, flags)
	try
		let flags = substitute(a:flags, 'c', '', "g")
		let old_pos = getpos(".")
		let old_search = @/
		let check = b:changedtick
		silent execute printf('%ss/%s/%s/%s', a:range, a:pattern, a:string, flags)
		call histdel("search", -1)
		let &l:modified = s:old_modified
	catch /\v^Vim%(\(\a+\))=:(E121)|(E117)|(E110)|(E112)|(E113)|(E731)|(E475)|(E15)/
		if check != b:changedtick
			call s:silent_undo()
		endif
		return 0
	catch
	finally
		call setpos(".", old_pos)
		let @/ = old_search
	endtry
	return check != b:changedtick
endfunction


function! s:substitute_preview(line)
	if &modifiable == 0
		return
	endif

	if over#command_line#is_input("\<CR>")
		return
	endif

	call s:undo()

	call s:reset_match()

	let result = over#parse_substitute(a:line)
	if empty(result)
		return
	endif
	nohlsearch

	let [range, pattern, string, flags] = result
	if empty(pattern)
		let pattern = @/
	endif

	if empty(string)
		call s:matchadd(g:over#command_line#substitute#highlight_pattern, (&ignorecase ? '\c' : '') . pattern)
		return
	endif

	let range = (range ==# "%") ? printf("%d,%d", line("w0"), line("w$")) : range
	if string =~ '^\\=.\+'

		" \="`os`" . submatch(0) . "`om`" . (submatch(0)) . "`oe`"
		let hl_submatch = printf('\\="%s" . submatch(0) . "%s" . (', s:hl_mark_begin, s:hl_mark_center)
		let string = substitute(string, '^\\=\ze.\+', hl_submatch, "") . ') . "' . s:hl_mark_end . '"'
	else
		if g:over#command_line#substitute#replace_pattern_visually
			let string = s:hl_mark_begin . s:hl_mark_center . string . s:hl_mark_end
		else
			let string = s:hl_mark_begin . '\0' . s:hl_mark_center . string . s:hl_mark_end
		endif
	endif
	let s:undo_flag = s:silent_substitute(range, pattern, string, flags)

	let &l:concealcursor = "nvic"
	let &l:conceallevel = 3

	let pattern = s:hl_mark_begin  . '\zs\_.\{-}\ze' . s:hl_mark_center
	let string  = s:hl_mark_center . '\zs\_.\{-}\ze' . s:hl_mark_end
	call s:matchadd(g:over#command_line#substitute#highlight_pattern, pattern)
	call s:matchadd(g:over#command_line#substitute#highlight_string, string)
endfunction


function! s:on_charpre()
	if over#command_line#is_input("\<Plug>(over-cmdline-substitute-jump-string)")
		let result = over#parse_substitute(over#command_line#getline())
		if empty(result)
			return
		endif
		let [range, pattern, string, flags] = result
		call over#command_line#setpos(strchars(range . pattern) + 3)
		call over#command_line#setchar("")
	endif
	if over#command_line#is_input("\<Plug>(over-cmdline-substitute-jump-pattern)")
		let result = over#parse_substitute(over#command_line#getline())
		if empty(result)
			return
		endif
		let [range, pattern, string, flags] = result
		call over#command_line#setpos(strchars(range ) + 2)
		call over#command_line#setchar("")
	endif
endfunction


augroup over-cmdline-substitute
	autocmd!
	autocmd User OverCmdLineEnter call s:init()
	autocmd User OverCmdLineExecutePre call s:undojoin()
	autocmd User OverCmdLineExecutePre call s:finish()
	autocmd User OverCmdLineLeave call s:finish()
	autocmd User OverCmdLineException call s:finish()
	autocmd User OverCmdLineException call s:undojoin()
	autocmd User OverCmdLineCancel call s:undojoin()
	autocmd User OverCmdLineChar call s:substitute_preview(over#command_line#getline())
	autocmd user OverCmdLineCharPre call s:on_charpre()
augroup END



let &cpo = s:save_cpo
unlet s:save_cpo
