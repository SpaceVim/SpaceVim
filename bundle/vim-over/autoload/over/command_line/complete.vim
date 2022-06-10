scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! over#command_line#complete#load()
	" load
endfunction


function! s:uniq(list)
	let dict = {}
	for _ in a:list
		let dict[_] = 0
	endfor
	return keys(dict)
endfunction


function! s:buffer_complete()
	return sort(s:uniq(filter(split(join(getline(1, '$')), '\W'), '!empty(v:val)')), 1)
endfunction


function! s:parse_line(line)
	let keyword = matchstr(a:line, '\zs\w\+\ze$')
	let pos = strchars(a:line) - strchars(keyword)
	return [pos, keyword]
endfunction


function! s:make_context(...)
	let base = get(a:, 1, {})
	return extend(base, {
\		"backward" : over#command_line#backward()
\		"forward"  : over#command_line#forward()
\	})
endfunction


function! s:get_complete_words()
	return s:buffer_complete()
endfunction


function! s:as_statusline(list, count)
	if empty(a:list)
		return
	endif
	let hl_none = "%#StatusLine#"
	let hl_select = "%#StatusLineNC#"
	let tail = " > "
	let result = a:list[0]
	let pos = 0
	for i in range(1, len(a:list)-1)
		if strdisplaywidth(result . " " . a:list[i]) > &columns - len(tail)
			if a:count < i
				break
			else
				let pos = -i
			endif
			let result = a:list[i]
		else
			let result .= (" " . a:list[i])
		endif
		if a:count == i
			let pos = pos + i
		endif
	endfor
	return join(map(split(result, " "), 'v:key == pos ? hl_select . v:val . hl_none : v:val'))
endfunction


function! s:start()
	let s:old_statusline = &statusline

	let backward = over#command_line#backward()
	let [pos, keyword] = s:parse_line(backward)

	if !exists("s:complete")
		let s:complete = s:get_complete_words()
	endif
	let s:complete_list = filter(copy(s:complete), 'v:val =~ ''^''.keyword')
	if empty(s:complete_list)
		return -1
	endif

	if pos == 0
		let backward = ""
	else
		let backward = join(split(backward, '\zs')[ : pos-1 ], "")
	endif
	let s:line = backward . over#command_line#forward()
	let s:pos = pos
	call over#command_line#setline(s:line)

	let s:count = 0
endfunction


function! s:finish()
	if exists("s:old_statusline")
		let &statusline = s:old_statusline
		unlet s:old_statusline
	endif
endfunction



function! s:main()
	if over#command_line#is_input("\<Tab>")
		if s:start() == -1
			call s:finish()
			call over#command_line#setchar('')
			return
		endif
		call over#command_line#setchar('')
		call over#command_line#wait_keyinput_on("Completion")
	elseif over#command_line#is_input("\<Tab>", "Completion")
\		|| over#command_line#is_input("\<C-f>", "Completion")
		call over#command_line#setchar('')
		let s:count += 1
		if s:count >= len(s:complete_list)
			let s:count = 0
		endif
	elseif over#command_line#is_input("\<C-b>", "Completion")
		call over#command_line#setchar('')
		let s:count -= 1
		if s:count < 0
			let s:count = len(s:complete_list) - 1
		endif
	else
		call over#command_line#wait_keyinput_off("Completion")
		call s:finish()
		return
	endif
	call over#command_line#setline(s:line)
	call over#command_line#insert(s:complete_list[s:count], s:pos)
	if len(s:complete_list) > 1
		let &statusline = s:as_statusline(s:complete_list, s:count)
	endif
endfunction


augroup over-cmdwindow-complete
	autocmd!
	autocmd User OverCmdLineCharPre call s:main()
	autocmd User OverCmdLineLeave unlet! s:complete
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo
