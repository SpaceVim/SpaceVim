
function s:LoadPlugins()
	if exists("g:loaded_matchit")
		let b:match_ignorecase = 0
		let b:match_words=
			\ '\<\%(do\|enum\|record\|function\|if\)\>:' .
			\ '\<\%(return\|else\|elseif\)\>:' .
			\ '\<end\>,' .
			\ '\<repeat\>:\<until\>'
	endif
	if exists("g:loaded_endwise")
		let b:endwise_addition = 'end'
		let b:endwise_words = 'function,do,then,enum,record'
		let b:endwise_pattern = '\zs\<\%(then\|do\)\|\(\%(function\|record\|enum\).*\)\ze\s*$'
		let b:endwise_syngroups = 'tealFunction,tealDoEnd,tealIfStatement,tealRecord,tealEnum'
	endif

	if exists("g:colors_name") && g:colors_name == "dracula"
		hi! link tealTable           DraculaFg
		hi! link tealFunctionArgName DraculaOrangeItalic
		hi! link tealSelf            DraculaPurpleItalic
		hi! link tealBuiltin         DraculaCyan
		hi! link tealGeneric         DraculaOrangeItalic
	endif
endfunction

autocmd FileType teal call s:LoadPlugins()
