"let g:delimitMate_quotes = '" '' ` ” « |'
let g:delimitMate_quotes = '" '' ` « |'
let lines = readfile(expand('<sfile>:t:r').'.txt')
call vimtest#StartTap()
let testsnumber = len(filter(copy(lines), 'v:val =~ ''^"'''))
let itemsnumber = len(split(g:delimitMate_quotes, ' '))
call vimtap#Plan(testsnumber * itemsnumber)
let reload = 1
let tcount = 1
let linenr = 0
for item in lines
  let linenr += 1
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
  let quotes = split(g:delimitMate_quotes, '\s')
  for quote in quotes
    if vimtap#Skip(1, tcount != 26, "This test is invalid for double quote.")
      let tcount += 1
      continue
    endif
    let [input, output] = split(item, '"\%(\\.\|[^\\"]\)*"\zs\s*\ze"\%(\\.\|[^\\"]\)*"')
    let input_q = substitute(input,"'" , escape(escape(quote, '"'), '\'), 'g')
    let output_q = substitute(output,"'" , escape(escape(quote, '"'), '\'), 'g')
    %d
    exec 'normal i'.eval(input_q)."\<Esc>"
    if quote == '”'
      call vimtap#Todo(1)
    endif
    call vimtap#Is(getline('.'), eval(output_q), 'Line '.linenr.': '.eval(substitute(input_q, '\\<', '<','g')))
    let tcount += 1
  endfor
endfor
call vimtest#Quit()
