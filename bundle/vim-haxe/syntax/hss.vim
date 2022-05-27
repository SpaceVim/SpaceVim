" Vim syntax file
" Language: hss (Haxe css)
" Author: Justin Donaldson (jdonaldson@gmail.com) 
" Based heavily on work by Daniel Hofstetter (daniel.hofstetter@42dh.com)

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'hss'
endif

runtime! syntax/css.vim
runtime! syntax/css/*.vim

syn case ignore

syn region hssDefinition transparent matchgroup=cssBraces start='{' end='}' contains=css.*Attr,css.*Prop,cssComment,cssValue.*,cssColor,cssUrl,cssImportant,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape,hssDefinition,hssComment,hssIdChar,hssClassChar,hssAmpersand,hssVariable,hssInclude,hssExtend,hssDebug,hssWarn,@hssControl,hssInterpolation,hssNestedSelector,hssReturn

syn region hssInterpolation start="#{" end="}" contains=hssVariable

syn match hssVariable "$[[:alnum:]_-]\+" nextgroup=hssVariableAssignment
syn match hssVariableAssignment ":" contained nextgroup=hssVariableValue
syn match hssVariableValue ".*;"me=e-1 contained contains=hssVariable,hssOperator,hssDefault "me=e-1 means that the last char of the pattern is not highlighted
" syn match hssMixin "^@mixin" nextgroup=hssMixinName
syn match hssMixinName " [[:alnum:]_-]\+" contained nextgroup=hssDefinition
syn match hssFunction "^@function" nextgroup=hssFunctionName
syn match hssFunctionName " [[:alnum:]_-]\+" contained nextgroup=hssDefinition
" syn match hssReturn "@return" contained
" syn match hssInclude "@include" nextgroup=hssMixinName
" syn match hssExtend "@extend .*[;}]"me=e-1 contains=cssTagName,hssIdChar,hssClassChar
syn keyword hssTodo TODO FIXME NOTE OPTIMIZE XXX contained containedIn=hssComment,cssComment

syn match hssColor "#[0-9A-Fa-f]\{3\}\>" contained
syn match hssColor "#[0-9A-Fa-f]\{6\}\>" contained

syn match hssIdChar "#[[:alnum:]_-]\@=" nextgroup=hssId contains=hssColor
syn match hssId "[[:alnum:]_-]\+" contained
syn match hssClassChar "\.[[:alnum:]_-]\@=" nextgroup=hssClass
syn match hssClass "[[:alnum:]_-]\+" contained
syn match hssAmpersand "&" nextgroup=cssPseudoClass

syn match hssOperator "+" contained
syn match hssOperator "-" contained
syn match hssOperator "/" contained
syn match hssOperator "*" contained

syn match hssNestedSelector "[^/]* {"me=e-1 contained contains=cssTagName,cssAttributeSelector,hssIdChar,hssClassChar,hssAmpersand,hssVariable,hssMixin,hssFunction,@hssControl,hssInterpolation,hssNestedProperty
syn match hssNestedProperty "[[:alnum:]]\+:"me=e-1 contained

" syn match hssDebug "@debug"
" syn match hssWarn "@warn"
syn match hssDefault "!default" contained

" syn match hssIf "@if"
" syn match hssElse "@else"
" syn match hssElseIf "@else if"
" syn match hssWhile "@while"
" syn match hssFor "@for" nextgroup=hssVariable
" syn match hssFrom " from "
" syn match hssTo " to "
" syn match hssThrough " through "
" syn match hssEach "@each" nextgroup=hssVariable
" syn match hssIn " in "
" syn cluster hssControl contains=hssIf,hssElse,hssElseIf,hssWhile,hssFor,hssFrom,hssTo,hssThrough,hssEach,hssIn

syn match hssComment "//.*$" contains=@Spell
syn region hssImportStr start="\"" end="\""
syn region hssImport start="@import" end=";" contains=hssImportStr,hssComment,cssComment,cssUnicodeEscape,cssMediaType

hi def link hssVariable  Identifier
hi def link hssVariableValue Constant
hi def link hssMixin     PreProc
hi def link hssMixinName Function
hi def link hssFunction  PreProc
hi def link hssFunctionName Function
hi def link hssReturn    Statement
hi def link hssInclude   PreProc
hi def link hssExtend    PreProc
hi def link hssComment   Comment
hi def link hssColor     Constant
hi def link hssIdChar    Special
hi def link hssClassChar Special
hi def link hssId        Identifier
hi def link hssClass     Identifier
hi def link hssAmpersand Character
hi def link hssNestedProperty Type
hi def link hssDebug     Debug
hi def link hssWarn      Debug
hi def link hssDefault   Special
hi def link hssIf        Conditional
hi def link hssElse      Conditional
hi def link hssElseIf    Conditional
hi def link hssWhile     Repeat
hi def link hssFor       Repeat
hi def link hssFrom      Repeat
hi def link hssTo        Repeat
hi def link hssThrough   Repeat
hi def link hssEach      Repeat
hi def link hssIn        Repeat
hi def link hssInterpolation Delimiter
hi def link hssImport    Include
hi def link hssImportStr Include
hi def link hssTodo      Todo

let b:current_syntax = "hss"
if main_syntax == 'hss'
  unlet main_syntax
endif
