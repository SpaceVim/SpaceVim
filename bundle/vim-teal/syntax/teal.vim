

if exists("b:current_syntax")
	finish
endif
if !has("lambda")
	echoerr "vim-teal: Teal syntax requires lambda support, please update your vim installation"
	finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match
syn sync fromstart

syn cluster tealBase contains=
	\ tealComment,tealLongComment,
	\ tealConstant,tealNumber,tealString,tealLongString
syn cluster tealExpression contains=
	\ @tealBase,tealParen,tealBuiltin,tealBracket,tealBrace,
	\ tealOperator,tealFunctionBlock,tealFunctionCall,tealError,
	\ tealTableConstructor,tealRecordBlock,tealEnumBlock,tealSelf,
	\ tealVarargs
syn cluster tealStatement contains=
	\ @tealExpression,tealIfThen,tealThenEnd,tealBlock,tealLoop,
	\ tealRepeatBlock,tealWhileDo,tealForDo,
	\ tealGoto,tealLabel,tealBreak,tealReturn,
	\ tealLocal,tealGlobal

" {{{ ), ], end, etc error
syn match tealError "\()\|}\|\]\)"
syn match tealError "\<\%(end\|else\|elseif\|until\|in\)\>"
syn match tealInvalid /\S\+/ contained
" }}}
" {{{ Table Constructor
syn region tealTableConstructor
	\ matchgroup=tealTable
	\ start=/{/ end=/}/
	\ contains=@tealExpression,tealTableEntryTypeAnnotation
syn match tealTableEntryTypeAnnotation /:.\{-}\ze=/ contained
	\ contains=@tealSingleType
" }}}
" {{{ Types

" Programmatically generate type definitions for single types and type lists
syn match tealUnion /|/ contained nextgroup=@tealType skipwhite skipempty skipnl
syn match tealSingleUnion /|/ contained nextgroup=@tealSingleType skipwhite skipempty skipnl

syn match tealTypeComma /,/ contained nextgroup=@tealType skipwhite skipempty skipnl
syn match tealSingleTypeAnnotation /:/ contained nextgroup=@tealSingleType skipwhite skipempty skipnl
syn match tealTypeAnnotation /:/ contained nextgroup=@tealType skipwhite skipempty skipnl
syn match tealGeneric /\K\k*/ contained

" {{{ Patterns
let s:typePatterns = {
	\ 'tealFunctionType': {
	\	'synType': 'match',
	\	'patt': '\<function\>',
	\	'nextgroup': ['tealFunctionGenericType', 'tealFunctionArgsType'],
	\ },
	\ 'tealBasicType': {
	\	'synType': 'match',
	\	'patt': '\K\k*\(\.\K\k*\)*',
	\	'nextgroup': ['tealGenericType'],
	\ },
	\ 'tealFunctionGenericType': {
	\	'synType': 'region',
	\	'start': '<',
	\	'end': '>',
	\	'matchgroup': 'tealParens',
	\	'nextgroup': ['tealFunctionArgsType'],
	\	'contains': ['tealGeneric'],
	\ },
	\ 'tealGenericType': {
	\	'synType': 'region',
	\	'start': '<',
	\	'end': '>',
	\	'matchgroup': 'tealParens',
	\	'contains': ['tealGeneric'],
	\ },
	\ 'tealFunctionArgsType': {
	\	'synType': 'region',
	\	'start': '(',
	\	'end': ')',
	\	'matchgroup': 'tealParens',
	\	'contains': ['@tealType'],
	\	'nextgroup': ['tealTypeAnnotation'],
	\	'dontsub': 1,
	\ },
	\ 'tealTableType': {
	\	'synType': 'region',
	\	'start': '{',
	\	'end': '}',
	\	'matchgroup': 'tealTable',
	\	'contains': ['@tealType'],
	\ },
\ }
" }}}

" Add nextgroup=tealUnion,tealTypeComma and
" make a second syntax item with nextgroup=tealSingleUnion
" the effect of this is that we have @tealType, which is a type list
" and @tealSingleType for function arguments
" {{{ ToSingleName
function s:ToSingleName(str)
	return substitute(a:str, 'Type', 'SingleType', '')
