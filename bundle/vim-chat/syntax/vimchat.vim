" syn match vimChatMsg 	/^\[\d\d\(:\d\d\)\{0,2\}].\{-}:/	contains=vimChatTime,vimChatMe
" syn match vimChatTime  	/\[\d\d\(:\d\d\)\{0,2\}]/			contained nextgroup=vimChatMe
" syn match vimChatMe  	/Me:/		 			contained
" Comment, Type, String, Statement
" hi link vimChatMsg		Comment
" hi link vimChatTime		String
" hi link vimChatMe		Type
" syn match vimChatMsg 	/^\[\d\d\(:\d\d\)\{0,2\}][^>]*/	contains=vimChatTime,vimChatNick
syn match VimChatTime /\[\d\d\d\d-\d\d-\d\d\s\d\d\:\d\d]/
syn match VimChatVert /│/
syn match VimChatNick /\[\d\d\d\d-\d\d-\d\d\s\d\d\:\d\d]\s│[^│]*│/ contains=VimChatTime,VimChatVert

syntax match VimChatCodeBlock /`[^`]*`/
syntax match VimChatRemoteNickL /\*\*`/ conceal
syntax match VimChatRemoteNickR /`\*\*/ conceal
syntax match VimChatRemoteNick /**`[^`]*`\*\*/ contains=VimChatRemoteNickR,VimChatRemoteNickL
syntax match VimChatPing /\s\zs@\S*/
" hi def link vimChatMsg	Comment
hi def link VimChatTime Comment
hi def link VimChatNick Type
hi def link VimChatVert VertSplit
hi def link VimChatRemoteNick Todo
hi def link VimChatPing ModeMsg
hi def link VimChatCodeBlock String
