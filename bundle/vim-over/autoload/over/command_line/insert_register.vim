scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! over#command_line#insert_register#load()
	" load
endfunction


function! s:to_string(expr)
	return type(a:expr) == type("") ? a:expr : string(a:expr)
endfunction


function! s:input()
	call over#command_line#hl_cursor_on()
	try
		call over#command_line#redraw()
		let input = input("=", "", "expression")
		if !empty(input)
			let input = s:to_string(eval(input))
		endif
	catch
		return ""
	finally
		call over#command_line#hl_cursor_off()
	endtry
	return input
endfunction


function! s:main()
	if over#command_line#is_input("\<C-r>")
		call over#command_line#setchar('"')
		call over#command_line#wait_keyinput_on("InsertRegister")
		let s:old_line = over#command_line#getline()
		let s:old_pos  = over#command_line#getpos()
		return
	elseif over#command_line#get_wait_keyinput() == "InsertRegister"
		call over#command_line#setline(s:old_line)
		call over#command_line#setpos(s:old_pos)
		let key = over#command_line#keymap(over#command_line#char())
		if key =~ '^[0-9a-zA-z.%#:/"\-*]$'
			execute "let regist = @" . key
			call over#command_line#setchar(regist)
		elseif key == '='
			call over#command_line#setchar(s:input())
		elseif key == "\<C-w>"
			call over#command_line#setchar(s:cword)
		elseif key == "\<C-a>"
			call over#command_line#setchar(s:cWORD)
		elseif key == "\<C-f>"
			call over#command_line#setchar(s:cfile)
		elseif key == "\<C-r>"
			call over#command_line#setchar('"')
		endif
	endif
endfunction


function! s:on_OverCmdLineChar()
	if over#command_line#is_input("\<C-r>", "InsertRegister")
		call over#command_line#setpos(over#command_line#getpos()-1)
	else
		call over#command_line#wait_keyinput_off("InsertRegister")
	endif
endfunction


function! s:save_op()
	let s:cword = expand("<cword>")
	let s:cWORD = expand("cWORD")
	let s:cfile = expand("<cfile>")
endfunction

augroup over-cmdline-insert_register
	autocmd!
	autocmd User OverCmdLineEnter call s:save_op()
	autocmd User OverCmdLineCharPre call s:main()
	autocmd User OverCmdLineChar call s:on_OverCmdLineChar()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
