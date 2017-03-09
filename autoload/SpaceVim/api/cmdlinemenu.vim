let s:api = {}



function! s:parseInput(char) abort
  if a:char == 27
    return ''
  else
    return a:char
  endif
endfunction

function! s:parseItems(items) abort
  let shortcuts = []
  let items = {}
  for item in a:items
    if index(shortcuts, item[0:0]) == -1
      let items[item[0:0]] = '(' . item[0:0] . ')' . item[1:]
    endif
  endfor
  return items
endfunction

function! s:menu(items) abort
  let saved_more = &more
  set nomore
  let items = s:parseItems(a:items)
  let selected = values(items)[0][1:1]
  let exit = 0
  let indent = repeat(' ', 7)
  while !exit
    let menu = "Cmdline menu: Use j/k/enter and the shortcuts indicated\n"
    for line in values(items)
      if line[1:1] == selected
        let menu .= indent . '>' . line . "\n"
      else
        let menu .= indent . ' ' . line . "\n"
      endif
    endfor
    echo menu[:-2]
    let nr = getchar()
    if s:parseInput(nr) ==# '' || nr == 3
      let exit = 1
    elseif index(keys(items), nr2char(nr)) != -1
      let selected = nr2char(nr)
    elseif nr2char(nr) ==# 'j'
      let selected = keys(items)[index(keys(items), selected) + 1]
    elseif nr2char(nr) ==# 'k'
      let selected = keys(items)[index(keys(items), selected) - 1]
    endif
    redraw
  endwhile
  let &more = saved_more
endfunction

let s:api['menu'] = function('s:menu')

function! SpaceVim#api#cmdlinemenu#get() abort
  return deepcopy(s:api)
endfunction


" vim:set et sw=2 cc=80:
