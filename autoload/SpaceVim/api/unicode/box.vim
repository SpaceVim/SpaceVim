"=============================================================================
" box.vim --- SpaceVim box API
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

""
" @section unicode#box, api-unicode-box
" @parentsection api
" provides some functions to draw box and table.
"
" drawing_table({json}[, {keys}])
" 
"   drawing table with json data.
"

let s:self = {}
let s:self._json = SpaceVim#api#import('data#json')
let s:self._string = SpaceVim#api#import('data#string')
let s:self.box_width = 40
" http://jrgraphix.net/r/Unicode/2500-257F
" http://www.alanflavell.org.uk/unicode/unidata.html

" json should be a list of items which have same keys
function! s:self.drawing_table(json, ...) abort
  if empty(a:json)
    return []
  endif
  if &encoding ==# 'utf-8'
    let top_left_corner = '╭'
    let top_right_corner = '╮'
    let bottom_left_corner = '╰'
    let bottom_right_corner = '╯'
    let side = '│'
    let top_bottom_side = '─'
    let middle = '┼'
    let top_middle = '┬'
    let left_middle = '├'
    let right_middle = '┤'
    let bottom_middle = '┴'
  else
    let top_left_corner = '*'
    let top_right_corner = '*'
    let bottom_left_corner = '*'
    let bottom_right_corner = '*'
    let side = '|'
    let top_bottom_side = '-'
    let middle = '*'
    let top_middle = '*'
    let left_middle = '*'
    let right_middle = '*'
    let bottom_middle = '*'
  endif
  let table = []
  let items = self._json.json_decode(a:json)
  let col = len(keys(items[0]))
  let top_line = top_left_corner
        \ . repeat(repeat(top_bottom_side, self.box_width) . top_middle, col - 1)
        \ . repeat(top_bottom_side, self.box_width)
        \ . top_right_corner
  let middle_line = left_middle
        \ . repeat(repeat(top_bottom_side, self.box_width) . middle, col - 1)
        \ . repeat(top_bottom_side, self.box_width)
        \ . right_middle
  let bottom_line = bottom_left_corner
        \ . repeat(repeat(top_bottom_side, self.box_width) . bottom_middle, col - 1)
        \ . repeat(top_bottom_side, self.box_width)
        \ . bottom_right_corner
  call add(table, top_line)
  let tytle = side
  if a:0 == 0
    let keys = keys(items[0])
  else
    let keys = a:1
  endif
  for key in keys
    let tytle .= self._string.fill_middle(key , self.box_width) . side
  endfor
  call add(table, tytle)
  call add(table, middle_line)
  for item in items
    let value_line = side
    for key in keys
      let value_line .= self._string.fill(item[key], self.box_width) . side
    endfor
    call add(table, value_line)
    call add(table, middle_line)
  endfor
  let table[-1] = bottom_line
  return table
endfunction

" @vimlint(EVL102, 1, l:j)
" @param data: a list of string
" @param h: max height of box
" @param w: max width of box
" @param bw: cell width
" @param [opt]: a dict of options
"     align: right/left/center
function! s:self.drawing_box(data, h, w, bw, ...) abort
  let opt = get(a:000, 0, {
        \ 'align': 'center'
        \ })
  if &encoding ==# 'utf-8'
    let top_left_corner = '╭'
    let top_right_corner = '╮'
    let bottom_left_corner = '╰'
    let bottom_right_corner = '╯'
    let side = '│'
    let top_bottom_side = '─'
    let middle = '┼'
    let top_middle = '┬'
    let left_middle = '├'
    let right_middle = '┤'
    let bottom_middle = '┴'
  else
    let top_left_corner = '*'
    let top_right_corner = '*'
    let bottom_left_corner = '*'
    let bottom_right_corner = '*'
    let side = '|'
    let top_bottom_side = '-'
    let middle = '*'
    let top_middle = '*'
    let left_middle = '*'
    let right_middle = '*'
    let bottom_middle = '*'
  endif
  let box = []
  let top_line = top_left_corner
        \ . repeat(repeat(top_bottom_side, a:bw) . top_middle, a:w - 1)
        \ . repeat(top_bottom_side, a:bw)
        \ . top_right_corner
  let middle_line = left_middle
        \ . repeat(repeat(top_bottom_side, a:bw) . middle, a:w - 1)
        \ . repeat(top_bottom_side, a:bw)
        \ . right_middle
  let bottom_line = bottom_left_corner
        \ . repeat(repeat(top_bottom_side, a:bw) . bottom_middle, a:w - 1)
        \ . repeat(top_bottom_side, a:bw)
        \ . bottom_right_corner
  let empty_line = side
        \ . repeat(repeat(' ', a:bw) . side, a:w)
  call add(box, top_line)
  let i = 0
  let ls = 1
  let line = side
  for sel in a:data
    if opt.align == 'center'
      let line .=self._string.fill_middle(sel, a:bw) . side
    elseif opt.align == 'right'
      let line .=self._string.fill_left(sel, a:bw) . side
    else
      let line .=self._string.fill(sel, a:bw) . side
    endif
    let i += 1
    if i == a:w
      call add(box, line)
      call add(box, middle_line)
      let ls += 1
      let line = side
      let i = 0
    endif
  endfor
  if ls < a:h
    for j in range(a:h - ls)
      call add(box, empty_line)
      call add(box, middle)
    endfor
  else
    let box[-1] = bottom_line
  endif
  return box
endfunction
" @vimlint(EVL102, 0, l:j)

function! SpaceVim#api#unicode#box#get() abort
  return deepcopy(s:self)
endfunction

" vim:set et sw=2:
