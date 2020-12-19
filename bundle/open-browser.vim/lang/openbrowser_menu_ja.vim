
if exists("did_openbrowser_menu_trans")
  finish
endif
let did_openbrowser_menu_trans = 1
let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

menutrans Open\ URL               カーソル下のURLを開く
menutrans Open\ Word(s)           カーソル下の単語を開く
menutrans Open\ URL\ or\ Word(s)  カーソル下の単語かURLを開く

let &cpo = s:save_cpo
unlet s:save_cpo
