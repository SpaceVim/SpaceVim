"=============================================================================
" FILE: autoload/echodoc/util.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
"          Tommy Allen <tommy@esdf.io>
" License: MIT license
"=============================================================================

" Return the next column and character at the column position in text.  Keep
" scanning until a usable character is found.  This should be safe for
" multi-byte characters.
function! s:mbprevchar(text, col) abort
  if a:col < 0
    return [a:col, '']
  endif
  let c = matchstr(a:text, '\%'.a:col.'c.')
  let c1 = a:col - 1
  while c1 > 0 && c ==# ''
    let c = matchstr(a:text, '\%'.c1.'c.')
    let c1 -= 1
  endwhile
  return [c1, c]
endfunction

" Try to find a function at the current position.
" Stops if `echodoc_max_blank_lines` is encountered. (max 50)
function! echodoc#util#get_func_text() abort
  let l2 = line('.')
  let c2 = col('.') - 1
  let l1 = l2
  let c1 = c2

  let skip = 0
  let last_quote = ''
  let text = getline(l1)[: c2-1]
  let found = 0
  let line_guard = 0
  let blank = 0
  let max_blank = max([1, get(b:, 'echodoc_max_blank_lines',
        \ get(g:, 'echodoc_max_blank_lines', 1))])
  let max_guard = get(b:, 'echodoc_max_line_guard',
        \ get(g:, 'echodoc_max_line_guard', 5))

  let check_quotes = s:check_quotes()

  while l1 > 0 && line_guard < max_guard && blank < max_blank
    if c1 <= 0
      let l1 -= 1
      let c1 = col([l1, '$'])
      let text = getline(l1)
      if text ==# ''
        let blank += 1
      else
        let blank = 0
      endif
      let line_guard += 1

      " Clear last quote
      let last_quote = ''
      continue
    endif

    if len(text) >= &l:columns
      break
    endif

    let [c1, c] = s:mbprevchar(text, c1)
    let p = ''

    if c1 > 0
      let [_, p] = s:mbprevchar(text, c1)
      if p ==# '\'
        continue
      endif
    endif

    if c =~# '\s'
      " Skip
      continue
    endif

    if last_quote ==# '' && index(check_quotes, c) >= 0
      let last_quote = c
      continue
    elseif last_quote !=# ''
      if last_quote == c
        let last_quote = ''
      endif
      continue
    endif

    if c ==# '('
      if skip == 0
        if p =~# '\k\|\s'
          let found = 1
          break
        endif
      else
        let skip -= 1
      endif
    elseif c ==# ')'
      let skip += 1
    endif
  endwhile

  if (found || last_quote !=# '') && l1 > 0 && c1 > 0
    let lines = getline(l1, l2)
    let lines[-1] = c2 == 0 ? '' : lines[-1][:c2 - 1]
    let lines[0] = c1 == 0 ? '' : matchstr(lines[0], '\k\+\%>'.(c1 - 1).'c.*')
    return [l1, c1, join(lines, "\n")]
  endif

  return [-1, -1, '']
endfunction

" Returns a parsed stack of functions found in the text.  Each item in the
" stack contains a dict:
" - name: Function name.
" - start: Argument start position.
" - end: Argument end position.  -1 if the function is unclosed.
" - pos: The argument position.  1-indexed, 0 = no args, -1 = closed.
" - ppos: The function's position in the previous function in the stack.
" - args: A list of arguments.
function! echodoc#util#parse_funcs(text, filetype) abort
  if a:text ==# ''
    return []
  endif

  let text = a:text

  " Function pointer pattern.
  " Example: int32_t get(void *const, const size_t)
  let text = substitute(text, '\s*(\*)\s*', '', 'g')
  let text = substitute(text, '^(\(.*\))$', '\1', '')
  let text = substitute(text, '\s\+\ze(', '', '')

  " Template arguments pattern.
  let text = substitute(text, '<\zs[^(]*\ze>', '...', 'g')

  let quote_i = -1
  let stack = []
  let open_stack = []
  let comma = 0

  " Matching pairs will count as a single argument entry so that commas can be
  " skipped within them.  The open depth is tracked in each open stack item.
  " Parenthesis is an exception since it's used for functions and can have a
  " depth of 1.
  let pairs = '({[)}]'
  let l = len(text) - 1
  let i = -1

  let check_quotes = s:check_quotes()

  while i < l
    let i += 1
    let c = text[i]

    if i > 0 && text[i - 1] ==# '\'
      continue
    endif

    if quote_i != -1
      " For languages that allow '''' ?
      " if c == "'" && text[i - 1] == c && i - quote_i > 1
      "   continue
      " endif
      if c == text[quote_i]
        let quote_i = -1
      endif
      continue
    endif

    if quote_i == -1 && index(check_quotes, c) >= 0
      " backtick (`) is not used alone in languages that I know of.
      let quote_i = i
      continue
    endif

    let prev = len(open_stack) ? open_stack[-1] : {'opens': [0, 0, 0]}
    let opened = prev.opens[0] + prev.opens[1] + prev.opens[2]

    let p = stridx(pairs, c)
    if p != -1
      let ci = p % 3
      if p == 3 && opened == 1 && prev.opens[0] == 1
        " Closing the function parenthesis
        if !empty(open_stack)
          let item = remove(open_stack, -1)
          let item.end = i - 1
          let item.pos = -1
          let item.opens[0] -= 1
          if comma <= i
            call add(item.args, text[comma :i - 1])
          endif
          let comma = item.i
        endif
      elseif p == 0
        " Opening parenthesis
        let func_i = match(text[:i - 1], '\S', comma)
        let func_name = matchstr(substitute(text[func_i :i - 1],
              \ '<[^>]*>', '', 'g'), '\k\+$')

        if func_i != -1 && func_i < i && func_name !=# ''
          let ppos = 0
          if !empty(open_stack)
            let ppos = open_stack[-1].pos
          endif

          if func_name !=# ''
            " Opening parenthesis that's preceded by a non-empty string.
            call add(stack, {
                  \ 'name': func_name,
                  \ 'i': func_i,
                  \ 'start': i + 1,
                  \ 'end': -1,
                  \ 'pos': 0,
                  \ 'ppos': ppos,
                  \ 'args': [],
                  \ 'opens': [1, 0, 0]
                  \ })
            call add(open_stack, stack[-1])

            " Function opening parenthesis marks the beginning of arguments.
            " let comma = i + 1
            let comma = i + 1
          endif
        else
          let prev.opens[0] += 1
        endif
      else
        let prev.opens[ci] += p > 2 ? -1 : 1
      endif
    elseif opened == 1 && prev.opens[0] == 1 && c ==# ','
      " Not nested in a pair.
      if !empty(open_stack) && comma <= i
        let open_stack[-1].pos += 1
        call add(open_stack[-1].args, text[comma :i - 1])
      endif
      let comma = i + 1
    endif
  endwhile

  if !empty(open_stack)
    let item = open_stack[-1]
    call add(item.args, text[comma :l])
    let item.pos += 1
  endif

  if index(['python', 'rust'], a:filetype) >= 0
    " Remove self argument
    let expr = a:filetype ==# 'python' ?
          \ "v:val !=# 'self'" :
          \ "index(['self', '&self', '&mut self'], v:val) < 0"
    for item in stack
      call filter(item.args, expr)
    endfor

    if !empty(stack) && !empty(stack[-1].args)
      " Remove heading spaces
      let stack[-1].args[0] = substitute(stack[-1].args[0], '^\s\+', '', '')
    endif
  endif

  if !empty(stack) && stack[-1].opens[0] == 0
    let item = stack[-1]
    let item.trailing = matchstr(text, '\s*\zs\p*', item.end + 2)
  endif

  return stack
endfunction


function! echodoc#util#completion_signature(completion, maxlen, filetype) abort
  if empty(a:completion)
    return {}
  endif

  let item = a:completion
  let abbrs = []
  if type(get(item, 'user_data', 0)) ==# v:t_string && item.user_data !=# ''
    let user_data = {}
    silent! let user_data = json_decode(item.user_data)
    if type(user_data) == v:t_dict && has_key(user_data, 'signature')
      call add(abbrs, user_data.signature)
    endif
  endif
  if get(item, 'info', '') =~# '^.\+(.*)'
    call add(abbrs, matchstr(item.info, '^\_s*\zs.*'))
  endif
  if get(item, 'kind', '') =~# '^.\+(.*)'
    call add(abbrs, item.kind)
  endif
  if get(item, 'menu', '') =~# '^.\+(.*)'
    call add(abbrs, item.menu)
  endif
  if get(item, 'abbr', '') =~# '^.\+(.*)'
    call add(abbrs, item.abbr)
  endif
  if item.word =~# '^.\+(.*)' || get(item, 'kind', '') ==# 'f'
    call add(abbrs, item.word)
  endif

  let stack = []
  for info in abbrs
    let info = info[:a:maxlen]
    let stack = echodoc#util#parse_funcs(info, a:filetype)
    if !empty(stack)
      break
    endif
  endfor

  if empty(stack)
    return {}
  endif

  let comp = stack[0]
  let word = matchstr(a:completion.word, '\k\+\ze[()]*')
  if index(['go', 'rust'], a:filetype) >= 0 && word !=# '' && comp.name !=# word
    " Note: It is for Rust and Go only.

    " Completion 'word' is what actually completed, if the parsed name is
    " different, it's probably because 'info' is an abstract function
    " signature.  .e.g in Go:
    " completed: BoolVar(p *bool, name string, value bool, usage string)
    " info:      func(p *bool, name string, value bool, usage string)
    let comp.name = word
  endif
  return comp
endfunction

function! s:check_quotes() abort
  " Note: It is very ugly check...
  " Rust contains quoting pattern like "fn from(s: &'s str) -> String"
  return &filetype !=# 'rust' ? ['"', '`', "'"] : ['"', '`']
endfunction
