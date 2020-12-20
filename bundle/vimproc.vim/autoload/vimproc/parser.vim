"=============================================================================
" FILE: parser.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" For vimshell parser.
function! vimproc#parser#parse_pipe(statement) abort "{{{
  let commands = []
  for cmdline in vimproc#parser#split_pipe(a:statement)
    " Split args.
    let cmdline = s:parse_cmdline(cmdline)

    " Parse redirection.
    if cmdline =~ '[<>]'
      let [fd, cmdline] = s:parse_redirection(cmdline)
    else
      let fd = { 'stdin' : '', 'stdout' : '', 'stderr' : '' }
    endif

    for key in ['stdout', 'stderr']
      if fd[key] == '' || fd[key] =~ '^>'
        continue
      endif

      if fd[key] ==# '/dev/clip'
        " Clear.
        let @+ = ''
      elseif fd[key] ==# '/dev/quickfix'
        " Clear quickfix.
        call setqflist([])
      endif
    endfor

    call add(commands, {
          \ 'args' : vimproc#parser#split_args(cmdline),
          \ 'fd' : fd
          \})
  endfor

  return commands
endfunction"}}}
function! s:parse_cmdline(cmdline) abort "{{{
  let cmdline = a:cmdline

  " Expand block.
  if cmdline =~ '{'
    let cmdline = s:parse_block(cmdline)
  endif

  " Expand tilde.
  if cmdline =~ '\~'
    let cmdline = s:parse_tilde(cmdline)
  endif

  " Expand filename.
  if cmdline =~ ' ='
    let cmdline = s:parse_equal(cmdline)
  endif

  " Expand variables.
  if cmdline =~ '\$'
    let cmdline = s:parse_variables(cmdline)
  endif

  " Expand wildcard.
  if cmdline =~ '[[*?]\|\\[()|]'
    let cmdline = s:parse_wildcard(cmdline)
  endif

  return s:parse_tilde(cmdline)
endfunction"}}}
function! vimproc#parser#parse_statements(script) abort "{{{
  if type(a:script) == type('')  && a:script =~ '^\s*:'
    return [ {
          \ 'statement' : a:script,
          \ 'condition' : 'always',
          \ 'cwd' : getcwd(),
          \ } ]
  endif

  let script = type(a:script) == type([]) ?
        \ a:script : split(a:script, '\zs')
  let max = len(script)
  let statements = []
  let statement = ''
  let i = 0
  while i < max
    if script[i] == ';'
      if statement != ''
        call add(statements,
              \ {
              \ 'statement' : statement,
              \ 'condition' : 'always',
              \ 'cwd' : getcwd(),
              \})
      endif
      let statement = ''
      let i += 1
    elseif script[i] == '&'
      if i+1 < max && script[i+1] == '&'
        if statement != ''
          call add(statements,
                \ {
                \ 'statement' : statement,
                \ 'condition' : 'true',
                \ 'cwd' : getcwd(),
                \})
        endif
        let statement = ''
        let i += 2
      else
        let statement .= script[i]

        let i += 1
      endif
    elseif script[i] == '|'
      if i+1 < max && script[i+1] == '|'
        if statement != ''
          call add(statements,
                \ {
                \ 'statement' : statement,
                \ 'condition' : 'false',
                \ 'cwd' : getcwd(),
                \})
        endif
        let statement = ''
        let i += 2
      else
        let statement .= script[i]

        let i += 1
      endif
    elseif script[i] == "'"
      " Single quote.
      let [string, i] = s:skip_single_quote(script, i)
      let statement .= string
    elseif script[i] == '"'
      " Double quote.
      let [string, i] = s:skip_double_quote(script, i)
      let statement .= string
    elseif script[i] == '`'
      " Back quote.
      let [string, i] = s:skip_back_quote(script, i)
      let statement .= string
    elseif script[i] == '\'
      " Escape.
      let i += 1

      if i >= max
        throw 'Exception: Join to next line (\).'
      endif

      let statement .= '\' . script[i]
      let i += 1
    elseif script[i] == '#' && statement == ''
      " Comment.
      break
    else
      let statement .= script[i]
      let i += 1
    endif
  endwhile

  if statement !~ '^\s*$'
    call add(statements,
          \ {
          \ 'statement' : statement,
          \ 'condition' : 'always',
          \ 'cwd' : getcwd(),
          \})
  endif

  return statements
endfunction"}}}

