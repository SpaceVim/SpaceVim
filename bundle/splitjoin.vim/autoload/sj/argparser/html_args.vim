function! sj#argparser#html_args#Construct(start_index, end_index, line)
  let parser = sj#argparser#common#Construct(a:start_index, a:end_index, a:line)

  call extend(parser, {
        \ 'Process': function('sj#argparser#html_args#Process'),
        \ })

  return parser
endfunction

function! sj#argparser#html_args#Process() dict
  while !self.Finished()
    if self.body =~ '^\s*/\=>'
      " end of the tag, push it onto the last argument
      let self.current_arg .= self.body
      break
    elseif self.body[0] == ' '
      if self.current_arg != ''
        call self.PushArg()
      endif
      call self.Next()
      continue
    elseif self.body[0] =~ '["''{]'
      call self.JumpPair('"''{', '"''}')
    endif

    call self.PushChar()
  endwhile

  if len(self.current_arg) > 0
    call self.PushArg()
  endif
endfunction
