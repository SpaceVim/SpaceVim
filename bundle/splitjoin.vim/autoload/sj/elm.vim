" vim: foldmethod=marker

" Split / Join {{{1
"
" function! sj#elm#JoinBraces() {{{2
"
" Attempts to join the multiline tuple, record or list closest
" to current cursor position.
function! sj#elm#JoinBraces()
  let [from, to] = s:ClosestMultilineBraces()

  if from[0] < 0
    return 0
  endif

  let original = sj#GetByPosition([0, from[0], from[1]], [0, to[0], to[1]])
  let joined = s:JoinOuterBraces(s:JoinLines(original))
  call sj#ReplaceByPosition([0, from[0], from[1]], [0, to[0], to[1]], joined)

  return 1
endfunction

" function! sj#elm#SplitBraces() {{{2
"
" Attempts to split the tuple, record or list furthest to current
" cursor position on the same line.
function! sj#elm#SplitBraces()
  try
    call sj#PushCursor()

    let [from, to] = s:CurrentLineOutermostBraces(col('.'))

    if from < 0
      return 0
    endif

    let parts = s:SplitParts(from, to)

    if len(parts) <= 2
      return 0
    endif

    let replacement = join(parts, "\n")

    call cursor(line('.'), from)
    let [previousLine, previousCol] = searchpos('\S', 'bn')
    if previousLine == line('.') && previousCol > 0 && s:CharAt(previousCol) =~ '[=:]'
      let replacement = "\n".replacement
      let from = previousCol + 1
    end

    call sj#ReplaceCols(from, to, replacement)

    return 1
  finally
    call sj#PopCursor()
  endtry
endfunction


" Helper functions {{{1

" function! s:SkipSyntax() {{{2
"
" Returns Elm's typical skippable syntax (strings and comments)
function! s:SkipSyntax()
  return sj#SkipSyntax(['elmString', 'elmTripleString', 'elmComment'])
endfunction

" function! s:CurrentLineClosestBraces(column) {{{2
"
" Returns the columns corresponding to the bracing pair closest
" to and surrounding given column as a list ([opening, closing]).
" Returns [-1, -1] when there is none on the same line.
function! s:CurrentLineClosestBraces(column)
  try
    call sj#PushCursor()

    let skip = s:SkipSyntax()
    let currentLine = line('.')

    call cursor(currentLine, a:column)
    let from = searchpairpos('[{(\[]', '', '[})\]]', 'bcn', skip, currentLine)

    if from[0] == 0
      return [-1, -1]
    end

    call cursor(from[0], from[1])
    normal! %

    if line('.') != currentLine
      return [-1, -1]
    endif

    let to = col('.')

    return [from[1], to]
  finally
    call sj#PopCursor()
  endtry
endfunction

" function! s:CurrentLineOutermostBraces(column) {{{2
"
" Returns the colums corresponding to the bracing pair furthest
" to and surrounding given column as a list ([opening, closing]).
" Returns [-1, -1] when there is none on the same line.
function! s:CurrentLineOutermostBraces(column)
  if a:column < 1
    return [-1, -1]
  endif

  let currentMatch = s:CurrentLineClosestBraces(a:column)

  if currentMatch[0] < 1
    return [-1, -1]
  endif

  let betterMatch = s:CurrentLineOutermostBraces(currentMatch[0] - 1)

  if betterMatch[0] < 1
    return currentMatch
  endif

  return betterMatch
endfunction

" function! s:ClosestMultilineBraces() {{{2
"
" Returns the position of the closest pair of multiline braces
" around the cursor.
"
" The positions are given as a couple of arrays:
"
"   [[startLine, startCol], [endLine, endCol]]
"
" When no position is found, returns:
"
"   [[-1, -1], [-1, -1]]
function! s:ClosestMultilineBraces()
  try
    call sj#PushCursor()

    let skip = s:SkipSyntax()

    let currentLine = line('.')

    normal! $

    let [toLine, toCol] = searchpairpos('[{(\[]', '', '[})\]]', '', skip, line('$'))

    if toLine < currentLine
      return [[-1, -1], [-1, -1]]
    endif

    normal! %

    let fromLine = line('.')
    let fromCol = col('.')

    if fromLine >= toLine
      return [[-1, -1], [-1, -1]]
    endif

    return [[fromLine, fromCol], [toLine, toCol]]
  finally
    call sj#PopCursor()
  endtry
endfunction

" function! s:JoinOuterBraces(text)
"
" Removes spaces separating the first and last char of a string
" with the closest non-space char found.
"
" ex:
"
"   [ 1, 2, 3 ] => [1, 2, 3]
function! s:JoinOuterBraces(text)
  return substitute(substitute(a:text, '\s*\(.\)$', '\1', ''), '^\(.\)\s*', '\1', '')
endfunction

" function! s:JoinLines(text)
"
" Joins lines in text, removing complementary spaces around
" newline chars when the last line starts with a ',' and keeping
" one whitespace for other cases.
function! s:JoinLines(text)
  return substitute(substitute(a:text, '\s*\n\s*,', ',', 'g'), '\s*\n\s*', ' ', 'g')
endfunction

" function! s:SplitParts(from, to)
"
" Splits a section of a line according to bracing characters
" rules.
"
" ex:
"   "[1,2,3]"
"   v
"   [ "[ 1", ", 2", ", 3", "]" ]
"
"   "{a | foo = bar, baz = buzz}"
"   v
"   [ "{ a", "| foo = bar", ", baz = buzz", "}" ]
function! s:SplitParts(from, to)
  try
    call sj#PushCursor()
    let skip = s:SkipSyntax()
    let currentLine = line('.')

    call cursor(currentLine, a:from)

    let openingCol = a:from
    let openingChar = s:CurrentChar()
    let parts = []

    while col('.') < a:to
      call searchpair('[{(\[]', ',\|\(\(<\)\@<!|\(>\)\@!\)', '[})\]]', '', skip, currentLine)
      let closingCol = col('.')
      let closingChar = s:CurrentChar()
      let part = openingChar.' '.sj#Trim(sj#GetByPosition([0, currentLine, openingCol + 1, 0], [0, currentLine, closingCol - 1, 0]))
      call add(parts, part)
      let openingCol = closingCol
      let openingChar = closingChar
      call cursor(currentLine, openingCol)
    endwhile

    call add(parts, s:CharAt(a:to))

    return parts
  finally
    call sj#PopCursor()
  endtry
endfunction

" function! s:CharAt(column)
"
" Returns the char sitting at given column of current line.
function! s:CharAt(column)
  return getline('.')[a:column - 1]
endfunction

" function! s:CurrentChar()
"
" Returns the character at current cursor's position
function! s:CurrentChar()
  return s:CharAt(col('.'))
endfunction
