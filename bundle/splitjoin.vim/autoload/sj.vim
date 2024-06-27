" vim: foldmethod=marker

" Main entry points {{{1
"
" The two main functions that loop through callbacks and execute them.
"
" function! sj#Split() {{{2
"
function! sj#Split()
  if !exists('b:splitjoin_split_callbacks')
    return
  end

  " expand any folds under the cursor, or we might replace the wrong area
  silent! foldopen

  let disabled_callbacks = sj#settings#Read('disabled_split_callbacks')

  let saved_view = winsaveview()
  let saved_whichwrap = &whichwrap
  set whichwrap-=l

  if !sj#settings#Read('quiet') | echo "Splitjoin: Working..." | endif
  for callback in b:splitjoin_split_callbacks
    if index(disabled_callbacks, callback) >= 0
      continue
    endif

    try
      call sj#PushCursor()

      if call(callback, [])
        silent! call repeat#set("\<plug>SplitjoinSplit")
        let &whichwrap = saved_whichwrap
        if !sj#settings#Read('quiet')
          " clear progress message
          redraw | echo ""
        endif
        return 1
      endif

    finally
      call sj#PopCursor()
    endtry
  endfor

  call winrestview(saved_view)
  let &whichwrap = saved_whichwrap
  if !sj#settings#Read('quiet')
    " clear progress message
    redraw | echo ""
  endif
  return 0
endfunction

" function! sj#Join() {{{2
"
function! sj#Join()
  if !exists('b:splitjoin_join_callbacks')
    return
  end

  " expand any folds under the cursor, or we might replace the wrong area
  silent! foldopen

  let disabled_callbacks = sj#settings#Read('disabled_join_callbacks')

  let saved_view = winsaveview()
  let saved_whichwrap = &whichwrap
  set whichwrap-=l

  if !sj#settings#Read('quiet') | echo "Splitjoin: Working..." | endif
  for callback in b:splitjoin_join_callbacks
    if index(disabled_callbacks, callback) >= 0
      continue
    endif

    try
      call sj#PushCursor()

      if call(callback, [])
        silent! call repeat#set("\<plug>SplitjoinJoin")
        let &whichwrap = saved_whichwrap
        if !sj#settings#Read('quiet')
          " clear progress message
          redraw | echo ""
        endif
        return 1
      endif

    finally
      call sj#PopCursor()
    endtry
  endfor

  call winrestview(saved_view)
  let &whichwrap = saved_whichwrap
  if !sj#settings#Read('quiet')
    " clear progress message
    redraw | echo ""
  endif
  return 0
endfunction

" Cursor stack manipulation {{{1
"
" In order to make the pattern of saving the cursor and restoring it
" afterwards easier, these functions implement a simple cursor stack. The
" basic usage is:
"
"   call sj#PushCursor()
"   " Do stuff that move the cursor around
"   call sj#PopCursor()
"
" function! sj#PushCursor() {{{2
"
" Adds the current cursor position to the cursor stack.
function! sj#PushCursor()
  if !exists('b:cursor_position_stack')
    let b:cursor_position_stack = []
  endif

  call add(b:cursor_position_stack, winsaveview())
endfunction

" function! sj#PopCursor() {{{2
"
" Restores the cursor to the latest position in the cursor stack, as added
" from the sj#PushCursor function. Removes the position from the stack.
function! sj#PopCursor()
  call winrestview(remove(b:cursor_position_stack, -1))
endfunction

" function! sj#DropCursor() {{{2
"
" Discards the last saved cursor position from the cursor stack.
" Note that if the cursor hasn't been saved at all, this will raise an error.
function! sj#DropCursor()
  call remove(b:cursor_position_stack, -1)
endfunction

" Indenting {{{1
"
" Some languages don't have built-in support, and some languages have semantic
" indentation. In such cases, code blocks might need to be reindented
" manually.
"

