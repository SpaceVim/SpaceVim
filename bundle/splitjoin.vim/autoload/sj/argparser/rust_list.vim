function! sj#argparser#rust_list#Construct(type, start_index, end_index, line)
  let parser = sj#argparser#common#Construct(a:start_index, a:end_index, a:line)

  call extend(parser, {
        \ 'type': a:type,
        \
        \ 'Process': function('sj#argparser#rust_list#Process'),
        \ })

  return parser
endfunction

" Note: Differs from "json" parser by <generics> and 'lifetimes
function! sj#argparser#rust_list#Process() dict
  if self.type == 'list'
    let bracket_regex = "[\"'{\[(<]"
    let opening_brackets = "\"'{[(<"
    let closing_brackets = "\"'}])>"
  elseif self.type == 'fn'
    let bracket_regex = "[\"{\[(<]"
    let opening_brackets = "\"{[(<"
    let closing_brackets = "\"}])>"
  else
    throw "Unknown rust_list parse type: " . self.type
  endif

  while !self.Finished()
    if self.body[0] == ','
      call self.PushArg()
      call self.Next()
      continue
    elseif self.body[0] =~ bracket_regex
      call self.JumpPair(opening_brackets, closing_brackets)
    endif

    call self.PushChar()
  endwhile

  if len(sj#Trim(self.current_arg)) > 0
    call self.PushArg()
  endif
endfunction
