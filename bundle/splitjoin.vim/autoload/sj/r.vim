" Only real syntax that's interesting is cParen and cConditional
let s:skip = sj#SkipSyntax(['rComment'])

" function! sj#r#SplitFuncall()
"
" Split the R function call if the cursor lies within the arguments of a
" function call
"
function! sj#r#SplitFuncall()
  if !s:IsValidSelection("va(")
    return 0
  endif

  call sj#PushCursor()
  let items = s:ParseJsonFromMotion("va(\<esc>vi(")
  let items = map(items, {k, v -> v . (k+1 < len(items) ? "," : "")})

  let r_indent_align_args = get(g:, 'r_indent_align_args', 1)
  if r_indent_align_args && len(items)
    let items[0]  = "(" . items[0]
    let items[-1] = items[-1] . ")"
    let lines = items
  else
    let lines = ["("] + items + [")"]
  endif

  call sj#PopCursor()
  call s:ReplaceMotionPreserveCursor('va(', lines)

  return 1
endfunction

" function! sj#r#JoinFuncall()
"
" Join an R function call if the cursor lies within the arguments of a
" function call
"
function! sj#r#JoinFuncall()
  if !s:IsValidSelection("va(")
    return 0
  endif

  call sj#PushCursor()

  let existing_text = sj#GetMotion("va(\<esc>vi(")
  let items = s:ParseJsonObject(existing_text)
  let text = join(items, ", ")

  " if replacement wouldn't have any effect, fail to attempt a latter callback
  if text == existing_text
    return 0
  endif

  call sj#PopCursor()
  call s:ReplaceMotionPreserveCursor("va(", ["(" . text . ")"])

  return 1
endfunction

" function! sj#r#JoinSmart()
"
" Reexecute :SplitjoinJoin at the end of the line, where it is more likely
" to find a code block relevant to being joined.
"
function! sj#r#JoinSmart()
  try
    call sj#PushCursor()

    let cur_pos = getpos(".")
    silent normal! $
    let end_pos = getpos(".")

    if cur_pos[1:2] != end_pos[1:2]
      execute ":SplitjoinJoin"
      return 1
    else
      return 0
    endif
  finally
    call sj#PopCursor()
  endtr
endfunction

" function! s:DoMotion(motion)
"
" Perform a normal-mode motion command
"
function s:DoMotion(motion)
  call sj#PushCursor()
  execute "silent normal! " . a:motion . "\<esc>"
  execute "silent normal! \<esc>"
  call sj#PopCursor()
endfunction

" function! s:MoveCursor(lines, cols)
"
" Reposition cursor given relative lines offset and columns from the start of
" the line
"
function! s:MoveCursor(lines, cols)
  let y = a:lines > 0 ? a:lines . 'j^' : a:lines < 0 ? a:lines . 'k^' : ''
  let x = a:cols  > 0 ? a:cols  . 'l'  : a:cols  < 0 ? a:cols  . 'h'  : ''
  let motion = y . x
  if len(motion)
    execute 'silent normal! ' . motion
  endif
endfunction

" function! s:ParseJsonObject(text)
"
" Wrapper around sj#argparser#js#Construct to simply parse a given string
"
function! s:ParseJsonObject(text)
  let parser = sj#argparser#js#Construct(0, len(a:text), a:text)
  call parser.Process()
  return parser.args
endfunction

" function! s:ParseJsonFromMotion(motion)
"
" Parse a json object from the visual selection of a given normal-mode motion
" string
"
function! s:ParseJsonFromMotion(motion)
  let text = sj#GetMotion(a:motion)
  return s:ParseJsonObject(text)
endfunction

" function! s:IsValidSelection(motion)
"
" Test whether a visual selection contains more than a single character after
" performing the given normal-mode motion string
"
function! s:IsValidSelection(motion)
  call s:DoMotion(a:motion)
  return getpos("'<") != getpos("'>")
endfunction

" function! s:ReplaceMotionPreserveCursor(motion, rep) {{{2
"
" Replace the normal mode "motion" selection with a list of replacement lines,
" "rep", separated by line breaks, Assuming the non-whitespace content of
" "motion" is identical to the non-whitespace content of the joined lines of
" "rep", the cursor will be repositioned to the resulting location of the
" current character under the cursor.
"
function! s:ReplaceMotionPreserveCursor(motion, rep)
  " default to interpretting all lines of text as originally from text to replace
  let rep = a:rep

  " do motion and get bounds & text
  call s:DoMotion(a:motion)
  let ini = split(sj#GetByPosition(getpos("'<"), getpos(".")), "\n")
  let ini = map(ini, {k, v -> sj#Ltrim(v)})

  " do replacement
  let body = join(a:rep, "\n")
  call sj#ReplaceMotion(a:motion, body)

  " go back to start of selection
  silent normal! `<

  " try to reconcile initial selection against replacement lines
  let [cursory, cursorx, leading_ws] = [0, 0, 0]
  while len(ini) && len(rep)
    let i = stridx(ini[0], rep[0])
    let j = stridx(rep[0], ini[0])
    if i >= 0
      " if an entire line of the replacement text found in initial then we'll
      " need our cursor to move to the next line if more lines are insered
      let ini[0] = sj#Ltrim(ini[0][i+len(rep[0]):])
      let cursorx += i + len(rep[0])
      let ini = len(ini[0]) ? ini : ini[1:]
      let rep = rep[1:]
      if len(ini)
        let cursory += 1
        let cursorx = 0
      endif
    elseif j >= 0
      " if an entire line of the initial is found in the replacement then
      " we'll need our cursor to move rightward through length of the initial
      let rep[0] = rep[0][j+len(ini[0]):]
      let leading_ws = len(rep[0])
      let rep[0] = sj#Ltrim(rep[0])
      let leading_ws = leading_ws - len(rep[0])
      let cursorx += j + len(ini[0])
      let ini = ini[1:]
      let cursorx += (len(ini) && len(ini[0]) ? leading_ws : 0)
    else
      let ini = []
    endif
  endwhile

  call s:MoveCursor(cursory, max([cursorx-1, 0]))
  call sj#PushCursor()
endfunction
