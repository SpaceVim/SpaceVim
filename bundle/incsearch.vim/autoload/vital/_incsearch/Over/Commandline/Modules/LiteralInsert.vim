" ___vital___
" NOTE: lines between '" ___vital___' is generated by :Vitalize.
" Do not mofidify the code nor insert new lines before '" ___vital___'
function! s:_SID() abort
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
endfunction
execute join(['function! vital#_incsearch#Over#Commandline#Modules#LiteralInsert#import() abort', printf("return map({'make': ''}, \"vital#_incsearch#function('<SNR>%s_' . v:key)\")", s:_SID()), 'endfunction'], "\n")
delfunction s:_SID
" ___vital___
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:module = {
\	"name" : "LiteralInsert",
\}

function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("\<C-v>")
\	|| a:cmdline.is_input("\<C-q>")
		let old_line = a:cmdline.getline()
		let old_pos  = a:cmdline.getpos()
		call a:cmdline.insert('^')
		call a:cmdline.setpos(old_pos)
		call a:cmdline.draw()
		let char = a:cmdline.getchar()
		call a:cmdline.setline(old_line)
		call a:cmdline.setpos(old_pos)
		call a:cmdline.setchar(char)
	endif
endfunction

function! s:make()
	return deepcopy(s:module)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
