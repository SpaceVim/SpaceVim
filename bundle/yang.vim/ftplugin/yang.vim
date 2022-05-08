" Only do this when not done yet for this buffer
if exists('b:did_ftplugin')
    finish
endif
let b:did_ftplugin = 1

setlocal commentstring=//%s
setlocal include=^\\s*import
setlocal suffixesadd=.yang

" j is a fairly recent addition - silence warnings if it can't be set.
setlocal formatoptions-=t formatoptions+=croql
silent! setlocal formatoptions+=j

let b:undo_ftplugin = 'setlocal commentstring< formatoptions< include< suffixesadd<'

setlocal iskeyword+=-
let b:undo_ftplugin .= ' iskeyword<'
