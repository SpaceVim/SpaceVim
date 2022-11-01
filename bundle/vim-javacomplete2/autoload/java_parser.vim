" Vim autoload script for a JAVA PARSER and more.
" Language:	Java
" Maintainer:	artur shaik <ashaihullin@gmail.com>
" License:	Vim License	(see vim's :help license)


if exists("g:loaded_javaparser") || version < 700 || &cp
  finish
endif
let g:loaded_javaparser = 'v0.67'


" Constants used by scanner and parser					{{{1
let s:EOI = ''

let s:keywords = {'+': 'PLUS', '-': 'SUB', '!': 'BANG', '%': 'PERCENT', '^': 'CARET', '&': 'AMP', '*': 'STAR', '|': 'BAR', '~': 'TILDE', '/': 'SLASH', '>': 'GT', '<': 'LT', '?': 'QUES', ':': 'COLON', '=': 'EQ', '++': 'PLUSPLUS', '--': 'SUBSUB', '==': 'EQEQ', '<=': 'LTEQ', '>=': 'GTEQ', '!=': 'BANGEQ', '<<': 'LTLT', '>>': 'GTGT', '>>>': 'GTGTGT', '+=': 'PLUSEQ', '-=': 'SUBEQ', '*=': 'STAREQ', '/=': 'SLASHEQ', '&=': 'AMPEQ', '|=': 'BAREQ', '^=': 'CARETEQ', '%=': 'PERCENTEQ', '<<=': 'LTLTEQ', '>>=': 'GTGTEQ', '>>>=': 'GTGTGTEQ', '||': 'BARBAR', '&&': 'AMPAMP', '->': 'RARROW', 'abstract': 'ABSTRACT', 'assert': 'ASSERT', 'boolean': 'BOOLEAN', 'break': 'BREAK', 'byte': 'BYTE', 'case': 'CASE', 'catch': 'CATCH', 'char': 'CHAR', 'class': 'CLASS', 'const': 'CONST', 'continue': 'CONTINUE', 'default': 'DEFAULT', 'do': 'DO', 'double': 'DOUBLE', 'else': 'ELSE', 'extends': 'EXTENDS', 'final': 'FINAL', 'finally': 'FINALLY', 'float': 'FLOAT', 'for': 'FOR', 'goto': 'GOTO', 'if': 'IF', 'implements': 'IMPLEMENTS', 'import': 'IMPORT', 'instanceof': 'INSTANCEOF', 'int': 'INT', 'interface': 'INTERFACE', 'long': 'LONG', 'native': 'NATIVE', 'new': 'NEW', 'package': 'PACKAGE', 'private': 'PRIVATE', 'protected': 'PROTECTED', 'public': 'PUBLIC', 'return': 'RETURN', 'short': 'SHORT', 'static': 'STATIC', 'strictfp': 'STRICTFP', 'super': 'SUPER', 'switch': 'SWITCH', 'synchronized': 'SYNCHRONIZED', 'this': 'THIS', 'throw': 'THROW', 'throws': 'THROWS', 'transient': 'TRANSIENT', 'try': 'TRY', 'void': 'VOID', 'volatile': 'VOLATILE', 'while': 'WHILE', 'true': 'TRUE', 'false': 'FALSE', 'null': 'NULL', '(': 'LPAREN', ')': 'RPAREN', '{': 'LBRACE', '}': 'RBRACE', '[': 'LBRACKET', ']': 'RBRACKET', ';': 'SEMI', ',': 'COMMA', '.': 'DOT', 'enum': 'ENUM', '...': 'ELLIPSIS', '@': 'MONKEYS_AT'}

let s:Flags = {'PUBLIC': 0x1, 'PRIVATE': 0x2, 'PROTECTED': 0x4, 'STATIC': 0x8, 'FINAL': 0x10, 'SYNCHRONIZED': 0x20, 'VOLATILE': 0x40, 'TRANSIENT': 0x80, 'NATIVE': 0x100, 'INTERFACE': 0x200, 'ABSTRACT': 0x400, 'STRICTFP': 0x800, 'SYNTHETIC': 0x1000, 'ANNOTATION': 0x2000, 'ENUM': 	0x4000, 'StandardFlags':0x0fff, 'ACC_SUPER': 0x20, 'ACC_BRIDGE': 0x40, 'ACC_VARARGS': 0x80, 'DEPRECATED': 0x20000, 'HASINIT': 0x40000, 'BLOCK': 0x100000, 'IPROXY': 0x200000, 'NOOUTERTHIS': 0x400000, 'EXISTS': 0x800000, 'COMPOUND': 0x1000000, 'CLASS_SEEN': 0x2000000, 'SOURCE_SEEN': 0x4000000, 'LOCKED': 0x8000000, 'UNATTRIBUTED': 0x10000000, 'ANONCONSTR': 0x20000000, 'ACYCLIC': 0x40000000, 'BRIDGE': 1.repeat('0', 31), 'PARAMETER': 1.repeat('0', 33), 'VARARGS': 1.repeat('0', 34), 'ACYCLIC_ANN': 1.repeat('0', 35), 'GENERATEDCONSTR': 1.repeat('0', 36), 'HYPOTHETICAL': 1.repeat('0', 37), 'PROPRIETARY': 1.repeat('0', 38)}

let s:RE_ANYTHING_AND_NEWLINE	= '\(\(.\|\n\)*\)'
let s:RE_LINE_COMMENT		= '//.*$'
let s:RE_COMMENT_SP		= '/\*\*/'
let s:RE_COMMENT		= ''
let s:RE_BRACKETS		= '\(\s*\[\s*\]\)'

let s:RE_IDENTIFIER		= '[a-zA-Z_$][a-zA-Z0-9_$]*'
let s:RE_QUALID			= s:RE_IDENTIFIER. '\(\s*\.\s*' .s:RE_IDENTIFIER. '\)*'
let s:RE_TYPE_NAME		= s:RE_QUALID
let s:RE_REFERENCE_TYPE		= s:RE_QUALID . s:RE_BRACKETS . '*'		" TypeName	|| Type[]
let s:RE_TYPE			= s:RE_REFERENCE_TYPE		" PrimitiveType || ReferenceType
let s:RE_TYPE_VARIABLE		= s:RE_IDENTIFIER
let s:RE_VAR_DECL_ID		= s:RE_IDENTIFIER . s:RE_BRACKETS . '*'

let s:RE_TYPE_PARAMS		= ''

let s:RE_THROWS			= 'throws\s\+' . s:RE_TYPE_NAME . '\(\s*,\s*' . s:RE_TYPE_NAME . '\)*'
let s:RE_FORMAL_PARAM		= '\%(@'. s:RE_IDENTIFIER. '\s*\)\=\(final\s*\)\='. s:RE_TYPE . '\s\+' . s:RE_VAR_DECL_ID
let s:RE_FORMAL_PARAM_LIST	= s:RE_FORMAL_PARAM . '\(\s*,\s*' . s:RE_FORMAL_PARAM . '\)*'
let s:RE_FORMAL_PARAM2		= '^\s*\%(@'. s:RE_IDENTIFIER. '\s*\)\=\(final\s*\)\=\('. s:RE_TYPE . '\)\s\+\(' . s:RE_IDENTIFIER . '\)' . s:RE_BRACKETS . '*'

let s:RE_METHOD_ARGS	= s:RE_IDENTIFIER . '\(\s*,\s*' . s:RE_IDENTIFIER . '\)*'

let s:RE_MEMBER_MODS		= '\%(PUBLIC\|PROTECTED\|PRIVATE\|ABSTRACT\|STATIC\|FINAL\|TRANSIENT\|VOLATILE\|SYNCHRONIZED\|NATIVE\|STRICTFP\)'
let s:RE_MEMBER_HEADER		= '\s*\(\%(' .s:RE_MEMBER_MODS. '\s\+\)\+\)\(' .s:RE_IDENTIFIER. '\%(\s*\.\s*' .s:RE_IDENTIFIER. '\)*\%(\s*\[\s*\]\)*\)\s\+\(' .s:RE_IDENTIFIER. '\)'

" API								{{{1

let s:PROTOTYPE = {'s:options': {}, 'b:buf': '', 'b:buflen': 0, 'b:lines': [], 'b:idxes': [0], 'b:bp': -1, 'b:ch': '', 'b:line': 0, 'b:col': 0, 'b:pos': 0, 'b:endPos': 0, 'b:prevEndPos': 0, 'b:errPos': -1, 'b:errorEndPos': -1, 'b:sbuf': '', 'b:name': '', 'b:token': '', 'b:docComment': '', 'b:radix': 0, 'b:unicodeConversionBp': -1, 'b:scanStrategy': 0, 'b:allowGenerics': 1, 'b:allowVarargs': 1, 'b:allowAsserts': 1, 'b:allowEnums': 1, 'b:allowForeach': 1, 'b:allowStaticImport': 1, 'b:allowAnnotations': 1, 'b:keepDocComments': 1, 'b:mode': 0, 'b:lastmode': 0, 'b:log': [], 'b:et_perf': '', 'b:et_nextToken_count': 0}

" Function to initialize the parser
" parameters:
" - lines	List of code text
" - options	A set of options
fu! java_parser#InitParser(lines, ...)
  let s:options = a:0 == 0 ? {} : a:1

  " internal variables for scanning
  " let b:buf = ''		" The input buffer
  let b:buflen = 0		" index of one past last character in buffer. also eofPos
  let b:lines = a:lines		" The input buffer
  let b:idxes = [0]		" Begin index of every lines
  let b:bp = -1			" index of next character to be read.
  let b:ch = ''			" The current character.
  let b:line = 0		" The line number position of the current character.
  let b:col = 0			" The column number position of the current character.
  let b:pos = 0			" The token's position, 0-based offset from beginning of text.
  let b:endPos = 0		" Character position just after the last character of the token.
  let b:prevEndPos = 0		" The last character position of the previous token.
  let b:errPos = -1		" The position where a lexical error occurred
  let b:errorEndPos = -1	" 
  let b:sbuf = ''		" A character buffer for literals.
  let b:name = ''		" The name of an identifier or token:
  let b:token = 0		" The token, set by s:nextToken().
  let b:docComment = ''
  let b:radix = 0		" The radix of a numeric literal token.
  let b:unicodeConversionBp =-1 " The buffer index of the last converted unicode character

  let b:scanStrategy = get(s:options, 'scanStrategy', -1)	" 0 - only class members when parse full file; 
  " 1 - keep statement as a whole string; 
  " 2 - all 
  " -1 - enable quick recognition of declarations in common form.

  " language feature options.
  let b:allowGenerics = get(s:options, 'allowGenerics', 1)
  let b:allowVarargs = get(s:options, 'allowVarargs', 1)
  let b:allowAsserts = get(s:options, 'allowAsserts', 1)
  let b:allowEnums = get(s:options, 'allowEnums', 1)
  let b:allowForeach = get(s:options, 'allowForeach', 1)
  let b:allowStaticImport = get(s:options, 'allowStaticImport', 1)
  let b:allowAnnotations = get(s:options, 'allowAnnotations', 1)
  let b:keepDocComments = get(s:options, 'keepDocComments', 1)

  let b:mode = 0		" The current mode.
  let b:lastmode = 0		" The mode of the term that was parsed last.


  let s:log = []

  let b:et_perf = ''
  let b:et_nextToken_count = 0

  "  let b:buf = join(a:lines, "\r")
  "  let b:buflen = strlen(b:buf)
  for line in a:lines
    let b:buflen += strlen(line) + 1
    call add(b:idxes, b:buflen)
  endfor
  call add(b:lines, s:EOI)	" avoid 'list index out of range' error from lines[] in java_scanChar
  "  if b:bp >= b:buflen
  "    return s:EOI
  "  endif

  " initialize scanner
  call s:scanChar()	" be ready for scanning
  call s:nextToken()	" prime the pump
endfu

fu! java_parser#FreeParser()
  for varname in keys(s:PROTOTYPE)
    exe "if exists(" . string(varname) . ") | unlet " . varname . " | endif"
  endfor
endfu

fu! java_parser#GetSnapshot()
  let snapshot = {}
  for varname in keys(s:PROTOTYPE)
    exe "let snapshot[" . string(varname) . "] = " . varname
  endfor
  return snapshot
endfu

fu! java_parser#Restore(snapshot)
  for key in keys(a:snapshot)
    exe "let " . key . "=" . string(a:snapshot[key])
  endfor
endfu

" move b:bp and b:pos to the specified position
fu! java_parser#GotoPosition(pos)
  let b:bp = a:pos-1
  let b:pos = a:pos
  let p = java_parser#DecodePos(b:bp)
  let b:line = p.line
  let b:col = p.col
  call s:scanChar()
  call s:nextToken()
endfu

fu! java_parser#compilationUnit()
  return s:compilationUnit()
endfu

fu! java_parser#block()
  return s:block()
endfu

fu! java_parser#statement()
  return s:blockStatements()
endfu

fu! java_parser#expression()
  return s:expression()
endfu

fu! java_parser#nextToken()
  return s:nextToken()
endfu


" Tree									{{{1
let s:TTree = {'tag': '', 'pos': 0}	" Root class for AST nodes.

" Tree maker functions							{{{2
fu! s:ClassDef(pos, mods, ...)
  return {'tag': 'CLASSDEF', 'pos': a:pos, 'mods': a:mods, 'name': ''}
endfu

fu! s:VarDef(pos, mods, name, vartype)
  return {'tag': 'VARDEF', 'pos': a:pos, 'mods': a:mods, 'name': a:name, 'vartype': a:vartype}
endfu

fu! s:Unary(pos, opcode, arg)
  return {'tag': a:opcode, 'pos': a:pos, 'arg': a:arg}
endfu

fu! s:Binary(pos, opcode, lhs, rhs, ...)
  return {'tag': a:opcode, 'pos': a:pos, 'lhs': a:lhs, 'rhs': a:rhs}
endfu

fu! s:TypeCast(pos, clazz, expr)
  return {'tag': 'TYPECAST', 'pos': a:pos, 'clazz': a:clazz, 'expr': a:expr}
endfu

fu! s:Select(pos, selected, name)
  return {'tag': 'SELECT', 'pos': a:pos, 'selected': a:selected, 'name': a:name}
endfu

fu! s:Ident(pos, name)
  return {'tag': 'IDENT', 'pos': a:pos, 'name': a:name}
endfu

fu! s:TypeArray(pos, elementtype)
  return {'tag': 'TYPEARRAY', 'pos': a:pos, 'elementtype': a:elementtype}
endfu

fu! s:Modifiers(pos, flags, annotations)
  let noFlags = s:BitAnd(a:flags, s:Flags.StandardFlags) == 0
  let mods = {'tag': 'MODIFIERS', 'flags': a:flags}
  let mods.pos = noFlags && empty(a:annotations) ? -1 : a:pos
  if !empty(a:annotations)
    let mods.annotations = a:annotations
  endif
  return mods
endfu

fu! java_parser#SScope()
  return s:
endfu

fu! s:GetInnerText(left)
  let line = b:line
  let col = b:col
  while b:lines[line][col] != a:left
    if col == 0
      if line == 0
        return ''
      endif
      let line -= 1
      let col = len(b:lines[line])
    else
      let col -= 1
    endif
  endwhile

  let right = s:GetPair(a:left)
  let startPos = java_parser#MakePos(line, col)
  let endPos = 0
  let br = 0
  while b:lines[line][col] != right || br > 0
    let col += 1
    if col >= len(b:lines[line])
      let col = 0
      let line += 1
      if line >= len(b:lines)
        return ''
      endif
    endif

    if b:lines[line][col] == a:left
      let br += 1
    elseif b:lines[line][col] == right
      if br > 0
        let br -= 1
      else
        let endPos = java_parser#MakePos(line, col)
        break
      endif
    endif
  endwhile
  let result = ""
  while startPos <= endPos
    let pos = java_parser#DecodePos(startPos)
    let result .= b:lines[pos.line][pos.col]
    let startPos += 1
  endwhile
  return result
endfu

fu! s:GetPair(left)
  if a:left == '('
    return ')'
  elseif a:left == '{'
    return '}'
  elseif a:left == '<'
    return '>'
  endif
  return a:left
