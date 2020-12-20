"=============================================================================
" FILE: syntax/exrename.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

if version < 700
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

syntax match uniteExrenameModified '^.*$'

highlight def link uniteExrenameModified Todo
highlight def link uniteExrenameOriginal Normal

let b:current_syntax = 'unite_exrename'

" vim: foldmethod=marker