function! vimproc#parser#split_statements(script) abort "{{{
  return map(vimproc#parser#parse_statements(a:script),
        \ 'v:val.statement')
endfunction"}}}
function! vimproc#parser#split_args(script) abort "{{{
  let script = type(a:script) == type([]) ?
        \ a:script : split(a:script, '\zs')
  let max = len(script)
  let args = []
  let arg = ''
  let i = 0
  while i < max
    if script[i] == "'"
      " Single quote.
      let [arg_quote, i] = s:parse_single_quote(script, i)
      let arg .= arg_quote
      if arg == ''
        call add(args, '')
      endif
    elseif script[i] == '"'
      " Double quote.
      let [arg_quote, i] = s:parse_double_quote(script, i)
      let arg .= arg_quote
      if arg == ''
        call add(args, '')
      endif
    elseif script[i] == '`'
      " Back quote.
      let head = i > 0 ? script[: i-1] : []
      let [arg_quote, i] = s:parse_back_quote(script, i)

      " Re-parse script.
      return vimproc#parser#split_args(
            \ head + split(arg_quote, '\zs') + script[i :])
    elseif script[i] == '\'
      " Escape.
      let i += 1

      if i >= max
        throw 'Exception: Join to next line (\).'
      endif

      let arg .= script[i]
      let i += 1
    elseif script[i] == '#' && arg == ''
      " Comment.
      break
    elseif script[i] != ' '
      let arg .= script[i]
      let i += 1
    else
      " Space.
      if arg != ''
        call add(args, arg)
      endif

      let arg = ''

      let i += 1
    endif
  endwhile

  if arg != ''
    call add(args, arg)
  endif

  return args
endfunction"}}}
function! vimproc#parser#split_args_through(script) abort "{{{
  let script = type(a:script) == type([]) ?
        \ a:script : split(a:script, '\zs')
  let max = len(script)
  let args = []
  let arg = ''
  let i = 0
  while i < max
    if script[i] == "'"
      " Single quote.
      let [string, i] = s:skip_single_quote(script, i)
      let arg .= string
      if arg == ''
        call add(args, '')
      endif
    elseif script[i] == '"'
      " Double quote.
      let [string, i] = s:skip_double_quote(script, i)
      let arg .= string
      if arg == ''
        call add(args, '')
      endif
    elseif script[i] == '`'
      " Back quote.
      let [string, i] = s:skip_back_quote(script, i)
      let arg .= string
      if arg == ''
        call add(args, '')
      endif
    elseif script[i] == '\'
      " Escape.
      let i += 1

      if i >= max
        throw 'Exception: Join to next line (\).'
      endif

      let arg .= '\'.script[i]
      let i += 1
    elseif script[i] != ' '
      let arg .= script[i]
      let i += 1
    else
      " Space.
      if arg != ''
        call add(args, arg)
      endif

      let arg = ''

      let i += 1
    endif
  endwhile

  if arg != ''
    call add(args, arg)
  endif

  return args
endfunction"}}}
function! vimproc#parser#split_pipe(script) abort "{{{
  let script = type(a:script) == type([]) ?
        \ a:script : split(a:script, '\zs')
  let max = len(script)
  let command = ''

  let i = 0
  let commands = []
  while i < max
    if script[i] == '|'
      " Pipe.
      call add(commands, command)

      " Search next command.
      let command = ''
      let i += 1
    elseif script[i] == "'"
      " Single quote.
      let [string, i] = s:skip_single_quote(script, i)
      let command .= string
    elseif script[i] == '"'
      " Double quote.
      let [string, i] = s:skip_double_quote(script, i)
      let command .= string
    elseif script[i] == '`'
      " Back quote.
      let [string, i] = s:skip_back_quote(script, i)
      let command .= string
    elseif script[i] == '\' && i + 1 < max
      " Escape.
      let command .= '\' . script[i+1]
      let i += 2
    else
      let command .= script[i]
      let i += 1
    endif
  endwhile

  call add(commands, command)

  return commands
endfunction"}}}
function! vimproc#parser#split_commands(script) abort "{{{
  let script = type(a:script) == type([]) ?
        \ a:script : split(a:script, '\zs')
  let max = len(script)
  let commands = []
  let command = ''
  let i = 0
  while i < max
    if script[i] == '\'
      " Escape.
      let command .= script[i]
      let i += 1

      if i >= max
        throw 'Exception: Join to next line (\).'
      endif

      let command .= script[i]
      let i += 1
    elseif script[i] == '|'
      if command != ''
        call add(commands, command)
      endif
      let command = ''

      let i += 1
    else

      let command .= script[i]
      let i += 1
    endif
  endwhile

  if command != ''
    call add(commands, command)
  endif

  return commands
