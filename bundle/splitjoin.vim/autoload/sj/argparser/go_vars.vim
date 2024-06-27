function! sj#argparser#go_vars#Construct(line)
  " 0, 0 for start, end, since we're giving it the full body
  let parser = sj#argparser#common#Construct(0, 0, a:line)

  call extend(parser, {
        \ 'comment': '',
        \
        \ 'Process': function('sj#argparser#go_vars#Process'),
        \ })

  return parser
endfunction

function! sj#argparser#go_vars#Process() dict
  while !self.Finished()
    if self.body[0] == ','
      call self.PushArg()
      call self.Next()
      continue
    elseif self.body[0] =~ "[\"'{\[(]"
      call self.JumpPair("\"'{[(<", "\"'}])>")
    elseif self.body =~ '^\s*\/\/'
      let self.comment = sj#Trim(self.body)
      break
    endif

    call self.PushChar()
  endwhile

  if len(sj#Trim(self.current_arg)) > 0
    call self.PushArg()
  endif
endfunction
