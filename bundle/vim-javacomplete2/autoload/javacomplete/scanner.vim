" Vim completion script for java
" Maintainer:	artur shaik <ashaihullin@gmail.com>
"
" Simple parsing functions

" Search back from the cursor position till meeting '{' or ';'.
" '{' means statement start, ';' means end of a previous statement.
" Return: statement before cursor
" Note: It's the base for parsing. And It's OK for most cases.
function! javacomplete#scanner#GetStatement()
  if getline('.') =~ '^\s*\(import\|package\)\s\+'
    return strpart(getline('.'), match(getline('.'), '\(import\|package\)'), col('.')-1)
  endif

  let lnum_old = line('.')
  let col_old = col('.')

  call s:SkipBlock()

  while 1
    if search('[{};]\|<%\|<%!', 'bW') == 0
      let lnum = 1
      let col  = 1
    else
      if javacomplete#util#InCommentOrLiteral(line('.'), col('.'))
        continue
      endif

      normal! w
      let lnum = line('.')
      let col = col('.')
    endif
    break
  endwhile

  silent call cursor(lnum_old, col_old)
  return s:MergeLines(lnum, col, lnum_old, col_old)
endfunction

function! s:SkipBlock()
  let pos = line('.') + 1
  let clbracket = 0
  let quoteFlag = 0
  while pos > 0
    let pos -= 1
    if pos == 0
      break
    endif

    let line = getline(pos)
    let cursor = len(line)
    while cursor > 0
      if line[cursor] == '"'
        if quoteFlag == 0
          let quoteFlag = 1
        else
          let quoteFlag = 0
        endif
      endif

      if quoteFlag
        let line = line[0 : cursor - 1]. line[cursor + 1 : -1]
        let cursor -= 1
        continue
      endif

      if line[cursor] == '}'
        let clbracket += 1
      elseif line[cursor] == '(' && clbracket == 0
        call cursor(pos, cursor)
        break
      elseif line[cursor] == '{' 
        if clbracket > 0
          let clbracket -= 1
        else
          break
        endif
      endif
      let cursor -= 1
    endwhile
    if clbracket == 0
      break
    endif
  endwhile
endfunction

function! s:MergeLines(lnum, col, lnum_old, col_old)
  let lnum = a:lnum
  let col = a:col

  let str = ''
  if lnum < a:lnum_old
    let str = javacomplete#util#Prune(strpart(getline(lnum), a:col-1))
    let lnum += 1
    while lnum < a:lnum_old
      let str  .= javacomplete#util#Prune(getline(lnum))
      let lnum += 1
    endwhile
    let col = 1
  endif
  let lastline = strpart(getline(a:lnum_old), col-1, a:col_old-col)
  let str .= javacomplete#util#Prune(lastline, col)
  let str = javacomplete#util#RemoveBlockComments(str)
  " generic in JAVA 5+
  while match(str, g:RE_TYPE_ARGUMENTS) != -1
    let str = substitute(str, '\(' . g:RE_TYPE_ARGUMENTS . '\)', '\=repeat("", len(submatch(1)))', 'g')
  endwhile
  let str = substitute(str, '\s\s\+', ' ', 'g')
  if str !~ '.*'. g:RE_KEYWORDS. '.*'
    let str = substitute(str, '\([.()]\)[ \t]\+', '\1', 'g')
    let str = substitute(str, '[ \t]\+\([.()]\)', '\1', 'g')
  endif
  return javacomplete#util#Trim(str) . matchstr(lastline, '\s*$')
endfunction