endfu

" 				{{{2
fu! java_parser#IsStatement(tree)
  return has_key(a:tree, 'tag') && a:tree.tag =~# '^\(CLASSDEF\|VARDEF\|BLOCK\|IF\|DOLOOP\|WHILELOOP\|FORLOOP\|FOREACHLOOP\|SWITCH\|TRY\|EXEC\|LABELLED\|SYNCHRONIZED\|CASE\|BREAK\|RETURN\|SKIP\|THROW\|ASSERT\|CONTINUE\)$'
endfu

" Tree Helper						{{{1
fu! java_parser#type2Str(type)
  if type(a:type) == type("")
    return a:type
  endif

  let t = a:type
  if t.tag == 'IDENTIFIER'
    return t.value
  elseif t.tag == 'IDENT'
    return t.name
  elseif t.tag == 'TYPEIDENT'
    return t.typetag
  elseif t.tag == 'SELECT'
    return java_parser#type2Str(t.selected) . '.' . t.name
  elseif t.tag == 'TYPEARRAY'
    return java_parser#type2Str(t.elementtype) . '[]'
  elseif t.tag == 'TYPEAPPLY'
    let s = ''
    for arg in get(t, 'arguments', [])
      if type(arg) == type({}) && has_key(arg, 'tag')
        if arg.tag == 'TYPEAPPLY'
          let s .= java_parser#type2Str(arg). ','
        elseif arg.tag == 'TYPEARRAY'
          let s .= java_parser#type2Str(arg). ','
        elseif has_key(arg, 'name')
          let s .= arg.name. ','
        endif
      endif
      unlet arg
    endfor

    if len(s) > 0
      return t.clazz.name . '<'. s[0:-2]. '>'
    endif

    return get(t.clazz, 'name', '')
  elseif t.tag == 'TEMPLATE'
    let s = t.clazz.value . '<'
    for arg in t.arguments
      let s .= arg.value
    endfor
    let s .= '>'
    return s
  endif
endfu

fu! s:vardef2Str(vardef)
  return java_parser#type2Str(a:vardef.vartype) . ' ' . a:vardef.name
endfu

fu! s:method2Str(methoddef)
  let m = a:methoddef
  let desc = m.r . ' ' . m.n . '('
  for item in m.params
    let desc .= s:vardef2Str(item) . ','
  endfor
  let desc = substitute(desc, ',$', '', '')
  let desc .= ')'
  return desc
endfu

" Scanner								{{{1

" nextToken()								{{{2
fu! s:nextToken()
  let b:prevEndPos = b:endPos
  let b:et_nextToken_count += 1
  let b:sbuf = ''
  while 1
    let b:pos = b:bp
    if b:ch =~ '[ \t\r\n]'	"  - FF
      " OAO optimized code: skip spaces
      let b:col = match(b:lines[b:line], '[^ \t\r\n]\|$', b:col)
      let b:bp = b:idxes[b:line] + b:col
      call s:scanChar()
      let b:endPos = b:bp
      continue

    elseif b:ch =~ '[a-zA-Z$_]'
      " read a identifier
      call s:scanIdent()
      return

    elseif b:ch == '0'
      call s:scanChar()
      " hex
      if b:ch == 'x' || b:ch == 'X'
        call s:scanChar()
        if b:ch == '.'
          call s:scanHexFractionAndSuffix(0)
        elseif s:isDigit(16)
          call s:scanNumber(16)
        else
          call s:LexError("invalid.hex.number")
        endif
        " oct
      else
        let b:sbuf .= '0'
        call s:scanNumber(8)
      endif
      return

    elseif b:ch =~ '[1-9]'
      " read number
      call s:scanNumber(10)
      return

    elseif b:ch == '.'
      call s:scanChar()
      if b:ch =~ '[0-9]'
        let b:sbuf .= '.'
        call s:scanFractionAndSuffix()
        " JAVA5 ELLIPSIS
      elseif b:ch == '.'
        let b:sbuf .= '..'
        call s:scanChar()
        if b:ch == '.'
          call s:scanChar()
          let b:sbuf .= '.'
          let b:token = 'ELLIPSIS'
        else
          call s:LexError('malformed.fp.lit')
        endif
      else
        let b:token = 'DOT'
      endif
      return

    elseif b:ch =~ '[,;(){}[\]]'
      let b:token = s:keywords[b:ch]
      call s:scanChar()
      return

    elseif b:ch == '/'
      let status = s:scanComment()
      if status == 1
        continue
      elseif status == 2
        return
      elseif b:ch == '='
        let b:name = '/='
        let b:token = 'SLASHEQ'
        call s:scanChar()
      else
        let b:name = '/'
        let b:token = 'SLASH'
      endif
      return


    elseif b:ch == "'"
      call s:scanSingleQuote()
      return

    elseif b:ch == '"'
      call s:scanDoubleQuote()
      return

    else
      if s:IsSpecial(b:ch)
        call s:scanOperator()
      elseif b:ch =~ '[a-zA-Z_]'
        call s:scanIdent()
      elseif b:bp >= b:buflen 
        let b:token = 'EOF'
      else
        call s:LexError("illegal.char '" . b:ch . "'")
        call s:scanChar()
      endif
      return
    endif
  endwhile
endfu

" Read next character.		multiple lines version 
fu! s:scanChar()
  let b:bp+=1
  let b:ch=b:lines[b:line][b:col]
  let b:col+=1
  if b:ch==''
    let b:ch="\r"
    let b:line+=1
    let b:col=0
  endif

  if b:ch == '\'
    call s:convertUnicode()
  endif
endfu

fu! java_parser#CharAt(line, col)
  let ch=b:lines[a:line][a:col]
  if ch == ''
    let ch = "\r"
  endif
  return ch
endfu

fu! s:convertUnicode()
  if b:ch == '\' && b:unicodeConversionBp != b:bp
    "if java_parser#CharAt(b:bp+1) == 'u'
    "call s:scanChar()
    "endif
  endif
endfu

" putChar() is substituted with 
"	let b:sbuf .= '.'

" scanIdent()								{{{2
" OAO optimized code
fu! s:scanIdent()
  let col_old = b:col
  let b:col = match(b:lines[b:line], '[^a-zA-Z0-9$_]\|$', b:col)
  let b:name = strpart(b:lines[b:line], col_old-1, b:col-col_old+1)
  let b:token = get(s:keywords, b:name, 'IDENTIFIER')
  call s:Debug('name: "' . b:name . '" of token type ' . b:token )
  let b:bp = b:idxes[b:line] + b:col
  call s:scanChar()
endfu

" Standard implementation
fu! s:scanIdent_old()
  " do ... while ()
  let b:sbuf .= b:ch
  call s:scanChar()
  if b:ch !~ '[a-zA-Z0-9$_]' || b:bp >= b:buflen
    let b:name = b:sbuf
    let b:token = has_key(s:keywords, b:name) ? s:keywords[b:name] : 'IDENTIFIER'
    call s:Debug('name: "' . b:name . '" of token type ' . b:token )
    return
  endif

  while (1)
    let b:sbuf .= b:ch
    call s:scanChar()
    if b:ch !~ '[a-zA-Z0-9$_]' || b:bp >= b:buflen
      let b:name = b:sbuf
      let b:token = has_key(s:keywords, b:name) ? s:keywords[b:name] : 'IDENTIFIER'
      call s:Debug('name: "' . b:name . '" of token type ' . b:token )
      break
    endif
  endwhile
endfu

" digit()								{{{2
" Convert an ASCII digit from its base (8, 10, or 16) to its value.
" NOTE: This only implement isdigit() check
fu! s:digit(base)
  let c = b:ch
  "let result = 
endfu

fu! s:isDigit(base)
  if a:base == 8
    return b:ch =~ '[0-7]'
  elseif a:base == 16
    return b:ch =~ '[0-9a-fA-F]'
  elseif a:base == 10
    return b:ch =~ '[0-9]'
  endif
endfu

" scanNumber()								{{{2
fu! s:scanNumber(radix)
  let b:radix = a:radix
  let digitRadix = a:radix <= 10 ? 10 : 16
  let seendigit = 0
  while s:isDigit(a:radix)
    let seendigit = 1
    let b:sbuf .= b:ch
    call s:scanChar()
  endwhile
  if a:radix == 16 && b:ch == '.'
    call s:scanHexFractionAndSuffix(seendigit)
  elseif seendigit && a:radix == 16 && (b:ch == 'p' || b:ch == 'P')
    call s:scanHexExponentAndSuffix()
  elseif a:radix <= 10 && b:ch == '.'
    let b:sbuf .= b:ch
    call s:scanChar()
    call s:scanFractionAndSuffix()
  elseif a:radix <= 10 && b:ch =~ '[eEfFdD]'
    call s:scanFractionAndSuffix()
  else
    if b:ch == 'l' || b:ch == 'L'
      call s:scanChar()
      let b:token = 'LONGLITERAL'
    else
      let b:token = 'INTLITERAL'
    endif
  endif
endfu

fu! s:scanHexExponentAndSuffix()
  if b:ch == 'p' || b:ch == 'P'
    let b:sbuf .= b:ch
    call s:scanChar()
    if b:ch == '+' || b:ch == '-'
      let b:sbuf .= b:ch
      call s:scanChar()
    endif

    if '0' <= b:ch && b:ch <= '9'
      let b:sbuf .= b:ch
      call s:scanChar()
      while '0' <= b:ch && b:ch <= '9'
        let b:sbuf .= b:ch
        call s:scanChar()
      endwhile

      "if !b:allowHexFloats
      "elseif !b:hexFloatsWork
      "  call s:LexError("unsupported.cross.fp.lit")
      "endif
    else
      call s:LexError("malformed.fp.lit")
    endif
  else
    call s:LexError("malformed.fp.lit")
  endif

  if b:ch == 'f' || b:ch == 'F'
    let b:sbuf .= b:ch
    call s:scanChar()
    let b:token = 'FLOATLITERAL'
  else
    if b:ch == 'f' || b:ch == 'F'
      let b:sbuf .= b:ch
      call s:scanChar()
    endif
    let b:token = 'DOUBLELITERAL'
  endif
endfu

fu! s:scanFraction()
  " scan fraction
  while b:ch =~ '[0-9]'
    let b:sbuf .= b:ch
    call s:scanChar()
  endwhile

  " floating point number
  if b:ch == 'e' || b:ch == 'E'
    let b:sbuf .= b:ch
    call s:scanChar()

    if b:ch == '+' || b:ch == '-'
      let b:sbuf .= b:ch
      call s:scanChar()
    endif

    if b:ch =~ '[0-9]'
      let b:sbuf .= b:ch
      call s:scanChar()
      while b:ch =~ '[0-9]'
        let b:sbuf .= b:ch
        call s:scanChar()
      endwhile
      return 
    endif

    call s:LexError("malformed.fp.lit")
  endif
endfu

" Read fractional part and 'd' or 'f' suffix of floating point number.
fu! s:scanFractionAndSuffix()
  call s:scanFraction()
  if b:ch == 'f' || b:ch == 'F'
    let b:sbuf .= b:ch
    call s:scanChar()
    let b:token = 'FLOATLITERAL'
  else
    if b:ch == 'd' || b:ch == 'D'
      let b:sbuf .= b:ch
      call s:scanChar()
    endif
    let b:token = 'DOUBLELITERAL'
  endif
endfu

fu! s:scanHexFractionAndSuffix(seendigit)
  let seendigit = a:seendigit
  let b:radix = 16
  if b:ch != '.' | echoerr "b:ch != '.'" | endif

  let b:sbuf .= b:ch
  call s:scanChar()
  while s:isDigit(16)
    let seendigit = 1
    let b:sbuf .= b:ch
    call s:scanChar()
  endwhile

  if !seendigit
    call s:LexError("invalid.hex.number")
  else
    call s:scanHexExponentAndSuffix()
  endif
endfu

" scanLitChar()								{{{2
fu! s:scanLitChar()
  if b:ch == '\'
    call s:scanChar()
    if b:ch =~ '[0-7]'
      let leadch = b:ch
      let oct = b:ch
      call s:scanChar()
      if b:ch =~ '[0-7]'
        let oct = oct * 8 + b:ch
        call s:scanChar()
        if leadch <= '3' && '0' <= b:ch && b:ch <= '7'
          let oct = oct * 8 + b:ch
          call s:scanChar()
        endif
      endif
      let b:sbuf .= oct

    elseif b:ch == "'" || b:ch =~ '[btnfr"\\]'
      let b:sbuf .= b:ch
      call s:scanChar()

      " unicode escape
    elseif b:ch == 'u'
      while b:ch =~ '[a-zA-Z0-9]'
        call s:scanChar()
      endwhile

    else
      call s:LexError("illegal.esc.char")
    endif

  elseif b:bp < b:buflen
    let b:sbuf .= b:ch
    call s:scanChar()
  endif
endfu

" scanOperator()								{{{2
fu! s:scanOperator()
  while 1
    if !has_key(s:keywords, b:sbuf . b:ch)
      break
    endif

    let b:sbuf .= b:ch
    let b:token = get(s:keywords, b:sbuf, 'IDENTIFIER')
    call s:Debug('sbuf: "' . b:sbuf . '" of token type ' . b:token )
    call s:scanChar()
    if !s:IsSpecial(b:ch)
      break
    endif
  endwhile
endfu

" NOTE: add @ for JAVA5
fu! s:IsSpecial(ch)
  return a:ch =~ '[!%&*?+-:<=>^|~@]'
endfu

" scan comment							{{{2
" return 0 - not comment, 1 - succeeded to scan comment, 2 - unclosed comment
fu! s:scanComment()
  call s:scanChar()
  " line comment
  if b:ch == '/'
    let b:token = 'LINECOMMENT'
    call s:Info('line comment')
    call s:SkipLineComment()
    let b:endPos = b:bp
    return 1

    " classic comment
    " test cases: /**/, /***/, /*******/, /*** astatement; /***/, /*/
  elseif b:ch == '*'
    let b:token = 'BLOCKCOMMENT'
    call s:Info('block comment')
    call s:scanChar()
    let time = reltime()
    " javadoc
    if b:ch == '*'
      let b:docComment = s:scanDocComment()
      " normal comment
    else
      call s:skipComment()
    endif
    let b:et_perf .= "\r" . 'comment ' . reltimestr(reltime(time))

    if b:ch == '/'
      call s:Info('end block comment')
      call s:scanChar()
      let b:endPos = b:bp
      return 1
    else
      call s:LexError('unclosed.comment')
      return 2
    endif
  endif
  return 0
endfu

fu! s:SkipLineComment()
  " OAO optimized code
  let b:ch = "\r"
  let b:line += 1
  let b:col = 0
  let b:bp = b:idxes[b:line] + b:col

  " OLD 
  "call s:scanChar()
  "while (b:ch != "\r")
  "  call s:scanChar()
  "endwhile
endfu

fu! s:skipComment()
  if b:ch == '*'
    call s:scanChar()
    if b:ch == '/'
      return
    else	" NOTE: go back
      let b:ch = '*'
      let b:bp -= 1
      let b:col -= 1
    endif 
  endif

  " OAO optimized code
  if s:Stridx('*/') > -1
    call s:scanChar()
  endif

  "  " Standard implementation 
  "  while b:bp < b:buflen
  "    if b:ch == '*'
  "      call s:scanChar()
  "      if b:ch == '/'
  "        break
  "      endif
  "    else
  "      call s:scanChar()
  "    endif
  "  endwhile
endfu

fu! s:scanDocComment()
  call s:Info('It is javadoc')
  return s:skipComment()

  " skip star '*'
  while (b:bp < b:buflen && b:ch == '*')
    call s:scanChar()
  endwhile

  if b:bp < b:buflen && b:ch == '/'
    return ''
  endif

  let result = ''
  while b:bp < b:buflen
    if b:ch == '*'
      call s:scanChar()
      if b:ch == '/'
        break
      else
        let result .= b:ch
      endif
    else
      call s:scanChar()
      let result .= b:ch
    endif
  endwhile

  return result
endfu

