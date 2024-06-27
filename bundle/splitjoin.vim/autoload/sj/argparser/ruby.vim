" Constructor:
" ============

function! sj#argparser#ruby#Construct(start_index, end_index, line)
  let parser = sj#argparser#common#Construct(a:start_index, a:end_index, a:line)

  call extend(parser, {
        \ 'hash_type': '',
        \ 'cursor_arg': 0,
        \ 'cursor_col': col('.'),
        \
        \ 'Process':          function('sj#argparser#ruby#Process'),
        \ 'PushArg':          function('sj#argparser#ruby#PushArg'),
        \ 'AtFunctionEnd':    function('sj#argparser#ruby#AtFunctionEnd'),
        \ 'ExpandOptionHash': function('sj#argparser#ruby#ExpandOptionHash'),
        \ 'MarkOptionArg':    function('sj#argparser#ruby#MarkOptionArg'),
        \ })

  return parser
endfunction

" Methods:
" ========

function! sj#argparser#ruby#Process() dict
  while !self.Finished()
    if self.body[0] == ','
      call self.PushArg()
      call self.Next()
      continue
    elseif self.AtFunctionEnd()
      break
    elseif self.body[0] =~ '[''"]'
      call self.JumpPair("'\"", "'\"")

      " Example: 'some key': value
      if len(self.body) > 1 && self.body[1] == ':'
        call self.MarkOptionArg('new')
      endif
    elseif self.body[0] =~ "[{\[`(/]"
      call self.JumpPair("{[`(/", "}]`)/")
    elseif self.body[0] == '%'
      call self.PushChar()
      if self.body[0] =~ '[qQrswWx]'
        call self.PushChar()
      endif
      let delimiter = self.body[0]
      if delimiter =~ '[[({<]'
        call self.JumpPair('[({<', '])}>')
      else
        call self.JumpPair(delimiter, delimiter)
      endif
    elseif self.body =~ '^=>'
      " Example: 'some key' => value
      call self.MarkOptionArg('classic')
    elseif self.body =~ '^\(\k\|[?!]\):[^:]'
      " Example: some_key: value
      call self.MarkOptionArg('new')
    endif

    call self.PushChar()
  endwhile

  if len(self.current_arg) > 0
    call self.PushArg()
  endif
endfunction

" Pushes the current argument either to the args or opts stack and initializes
" a new one.
function! sj#argparser#ruby#PushArg() dict
  if self.current_arg_type == 'option'
    call add(self.opts, sj#Trim(self.current_arg))
  else
    call add(self.args, sj#Trim(self.current_arg))
  endif

  let self.current_arg      = ''
  let self.current_arg_type = 'normal'

  if self.cursor_col > self.index + 1
    " cursor is after the current argument
    let self.cursor_arg += 1
  endif
endfunction

" If the last argument is a hash and no options have been parsed, splits the
" last argument and fills the options with it.
function! sj#argparser#ruby#ExpandOptionHash() dict
  if len(self.opts) <= 0 && len(self.args) > 0
    " then try parsing the last parameter
    let last = self.args[-1]
    let hash_pattern = '^{\(.*\(=>\|\k:\|[''"]:\).*\)}$'

    if last =~ hash_pattern
      " then it seems to be a hash, expand it
      call remove(self.args, -1)

      let hash = sj#ExtractRx(last, hash_pattern, '\1')

      let [_from, _to, _args, opts, hash_type, _cursor_arg] =
            \ sj#argparser#ruby#ParseArguments(0, -1, hash, { 'expand_options': 1 })
      call extend(self.opts, opts)
      let self.hash_type = hash_type
    endif
  endif
endfunction

" Returns true if the parser is at the function's end, either because of a
" closing brace, a "do" clause or a "%>".
function! sj#argparser#ruby#AtFunctionEnd() dict
  if self.body[0] == ')'
    return 1
  elseif self.body =~ '\v^\s*do(\s*\|.*\|)?(\s*-?\%\>\s*)?$'
    return 1
  elseif self.body =~ '^\s*-\?%>'
    return 1
  endif

  return 0
endfunction

" Public functions:
" =================

function! sj#argparser#ruby#LocateFunction()
  return sj#argparser#common#LocateRubylikeFunction(
        \ '\k\+[?!]\=',
        \ ['rubyInterpolationDelimiter', 'rubyString']
        \ )
endfunction

function! sj#argparser#ruby#MarkOptionArg(type) dict
  let self.current_arg_type = 'option'

  if a:type == 'new' && sj#BlankString(self.hash_type)
    let self.hash_type = 'new'
  elseif a:type == 'classic' && sj#BlankString(self.hash_type)
    let self.hash_type = 'classic'
  elseif a:type != self.hash_type
    let self.hash_type = 'mixed'
  endif
endfunction

function! sj#argparser#ruby#LocateHash()
  return sj#LocateBracesOnLine('{', '}', ['rubyInterpolationDelimiter', 'rubyString'])
endfunction

function! sj#argparser#ruby#ParseArguments(start_index, end_index, line, options)
  let parser = sj#argparser#ruby#Construct(a:start_index, a:end_index, a:line)
  call parser.Process()
  if a:options.expand_options
    call parser.ExpandOptionHash()
  endif
  return [ a:start_index, parser.index, parser.args, parser.opts, parser.hash_type, parser.cursor_arg ]
endfunction
