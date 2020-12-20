" File:        autoload/delimitMate.vim
" Version:     2.7
" Modified:    2013-07-15
" Description: This plugin provides auto-completion for quotes, parens, etc.
" Maintainer:  Israel Chauca F. <israelchauca@gmail.com>
" Manual:      Read ":help delimitMate".
" ============================================================================

"let delimitMate_loaded = 1

if !exists('s:options')
  let s:options = {}
endif

function! s:set(name, value, ...) "{{{
  let scope = a:0 ? a:1 : 's'
  let bufnr = bufnr('%')
  if !exists('s:options[bufnr]')
    let s:options[bufnr] = {}
  endif
  if scope == 's'
    let name = 's:options.' . bufnr . '.' . a:name
  else
    let name = scope . ':delimitMate_' . a:name
    if exists('name')
      exec 'unlet! ' . name
    endif
  endif
  exec 'let ' . name . ' = a:value'
endfunction "}}}

function! s:get(name, ...) "{{{
  if a:0 == 2
    return deepcopy(get(a:2, 'delimitMate_' . a:name, a:1))
  elseif a:0 == 1
    let bufoptions = get(s:options, bufnr('%'), {})
    return deepcopy(get(bufoptions, a:name, a:1))
  else
    return deepcopy(eval('s:options.' . bufnr('%') . '.' . a:name))
  endif
endfunction "}}}

function! s:exists(name, ...) "{{{
  let scope = a:0 ? a:1 : 's'
  if scope == 's'
    let bufnr = bufnr('%')
    let name = 'options.' . bufnr . '.' . a:name
  else
    let name = 'delimitMate_' . a:name
  endif
  return exists(scope . ':' . name)
endfunction "}}}

function! s:is_jump(...) "{{{
  " Returns 1 if the next character is a closing delimiter.
  let char = s:get_char(0)
  let list = s:get('right_delims') + s:get('quotes_list')

  " Closing delimiter on the right.
  if (!a:0 && index(list, char) > -1)
        \ || (a:0 && char == a:1)
    return 1
  endif

  " Closing delimiter with space expansion.
  let nchar = s:get_char(1)
  if !a:0 && s:get('expand_space') && char == " "
    if index(list, nchar) > -1
      return 2
    endif
  elseif a:0 && s:get('expand_space') && nchar == a:1 && char == ' '
    return 3
  endif

  if !s:get('jump_expansion')
    return 0
  endif

  " Closing delimiter with CR expansion.
  let uchar = matchstr(getline(line('.') + 1), '^\s*\zs\S')
  if !a:0 && s:get('expand_cr') && char == ""
    if index(list, uchar) > -1
      return 4
    endif
  elseif a:0 && s:get('expand_cr') && uchar == a:1
    return 5
  endif
  return 0
endfunction "}}}