endfunction"}}}
function! vimproc#parser#expand_wildcard(wildcard) abort "{{{
  " Check wildcard.
  let i = 0
  let max = len(a:wildcard)
  let script = ''
  let found = 0
  while i < max
    if a:wildcard[i] == '*' || a:wildcard[i] == '?' || a:wildcard[i] == '['
      let found = 1
      break
    else
      let [script, i] = s:skip_else(script, a:wildcard, i)
    endif
  endwhile

  if !found
    return [ a:wildcard ]
  endif

  let wildcard = a:wildcard

  " Exclude wildcard.
  let exclude = matchstr(wildcard, '\\\@<!\~\zs.\+$')
  let exclude_wilde = []
  if exclude != ''
    " Truncate wildcard.
    let wildcard = wildcard[: len(wildcard)-len(exclude)-2]
    let exclude_wilde = vimproc#parser#expand_wildcard(exclude)
  endif

  " Modifier.
  let modifier = matchstr(wildcard, '\\\@<!(\zs.\+\ze)$')
  if modifier != ''
    " Truncate wildcard.
    let wildcard = wildcard[: len(wildcard)-len(modifier)-3]
  endif

  " Expand wildcard.
  let expanded = split(escape(substitute(
        \ glob(wildcard, 1), '\\', '/', 'g'), ' '), '\n')
  if empty(expanded)
    " Use original string.
    return [ a:wildcard ]
  else
    " Check exclude wildcard.
    let candidates = expanded
    let expanded = []
    for candidate in candidates
      let found = 0

      for ex in exclude_wilde
        if candidate ==# ex
          let found = 1
          break
        endif
      endfor

      if !found
        call add(expanded, candidate)
      endif
    endfor
  endif

  if modifier != ''
    " Check file modifier.
    let i = 0
    let max = len(modifier)
    while i < max
      if modifier[i] ==# '/'
        " Directory.
        let expr = 'getftype(v:val) ==# "dir"'
      elseif modifier[i] ==# '.'
        " Normal.
        let expr = 'getftype(v:val) ==# "file"'
      elseif modifier[i] ==# '@'
        " Link.
        let expr = 'getftype(v:val) ==# "link"'
      elseif modifier[i] ==# '='
        " Socket.
        let expr = 'getftype(v:val) ==# "socket"'
      elseif modifier[i] ==# 'p'
        " FIFO Pipe.
        let expr = 'getftype(v:val) ==# "pipe"'
      elseif modifier[i] ==# '*'
        " Executable.
        let expr = 'getftype(v:val) ==# "pipe"'
      elseif modifier[i] ==# '%'
        " Device.

        if modifier[i :] =~# '^%[bc]'
          if modifier[i] ==# 'b'
            " Block device.
            let expr = 'getftype(v:val) ==# "bdev"'
          else
            " Character device.
            let expr = 'getftype(v:val) ==# "cdev"'
          endif

          let i += 1
        else
          let expr = 'getftype(v:val) ==# "bdev" || getftype(v:val) ==# "cdev"'
        endif
      else
        " Unknown.
        return []
      endif

      call filter(expanded, expr)
      let i += 1
    endwhile
  endif

  return filter(expanded, 'v:val != "." && v:val != ".."')
endfunction"}}}