" function! sj#SetIndent(start_lineno, end_lineno, indent) {{{2
" function! sj#SetIndent(lineno, indent)
"
" Sets the indent of the given line numbers to "indent" amount of whitespace.
"
function! sj#SetIndent(...)
  if a:0 == 3
    let start_lineno = a:1
    let end_lineno   = a:2
    let indent       = a:3
  elseif a:0 == 2
    let start_lineno = a:1
    let end_lineno   = a:1
    let indent       = a:2
  endif

  let is_tabs = &l:expandtab
  let shift = shiftwidth()

  if is_tabs == 0
    if shift > 0
      let indent = indent / shift
    endif

    let whitespace = repeat('\t', indent)
  else
    let whitespace = repeat(' ', indent)
  endif

  exe start_lineno.','.end_lineno.'s/^\s*/'.whitespace

  " Don't leave a history entry
  call histdel('search', -1)
  let @/ = histget('search', -1)
endfunction

" function! sj#PeekCursor() {{{2
"
" Returns the last saved cursor position from the cursor stack.
" Note that if the cursor hasn't been saved at all, this will raise an error.
function! sj#PeekCursor()
  return b:cursor_position_stack[-1]
endfunction

" Text replacement {{{1
"
" Vim doesn't seem to have a whole lot of functions to aid in text replacement
" within a buffer. The ":normal!" command usually works just fine, but it
" could be difficult to maintain sometimes. These functions encapsulate a few
" common patterns for this.

" function! sj#ReplaceMotion(motion, text) {{{2
"
" Replace the normal mode "motion" with "text". This is mostly just a wrapper
" for a normal! command with a paste, but doesn't pollute any registers.
"
"   Examples:
"     call sj#ReplaceMotion('Va{', 'some text')
"     call sj#ReplaceMotion('V', 'replacement line')
"
" Note that the motion needs to include a visual mode key, like "V", "v" or
" "gv"
function! sj#ReplaceMotion(motion, text)
  " reset clipboard to avoid problems with 'unnamed' and 'autoselect'
  let saved_clipboard = &clipboard
  set clipboard=
  let saved_selection = &selection
  let &selection = "inclusive"

  let saved_register_text = getreg('"', 1)
  let saved_register_type = getregtype('"')
  let saved_opening_visual = getpos("'<")
  let saved_closing_visual = getpos("'>")

  call setreg('"', a:text, 'v')
  exec 'silent noautocmd normal! '.a:motion.'p'

  " TODO (2021-02-22) Not a good idea to rely on reindent here
  silent normal! gv=

  call setreg('"', saved_register_text, saved_register_type)
  call setpos("'<", saved_opening_visual)
  call setpos("'>", saved_closing_visual)

  let &clipboard = saved_clipboard
  let &selection = saved_selection
endfunction

" function! sj#ReplaceLines(start, end, text) {{{2
"
" Replace the area defined by the 'start' and 'end' lines with 'text'.
function! sj#ReplaceLines(start, end, text)
  let interval = a:end - a:start

  if interval == 0
    return sj#ReplaceMotion(a:start.'GV', a:text)
  else
    return sj#ReplaceMotion(a:start.'GV'.interval.'j', a:text)
  endif
endfunction

" function! sj#ReplaceCols(start, end, text) {{{2
"
" Replace the area defined by the 'start' and 'end' columns on the current
" line with 'text'
function! sj#ReplaceCols(start, end, text)
  let start_position = getpos('.')
  let end_position   = getpos('.')

  let start_position[2] = a:start
  let end_position[2]   = a:end

  return sj#ReplaceByPosition(start_position, end_position, a:text)
endfunction

" function! sj#ReplaceByPosition(start, end, text) {{{2
"
" Replace the area defined by the 'start' and 'end' positions with 'text'. The
" positions should be compatible with the results of getpos():
"
"   [bufnum, lnum, col, off]
"
function! sj#ReplaceByPosition(start, end, text)
  let saved_z_pos = getpos("'z")

  try
    call setpos('.', a:start)
    call setpos("'z", a:end)

    return sj#ReplaceMotion('v`z', a:text)
  finally
    call setpos("'z", saved_z_pos)
  endtry
endfunction

