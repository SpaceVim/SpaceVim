let g:delimitMate_expand_cr = 1
"DelimitMateReload
let lines = readfile(expand('<sfile>:t:r').'.txt')
call vimtest#StartTap()
let testsnumber = len(filter(copy(lines), 'v:val =~ ''^=\{80}$'''))
call vimtap#Plan(testsnumber)
let tcount = 1
let expect = 0
let evaluate = 0
let commands = []
let header = ''
for item in lines
  if item =~ '^=\{80}$'
    let expect = 1
    let expected = []
    continue
  endif

  if item =~ '^#' && expect == 0
    " A comment.
    let header = empty(header) ? item[1:] : 'Lines should match.'
    continue
  endif
  if item =~ '^\s*$' && expect == 0
    " An empty line.
    continue
  endif
  if ! expect
    " A command.
    call add(commands, item)
    exec item
    "call vimtap#Diag(item)
    continue
  endif
  if item =~ '^-\{80}$'
    let expect = 0
  endif
  if expect
    call add(expected, item)
    continue
  endif
  let lines = getline(1, line('$'))
  let passed = lines == expected
  echom string(lines)
  echom string(expected)
  call vimtap#Is(lines, expected, header)
  echom string(commands)
  for cmd in commands
    call vimtap#Diag(cmd)
  endfor
  let commands = []
  let header = ''
  let tcount += 1
endfor
call vimtest#Quit()