" Parse helper.
function! s:parse_block(script) abort "{{{
  let script = ''

  let i = 0
  let max = len(a:script)
  while i < max
    if a:script[i] == '{'
      " Block.
      let block = matchstr(a:script, '^{\zs.\{-}\ze}', i)
      let rest = a:script[matchend(a:script, '^{.\{-}}', i) :]
      if block == ''
        let [script, i] = s:skip_else(script, a:script, i)
        continue
      endif

      let head = matchstr(a:script[: i-1], '[^[:blank:]]*$')
      " Truncate script.
      let script = script[: -len(head)-1]
      let rest = (rest =~ '^\s\+' ? ' ' : '') .
            \ join(vimproc#parser#split_args(s:parse_cmdline(rest)))
      let foot = matchstr(rest, '^\S\+')
      let rest = rest[len(foot):]
      if block == ''
        throw 'Exception: Block is not found.'
      elseif block =~ '^\d\+\.\.\d\+$'
        " Range block.
        let start = matchstr(block, '^\d\+')
        let end = matchstr(block, '\d\+$')
        let zero = len(matchstr(block, '^0\+'))+1
        let pattern = '%0' . zero . 'd'
        for b in range(start, end)
          " Concat.
          let script .= head . printf(pattern, b) . foot . ' '
        endfor
      else
        " Normal block.
        let blocks = (stridx(block, ',') < 0) ?
              \ split(block, '\zs') :
              \ split(block, ',', 1)
        for b in vimproc#util#uniq(blocks)
          " Concat.
          let script .= head . escape(b, ' ') . foot . ' '
        endfor
      endif

      let script .= rest
      return script
    else
      let [script, i] = s:skip_else(script, a:script, i)
    endif
  endwhile

  return script
endfunction"}}}
function! s:parse_tilde(script) abort "{{{
  let script = ''

  let i = 0
  let max = len(a:script)
  while i < max
    if a:script[i] == ' ' && a:script[i+1] == '~'
      " Tilde.
      " Expand home directory.
      let script .= ' ' . escape(substitute($HOME, '\\', '/', 'g'), '\ ')
      let i += 2

    elseif i == 0 && a:script[i] == '~'
      " Tilde.
      " Expand home directory.
      let script .= escape(substitute($HOME, '\\', '/', 'g'), '\ ')
      let i += 1
    else
      let [script, i] = s:skip_else(script, a:script, i)
    endif
  endwhile

  return script
endfunction"}}}
function! s:parse_equal(script) abort "{{{
  let script = ''

  let i = 0
  let max = len(a:script)
  while i < max
    if a:script[i] == ' ' && a:script[i+1] == '='
      " Expand filename.
      let prog = matchstr(a:script, '^=\zs[^[:blank:]]*', i+1)
      if prog == ''
        let [script, i] = s:skip_else(script, a:script, i)
      else
        let filename = vimproc#get_command_name(prog)
        if filename == ''
          throw printf('Error: File "%s" is not found.', prog)
        else
          let script .= filename
        endif

        " Consume `a:script` until an end of `prog`.
        " e.g.
        "   'echo  =ls hoge'  ->  'echo  =ls hoge'
        "         ^                         ^
        let i += strlen(a:script[i] . a:script[i+1] . prog)
      endif
    else
      let [script, i] = s:skip_else(script, a:script, i)
    endif
  endwhile

  return script
endfunction"}}}
function! s:parse_variables(script) abort "{{{
  let script = ''

  let i = 0
  let max = len(a:script)
  try
    while i < max
      if a:script[i] == '$' && a:script[i :] =~ '^$$\?\h'
        " Eval variables.
        let variable_name = matchstr(a:script, '^$$\?\zs\h\w*', i)
        if exists('b:vimshell')
          " For vimshell.
          let script_head = a:script[i :]
          if script_head =~ '^$\l' &&
                \ has_key(b:vimshell.variables, variable_name)
            let script .= b:vimshell.variables[variable_name]
          elseif script_head =~ '^\$\$' &&
                \ has_key(b:vimshell.system_variables, variable_name)
            let script .= b:vimshell.system_variables[variable_name]
          elseif script_head =~ '^$\h'
            let script .= vimproc#util#substitute_path_separator(
                  \ eval('$' . variable_name))
          endif
        else
          let script .= vimproc#util#substitute_path_separator(
                \ eval(matchstr(a:script, '^$\h\w*', i)))
        endif

        let i = matchend(a:script, '^$$\?\h\w*', i)
      else
        let [script, i] = s:skip_else(script, a:script, i)
      endif
    endwhile
  catch /^Vim\%((\a\+)\)\=:E15/
    " Parse error.
    return a:script
  endtry

  return script
