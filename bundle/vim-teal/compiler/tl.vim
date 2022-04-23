
if exists("current_compiler")
	finish
endif
let current_compiler = "tl"

let s:cpo_save = &cpo
set cpo&vim

if exists("g:teal_check_only")
	CompilerSet makeprg=tl\ -q\ check\ %
elseif exists("g:teal_check_before_gen")
	CompilerSet makeprg=tl\ -q\ check\ %\ &&\ tl\ -q\ gen\ %
else
	CompilerSet makeprg=tl\ -q\ gen\ %
endif
CompilerSet errorformat=%f:%l:%c:\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