" Text retrieval {{{1
"
" These functions are similar to the text replacement functions, only retrieve
" the text instead.
"
" function! sj#GetMotion(motion) {{{2
"
" Execute the normal mode motion "motion" and return the text it marks.
"
" Note that the motion needs to include a visual mode key, like "V", "v" or
" "gv"
function! sj#GetMotion(motion)
  call sj#PushCursor()

  let saved_selection = &selection
  let &selection = "inclusive"
  let saved_register_text = getreg('z', 1)
  let saved_register_type = getregtype('z')
  let saved_opening_visual = getpos("'<")
  let saved_closing_visual = getpos("'>")

  let @z = ''
  exec 'silent noautocmd normal! '.a:motion.'"zy'
  let text = @z

  if text == ''
    " nothing got selected, so we might still be in visual mode
    exe "normal! \<esc>"
  endif

  call setreg('z', saved_register_text, saved_register_type)
  call setpos("'<", saved_opening_visual)
  call setpos("'>", saved_closing_visual)
  let &selection = saved_selection

  call sj#PopCursor()

  return text
endfunction

" function! sj#GetLines(start, end) {{{2
"
" Retrieve the lines from "start" to "end" and return them as a list. This is
" simply a wrapper for getbufline for the moment.
function! sj#GetLines(start, end)
  return getbufline('%', a:start, a:end)
endfunction

" function! sj#GetCols(start, end) {{{2
"
" Retrieve the text from columns "start" to "end" on the current line.
function! sj#GetCols(start, end)
  return strpart(getline('.'), a:start - 1, a:end - a:start + 1)
endfunction

" function! sj#GetByPosition(start, end) {{{2
"
" Fetch the area defined by the 'start' and 'end' positions. The positions
" should be compatible with the results of getpos():
"
"   [bufnum, lnum, col, off]
"
function! sj#GetByPosition(start, end)
  let saved_z_pos = getpos("'z")

  try
    call setpos('.', a:start)
    call setpos("'z", a:end)

    return sj#GetMotion('v`z')
  finally
    call setpos("'z", saved_z_pos)
  endtry
endfunction

" String functions {{{1
" Various string manipulation utility functions
function! sj#BlankString(s)
  return (a:s =~ '^\s*$')
endfunction

" Surprisingly, Vim doesn't seem to have a "trim" function. In any case, these
" should be fairly obvious.
function! sj#Ltrim(s)
  return substitute(a:s, '^\_s\+', '', '')
endfunction
function! sj#Rtrim(s)
  return substitute(a:s, '\_s\+$', '', '')
endfunction
function! sj#Trim(s)
  return sj#Rtrim(sj#Ltrim(a:s))
endfunction

" Execute sj#Trim on each item of a List
function! sj#TrimList(list)
  return map(a:list, 'sj#Trim(v:val)')
endfunction

" Remove blank strings from the List
function! sj#RemoveBlanks(list)
  return filter(a:list, 'v:val !~ "^\\s*$"')
endfunction

" Searching for patterns {{{1
"
" function! sj#SearchUnderCursor(pattern, flags, skip) {{{2
"
" Searches for a match for the given pattern under the cursor. Returns the
" result of the |search()| call if a match was found, 0 otherwise.
"
" Moves the cursor unless the 'n' flag is given.
"
" The a:flags parameter can include one of "e", "p", "s", "n", which work the
" same way as the built-in |search()| call. Any other flags will be ignored.
"
function! sj#SearchUnderCursor(pattern, ...)
  let [match_start, match_end] = call('sj#SearchColsUnderCursor', [a:pattern] + a:000)
  if match_start > 0
    return match_start
  else
    return 0
  endif
endfunction

