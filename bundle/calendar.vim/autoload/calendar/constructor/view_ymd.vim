" =============================================================================
" Filename: autoload/calendar/constructor/view_ymd.vim
" Author: itchyny
" License: MIT License
" Last Change: 2017/07/02 08:42:35.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#constructor#view_ymd#new(instance) abort
  return extend({ 'instance': a:instance }, s:constructor)
endfunction

let s:constructor = {}

function! s:constructor.new(source) dict abort
  let instance = extend(extend(s:super_constructor.new(a:source), s:instance), self.instance)
  let iday = index(instance.ymd, 'day')
  let imonth = index(instance.ymd, 'month')
  let iyear = index(instance.ymd, 'year')
  let instance.select_index = iday >= 0 ? iday : imonth >= 0 ? imonth : iyear
  return instance
endfunction

let s:instance = {}

function! s:instance.width() dict abort
  return len(self.contents()[0].s)
endfunction

function! s:instance.height() dict abort
  return 1
endfunction

function! s:sum(l) abort
  let n = 0
  for i in a:l
    let n += i
  endfor
  return n
endfunction

function! s:instance.contents() dict abort
  let y = b:calendar.month().get_year()
  let year = y > 0 ? string(y) : (1 - y) . ' BC'
  let use_month_name = calendar#setting#get('date_month_name')
  let use_full_month_name = calendar#setting#get('date_full_month_name')
  if use_full_month_name
    let month = calendar#message#get('month_name_long')[b:calendar.month().get_month() - 1]
  elseif use_month_name
    let month = calendar#message#get('month_name')[b:calendar.month().get_month() - 1]
  else
    let month = printf('%2d', b:calendar.month().get_month())
  endif
  let day = printf('%2d', b:calendar.day().get_day())
  let sepa = substitute(printf(' %s ', calendar#setting#get('date_separator')), '\s\+', ' ', 'g')
  let texts = map(copy(self.ymd), "get({ 'year': year, 'month': month, 'day': day }, v:val)")
  let t = ''
  let separator = []
  for i in range(len(texts))
    if i
      let sep = use_month_name && (self.ymd[i - 1] ==# 'month' && self.ymd[i] ==# 'day' || self.ymd[i - 1] ==# 'day' && self.ymd[i] ==# 'month') ? ' ' : sepa
    else
      let sep = ''
    endif
    call add(separator, sep)
    let t .= sep . texts[i]
  endfor
  let text = calendar#text#new(t, 0, 0, '')
  if self.is_selected()
    let separatorlen = map(copy(separator), 'len(v:val)')
    let length = map(copy(self.ymd), "get({ 'year': len(year), 'month': len(month), 'day': len(day) }, v:val)")
    let position = map(range(len(length)), 's:sum((v:val ? length[:(v:val - 1)] : []) + (separatorlen[:(v:val)]))')
    let select = calendar#text#new(length[self.select_index], position[self.select_index], 0, 'Select')
    let cursor = calendar#text#new(0, length[self.select_index] + position[self.select_index], 0, 'Cursor')
    return [text, select, cursor]
  else
    return [text]
  endif
endfunction

function! s:instance.action(action) dict abort
  if index(['left', 'prev', 'line_head', 'first_line', 'last_line' ], a:action) >= 0
    let self.select_index = max([self.select_index - 1, 0])
  elseif index(['right', 'next', 'line_last', 'last_line_last'], a:action) >= 0
    let self.select_index = min([self.select_index + 1, len(self.ymd) - 1])
  elseif index(['down', 'up', 'add', 'subtract', 'plus', 'minus', 'scroll_down', 'scroll_up'], a:action) >= 0
    let diff = v:count1 * (index(['down', 'add', 'plus', 'scroll_down'], a:action) >= 0 ? 1 : -1)
    call b:calendar['move_' . self.ymd[self.select_index]](diff)
  elseif index(['down_big', 'up_big'], a:action) >= 0
    let diff = v:count1 * (a:action ==# 'down_big' ? 1 : -1)
    let move_big = { 'year': 10, 'month': 3, 'day': 7 }
    call b:calendar['move_' . self.ymd[self.select_index]](diff * move_big[self.ymd[self.select_index]])
  elseif index(['down_large', 'up_large'], a:action) >= 0
    let diff =  v:count1 * (a:action ==# 'down_large' ? 1 : -1)
    let move_large = { 'year': 100, 'month': 6, 'day': 14 }
    call b:calendar['move_' . self.ymd[self.select_index]](diff * move_large[self.ymd[self.select_index]])
  elseif a:action ==# 'bar'
    let self.select_index = max([min([v:count1 - 1, len(self.ymd) - 1]), 0])
  elseif a:action ==# 'space'
    let self.select_index = (self.select_index + 1) % len(self.ymd)
  elseif a:action ==# 'command_enter' && mode() ==# 'c' && getcmdtype() ==# ':'
    let cmd = calendar#util#getcmdline()
    if cmd =~# '\v^\s*\d+\s*$'
      let c = matchstr(cmd, '\v\d+') * 1
      if self.ymd[self.select_index] ==# 'day'
        let month = b:calendar.month()
        let [y, m] = month.get_ym()
        let c = max([min([c, month.last_day().get_day()]), month.head_day().get_day()])
        call b:calendar.move_day(b:calendar.day().new(y, m, c).sub(b:calendar.day()))
      elseif self.ymd[self.select_index] ==# 'month'
        let month = b:calendar.month().get_month()
        let c = max([min([c, 12]), 1])
        call b:calendar.move_month(c - month)
      elseif self.ymd[self.select_index] ==# 'year'
        call b:calendar.move_year(c - b:calendar.month().get_year())
      endif
      return calendar#util#update_keys()
    endif
  endif
endfunction

let s:super_constructor = calendar#constructor#view#new(s:instance)

let &cpo = s:save_cpo
unlet s:save_cpo
