" Vim syntax plugin for filetype name.
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" 		Israel Chauca F. <israelchauca@gmail.com>
" Version:	0.1
" Description:	Long description.
" Last Change:	2013-02-01
" License:	Vim License (see :help license)
" Location:	syntax/vrs.vim
" Website:	https://github.com/Raimondi/vrs
"
" See vrs.txt for help. This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help vrs

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

syn match       vrsNameErr    /^\S\+\s\+/ contained
syn match       vrsName       /^\w\+\s\+/ contained
syn match       vrsFlavorErr  /\%(^\S\+\s\+\)\@<=\S\+\s\+/ contained
syn match       vrsFlavor     /\%(^\S\+\s\+\)\@<=\w\+\s\+/ contained
syn match       vrsCompItem   /\w\+\|\d\+\|,\@<=\%(\\}\|[^}]\)\+/ contained
syn match       vrsCompose    /\\%{\S\+,\d\+,\%(\\}\|[^}]\)*}/ contained contains=vrsCompItem
syn match       vrsRegExp     /\%(^\S\+\s\+\S\+\s\+\)\@<=.*/ contains=vrsCompose contained
syn match       vrsCommand    /^\S\+\s\+\S\+\s\+\S.*/ contains=vrsName,vrsFlavor,vrsNameErr,vrsFlavorErr,vrsRegExp,vrsComment
syn match       vrsContinued  /^\s\+\S.*/ contains=vrsComment
syn match       vrsComment    /\%(\%(\\\\\)*\\\)\@<!#.*$/ containedin=ALL contains=vrsTODO
syn keyword	vrsTodo	TODO FIXME XXX
syn match       vrsError      /^[^a-zA-Z0-9_# ].*/

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link vrsTodo	 Todo
hi def link vrsComment   Comment
hi def link vrsName      Identifier
hi def link vrsFlavor    Type
hi def link vrsRegExp    String
hi def link vrsContinued String
hi def link vrsCompose   PreProc
hi def link vrsCompItem  Normal
hi def link vrsError     Error
hi def link vrsFlavorErr Error
hi def link vrsNameErr   Error

let b:current_syntax = 'vrs'

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