" function! sj#SearchColsUnderCursor(pattern, flags, skip) {{{2
"
" Searches for a match for the given pattern under the cursor. Returns the
" start and (end + 1) column positions of the match. If nothing was found,
" returns [0, 0].
"
" Moves the cursor unless the 'n' flag is given.
"
" Respects the skip expression if it's given.
"
" See sj#SearchUnderCursor for the behaviour of a:flags
"
function! sj#SearchColsUnderCursor(pattern, ...)
  if a:0 >= 1
    let given_flags = a:1
  else
    let given_flags = ''
  endif

  if a:0 >= 2
    let skip = a:2
  else
    let skip = ''
  endif

  let lnum        = line('.')
  let col         = col('.')
  let pattern     = a:pattern
  let extra_flags = ''

  " handle any extra flags provided by the user
  for char in ['e', 'p', 's']
    if stridx(given_flags, char) >= 0
      let extra_flags .= char
    endif
  endfor

  call sj#PushCursor()

  " find the start of the pattern
  call search(pattern, 'bcW', lnum)
  let search_result = sj#SearchSkip(pattern, skip, 'cW'.extra_flags, lnum)
  if search_result <= 0
    call sj#PopCursor()
    return [0, 0]
  endif

  call sj#PushCursor()

  " find the end of the pattern
  if stridx(extra_flags, 'e') >= 0
    let match_end = col('.')

    call sj#PushCursor()
    call sj#SearchSkip(pattern, skip, 'cWb', lnum)
    let match_start = col('.')
    call sj#PopCursor()
  else
    let match_start = col('.')
    call sj#SearchSkip(pattern, skip, 'cWe', lnum)
    let match_end = col('.')
  end

  " set the end of the pattern to the next character, or EOL. Extra logic
  " is for multibyte characters.
  normal! l
  if col('.') == match_end
    " no movement, we must be at the end
    let match_end = col('$')
  else
    let match_end = col('.')
  endif
  call sj#PopCursor()

  if !sj#ColBetween(col, match_start, match_end)
    " then the cursor is not in the pattern
    call sj#PopCursor()
    return [0, 0]
  else
    " a match has been found
    if stridx(given_flags, 'n') >= 0
      call sj#PopCursor()
    else
      call sj#DropCursor()
    endif

    return [match_start, match_end]
  endif
endfunction

" function! sj#SearchSkip(pattern, skip, ...) {{{2
" A partial replacement to search() that consults a skip pattern when
" performing a search, just like searchpair().
"
" Note that it doesn't accept the "n" and "c" flags due to implementation
" difficulties.
function! sj#SearchSkip(pattern, skip, ...)
  " collect all of our arguments
  let pattern = a:pattern
  let skip    = a:skip

  if a:0 >= 1
    let flags = a:1
  else
    let flags = ''
  endif

  if stridx(flags, 'n') > -1
    echoerr "Doesn't work with 'n' flag, was given: ".flags
    return
  endif

  let stopline = (a:0 >= 2) ? a:2 : 0
  let timeout  = (a:0 >= 3) ? a:3 : 0

  " Note: Native search() seems to hit a bug with one of the HTML tests
  " (because of \zs?)
  if skip == ''
    " no skip, can delegate to native search()
    return search(pattern, flags, stopline, timeout)
  " elseif has('patch-8.2.915')
  "   " the native search() function can do this now:
  "   return search(pattern, flags, stopline, timeout, skip)
  endif

  " search for the pattern, skipping a match if necessary
  let skip_match = 1
  while skip_match
    let match = search(pattern, flags, stopline, timeout)

    " remove 'c' flag for any run after the first
    let flags = substitute(flags, 'c', '', 'g')

    if match && eval(skip)
      let skip_match = 1
    else
      let skip_match = 0
    endif
  endwhile

  return match
endfunction

function! sj#SkipSyntax(syntax_groups)
  let syntax_groups = a:syntax_groups
  let skip_pattern  = '\%('.join(syntax_groups, '\|').'\)'

  return "synIDattr(synID(line('.'),col('.'),1),'name') =~ '".skip_pattern."'"
endfunction

function! sj#IncludeSyntax(syntax_groups)
  let syntax_groups = a:syntax_groups
  let include_pattern  = '\%('.join(syntax_groups, '\|').'\)'

  return "synIDattr(synID(line('.'),col('.'),1),'name') !~ '".include_pattern."'"
endfunction

" Checks if the current position of the cursor is within the given limits.
"
function! sj#CursorBetween(start, end)
  return sj#ColBetween(col('.'), a:start, a:end)
endfunction

" Checks if the given column is within the given limits.
"
function! sj#ColBetween(col, start, end)
  return a:start <= a:col && a:end > a:col
endfunction

" Regex helpers {{{1
"
" function! sj#ExtractRx(expr, pat, sub) {{{2
"
" Extract a regex match from a string. Ordinarily, substitute() would be used
" for this, but it's a bit too cumbersome for extracting a particular grouped
" match. Example usage:
"
"   sj#ExtractRx('foo:bar:baz', ':\(.*\):', '\1') == 'bar'
"
function! sj#ExtractRx(expr, pat, sub)
  let rx = a:pat

  if stridx(a:pat, '^') != 0
    let rx = '^.*'.rx
  endif

  if strridx(a:pat, '$') + 1 != strlen(a:pat)
    let rx = rx.'.*$'
  endif

  return substitute(a:expr, rx, a:sub, '')
