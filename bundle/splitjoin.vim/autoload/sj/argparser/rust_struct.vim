function! sj#argparser#rust_struct#Construct(start_index, end_index, line)
  let parser = sj#argparser#common#Construct(a:start_index, a:end_index, a:line)

  call extend(parser, {
        \ 'current_arg_attributes': [],
        \
        \ 'PushArg': function('sj#argparser#rust_struct#PushArg'),
        \ 'Process': function('sj#argparser#rust_struct#Process'),
        \
        \ 'IsValidStruct':     function('sj#argparser#rust_struct#IsValidStruct'),
        \ 'IsOnlyStructPairs': function('sj#argparser#rust_struct#IsOnlyStructPairs'),
        \ })

  return parser
endfunction

function! sj#argparser#rust_struct#Process() dict
  while !self.Finished()
    if self.body[0] == ','
      call self.PushArg()
      call self.Next()
      continue
    elseif self.body =~ '^#['
      " It's an #[attribute], so the "current arg" is going to be temporarily
      " reset so we can parse it
      let real_current_arg = self.current_arg
      let self.current_arg = ''

      call self.PushChar()
      call self.JumpPair('[', ']')
      call self.PushChar()
      call add(self.current_arg_attributes, self.current_arg)

      let self.current_arg = real_current_arg
    elseif self.body =~ '^''\\\=.'''
      " then it's a char, not a lifetime, we can jump it
      call self.JumpPair("'", "'")
    elseif self.body[0] =~ '["{\[(|]'
      call self.JumpPair('"{[(|', '"}])|')
    endif

    call self.PushChar()
  endwhile

  if len(sj#Trim(self.current_arg)) > 0
    call self.PushArg()
  endif
endfunction

" Pushes the current argument to the args and initializes a new one. Special
" handling for attributes
function! sj#argparser#rust_struct#PushArg() dict
  call add(self.args, {
        \ "attributes": self.current_arg_attributes,
        \ "argument":   sj#Trim(self.current_arg)
        \ })

  let self.current_arg            = ''
  let self.current_arg_type       = 'normal'
  let self.current_arg_attributes = []
endfunction

" Expects self.Process() to have been run
"
" Possibilities:
"   StructName { key: value }, or
"   StructName { prop1, prop2 }, or
"   StructName { prop1, ..Foo }, or
"   StructName { #[cfg] prop1, ..Foo }
"
function! sj#argparser#rust_struct#IsValidStruct() dict
  let visibility = '\%(pub\%((crate)\)\=\s*\)\='

  for entry in self.args
    if entry.argument !~ '^'.visibility.'\k\+$' &&
          \ entry.argument !~ '^'.visibility.'\k\+:' &&
          \ entry.argument !~ '^'.visibility.'\.\.\k'
      return 0
    endif
  endfor

  return 1
endfunction

" Expects self.Process() to have been run
"
" Possibilities:
"   StructName { key: value, other_key: expression() }
"
function! sj#argparser#rust_struct#IsOnlyStructPairs() dict
  let visibility = '\%(pub\%((crate)\)\=\s*\)\='

  for entry in self.args
    if len(entry.attributes) > 0
      " then it's not just pairs, there's also an attribute
      return 0
    endif

    if entry.argument !~ '^'.visibility.'\k\+:'
      return 0
    endif
  endfor

  return 1
endfunction
