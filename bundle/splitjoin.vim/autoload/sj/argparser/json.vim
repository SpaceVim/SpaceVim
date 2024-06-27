function! sj#argparser#json#Construct(start_index, end_index, line)
  let parser = sj#argparser#common#Construct(a:start_index, a:end_index, a:line)

  call extend(parser, {
        \ 'Process': function('sj#argparser#json#Process'),
        \ })

  return parser
endfunction

" Note: Differs from "js" parser by the fact that JSON doesn't have /regexes/
" to skip through.
function! sj#argparser#json#Process() dict
  while !self.Finished()
    if self.body[0] == ','
      call self.PushArg()
      call self.Next()
      continue
    elseif self.body[0] =~ "[\"'{\[(]"
      call self.JumpPair("\"'{[(", "\"'}])")
    endif

    call self.PushChar()
  endwhile

  if len(sj#Trim(self.current_arg)) > 0
    call self.PushArg()
  endif
endfunction