endfunction

" Compatibility {{{1
"
" Functionality that is present in newer versions of Vim, but needs a
" compatibility layer for older ones.
"
" function! sj#Keeppatterns(command) {{{2
"
" Executes the given command, but attempts to keep search patterns as they
" were.
"
function! sj#Keeppatterns(command)
  if exists(':keeppatterns')
    exe 'keeppatterns '.a:command
  else
    let histnr = histnr('search')

    exe a:command

    if histnr != histnr('search')
      call histdel('search', -1)
      let @/ = histget('search', -1)
    endif
  endif
endfunction

" Splitjoin-specific helpers {{{1

" These functions are not general-purpose, but can be used all around the
" plugin disregarding filetype, so they have no place in the specific autoload
" files.

function! sj#Align(from, to, type)
  if a:from >= a:to
    return
  endif

  if exists('g:tabular_loaded')
    call s:Tabularize(a:from, a:to, a:type)
  elseif exists('g:loaded_AlignPlugin')
    call s:Align(a:from, a:to, a:type)
  endif
endfunction

function! s:Tabularize(from, to, type)
  if a:type == 'hashrocket'
    let pattern = '^[^=>]*\zs=>'
  elseif a:type == 'css_declaration' || a:type == 'json_object'
    let pattern = '^[^:]*:\s*\zs\s/l0'
  elseif a:type == 'lua_table'
    let pattern = '^[^=]*\zs='
  elseif a:type == 'when_then'
    let pattern = 'then'
  elseif a:type == 'equals'
    let pattern = '='
  else
    return
  endif

  exe a:from.",".a:to."Tabularize/".pattern
endfunction

function! s:Align(from, to, type)
  if a:type == 'hashrocket'
    let pattern = 'l: =>'
  elseif a:type == 'css_declaration' || a:type == 'json_object'
    let pattern = 'lp0W0 :\s*\zs'
  elseif a:type == 'when_then'
    let pattern = 'l: then'
  elseif a:type == 'equals'
    let pattern = '='
  else
    return
  endif

  exe a:from.",".a:to."Align! ".pattern
endfunction

" Returns a pair with the column positions of the closest opening and closing
" braces on the current line. The a:open and a:close parameters are the
" opening and closing brace characters to look for.
"
" The optional parameter is the list of syntax groups to skip while searching.
"
" If a pair is not found on the line, returns [-1, -1]
"
" Examples:
"
"   let [start, end] = sj#LocateBracesOnLine('{', '}')
"   let [start, end] = sj#LocateBracesOnLine('{', '}', ['rubyString'])
"   let [start, end] = sj#LocateBracesOnLine('[', ']')
"
function! sj#LocateBracesOnLine(open, close, ...)
  let [_bufnum, line, col, _off] = getpos('.')
  let search_pattern = '\V'.a:open.'\m.*\V'.a:close
  let current_line = line('.')

  " bail early if there's obviously no match
  if getline('.') !~ search_pattern
    return [-1, -1]
  endif

  " optional skip parameter
  if a:0 > 0
    let skip = sj#SkipSyntax(a:1)
  else
    let skip = ''
  endif

  " try looking backwards, then forwards
  let found = searchpair('\V'.a:open, '', '\V'.a:close, 'cb', skip, line('.'))
  if found <= 0
    let found = sj#SearchSkip(search_pattern, skip, '', line('.'))
  endif

  if found > 0
    let from = col('.')

    normal! %
    if line('.') != current_line
      return [-1, -1]
    endif

    let to = col('.')

    return [from, to]
  else
    return [-1, -1]
  endif
endfunction

" Returns a pair with the column positions of the closest opening and closing
" braces on the current line, but only if the cursor is between them.
"
" The optional parameter is the list of syntax groups to skip while searching.
"
" If a pair is not found around the cursor, returns [-1, -1]
"
" Examples:
"
"   let [start, end] = sj#LocateBracesAroundCursor('{', '}')
"   let [start, end] = sj#LocateBracesAroundCursor('{', '}', ['rubyString'])
"   let [start, end] = sj#LocateBracesAroundCursor('[', ']')
"
function! sj#LocateBracesAroundCursor(open, close, ...)
  let args = [a:open, a:close]
  if a:0 > 0
    call extend(args, a:000)
  endif

  call sj#PushCursor()
  let [start, end] = call('sj#LocateBracesOnLine', args)
  call sj#PopCursor()

  if sj#CursorBetween(start, end)
    return [start, end]
  else
    return [-1, -1]
  endif
