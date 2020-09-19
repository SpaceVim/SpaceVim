let g:delimitMate_matchpairs = '(:),{:},[:],<:>,¿:?,¡:!,,::'
let lines = readfile(expand('<sfile>:t:r').'.txt')
call vimtest#StartTap()
let testsnumber = len(filter(copy(lines), 'v:val =~ ''^"'''))
let itemsnumber = len(split(g:delimitMate_matchpairs, '.:.\zs,\ze.:.'))
call vimtap#Plan(testsnumber * itemsnumber)
let tcount = 1
let reload = 1
for item in lines
  if item =~ '^#\|^\s*$'
    " A comment or empty line.
    continue
  endif
  if item !~ '^"'
    " A command.
    exec item
    call vimtap#Diag(item)
    let reload = 1
    continue
  endif
  if reload
    DelimitMateReload
    call vimtap#Diag('DelimitMateReload')
    let reload = 0
  endif
  let [input, output] = split(item, '"\%(\\.\|[^\\"]\)*"\zs\s*\ze"\%(\\.\|[^\\"]\)*"')
  for [s:l,s:r] in map(split(g:delimitMate_matchpairs, '.:.\zs,\ze.:.'), 'split(v:val, ''.\zs:\ze.'')')
    let input2 = substitute(input, '(', s:l, 'g')
    let input2 = substitute(input2, ')', s:r, 'g')
    let output2 = substitute(output, '(', s:l, 'g')
    let output2 = substitute(output2, ')', s:r, 'g')
    %d
    exec 'normal i'.eval(input2)."\<Esc>"
    let line = getline('.')
    let passed = line == eval(output2)
    call vimtap#Is(line, eval(output2), input2)
    ", input2 . ' => ' . string(line) .
    "      \ (passed ? ' =' : ' !') . '= ' . string(eval(output2)))
    let tcount += 1
  endfor
endfor
call vimtest#Quit()