function! s:rquote(char) "{{{
  let pos = matchstr(getline('.')[col('.') : ], escape(a:char, '[]*.^$\'), 1)
  let i = 0
  while s:get_char(i) ==# a:char
    let i += 1
  endwhile
  return i
endfunction "}}}

function! s:lquote(char) "{{{
  let i = 0
  while s:get_char(i - 1) ==# a:char
    let i -= 1
  endwhile
  return i * -1
endfunction "}}}

function! s:get_char(...) "{{{
  let idx = col('.') - 1
  if !a:0 || (a:0 && a:1 >= 0)
    " Get char from cursor.
    let line = getline('.')[idx :]
    let pos = a:0 ? a:1 : 0
    return matchstr(line, '^'.repeat('.', pos).'\zs.')
  endif
  " Get char behind cursor.
  let line = getline('.')[: idx - 1]
  let pos = 0 - (1 + a:1)
  return matchstr(line, '.\ze'.repeat('.', pos).'$')
endfunction "s:get_char }}}

function! s:is_cr_expansion(...) " {{{
  let nchar = getline(line('.')-1)[-1:]
  let schar = matchstr(getline(line('.')+1), '^\s*\zs\S')
  let isEmpty = a:0 ? getline('.') =~ '^\s*$' : empty(getline('.'))
  if index(s:get('left_delims'), nchar) > -1
        \ && index(s:get('left_delims'), nchar)
        \    == index(s:get('right_delims'), schar)
        \ && isEmpty
    return 1
  elseif index(s:get('quotes_list'), nchar) > -1
        \ && index(s:get('quotes_list'), nchar)
        \    == index(s:get('quotes_list'), schar)
        \ && isEmpty
    return 1
  else
    return 0
  endif
endfunction " }}} s:is_cr_expansion()

function! s:is_space_expansion() " {{{
  if col('.') > 2
    let pchar = s:get_char(-2)
    let nchar = s:get_char(1)
    let isSpaces =
          \ (s:get_char(-1)
          \   == s:get_char(0)
          \ && s:get_char(-1) == " ")

    if index(s:get('left_delims'), pchar) > -1 &&
        \ index(s:get('left_delims'), pchar)
        \   == index(s:get('right_delims'), nchar) &&
        \ isSpaces
      return 1
    elseif index(s:get('quotes_list'), pchar) > -1 &&
        \ index(s:get('quotes_list'), pchar)
        \   == index(s:get('quotes_list'), nchar) &&
        \ isSpaces
      return 1
    endif
  endif
  return 0
endfunction " }}} IsSpaceExpansion()

function! s:is_empty_matchpair() "{{{
  " get char before the cursor.
  let open = s:get_char(-1)
  let idx = index(s:get('left_delims'), open)
  if idx == -1
    return 0
  endif
  let close = get(s:get('right_delims'), idx, '')
  return close ==# s:get_char(0)
endfunction "}}}

function! s:is_empty_quotes() "{{{
  " get char before the cursor.
  let quote = s:get_char(-1)
  let idx = index(s:get('quotes_list'), quote)
  if idx == -1
    return 0
  endif
  return quote ==# s:get_char(0)
endfunction "}}}

function! s:cursor_idx() "{{{
  let idx = len(split(getline('.')[: col('.') - 1], '\zs')) - 1
  return idx
endfunction "delimitMate#CursorCol }}}

function! s:get_syn_name() "{{{
  let col = col('.')
  if  col == col('$')
    let col = col - 1
  endif
  return synIDattr(synIDtrans(synID(line('.'), col, 1)), 'name')
endfunction " }}}

function! s:is_excluded_ft(ft) "{{{
  if !exists("g:delimitMate_excluded_ft")
    return 0
  endif
  return index(split(g:delimitMate_excluded_ft, ','), a:ft, 0, 1) >= 0
endfunction "}}}

function! s:is_forbidden(char) "{{{
  if s:is_excluded_ft(&filetype)
    return 1
  endif
  if !s:get('excluded_regions_enabled')
    return 0
  endif
  let region = s:get_syn_name()
  return index(s:get('excluded_regions_list'), region) >= 0
endfunction "}}}

function! s:balance_matchpairs(char) "{{{
  " Returns:
  " = 0 => Parens balanced.
  " > 0 => More opening parens.
  " < 0 => More closing parens.

  let line = getline('.')
  let col = s:cursor_idx() - 1
  let col = col >= 0 ? col : 0
  let list = split(line, '\zs')
  let left = s:get('left_delims')[index(s:get('right_delims'), a:char)]
  let right = a:char
  let opening = 0
  let closing = 0

  " If the cursor is not at the beginning, count what's behind it.
  if col > 0
      " Find the first opening paren:
      let start = index(list, left)
      " Must be before cursor:
      let start = start < col ? start : col - 1
      " Now count from the first opening until the cursor, this will prevent
      " extra closing parens from being counted.
      let opening = count(list[start : col - 1], left)
      let closing = count(list[start : col - 1], right)
      " I don't care if there are more closing parens than opening parens.
      let closing = closing > opening ? opening : closing
  endif

  " Evaluate parens from the cursor to the end:
  let opening += count(list[col :], left)
  let closing += count(list[col :], right)

  " Return the found balance:
  return opening - closing
endfunction "}}}

function! s:is_smart_quote(char) "{{{
  " TODO: Allow using a:char in the pattern.
  let tmp = s:get('smart_quotes')
  if empty(tmp)
    return 0
  endif
  let regex = matchstr(tmp, '^!\?\zs.*')
  " Flip matched value if regex starts with !
  let mod = tmp =~ '^!' ? [1, 0] : [0, 1]
  let matched = search(regex, 'ncb', line('.')) > 0
  let noescaped = substitute(getline('.'), '\\.', '', 'g')
  let odd =  (count(split(noescaped, '\zs'), a:char) % 2)
  let result = mod[matched] || odd
  return result
endfunction "delimitMate#SmartQuote }}}

function! delimitMate#Set(...) "{{{
  return call('s:set', a:000)
endfunction "}}}

function! delimitMate#Get(...) "{{{
  return call('s:get', a:000)
endfunction "}}}

function! delimitMate#ShouldJump(...) "{{{
  return call('s:is_jump', a:000)
endfunction "}}}

function! delimitMate#IsEmptyPair(str) "{{{
  if strlen(substitute(a:str, ".", "x", "g")) != 2
    return 0
  endif
  let idx = index(s:get('left_delims'), matchstr(a:str, '^.'))
  if idx > -1 &&
        \ s:get('right_delims')[idx] == matchstr(a:str, '.$')
    return 1
  endif
  let idx = index(s:get('quotes_list'), matchstr(a:str, '^.'))
  if idx > -1 &&
        \ s:get('quotes_list')[idx] == matchstr(a:str, '.$')
    return 1
  endif
  return 0
endfunction "}}}

function! delimitMate#WithinEmptyPair() "{{{
  " if cursor is at column 1 return 0
  if col('.') == 1
    return 0
  endif
  " get char before the cursor.
  let char1 = s:get_char(-1)
  " get char under the cursor.
  let char2 = s:get_char(0)
  return delimitMate#IsEmptyPair( char1.char2 )
endfunction "}}}

function! delimitMate#SkipDelim(char) "{{{
  if s:is_forbidden(a:char)
    return a:char
  endif
  let col = col('.') - 1
  let line = getline('.')
  if col > 0
    let cur = s:get_char(0)
    let pre = s:get_char(-1)
  else
    let cur = s:get_char(0)
    let pre = ""
  endif
  if pre == "\\"
    " Escaped character
    return a:char
  elseif cur == a:char
    " Exit pair
    return a:char . "\<Del>"
  elseif delimitMate#IsEmptyPair( pre . a:char )
    " Add closing delimiter and jump back to the middle.
    return a:char . s:joinUndo() . "\<Left>"
  else
    " Nothing special here, return the same character.
    return a:char
  endif
endfunction "}}}

function! delimitMate#ParenDelim(right) " {{{
  let left = s:get('left_delims')[index(s:get('right_delims'),a:right)]
  if s:is_forbidden(a:right)
    return left
  endif
  " Try to balance matchpairs
  if s:get('balance_matchpairs') &&
        \ s:balance_matchpairs(a:right) < 0
    return left
  endif
  let line = getline('.')
  let col = col('.')-2
  if s:get('smart_matchpairs') != ''
    let smart_matchpairs = substitute(s:get('smart_matchpairs'), '\\!', left, 'g')
    let smart_matchpairs = substitute(smart_matchpairs, '\\#', a:right, 'g')
    if line[col+1:] =~ smart_matchpairs
      return left
    endif
  endif
  if len(line) == (col + 1) && s:get('insert_eol_marker') == 1
    let tail = s:get('eol_marker')
  else
    let tail = ''
  endif
  return left . a:right . tail . repeat(s:joinUndo() . "\<Left>", len(split(tail, '\zs')) + 1)
endfunction " }}}

function! delimitMate#QuoteDelim(char) "{{{
  if s:is_forbidden(a:char)
    return a:char
  endif
  let char_at = s:get_char(0)
  let char_before = s:get_char(-1)
  let nesting_on = index(s:get('nesting_quotes'), a:char) > -1
  let left_q = nesting_on ? s:lquote(a:char) : 0
  if nesting_on && left_q > 1
    " Nesting quotes.
    let right_q =  s:rquote(a:char)
    let quotes = right_q > left_q + 1 ? 0 : left_q - right_q + 2
    let lefts = quotes - 1
    return repeat(a:char, quotes) . repeat(s:joinUndo() . "\<Left>", lefts)
  elseif char_at == a:char
    " Inside an empty pair, jump out
    return a:char . "\<Del>"
  elseif a:char == '"' && index(split(&ft, '\.'), "vim") != -1 && getline('.') =~ '^\s*$'
    " If we are in a vim file and it looks like we're starting a comment, do
    " not add a closing char.
    return a:char
  elseif s:is_smart_quote(a:char)
    " Seems like a smart quote, insert a single char.
    return a:char
  elseif (char_before == a:char && char_at != a:char)
        \ && !empty(s:get('smart_quotes'))
    " Seems like we have an unbalanced quote, insert one quotation
    " mark and jump to the middle.
    return a:char . s:joinUndo() . "\<Left>"
  else
    " Insert a pair and jump to the middle.
    let sufix = ''
    if !empty(s:get('eol_marker')) && col('.') - 1 == len(getline('.'))
      let idx = len(s:get('eol_marker')) * -1
      let marker = getline('.')[idx : ]
      let has_marker = marker == s:get('eol_marker')
      let sufix = !has_marker ? s:get('eol_marker') : ''
    endif
    return a:char . a:char . s:joinUndo() . "\<Left>"
  endif
endfunction "}}}

function! delimitMate#JumpOut(char) "{{{
  if s:is_forbidden(a:char)
    return a:char
  endif
  let jump = s:is_jump(a:char)
  if jump == 1
    " HACK: Instead of <Right>, we remove the char to be jumped over and
    " insert it again. This will trigger re-indenting via 'indentkeys'.
    " Ref: https://github.com/Raimondi/delimitMate/issues/168
    return "\<Del>".a:char
  elseif jump == 3
    return s:joinUndo() . "\<Right>" . s:joinUndo() . "\<Right>"
  elseif jump == 5
    return "\<Down>\<C-O>I" . s:joinUndo() . "\<Right>"
  else
    return a:char
  endif
endfunction " }}}

function! delimitMate#JumpAny(...) " {{{
  if s:is_forbidden('')
    return ''
  endif
  if !s:is_jump()
    return ''
  endif
  " Let's get the character on the right.
  let char = s:get_char(0)
  if char == " "
    " Space expansion.
    return s:joinUndo() . "\<Right>" . s:joinUndo() . "\<Right>"
  elseif char == ""
    " CR expansion.
    return "\<CR>" . getline(line('.') + 1)[0] . "\<Del>\<Del>"
  else
    return s:joinUndo() . "\<Right>"
  endif
endfunction " delimitMate#JumpAny() }}}

function! delimitMate#JumpMany() " {{{
  let line = split(getline('.')[col('.') - 1 : ], '\zs')
  let rights = ""
  let found = 0
  for char in line
    if index(s:get('quotes_list'), char) >= 0 ||
          \ index(s:get('right_delims'), char) >= 0
      let rights .= s:joinUndo() . "\<Right>"
      let found = 1
    elseif found == 0
      let rights .= s:joinUndo() . "\<Right>"
    else
      break
    endif
  endfor
  if found == 1
    return rights
  else
    return ''
  endif
endfunction " delimitMate#JumpMany() }}}

function! delimitMate#ExpandReturn() "{{{
  if s:is_forbidden("")
    return "\<CR>"
  endif
  let escaped = s:cursor_idx() >= 2
        \ && s:get_char(-2) == '\'
  let expand_right_matchpair = s:get('expand_cr') == 2
        \     && index(s:get('right_delims'), s:get_char(0)) > -1
  let expand_inside_quotes = s:get('expand_inside_quotes')
          \     && s:is_empty_quotes()
          \     && !escaped
  let is_empty_matchpair = s:is_empty_matchpair()
  if !pumvisible(  )
        \ && (   is_empty_matchpair
        \     || expand_right_matchpair
        \     || expand_inside_quotes)
    let val = "\<Esc>a"
    if is_empty_matchpair && s:get('insert_eol_marker') == 2
          \ && !search(escape(s:get('eol_marker'), '[]\.*^$').'$', 'cnW', '.')
      let tail = getline('.')[col('.') - 1 : ]
      let times = len(split(tail, '\zs'))
      let val .= repeat(s:joinUndo() . "\<Right>", times) . s:get('eol_marker') . repeat(s:joinUndo() . "\<Left>", times + 1)
    endif
    let val .= "\<CR>"
    if &smartindent && !&cindent && !&indentexpr
          \ && s:get_char(0) == '}'
      " indentation is controlled by 'smartindent', and the first character on
      " the new line is '}'. If this were typed manually it would reindent to
      " match the current line. Let's reproduce that behavior.
      let shifts = indent('.') / &sw
      let spaces = indent('.') - (shifts * &sw)
      let val .= "^\<C-D>".repeat("\<C-T>", shifts).repeat(' ', spaces)
    endif
    " Expand:
    " XXX zv prevents breaking expansion with syntax folding enabled by
    " InsertLeave.
    let val .= "\<Esc>zvO"
    return val
  else
    return "\<CR>"
  endif
endfunction "}}}

function! delimitMate#ExpandSpace() "{{{
  if s:is_forbidden("\<Space>")
    return "\<Space>"
  endif
  let escaped = s:cursor_idx() >= 2
        \ && s:get_char(-2) == '\'
  let expand_inside_quotes = s:get('expand_inside_quotes')
          \     && s:is_empty_quotes()
          \     && !escaped
  if s:is_empty_matchpair() || expand_inside_quotes
    " Expand:
    return "\<Space>\<Space>" . s:joinUndo() . "\<Left>"
  else
    return "\<Space>"
  endif
endfunction "}}}

function! delimitMate#BS() " {{{
  if s:is_forbidden("")
    let extra = ''
  elseif &bs !~ 'start\|2'
    let extra = ''
  elseif delimitMate#WithinEmptyPair()
    let extra = "\<Del>"
  elseif s:is_space_expansion()
    let extra = "\<Del>"
  elseif s:is_cr_expansion()
    let extra = repeat("\<Del>",
          \ len(matchstr(getline(line('.') + 1), '^\s*\S')))
  else
    let extra = ''
  endif
  return "\<BS>" . extra
endfunction " }}} delimitMate#BS()

function! delimitMate#Test() "{{{
  %d _
  " Check for script options:
  let result = [
        \ 'delimitMate Report',
        \ '==================',
        \ '',
        \ '* Options: ( ) default, (g) global, (b) buffer',
        \ '']
  for option in sort(keys(s:options[bufnr('%')]))
    if s:exists(option, 'b')
      let scope = '(b)'
    elseif s:exists(option, 'g')
      let scope = '(g)'
    else
      let scope = '( )'
    endif
    call add(result,
          \ scope . ' delimitMate_' . option
          \ . ' = '
          \ . string(s:get(option)))
  endfor
  call add(result, '')

  let option = 'delimitMate_excluded_ft'
  call add(result,
        \(exists('g:'.option) ? '(g) ' : '( ) g:') . option . ' = '
        \. string(get(g:, option, '')))

  call add(result, '--------------------')
  call add(result, '')

  " Check if mappings were set.
  let left_delims = s:get('autoclose') ? s:get('left_delims') : []
  let special_keys = ['<BS>', '<S-BS>', '<S-Tab>', '<C-G>g']
  if s:get('expand_cr')
    call add(special_keys, '<CR>')
  endif
  if s:get('expand_space')
    call add(special_keys, '<Space>')
  endif
  let maps =
        \ s:get('right_delims')
        \ + left_delims
        \ + s:get('quotes_list')
        \ + s:get('apostrophes_list')
        \ + special_keys

  call add(result, '* Mappings:')
  call add(result, '')
  for map in maps
    let output = ''
    if map == '|'
      let map = '<Bar>'
    endif
    redir => output | execute "verbose imap ".map | redir END
    call extend(result, split(output, '\n'))
  endfor

  call add(result, '--------------------')
  call add(result, '')
  call add(result, '* Showcase:')
  call add(result, '')
  call setline(1, result)
  call s:test_mappings(s:get('left_delims'), 1)
  call s:test_mappings(s:get('quotes_list'), 0)

  let result = []
  redir => setoptions
  echo " * Vim configuration:\<NL>"
  filetype
  echo ""
  set
  version
  redir END
  call extend(result, split(setoptions,"\n"))
  call add(result, '--------------------')
  setlocal nowrap
  call append('$', result)
  call feedkeys("\<Esc>\<Esc>", 'n')
endfunction "}}}

function! s:test_mappings(list, is_matchpair) "{{{
  let prefix = "normal Go0\<C-D>"
  let last = "|"
  let open = s:get('autoclose') ? 'Open: ' : 'Open & close: '
  for s in a:list
    if a:is_matchpair
      let pair = s:get('right_delims')[index(s:get('left_delims'), s)]
    else
      let pair = s
    endif
    if !s:get('autoclose')
      let s .= pair
    endif
    exec prefix . open . s . last
    exec prefix . "Delete: " . s . "\<BS>" . last
    exec prefix . "Exit: " . s . pair . last
    if s:get('expand_space')
          \ && (a:is_matchpair || s:get('expand_inside_quotes'))
      exec prefix . "Space: " . s . " " . last
      exec prefix . "Delete space: " . s . " \<BS>" . last
    endif
    if s:get('expand_cr')
          \ && (a:is_matchpair || s:get('expand_inside_quotes'))
      exec prefix . "Car return: " . s . "\<CR>" . last
      exec prefix . "Delete car return: " . s . "\<CR>0\<C-D>\<BS>" . last
    endif
    call append('$', '')
  endfor
endfunction "}}}

function! s:joinUndo() "{{{
  if v:version < 704
        \ || ( v:version == 704 && !has('patch849') )
    return ''
  endif
  return "\<C-G>U"
endfunction "}}}

" vim:foldmethod=marker:foldcolumn=4:ts=2:sw=2
