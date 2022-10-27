"unstack#extractors#Regex(regex, file_replacement, line_replacement) constructs {{{
"an extractor that uses regexes
function! unstack#extractors#Regex(regex, file_replacement, line_replacement, ...)
  let extractor = {"regex": a:regex, "file_replacement": a:file_replacement,
        \ "line_replacement": a:line_replacement, "reverse": (a:0 > 0) ? a:1 : 0}
  function extractor.extract(text) dict
    let stack = []
    for line in split(a:text, "\n")
      let fname = substitute(line, self.regex, self.file_replacement, '')
      "if this line has a matching filename
      if (fname != line)
        let lineno = substitute(line, self.regex, self.line_replacement, '')
        call add(stack, [fname, lineno])
      endif
    endfor
    if self.reverse
      call reverse(stack)
    endif
    return stack
  endfunction

  return extractor
endfunction
"}}}

function! unstack#extractors#GetDefaults()
  "I'm writing this as multiple statemnts because vim line continuations make
  "me cry
  let extractors = []
  "Python
  call add(extractors, unstack#extractors#Regex('\v^ *File "([^"]+)", line ([0-9]+).*', '\1', '\2'))
  "Ruby
  call add(extractors, unstack#extractors#Regex('\v^[ \t]*from (.+):([0-9]+):in `.*', '\1', '\2'))
  "C#
  call add(extractors, unstack#extractors#Regex('\v^[ \t]*at .*\(.*\) in (.+):line ([0-9]+) *$', '\1', '\2'))
  "Perl
  call add(extractors, unstack#extractors#Regex('\v^%(Trace begun|.+ called) at (.+) line (\d+)$', '\1', '\2'))
  " Go
  call add(extractors, unstack#extractors#Regex('\v^[ \t]*(.+):(\d+) \+0x\x+$', '\1', '\2'))
  " Node.js
  call add(extractors, unstack#extractors#Regex('\v^ +at .+\((.+):(\d+):\d+\)$', '\1', '\2'))
  " Erlang R15+
  call add(extractors, unstack#extractors#Regex('\v^.+\[\{file,"([^"]+)"\},\{line,([0-9]+)\}\]\}.*$', '\1', '\2'))
  " Valgrind
  call add(extractors, unstack#extractors#Regex('\v^\=\=\d+\=\=[ \t]*%(at|by).*\((.+):(\d+)\)$', '\1', '\2', 1))
  " GDB / LLDB
  call add(extractors, unstack#extractors#Regex('\v^[ *]*%(frame )?#\d+:? +0[xX][0-9a-fA-F]+ .+ at (.+):(\d+)', '\1', '\2', 1))
  return extractors
endfunction

" vim: et sw=2 sts=2 foldmethod=marker foldmarker={{{,}}}
