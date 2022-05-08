" Vim syntax file
" Language:     YANG
" Remark:       RFC 7950 http://tools.ietf.org/html/rfc7950
" Author:       Matt Parker <mparker@computer.org>
"------------------------------------------------------------------

if v:version < 600
    syntax clear
elseif exists('b:current_syntax')
    finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" Enable block folding
syntax region yangBlock start="{" end="}" fold transparent

" YANG identifiers are made up of alphanumeric characters, underscores,
" hyphens, and dots.
if has('patch-7.4.1142')
    syntax iskeyword a-z,A-Z,48-57,_,-,.
endif

" An identifier looks like [prefix:]identifier
syntax match yangIdentifier /\<\(\h\k*:\)\?\h\k*\>/

" keywords are case-sensitive
syntax case match

" built-in types (section 4.2.4)
syntax keyword yangType binary bits boolean decimal64 empty enumeration identityref
syntax keyword yangType instance-identifier int8 int16 int32 int64 leafref string
syntax keyword yangType uint8 uint16 uint32 uint64 union

" statement keywords
syntax keyword yangStatement augment config deviate deviation fraction-digits input
syntax keyword yangStatement length mandatory max-elements min-elements modifier
syntax keyword yangStatement must namespace ordered-by output pattern position range
syntax keyword yangStatement refine require-instance revision revision-date status
syntax keyword yangStatement unique units value when yang-version yin-element

syntax keyword yangStatement action anydata anyxml argument base nextgroup=yangIdentifier skipwhite
syntax keyword yangStatement belongs-to bit case choice contact nextgroup=yangIdentifier skipwhite
syntax keyword yangStatement container default description enum nextgroup=yangIdentifier skipwhite
syntax keyword yangStatement error-app-tag error-message extension nextgroup=yangIdentifier skipwhite
syntax keyword yangStatement feature grouping identity import include nextgroup=yangIdentifier skipwhite
syntax keyword yangStatement key leaf leaf-list list module nextgroup=yangIdentifier skipwhite
syntax keyword yangStatement notification organization path prefix nextgroup=yangIdentifier skipwhite
syntax keyword yangStatement presence reference rpc submodule typedef nextgroup=yangIdentifier skipwhite
syntax keyword yangStatement uses nextgroup=yangIdentifier skipwhite

syntax keyword yangStatement type nextgroup=yangType,yangIdentifier skipwhite

" other keywords
syntax keyword yangKeyword add current delete deprecated invert-match max min not-supported
syntax keyword yangKeyword obsolete replace system unbounded user

" boolean constants (separated from the 'other keywords' for vim syntax purposes)
syntax keyword yangBoolean true false

" operators (separated from the 'other keywords' for vim syntax purposes)
syntax keyword yangOperator and or not

" if-feature (separated from 'statement keywords' for vim syntax purposes)
syntax keyword yangConditional if-feature

" comments
syntax region yangComment start="/\*" end="\*/" contains=@Spell
syntax region yangComment start="//" end="$" contains=@Spell

" strings
syntax region yangString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell
syntax region yangString start=+'+ end=+'+ contains=@Spell

" dates
syntax match yangDateArg /"\=\<\d\{4}-\d\{2}-\d\{2}\>"\=/

" length-arg TODO: this needs to also include the pipe and individual numbers (i.e. fixed length)
syntax match yangLengthArg /"\(\d\+\|min\)\s*\.\.\s*\(\d\+\|max\)"/

" numbers
syntax match yangNumber /\<[+-]\=\d\+\>/
syntax match yangNumber "\<0x\x\+\>"


"-------------------------------------
" and now for the highlighting

" things with one-to-one mapping
highlight def link yangBoolean Boolean
highlight def link yangComment Comment
highlight def link yangConditional Conditional
highlight def link yangIdentifier Identifier
highlight def link yangKeyword Keyword
highlight def link yangNumber Number
highlight def link yangOperator Operator
highlight def link yangStatement Statement
highlight def link yangString String
highlight def link yangType Type

" arbitrary mappings
highlight def link yangDateArg Special
highlight def link yangLengthArg Special

" synchronize
syntax sync match yangSync grouphere NONE '}$'

let b:current_syntax = 'yang'

let &cpoptions = s:cpo_save
unlet s:cpo_save
