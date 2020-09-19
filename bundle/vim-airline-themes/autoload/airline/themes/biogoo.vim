" Name:        biogoo (vim-airline version)
" Author:      Benjamin Esham (https://esham.io)
" Last Change: 2017-10-20
"
" You can find more information on the Biogoo theme at <https://github.com/bdesham/biogoo>.

let g:airline#themes#biogoo#palette = {}

function! airline#themes#biogoo#refresh()
	let g:airline#themes#biogoo#palette.accents = {
		\ 'red': airline#themes#get_highlight('String'),
		\ }

	let s:N1 = airline#themes#get_highlight2(['VertSplit', 'bg'], ['Include', 'fg'], 'bold')
	let s:N2 = airline#themes#get_highlight2(['Include', 'fg'], ['Folded', 'bg'], 'bold')
	let s:N3 = airline#themes#get_highlight2(['Include', 'fg'], ['VertSplit', 'bg'], 'bold')
	let g:airline#themes#biogoo#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
	let s:Term = airline#themes#get_highlight2(['StatusLineTerm', 'fg'], ['StatusLineTerm', 'bg'], 'NONE')
	let g:airline#themes#biogoo#palette.normal.airline_term = s:Term

	let s:Nmod = airline#themes#get_highlight2(['MatchParen', 'bg'], ['VertSplit', 'bg'])
	let g:airline#themes#biogoo#palette.normal_modified = {'airline_c': s:Nmod}
	let g:airline#themes#biogoo#palette.normal_modified.airline_term = s:Term

	let s:I1 = airline#themes#get_highlight2(['VertSplit', 'bg'], ['MatchParen', 'bg'], 'bold')
	let s:I2 = s:N2
	let s:I3 = s:N3
	let g:airline#themes#biogoo#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
	let g:airline#themes#biogoo#palette.insert.airline_term = s:Term
	let g:airline#themes#biogoo#palette.insert_modified = g:airline#themes#biogoo#palette.normal_modified
	let g:airline#themes#biogoo#palette.insert_modified.airline_term = s:Term

	let s:R1 = airline#themes#get_highlight2(['VertSplit', 'bg'], ['String', 'fg'], 'bold')
	let s:R2 = s:N2
	let s:R3 = s:N3
	let g:airline#themes#biogoo#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
	let g:airline#themes#biogoo#palette.replace.airline_term = s:Term
	let g:airline#themes#biogoo#palette.replace_modified = g:airline#themes#biogoo#palette.normal_modified
	let g:airline#themes#biogoo#palette.replace_modified.airline_term = s:Term

	let s:V1 = airline#themes#get_highlight2(['VertSplit', 'bg'], ['Number', 'fg'], 'bold')
	let s:V2 = s:N2
	let s:V3 = s:N3
	let g:airline#themes#biogoo#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
	let g:airline#themes#biogoo#palette.visual.airline_term = s:Term
	let g:airline#themes#biogoo#palette.visual_modified = g:airline#themes#biogoo#palette.normal_modified
	let g:airline#themes#biogoo#palette.visual_modified.airline_term = s:Term

	let s:IA1 = airline#themes#get_highlight2(['VertSplit', 'fg'], ['VertSplit', 'bg'])
	let s:IA2 = s:IA1
	let s:IA3 = airline#themes#get_highlight2(['VertSplit', 'fg'], ['VertSplit', 'bg'], 'NONE')
	let g:airline#themes#biogoo#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
	let g:airline#themes#biogoo#palette.inactive.airline_term = s:Term
	let g:airline#themes#biogoo#palette.inactive_modified = g:airline#themes#biogoo#palette.normal_modified
	let g:airline#themes#biogoo#palette.inactive_modified.airline_term = s:Term
endfunction

call airline#themes#biogoo#refresh()
