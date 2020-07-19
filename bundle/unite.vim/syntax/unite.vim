"=============================================================================
" FILE: syntax/unite.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license
"=============================================================================

if version < 700
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

highlight default link uniteError  Error

highlight default link uniteMarkedLine  Statement
highlight default link uniteCandidateSourceName  Type
highlight default link uniteQuickMatchText  Special
highlight default link uniteCandidateIcon  Special
highlight default link uniteMarkedIcon  Statement
highlight default link uniteCandidateInputKeyword  Function

" The following definitions are for <Plug>(unite-choose-action).
highlight default link uniteChooseAction  NONE
highlight default link uniteChooseCandidate  NONE
highlight default link uniteChooseKey  SpecialKey
highlight default link uniteChooseMessage  NONE
highlight default link uniteChoosePrompt  uniteSourcePrompt
highlight default link uniteChooseSource  uniteSourceNames

highlight default link uniteInputPrompt  Normal
highlight default link uniteInputLine  Identifier
highlight default link uniteInputCommand  Statement

highlight default link uniteStatusNormal  StatusLine
highlight default link uniteStatusHead  Statement
highlight default link uniteStatusSourceNames  PreProc
highlight default link uniteStatusSourceCandidates  Constant
highlight default link uniteStatusMessage  Comment
highlight default link uniteStatusLineNR  LineNR

let b:current_syntax = 'unite'

call unite#view#_set_syntax()

let &cpo = s:save_cpo
unlet s:save_cpo