" Extract a clean expr, removing some non-necessary characters. 
function! javacomplete#scanner#ExtractCleanExpr(expr)
  if a:expr !~ '.*'. g:RE_KEYWORDS. '.*'
    let cmd = substitute(a:expr, '[ \t\r\n]\+\([.()[\]]\)', '\1', 'g')
    let cmd = substitute(cmd, '\([.()[\]]\)[ \t\r\n]\+', '\1', 'g')
  else
    let cmd = a:expr
  endif

  let pos = strlen(cmd)-1 
  while pos >= 0 && cmd[pos] =~ '[a-zA-Z0-9_.)\]:<>]'
    if cmd[pos] == ')'
      let pos = javacomplete#util#SearchPairBackward(cmd, pos, '(', ')')
    elseif cmd[pos] == ']'
      let pos = javacomplete#util#SearchPairBackward(cmd, pos, '[', ']')
    endif
    let pos -= 1
  endwhile

  " try looking back for "new"
  let idx = match(strpart(cmd, 0, pos+1), '\<new[ \t\r\n]*$')

  return strpart(cmd, idx != -1 ? idx : pos+1)
endfunction

function! javacomplete#scanner#ParseExpr(expr)
  let items = []
  let s = 0
  " recognize ClassInstanceCreationExpr as a whole
  let e = matchend(a:expr, '^\s*new\s\+' . g:RE_QUALID . '\s*[([]')-1
  if e < 0
    let e = match(a:expr, '[.([:]')
  endif
  let isparen = 0
  while e >= 0
    if a:expr[e] == '.' || a:expr[e] == ':'
      let subexpr = strpart(a:expr, s, e-s)
      call extend(items, isparen ? s:ProcessParentheses(subexpr) : [subexpr])
      let isparen = 0
      if a:expr[e] == ':' && a:expr[e+1] == ':'
        let s = e + 2
      else
        let s = e + 1
      endif
    elseif a:expr[e] == '('
      let e = javacomplete#util#GetMatchedIndexEx(a:expr, e, '(', ')')
      let isparen = 1
      if e < 0
        break
      else
        let e = matchend(a:expr, '^\s*[.[]', e+1)-1
        continue
      endif
    elseif a:expr[e] == '['
      let e = javacomplete#util#GetMatchedIndexEx(a:expr, e, '[', ']')
      if e < 0
        break
      else
        let e = matchend(a:expr, '^\s*[.[]', e+1)-1
        continue
      endif
    endif
    let e = match(a:expr, '[.([:]', s)
  endwhile
  let tail = strpart(a:expr, s)
  if tail !~ '^\s*$'
    call extend(items, isparen ? s:ProcessParentheses(tail) : [tail])
  endif

  return items
endfunction

" Given optional argument, call s:ParseExpr() to parser the nonparentheses expr
fu! s:ProcessParentheses(expr, ...)
  let s = matchend(a:expr, '^\s*(')
  if s != -1
    let e = javacomplete#util#GetMatchedIndexEx(a:expr, s-1, '(', ')')
    if e >= 0
      let tail = strpart(a:expr, e+1)
      if tail[-1:] == '.'
        return [tail[0:-2]]
      endif
      if tail =~ '^\s*[\=$'
        return s:ProcessParentheses(strpart(a:expr, s, e-s), 1)
      elseif tail =~ '^\s*\w'
        return [strpart(a:expr, 0, e+1) . 'obj.']
      endif
    endif

    " multi-dot-expr except for new expr
  elseif a:0 > 0 && stridx(a:expr, '.') != match(a:expr, '\.\s*$') && a:expr !~ '^\s*new\s\+'
    return javacomplete#scanner#ParseExpr(a:expr)
  endif
  return [a:expr]
endfu

" search decl							{{{1
" Return: The declaration of identifier under the cursor
" Note: The type of a variable must be imported or a fqn.
function! javacomplete#scanner#GetVariableDeclaration()
  let lnum_old = line('.')
  let col_old = col('.')

  silent call search('[^a-zA-Z0-9$_.,?<>[\] \t\r\n]', 'bW')	" call search('[{};(,]', 'b')
  normal! w
  let lnum = line('.')
  let col = col('.')
  if (lnum == lnum_old && col == col_old)
    return ''
  endif

  silent call cursor(lnum_old, col_old)
  return s:MergeLines(lnum, col, lnum_old, col_old)
endfunction

" vim:set fdm=marker sw=2 nowrap:
