
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Haxedoc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("haxe_haxedoc") || (exists("main_syntax") && main_syntax == 'jsp')
  syntax case ignore
  " syntax coloring for haxedoc comments (HTML)
  " syntax include @haxeHtml <sfile>:p:h/html.vim
  " unlet b:current_syntax
  syn region  haxeDocComment    start="/\*\*"  end="\*/" keepend contains=haxeCommentTitle,@haxeHtml,haxeDocTags,haxeTodo,@Spell
  syn region  haxeCommentTitle  contained matchgroup=haxeDocComment start="/\*\*"   matchgroup=haxeCommentTitle keepend end="\.$" end="\.[ \t\r<&]"me=e-1 end="[^{]@"me=s-2,he=s-1 end="\*/"me=s-1,he=s-1 contains=@haxeHtml,haxeCommentStar,haxeTodo,@Spell,haxeDocTags

  syn region haxeDocTags  contained start="{@\(link\|linkplain\|inherit[Dd]oc\|doc[rR]oot\|value\)" end="}"
  syn match  haxeDocTags  contained "@\(see\|param\|exception\|throws\|since\)\s\+\S\+" contains=haxeDocParam
  syn match  haxeDocParam contained "\s\S\+"
  syn match  haxeDocTags  contained "@\(version\|author\|return\|deprecated\|serial\|serialField\|serialData\)\>"
  syntax case match
  HaxeHiLink haxeDocComment		Comment
  HaxeHiLink haxeDocTags		Special
  HaxeHiLink haxeDocParam		Function
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Haxe comment strings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("haxe_comment_strings")
  syn region  haxeCommentString    contained start=+"+ end=+"+ end=+$+ end=+\*/+me=s-1,he=s-1 contains=haxeSpecial,haxeCommentStar,haxeSpecialChar,@Spell
  syn region  haxeComment2String   contained start=+"+  end=+$\|"+  contains=haxeSpecial,haxeSpecialChar,@Spell
  syn match   haxeCommentCharacter contained "'\\[^']\{1,6\}'" contains=haxeSpecialChar
  syn match   haxeCommentCharacter contained "'\\''" contains=haxeSpecialChar
  syn match   haxeCommentCharacter contained "'[^\\]'"
  syn cluster haxeCommentSpecial add=haxeCommentString,haxeCommentCharacter,haxeNumber
  syn cluster haxeCommentSpecial2 add=haxeComment2String,haxeCommentCharacter,haxeNumber
  HaxeHiLink haxeCommentString haxeString
  HaxeHiLink haxeComment2String haxeString
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Haxe concealed text 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('g:haxe_conceal') && has("conceal")
  syn match Ignore 'urn' transparent conceal containedin=haxeStatement
  syn match Ignore 'ction' transparent conceal containedin=haxeStorageClass,haxeStatement
  syn match Ignore 'ati' transparent conceal containedin=haxeStorageClass
  syn match Ignore 'nline\|tati\|ubli' transparent conceal containedin=haxeScopeDecl
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Haxe space errors 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("haxe_space_errors")
  if !exists("haxe_no_trail_space_error")
    syn match   haxeSpaceError  "\s\+$"
  endif
  if !exists("haxe_no_tab_space_error")
    syn match   haxeSpaceError  " \+\t"me=e-1
  endif
  HaxeHiLink haxeSpaceError		Error
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Haxe minline comments 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists("haxe_minlines")
  let haxe_minlines = 10
  exec "syn sync ccomment haxeComment minlines=" . haxe_minlines
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mark braces in parens as errors 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("haxe_mark_braces_in_parens_as_errors")
  syn match haxeInParen		 contained "[{}]"
  HaxeHiLink haxeInParen	haxeError
  syn cluster haxeTop add=haxeInParen
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight Functions 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("haxe_highlight_functions")
  if haxe_highlight_functions == "indent"
    syn match  haxeFuncDef "^\(\t\| \{8\}\)[_$a-zA-Z][_$a-zA-Z0-9_. \[\]]*([^-+*/()]*)" contains=haxeScopeDecl,haxeType,haxeStorageClass,@haxeClasses
    syn region haxeFuncDef start=+^\(\t\| \{8\}\)[$_a-zA-Z][$_a-zA-Z0-9_. \[\]]*([^-+*/()]*,\s*+ end=+)+ contains=haxeScopeDecl,haxeType,haxeStorageClass,@haxeClasses
    syn match  haxeFuncDef "^  [$_a-zA-Z][$_a-zA-Z0-9_. \[\]]*([^-+*/()]*)" contains=haxeScopeDecl,haxeType,haxeStorageClass,@haxeClasses
    syn region haxeFuncDef start=+^  [$_a-zA-Z][$_a-zA-Z0-9_. \[\]]*([^-+*/()]*,\s*+ end=+)+ contains=haxeScopeDecl,haxeType,haxeStorageClass,@haxeClasses
  else
    " This line catches method declarations at any indentation>0, but it assumes
    " two things:
    "   1. class names are always capitalized (ie: Button)
    "   2. method names are never capitalized (except constructors, of course)
    syn region haxeFuncDef start=+^\s\+\(\(public\|protected\|private\|static\|abstract\|override\|final\|native\|synchronized\)\s\+\)*\(\(void\|boolean\|char\|byte\|short\|int\|long\|float\|double\|\([A-Za-z_][A-Za-z0-9_$]*\.\)*[A-Z][A-Za-z0-9_$]*\)\(\[\]\)*\s\+[a-z][A-Za-z0-9_$]*\|[A-Z][A-Za-z0-9_$]*\)\s*(+ end=+)+ contains=haxeScopeDecl,haxeType,haxeStorageClass,haxeComment,haxeLineComment,@haxeClasses
  endif
  syn match  haxeBraces  "[{}]"
  syn cluster haxeTop add=haxeFuncDef,haxeBraces
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add special handling for haxecc.vim 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" use separate name so that it can be deleted in haxecc.vim
syn match   haxeError2 "#\|=<"
HaxeHiLink haxeError2 haxeError


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Catch extra paren errors 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" catch errors caused by wrong parenthesis
syn region  haxeParenT  transparent matchgroup=haxeParen  start="("  end=")" contains=@haxeTop,haxeParenT1,haxeString,haxeSingleString
syn region  haxeParenT1 transparent matchgroup=haxeParen1 start="(" end=")" contains=@haxeTop,haxeParenT2 contained
syn region  haxeParenT2 transparent matchgroup=haxeParen2 start="(" end=")" contains=@haxeTop,haxeParenT  contained
syn match   haxeParenError       ")"
HaxeHiLink haxeParenError       haxeError


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load a spearte haxeid.vim file 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand("<sfile>:p:h")."/haxeid.vim")
  source <sfile>:p:h/haxeid.vim
endif
