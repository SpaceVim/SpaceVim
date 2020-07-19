let g:delimitMate_expand_space = 1
"DelimitMateReload
let lines = readfile(expand('<sfile>:t:r').'.txt')
call vimtest#StartTap()
let testsnumber = len(filter(copy(lines), 'v:val =~ ''^=\{80}$'''))
call vimtap#Plan(testsnumber)
let tcount = 1
let expect = 0
let evaluate = 0
for item in lines
  if item =~ '^=\{80}$'
    let expect = 1
    let expected = []
    continue
  endif

  if item =~ '^#\|^\s*$' && expect == 0
    " A comment or empty line.
    continue
  endif
  if ! expect
    " A command.
    exec item
    call vimtap#Diag(item)
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
  call vimtap#Ok(passed, string(expected) .
        \ (passed ? ' =' : ' !') . '= ' . string(lines))
  let tcount += 1
endfor
call vimtest#Quit()
