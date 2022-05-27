
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1
let s:cpo_save = &cpo

setlocal comments=s:--[[,mb:-,ex:]],:--,f:#,:--
setlocal commentstring=--%s
setlocal suffixesadd=.tl

let b:undo_ftplugin = "setl com< cms< mp< sua<"

let &cpo = s:cpo_save
unlet s:cpo_save