endfunction
" }}}
" {{{ MakeSyntaxItem
function s:MakeSyntaxItem(typeName, props)
	if exists("a:props.contains")
		let a:props.contains += ['tealLongComment']
	endif
	for single in [v:true, v:false]
		let tname = a:typeName
		if single
			let tname = s:ToSingleName(tname)
		endif
		let cmd = 'syntax '
		let cmd .= a:props.synType
		let cmd .= ' '
		let cmd .= tname
		let cmd .= ' '
		if a:props.synType == 'region'
			if exists("a:props.matchgroup")
				let cmd .= 'matchgroup=' . a:props.matchgroup
			endif
			let cmd .= ' start=+' . a:props.start . '+ end=+' . a:props.end
		else
			let cmd .= '+' . a:props.patt
		endif
		let cmd .= '+ '
		let cmd .= 'contained '
		if exists("a:props.contains")
			let cmd .= 'contains=' . join(a:props.contains, ",") . ' '
		endif
		let cmd .= 'nextgroup='
		if exists("a:props.nextgroup")
			let nextgroup = copy(a:props.nextgroup)
		else
			let nextgroup = []
		endif
		call map(nextgroup, {-> (single && v:val =~# "Type" && !exists("a:props.dontsub")) ? s:ToSingleName(v:val) : v:val})
		if single
			let nextgroup += ['tealSingleUnion']
		else
			let nextgroup += ['tealUnion', 'tealTypeComma']
		endif
		let cmd .= join(nextgroup, ',')
		let cmd .= ' skipwhite skipempty skipnl'
		exec cmd
		exec "syn cluster teal" . (single ? "Single" : "") . "Type add=" . tname
	endfor
	exec "highlight link " . s:ToSingleName(tname) . " " . tname
endfunction
" }}}
call map(s:typePatterns, {tname, props -> s:MakeSyntaxItem(tname, props)})

syn cluster tealNewType contains=tealRecordBlock,tealEnumBlock
" }}}
" {{{ Function call
syn match tealFunctionCall /\K\k*\ze\s*\n*\s*\(["'({]\|\[=*\[\)/
" }}}
" {{{ Operators
" Symbols
syn match tealOperator "[#<>=~^&|*/%+-]\|\.\."
" Words
syn keyword tealOperator and or not
syn keyword tealOperator is as
	\ nextgroup=@tealSingleType
	\ skipempty skipnl skipwhite
syn match tealVarargs /\.\.\./
" }}}
" {{{ Comments
syn match tealComment "\%^#!.*$"
syn match tealComment /--.*$/ contains=tealTodo,@Spell
syn keyword tealTodo contained TODO todo FIXME fixme TBD tbd XXX
syn region tealLongComment start=/--\[\z(=*\)\[/ end=/\]\z1\]/
" }}}
" {{{ local ... <const>, global ... <const>, local type ..., break, return, self
syn keyword tealTypeDeclaration type contained
	\ nextgroup=tealTypeDeclarationName
	\ skipwhite skipempty skipnl
syn match tealTypeDeclarationName /\K\k*/ contained
	\ nextgroup=tealTypeDeclarationEq,tealInvalid
	\ skipwhite skipempty skipnl
syn match tealTypeDeclarationEq /=/ contained
	\ nextgroup=@tealSingleType,tealRecordBlock,tealEnumBlock
	\ skipwhite skipempty skipnl
syn region tealAttributeBrackets contained transparent
	\ matchgroup=tealParens
	\ start=/</ end=/>/
	\ contains=tealAttribute
	\ nextgroup=tealVarComma,tealTypeAnnotation
	\ skipwhite skipempty skipnl
syn match tealAttribute contained /\K\k*/
syn match tealVarName contained /\K\k*/
	\ nextgroup=tealAttributeBrackets,tealVarComma,tealTypeAnnotation
	\ skipwhite skipempty skipnl
syn match tealVarComma /,/ contained
	\ nextgroup=tealVarName
	\ skipwhite skipempty skipnl
syn keyword tealLocal local
	\ nextgroup=tealFunctionBlock,tealRecordBlock,tealEnumBlock,tealVarName,tealTypeDeclaration
	\ skipwhite skipempty skipnl
syn keyword tealGlobal global
	\ nextgroup=tealFunctionBlock,tealRecordBlock,tealEnumBlock,tealVarName,tealTypeDeclaration
	\ skipwhite skipempty skipnl
syn keyword tealBreak break
syn keyword tealReturn return
syn keyword tealSelf self
" }}}
" {{{ Parens
syn region tealParen transparent
	\ matchgroup=tealParens
	\ start=/(/ end=/)/
	\ contains=@tealExpression
syn region tealBracket transparent
	\ matchgroup=tealBrackets
	\ start=/\[/ end=/\]/
	\ contains=@tealExpression
" }}}
" {{{ function ... end
syn region tealFunctionBlock transparent
	\ matchgroup=tealFunction
	\ start=/\<function\>/ end=/\<end\>/
	\ contains=@tealStatement,tealFunctionStart
syn match tealFunctionStart /\(\<function\>\)\@8<=\s*/ contained
	\ nextgroup=tealFunctionName,tealFunctionGeneric,tealFunctionArgs
	\ skipwhite skipempty skipnl
syn match tealFunctionName /\K\k*\(\.\K\k*\)*\(:\K\k*\)\?/ contained
	\ nextgroup=tealFunctionGeneric,tealFunctionArgs,tealInvalid
	\ skipwhite skipempty skipnl
syn region tealFunctionGeneric contained transparent
	\ start=/</ end=/>/
	\ contains=tealGeneric
	\ nextgroup=tealFunctionArgs
	\ skipwhite skipempty skipnl
syn region tealFunctionArgs contained transparent
	\ matchgroup=tealParens
	\ start=/(/ end=/)/
	\ contains=tealFunctionArgName,tealFunctionArgComma,tealSingleTypeAnnotation
	\ nextgroup=tealTypeAnnotation
	\ skipwhite skipempty skipnl
syn match tealFunctionArgName contained /\K\k*/
	\ nextgroup=tealSingleTypeAnnotation,tealFunctionArgComma,tealInvalid
	\ skipwhite skipempty skipnl
syn match tealFunctionArgComma contained /,/
	\ nextgroup=tealFunctionArgName
	\ skipwhite skipempty skipnl
" }}}
" {{{ record ... end
syn match tealRecordType /\K\k*/ contained
	\ nextgroup=tealRecordAssign,tealInvalid
	\ skipwhite skipnl skipempty
syn match tealRecordEntry /\K\k*/ contained
	\ nextgroup=tealSingleTypeAnnotation,tealInvalid
	\ skipwhite skipnl skipempty
syn match tealRecordEntry /\[.*\]/ contained
	\ nextgroup=tealSingleTypeAnnotation,tealInvalid
	\ contains=tealString,tealLongString
	\ skipwhite skipnl skipempty
	\ transparent
syn cluster tealRecordItem contains=tealRecordEntry
syn region tealRecordBlock contained
	\ matchgroup=tealRecord transparent
	\ start=/\<record\>/ end=/\<end\>/
	\ contains=tealRecordKeywordName,tealRecordStart,@tealRecordItem,tealTableType,tealComment,tealLongComment
syn cluster tealRecordItem add=tealRecordBlock,tealEnumBlock
syn match tealRecordStart /\(\<record\>\)\@6<=\s*/ contained
	\ nextgroup=tealRecordName,tealRecordGeneric
	\ skipwhite skipnl skipempty
syn match tealRecordName /\K\k*/ contained
	\ nextgroup=tealRecordGeneric
	\ skipwhite skipnl skipempty
syn region tealRecordGeneric contained transparent
	\ matchgroup=tealParens
	\ start=/</ end=/>/
	\ contains=tealGeneric
syn keyword tealRecordUserdata userdata contained
	\ nextgroup=@tealRecordItem
	\ skipwhite skipnl skipempty
syn match tealRecordTypeDeclaration /type\s*\K\k*\s*=/ contained
	\ contains=tealRecordTypeKeyword,tealOperator
	\ nextgroup=@tealSingleType,@tealNewType,tealInvalid
	\ skipwhite skipnl skipempty
syn keyword tealRecordMetamethodKeyword metamethod contained
syn match tealRecordMetamethod /metamethod\s\+\K\k*/ contained
	\ contains=tealRecordMetamethodKeyword
	\ nextgroup=tealSingleTypeAnnotation
	\ skipwhite skipnl skipempty

syn keyword tealRecordTypeKeyword type contained
syn cluster tealRecordItem
	\ add=tealRecordTypeDeclaration,tealRecordUserdata,tealRecordMetamethod
" }}}
" {{{ enum ... end
syn match tealEnumStart /\(\<enum\>\)\@4<=\s*/ contained
	\ nextgroup=tealEnumName
	\ skipwhite skipnl skipempty
syn match tealEnumName /\K\k*/ contained
syn region tealEnumBlock
	\ matchgroup=tealEnum transparent
	\ start="\<enum\>" end="\<end\>"
	\ contains=tealEnumStart,tealString,tealLongString,tealComment,tealLongComment,tealInvalid
" }}}
" {{{ record entries with names 'enum' and 'record'
syn match tealRecordKeywordName /\(enum\|record\)\s*\ze:/ contained
	\ contains=tealRecordItem
	\ nextgroup=tealSingleTypeAnnotation,tealInvalid
	\ skipwhite skipnl skipempty
" }}}
" {{{ if ... then, elseif ... then, then ... end, else
syn keyword tealError then
syn region tealIfThen
	\ transparent matchgroup=tealIfStatement
	\ start=/\<if\>/ end=/\<then\>/me=e-4
	\ contains=@tealExpression
	\ nextgroup=tealThenEnd
	\ skipwhite skipnl skipempty
syn region tealElseifThen contained
	\ transparent matchgroup=tealIfStatement
	\ start=/\<elseif\>/ end=/\<then\>/
	\ contains=@tealExpression
syn region tealThenEnd
	\ transparent matchgroup=tealIfStatement
	\ start=/\<then\>/ end=/\<end\>/
	\ contains=tealElseifThen,tealElse,@tealStatement
syn keyword tealElse else contained containedin=tealThenEnd
" }}}
" {{{ for ... do ... end, in
syn region tealForDo
	\ matchgroup=tealFor transparent
	\ contains=tealIn,@tealExpression
	\ start=/\<for\>/ end=/\<do\>/me=e-2
syn keyword tealIn in contained
" }}}
" {{{ while ... do ... end
syn region tealWhileDo
	\ matchgroup=tealWhile transparent
	\ contains=@tealExpression
	\ start=/\<while\>/ end=/\<do\>/me=e-2
" }}}
" {{{ do ... end
syn region tealBlock
	\ matchgroup=tealDoEnd transparent
	\ contains=@tealStatement
	\ start=/\<do\>/ end=/\<end\>/
" }}}
" {{{ repeat ... until
syn region tealRepeatBlock
	\ matchgroup=tealRepeatUntil transparent
	\ contains=@tealStatement
	\ start=/\<repeat\>/ end=/\<until\>/
" }}}
" {{{ Goto
syn keyword tealGoto goto
syn match tealLabel /::\K\k*::/
" }}}
" {{{ true, false, nil, etc...
syn keyword tealConstant nil true false
" }}}
" {{{ Strings
syn match tealSpecial contained #\\[\\abfnrtvz'"]\|\\x[[:xdigit:]]\{2}\|\\[[:digit:]]\{,3}#
syn region tealLongString matchgroup=tealString start="\[\z(=*\)\[" end="\]\z1\]" contains=@Spell
syn region tealString  start=+'+ end=+'\|$+ skip=+\\\\\|\\'+ contains=tealSpecial,@Spell
syn region tealString  start=+"+ end=+"\|$+ skip=+\\\\\|\\"+ contains=tealSpecial,@Spell
" }}}
" {{{ Numbers
" integer number
syn match tealNumber "\<\d\+\>"
" floating point number, with dot, optional exponent
syn match tealNumber  "\<\d\+\.\d*\%([eE][-+]\=\d\+\)\=\>"
" floating point number, starting with a dot, optional exponent
syn match tealNumber  "\.\d\+\%([eE][-+]\=\d\+\)\=\>"
" floating point number, without dot, with exponent
syn match tealNumber  "\<\d\+[eE][-+]\=\d\+\>"
" hex numbers
syn match tealNumber "\<0[xX][[:xdigit:].]\+\%([pP][-+]\=\d\+\)\=\>"
" }}}
" {{{ Built ins

syn keyword tealBuiltIn assert error collectgarbage
	\ print tonumber tostring type
	\ getmetatable setmetatable
	\ ipairs pairs next
	\ pcall xpcall
	\ _G _ENV _VERSION require
	\ rawequal rawget rawset rawlen
	\ loadfile load dofile select
syn match tealBuiltIn /\<package\.cpath\>/
syn match tealBuiltIn /\<package\.loaded\>/
syn match tealBuiltIn /\<package\.loadlib\>/
syn match tealBuiltIn /\<package\.path\>/
syn match tealBuiltIn /\<coroutine\.running\>/
syn match tealBuiltIn /\<coroutine\.create\>/
syn match tealBuiltIn /\<coroutine\.resume\>/
syn match tealBuiltIn /\<coroutine\.status\>/
syn match tealBuiltIn /\<coroutine\.wrap\>/
syn match tealBuiltIn /\<coroutine\.yield\>/
syn match tealBuiltIn /\<string\.byte\>/
syn match tealBuiltIn /\<string\.char\>/
syn match tealBuiltIn /\<string\.dump\>/
syn match tealBuiltIn /\<string\.find\>/
syn match tealBuiltIn /\<string\.format\>/
syn match tealBuiltIn /\<string\.gsub\>/
syn match tealBuiltIn /\<string\.len\>/
syn match tealBuiltIn /\<string\.lower\>/
syn match tealBuiltIn /\<string\.rep\>/
syn match tealBuiltIn /\<string\.sub\>/
syn match tealBuiltIn /\<string\.upper\>/
syn match tealBuiltIn /\<string\.gmatch\>/
syn match tealBuiltIn /\<string\.match\>/
syn match tealBuiltIn /\<string\.reverse\>/
syn match tealBuiltIn /\<table\.pack\>/
syn match tealBuiltIn /\<table\.unpack\>/
syn match tealBuiltIn /\<table\.concat\>/
syn match tealBuiltIn /\<table\.sort\>/
syn match tealBuiltIn /\<table\.insert\>/
syn match tealBuiltIn /\<table\.remove\>/
syn match tealBuiltIn /\<math\.abs\>/
syn match tealBuiltIn /\<math\.acos\>/
syn match tealBuiltIn /\<math\.asin\>/
syn match tealBuiltIn /\<math\.atan\>/
syn match tealBuiltIn /\<math\.atan2\>/
syn match tealBuiltIn /\<math\.ceil\>/
syn match tealBuiltIn /\<math\.sin\>/
syn match tealBuiltIn /\<math\.cos\>/
syn match tealBuiltIn /\<math\.tan\>/
syn match tealBuiltIn /\<math\.deg\>/
syn match tealBuiltIn /\<math\.exp\>/
syn match tealBuiltIn /\<math\.floor\>/
syn match tealBuiltIn /\<math\.log\>/
syn match tealBuiltIn /\<math\.max\>/
syn match tealBuiltIn /\<math\.min\>/
syn match tealBuiltIn /\<math\.huge\>/
syn match tealBuiltIn /\<math\.fmod\>/
syn match tealBuiltIn /\<math\.modf\>/
syn match tealBuiltIn /\<math\.ult\>/
syn match tealBuiltIn /\<math\.tointeger\>/
syn match tealBuiltIn /\<math\.maxinteger\>/
syn match tealBuiltIn /\<math\.mininteger\>/
syn match tealBuiltIn /\<math\.pow\>/
syn match tealBuiltIn /\<math\.rad\>/
syn match tealBuiltIn /\<math\.sqrt\>/
syn match tealBuiltIn /\<math\.random\>/
syn match tealBuiltIn /\<math\.randomseed\>/
syn match tealBuiltIn /\<math\.pi\>/
syn match tealBuiltIn /\<io\.close\>/
syn match tealBuiltIn /\<io\.flush\>/
syn match tealBuiltIn /\<io\.input\>/
syn match tealBuiltIn /\<io\.lines\>/
syn match tealBuiltIn /\<io\.open\>/
syn match tealBuiltIn /\<io\.output\>/
syn match tealBuiltIn /\<io\.popen\>/
syn match tealBuiltIn /\<io\.read\>/
syn match tealBuiltIn /\<io\.stderr\>/
syn match tealBuiltIn /\<io\.stdin\>/
syn match tealBuiltIn /\<io\.stdout\>/
syn match tealBuiltIn /\<io\.tmpfile\>/
syn match tealBuiltIn /\<io\.type\>/
syn match tealBuiltIn /\<io\.write\>/
syn match tealBuiltIn /\<os\.clock\>/
syn match tealBuiltIn /\<os\.date\>/
syn match tealBuiltIn /\<os\.difftime\>/
syn match tealBuiltIn /\<os\.execute\>/
syn match tealBuiltIn /\<os\.exit\>/
syn match tealBuiltIn /\<os\.getenv\>/
syn match tealBuiltIn /\<os\.remove\>/
syn match tealBuiltIn /\<os\.rename\>/
syn match tealBuiltIn /\<os\.setlocale\>/
syn match tealBuiltIn /\<os\.time\>/
syn match tealBuiltIn /\<os\.tmpname\>/
syn match tealBuiltIn /\<debug\.debug\>/
syn match tealBuiltIn /\<debug\.gethook\>/
syn match tealBuiltIn /\<debug\.getinfo\>/
syn match tealBuiltIn /\<debug\.getlocal\>/
syn match tealBuiltIn /\<debug\.getupvalue\>/
syn match tealBuiltIn /\<debug\.setlocal\>/
syn match tealBuiltIn /\<debug\.setupvalue\>/
syn match tealBuiltIn /\<debug\.sethook\>/
syn match tealBuiltIn /\<debug\.traceback\>/
syn match tealBuiltIn /\<debug\.getmetatable\>/
syn match tealBuiltIn /\<debug\.setmetatable\>/
syn match tealBuiltIn /\<debug\.getregistry\>/
syn match tealBuiltIn /\<debug\.getuservalue\>/
syn match tealBuiltIn /\<debug\.setuservalue\>/
syn match tealBuiltIn /\<debug\.upvalueid\>/
syn match tealBuiltIn /\<debug\.upvaluejoin\>/
syn match tealBuiltIn /\<utf8\.char\>/
syn match tealBuiltIn /\<utf8\.charpattern\>/
syn match tealBuiltIn /\<utf8\.codepoint\>/
syn match tealBuiltIn /\<utf8\.codes\>/
syn match tealBuiltIn /\<utf8\.len\>/
syn match tealBuiltIn /\<utf8\.offset\>/

" }}}
" {{{ Highlight
hi def link tealTypeDeclaration       StorageClass
hi def link tealKeyword               Keyword
hi def link tealFunction              Keyword
hi def link tealFunctionName          Function
hi def link tealFunctionArgName       Identifier
hi def link tealLocal                 Keyword
hi def link tealGlobal                Keyword
hi def link tealBreak                 Keyword
hi def link tealReturn                Keyword
hi def link tealIn                    Keyword
hi def link tealSelf                  Special
hi def link tealTable                 Structure
hi def link tealBasicType             Type
hi def link tealFunctionType          Type
hi def link tealAttribute             StorageClass
hi def link tealParens                Normal
hi def link tealRecord                Keyword
hi def link tealEnum                  Keyword
hi def link tealIfStatement           Conditional
hi def link tealElse                  Conditional
hi def link tealFor                   Repeat
hi def link tealWhile                 Repeat
hi def link tealDoEnd                 Keyword
hi def link tealRepeatUntil           Repeat
hi def link tealFunctionCall          Function
hi def link tealGoto                  Keyword
hi def link tealLabel                 Label
hi def link tealString                String
hi def link tealLongString            String
hi def link tealSpecial               Special
hi def link tealComment               Comment
hi def link tealLongComment           Comment
hi def link tealConstant              Constant
hi def link tealNumber                Number
hi def link tealOperator              Operator
hi def link tealBuiltin               Identifier
hi def link tealError                 Error
hi def link tealInvalid               Error
hi def link tealGeneric               Type
hi def link tealTodo                  Todo
hi def link tealRecordName            tealBasicType
hi def link tealRecordType            tealBasicType
hi def link tealRecordTypeKeyword     tealKeyword
hi def link tealRecordAssign          tealOperator
hi def link tealEnumName              tealBasicType
hi def link tealTypeDeclarationEq     tealOperator
hi def link tealTypeDeclarationName   tealBasicType
hi def link tealRecordUserdata        Keyword
hi def link tealRecordMetamethodKeyword Keyword
" }}}

let b:current_syntax = "teal"

let &cpo = s:cpo_save
unlet s:cpo_save
