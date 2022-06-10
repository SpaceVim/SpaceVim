scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! over#command_line#command_history#load()
	" load
endfunction


function! s:command_histories()
	return map(range(1, &history), 'histget(":", v:val * -1)')
endfunction


let s:cmdhist = []
let s:count = 0

function! s:main()
	if !over#command_line#is_input("\<C-p>") && !over#command_line#is_input("\<C-n>")
		let s:cmdhist = []
		let s:count = 0
		return
	else
		if s:count == 0 && empty(s:cmdhist)
			let cmdline = '^' . over#command_line#getline()
			let s:cmdhist = filter(s:command_histories(), 'v:val =~ cmdline')
		endif
	endif
	call over#command_line#setchar("")
	if over#command_line#is_input("\<C-n>")
		let s:count = max([s:count - 1, 0])
	endif
	if over#command_line#is_input("\<C-p>")
		let s:count = min([s:count + 1, len(s:cmdhist)])
	endif
	call over#command_line#setline(get(s:cmdhist, s:count, over#command_line#getline()))
endfunction

augroup over-cmdline-command_history
	autocmd!
	autocmd User OverCmdLineCharPre call s:main()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