" scan single quote							{{{2
fu! s:scanSingleQuote()
  call s:scanChar()
  if (b:ch == "'")
    call s:LexError("empty.char.lit")
  else
    if (b:ch =~ '[\r\n]')
      call s:LexError("illegal.line.end.in.char.lit")
    endif

    call s:scanLitChar()
    if b:ch == "'"
      call s:scanChar()
      let b:token = 'CHARLITERAL'
    else
      call s:LexError("unclosed.char.lit")
    endif
  endif
endfu

" scan double quote							{{{2
" test cases:
"	'a"";'
"	'a"b,c";'
"	'a"b,\"c";'
"	'a"b,\\"c";'
"	'a"b,\\\"c";'
"	'a"b,\\\\"c";'
"	'a"b,\\\"c;'	" NOTE: cannot handle
fu! s:scanDoubleQuote()
  if match(b:lines[b:line], '\\"', b:col) == -1
    let idx = matchend(b:lines[b:line], '\(\\\(["\\''ntbrf]\)\|[^"]\)*"', b:col)
    if idx != -1
      let b:sbuf = strpart(b:lines[b:line], b:col, idx-b:col-1)
      let b:col = idx-1	" back to the end 
      let b:bp = b:idxes[b:line] + b:col
      call s:scanChar()
      let b:token = 'STRINGLITERAL'
    else
      call s:LexError("unclosed.str.lit")
    endif
    call s:scanChar()
    return
  endif


  call s:scanChar()
  while b:ch !~ '["\r\n]' && b:bp < b:buflen
    call s:scanLitChar()
  endwhile

  if b:ch == '"'
    let b:token = 'STRINGLITERAL'
    call s:scanChar()
  else
    call s:LexError("unclosed.str.lit")
  endif
endfu

" lex errors					{{{2
fu! s:LexError(key, ...)
  let pos = a:0 == 0 ? b:pos : a:1
  let b:token = 'ERROR'
  let b:errPos = pos
  call s:Log(4, b:pos, '[lex error]:' . s:Pos2Str(pos) . ': ' . a:key)
endfu

" Scanner Helper							{{{1
" gotoMatchEnd								{{{2
fu! s:gotoMatchEnd(one, another, ...)
  while b:bp < b:buflen
    if b:ch == a:another
      call s:scanChar()
      if has_key(s:keywords, a:another)
        let b:token = s:keywords[a:another]
      else
        echoerr '<strange>'
      endif
      break

    elseif b:ch == a:one
      call s:scanChar()
      call s:gotoMatchEnd(a:one, a:another)

      " skip commment
    elseif b:ch == '/'
      call s:scanComment()

      " skip literal character
    elseif b:ch == "'"
      call s:scanSingleQuote()

      " skip literal string
    elseif b:ch == '"'
      call s:scanDoubleQuote()

    else
      " OAO 
      call s:Match('[' . a:one . a:another . '/"'']')
      " OLD 
      "call s:scanChar()
    endif
  endwhile

  " For such situation: after accept one token, the next token is just the same.
  let nextTokenIsLBRACE = a:0 == 0 ? 0 : a:1
  if nextTokenIsLBRACE
    call s:gotoMatchEnd(a:one, a:another)
  endif

  return b:bp
endfu

" gotoSemi								{{{2
fu! s:gotoSemi()
  while b:bp < b:buflen
    if b:ch == ';'
      let b:pos = b:bp
      call s:scanChar()
      let b:token = 'SEMI'
      return

      " skip commment
    elseif b:ch == '/'
      call s:scanComment()

      " skip literal character
    elseif b:ch == "'"
      call s:scanSingleQuote()

      " skip literal string
    elseif b:ch == '"'
      call s:scanDoubleQuote()

    elseif b:ch == '{'
      call s:scanChar()
      call s:gotoMatchEnd('{', '}')

    elseif b:ch == '('
      call s:scanChar()
      call s:gotoMatchEnd('(', ')')

    elseif b:ch == '['
      call s:scanChar()
      call s:gotoMatchEnd('[', ']')

    else
      " OAO 
      call s:Match('[;({[/"'']')
      " OLD 
      "call s:scanChar()
    endif
  endwhile
endfu

" s:Strpart(), s:Stridx(), s:Match()					{{{2
fu! Strpart(start, len)
  let startline = java_parser#DecodePos(a:start).line
  let endline   = java_parser#DecodePos(a:start + a:len).line
  let str = join(b:lines[startline:endline-1]) . b:lines[endline]
  return strpart(str, a:start-b:idxes[startline], a:len)
endfu

fu! s:Stridx(needle)
  let found = 0
  while b:line < len(b:lines)-1
    let idx = stridx(b:lines[b:line], a:needle, b:col)
    if idx > -1
      let found = 1
      let b:col = idx
      break
    endif
    let b:line += 1
    let b:col = 0
  endwhile

  if found
    let b:bp = b:idxes[b:line] + b:col
    call s:scanChar()
    return b:bp
  else
    let b:bp = b:buflen
    let b:ch = s:EOI
    return -1
  endif
endfu

fu! s:Match(pat)
  let bp_old = b:bp
  let line_old = b:line
  let col_old = b:col

  let found = 0
  while b:line < len(b:lines)-1
    let idx = match(b:lines[b:line], a:pat, b:col)
    if idx > -1
      let found = 1
      let b:col = idx
      break
    endif
    let b:line += 1
    let b:col = 0
  endwhile

  if found
    let b:bp = b:idxes[b:line] + b:col-1
    call s:scanChar()
    return b:bp
  else
    let b:bp = bp_old
    let b:line = line_old
    let b:col = col_old
    call s:scanChar()
    return -1
  endif
endfu


" conversion between position and (line, col)				{{{2
fu! java_parser#MakePos(line, col)
  if exists('b:idxes') && len(b:idxes) >= a:line
    return b:idxes[a:line] + a:col
  endif
  return 0
endfu

fu! java_parser#DecodePos(pos)
  let line = -1
  for idx in b:idxes
    if idx > a:pos
      break
    endif
    let line += 1
  endfor
  let col = a:pos - b:idxes[line]
  return {'line': line, 'col': col}
endfu

fu! s:Pos2Str(pos)
  let o = java_parser#DecodePos(a:pos)
  return '(' . (o.line+1) . ',' . (o.col+1) . ')'
endfu

" Bitwise operator emulators						{{{1
" NOTE: For more than 32 bit number, use the string bits form.

" bit operator ~
fu! s:BitNot(v)
  return s:Bits2Number( s:BitNot_binary(s:Number2Bits(a:v)) )
endfu

fu! s:BitNot_binary(v)
  let v = substitute(a:v, '^0*\([01]\+\)', '\1', 'g')
  let v = substitute(v, '1', '2', 'g')
  let v = substitute(v, '0', '1', 'g')
  let v = substitute(v, '2', '0', 'g')
  return v
endfu

" bit operator &
fu! s:BitAnd(n1, n2)
  if a:n1 == 0 || a:n2 == 0	| return 0 | endif
  if a:n1 == a:n2		| return 1 | endif
  return s:Bits2Number( s:BitOperator_binary(s:Number2Bits(a:n1), s:Number2Bits(a:n2), 'n1[i] == "1" && n2[i] == "1"') )
endfu

" bit operator |
fu! s:BitOr(n1, n2, ...)
  if a:0 == 0
    if a:n1 == 0
      return a:n2
    elseif a:n2 == 0
      return a:n1
    endif
  endif
  let result = s:BitOperator_binary(s:Number2Bits(a:n1), s:Number2Bits(a:n2), 'n1[i] == "1" || n2[i] == "1"')
  for a in a:000
    let result = s:BitOperator_binary(result, s:Number2Bits(a), 'n1[i] == "1" || n2[i] == "1"')
  endfor
  return s:Bits2Number( result )
endfu

" bit operator ^
fu! s:BitXor(n1, n2)
  if a:n1 == a:n2	| return 0 | endif
  return s:Bits2Number( s:BitOperator_binary(s:Number2Bits(a:n1), s:Number2Bits(a:n2), 'n1[i] != n2[i]') )
endfu

fu! s:BitOperator_binary(n1, n2, comparator)
  let n1 = a:n1
  let n2 = a:n2

  let len1 = len(n1)
  let len2 = len(n2)
  let len  = len1
  if len1 > len2
    let n2 = repeat('0', len1-len2) . n2
  else
    let len = len2
    let n1 = repeat('0', len2-len1) . n1
  endif

  let i = 0
  let bits = ''
  while i < len
    let bits .= eval(a:comparator) ? '1' : '0'
    let i += 1
  endwhile
  return bits
endfu

" bit operator <<
fu! s:BitMoveLeft()
endfu

" bit operator >>
fu! s:BitMoveRight()
endfu

" helper function: convert a number to a string consisted of '0' or '1' indicating number
fu! s:Number2Bits(n, ...)
  if type(a:n) == type("") | return a:n | endif
  if a:n == 0 | return '0' | endif

  let n = a:n
  let bits = ''
  while n != 0
    let bit = n % 2
    "echo 'n: ' . n . ' bit: ' . bit
    let bits = bit . bits
    let n = (n-bit)/ 2
  endwhile
  if a:0 > 0
    let bits = repeat(a:1 - len(bits)) . bits
  endif
  return bits
endfu

" helper function: convert a string consisted of '0' or '1' indicating number to a number
" precondition: bits must not be empty string
fu! s:Bits2Number(bits)
  let len = len(a:bits)
  let n = a:bits[0]
  let i = 1
  while i < len
    let n = n * 2 + a:bits[i]
    let i += 1
  endwhile
  return n
endfu


let s:modifier_keywords = ['strictfp', 'abstract', 'interface', 'native', 'transient', 'volatile', 'synchronized', 'final', 'static', 'protected', 'private', 'public']
fu! s:String2Flags(str)
  let mod = [0,0,0,0,0,0,0,0,0,0,0,0,]
  for item in split(a:str, '\s\+')
    if index(s:modifier_keywords, item) != -1
      let mod[index(s:modifier_keywords, item)] = '1'
    endif
  endfor
  return join(mod[index(mod, '1'):], '')
endfu

" Log utilities							{{{1
" level
" 	5	off/fatal 
" 	4	error 
" 	3	warn
" 	2	info
" 	1	debug
" 	0	trace
fu! java_parser#SetLogLevel(level)
  let b:loglevel = a:level
endfu

fu! java_parser#GetLogLevel()
  return exists('b:loglevel') ? b:loglevel : 0
endfu

fu! java_parser#GetLogContent()
  new
  put =s:log
endfu

fu! s:Trace(msg)
  call s:Log(0, b:pos, a:msg)
endfu

fu! s:Debug(msg)
  call s:Log(1, b:pos, a:msg)
endfu

fu! s:Info(msg)
  call s:Log(2, b:pos, a:msg)
endfu

fu! s:Log(level, pos, key, ...)
  if a:level >= java_parser#GetLogLevel()
    let log = type(a:key) == type("") ? a:key : string(a:key)
    call add(s:log, log)
  endif
endfu

