" PlantUML Live Preview for ascii/unicode art
" @Author: Martin Grenfell <martin.grenfell@gmail.com>
" @Date: 2018-12-07 13:00:22
" @Last Modified by: Tsuyoshi CHO <Tsuyoshi.CHO@Gmail.com>
" @Last Modified time: 2018-12-08 00:02:43
" @License: WTFPL
" PlantUML Filetype preview kick

" Intro  {{{1
if exists("b:loaded_slumlord")
    finish
endif
let b:loaded_slumlord=1

let s:save_cpo = &cpo
set cpo&vim

" setting {{{1
setlocal nowrap

" autocmd {{{1
augroup slumlord
    autocmd!
    autocmd BufWritePre * if &ft =~ 'plantuml' | silent call slumlord#updatePreview({'write': 1}) | endif
augroup END

" Outro {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set fdm=marker:
