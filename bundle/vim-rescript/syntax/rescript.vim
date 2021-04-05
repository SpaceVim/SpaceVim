if exists('b:current_syntax')
  finish
endif

" See https://github.com/rescript-lang/vim-rescript/issues/14
syntax sync minlines=600

" Boolean
syntax keyword resBoolean true false

" Keywords
syntax keyword resKeyword let rec type external mutable lazy private of with
syntax keyword resKeyword if else switch when
syntax keyword resKeyword and as open include module in constraint import export
syntax keyword resKeyword for to downto while
syntax keyword resKeyword try catch exception assert

" Types
syntax keyword resType bool int float char string unit
syntax keyword resType list array option ref exn format

" Operators
syntax keyword resOperator mod land lor lxor lsl lsr asr
syntax keyword resOperator or

syntax match resOperator "\v\="

syntax match resOperator "\v\*"
syntax match resOperator "\v/"
syntax match resOperator "\v\+"
syntax match resOperator "\v-"

syntax match resOperator "\v\*\."
syntax match resOperator "\v/\."
syntax match resOperator "\v\+\."
syntax match resOperator "\v-\."

syntax match resOperator "\v\<"
syntax match resOperator "\v\<\="
syntax match resOperator "\v\>"
syntax match resOperator "\v\>\="

syntax match resOperator "\v\@"

syntax match resOperator "\v\!"
syntax match resOperator "\v\|"
syntax match resOperator "\v\&"

" Refs
syntax match resOperator "\v\:\="

" Arrows / Pipes
syntax match resArrowPipe "\v\=\>"
syntax match resArrowPipe "\v\-\>"
syntax match resArrowPipe "\v\|\>"
syntax match resArrowPipe "\v\@\@"

" Comment
syntax region resSingleLineComment start="//" end="$" contains=resTodo,@Spell
syntax region resMultiLineComment start="/\*\s*" end="\*/" contains=@Spell,resTodo,resMultiLineComment

syntax keyword resTodo contained TODO FIXME XXX NOTE

" Char
syntax match resChar "\v'\\.'|'.'"

syntax match resNumber "-\=\<\d\(_\|\d\)*[l|L|n]\?\>"
syntax match resNumber "-\=\<0[x|X]\(\x\|_\)\+[l|L|n]\?\>"
syntax match resNumber "-\=\<0[o|O]\(\o\|_\)\+[l|L|n]\?\>"
syntax match resNumber "-\=\<0[b|B]\([01]\|_\)\+[l|L|n]\?\>"
syntax match resFloat "-\=\<\d\(_\|\d\)*\.\?\(_\|\d\)*\([eE][-+]\=\d\(_\|\d\)*\)\=\>"

" Module / Constructor
syntax match resModuleOrVariant "\v<[A-Z][A-Za-z0-9_'$]*"
syntax match resPolyVariant "\v#[A-za-z][A-Za-z0-9_'$]*"
syntax match resModuleChain "\v<[A-Z][A-Za-z0-9_'$]*\."

" Attribute
syntax match resAttribute "\v\@([a-zA-z][A-Za-z0-9_']*)(\.([a-zA-z])[A-Za-z0-9_']*)*"

" String
syntax match resUnicodeChar "\v\\u[A-Fa-f0-9]\{4}" contained
syntax match resEscapedChar "\v\\[\\"'ntbrf]" contained
syntax region resString start="\v\"" end="\v\"" contains=resEscapedQuote,resEscapedChar,resUnicodeChar

syntax match resInterpolationVariable "\v\$[a-z_][A-Za-z0-0_'$]*" contained
syntax region resString start="\v`" end="\v`" contains=resInterpolationVariable
syntax region resString start="\v[a-z]`" end="\v`" contains=resInterpolationVariable


highlight default link resBoolean Boolean
highlight default link resKeyword Keyword
highlight default link resType Type
highlight default link resOperator Operator
highlight default link resArrowPipe Operator
highlight default link resSingleLineComment Comment
highlight default link resMultiLineComment Comment
highlight default link resTodo TODO
highlight default link resChar Character
highlight default link resNumber Number
highlight default link resFloat Float
highlight default link resModuleOrVariant Function
highlight default link resPolyVariant Function
highlight default link resModuleChain Macro
highlight default link resUnicodeChar Character
highlight default link resEscapedChar Character
highlight default link resString String
highlight default link resInterpolationVariable Macro
highlight default link resAttribute PreProc

let b:current_syntax = 'rescript'