fu! s:ShowWatch(...)
  let at = a:0 > 0 ? a:1 : ''
  echo '-- b:bp ' . b:bp . string(java_parser#DecodePos(b:bp)) . ' b:ch "' . b:ch . '" b:name ' . b:name . ' b:token ' . b:token . ' b:pos ' .b:pos . ' endPos ' . b:endPos . ' prevEndPos ' . b:prevEndPos . ' errPos ' . b:errPos . ' errorEndPos ' . b:errorEndPos . at
endfu

fu! java_parser#Exe(cmd)
  exe a:cmd
endfu

" Parser								{{{1
" skip() Skip forward until a suitable stop token is found.		{{{2
fu! s:skip(stopAtImport, stopAtMemberDecl, stopAtIdentifier, stopAtStatement)
  while 1
    if b:token == 'SEMI'
      call s:nextToken()
      return
    elseif b:token =~# '^\(PUBLIC\|FINAL\|ABSTRACT\|MONKEYS_AT\|EOF\|CLASS\|INTERFACE\|ENUM\)$'
      return
    elseif b:token == 'IMPORT'
      if a:stopAtImport
        return
      endif
    elseif b:token =~# '^\(LBRACE\|RBRACE\|PRIVATE\|PROTECTED\|STATIC\|TRANSIENT\|NATIVE\|VOLATILE\|SYNCHRONIZED\|STRICTFP\|LT\|BYTE\|SHORT\|CHAR\|INT\|LONG\|FLOAT\|DOUBLE\|BOOLEAN\|VOID\)$'
      if a:stopAtMemberDecl
        return
      endif
    elseif b:token == 'IDENTIFIER'
      if a:stopAtIdentifier
        return
      endif
    elseif b:token =~# '^\(CASE\|DEFAULT\|IF\|FOR\|WHILE\|DO\|TRY\|SWITCH\|RETURN\|THROW\|BREAK\|CONTINUE\|ELSE\|FINALLY\|CATCH\)$'
      if a:stopAtStatement
        return
      endif
    endif
    call s:nextToken()
  endwhile
endfu

" syntax errors					{{{2
fu! s:SyntaxError(key, ...)
  let pos = a:0 == 0 ? b:pos : a:1
  let errs = a:0 > 1 ? a:2 : []
  call s:setErrorEndPos(pos)
  call s:ReportSyntaxError(pos, a:key)
  return {'tag': 'ERRONEOUS', 'pos': pos, 'errs': errs}
endfu

fu! s:ReportSyntaxError(pos, key, ...)
  if a:pos > b:errPos || a:pos == -1
    let key = a:key . (b:token == 'EOF' ? ' and premature.eof' : '')
    call s:Log(4, a:pos, '[syntax error]' . s:Pos2Str(a:pos) . ': ' . key)
  endif
  let b:errPos = a:pos
endfu

" accept()								{{{2
fu! s:accept(token_type)
  "call s:Debug(b:token . ' == ' . a:token_type  . (b:token == a:token_type))
  if b:token == a:token_type
    call s:nextToken()
  else
    call s:setErrorEndPos(b:pos)
    call s:ReportSyntaxError(b:prevEndPos, s:token2string(a:token_type) . " expected")
    "call s:nextToken()
  endif
endfu

fu! s:token2string(token)
  if a:token =~# '^\(DOT\|COMMA\|SEMI\|LPAREN\|RPAREN\|LBRACKET\|RBRACKET\|LBRACE\|RBRACE\)$'
    return "'" . a:token . "'"
  endif
  return a:token
endfu


" illegal()								{{{2
fu! s:illegal(...)
  call s:setErrorEndPos(b:pos)
  return s:SyntaxError(s:modeAndEXPR() ? 'illegal.start.of.expr' : 'illegal.start.of.type', a:0 == 0 ? b:pos : a:1)
endfu

" setErrorEndPos()							{{{2
fu! s:setErrorEndPos(errPos)
  if a:errPos > b:errorEndPos
    let b:errorEndPos = a:errPos
  endif
endfu

" ident()								{{{2
" Ident = IDENTIFIER
fu! s:ident()
  call s:Trace('s:ident ' . b:token)

  if b:token == 'IDENTIFIER'
    let name = b:name
    call s:nextToken()
    return name

  elseif b:token == 'ASSERT'
    if s:allowAsserts
      call s:Log(4, b:pos, 'assert.as.identifier')
      call s:nextToken()
      return '<error>'
    else
      call s:Log(3, b:pos, 'assert.as.identifier')
      let name = b:name
      call s:nextToken()
      return name
    endif

  elseif b:token == 'ENUM'
    if b:allowEnums
      call s:Log(4, b:pos, 'enum.as.identifier')
      call s:nextToken()
      return '<error>'
    else
      call s:Log(3, b:pos, 'enum.as.identifier')
      let name = b:name
      call s:nextToken()
      return name
    endif

  else
    call s:accept('IDENTIFIER')
    return '<error>'
  endif
endfu

" qualident()								{{{2
" Qualident = Ident { DOT Ident }
fu! s:qualident()
  let t = s:Ident(b:pos, s:ident())
  while b:token == 'DOT'
    let pos = b:pos
    call s:nextToken()
    let t = s:Select(b:pos, t, s:ident())
    "let t.name .= '.' . s:ident()		" FIXME
  endwhile
  return t
endfu

" literal()								{{{2
" Literal = INTLITERAL | LONGLITERAL | FLOATLITERAL | DOUBLELITERAL | CHARLITERAL | STRINGLITERAL | TRUE | FALSE | NULL
fu! s:literal(prefix)
  let t = {'tag': 'LITERAL', 'pos': b:pos}
  if b:token == 'INTLITERAL'
    let t.typetag = 'INT'
    let t.value = b:sbuf
  elseif b:token == 'LONGLITERAL'
    let t.typetag = 'LONG'
    let t.value = b:sbuf
  elseif b:token == 'FLOATLITERAL'
    let t.typetag = 'FLOAT'
    let t.value = b:sbuf
  elseif b:token == 'DOUBLELITERAL'
    let t.typetag = 'DOUBLE'
    let t.value = b:sbuf
  elseif b:token == 'CHARLITERAL'
    let t.typetag = 'CHAR'
    let t.value = b:sbuf
  elseif b:token == 'STRINGLITERAL'
    let t.typetag = 'CLASS'
    let t.value = b:sbuf
  elseif b:token == 'TRUE'
    let t.typetag = 'BOOLEAN'
    let t.value = 1
  elseif b:token == 'FALSE'
    let t.typetag = 'BOOLEAN'
    let t.value = 0
  elseif b:token == 'NULL'
    let t.typetag = 'BOT'
    let t.value = 'null'
  else
    echoerr 'can not reach here'
  endif
  call s:nextToken()
  return t
endfu

" 									{{{2
" terms, expression, type						{{{2
" When terms are parsed, the mode determines which is expected:
"     mode = EXPR        : an expression
"     mode = TYPE        : a type
"     mode = NOPARAMS    : no parameters allowed for type
"     mode = TYPEARG     : type argument
let s:EXPR = 1
let s:TYPE = 2
let s:NOPARAMS = 4
let s:TYPEARG = 8
let s:EXPR_OR_TYPE = 3
let s:EXPR_OR_TYPE_OR_NOPARAMS = 7
let s:TYPEARG_OR_NOPARAMS = 12

fu! s:modeAndEXPR()
  return b:mode % 2
endfu

fu! s:modeAndTYPE()
  return s:BitAnd(b:mode, s:TYPE)
endfu

" terms can be either expressions or types. 
fu! s:expression()
  return s:term(s:EXPR)
endfu

fu! s:type()
  return s:term(s:TYPE)
endfu

fu! s:typeList()
  let ts = []
  call add(ts, s:type())
  while b:token == 'COMMA'
    call s:nextToken()
    call add(ts, s:type())
  endwhile
  return ts
endfu

" Expression = Expression1 [ExpressionRest]
" ExpressionRest = [AssignmentOperator Expression1]
" AssignmentOperator = "=" | "+=" | "-=" | "*=" | "/=" |  "&=" | "|=" | "^=" |
"                      "%=" | "<<=" | ">>=" | ">>>="
" Type = Type1
" TypeNoParams = TypeNoParams1
" StatementExpression = Expression
" ConstantExpression = Expression
fu! s:term(...)
  let prevmode = b:mode
  let b:mode = a:0 == 0 ? b:mode : a:1

  let t = s:term1()
  if s:modeAndEXPR() && b:token == 'EQ' || b:token =~# '^\(RARROW\|PLUSEQ\|SUBEQ\|STAREQ\|SLASHEQ\|AMPEQ\|BAREQ\|CARETEQ\|PERCENTEQ\|LTLTEQ\|GTGTEQ\|GTGTGTEQ\)$'
    let t = s:termRest(t)
  endif

  let b:lastmode = b:mode
  let b:mode = prevmode
  return t
endfu

fu! s:lambdaDeclaration(lhs)
  if has_key(a:lhs, 'args')
    let lambdadef = {'tag': 'LAMBDA', 'args': a:lhs.args, 'pos': a:lhs.pos}
  else
    let lambdadef = {'tag': 'LAMBDA', 'args': a:lhs}
  endif
  call s:nextToken()
  if b:token == 'LBRACE'
    let lambdadef.body = s:block()
  else
    let lambdadef.body = s:statement()
  endif

  return lambdadef
endfu

fu! s:termRest(t)
  if b:token == 'EQ'
    let pos = b:pos
    call s:nextToken()
    let b:mode = s:EXPR
    return {'tag': 'ASSIGN', 'pos': pos, 'lhs': a:t, 'rhs': s:term()}

  elseif b:token =~# '^\(PLUSEQ\|SUBEQ\|STAREQ\|SLASHEQ\|PERCENTEQ\|AMPEQ\|BAREQ\|CARETEQ\|LTLTEQ\|GTGTEQ\|GTGTGTEQ\)$'
    let pos = b:pos
    let token = b:token
    call s:nextToken()
    let b:mode = s:EXPR
    return {'tag': s:optag(token), 'pos': pos, 'lhs': a:t, 'rhs': s:term()}

  elseif b:token == 'RARROW'
    return s:lambdaDeclaration(a:t)

  else
    return a:t
  endif
endfu

" Expression1   = Expression2 [Expression1Rest]
"  Type1         = Type2
"  TypeNoParams1 = TypeNoParams2
fu! s:term1()
  let t = s:term2()
  if s:modeAndEXPR() && b:token == 'QUES'
    let b:mode = s:EXPR
    return s:term1Rest(t)
  else
    return t
  endif
endfu

" Expression1Rest = ["?" Expression ":" Expression1]
fu! s:term1Rest(t)
  if b:token == 'QUES'
    let t = {'tag': 'CONDEXPR', 'pos': b:pos, 'cond': a:t}
    call s:nextToken()
    let t.truepart = s:term()
    call s:accept('COLON')
    let t.falsepart = s:term1()
    return t
  else
    return a:t
  endif
endfu

" Expression2   = Expression3 [Expression2Rest]
"  Type2         = Type3
"  TypeNoParams2 = TypeNoParams3
fu! s:term2()
  let t = s:term3()
  if s:modeAndEXPR()  && s:prec(b:token) >= s:opprecedences.orPrec
    let b:mode = s:EXPR
    return s:term2Rest(t, s:opprecedences.orPrec)
  else
    return t
  endif
endfu

" Expression2Rest = {infixop Expression3}
"" 		  | Expression3 instanceof Type
" infixop         = "||"
" 		  | "&&"
"		  | "|"
"		  | "^"
"		  | "&"
"		  | "==" | "!="
"		  | "<" | ">" | "<=" | ">="
"		  | "<<" | ">>" | ">>>"
"		  | "+" | "-"
"		  | "*" | "/" | "%"
fu! s:term2Rest(t, minprec)
  let odStack = [a:t]	" for expressions
  let opStack = []	" for tokens
  let top = 0
  let startPos = b:pos
  let topOp = 'ERROR'
  while s:prec(b:token) >= a:minprec
    call add(opStack, topOp)
    let top += 1
    let topOp = b:token
    let pos = b:pos
    call s:nextToken()
    call add(odStack, topOp == 'INSTANCEOF' ? s:type() : s:term3())
    while top > 0 && s:prec(topOp) >= s:prec(b:token)
      let odStack[top-1] = s:makeOp(pos, topOp, odStack[top-1], odStack[top])
      let top -= 1
      let topOp = opStack[top]
    endwhile
  endwhile
  "assert top == 0
  let t = odStack[0]

  if t.tag == 'PLUS'
    let buf = s:foldStrings(t)
    if buf != ''
      let t = {'tag': 'LITERAL', 'pos': startPos, 'typetag': 'CLASS', 'value': t}
    endif
  endif
  return t
endfu

fu! s:makeOp(pos, topOp, od1, od2)
  if a:topOp == 'INSTANCEOF'
    return {'tag': 'TYPETEST', 'pos': a:pos, 'expr': a:od1, 'clazz': a:od2}
  else
    return s:Binary(a:pos, s:optag(a:topOp), a:od1, a:od2)
  endif
endfu

fu! s:foldStrings(tree)
  let tree = a:tree
  let buf = ''
  while 1
    if tree.tag  == 'LITERAL'
      let lit = tree
      if lit.typetag == 'CLASS'
        let sbuf = lit.value
        if buf != ''
          let sbuf .= buf
        endif
        return sbuf
      endif
    elseif tree.tag == 'PLUS'
      let op = tree
      if op.rhs.tag == 'LITERAL'
        let lit = op.rhs
        if lit.typetag == 'CLASS'
          let buf = lit.value . buf
          let tree = op.lhs
          continue
        endif
      endif
    endif
    return ''
  endwhile
endfu

" Expression3    = PrefixOp Expression3					{{{2
"                | "(" Expr | TypeNoParams ")" Expression3
"                | Primary {Selector} {PostfixOp}
" Primary        = "(" Expression ")"
"                | Literal
"                | [TypeArguments] THIS [Arguments]
"                | [TypeArguments] SUPER SuperSuffix
"                | NEW [TypeArguments] Creator
"                | Ident { "." Ident }
"                  [ "[" ( "]" BracketsOpt "." CLASS | Expression "]" )
"                  | Arguments
"                  | "." ( CLASS | THIS | [TypeArguments] SUPER Arguments | NEW [TypeArguments] InnerCreator )
"                  ]
"                | BasicType BracketsOpt "." CLASS
" PrefixOp       = "++" | "--" | "!" | "~" | "+" | "-"
" PostfixOp      = "++" | "--"
" Type3          = Ident { "." Ident } [TypeArguments] {TypeSelector} BracketsOpt
"                | BasicType
" TypeNoParams3  = Ident { "." Ident } BracketsOpt
" Selector       = "." [TypeArguments] Ident [Arguments]
"                | "." THIS
"                | "." [TypeArguments] SUPER SuperSuffix
"                | "." NEW [TypeArguments] InnerCreator
"                | "[" Expression "]"
" TypeSelector   = "." Ident [TypeArguments]
" SuperSuffix    = Arguments | "." Ident [Arguments]
" NOTE: We need only type expression.
fu! s:term3()
  let pos = b:pos
  let t = copy(s:TTree)

  call s:Debug('term3() b:token is ' . b:token)
  let typeArgs = s:typeArgumentsOpt(s:EXPR)

  if b:token == 'QUES'
    if s:modeAndTYPE() && s:BitAnd(b:mode, s:TYPEARG_OR_NOPARAMS) == s:TYPEARG
      let b:mode = s:TYPE
      return s:typeArgument()
    else
      return s:illegal()
    endif

  elseif b:token =~# '^\(PLUSPLUS\|SUBSUB\|BANG\|TILDE\|PLUS\|SUB\)$'
    if typeArgs == [] && s:modeAndEXPR()
      let token = b:token
      call s:nextToken()
      let b:mode = s:EXPR
      if token == 'SUB' && (b:token == 'INTLITERAL' || b:token == 'LONGLITERAL') && b:radix == 10
        let b:mode = s:EXPR
        let t = s:literal('-')
      else
        let t = s:term3()
        return s:Unary(pos, s:unoptag(token), t)
      endif
    else
      return s:illegal()
    endif

  elseif b:token == 'LPAREN'
    if typeArgs == [] && s:modeAndEXPR()
      let nextText = s:GetInnerText("(")
      if nextText =~ s:RE_FORMAL_PARAM_LIST 
        let args = s:formalParameters()
        return {'tag': 'TYPEAPPLY', 'pos': b:pos, 'clazz': t, 'args': args}
      elseif nextText =~ s:RE_METHOD_ARGS
        let args = s:arguments()
        return {'tag': 'TYPEAPPLY', 'pos': b:pos, 'clazz': t, 'args': args}
      elseif s:modeAndEXPR() && b:token == 'LT'
        call s:nextToken()
        let b:mode = s:EXPR_OR_TYPE_OR_NOPARAMS
        let t = s:term3()

        let op = 'LT'
        let pos1 = b:pos
        call s:nextToken()
        let b:mode = s:BitAnd(b:mode, s:EXPR_OR_TYPE)
        let b:mode = s:BitOr(b:mode, s:TYPEARG)
        let t1 = s:term3()
        if s:modeAndTYPE() && (b:token == 'COMMA' || b:token == 'GT')
          let b:mode = s:TYPE
          let args = []
          call add(args, t1)
          while b:token == 'COMMA'
            call s:nextToken()
            call add(args, s:typeArgument())
          endwhile
          call s:accept('GT')
          let t = {'tag': 'TYPEAPPLY', 'pos': pos1, 'clazz': t, 'arguments': args}
          " checkGenerics
          let t = s:bracketsOpt(t)
        elseif s:modeAndEXPR()
          let b:mode = s:EXPR
          let t = s:Binary(pos1, op, t, s:term2Rest(t1, s:opprecedences.shiftPrec))
          let t = s:termRest(s:term1Rest(s:term2Rest(t, s:opprecedences.orPrec)))
        else
          call s:accept('GT')
        endif
      else
        let t = s:termRest(s:term1Rest(s:term2Rest(t, s:opprecedences.orPrec)))
      endif
      call s:accept('RPAREN')
      let b:lastmode = b:mode
      let b:mode = s:EXPR
      if s:BitAnd(b:lastmode, s:EXPR) == 0
        return s:TypeCast(pos, t, s:term3())
      elseif s:BitAnd(b:lastmode, s:TYPE) != 0
        if b:token =~# '^\(BANG\|TILDE\|LPAREN\|THIS\|SUPER\|INTLITERAL\|LONGLITERAL\|FLOATLITERAL\|DOUBLELITERAL\|CHARLITERAL\|STRINGLITERAL\|TRUE\|FALSE\|NULL\|NEW\|IDENTIFIER\|ASSERT\|ENUM\|BYTE\|SHORT\|CHAR\|INT\|LONG\|FLOAT\|DOUBLE\|BOOLEAN\|VOID\)$'
          return s:TypeCast(pos, t, s:term3())
        endif
      endif
    else
      return s:illegal()
    endif
    let t = {'tag': 'PARENS', 'pos': pos, 'expr': t}

  elseif b:token == 'THIS'
    if s:modeAndEXPR()
      let b:mode = s:EXPR
      let t = s:Ident(pos, 'this')
      call s:nextToken()
      if typeArgs == []
        let t = s:argumentsOpt([], t)
      else
        let t = s:arguments(typeArgs, t)
      endif
      let typeArgs = []
    else
      return s:illegal()
    endif

  elseif b:token == 'SUPER'
    if s:modeAndEXPR()
      let b:mode = s:EXPR
      let t = s:superSuffix(typeArgs, s:Ident(pos, 'super'))
      let typeArgs = []
    else
      return s:illegal()
    endif

  elseif b:token =~# '^\(INTLITERAL\|LONGLITERAL\|FLOATLITERAL\|DOUBLELITERAL\|CHARLITERAL\|STRINGLITERAL\|TRUE\|FALSE\|NULL\)$'
    if typeArgs == [] && s:modeAndEXPR()
      let b:mode = s:EXPR
      let t = s:literal('')
    else
      return s:illegal()
    endif

  elseif b:token == 'NEW'
    if typeArgs != []
      return s:illegal()
    endif

    if s:modeAndEXPR()
      let b:mode = s:EXPR
      call s:nextToken()
      if b:token == 'LT'
        let typeArgs = s:typeArguments()
      endif
      let t = s:creator(pos, typeArgs)
      let typeArgs = []
    else
      return s:illegal()
    endif

  elseif b:token =~# '^\(IDENTIFIER\|ASSERT\|ENUM\)$'
    if typeArgs != []
      return s:illegal()
    endif

    let t = s:Ident(pos, s:ident())
    while 1
      if b:token == 'LBRACKET'
        "let t.value = '['	" FIXME
        call s:nextToken()
        if b:token == 'RBRACKET'
          "let t.value .= ']'
          call s:nextToken()
          let t = s:bracketsSuffix(s:TypeArray(pos, s:bracketsOpt(t)))
        else
          if s:modeAndEXPR()
            let b:mode = s:EXPR
            let t = {'tag': 'INDEXED', 'pos': pos, 'indexed': t, 'index': s:term()}
          endif
          call s:accept('RBRACKET')
          "let t.value .= ']'
        endif
        break

      elseif b:token == 'LPAREN'
        if s:modeAndEXPR()
          let b:mode = s:EXPR
          let t = s:arguments(typeArgs, t)
          let typeArgs = []
          "call s:accept('LPAREN')
          "call s:gotoMatchEnd('(', ')', b:token == 'LPAREN')
          "call s:accept('RPAREN')
        endif
        break

      elseif b:token == 'DOT'
        call s:nextToken()
        let typeArgs = s:typeArgumentsOpt(s:EXPR)
        if s:modeAndEXPR()
          if b:token == 'CLASS' || b:token == 'THIS' 
            if typeArgs != []
              return s:illegal()
            endif
            let b:mode = s:EXPR
            let t = s:Select(pos, t, b:token == 'CLASS' ? 'class' : 'this')
            call s:nextToken()
            break
          elseif b:token == 'SUPER'
            let b:mode = s:EXPR
            let t = s:Select(pos, t, 'super')
            let t = s:superSuffix(typeArgs, t)
            let typeArgs = []
            break
          elseif b:token == 'NEW'
            if typeArgs != []
              return s:illegal()
            endif
            let b:mode = s:EXPR
            let pos1 = b:pos
            call s:nextToken()
            if b:token == 'LT'
              let typeArgs = s:typeArguments()
            endif
            let t = s:innerCreator(pos1, typeArgs, t)
            let typeArgs = []
            break
          endif
        endif
        let t = s:Select(pos, t, s:ident())
      else
        break
      endif
    endwhile
    if typeArgs != [] | call s:illegal() | endif
    let t = s:typeArgumentsOpt2(t)

  elseif b:token =~# '^\(BYTE\|SHORT\|CHAR\|INT\|LONG\|FLOAT\|DOUBLE\|BOOLEAN\)$'
    if typeArgs != [] | call s:illegal() | endif
    let t = s:bracketsSuffix(s:bracketsOpt(s:basicType()))

  elseif b:token == 'VOID'
    if typeArgs != [] | call s:illegal() | endif
    if s:modeAndEXPR()
      call s:nextToken()
      if b:token == 'DOT'
        let ti = {'tag': 'TYPEIDENT', 'pos': pos, 'typetag': 'void'}	" FIXME
        let t = s:bracketsSuffix(ti)
      else
        return s:illegal(pos)
      endif
    else
      return s:illegal()
    endif

  else
    return s:illegal()
  endif

  if typeArgs != []
    return s:illegal()
  endif

  while 1
    let pos1 = b:pos
    if b:token == 'LBRACKET'
      call s:nextToken()
      if s:modeAndEXPR()
        let oldmode = b:mode
        let b:mode = s:TYPE
        if b:token == 'RBRACKET'
          call s:nextToken()
          let t = s:bracketsOpt(t)
          let t = s:TypeArray(pos1, t)
          return t
        endif
        let b:mode = oldmode
      endif
      if s:modeAndEXPR()
        let b:mode = s:EXPR
        let t = {'tag': 'INDEXED', 'pos': pos1, 'indexed': t, 'index': s:term()}
      endif
      call s:accept('RBRACKET')

    elseif b:token == 'DOT'
      call s:nextToken()
      let typeArgs = s:typeArgumentsOpt(s:EXPR)
      if b:token == 'SUPER' && s:modeAndEXPR()
        let b:mode = s:EXPR
        let t = s:Select(pos1, t, 'super')
        call s:nextToken()
        let t = s:arguments(typeArgs, t)
        let typeArgs = []
      elseif b:token == 'NEW' && s:modeAndEXPR()
        if typeArgs != []
          return s:illegal()
        endif
        let b:mode = s:EXPR
        let pos2 = b:pos
        call s:nextToken()
        if b:token == 'LT'
          let typeArgs = s:typeArguments()
        endif
        let t = s:innerCreator(pos2, typeArgs, t)
        let typeArgs = []
      else
        let t = s:Select(pos1, t, s:ident())
        let t = s:argumentsOpt(typeArgs, s:typeArgumentsOpt2(t))
        let typeArgs = []
      endif
    else
      break
    endif
  endwhile


  while (b:token == 'PLUSPLUS' || b:token == 'SUBSUB') && s:modeAndEXPR()
    let b:mode = s:EXPR
    let t = s:Unary(b:pos, b:token == 'PLUSPLUS' ? 'POSTINC' : 'POSTDEC', t)
    call s:nextToken()
  endwhile
  return t
