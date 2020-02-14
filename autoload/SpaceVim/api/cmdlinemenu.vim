"=============================================================================
" cmdlinemenu.vim --- SpaceVim cmdlinemenu API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
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
  for item in a:items
    let id = index(a:items, item) + 1
    let items[id] = ['(' . id . ')' . item[0]] + item[1:]
  endfor
  return items
endfunction

" items should be a list of [name, funcrc or string]

""
" @section cmdlinemenu, api-cmdlinemenu
" @parentsection api
" menu({items})
"
" Create a cmdline selection menu from a list of {items}, each item should be a
" list of two value in it, first one is the description, and the next one
" should be a funcrc.

function! s:menu(items) abort
  let cancelled = 0
  let saved_more = &more
  let save_cmdheight = &cmdheight
  set nomore
  let items = s:parseItems(a:items)
  let &cmdheight = len(items) + 1
  redrawstatus!
  let selected = '1'
  let exit = 0
  let indent = repeat(' ', 7)
  while !exit
    let menu = "Cmdline menu: Use j/k/enter and the shortcuts indicated\n"
    for id in keys(items)
      let m = items[id]
      if type(m) == type([])
        let m = m[0]
      endif
      if id == selected
        let menu .= indent . '>' . items[id][0] . "\n"
      else
        let menu .= indent . ' ' . items[id][0] . "\n"
      endif
    endfor
    redraw!
    echo menu[:-2]
    let nr = getchar()
    if s:parseInput(nr) ==# '' || nr == 3
      let exit = 1
      let cancelled = 1
      normal! :
    elseif index(keys(items), nr2char(nr)) != -1  || nr == 13
      if nr != 13
        let selected = nr2char(nr)
      endif
      let Value =  items[selected][1]
      normal! :
      if type(Value) == 2
        let args = get(items[selected], 2, [])
        call call(Value, args)
      elseif type(Value) == type('') && !empty(Value)
        execute Value
      endif
      let exit = 1
    elseif nr2char(nr) ==# 'j' || nr ==# 9
      let selected = s:nextItem(keys(items), selected)
      normal! :
    elseif nr2char(nr) ==# 'k' || nr ==# "\<S-Tab>"
      let selected = s:previousItem(keys(items), selected)
      normal! :
    else
      normal! :
    endif
  endwhile
  let &more = saved_more
  let &cmdheight = save_cmdheight
  redraw!
  if cancelled
    echo 'cancelled!'
  endif
endfunction

let s:api['menu'] = function('s:menu')

function! SpaceVim#api#cmdlinemenu#get() abort
  return deepcopy(s:api)
endfunction


" vim:set et sw=2 cc=80:
