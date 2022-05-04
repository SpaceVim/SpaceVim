" syn match vimChatMsg 	/^\[\d\d\(:\d\d\)\{0,2\}].\{-}:/	contains=vimChatTime,vimChatMe
" syn match vimChatTime  	/\[\d\d\(:\d\d\)\{0,2\}]/			contained nextgroup=vimChatMe
" syn match vimChatMe  	/Me:/		 			contained
" Comment, Type, String, Statement
" hi link vimChatMsg		Comment
" hi link vimChatTime		String
" hi link vimChatMe		Type
" syn match vimChatMsg 	/^\[\d\d\(:\d\d\)\{0,2\}][^>]*/	contains=vimChatTime,vimChatNick
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'vimchat'
endif

syntax sync fromstart
syn match VimChatTime /\[\d\d\d\d-\d\d-\d\d\s\d\d\:\d\d]/
syn match VimChatVert /│/
syn match VimChatNick /\[\d\d\d\d-\d\d-\d\d\s\d\d\:\d\d]\s│[^│]*│/ contains=VimChatTime,VimChatVert

syntax match VimChatCodeBlock /`[^`]*`/
syntax match VimChatRemoteNickL /\*\*`/ conceal
syntax match VimChatRemoteNickR /`\*\*/ conceal
syntax match VimChatRemoteNick /**`[^`]*`\*\*/ contains=VimChatRemoteNickR,VimChatRemoteNickL
syntax match VimChatPing /\s\zs@\S*/
syntax match VimChatQuoteMsg /.*│\s>\s.*/ contains=VimChatTime,VimChatVert,VimChatNick
syn region VimChatCodeBlockLines start=".*│\s*````*.*$" end="│\s*````*\ze\s*$" contains=VimChatTime,VimChatVert,VimChatNick keepend
syntax match VimChatReplayCounts /.*│\s->\s\d*\s\(reply\|replies\)/ contains=VimChatTime,VimChatVert,VimChatNick
" hi def link vimChatMsg	Comment
hi def link VimChatTime Comment
hi def link VimChatQuoteMsg Comment
hi def link VimChatReplayCounts Comment
hi def link VimChatNick Type
hi def link VimChatVert VertSplit
hi def link VimChatRemoteNick Todo
hi def link VimChatPing ModeMsg
hi def link VimChatCodeBlock String
hi def link VimChatCodeBlockLines String

let b:current_syntax = "vimchat"
if main_syntax == 'vimchat'
  unlet main_syntax
endif