endfu

fu! s:superSuffix(typeArgs, t)
  let typeArgs = a:typeArgs
  let t = a:t
  call s:nextToken()
  if b:token == 'LPAREN' || typeArgs != []
    let t = s:arguments(typeArgs, t)
  else
    let pos = b:pos
    call s:accept('DOT')
    let typeArgs = b:token == 'LT' ? s:typeArguments() : []
    let t = s:Select(pos, t, s:ident())
    let t = s:argumentsOpt(typeArgs, t)
  endif
  return t
endfu

" BasicType = BYTE | SHORT | CHAR | INT | LONG | FLOAT | DOUBLE | BOOLEAN {{{2
fu! s:basicType()
  let t = {'tag': 'TYPEIDENT', 'pos': b:pos, 'typetag': s:typetag(b:token)}
  call s:nextToken()
  return t
endfu

" ArgumentsOpt = [ Arguments ]						{{{2
fu! s:argumentsOpt(typeArgs, t)
  if s:modeAndEXPR() && b:token == 'LPAREN' || a:typeArgs != []
    let b:mode = s:EXPR
    return s:arguments(a:typeArgs, a:t)
  else
    return a:t
  endif
endfu

" Arguments = "(" [Expression { COMMA Expression }] ")"
fu! s:arguments(...)
  let pos = b:pos
  let args = []
  if b:token == 'LPAREN'
    call s:nextToken()
    if b:token != 'RPAREN'
      let idx = 0
      let arg = s:expression()
      let arg.idx = idx
      call add(args, arg)
      while b:token == 'COMMA'
        let idx += 1
        call s:nextToken()
        let arg = s:expression()
        let arg.idx = idx
        call add(args, arg)
      endwhile
    endif
    call s:accept('RPAREN')
  else
    call s:SyntaxError(') expected')
  endif

  if a:0 == 0
    return args
  else
    let typeArgs = a:1
    let t = a:2
    return {'tag': 'APPLY', 'pos': pos, 'typeargs': typeArgs, 'meth': t, 'args': args}
  endif
endfu

" typeArgument generic type						{{{2
fu! s:typeArgumentsOpt2(t)
  if b:token == 'LT' && s:modeAndTYPE() && s:BitAnd(b:mode, s:NOPARAMS) == 0
    let b:mode = s:TYPE
    " checkGenerics()
    return s:typeArguments(a:t)
  else
    return a:t
  endif
endfu

fu! s:typeArgumentsOpt(...)
  let useMode = a:0 == 0 ? s:TYPE : a:1

  if b:token == 'LT'
    " checkGenerics()
    if s:BitAnd(b:mode, useMode) == 0 || s:BitAnd(b:mode, s:NOPARAMS) != 0
      return s:illegal()
    endif
    let b:mode = useMode
    return s:typeArguments()
  endif
  return []
endfu

" TypeArguments  = "<" TypeArgument {"," TypeArgument} ">"
fu! s:typeArguments(...)
  let pos = b:pos

  let args = []
  if b:token == 'LT'
    call s:nextToken()
    call add(args, s:modeAndEXPR() ? s:type() : s:typeArgument())
    while b:token == 'COMMA'
      call s:nextToken()
      call add(args, s:modeAndEXPR() ? s:type() : s:typeArgument())
    endwhile

    if b:token == 'GTGTGTEQ'
      let b:token = 'GTGTEQ'
    elseif b:token == 'GTGTEQ'
      let b:token = 'GTEQ'
    elseif b:token == 'GTEQ'
      let b:token = 'EQ'
    elseif b:token == 'GTGTGT'
      let b:token = 'GTGT'
    elseif b:token == 'GTGT'
      let b:token = 'GT'
    else
      call s:accept('GT')
    endif
  else
    call s:SyntaxError("LT expected")
  endif

  if a:0 == 0
    return args
  else
    return {'tag': 'TYPEAPPLY', 'pos': pos, 'clazz': a:1, 'arguments': args}
  endif
endfu

" TypeArgument = Type
"              | "?"
"              | "?" EXTENDS Type {"&" Type}
"              | "?" SUPER Type
fu! s:typeArgument()
  if b:token != 'QUES'
    return s:type()
  endif

  call s:nextToken()
  if b:token == 'EXTENDS'
    call s:nextToken()
    return s:type()
  elseif b:token == 'SUPER'
    call s:nextToken()
    return s:type()
  elseif b:token == 'IDENTIFIER'
    let id = ident()
  else
  endif
endfu


" BracketsOpt = {"[" "]"}						{{{2
fu! s:bracketsOpt(t)
  let t = a:t
  while b:token == 'LBRACKET'
    let pos = b:pos
    call s:nextToken()
    let t = s:bracketsOptCont(t, pos)
  endwhile
  return t
endfu

fu! s:bracketsOptCont(t, pos)
  let t = a:t
  call s:accept('RBRACKET')
  let t = s:bracketsOpt(t)
  return s:TypeArray(a:pos, t)
endfu

" BracketsSuffixExpr = "." CLASS
" BracketsSuffixType =
fu! s:bracketsSuffix(t)
  let t = a:t
  if s:modeAndEXPR() && b:token == 'DOT'
    let b:mode = s:EXPR
    let pos = b:pos
    call s:nextToken()
    call s:accept('CLASS')
    if b:pos == b:errorEndPos
      let name = ''
      if b:token == 'IDENTIFIER'
        let name = b:name
        call s:nextToken()
      else
        let name = '<error>'
      endif
      let t = {'tag': 'ERRONEOUS', 'pos': pos, 'errs': [s:Select(pos, t, name)]}
    else
      let t = s:Select(pos, t, 'class')
    endif
  elseif s:modeAndTYPE()
    let b:mode = s:TYPE
  else
    call s:SyntaxError('dot.class.expected')
  endif
  return t
endfu

" creator						{{{2
fu! s:creator(newpos, typeArgs)
  if b:token =~# '^\(BYTE\|SHORT\|CHAR\|INT\|LONG\|FLOAT\|DOUBLE\|BOOLEAN\)$'
    if a:typeArgs == []
      return s:arrayCreatorRest(a:newpos, s:basicType())
    endif
  endif

  let t = s:qualident()
  let oldmode = b:mode
  let b:mode = s:TYPE
  if b:token == 'LT'
    "checkGenerics
    let t = s:typeArguments(t)
  endif
  let b:mode = oldmode

  if b:token == 'LBRACKET'
    return s:arrayCreatorRest(a:newpos, t)
  elseif b:token == 'LPAREN'
    return s:classCreatorRest(a:newpos, {}, a:typeArgs, t)
  else
    call s:ReportSyntaxError(b:pos, '( or [ expected')
    let t = {'tag': 'NEWCLASS', 'encl': {}, 'typeargs': a:typeArgs, 'clazz': t, 'args': [], 'def': {}}
    return {'tag': 'ERRONEOUS', 'pos': a:newpos, 'errs': [t]}
  endif
endfu

fu! s:innerCreator(newpos, typeArgs, encl)
  let t = s:Ident(b:pos, s:ident())
  if b:token == 'LT'
    " checkGenerics
    let t = s:typeArguments(t)
  endif
  return s:classCreatorRest(a:newpos, a:encl, a:typeArgs, t)
endfu

fu! s:arrayCreatorRest(newpos, elemtype)
  let elemtype = a:elemtype
  call s:accept('LBRACKET')
  if b:token == 'RBRACKET'
    call s:accept('RBRACKET')
    let elemtype = s:bracketsOpt(elemtype)
    if b:token == 'LBRACE'
      return s:arrayInitializer(a:newpos, elemtype)
    else
      return s:SyntaxError('array.dimension.missing')
    endif
  else
    let dims = [s:expression()]
    call s:accept('RBRACKET')
    while b:token == 'LBRACKET'
      let pos = b:pos
      call s:nextToken()
      if b:token == 'RBRACKET'
        let elemtype = s:bracketsOptCont(elemtype, pos)
      else
        call add(dims, s:expression())
        call s:accept('RBRACKET')
      endif
    endwhile
    return {'tag': 'NEWARRAY', 'pos': a:newpos, 'elemtype': elemtype, 'dims': dims, 'elems': {}}
  endif
endfu

fu! s:classCreatorRest(newpos, encl, typeArgs, t)
  let args = s:arguments()
  let body = {}
  if b:token == 'LBRACE'
    let body = s:ClassDef(b:pos, {})
    let body.defs = s:classOrInterfaceBody('', 0)
    let body.endpos = b:pos
  endif
  return {'tag': 'NEWCLASS', 'encl': a:encl, 'typeargs': a:typeArgs, 'clazz': a:t, 'args': args, 'def': body}
endfu

" ArrayInitializer = "{" [VariableInitializer {"," VariableInitializer}] [","] "}" {{{2
fu! s:arrayInitializer(newpos, t)
  call s:accept('LBRACE')
  let elems = []
  if b:token == 'COMMA'
    call s:nextToken()
  elseif b:token != 'RBRACE'
    call add(elems, s:variableInitializer())
    while b:token == 'COMMA'
      call s:nextToken()
      if b:token == 'RBRACE'
        break
      endif
      call add(elems, s:variableInitializer())
    endwhile
  endif
  call s:accept('RBRACE')
  return {'tag': 'NEWARRAY', 'pos': a:newpos, 'elemtype': a:t, 'dims': [], 'elems': elems}
endfu

" VariableInitializer = ArrayInitializer | Expression			{{{2
fu! s:variableInitializer()
  return b:token == 'LBRACE' ? s:arrayInitializer(b:pos, {}) : s:expression()
endfu

" ParExpression = "(" Expression ")"					{{{2
fu! s:parExpression()
  call s:accept('LPAREN')
  let t = s:expression()
  call s:accept('RPAREN')
  return t
endfu

" 									{{{2
" Block = "{" BlockStatements "}"					{{{2
fu! s:block(...)
  let t = {'tag': 'BLOCK', 'stats': []}
  let t.pos	= a:0 > 0 ? a:1 : b:pos
  let t.flags	= a:0 > 1 ? a:2 : 0

  call s:accept('LBRACE')

  " scan strategy: ignore statements?
  if a:0 > 2 && a:3
    if b:token !=# 'RBRACE'
      let b:pos = s:gotoMatchEnd('{', '}', b:token == 'LBRACE')
    endif
    "let t.stats = Strpart(t.pos, t.endpos-t.pos-1)
  else
    let t.stats = s:blockStatements()
    while b:token == 'CASE' || b:token == 'DEFAULT'
      call s:SyntaxError("orphaned")
      call s:switchBlockStatementGroups()
    endwhile
  endif

  let t.endpos = b:pos
  call s:accept('RBRACE')
  return t
endfu

