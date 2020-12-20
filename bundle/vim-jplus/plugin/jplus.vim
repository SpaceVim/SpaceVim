scriptencoding utf-8
if exists('g:loaded_jplus')
  finish
endif
let g:loaded_jplus = 1

let s:save_cpo = &cpo
set cpo&vim


function! s:config(base)
	return jplus#get_config(&filetype, a:base)
endfunction


function! s:input_config(input, base)
	return jplus#get_input_config(a:input, &filetype, a:base)
endfunction


noremap <silent> <Plug>(jplus-getchar)
\	:call jplus#join(<SID>input_config(jplus#getchar(), {}))<CR>

noremap <silent> <Plug>(jplus-getchar-with-space)
\	:call jplus#join(<SID>input_config(jplus#getchar(), { "delimiter_format" : " %d " }))<CR>

noremap <silent> <Plug>(jplus-input)
\	:call jplus#join(<SID>input_config(input("Input joint delimiter : "), {}))<CR>

noremap <silent> <Plug>(jplus-input-with-space)
\	:call jplus#join(<SID>input_config(input("Input joint delimiter :"), { "delimiter_format" : " %d " }))<CR>


noremap <silent> <Plug>(jplus)
\	:call jplus#join(<SID>config({}))<CR>

nnoremap <silent> <Plug>(operator-jplus)
\		:set operatorfunc=jplus#operatorfunc<CR>g@

nnoremap <silent> <Plug>(operator-jplus-getchar)
\		:set operatorfunc=jplus#operatorfunc_getchar<CR>g@

nnoremap <silent> <Plug>(operator-jplus-input)
\		:set operatorfunc=jplus#operatorfunc_input<CR>g@


let &cpo = s:save_cpo
unlet s:save_cpo
