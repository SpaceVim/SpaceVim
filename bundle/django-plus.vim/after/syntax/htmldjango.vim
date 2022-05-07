let s:old = b:current_syntax
unlet b:current_syntax
syntax include @HTML $VIMRUNTIME/syntax/html.vim
syntax region djangoVerbatimBlock start="{%\s*verbatim\s*%}" end="{%\s*endverbatim\s*%}" transparent contains=@HTML containedin=ALL
syntax match djangoVerbatimTagBlock #{%\s*\%(end\)\?verbatim\s*%}# containedin=djangoVerbatimBlock
syntax cluster djangoBlocks add=djangoVerbatimBlock,djangoVerbatimTagBlock

" Highlight tag and variable blocks inside of scripts, styles, and attributes
syntax region djangoNestedTagBlock start="{%" end="%}" contained contains=djangoStatement,djangoFilter,djangoArgument,djangoTagError display containedin=htmlString,javaScript,javaScriptStringD,javaScriptStringN,jsStringS,jsStringD,cssStyle,cssDefinition
syntax region djangoNestedVarBlock start="{{" end="}}" contained contains=djangoFilter,djangoArgument,djangoVarError display containedin=htmlString,javaScript,javaScriptStringD,javaScriptStringN,jsStringS,jsStringD,cssStyle,cssDefinition
syntax cluster djangoBlocks add=djangoNestedTagBlock,djangoNestedVarBlock

highlight default link djangoNestedVarBlock djangoVarBlock
highlight default link djangoNestedTagBlock djangoTagBlock
highlight default link djangoVerbatimTagBlock djangoTagBlock
