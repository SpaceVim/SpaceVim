"=============================================================================
" FILE: syntaxtax/snippet.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

if version < 700
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax region  neosnippetString
      \ start=+'+ end=+'+ contained
syntax region  neosnippetString
      \ start=+"+ end=+"+ contained
syntax region  neosnippetEval
      \ start=+\\\@<!`+ end=+\\\@<!`+ contained
syntax match   neosnippetWord
      \ '^\s\+.*$' contains=
      \neosnippetEval,neosnippetPlaceHolder,neosnippetEscape,neosnippetVariable
syntax match   neosnippetPlaceHolder
      \ '\%(\\\@<!\|\\\\\zs\)\${\d\+\%(:.\{-}\)\?\\\@<!}'
      \ contained contains=neosnippetPlaceHolderComment
syntax match   neosnippetVariable
      \ '\\\@<!\$\d\+' contained
syntax match   neosnippetComment
      \ '^#.*$'
syntax match   neosnippetEscape
      \ '\\[`]' contained

syntax match   neosnippetKeyword
      \ '^\%(include\|extends\|source\|snippet\|abbr\|prev_word\|delete\|alias\|options\|regexp\|TARGET\)' contained
syntax match   neosnippetPrevWords
      \ '^prev_word\s\+.*$' contains=neosnippetString,neosnippetKeyword
syntax match   neosnippetRegexpr
      \ '^regexp\s\+.*$' contains=neosnippetString,neosnippetKeyword
syntax match   neosnippetStatementName
      \ '^snippet\s.*$' contains=neosnippetName,neosnippetKeyword
syntax match   neosnippetName
      \ '\s\+.*$' contained
syntax match   neosnippetStatementAbbr
      \ '^abbr\s.*$' contains=neosnippetAbbr,neosnippetKeyword
syntax match   neosnippetAbbr
      \ '\s\+.*$' contained
syntax match   neosnippetStatementRank
      \ '^rank\s.*$' contains=neosnippetRank,neosnippetKeyword
syntax match   neosnippetRank
      \ '\s\+\d\+$' contained
syntax match   neosnippetStatementInclude
      \ '^include\s.*$' contains=neosnippetInclude,neosnippetKeyword
syntax match   neosnippetInclude
      \ '\s\+.*$' contained
syntax match   neosnippetStatementSource
      \ '^source\s.*$' contains=neosnippetSource,neosnippetKeyword
syntax match   neosnippetSource
      \ '\s\+.*$' contained
syntax match   neosnippetStatementDelete
      \ '^delete\s.*$' contains=neosnippetDelete,neosnippetKeyword
syntax match   neosnippetDelete
      \ '\s\+.*$' contained
syntax match   neosnippetStatementAlias
      \ '^alias\s.*$' contains=neosnippetAlias,neosnippetKeyword
syntax match   neosnippetAlias
      \ '\s\+.*$' contained
syntax match   neosnippetStatementOptions
      \ '^options\s.*$' contains=neosnippetOption,neosnippetKeyword
syntax keyword   neosnippetOption
      \ head word indent contained
syntax match   neosnippetStatementExtends
      \ '^extends\s.*$' contains=neosnippetExtend,neosnippetKeyword
syntax match   neosnippetExtend
      \ '\s\+.*$' contained
syntax match   neosnippetPlaceHolderComment
      \ '{\d\+:\zs#:.\{-}\ze\\\@<!}' contained

highlight def link neosnippetKeyword Statement
highlight def link neosnippetString String
highlight def link neosnippetName Identifier
highlight def link neosnippetAbbr Normal
highlight def link neosnippetEval Type
highlight def link neosnippetWord String
highlight def link neosnippetPlaceHolder Special
highlight def link neosnippetPlaceHolderComment Comment
highlight def link neosnippetVariable Special
highlight def link neosnippetComment Comment
highlight def link neosnippetInclude PreProc
highlight def link neosnippetSource PreProc
highlight def link neosnippetDelete PreProc
highlight def link neosnippetOption PreProc
highlight def link neosnippetAlias Identifier
highlight def link neosnippetEscape Special

let b:current_syntax = 'snippet'
