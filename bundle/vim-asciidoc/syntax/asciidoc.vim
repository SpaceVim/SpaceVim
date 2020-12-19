" Vim syntax file
" Language:     AsciiDoc
" Author:       Stuart Rackham <srackham@gmail.com> (inspired by Felix
"               Obenhuber's original asciidoc.vim script).
" URL:          http://www.methods.co.nz/asciidoc/
"               https://github.com/dahu/vim-asciidoc
" Licence:      GPL (http://www.gnu.org)
" Remarks:      Vim 6 or greater
" Limitations:  See 'Appendix E: Vim Syntax Highlighter' in the AsciiDoc 'User
"               Guide'.

if exists("b:current_syntax")
  finish
endif

syn clear
syn sync fromstart
syn sync linebreaks=1

function! AsciidocEnableSyntaxRanges()
" source block syntax highlighting
if exists('g:loaded_SyntaxRange')
  for lang in ['c', 'python', 'vim']
    call SyntaxRange#Include(
          \  '^\c\[source\s*,\s*' . lang . '.*\]\s*$'
          \, '\(\]\s*\n\)\@<![=-]\{4,\}'
          \, lang)
  endfor
endif
endfunction

" Run :help syn-priority to review syntax matching priority.
syn keyword asciidocToDo TODO FIXME CHECK TEST XXX ZZZ DEPRECATED
syn match asciidocBackslash /\\/
syn region asciidocIdMarker start=/^\$Id:\s/ end=/\s\$$/
syn match asciidocCallout /\\\@<!<\d\{1,2}>/
syn match asciidocListBlockDelimiter /^--$/
syn match asciidocLineBreak /[ \t]+$/
syn match asciidocRuler /^'\{3,}$/
syn match asciidocPagebreak /^<\{3,}$/
syn match asciidocEntityRef /\\\@<!&[#a-zA-Z]\S\{-};/
syn region asciidocLiteralParagraph start=/\(\%^\|\_^\n\)\@<=\s\+\S\+/ end=/\(^\(+\|--\)\?\s*$\)\@=/ contains=asciidocToDo
syn match asciidocURL /\\\@<!\<\(http\|https\|ftp\|file\|irc\):\/\/[^| \t]*\(\w\|\/\)/
syn match asciidocEmail /[\\.:]\@<!\(\<\|<\)\w\(\w\|[.-]\)*@\(\w\|[.-]\)*\w>\?[0-9A-Za-z_]\@!/
syn match asciidocAttributeRef /\\\@<!{\w\(\w\|[-,+]\)*\([=!@#$%?:].*\)\?}/

" As a damage control measure quoted patterns always terminate at a blank
" line (see 'Limitations' above).
syn match asciidocQuotedAttributeList /\\\@<!\[[a-zA-Z0-9_-][a-zA-Z0-9 _-]*\][+_'`#*]\@=/
syn match asciidocQuotedSubscript /\\\@<!\~\S\_.\{-}\(\~\|\n\s*\n\)/ contains=asciidocEntityRef
syn match asciidocQuotedSuperscript /\\\@<!\^\S\_.\{-}\(\^\|\n\s*\n\)/ contains=asciidocEntityRef

syn match asciidocQuotedMonospaced /\(^\|[| \t([.,=\]]\)\@<=+\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(+\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef
syn match asciidocQuotedMonospaced2 /\(^\|[| \t([.,=\]]\)\@<=`\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(`\([| \t)[\],.?!;:=]\|$\)\@=\)/
syn match asciidocQuotedUnconstrainedMonospaced /[\\+]\@<!++\S\_.\{-}\(++\|\n\s*\n\)/ contains=asciidocEntityRef

syn match asciidocQuotedEmphasized /\(^\|[| \t([.,=\]]\)\@<=_\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(_\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef
syn match asciidocQuotedEmphasized2 /\(^\|[| \t([.,=\]]\)\@<='\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\('\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef
syn match asciidocQuotedUnconstrainedEmphasized /\\\@<!__\S\_.\{-}\(__\|\n\s*\n\)/ contains=asciidocEntityRef

syn match asciidocQuotedBold /\(^\|[| \t([.,=\]]\)\@<=\*\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(\*\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef
syn match asciidocQuotedUnconstrainedBold /\\\@<!\*\*\S\_.\{-}\(\*\*\|\n\s*\n\)/ contains=asciidocEntityRef

" Don't allow ` in single quoted (a kludge to stop confusion with `monospaced`).
syn match asciidocQuotedSingleQuoted /\(^\|[| \t([.,=\]]\)\@<=`\([ )\n\t]\)\@!\([^`]\|\n\(\s*\n\)\@!\)\{-}[^` \t]\('\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef

syn match asciidocQuotedDoubleQuoted /\(^\|[| \t([.,=\]]\)\@<=``\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(''\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef

syn match asciidocDoubleDollarPassthrough /\\\@<!\(^\|[^0-9a-zA-Z$]\)\@<=\$\$..\{-}\(\$\$\([^0-9a-zA-Z$]\|$\)\@=\|^$\)/
syn match asciidocTriplePlusPassthrough /\\\@<!\(^\|[^0-9a-zA-Z$]\)\@<=+++..\{-}\(+++\([^0-9a-zA-Z$]\|$\)\@=\|^$\)/

syn match asciidocAdmonition /^\u\{3,15}:\(\s\+.*\)\@=/

syn region asciidocTable_OLD start=/^\([`.']\d*[-~_]*\)\+[-~_]\+\d*$/ end=/^$/
syn match asciidocBlockTitle /^\.[^. \t].*[^-~_]$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocTitleUnderline /[-=~^+]\{2,}$/ transparent contained contains=NONE
syn match asciidocOneLineTitle /^=\{1,5}\s\+\S.*$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash
syn match asciidocTwoLineTitle /^[^. +/].*[^.]\n[-=~^+]\{2,}$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocTitleUnderline

syn match asciidocAttributeList /^\[[^[ \t].*\]$/
syn match asciidocQuoteBlockDelimiter /^_\{4,}$/
syn match asciidocExampleBlockDelimiter /^=\{4,}$/
syn match asciidocSidebarDelimiter /^*\{4,}$/

" See http://vimdoc.sourceforge.net/htmldoc/usr_44.html for excluding region
" contents from highlighting.
syn match asciidocTablePrefix /\(\S\@<!\(\([0-9.]\+\)\([*+]\)\)\?\([<\^>.]\{,3}\)\?\([a-z]\)\?\)\?|/ containedin=asciidocTableBlock contained
syn region asciidocTableBlock matchgroup=asciidocTableDelimiter start=/^|=\{3,}$/ end=/^|=\{3,}$/ keepend contains=ALL
syn match asciidocTablePrefix /\(\S\@<!\(\([0-9.]\+\)\([*+]\)\)\?\([<\^>.]\{,3}\)\?\([a-z]\)\?\)\?!/ containedin=asciidocTableBlock contained
syn region asciidocTableBlock2 matchgroup=asciidocTableDelimiter2 start=/^!=\{3,}$/ end=/^!=\{3,}$/ keepend contains=ALL

syn match asciidocListContinuation /^+$/
syn region asciidocExampleBlock start=/^=\{4,}$/ end=/^=\{4,}$/ contains=asciidocCallout,asciidocToDo keepend
syn region asciidocLiteralBlock start=/^\.\{4,}$/ end=/^\.\{4,}$/ contains=asciidocCallout,asciidocToDo keepend
syn region asciidocListingBlock start=/^-\{4,}$/ end=/^-\{4,}$/ contains=asciidocCallout,asciidocToDo keepend
syn region asciidocCommentBlock start="^/\{4,}$" end="^/\{4,}$" contains=asciidocToDo
syn region asciidocPassthroughBlock start="^+\{4,}$" end="^+\{4,}$"


" Allowing leading \w characters in the filter delimiter is to accomodate
" the pre version 8.2.7 syntax and may be removed in future releases.
syn region asciidocFilterBlock start=/^\w*\~\{4,}$/ end=/^\w*\~\{4,}$/

syn region asciidocMacroAttributes matchgroup=asciidocRefMacro start=/\\\@<!<<"\{-}\(\w\|-\|_\|:\|\.\)\+"\?,\?/ end=/\(>>\)\|^$/ contains=asciidocQuoted.* keepend
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start=/\\\@<!\[\{2}\(\w\|-\|_\|:\|\.\)\+,\?/ end=/\]\{2}/ keepend
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start=/\\\@<!\[\{3}\(\w\|-\|_\|:\|\.\)\+/ end=/\]\{3}/ keepend
syn region asciidocMacroAttributes matchgroup=asciidocMacro start=/[\\0-9a-zA-Z]\@<!\w\(\w\|-\)*:\S\{-}\[/ skip=/\\\]/ end=/\]\|^$/ contains=asciidocQuoted.*,asciidocAttributeRef,asciidocEntityRef keepend
" Highlight macro that starts with an attribute reference (a common idiom).
syn region asciidocMacroAttributes matchgroup=asciidocMacro start=/\(\\\@<!{\w\(\w\|[-,+]\)*\([=!@#$%?:].*\)\?}\)\@<=\S\{-}\[/ skip=/\\\]/ end=/\]\|^$/ contains=asciidocQuoted.*,asciidocAttributeRef keepend
syn region asciidocMacroAttributes matchgroup=asciidocIndexTerm start=/\\\@<!(\{2,3}/ end=/)\{2,3}/ contains=asciidocQuoted.*,asciidocAttributeRef keepend

syn match asciidocCommentLine "^//\([^/].*\|\)$" contains=asciidocToDo

syn region asciidocAttributeEntry start=/^:\w/ end=/:\(\s\|$\)/ oneline

" Lists.
syn match asciidocListBullet /^\s*\zs\(-\|\*\{1,5}\)\ze\s/
syn match asciidocListNumber /^\s*\zs\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\ze\s\+/
syn region asciidocListLabel start=/^\s*/ end=/\(:\{2,4}\|;;\)$/ oneline contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocToDo keepend
" DEPRECATED: Horizontal label.
syn region asciidocHLabel start=/^\s*/ end=/\(::\|;;\)\(\s\+\|\\$\)/ oneline contains=asciidocQuoted.*,asciidocMacroAttributes keepend
" Starts with any of the above.
syn region asciidocList start=/^\s*\(-\|\*\{1,5}\)\s/ start=/^\s*\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\s\+/ start=/.\+\(:\{2,4}\|;;\)$/ end=/\(^[=*]\{4,}$\)\@=/ end=/\(^+\?\s*$\)\@=/ contains=asciidocList.\+,asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocCommentLine,asciidocAttributeList,asciidocToDo

highlight link asciidocAdmonition Special
highlight link asciidocAnchorMacro Macro
highlight link asciidocAttributeEntry Special
highlight link asciidocAttributeList Special
highlight link asciidocAttributeMacro Macro
highlight link asciidocAttributeRef Special
highlight link asciidocBackslash Special
highlight link asciidocBlockTitle Title
highlight link asciidocCallout Label
highlight link asciidocCommentBlock Comment
highlight link asciidocCommentLine Comment
highlight link asciidocDoubleDollarPassthrough Special
highlight link asciidocEmail Macro
highlight link asciidocEntityRef Special
highlight link asciidocExampleBlockDelimiter Type
highlight link asciidocFilterBlock Type
highlight link asciidocHLabel Label
highlight link asciidocIdMarker Special
highlight link asciidocIndexTerm Macro
highlight link asciidocLineBreak Special
highlight link asciidocListBlockDelimiter Label
highlight link asciidocListBullet Label
highlight link asciidocListContinuation Label
highlight link asciidocListingBlock Identifier
highlight link asciidocListLabel Label
highlight link asciidocListNumber Label
highlight link asciidocLiteralBlock Identifier
highlight link asciidocLiteralParagraph Identifier
highlight link asciidocMacroAttributes Label
highlight link asciidocMacro Macro
highlight link asciidocOneLineTitle Title
highlight link asciidocPagebreak Type
highlight link asciidocPassthroughBlock Identifier
highlight link asciidocQuoteBlockDelimiter Type
highlight link asciidocQuotedAttributeList Special
highlight link asciidocQuotedBold Special
highlight link asciidocQuotedDoubleQuoted Label
highlight link asciidocQuotedEmphasized2 Type
highlight link asciidocQuotedEmphasized Type
highlight link asciidocQuotedMonospaced2 Identifier
highlight link asciidocQuotedMonospaced Identifier
highlight link asciidocQuotedSingleQuoted Label
highlight link asciidocQuotedSubscript Type
highlight link asciidocQuotedSuperscript Type
highlight link asciidocQuotedUnconstrainedBold Special
highlight link asciidocQuotedUnconstrainedEmphasized Type
highlight link asciidocQuotedUnconstrainedMonospaced Identifier
highlight link asciidocRefMacro Macro
highlight link asciidocRuler Type
highlight link asciidocSidebarDelimiter Type
highlight link asciidocTableBlock2 NONE
highlight link asciidocTableBlock NONE
highlight link asciidocTableDelimiter2 Label
highlight link asciidocTableDelimiter Label
highlight link asciidocTable_OLD Type
highlight link asciidocTablePrefix2 Label
highlight link asciidocTablePrefix Label
highlight link asciidocToDo Todo
highlight link asciidocTriplePlusPassthrough Special
highlight link asciidocTwoLineTitle Title
highlight link asciidocURL Macro
let b:current_syntax = "asciidoc"

" vim: wrap et sw=2 sts=2:
