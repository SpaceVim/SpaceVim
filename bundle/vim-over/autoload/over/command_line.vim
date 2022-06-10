scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let g:over#command_line#enable_import_commandline_map = get(g:, "over#command_line#enable_import_commandline_map", 1)
let g:over#command_line#substitute#replace_pattern_visually = get(g:, "over#command_line#substitute#replace_pattern_visually", 0)

function! over#command_line#load()
	" dummy
endfunction

let s:V = over#vital()
let s:Highlight = s:V.import("Coaster.Highlight")
let s:Modules   = s:V.import("Over.Commandline.Modules")


unlet! s:_cmdline
function! s:cmdline()
	if exists("s:_cmdline")
		return s:_cmdline
	endif
	let s:_cmdline = over#vital().import("Over.Commandline")
	return s:_cmdline
endfunction


let s:main = s:cmdline().make_standard("")
call s:main.connect(s:cmdline().get_module("Doautocmd").make("OverCmdLine"))
call s:main.connect(s:cmdline().get_module("KeyMapping").make_emacs())
call s:main.connect("BufferComplete")
call s:main.connect("ExceptionMessage")
" call s:main.connect("Paste")



let g:over#command_line#paste_escape_chars = get(g:, "over#command_line#paste_escape_chars", '')


let s:default_filters = {
\	"\n" : '\\n',
\	"\r" : '\\r',
\}

let g:over#command_line#paste_filters = get(g:, "over#command_line#paste_filters", s:default_filters)


let s:module = {
\	"name" : "Paste"
\}

function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("<Over>(paste)")
		let register = v:register == "" ? '"' : v:register
		let text = escape(getreg(register), g:over#command_line#paste_escape_chars)
		for [pat, rep] in items(g:over#command_line#paste_filters)
			let text = substitute(text, pat, rep, "g")
		endfor
		call a:cmdline.insert(text)
		call a:cmdline.setchar('')
	endif
endfunction
call s:main.connect(s:module)
unlet s:module


" call s:main.cnoremap("\<Tab>", "<Over>(buffer-complete)")

let s:base_keymapping = {
\	"\<Tab>" : {
\		"key" : "<Over>(buffer-complete)",
\		"lock" : 1,
\		"noremap" : 1,
\	},
\	"\<C-v>" : {
\		"key" : "<Over>(paste)",
\		"lock" : 1,
\		"noremap" : 1,
\	}
\}

function! s:main.keymapping()
	return extend(
\		deepcopy(s:base_keymapping),
\		g:over_command_line_key_mappings,
\	)
endfunction



let s:module = {
\	"name" : "Scroll"
\}
function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("\<Plug>(over-cmdline-scroll-y)")
		execute "normal! \<C-y>"
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<Plug>(over-cmdline-scroll-u)")
		execute "normal! \<C-u>"
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<Plug>(over-cmdline-scroll-f)")
		execute "normal! \<C-f>"
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<Plug>(over-cmdline-scroll-e)")
		execute "normal! \<C-e>"
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<Plug>(over-cmdline-scroll-d)")
		execute "normal! \<C-d>"
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<Plug>(over-cmdline-scroll-b)")
		execute "normal! \<C-b>"
		call a:cmdline.setchar('')
	endif
endfunction
call s:main.connect(s:module)


let g:over#command_line#enable_Digraphs = get(g:, "over#command_line#enable_Digraphs", 1)

function! over#command_line#start(prompt, input, ...)
	let context = get(a:, 1, {})

	if g:over#command_line#enable_Digraphs
\	&& empty(over#command_line#get().get_module("Digraphs"))
		call over#command_line#get().connect("Digraphs")
	else
		call over#command_line#get().disconnect("Digraphs")
	endif

	if g:over#command_line#enable_import_commandline_map == 0
		call s:main.disconnect("KeyMapping_vim_cmdline_mapping")
	else
		call s:main.connect(s:Modules.get("KeyMapping").make_vim_cmdline_mapping())
	endif

	if get(context, "line1", 1) != get(context, "line2", 1)
		call s:main.connect(s:hl_visualmode)
	else
		call s:main.disconnect("HighlightVisualMode")
	endif

	if exists("*strchars") && has("conceal")
		call s:main.set_prompt(a:prompt)
		let exit_code = s:main.start(a:input)
		if exit_code == 1
			doautocmd User OverCmdLineCancel
		endif
	else
		echohl ErrorMsg
		echo "Vim 7.3 or above and +conceal."
		echo "Need strchars()."
		echohl NONE
	endif
endfunction


function! over#command_line#getline()
	return s:main.getline()
endfunction

function! over#command_line#setline(line)
	return s:main.set(a:line)
endfunction

function! over#command_line#char()
	return s:main.char()
endfunction

function! over#command_line#setchar(char)
	call s:main.setchar(a:char)
endfunction

function! over#command_line#getpos()
	return s:main.getpos()
endfunction

function! over#command_line#setpos(pos)
	return s:main.setpos(a:pos)
endfunction


function! over#command_line#wait_keyinput_on(key)
	return s:main.tap_keyinput(a:key)
endfunction

function! over#command_line#wait_keyinput_off(key)
	return s:main.untap_keyinput(a:key)
endfunction

function! over#command_line#get_wait_keyinput()
	return s:main.get_tap_key()
endfunction


function! over#command_line#is_input(...)
	return call(s:main.is_input, a:000, s:main)
endfunction


function! over#command_line#insert(...)
	return call(s:main.insert, a:000, s:main)
endfunction

function! over#command_line#forward()
	return s:main.forward()
endfunction

function! over#command_line#backward()
	return s:main.backward()
endfunction


call over#command_line#substitute#load()
call over#command_line#search#load()
call over#command_line#global#load()


function! over#command_line#do(input)
	call s:main.start(a:input)
	return s:main.getline()
endfunction


function! over#command_line#get()
	return s:main
endfunction



let s:hl_visualmode = {
\	"name" : "HighlightVisualMode"
\}

function! s:hl_visualmode.on_enter(...)
	if &selection == "exclusive"
		let pat = '\%''<\|\%>''<.*\%<''>'
	else
		let pat = '\%''<\|\%>''<.*\%<''>\|\%''>'
	endif

	call s:Highlight.highlight("visualmode", "Visual", pat, 0)
endfunction


function! s:hl_visualmode.on_leave(...)
	call s:Highlight.clear("visualmode")
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