" BlockStatements = { BlockStatement }					{{{2
" BlockStatement  = LocalVariableDeclarationStatement
"                 | ClassOrInterfaceOrEnumDeclaration
"                 | [Ident ":"] Statement
" LocalVariableDeclarationStatement
"                 = { FINAL | '@' Annotation } Type VariableDeclarators ";"
fu! s:blockStatements()
  let lastErrPos = -1
  let stats = []
  while 1
    let pos = b:pos
    if b:token =~# '^\(RBRACE\|CASE\|DEFAULT\|EOF\)$'
      return stats
    elseif b:token =~# '^\(LBRACE\|IF\|FOR\|WHILE\|DO\|TRY\|SWITCH\|SYNCHRONIZED\|RETURN\|THROW\|BREAK\|CONTINUE\|SEMI\|ELSE\|FINALLY\|CATCH\)$'
      call add(stats, s:statement())
    elseif b:token =~# '^\(MONKEYS_AT\|FINAL\)'
      let dc = b:docComment
      let mods = s:modifiersOpt()
      if b:token =~# '^\(INTERFACE\|CLASS\|ENUM\)$'
        call add(stats, s:classOrInterfaceOrEnumDeclaration(mods, dc))
      else
        let t = s:type()
        let stats = stats + s:variableDeclarators(mods, t, [])
        call s:accept('SEMI')
      endif
    elseif b:token =~# '^\(ABSTRACT\|STRICTFP\|CLASS\|INTERFACE\|ENUM\)$'
      if b:token == 'ENUM'
        call s:Log(4, b:pos, 'local.enum')
      endif
      call add(stats, s:classOrInterfaceOrEnumDeclaration(s:modifiersOpt(), b:docComment))
    elseif b:token == 'ASSERT'
      call add(stats, s:statement())
    else
      let name = b:name
      let t = s:term(s:EXPR_OR_TYPE)
      if b:token == 'COLON' && t.tag == 'IDENT'
        call s:nextToken()
        let stat = s:statement()
        call add(stats, {'tag': 'LABELLED', 'pos': b:pos, 'label': name, 'body': stat})
      elseif s:BitAnd(b:lastmode, s:TYPE) && b:token =~# '^\(IDENTIFIER\|ASSERT\|ENUM\)$'
        let pos = b:pos
        let mods = {}		" {'tag': 'MODIFIERS', 'pos': -1, 'flags': 0}
        let stats = stats + s:variableDeclarators(mods, t, [])
        call s:accept('SEMI')
      else
        call add(stats, {'tag': 'EXEC', 'pos': pos, 'expr': s:checkExprStat(t)})	" TODO
        call s:accept('SEMI')
      endif
    endif

    if b:pos == lastErrPos
      return stats
    endif
    if b:pos <= b:errorEndPos
      call s:skip(0, 1, 1, 1)
      let lastErrPos = b:pos
    endif

    " resetDeprecatedFlag()
  endwhile
endfu

" Statement = Block							{{{2
"    | IF ParExpression Statement [ELSE Statement]
"    | FOR "(" ForInitOpt ";" [Expression] ";" ForUpdateOpt ")" Statement
"    | FOR "(" FormalParameter : Expression ")" Statement
"    | WHILE ParExpression Statement
"    | DO Statement WHILE ParExpression ";"
"    | TRY Block ( Catches | [Catches] FinallyPart )
"    | SWITCH ParExpression "{" SwitchBlockStatementGroups "}"
"    | SYNCHRONIZED ParExpression Block
"    | RETURN [Expression] ";"
"    | THROW Expression ";"
"    | BREAK [Ident] ";"
"    | CONTINUE [Ident] ";"
"    | ASSERT Expression [ ":" Expression ] ";"
"    | ";"
"    | ExpressionStatement
"    | Ident ":" Statement
" called only by BlockStatements or self
fu! s:statement()
  let pos = b:pos
  if b:token == 'LBRACE'
    return s:block()
  elseif b:token == 'IF'
    call s:nextToken()
    let t = {'tag': 'IF', 'pos': pos, 'cond': s:parExpression(), 'thenpart': s:statement()}
    if b:token == 'ELSE'
      call s:nextToken()
      let t.elsepart = s:statement()
    endif
    let t.endpos = b:pos
    return t

  elseif b:token == 'FOR'
    call s:nextToken()
    call s:accept('LPAREN')
    let inits = b:token == 'SEMI' ? [] : s:forInit()
    " foreach
    if len(inits) == 1 && inits[0].tag == 'VARDEF' && (!has_key(inits[0], 'init') || inits[0].init == {}) && b:token == 'COLON'
      " checkForeach
      let var = inits[0]
      call s:accept('COLON')
      let expr = s:expression()
      call s:accept('RPAREN')
      let body = s:statement()
      return {'tag': 'FOREACHLOOP', 'pos': pos, 'endpos': b:pos, 'var': var, 'expr': expr, 'body': body}
    else
      call s:accept('SEMI')
      let cond = b:token == 'SEMI' ? {} : s:expression()
      call s:accept('SEMI')
      let steps = b:token == 'RPAREN' ? [] : s:forUpdate()
      call s:accept('RPAREN')
      let body = s:statement()
      return {'tag': 'FORLOOP', 'pos': pos, 'endpos': b:pos, 'init': inits, 'cond': cond, 'step': steps, 'body': body}
    endif

  elseif b:token == 'WHILE'
    call s:nextToken()
    let cond = s:parExpression()
    let body = s:statement()
    return {'tag': 'WHILELOOP', 'pos': pos, 'endpos': b:pos, 'cond': cond, 'body': body}

  elseif b:token == 'DO'
    call s:nextToken()
    let body = s:statement()
    call s:accept('WHILE')
    let cond = s:parExpression()
    let t = {'tag': 'DOLOOP', 'pos': pos, 'endpos': b:pos, 'cond': cond, 'body': body}
    call s:accept('SEMI')
    return t

  elseif b:token == 'TRY'
    call s:nextToken()
    let params = s:formalParameters()
    let body = s:block()
    let catchers = []
    let finalizer = {}
    if b:token == 'CATCH' || b:token == 'FINALLY'
      while b:token == 'CATCH'
        call add(catchers, s:catchClause())
      endwhile
      if b:token == 'FINALLY'
        call s:nextToken()
        let finalizer = s:block()
      endif
    else
      call s:Log(4, b:pos, 'try.without.catch.or.finally')
    endif
    return {'tag': 'TRY', 'pos': pos, 'endpos': b:pos, 'params': params, 'body': body, 'catchers': catchers, 'finalizer': finalizer}

  elseif b:token == 'RARROW'
    let body = s:block()
    let params = ''
    return {'tag': 'RARROW', 'pos': pos, 'endpos': b:pos, 'params': params, 'body': body}

  elseif b:token == 'SWITCH'
    call s:nextToken()
    let selector = s:parExpression()
    call s:accept('LBRACE')
    let cases = s:switchBlockStatementGroups()
    call s:accept('RBRACE')
    return {'tag': 'SWITCH', 'pos': pos, 'endpos': b:pos, 'selector': selector, 'cases': cases}

  elseif b:token == 'SYNCHRONIZED'
    call s:nextToken()
    let lock = s:parExpression()
    let body = s:block()
    return {'tag': 'SYNCHRONIZED', 'pos': pos, 'endpos': b:pos, 'lock': lock, 'body': body}

  elseif b:token == 'RETURN'
    call s:nextToken()
    let result = b:token == 'SEMI' ? {} : s:expression()
    call s:accept('SEMI')
    return {'tag': 'RETURN', 'pos': pos, 'endpos': b:pos, 'expr': result}

  elseif b:token == 'THROW'
    call s:nextToken()
    let exc = s:expression()
    call s:accept('SEMI')
    return {'tag': 'THROW', 'pos': pos, 'endpos': b:pos, 'expr': exc}

  elseif b:token == 'BREAK' || b:token == 'CONTINUE'
    let token = b:token
    call s:nextToken()
    let label = b:token =~# '^\(IDENTIFIER\|ASSERT\|ENUM\)$' ? s:ident() : ''
    call s:accept('SEMI')
    return {'tag': token, 'pos': pos, 'endpos': b:pos, 'label': label}

  elseif b:token == 'SEMI'
    call s:nextToken()
    return {'tag': 'SKIP', 'pos': pos}

  elseif b:token == 'ELSE'
    return s:SyntaxError("else.without.if")
  elseif b:token == 'FINALLY'
    return s:SyntaxError("finally.without.try")
  elseif b:token == 'CATCH'
    return s:SyntaxError("catch.without.try")

  elseif b:token == 'ASSERT'
    "if b:allowAsserts && b:token == 'ASSERT'
    call s:nextToken()
    let t = {'tag': 'ASSERT', 'pos': pos, 'cond': s:expression()}
    if b:token == 'COLON'
      call s:nextToken()
      let t.detail = s:expression()
    endif
    call s:accept('SEMI')
    let t.endpos = b:pos
    return t
    "endif

  else	" also ENUM
    let name = b:name
    let expr = s:expression()
    if b:token == 'COLON' && expr.tag == 'IDENT'
      call s:nextToken()
      let stat = s:statement()
      return {'tag': 'LABELLED', 'pos': pos, 'endpos': b:pos, 'label': name, 'body': stat}
    else
      let stat = {'tag': 'EXEC', 'pos': pos, 'endpos': b:pos, 'expr': s:checkExprStat(expr)}
      call s:accept('SEMI')
      return stat
    endif
  endif
endfu

" CatchClause	= CATCH "(" FormalParameter ")" Block
fu! s:catchClause()
  let pos = b:pos
  call s:accept('CATCH')
  call s:accept('LPAREN')
  let formal = s:variableDeclaratorId(s:optFinalParameter(), s:qualident())
  call s:accept('RPAREN')
  let body = s:block()
  return {'tag': 'CATCH', 'pos': pos, 'endpos': b:pos, 'param': formal, 'body': body}
endfu

" SwitchBlockStatementGroups = { SwitchBlockStatementGroup }
" SwitchBlockStatementGroup = SwitchLabel BlockStatements
" SwitchLabel = CASE ConstantExpression ":" | DEFAULT ":"
fu! s:switchBlockStatementGroups()
  let cases = []
  while 1
    let pos = b:pos
    if b:token == 'CASE' || b:token == 'DEFAULT'
      let token = b:token
      call s:nextToken()
      let pat = token == 'CASE' ? s:expression() : {}
      call s:accept('COLON')
      let stats = s:blockStatements()
      call add(cases, {'tag': 'CASE', 'pos': pos, 'pat': pat, 'stats': stats})
    elseif b:token == 'RBRACE' || b:token == 'EOF' 
      return cases
    else
      call s:nextToken()
      call s:SyntaxError('case.default.rbrace.expected')
    endif
  endwhile
endfu

" MoreStatementExpressions = { COMMA StatementExpression }
fu! s:moreStatementExpressions(pos, first, stats)
  call add(a:stats, {'tag': 'EXEC', 'pos': a:pos, 'expr': s:checkExprStat(a:first)})
  while b:token == 'COMMA'
    call s:nextToken()
    let pos = b:pos
    let t = s:expression()
    call add(a:stats, {'tag': 'EXEC', 'pos': pos, 'expr': s:checkExprStat(t)})
  endwhile
  return a:stats
endfu

" ForInit = StatementExpression MoreStatementExpressions
"          |  { FINAL | '@' Annotation } Type VariableDeclarators
fu! s:forInit()
  let stats = []
  let pos = b:pos
  if b:token == 'FINAL' || b:token == 'MONKEYS_AT'
    return s:variableDeclarators(s:optFinal(0), s:type(), stats)
  else
    let t = s:term(s:EXPR_OR_TYPE)
    if s:BitAnd(b:lastmode, s:TYPE) && b:token =~# '^\(IDENTIFIER\|ASSERT\|ENUM\)$'
      return s:variableDeclarators(s:modifiersOpt(), t, stats)
    else
      return s:moreStatementExpressions(pos, t, stats)
    endif
  endif
endfu

" ForUpdate = StatementExpression MoreStatementExpressions
fu! s:forUpdate()
  return s:moreStatementExpressions(b:pos, s:expression(), [])
endfu

" ModifiersOpt = { Modifier }						{{{2
"  Modifier = PUBLIC | PROTECTED | PRIVATE | STATIC | ABSTRACT | FINAL
"		| NATIVE | SYNCHRONIZED | TRANSIENT | VOLATILE | "@"
"		| "@" Annotation
" NOTE: flags is a string, not a long number
fu! s:modifiersOpt(...)
  let partial = a:0 == 0 ? {} : a:1

  let flags = partial == {} ? 0 : partial.flags
  let annotations = partial == {} ? [] : partial.annotations
  " TODO: deprecatedFlag

  let pos = b:pos
  let lastPos = -1
  while 1
    let flag = 0
    if b:token =~# '^\(PUBLIC\|PROTECTED\|PRIVATE\|STATIC\|ABSTRACT\|FINAL\|NATIVE\|SYNCHRONIZED\|TRANSIENT\|VOLATILE\|STRICTFP\|MONKEYS_AT\)$'
      let flag = b:token == 'MONKEYS_AT' ? s:Flags.ANNOTATION : get(s:Flags, b:token, 0)
    else
      break
    endif
    "if s:BitAnd(flags, flag) != 0
    "  "log.error(S.pos(), "repeated.modifier")
    "endif

    let lastPos = b:pos
    call s:nextToken()

    if flag == s:Flags.ANNOTATION
      "call s:checkAnnotations()
      if b:token != 'INTERFACE'
        let ann = s:annotation(lastPos)
        if flags == 0 && annotations == []
          let pos = ann.pos
        endif
        call add(annotations, ann)
        let lastPos = ann.pos
        let flag = 0
      endif
    endif
    let flags = s:BitOr(flags, flag)
  endwhile

  if b:token == 'ENUM'
    let flags = s:BitOr(flags, s:Flags.ENUM)
  elseif b:token == 'INTERFACE'
    let flags = s:BitOr(flags, s:Flags.INTERFACE)
  endif

  if flags == 0 && empty(annotations)
    let pos = -1
  endif

  return {'tag': 'MODIFIERS', 'pos': pos, 'flags': flags, 'annotations': annotations}
endfu

" Annotation = "@" Qualident [ "(" AnnotationFieldValues ")" ] 		{{{2
fu! s:annotation(pos)
  "call s:checkAnnotations()
  let ident = s:qualident()
  "let endPos = b:prevEndPos
  let fieldValues = s:annotationFieldValuesOpt()

  return {'tag': 'ANNOTATION', 'pos': a:pos, 'annotationType': ident, 'args': fieldValues}
endfu

fu! s:annotationFieldValuesOpt()
  return b:token == 'LPAREN' ? s:annotationFieldValues() : []
endfu

" AnnotationFieldValues	= "(" [ AnnotationFieldValue { "," AnnotationFieldValue } ] ")"
fu! s:annotationFieldValues()
  let buf = []
  call s:accept('LPAREN')
  if b:token != 'RPAREN'
    call add(buf, s:annotationFieldValue())
    while b:token == 'COMMA'
      call s:nextToken()
      call add(buf, s:annotationFieldValue())
    endwhile
  endif
  call s:accept('RPAREN')
  return buf
endfu

" AnnotationFieldValue	= AnnotationValue | Identifier "=" AnnotationValue
fu! s:annotationFieldValue()
  call s:Trace('s:annotationFieldValue ' . b:token)
  if b:token == 'IDENTIFIER'
    let b:mode = s:EXPR
    let t1 = s:term1()
    if t1.tag == 'IDENT' && b:token == 'EQ'
      let pos = b:pos
      call s:accept('EQ')
      return {'tag': 'ASSIGN', 'pos': pos, 'lhs': t1, 'rhs': s:annotationValue()}
    else
      return t1
    endif
  endif
  return s:annotationValue()
endfu

" AnnotationValue = ConditionalExpression | Annotation 	| "{" [ AnnotationValue { "," AnnotationValue } ] "}"
fu! s:annotationValue()
  let pos = 0
  if b:token == 'MONKEYS_AT'
    let pos = b:bp
    call s:nextToken()
    return s:annotation(pos)
  elseif b:token == 'LBRACE'
    let pos = b:pos
    call s:accept('LBRACE')
    let buf = []
    if b:token != 'RBRACE'
      call add(buf, s:annotationValue())
      while b:token == 'COMMA'
        call s:nextToken()
        if b:token == 'RPAREN'
          break
        endif
        call add(buf, s:annotationValue())
      endwhile
    endif
    call s:accept('RBRACE')
    return buf
  else
    let b:mode = s:EXPR
    return s:term1()
  endif
endfu

" AnnotationsOpt = { '@' Annotation }
fu! s:annotationsOpt()
  if b:token != 'MONKEYS_AT'
    return []
  endif

  let buf = []
  while b:token != 'MONKEYS_AT'
    let pos = b:pos
    call s:nextToken()
    call add(buf, s:annotation(pos))
  endwhile
  return buf
endfu