endfunction"}}}
function! s:parse_wildcard(script) abort "{{{
  let script = ''
  for arg in vimproc#parser#split_args_through(a:script)
    let script .= join(vimproc#parser#expand_wildcard(arg)) . ' '
  endfor

  return script
endfunction"}}}
function! s:parse_redirection(script) abort "{{{
  let script = ''
  let fd = { 'stdin' : '', 'stdout' : '', 'stderr' : '' }

  let i = 0
  let max = len(a:script)
  while i < max
    if a:script[i] == '<'
      " Input redirection.
      let i += 1
      let fd.stdin = get(vimproc#parser#split_args(
            \ matchstr(a:script, '^\s*\S\+', i)), 0, '')
      let i = matchend(a:script, '^\s*\S\+', i)
    elseif a:script[i] =~ '^[12]' && a:script[i :] =~ '^[12]>'
      " Output redirection.
      let i += 2
      if a:script[i-2] == 1
        let fd.stdout = get(vimproc#parser#split_args(
            \ matchstr(a:script, '^\s*\S\+', i)), 0, '')
      else
        let fd.stderr = get(vimproc#parser#split_args(
              \ matchstr(a:script, '^\s*\zs\(\S\+\|&\d\+\)', i)), 0, '')
        if fd.stderr ==# '&1'
          " Redirection to stdout.
          let fd.stderr = '/dev/stdout'
        endif
      endif

      let i = matchend(a:script, '^\s*\zs\(\S\+\|&\d\+\)', i)
    elseif a:script[i] == '&' && a:script[i :] =~ '^&>'
      " Output stderr.
      let i += 2
      let fd.stderr = get(vimproc#parser#split_args(
            \ matchstr(a:script, '^\s*\S\+', i)), 0, '')
      let i = matchend(a:script, '^\s*\S\+', i)
    elseif a:script[i] == '>'
      " Output redirection.
      if a:script[i :] =~ '^>&'
        " Output stderr.
        let i += 2
        let fd.stderr = get(vimproc#parser#split_args(
            \ matchstr(a:script, '^\s*\S\+', i)), 0, '')
      elseif a:script[i :] =~ '^>>'
        " Append stdout.
        let i += 2
        let fd.stdout = '>' . get(vimproc#parser#split_args(
            \ matchstr(a:script, '^\s*\S\+', i)), 0, '')
      else
        " Output stdout.
        let i += 1
        let fd.stdout = get(vimproc#parser#split_args(
            \ matchstr(a:script, '^\s*\S\+', i)), 0, '')
      endif

      let i = matchend(a:script, '^\s*\zs\S*', i)
    else
      let [script, i] = s:skip_else(script, a:script, i)
    endif
  endwhile

  return [fd, script]
endfunction"}}}

function! s:parse_single_quote(script, i) abort "{{{
  if a:script[a:i] != "'"
    return ['', a:i]
  endif

  let arg = ''
  let i = a:i + 1
  let max = len(a:script)
  while i < max
    if a:script[i] == "'"
      if i+1 < max && a:script[i+1] == "'"
        " Escape quote.
        let arg .= "'"
        let i += 2
      else
        " Quote end.
        return [arg, i+1]
      endif
    else
      let arg .= a:script[i]
      let i += 1
    endif
  endwhile

  throw 'Exception: Quote ('') is not found.'
endfunction"}}}
function! s:parse_double_quote(script, i) abort "{{{
  if a:script[a:i] != '"'
    return ['', a:i]
  endif

  let escape_sequences = {
        \ 'a' : "\<C-g>", 'b' : "\<BS>",
        \ 't' : "\<Tab>", 'r' : "\<CR>",
        \ 'n' : "\<LF>",  'e' : "\<Esc>",
        \ '\' : '\',  '?' : '?',
        \ '"' : '"',  "'" : "'",
        \ '`' : '`',  '$' : '$',
        \}
  let arg = ''
  let i = a:i + 1
  let script = type(a:script) == type([]) ?
        \ a:script : split(a:script, '\zs')
  let max = len(script)
  while i < max
    if script[i] == '"'
      " Quote end.
      return [arg, i+1]
    elseif script[i] == '$'
      " Eval variables.
      let var = matchstr(join(script[i :], ''), '^$\h\w*')
      if var != ''
        let arg .= s:parse_variables(var)
        let i += len(var)
      else
        let arg .= '$'
        let i += 1
      endif
    elseif script[i] == '`'
      " Backquote.
      let [arg_quote, i] = s:parse_back_quote(script, i)
      let arg .= arg_quote
    elseif script[i] == '\'
      " Escape.
      let i += 1

      if i >= max
        throw 'Exception: Join to next line (\).'
      endif

      if script[i] == 'x'
        let num = matchstr(join(script[i+1 :], ''), '^\x\+')
        let arg .= nr2char(str2nr(num, 16))
        let i += len(num)
      elseif has_key(escape_sequences, script[i])
        let arg .= escape_sequences[script[i]]
      else
        let arg .= '\' . script[i]
      endif
      let i += 1
    else
      let arg .= script[i]
      let i += 1
    endif
  endwhile

  throw 'Exception: Quote (") is not found.'
