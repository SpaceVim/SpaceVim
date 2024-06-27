function! sj#argparser#elixir#LocateFunction()
  return sj#argparser#common#LocateRubylikeFunction(
        \ '\k\+[?!]\=',
        \ ['elixirString', 'elixirAtom']
        \ )
endfunction

function! sj#argparser#elixir#Construct(start_index, end_index, line)
  let parser = sj#argparser#common#Construct(a:start_index, a:end_index, a:line)

  call extend(parser, {
        \ 'Process': function('sj#argparser#elixir#Process'),
        \ })

  return parser
endfunction

function! sj#argparser#elixir#Process() dict
  while !self.Finished()
    if self.body[0] == ','
      call self.PushArg()
      call self.Next()
      continue
    elseif self.body[0] =~ "[\"'{\[(/]"
      call self.JumpPair("\"'{[(/", "\"'}])/")
    endif

    call self.PushChar()
  endwhile

  if len(sj#Trim(self.current_arg)) > 0
    call self.PushArg()
  endif
endfunction
