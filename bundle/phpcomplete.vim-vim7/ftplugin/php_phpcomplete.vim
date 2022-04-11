" Vim completion plugin
" Language:	PHP
" Maintainer:	Szabó Dávid ( complex857 AT gmail DOT com )
"
"	OPTIONS:
"		let g:phpcomplete_enhance_jump_to_definition = 1/0  [default 1]
"			When enabled the <C-]> and <C-W><C-]> (see g:phpcomplete_mappings)
"			will be mapped to phpcomplete#JumpToDefinition() which will try to
"			make a more educated guess of the current symbol's location than simple
"			tag search. If the symbol's location cannot be found the original
"			<C-]> or <C-W><C-]> functionality will be invoked
"
"		let g:phpcomplete_mappings = {..}
"			Defines the mappings for the enhanced jump-to-definition.
"			Keys:
"				jump_to_def: Jumps to the definition in the current buffer
"				jump_to_def_split: Jumps to the definition in a new split buffer
"				jump_to_def_vsplit: Jumps to the definition in a new vertical split buffer
"
"			You change any of them like this in your vimrc:
"				let g:phpcomplete_mappings = {
"					\ 'jump_to_def': ',g',
"					\ }
"
"			The keys you don't specify will be mapped to the defaults:
"				let g:phpcomplete_mappings = {
"				 	\ 'jump_to_def': '<C-]>',
"				 	\ 'jump_to_def_split': '<C-W><C-]>',
"				 	\ 'jump_to_def_vsplit': '<C-W><C-\>',
"					\}
"
"

let s:save_cpo = &cpo
set cpo&vim

let g:phpcomplete_enhance_jump_to_definition = get(g:, 'phpcomplete_enhance_jump_to_definition', 1)
let g:phpcomplete_mappings = extend({
			\ 'jump_to_def': '<C-]>',
			\ 'jump_to_def_split': '<C-W><C-]>',
			\ 'jump_to_def_vsplit': '<C-W><C-\>',
			\ 'jump_to_def_tabnew': '<C-W><C-[>',
			\}, get(g:, 'phpcomplete_mappings', {}))

if g:phpcomplete_enhance_jump_to_definition
	if '' == mapcheck(g:phpcomplete_mappings['jump_to_def'])
		silent! exe "nnoremap <silent> <unique> <buffer> ".g:phpcomplete_mappings['jump_to_def']." :<C-u>call phpcomplete#JumpToDefinition('normal')<CR>"
		silent! exe "vnoremap <silent> <unique> <buffer> ".g:phpcomplete_mappings['jump_to_def']." :<C-u>call phpcomplete#JumpToDefinition('normal')<CR>"
	endif
	if '' == mapcheck(g:phpcomplete_mappings['jump_to_def_split'])
		silent! exe "nnoremap <silent> <unique> <buffer> ".g:phpcomplete_mappings['jump_to_def_split']." :<C-u>call phpcomplete#JumpToDefinition('split')<CR>"
		silent! exe "vnoremap <silent> <unique> <buffer> ".g:phpcomplete_mappings['jump_to_def_split']." :<C-u>call phpcomplete#JumpToDefinition('split')<CR>"
	endif
	if '' == mapcheck(g:phpcomplete_mappings['jump_to_def_vsplit'])
		silent! exe "nnoremap <silent> <unique> <buffer> ".g:phpcomplete_mappings['jump_to_def_vsplit']." :<C-u>call phpcomplete#JumpToDefinition('vsplit')<CR>"
		silent! exe "vnoremap <silent> <unique> <buffer> ".g:phpcomplete_mappings['jump_to_def_vsplit']." :<C-u>call phpcomplete#JumpToDefinition('vsplit')<CR>"
	endif
	if '' == mapcheck(g:phpcomplete_mappings['jump_to_def_tabnew'])
		silent! exe "nnoremap <silent> <unique> <buffer> ".g:phpcomplete_mappings['jump_to_def_tabnew']." :<C-u>call phpcomplete#JumpToDefinition('tabnew')<CR>"
		silent! exe "vnoremap <silent> <unique> <buffer> ".g:phpcomplete_mappings['jump_to_def_tabnew']." :<C-u>call phpcomplete#JumpToDefinition('tabnew')<CR>"
	endif
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker:noexpandtab:ts=4:sts=4:sw=4