endfunction"}}}
function! s:parse_back_quote(script, i) abort "{{{
  if a:script[a:i] != '`'
    return ['', a:i]
  endif

  let arg = ''
  let max = len(a:script)
  if a:i + 1 < max && a:script[a:i + 1] == '='
    " Vim eval quote.
    let i = a:i + 2

    while i < max
      if a:script[i] == '\'
        " Escape.
        let i += 1

        if i >= max
          throw 'Exception: Join to next line (\).'
        endif

        let arg .= '\' . a:script[i]
        let i += 1
      elseif a:script[i] == '`'
          " Quote end.
          return [eval(arg), i+1]
      else
        let arg .= a:script[i]
        let i += 1
      endif
    endwhile
  else
    " Eval quote.
    let i = a:i + 1

    while i < max
      if a:script[i] == '`'
        " Quote end.
        return [substitute(vimproc#system(arg), '\n$', '', ''), i+1]
      else
        let arg .= a:script[i]
        let i += 1
      endif
    endwhile
  endif

  throw 'Exception: Quote (`) is not found.'
endfunction"}}}

" Skip helper.
function! s:skip_single_quote(script, i) abort "{{{
  let max = len(a:script)
  let string = ''
  let i = a:i

  " a:script[i] is always "'" when this function is called
  if i >= max || a:script[i] != ''''
    throw 'Exception: Quote ('') is not found.'
  endif
  let string .= a:script[i]
  let i += 1

  let ss = []
  while i < max
    if a:script[i] == ''''
      if i+1 < max && a:script[i+1] == ''''
        " Escape quote.
        let ss += [a:script[i]]
        let i += 1
      else
        break
      endif
    endif

    let ss += [a:script[i]]
    let i += 1
  endwhile
  let string .= join(ss, '')

  if i < max
    " must end with "'"
    if a:script[i] != ''''
      throw 'Exception: Quote ('') is not found.'
    endif
    let string .= a:script[i]
    let i += 1
  endif

  return [string, i]
endfunction"}}}
function! s:skip_double_quote(script, i) abort "{{{
  let max = len(a:script)
  let string = ''
  let i = a:i

  " a:script[i] is always '"' when this function is called
  if i >= max || a:script[i] != '"'
    throw 'Exception: Quote (") is not found.'
  endif
  let string .= a:script[i]
  let i += 1

  let ss = []
  while i < max
    if a:script[i] == '\' && i+1 < max
      " Escape quote.
      let ss += [a:script[i]]
      let i += 1
    elseif a:script[i] == '"'
      break
    endif

    let ss += [a:script[i]]
    let i += 1
  endwhile
  let string .= join(ss, '')

  if i < max
    " must end with '"'
    if a:script[i] != '"'
      throw 'Exception: Quote (") is not found.'
    endif
    let string .= a:script[i]
    let i += 1
  endif

  return [string, i]
endfunction"}}}
function! s:skip_back_quote(script, i) abort "{{{
  let max = len(a:script)
  let string = ''
  let i = a:i

  " a:script[i] is always '`' when this function is called
  if a:script[i] != '`'
    throw 'Exception: Quote (`) is not found.'
  endif
  let string .= a:script[i]
  let i += 1

  while i < max && a:script[i] != '`'
    let string .= a:script[i]
    let i += 1
  endwhile

  if i < max
    " must end with "`"
    if a:script[i] != '`'
      throw 'Exception: Quote (`) is not found.'
    endif
    let string .= a:script[i]
    let i += 1
  endif

  return [string, i]
endfunction"}}}
function! s:skip_else(args, script, i) abort "{{{
  if a:script[a:i] == "'"
    " Single quote.
    let [string, i] = s:skip_single_quote(a:script, a:i)
    let script = a:args . string
  elseif a:script[a:i] == '"'
    " Double quote.
    let [string, i] = s:skip_double_quote(a:script, a:i)
    let script = a:args . string
  elseif a:script[a:i] == '`'
    " Back quote.
    let [string, i] = s:skip_back_quote(a:script, a:i)
    let script = a:args . string
  elseif a:script[a:i] == '\'
    " Escape.
    let script = a:args . '\' . a:script[a:i+1]
    let i = a:i + 2
  else
    let script = a:args . a:script[a:i]
    let i = a:i + 1
  endif

  return [script, i]
endfunction"}}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
" vim:foldmethod=marker:fen:sw=2:sts=2