" 									{{{2
" CompilationUnit							{{{2
" CompilationUnit = [ { "@" Annotation } PACKAGE Qualident ";"] {ImportDeclaration} {TypeDeclaration}
fu! s:compilationUnit()
  let unit = {'tag': 'TOPLEVEL', 'pos': b:pos}

  let mods = {}
  if b:token == 'MONKEYS_AT'
    let mods = s:modifiersOpt()
  endif

  if b:token == 'PACKAGE'
    if mods != {}
      " checkNoMods(mods.flags)
      let unit.packageAnnotations = mods.annotations
      let mods = {}
    endif
    call s:nextToken()
    let unit.pid = s:qualident()
    let unit.package = java_parser#type2Str(unit.pid)
    call s:accept('SEMI')
  endif

  let imports = []
  let s:types = []
  let checkForImports = 1
  while b:token != 'EOF'
    if b:pos <= b:errorEndPos
      call s:skip(checkForImports, 0, 0, 0)
      if b:token == 'EOF'
        break
      endif
    endif
    if checkForImports && mods == {} && b:token == 'IMPORT'
      call add(imports, s:importDeclaration())
    else
      let def = s:typeDeclaration(mods)
      "if (def instanceof JCExpressionStatement)
      "  def = ((JCExpressionStatement)def).expr
      "endif
      call add(s:types, def)
      if def.tag == 'CLASSDEF'
        let checkForImports = 0
      endif
      let mods = {}
    endif
  endwhile
  let unit.imports = imports
  let unit.types = s:types
  unlet s:types

  return unit
endfu

" ImportDeclaration = IMPORT [ STATIC ] Ident { "." Ident } [ "." "*" ] ";"	{{{2
" return fqn
fu! s:importDeclaration()
  " OAO: Usualy it is in one line.
  " if b:scanStrategy < 0
  "   let idx = matchend(b:lines[b:line], '\(\s\+static\>\)\?\s\+\([_$a-zA-Z][_$a-zA-Z0-9_]*\)\(\s*\.\s*[_$a-zA-Z][_$a-zA-Z0-9_]*\)*\(\s*\.\s*\*\)\?;')
  "   if idx != -1
  "     let fqn = strpart(b:lines[b:line], b:col, idx-b:col-1)
  "     let b:col = idx
  "     let b:bp = b:idxes[b:line] + b:col
  "     call s:nextToken()
  "     return fqn
  "   endif
  " endif


  call s:Info('==import==')
  let pos = b:pos
  call s:nextToken()

  let importStatic = 0
  if b:token == 'STATIC'
    " checkStaticImports()
    let importStatic = 1
    call s:nextToken()
  endif

  let pid = s:Ident(b:pos, s:ident())

  " 
  let pos1 = b:pos
  call s:accept('DOT')
  if b:token == 'STAR'
    let pid = s:Select(pos1, pid, '*')
    call s:nextToken()
  else
    let pid = s:Select(pos1, pid, s:ident())
  endif
  while b:token == 'DOT'
    let pos1 = b:pos
    call s:accept('DOT')
    if b:token == 'STAR'
      let pid = s:Select(pos1, pid, '*')
      call s:nextToken()
      break
    else
      let pid = s:Select(pos1, pid, s:ident())
    endif
  endwhile
  let fqn = java_parser#type2Str(pid)
  if b:token != 'SEMI'
    let fqn .= '<SEMI expected>'
  endif
  call s:accept('SEMI')
  "return {'tag': 'IMPORT', 'pos': b:pos, 'qualid': pid, 'staticImport': importStatic}
  return fqn
endfu

" TypeDeclaration = ClassOrInterfaceOrEnumDeclaration | ";"	{{{2
fu! s:typeDeclaration(mods)
  let pos = b:pos
  if a:mods == {} && b:token == 'SEMI'
    call s:nextToken()
    return {'tag': 'SKIP', 'pos': pos}
  else
    let dc = b:docComment
    let mods = s:modifiersOpt(a:mods)
    return s:classOrInterfaceOrEnumDeclaration(mods, dc)
  endif
endfu

fu! s:classOrInterfaceOrEnumDeclaration(mods, dc)
  call s:Info('== type ==')
  if b:token == 'CLASS'
    return s:classDeclaration(a:mods, a:dc)
  elseif b:token == 'INTERFACE'
    return s:interfaceDeclaration(a:mods, a:dc)
  elseif b:token == 'ENUM'
    "if !exists('b:allowEnums') || !b:allowEnums
    "  call s:SyntaxError("enums.not.supported.in.source")
    "endif
    return s:enumDeclaration(a:mods, a:dc)
  else
    let pos = b:pos
    let errs = []
    if b:token == 'IDENTIFIER'
      call add(errs, s:ident())
      call s:setErrorEndPos(b:bp)
    endif
    return s:SyntaxError("class.or.intf.or.enum.expected", pos, errs)
  endif
endfu

" ClassDeclaration = CLASS Ident TypeParametersOpt [EXTENDS Type] [IMPLEMENTS TypeList] ClassBody	{{{2
fu! s:classDeclaration(mods, dc)
  let type = s:ClassDef(b:pos, a:mods)

  call s:accept('CLASS')
  let type.name = s:ident()

  let type.typarams = s:typeParametersOpt()

  " extends
  if b:token == 'EXTENDS'
    call s:nextToken()
    let type.extends = [s:type()]
  endif

  " implements
  if b:token == 'IMPLEMENTS'
    call s:nextToken()
    let type.implements = s:typeList()
  endif

  let type.defs = s:classOrInterfaceBody(type.name, 0)
  let type.endpos = b:pos
  return type
endfu

" InterfaceDeclaration = INTERFACE Ident TypeParametersOpt [EXTENDS TypeList] InterfaceBody	{{{2
fu! s:interfaceDeclaration(mods, dc)
  let type = s:ClassDef(b:pos, a:mods)

  call s:accept('INTERFACE')
  let type.name = s:ident()

  let type.typarams = s:typeParametersOpt()

  " extends
  if b:token == 'EXTENDS'
    call s:nextToken()
    let type.extends = s:typeList()
  endif

  let type.defs = s:classOrInterfaceBody(type.name, 1)
  let type.endpos = b:pos
  return type
endfu

" EnumDeclaration = ENUM Ident [IMPLEMENTS TypeList] EnumBody		{{{2
fu! s:enumDeclaration(mods, dc)
  let type = s:ClassDef(b:pos, a:mods)

  call s:accept('ENUM')
  let type.name = s:ident()

  if b:token == 'IMPLEMENTS'
    call s:nextToken()
    let type.implements = s:typeList()
  endif

  let type.defs = s:enumBody(type.name)
  let type.endpos = b:pos
  return type
endfu

" EnumBody = "{" { EnumeratorDeclarationList } [","]
" 		[ ";" {ClassBodyDeclaration} ] "}"
fu! s:enumBody(enumName)
  let defs = []
  call s:accept('LBRACE')

  if b:token == 'COMMA'
    call s:nextToken()
  elseif b:token != 'RBRACE' && b:token != 'SEMI'
    call add(defs, s:enumeratorDeclaration(a:enumName))
    while b:token == 'COMMA'
      call s:nextToken()
      if b:token == 'RBRACE' || b:token == 'SEMI'
        break
      endif
      call add(defs, s:enumeratorDeclaration(a:enumName))
    endwhile
    if b:token != 'RBRACE' && b:token != 'SEMI'
      call s:SyntaxError('comma.or.rbrace.or.semi. expected')
      call s:nextToken()
    endif
  endif

  if b:token == 'SEMI'
    call s:nextToken()
    while b:token != 'RBRACE' && b:token != 'EOF'
      call add(defs, s:classOrInterfaceBodyDeclaration(a:enumName, 0))
      if b:pos <= b:errorEndPos
        call s:skip(0, 1, 1, 0)
      endif
    endwhile
  endif

  call s:accept('RBRACE')
  return defs
endfu

" EnumeratorDeclaration = AnnotationsOpt [TypeArguments] IDENTIFIER [ Arguments ] [ "{" ClassBody "}" ]
fu! s:enumeratorDeclaration(enumName)
  let vardef = {'tag': 'VARDEF', 'pos': b:pos}

  let dc = b:docComment
  let flags = 16409		" s:BitOr(s:Flags.PUBLIC, s:Flags.STATIC, s:Flags.FINAL, s:Flags.ENUM)
  " if b:deprecatedFlag
  "   let flags = 147481	" s:BitOr(flags, s:Flags.DEPRECATED)
  "   let b:deprecatedFlag = 1
  " endif
  let pos = b:pos
  let annotations = s:annotationsOpt()
  let vardef.mods = s:Modifiers(pos, flags, annotations)
  let vardef.mods.pos = empty(annotations) ? -1 : pos
  let vardef.m = s:Number2Bits(flags)

  let typeArgs = s:typeArgumentsOpt()
  let identPos = b:pos
  let vardef.name = s:ident()
  let vardef.n = vardef.name

  let args = b:token == 'LPAREN' ? s:arguments() : []

  " NOTE: It may be either a class body or a method body. I dont care, just record it
  if b:token == 'LBRACE'
    "call s:accept('LBRACE')
    "if b:token !=# 'RBRACE'
    "  call s:gotoMatchEnd('{', '}')
    "endif
    "call s:accept('RBRACE')

    "let mods1 = s:Modifiers(-1, s:BitOr(s:Flags.ENUM, s:Flags.STATIC), [])
    let defs = s:classOrInterfaceBody('', 0)
    "let body = s:ClassDef(identPos, mods1)
    "let body.defs = defs
  endif
  let vardef.endpos = b:bp

  " TODO: create new class

  return vardef
endfu

" classOrInterfaceBody						{{{2
" ClassBody     = "{" {ClassBodyDeclaration} "}"
" InterfaceBody = "{" {InterfaceBodyDeclaration} "}"
fu! s:classOrInterfaceBody(classname, isInterface)
  call s:Info('== type definition body ==')
  call s:accept('LBRACE')

  if b:pos <= b:errorEndPos
    call s:skip(0, 1, 0, 0)
    if b:token == 'LBRACE'
      call s:nextToken()
    endif
  endif

  let defs = []
  while b:token != 'RBRACE' && b:token != 'EOF'
    let defs += s:classOrInterfaceBodyDeclaration(a:classname, a:isInterface)

    if b:pos <= b:errorEndPos
      call s:skip(0, 1, 1, 0)
    endif
  endwhile
  call s:accept('RBRACE')
  return defs
endfu

" classOrInterfaceBodyDeclaration					{{{2
" ClassBodyDeclaration =
"     ";"
"   | [STATIC] Block
"   | ModifiersOpt
"     ( Type Ident
"       ( VariableDeclaratorsRest ";" | MethodDeclaratorRest )
"     | VOID Ident MethodDeclaratorRest
"     | TypeParameters (Type | VOID) Ident MethodDeclaratorRest
"     | Ident ConstructorDeclaratorRest
"     | TypeParameters Ident ConstructorDeclaratorRest
"     | ClassOrInterfaceOrEnumDeclaration
"     )
" InterfaceBodyDeclaration =
"     ";"
"   | ModifiersOpt Type Ident
"     ( ConstantDeclaratorsRest | InterfaceMethodDeclaratorRest ";" )
fu! s:classOrInterfaceBodyDeclaration(classname, isInterface)
  call s:Info('s:classOrInterfaceBodyDeclaration')
  if b:token == 'SEMI'
    call s:nextToken()
    return [{'tag': 'BLOCK', 'pos': -1, 'endpos': -1, 'stats': []}]
  else
    if b:scanStrategy < 0
      let result = s:classOrInterfaceBodyDeclaration_opt(a:classname, a:isInterface)
      if !empty(result)
        return result
      endif
    endif


    let dc = b:docComment
    let pos = b:bp
    let mods = s:modifiersOpt()

    if b:token =~# '^\(CLASS\|INTERFACE\|ENUM\)$'
      return [s:classOrInterfaceOrEnumDeclaration(mods, dc)]

      " [STATIC] block
    elseif b:token == 'LBRACE' && !a:isInterface
      return [s:block(pos, mods.flags, b:scanStrategy < 1)]

    else
      let typarams = s:typeParametersOpt()

      let token = b:token
      let name = b:name

      let type = copy(s:TTree)
      let isVoid = b:token == 'VOID'
      if isVoid
        let type = {'tag': 'TYPEIDENT', 'pos': pos, 'typetag': 'void'}	" FIXME
        let type.value = ''
        call s:nextToken()
      else
        let time = reltime()
        let type = s:type()
        let b:et_perf .= "\r" . reltimestr(reltime(time)) . ' s:type() '
      endif


      " ctor
      if b:token == 'LPAREN' && !a:isInterface && type.tag == 'IDENT'
        if a:isInterface || name != a:classname 
          call s:SyntaxError('invalid.meth.decl.ret.type.req')
        endif
        return [s:methodDeclaratorRest(pos, mods, type, name, typarams, a:isInterface, 1, dc)]
      else
        let name = s:ident()
        " method
        if b:token == 'LPAREN'
          return [s:methodDeclaratorRest(pos, mods, type, name, typarams, a:isInterface, isVoid, dc)]
          " field
        elseif !isVoid && len(typarams) == 0
          let defs = s:variableDeclaratorsRest(pos, mods, type, name, a:isInterface, dc, copy([]))
          call s:accept('SEMI')
          return defs
        else
          call s:SyntaxError("LPAREN expected")
          return [{}]
        endif
      endif
    endif
  endif
endfu

" OAO: short way for common declaration of field or method, not for generic type yet.
fu! s:classOrInterfaceBodyDeclaration_opt(classname, isInterface)
  let str = b:lines[b:line]
  let idx = matchend(str, s:RE_MEMBER_HEADER)
  if idx != -1
    let subs = split(substitute(strpart(str, 0, idx), s:RE_MEMBER_HEADER, '\1;\2;\3', ''), ';')
    let name_ = subs[2]
    let type_ = subs[1]
    let flag_ = s:String2Flags(subs[0])

    "      if type_ =~# '^\(class\|interface\|enum\)$'
    "	 return [s:classOrInterfaceOrEnumDeclaration(mods, dc)]
    "      else
    " methodDeclarator
    let idx = matchend(str, '^\s*[,=;(]', idx)-1
    if str[idx] == '('
      let methoddef = s:methodDeclaratorRest_opt(b:pos, flag_, type_, name_, [], a:isInterface, type_ == 'void', '', str, idx)
      if !empty(methoddef)
        return [methoddef]
      endif

      " variableDeclarator
    elseif str[idx] =~ '[=;]'
      let vardef = {'tag': 'VARDEF', 'pos': b:pos, 'name': name_, 'n': name_, 'vartype': type_, 't': type_, 'm': flag_}
      call s:gotoSemi()
      call s:accept('SEMI')
      let vardef.pos_end = b:pos
      return [vardef]

      " variableDeclarators
    elseif str[idx] == ','
      let ie = matchend(str, '^\(,\s*'. s:RE_IDENTIFIER .'\s*\)*;', idx)
      if ie != -1
        let vardef = {'tag': 'VARDEF', 'pos': b:pos, 'name': name_, 'n': name_, 'vartype': type_, 't': type_, 'm': flag_}
        let vars = [vardef]
        for item in split(substitute(strpart(str, idx+1, ie-idx-2), '\s', '', 'g'), ',')
          let vardef = copy(vardef)
          let vardef.name = item
          let vardef.n = item
          call add(vars, vardef)
        endfor
        let b:col = ie
        let b:bp = b:idxes[b:line] + b:col
        call s:nextToken()
        return vars
      endif
    endif
    "      endif
  endif

  let RE_CTOR_HEADER = '^\s*\(\(public\|protected\|private\)\s\+\)\=\C' .a:classname. '\s*('
  let ie = matchend(str, RE_CTOR_HEADER)
  if ie != -1 && !a:isInterface
    let flag_ = s:String2Flags(substitute(strpart(str, 0, ie), RE_CTOR_HEADER, '\1', ''))
    let methoddef = s:methodDeclaratorRest_opt(b:pos, flag_, a:classname, a:classname, [], a:isInterface, 1, '', str, ie-1)
    if !empty(methoddef)
      return [methoddef]
    endif
  endif

  let RE_METHOD_HEADER = '^\s*\(' .s:RE_IDENTIFIER. '\%(\s*\.\s*' .s:RE_IDENTIFIER. '\)*\%(\s*\[\s*\]\)\=\)\s\+\(' .s:RE_IDENTIFIER. '\)\s*('
  let ie = matchend(str, RE_METHOD_HEADER)
  if ie != -1
    let subs = split(substitute(strpart(str, 0, ie), RE_METHOD_HEADER, '\1;\2', ''), ';')
    let methoddef = s:methodDeclaratorRest_opt(b:pos, 0, subs[0], subs[1], [], a:isInterface, subs[0] == 'void', '', str, ie-1)
    if !empty(methoddef)
      return [methoddef]
    endif
  endif
