let s:api = {}



function! s:parseInput(char) abort
  if a:char == 27
    return ''
  else
    return a:char
  endif
endfunction

function! s:nextItem(list, item) abort
  let id = index(a:list, a:item)
  if id == len(a:list) - 1
    return a:list[0]
  else
    return a:list[id + 1]
  endif
endfunction

function! s:previousItem(list, item) abort
  let id = index(a:list, a:item)
  if id == 0
    return a:list[len(a:list) - 1]
  else
    return a:list[id - 1]
  endif
endfunction

function! s:parseItems(items) abort
  let items = {}
  let g:items = items
  for item in a:items
    let id = index(a:items, item) + 1
    let items[id] = '(' . id . ')' . item
  endfor
  return items
endfunction

function! s:menu(items) abort
  let saved_more = &more
  set nomore
  let items = s:parseItems(a:items)
  let selected = 1
  let exit = 0
  let indent = repeat(' ', 7)
  while !exit
    let menu = "Cmdline menu: Use j/k/enter and the shortcuts indicated\n"
    for id in keys(items)
      if id == selected
        let menu .= indent . '>' . items[id] . "\n"
      else
        let menu .= indent . ' ' . items[id] . "\n"
      endif
    endfor
    echo menu[:-2]
    let nr = getchar()
    if s:parseInput(nr) ==# '' || nr == 3
      let exit = 1
    elseif index(keys(items), nr2char(nr)) != -1
      let selected = nr2char(nr)
    elseif nr2char(nr) ==# 'j'
      let selected = s:nextItem(keys(items), selected)
    elseif nr2char(nr) ==# 'k'
      let selected = s:previousItem(keys(items), selected)
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
