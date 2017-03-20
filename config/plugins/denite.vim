scriptencoding utf-8
" load api
let s:sys = SpaceVim#api#import('system')

" denite option
let s:denite_options = {'default' : {
			\ 'winheight' : 15,
			\ 'mode' : 'insert',
			\ 'quit' : 'true',
			\ 'highlight-matched-char' : 'Function',
			\ 'highlight-matched-range' : 'Function',
			\ 'direction': 'rightbelow',
			\ 'statusline' : 'false',
			\'prompt' : '➭',
			\ }}

function! s:profile(opts) abort
	for fname in keys(a:opts)
		for dopt in keys(a:opts[fname])
			call denite#custom#option(fname, dopt, a:opts[fname][dopt])
		endfor
	endfor
endfunction

call s:profile(s:denite_options)

" denite command
if !s:sys.isWindows
	if executable('ag')
		" Change file_rec command.
		call denite#custom#var('file_rec', 'command',
					\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
	elseif executable('rg')
		" For ripgrep
		" Note: It is slower than ag
		call denite#custom#var('file_rec', 'command',
					\ ['rg', '--files', '--glob', '!.git', ''])
	endif
else
	if executable('pt')
		" For Pt(the platinum searcher)
		" NOTE: It also supports windows.
		call denite#custom#var('file_rec', 'command',
					\ ['pt', '--follow', '--nocolor', '--nogroup', '-g:', ''])
	endif
endif


" FIND and GREP COMMANDS
if executable('ag')
	call denite#custom#var('grep', 'command', ['ag'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', [])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
	call denite#custom#var('grep', 'default_opts',
				\ [ '--vimgrep', '--smart-case' ])
elseif executable('ack')
	" Ack command
	call denite#custom#var('grep', 'command', ['ack'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--match'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
	call denite#custom#var('grep', 'default_opts',
				\ ['--ackrc', $HOME.'/.config/ackrc', '-H',
				\ '--nopager', '--nocolor', '--nogroup', '--column'])
endif

" KEY MAPPINGS
let s:insert_mode_mappings = [
			\  ['jk', '<denite:enter_mode:normal>', 'noremap'],
			\ ['<Tab>', '<denite:move_to_next_line>', 'noremap'],
			\ ['<S-tab>', '<denite:move_to_previous_line>', 'noremap'],
			\  ['<Esc>', '<denite:enter_mode:normal>', 'noremap'],
			\  ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
			\  ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
			\  ['<Up>', '<denite:assign_previous_text>', 'noremap'],
			\  ['<Down>', '<denite:assign_next_text>', 'noremap'],
			\  ['<C-Y>', '<denite:redraw>', 'noremap'],
			\ ]

let s:normal_mode_mappings = [
			\   ["'", '<denite:toggle_select_down>', 'noremap'],
			\   ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
			\   ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
			\   ['gg', '<denite:move_to_first_line>', 'noremap'],
			\   ['st', '<denite:do_action:tabopen>', 'noremap'],
			\   ['sg', '<denite:do_action:vsplit>', 'noremap'],
			\   ['sv', '<denite:do_action:split>', 'noremap'],
			\   ['q', '<denite:quit>', 'noremap'],
			\   ['r', '<denite:redraw>', 'noremap'],
			\ ]

for s:m in s:insert_mode_mappings
	call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
endfor
for s:m in s:normal_mode_mappings
	call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
endfor

unlet s:m s:insert_mode_mappings s:normal_mode_mappings

" vim: set ts=2 sw=2 tw=80 noet :