endfu


" MethodDeclaratorRest =						{{{2
"	FormalParameters BracketsOpt [Throws TypeList] ( MethodBody | [DEFAULT AnnotationValue] ";")
" VoidMethodDeclaratorRest = FormalParameters [Throws TypeList] ( MethodBody | ";")
" InterfaceMethodDeclaratorRest = FormalParameters BracketsOpt [THROWS TypeList] ";"
" VoidInterfaceMethodDeclaratorRest = FormalParameters [THROWS TypeList] ";"
" ConstructorDeclaratorRest = "(" FormalParameterListOpt ")" [THROWS TypeList] MethodBody
fu! s:methodDeclaratorRest(pos, mods, type, name, typarams, isInterface, isVoid, dc)
  let time = reltime()
  let methoddef = {'tag': 'METHODDEF', 'pos': a:pos, 'name': a:name, 'mods': a:mods, 'restype': a:type, 'typarams': a:typarams}
  let methoddef.n = a:name
  let methoddef.m = s:Number2Bits(a:mods.flags)
  let methoddef.r = java_parser#type2Str(a:type)

  " parameters
  let methoddef.params = s:formalParameters()

  " BracketsOpt
  if !a:isVoid
    let methoddef.r = java_parser#type2Str(s:bracketsOpt(a:type))
  endif


  " throws
  if b:token == 'THROWS'
    call s:nextToken()

    " thrown = qualidentList()
    let ts = [s:qualident()]
    while b:token == 'COMMA'
      call s:nextToken()
      call add(ts, s:qualident())
    endwhile
    let methoddef.throws = ts
  endif

  " method body
  if b:token == 'LBRACE'
    let methoddef.body = s:block(b:pos, 0, b:scanStrategy < 1)
  else
    if b:token == 'DEFAULT'
      call s:accept('DEFAULT')
      let methoddef.defaultValue = s:annotationValue()
    endif
    call s:accept('SEMI')

    if b:pos <= b:errorEndPos
      call s:skip(0, 1, 0, 0)
      if b:token == 'LBRACE'
        let methoddef.body = s:block(b:pos, 0, b:scanStrategy < 1)
      endif
    endif
  endif

  let methoddef.d = s:method2Str(methoddef)
  let b:et_perf .= "\r" . reltimestr(reltime(time)) . ' methodrest() '
  return methoddef
endfu

" method header declared in one line, 
" NOTE: RE_FORMAL_PARAM_LIST do not recognize varargs and nested comments
fu! s:methodDeclaratorRest_opt(pos, mods, type, name, typarams, isInterface, isVoid, dc, str, idx)
  let str = a:str
  let idx = a:idx

  " params
  let idxend = matchend(str, '^(\s*)', idx)	" no params
  if idxend == -1
    let idxend = matchend(str, '^(\s*' . s:RE_FORMAL_PARAM_LIST . '\s*)', idx)
  endif
  if idxend == -1
    return
  endif

  let methoddef = {'tag': 'METHODDEF', 'pos': a:pos, 'name': a:name, 'n': a:name, 'm': a:mods, 'r': a:type}

  " params
  let methoddef.params = []
  let s = strpart(str, idx+1, idxend-idx-2)
  if s !~ '^\s*$'
    for item in split(s, ',')
      let subs = split(substitute(item, s:RE_FORMAL_PARAM2, '\2;\5', ''), ';')
      let param = {'tag': 'VARDEF', 'pos': -1}
      let param.name = substitute(subs[1], ' ', '', 'g')
      let param.vartype = substitute(subs[0], ' ', '', 'g')
      let param.m = s:Flags.PARAMETER
      call add(methoddef.params, param)
    endfor
  endif

  " throws
  let idx2 = matchend(str, '^\s*' . s:RE_THROWS, idxend)
  let idx = idx2 == -1 ? idxend : idx2
  if idx2 != -1
    "let throws = strpart(str, idxend, idx-idxend)
  endif

  " in interface
  if a:isInterface
    let idx = matchend(str, '^\s*;', idx)
    if idx != -1
      let b:token = 'SEMI'
      let b:col = idx
      let b:bp = b:idxes[b:line] + b:col
      let b:pos = b:bp - 1
      let methoddef.d = substitute(str, '^\s*\([^{]*\)\s*;\=$', '\1', '')
      return methoddef
    endif
  endif

  let idx = matchend(str, '^\s*{', idx)
  if idx == -1
    let idx = matchend(b:lines[b:line+1], '^\s*{')
    if idx != -1
      let b:line += 1
    endif
  endif
  if idx != -1
    let b:token = 'LBRACE'
    let b:col = idx
    let b:bp = b:idxes[b:line] + b:col
    let b:pos = b:bp - 1
    let methoddef.d = substitute(str, '^\s*\([^{]*\)\s*{\=$', '\1', '')
    let methoddef.body = s:block(b:pos, 0, b:scanStrategy < 1)
    return methoddef
  endif
endfu

" VariableDeclarators = VariableDeclarator { "," VariableDeclarator }	{{{2
fu! s:variableDeclarators(mods, type, vdefs)
  return s:variableDeclaratorsRest(b:pos, a:mods, a:type, s:ident(), 0, '', a:vdefs)
endfu

" VariableDeclaratorsRest = VariableDeclaratorRest { "," VariableDeclarator }
"  ConstantDeclaratorsRest = ConstantDeclaratorRest { "," ConstantDeclarator }
fu! s:variableDeclaratorsRest(pos, mods, type, name, reqInit, dc, vdefs)
  call add(a:vdefs, s:variableDeclaratorRest(a:pos, a:mods, a:type, a:name, a:reqInit, a:dc))
  while b:token == 'COMMA'
    call s:nextToken()
    call add(a:vdefs, s:variableDeclarator(a:mods, a:type, a:reqInit, a:dc))
  endwhile
  return a:vdefs
endfu

" VariableDeclarator = Ident VariableDeclaratorRest
" ConstantDeclarator = Ident ConstantDeclaratorRest
fu! s:variableDeclarator(mods, type, reqInit, dc)
  return s:variableDeclaratorRest(b:pos, a:mods, a:type, s:ident(), a:reqInit, a:dc)
endfu

" VariableDeclaratorRest = BracketsOpt ["=" VariableInitializer]	
"  ConstantDeclaratorRest = BracketsOpt "=" VariableInitializer
fu! s:variableDeclaratorRest(pos, mods, type, name, reqInit, dc)
  let vardef = s:VarDef(a:pos, a:mods, a:name, s:bracketsOpt(a:type))
  let vardef.n = vardef.name
  let vardef.m = a:mods == {} ? '0' : s:Number2Bits(a:mods.flags)
  let vardef.t = java_parser#type2Str(vardef.vartype)

  if b:token == 'EQ'
    call s:nextToken()
    call s:Info('field init ' . b:token)
    let vardef.init = s:variableInitializer()
  elseif a:reqInit
    call s:Trace('[syntax error]:' . s:token2string('EQ') . " expected")
  endif

  let vardef.endpos = b:pos
  return vardef
endfu

fu! s:variableDeclaratorId(mods, type)
  let vardef = s:VarDef(b:pos, a:mods, s:ident(), a:type)
  if len(a:mods.flags) <= 34		" (a:mods.flags & s:Flags.VARARGS) == 0
    let vardef.type = s:bracketsOpt(vardef.vartype)
  endif
  return vardef
endfu

" 									{{{2
" TypeParametersOpt = ["<" TypeParameter {"," TypeParameter} ">"]	{{{2
fu! s:typeParametersOpt()
  if b:token == 'LT'
    "call checkGenerics()
    let typarams = []
    call s:nextToken()
    call add(typarams, s:typeParameter())
    while b:token == 'COMMA'
      call s:nextToken()
      call add(typarams, s:typeParameter())
    endwhile
    call s:accept('GT')
    return typarams
  else
    return []
  endif
endfu

" TypeParameter = TypeVariable [TypeParameterBound]		{{{2
" TypeParameterBound = EXTENDS Type {"&" Type}
" TypeVariable = Ident
fu! s:typeParameter()
  let pos = b:pos
  let name = s:ident()
  let bounds = []
  if b:token == 'EXTENDS'
    call s:nextToken()
    call add(bounds, s:type())
    while b:token == 'AMP'
      call s:nextToken()
      call add(bounds, s:type())
    endwhile
  endif

  return {'tag': 'TYPEPARAMETER', 'pos': pos, 'name': name, 'bounds': bounds}
endfu

" FormalParameters = "(" [ FormalParameterList ] ")"			{{{2
" FormalParameterList = [ FormalParameterListNovarargs , ] LastFormalParameter
" FormalParameterListNovarargs = [ FormalParameterListNovarargs , ] FormalParameter
fu! s:formalParameters()
  let params = []
  let lastParam = {}
  call s:accept('LPAREN')
  if b:token != 'RPAREN'
    let lastParam = s:formalParameter()
    call add(params, lastParam)
    while b:token == 'COMMA' && len(lastParam.mods.flags) <= 34		" (lastParam.mods.flags & s:Flags.VARARGS) == 0
      call s:nextToken()
      let lastParam = s:formalParameter()
      call add(params, lastParam)
    endwhile
  endif
  call s:accept('RPAREN')
  return params
endfu

" FormalParameter = { FINAL | '@' Annotation } Type VariableDeclaratorId 	{{{2
" LastFormalParameter = { FINAL | '@' Annotation } Type '...' Ident | FormalParameter
fu! s:optFinal(flags)
  let mods = s:modifiersOpt()
  " checkNoMods(mods.flags & ~(Flags.FINAL | Flags.DEPRECATED))
  let mods.flags = s:BitOr(mods.flags, a:flags)
  return mods
endfu

" OAO: optional FINAL for parameter
fu! s:optFinalParameter()
  let mods = {'tag': 'MODIFIERS', 'pos': b:pos, 'flags': s:Flags.PARAMETER, 'annotations': []}
  if b:token == 'FINAL'
    let mods.flags = '1000000000000000000000000000010000'
    call s:nextToken()
  endif
  return mods
endfu

fu! s:formalParameter()
  let mods = s:optFinalParameter()
  let type = s:type()

  if b:token == 'ELLIPSIS'
    " checkVarargs()
    let mods.flags = '1' . mods.flags	" s:BitOr_binary(mods.flags, s:Flags.VARARGS)
    let type = s:TypeArray(b:pos, type)
    call s:nextToken()
  endif

  return s:variableDeclaratorId(mods, type)
endfu

" 									{{{2
" auxiliary methods							{{{2
let s:MapToken2Tag = {'BARBAR': 'OR', 'AMPAMP': 'AND', 'BAR': 'BITOR', 'BAREQ': 'BITOR_ASG', 'CARET': 'BITXOR', 'CARETEQ': 'BITXOR_ASG', 'AMP': 'BITAND', 'AMPEQ': 'BITAND_ASG', 'EQEQ': 'EQ', 'BANGEQ': 'NE', 'LT': 'LT', 'GT': 'GT', 'LTEQ': 'LE', 'GTEQ': 'GE', 'LTLT': 'SL', 'LTLTEQ': 'SL_ASG', 'GTGT': 'SR', 'GTGTEQ': 'SR_ASG', 'GTGTGT': 'USR', 'GTGTGTEQ': 'USR_ASG', 'PLUS': 'PLUS', 'PLUSEQ': 'PLUS_ASG', 'SUB': 'MINUS', 'SUBEQ': 'MINUS_ASG', 'STAR': 'MUL', 'STAREQ': 'MUL_ASG', 'SLASH': 'DIV', 'SLASHEQ': 'DIV_ASG', 'PERCENT': 'MOD', 'PERCENTEQ': 'MOD_ASG', 'INSTANCEOF': 'TYPETEST'}
let s:opprecedences = {'notExpression': -1, 'noPrec': 0,       'assignPrec': 1, 'assignopPrec': 2, 'condPrec': 3, 'orPrec': 4, 'andPrec': 5, 'bitorPrec': 6, 'bitxorPrec': 7, 'bitandPrec': 8, 'eqPrec': 9, 'ordPrec': 10, 'shiftPrec': 11, 'addPrec': 12, 'mulPrec': 13, 'prefixPrec': 14, 'postfixPrec': 15, 'precCount': 16}

fu! s:checkExprStat(t)
  if a:t.tag =~# '^\(PREINC\|PREDEC\|POSTINC\|POSTDEC\|ASSIGN\|BITOR_ASG\|BITXOR_ASG\|BITAND_ASG\|SL_ASG\|SR_ASG\|USR_ASG\|PLUS_ASG\|MINUS_ASG\|MUL_ASG\|DIV_ASG\|MOD_ASG\|APPLY\|NEWCLASS\|ERRONEOUS\)$'
    return a:t
  else
    call s:SyntaxError('not.stmt')
    return {'tag': 'ERRONEOUS', 'pos': b:pos, 'errs': [a:t]}
  endif
endfu

fu! s:prec(token)
  let oc = s:optag(a:token)
  return oc == -1 ? -1 : s:opPrec(oc)
endfu

fu! s:opPrec(tag)
  if a:tag =~# '^\(POS\|NEG\|NOT\|COMPL\|PREINC\|PREDEC\)$'
    return s:opprecedences.prefixPrec
  elseif a:tag =~# '^\(POSTINC\|POSTDEC\|NULLCHK\)$'
    return s:opprecedences.postfixPrec
  elseif a:tag == 'ASSIGN'
    return s:opprecedences.assignPrec
  elseif a:tag =~# '^\(BITOR_ASG\|BITXOR_ASG\|BITAND_ASG\|SL_ASG\|SR_ASG\|USR_ASG\|PLUS_ASG\|MINUS_ASG\|MUL_ASG\|DIV_ASG\|MOD_ASG\)$'
    return s:opprecedences.assignopPrec
  elseif a:tag == 'OR'
    return s:opprecedences.orPrec
  elseif a:tag == 'AND'
    return s:opprecedences.andPrec
  elseif a:tag =~# '^\(EQ\|NE\)$'
    return s:opprecedences.eqPrec
  elseif a:tag =~# '^\(LT\|GT\|LE\|GE\)$'
    return s:opprecedences.ordPrec
  elseif a:tag == 'BITOR'
    return s:opprecedences.bitorPrec
  elseif a:tag == 'BITXOR'
    return s:opprecedences.bitxorPrec
  elseif a:tag == 'BITAND'
    return s:opprecedences.bitandPrec
  elseif a:tag =~# '^\(SL\|SR\|USR\)$'
    return s:opprecedences.shiftPrec
  elseif a:tag =~# '^\(PLUS\|MINUS\)$'
    return s:opprecedences.addPrec
  elseif a:tag =~# '^\(MUL\|DIV\|MOD\)$'
    return s:opprecedences.mulPrec
  elseif a:tag == 'TYPETEST'
    return s:opprecedences.ordPrec
  else
    return -1
  endif
endfu

fu! s:optag(token)
  return get(s:MapToken2Tag, a:token, -1)
endfu

fu! s:unoptag(token)
  if a:token == 'PLUS'
    return 'POS'
  elseif a:token == 'SUB'
    return 'NEG'
  elseif a:token == 'BANG'
    return 'NOT'
  elseif a:token == 'TILDE'
    return 'COMPL'
  elseif a:token == 'PLUSPLUS'
    return 'PREINC'
  elseif a:token == 'SUBSUB'
    return 'PREDEC'
  else
    return -1
  endif
endfu

fu! s:typetag(token)
  if a:token =~# '\(BYTE\|CHAR\|SHORT\|INT\|LONG\|FLOAT\|DOUBLE\|BOOLEAN\)'
    return tolower(a:token)
  else
    return -1
  endif
endfu

"}}}1
" vim:set fdm=marker sw=2 nowrap:
