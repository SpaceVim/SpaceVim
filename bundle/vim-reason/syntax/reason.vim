" Vim syntax file
" Language:     Reason (Forked from Rust)
" Maintainer:   (Jordan - for Reason changes) Patrick Walton <pcwalton@mozilla.com>
" Maintainer:   Ben Blum <bblum@cs.cmu.edu>
" Maintainer:   Chris Morgan <me@chrismorgan.info>
" Last Change:  January 29, 2015
" Portions Copyright (c) 2015-present, Facebook, Inc. All rights reserved.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Syntax definitions {{{1
" Basic keywords {{{2
syn keyword   reasonConditional try switch if else for while
syn keyword   reasonOperator    as to downto

" syn keyword   reasonKeyword     fun nextgroup=reasonFuncName skipwhite skipempty
syn match     reasonAssert      "\<assert\(\w\)*"
syn match     reasonFailwith    "\<failwith\(\w\)*"

syn keyword   reasonStorage     when where fun mutable class pub pri val inherit let external rec nonrec and module type exception open include constraint
" FIXME: Scoped impl's name is also fallen in this category

syn match     reasonIdentifier  contains=reasonIdentifierPrime "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained
syn match     reasonFuncName    "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained
"
" syn match labelArgument "\(\l\|_\)\(\w\|'\)*::\(?\)\?"lc=0   "Allows any space between label name and ::
" syn match labelArgumentPunned "::\(?\)\?\(\l\|_\)\(\w\|'\)*"lc=0   "Allows any space between label name and ::
syn match labelArgument "\~\(\l\|_\)\(\w\|'\)*"lc=0   "Allows any space between label name and ::
syn match labelArgumentPunned "\~\(\l\|_\)\(\w\|'\)*\(?\)\?"lc=0   "Allows any space between label name and ::

syn match    reasonConstructor  "\<\u\(\w\|'\)*\>"
" Polymorphic variants
syn match    reasonConstructor  "`\w\(\w\|'\)*\>"

syn match    reasonModPath  "\<\u\(\w\|'\)* *\."he=e-1
syn match    reasonModPath  "\(\<open\s\+\)\@<=\u\(\w\|\.\)*"
syn match    reasonModPath  "\(\<include\s\+\)\@<=\u\(\w\|\.\)*"
syn match    reasonModPath  "\(\<module\s\+\)\@<=\u\(\w\|\.\)*"
syn match    reasonModPath  "\(\<module\s\+\u\w*\s*=\s*\)\@<=\u\(\w\|\.\)*"


" {} are handled by reasonFoldBraces


" Built-in types {{{2
syn keyword   reasonType        result int float option list array unit ref bool string

" Things from the libstd v1 prelude (src/libstd/prelude/v1.rs) {{{2
" This section is just straight transformation of the contents of the prelude,
" to make it easy to update.

" Reexported functions {{{3
" There’s no point in highlighting these; when one writes drop( or drop::< it
" gets the same highlighting anyway, and if someone writes `let drop = …;` we
" don’t really want *that* drop to be highlighted.
"syn keyword reasonFunction drop

" Reexported types and traits {{{3
syn keyword reasonEnum Option
syn keyword reasonConstructor Some None
syn keyword reasonEnum Result
syn keyword reasonConstructor Ok Error

" Other syntax {{{2
syn keyword   reasonSelf        self
syn keyword   reasonBoolean     true false

" This is merely a convention; note also the use of [A-Z], restricting it to
" latin identifiers rather than the full Unicode uppercase. I have not used
" [:upper:] as it depends upon 'noignorecase'
"syn match     reasonCapsIdent    display "[A-Z]\w\(\w\)*"

syn match     reasonOperator     display "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)=\?"
" This one isn't *quite* right, as we could have binary-& with a reference

" This isn't actually correct; a closure with no arguments can be `|| { }`.
" Last, because the & in && isn't a sigil
syn match     reasonOperator     display "&&\|||"
" This is reasonArrowCharacter rather than reasonArrow for the sake of matchparen,
" so it skips the ->; see http://stackoverflow.com/a/30309949 for details.
syn match     reasonArrowCharacter display "=>"

syn match     reasonEscapeError   display contained /\\./
syn match     reasonEscape        display contained /\\\([nrt0\\'"]\|x\x\{2}\)/
syn match     reasonEscapeUnicode display contained /\\\(u\x\{4}\|U\x\{8}\)/
syn match     reasonEscapeUnicode display contained /\\u{\x\{1,6}}/
syn match     reasonStringContinuation display contained /\\\n\s*/
syn region    reasonString      start=+b"+ skip=+\\\\\|\\"+ end=+"+ contains=reasonEscape,reasonEscapeError,reasonStringContinuation
syn region    reasonString      start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=reasonEscape,reasonEscapeUnicode,reasonEscapeError,reasonStringContinuation,@Spell
syn region    reasonString      start='b\?r\z(#*\)"' end='"\z1' contains=@Spell

syn region    reasonMultilineString      start=+b{|+ skip=+\\\\\|\\"+ end=+|}+ contains=reasonEscape,reasonEscapeError,reasonStringContinuation
syn region    reasonMultilineString      start=+{|+ end=+|}+ contains=reasonEscape,reasonEscapeUnicode,reasonEscapeError,reasonStringContinuation,@Spell


" https://github.com/pangloss/vim-javascript/blob/master/syntax/javascript.vim
" lc=1 means leading context, for "not backslashed"
syntax region  reasonTemplateExpression contained matchgroup=reasonTemplateBraces start=+\(^\|[^\\]\)${+lc=1 end=+}+ contains=@interpolation keepend
syntax region  reasonTemplateString   start=+`\($\| \)+  skip=+\\`+  end=+`+     contains=reasonTemplateExpression,jsSpecial,@Spell extend
syntax match   reasonTaggedTemplate   /\<\K\k*\ze`/ nextgroup=reasonTemplateString


syn region    reasonAttribute   start="#!\?\[" end="\]" contains=reasonString,reasonDerive
" This list comes from src/libsyntax/ext/deriving/mod.rs
" Some are deprecated (Encodable, Decodable) or to be removed after a new snapshot (Show).

" Number literals
syn match     reasonDecNumber   display "\<[0-9][0-9_]*\%([iu]\%(size\|8\|16\|32\|64\)\)\="
syn match     reasonHexNumber   display "\<0x[a-fA-F0-9_]\+\%([iu]\%(size\|8\|16\|32\|64\)\)\="
syn match     reasonOctNumber   display "\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\)\)\="
syn match     reasonBinNumber   display "\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\)\)\="

" Special case for numbers of the form "1." which are float literals, unless followed by
" an identifier, which makes them integer literals with a method call or field access,
" or by another ".", which makes them integer literals followed by the ".." token.
" (This must go first so the others take precedence.)
syn match     reasonFloat       display "\<[0-9][0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\|\.\)\@!"
" To mark a number as a normal float, it must have at least one of the three things integral values don't have:
" a decimal point and more numbers; an exponent; and a type suffix.
syn match     reasonFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\="
syn match     reasonFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\="
syn match     reasonFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)"

" For the benefit of delimitMate

syn match   reasonCharacterInvalid   display contained /b\?'\zs[\n\r\t']\ze'/
" The groups negated here add up to 0-255 but nothing else (they do not seem to go beyond ASCII).
syn match   reasonCharacterInvalidUnicode   display contained /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/
syn match   reasonCharacter   /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/ contains=reasonEscape,reasonEscapeError,reasonCharacterInvalid,reasonCharacterInvalidUnicode
syn match   reasonCharacter   /'\([^\\]\|\\\(.\|x\x\{2}\|u\x\{4}\|U\x\{8}\|u{\x\{1,6}}\)\)'/ contains=reasonEscape,reasonEscapeUnicode,reasonEscapeError,reasonCharacterInvalid

syn match reasonShebang /\%^#![^[].*/
syn region reasonCommentLine                                        start="//"                      end="$"   contains=reasonTodo,@Spell
" syn region reasonCommentLineDoc                                     start="//\%(//\@!\|!\)"         end="$"   contains=reasonTodo,@Spell
syn region reasonCommentBlock    matchgroup=reasonCommentBlock        start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=reasonTodo,reasonCommentBlockNest,@Spell
syn region reasonCommentBlockDoc matchgroup=reasonCommentBlockDoc     start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=reasonTodo,reasonCommentBlockDocNest,@Spell
syn region reasonCommentBlockNest matchgroup=reasonCommentBlock       start="/\*"                     end="\*/" contains=reasonTodo,reasonCommentBlockNest,@Spell contained transparent
syn region reasonCommentBlockDocNest matchgroup=reasonCommentBlockDoc start="/\*"                     end="\*/" contains=reasonTodo,reasonCommentBlockDocNest,@Spell contained transparent
" FIXME: this is a really ugly and not fully correct implementation. Most
" importantly, a case like ``/* */*`` should have the final ``*`` not being in
" a comment, but in practice at present it leaves comments open two levels
" deep. But as long as you stay away from that particular case, I *believe*
" the highlighting is correct. Due to the way Vim's syntax engine works
" (greedy for start matches, unlike Zust's tokeniser which is searching for
" the earliest-starting match, start or end), I believe this cannot be solved.
" Oh you who would fix it, don't bother with things like duplicating the Block
" rules and putting ``\*\@<!`` at the start of them; it makes it worse, as
" then you must deal with cases like ``/*/**/*/``. And don't try making it
" worse with ``\%(/\@<!\*\)\@<!``, either...

syn keyword reasonTodo contained TODO FIXME XXX NB NOTE

" Folding rules {{{2
" Trivial folding rules to begin with.
" FIXME: use the AST to make really good folding
syn region reasonFoldBraces start="{" end="}" transparent fold
" These mess up the highlighting
" reasonIdentifier,reasonIdentifierPrime,
syntax cluster interpolation  contains=reasonTemplateString,reasonCommentLine,reasonCommentBlock,reasonMultilineString,reasonString,reasonSelf,reasonBoolean,reasonType,reasonStorage,reasonAssert,reasonFailwith,reasonOperator,reasonConditional,reasonNumber,reasonCharacter,reasonConstructor,labelArgument,labelArgumentPunned,reasonCapsIdent,reasonFloat,reasonModPath,reasonDecNumber,reasonHexNumber,reasonOctNumber,reasonBinNumber,reasonArrowCharacter


" Default highlighting {{{1
hi def link labelArgument       Special
hi def link labelArgumentPunned Special
hi def link reasonDecNumber       reasonNumber
hi def link reasonHexNumber       reasonNumber
hi def link reasonOctNumber       reasonNumber
hi def link reasonBinNumber       reasonNumber
hi def link reasonIdentifierPrime reasonIdentifier

hi def link reasonEscape        Special
hi def link reasonEscapeUnicode reasonEscape
hi def link reasonEscapeError   Error
hi def link reasonStringContinuation Special
hi def link reasonString          String
hi def link reasonMultilineString String
hi def link reasonTemplateString  String


hi def link reasonCharacterInvalid Error
hi def link reasonCharacterInvalidUnicode reasonCharacterInvalid
hi def link reasonCharacter     Character
hi def link reasonNumber        Number
hi def link reasonBoolean       Boolean
hi def link reasonEnum          reasonType
hi def link reasonConstructor   Constant
hi def link reasonModPath       Include
hi def link reasonConstant      Constant
hi def link reasonSelf          Constant
hi def link reasonFloat         Float
hi def link reasonArrowCharacter reasonOperator
hi def link reasonOperator      Keyword
hi def link reasonKeyword       Keyword
hi def link reasonConditional   Conditional
hi def link reasonIdentifier    Identifier
hi def link reasonCapsIdent     reasonIdentifier
hi def link reasonFunction      Function
hi def link reasonFuncName      Function
hi def link reasonShebang       Comment
hi def link reasonCommentLine   Comment
" hi def link reasonCommentLineDoc Comment
hi def link reasonCommentBlock  Comment
hi def link reasonCommentBlockDoc Comment
hi def link reasonAssert        Precondit
hi def link reasonFailwith      PreCondit
hi def link reasonType          Type
hi def link reasonTodo          Todo
hi def link reasonAttribute     PreProc
hi def link reasonStorage       Keyword
hi def link reasonObsoleteStorage Error

hi def link reasonTemplateBraces Noise
hi def link reasonTaggedTemplate StorageClass


syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "reason"