endfunction

" Removes all extra whitespace on the current line. Such is often left when
" joining lines that have been aligned.
"
"   Example:
"
"     var one = { one:   "two", three: "four" };
"     " turns into:
"     var one = { one: "two", three: "four" };
"
function! sj#CompressWhitespaceOnLine()
  call sj#PushCursor()
  call sj#Keeppatterns('s/\S\zs \+/ /g')
  call sj#PopCursor()
endfunction

" Parses a JSON-like object and returns a list of its components
" (comma-separated parts).
"
" Note that a:from and a:to are the start and end of the body, not the curly
" braces that usually define a JSON object. This makes it possible to use the
" function for parsing an argument list into separate arguments, knowing their
" start and end.
"
" Different languages have different rules for delimiters, so it might be a
" better idea to write a specific parser. See autoload/sj/argparser/json.vim
" for inspiration.
"
function! sj#ParseJsonObjectBody(from, to)
  " Just use js object parser
  let parser = sj#argparser#json#Construct(a:from, a:to, getline('.'))
  call parser.Process()
  return parser.args
endfunction

" Jumps over nested brackets until it reaches the given pattern.
"
" Special handling for "<" for Rust (for now), but this only matters if it's
" provided in the `a:opening_brackets`
"
function! sj#JumpBracketsTill(end_pattern, brackets)
  let opening_brackets = a:brackets['opening']
  let closing_brackets = a:brackets['closing']

  try
    " ensure we can't go to the next line:
    let saved_whichwrap = &whichwrap
    set whichwrap-=l
    " ensure we can go to the very end of the line
    let saved_virtualedit = &virtualedit
    set virtualedit=onemore

    let remainder_of_line = s:RemainderOfLine()
    while remainder_of_line !~ '^'.a:end_pattern
          \ && remainder_of_line !~ '^\s*$'
      let [opening_bracket_match, offset] = s:BracketMatch(remainder_of_line, opening_brackets)
      let [closing_bracket_match, _]      = s:BracketMatch(remainder_of_line, closing_brackets)

      if opening_bracket_match < 0 && closing_bracket_match >= 0
        let closing_bracket = closing_brackets[closing_bracket_match]

        if closing_bracket == '>'
          " an unmatched > in this context means comparison, so do nothing
        else
          " there's an extra closing bracket from outside the list, bail out
          break
        endif
      elseif opening_bracket_match >= 0
        " then try to jump to the closing bracket
        let opening_bracket = opening_brackets[opening_bracket_match]
        let closing_bracket = closing_brackets[opening_bracket_match]

        " first, go to the opening bracket
        if offset > 0
          exe "normal! ".offset."l"
        end

        if opening_bracket == closing_bracket
          " same bracket (quote), search for it, unless it's escaped
          call search('\\\@<!\V'.closing_bracket, 'W', line('.'))
        else
          " different closing, use searchpair
          call searchpair('\V'.opening_bracket, '', '\V'.closing_bracket, 'W', '', line('.'))
        endif
      endif

      normal! l
      let remainder_of_line = s:RemainderOfLine()
      if remainder_of_line =~ '^$'
        " we have no more content, the current column is the end of the expression
        return col('.')
      endif
    endwhile

    " we're past the final column of the expression, so return the previous
    " one:
    return col('.') - 1
  finally
    let &whichwrap = saved_whichwrap
    let &virtualedit = saved_virtualedit
  endtry
endfunction

function! s:RemainderOfLine()
  return strpart(getline('.'), col('.') - 1)
endfunction

function! s:BracketMatch(text, brackets)
  let index  = 0
  let offset = match(a:text, '^\s*\zs')
  let text   = strpart(a:text, offset)

  for char in split(a:brackets, '\zs')
    if text[0] ==# char
      return [index, offset]
    else
      let index += 1
    endif
  endfor

  return [-1, 0]
endfunction
