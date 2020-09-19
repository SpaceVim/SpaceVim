" Vim filetype detect plugin for filetype name.
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" 		Israel Chauca F. <israelchauca@gmail.com>
" Version:	0.1
" Description:	Long description.
" Last Change:	2013-02-03
" License:	Vim License (see :help license)
" Location:	ftdetect/vrs.vim
" Website:	https://github.com/Raimondi/vrs
"
" See vrs.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help vrs

au BufRead,BufNewFile */patterns/*.vrs	set filetype=vrs
