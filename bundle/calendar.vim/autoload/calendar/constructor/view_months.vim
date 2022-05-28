" =============================================================================
" Filename: autoload/calendar/constructor/view_months.vim
" Author: itchyny
" License: MIT License
" Last Change: 2017/05/07 23:07:32.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#constructor#view_months#new(instance) abort
  return extend({ 'instance': a:instance }, s:constructor)
endfunction

let s:constructor = {}

function! s:constructor.new(source) dict abort
  return extend(extend(s:super_constructor.new(a:source), s:instance), self.instance)
endfunction

let s:instance = {}

function! s:instance.is_full() dict abort
  return self.x_months * self.y_months == 12
endfunction

function! s:instance.get_months() dict abort
  if self.is_full()
    return b:calendar.year().get_months()
  else
    let m = b:calendar.month()
    let months = [m]
    for i in range(self.x_months * self.y_months / 2)
      call add(months, months[-1].add(1))
    endfor
    for i in range((self.x_months * self.y_months - 1) / 2)
      call insert(months, months[0].add(-1), 0)
    endfor
    return months
  endif
endfunction

function! s:instance.width() dict abort
  let daywidth = 2
  let pad = 100
  while pad > daywidth * 7
    let daywidth += 1
    let pad = self.x_months > 1 ? max([(self.maxwidth() - daywidth * 7 * self.x_months)/2 / (self.x_months - 1), 2]) : 0
  endwhile
  let self.pad = pad
  let self.daywidth = daywidth
  return (daywidth * 7 + pad) * self.x_months - pad - self.daywidth + 2
endfunction

function! s:instance.height() dict abort
  return self.y_months > 1 ? max([9, (self.maxheight()) * 4/5 / self.y_months]) * self.y_months : 9
endfunction

function! s:instance.display_point() dict abort
  let w = self.maxwidth() - 2
  let h = self.maxheight()
  let lw = w - self.width()
  let lh = (h - self.height()) * 2
  return (lw >= 0 && lh >= 0) * (lw + lh + (lw - lh >= 0 ? lw - lh : - (lw - lh)) * 5)
endfunction

function! s:instance.on_resize() dict abort
  let self.view = {}
  let self.view.width = ((self.sizex() + self.pad + self.daywidth - 2)/ self.x_months - self.pad) / 7
  let self.view.pad = self.pad
  let self.view.height = self.sizey() / self.y_months
  let self.view.dheight = 1
  let self.view.dheight = max([1, self.view.height / 8])
  let self.view.offset = self.view.dheight * 2
  let self.element = {}
  let self.element.pad = repeat(' ', self.view.pad)
  let self.element.format = '%2d' . repeat(' ', self.view.width - 2)
  let self.element.white = repeat(' ', self.view.width)
  let self._today = [0, 0, 0]
  let self._month = [0, 0]
  let self._year = 0
  call self.set_day_name()
endfunction

function! s:instance.set_day_name() dict abort
  let day_name = copy(calendar#message#get('day_name'))
  let [v, e] = [self.view, self.element]
  let [mh, h, w] = [v.dheight, v.height, v.width]
  let syntax = []
  let day_names = ''
  let offsetx = [0]
  let index = calendar#week#first_day_index()
  for i in range(index, index + 6)
    let name = day_name[i % 7]
    let day_names .= calendar#string#truncate(name, 2) . repeat(' ', self.view.width - 2)
    call add(offsetx, len(day_names))
  endfor
  for j in range(self.y_months)
    let y = h * j + v.offset / 2
    let f = 1
    let daytitles = []
    for i in range(self.x_months)
      call add(daytitles, calendar#text#new(len(day_names) - (self.view.width - 2), (offsetx[-1] + v.pad) * i, y, 'DayTitle'))
      for k in range(index, index + 6)
        let l = k % 7
        let is_sunday = l == 0
        let is_saturday = l == 6
        if is_sunday || is_saturday
          let x = (offsetx[-1] + v.pad) * i + offsetx[k - index]
          let name = day_name[l]
          let weekstr = calendar#string#truncate(name, 2)
          let syn = is_sunday ? 'SundayTitle' : is_saturday ? 'SaturdayTitle' : ''
          call daytitles[-1].over(calendar#text#new(len(weekstr), x, y, syn))
        endif
      endfor
    endfor
    for i in range(len(daytitles))
      if i
        call extend(syntax[-1].syn, daytitles[i].syn)
      else
        call add(syntax, daytitles[i])
      endif
    endfor
  endfor
  let self.day_name_texts = syntax
  let self.day_names = day_names
  let self.day_names_len = offsetx[-1]
  let self._first_day = calendar#setting#get('first_day')
endfunction

function! s:instance.changed() dict abort
  if self._today != calendar#day#today().get_ymd() || get(self, '_first_day', '') != calendar#setting#get('first_day')
    return 1
  elseif self.is_full()
    return self._year != b:calendar.year().get_y()
  else
    return self._month != b:calendar.month().get_ym()
  endif
endfunction

function! s:instance.set_contents() dict abort
  let month_name = copy(calendar#message#get('month_name_long'))
  let self.month_names_offset = []
  for i in range(self.y_months)
    call add(self.month_names_offset, [])
  endfor
  let year = b:calendar.year()
  let month = b:calendar.month()
  let s = repeat([''], self.sizey())
  let syntax = deepcopy(self.day_name_texts)
  let [v, e] = [self.view, self.element]
  let [mh, h, w] = [v.dheight, v.height, v.width]
  let [i, j] = [0, 0]
  let today = calendar#day#today()
  let self.sun_position = []
  let self.sat_position = []
  let self.top_syntax = []
  let months = self.get_months()
  let week_number = calendar#setting#get('week_number')
  for m in months
    if len(s[h * j])
      for mj in range(h)
        let s[mj + h * j] .= mj < v.offset ? e.pad : e.pad[2:]
      endfor
    endif
    let [mi, mj] = [0, 0]
    let monthname = month_name[m.get_month() - 1]
    let monthnamelen = calendar#string#strdisplaywidth(monthname)
    let holidays = b:calendar.event.get_holidays(m.get_year(), m.get_month())
    call add(self.month_names_offset[j], len(s[mh * mj + h * j]))
    if monthnamelen >= w * 6 + 2
      let s[mh * mj + h * j] .= calendar#string#truncate(monthname, w * 7 - 1) . ' '
    else
      let whiteleft = (w * 6 + 3 - monthnamelen) / 2
      let whiteright = w * 7 - monthnamelen - whiteleft
      let s[mh * mj + h * j] .= repeat(' ', whiteleft) . monthname . repeat(' ', whiteright)
    endif
    call add(self.month_names_offset[j], len(s[mh * mj + h * j]))
    let s[mh * mj + h * j + v.offset / 2] .= self.day_names
    let days = m.get_days()
    let prev_days = calendar#week#is_first_day(days[0]) ? [] : m.add(-1).get_days()
    let next_days = calendar#week#is_last_day(days[-1]) ? [] : m.add(1).get_days()
    let week_count = calendar#week#week_count(m)
    let wn = calendar#week#week_index(days[0])
    let ld = wn + len(days)
    let sun = [-1, -1, -1]
    let sat = [-1, -1, -1]
    for p in range(week_count * 7)
      let d = p < wn ? prev_days[-wn + p] : p < ld ? days[p - wn] : next_days[p - ld]
      let x = (w * 7 + v.pad) * i + v.width * mi
      let y = mh * mj + h * j + v.offset
      if wn <= p && p < ld
        let s[y] .= printf(e.format, d.get_day())
        if today.eq(d)
          for k in range(mh) " Do not use .height()
            call add(self.top_syntax, calendar#text#new(2, x, y + k, 'Today'))
          endfor
        elseif has_key(holidays, join(d.get_ymd(), '-'))
          for k in range(mh) " Do not use .height()
            call add(self.top_syntax, calendar#text#new(2, x, y + k, 'Sunday'))
          endfor
        elseif d.is_sunday()
          if sun[0] < 0 | let sun[0] = x | endif
          let sun[2 - (sun[1] < 0)] = y
        elseif d.is_saturday()
          if sat[0] < 0 | let sat[0] = x | endif
          let sat[2 - (sat[1] < 0)] = y
        endif
        let dd = d
      else
        let s[y] .= e.white
      endif
      if mi == 6
        let [mi, mj] = [0, mj + 1]
        if week_number
          call add(self.top_syntax, calendar#text#new(2, len(s[y]), y, 'Comment'))
          let s[y] .= printf('%2d', calendar#week#week_number(dd))
        else
          let s[y] .= '  '
        endif
      else
        let mi = mi + 1
      endif
    endfor
    if sun[0] >= 0
      if sun[2] < 0 | let sun[2] = sun[1] | endif
      if len(syntax) && syntax[-1].y == sun[1]
        call add(syntax[-1].syn, ['Sunday', sun[1], sun[0], sun[0] + 2, sun[2] - sun[1] + mh])
      elseif len(syntax) > 1 && syntax[-2].y == sun[1]
        call add(syntax[-2].syn, ['Sunday', sun[1], sun[0], sun[0] + 2, sun[2] - sun[1] + mh])
      else
        call add(syntax, calendar#text#new(2, sun[0], sun[1], 'Sunday').height(sun[2] - sun[1] + mh))
      endif
    endif
    if sat[0] >= 0
      if sat[2] < 0 | let sat[2] = sat[1] | endif
      if len(syntax) && syntax[-1].y == sat[1]
        call add(syntax[-1].syn, ['Saturday', sat[1], sat[0], sat[0] + 2, sat[2] - sat[1] + mh])
      elseif len(syntax) > 1 && syntax[-2].y == sat[1]
        call add(syntax[-2].syn, ['Saturday', sat[1], sat[0], sat[0] + 2, sat[2] - sat[1] + mh])
      else
        call add(syntax, calendar#text#new(2, sat[0], sat[1], 'Saturday').height(sat[2] - sat[1] + mh))
      endif
    endif
    call add(self.sun_position, sun)
    call add(self.sat_position, sat)
    for jj in range(mj, h - v.offset)
      let y = mh * jj + h * j + v.offset
      if y < len(s) && y < h * (j + 1)
        let s[y] .= repeat(e.white, 7) . '  '
      else
        break
      endif
    endfor
    if i == self.x_months - 1 | let [i, j] = [0, j + 1] | else | let i = i + 1 | endif
    if j >= self.y_months | break | endif
  endfor
  let self._today = today.get_ymd()
  let self._first_day = calendar#setting#get('first_day')
  if self.is_full()
    let self._year = b:calendar.year().get_y()
  else
    let self._month = b:calendar.month().get_ym()
  endif
  let self.days = map(range(len(s)), 'calendar#text#new(s[v:val], 0, v:val, "")')
  let self.syntax = syntax
endfunction

function! s:instance.contents() dict abort
  if get(self, '_first_day', '') != calendar#setting#get('first_day') | call self.on_resize() | endif
  if self.changed() | call self.set_contents() | endif
  let [v, e] = [self.view, self.element]
  let [mh, h, w] = [v.dheight, v.height, v.width]
  let select = []
  let month = b:calendar.month()
  let ij = month.sub(self.get_months()[0])
  let [i, j] = [ij % self.x_months, ij / self.x_months]
  let o = self.month_names_offset[j]
  let sunsat = []
  if self.is_selected()
    for x in range(calendar#week#week_count(month) * mh + v.offset)
      let l = x ? (x > 1 ? w * 7 : self.day_names_len) : o[i * 2 + 1] - o[i * 2]
      let offset = x ? ((x > 1 ? w * 7 : self.day_names_len) + v.pad) * i : o[i * 2]
      if x != mh
        call add(select, calendar#text#new(l - (self.view.width - 2), offset, h * j + x, 'Select'))
      endif
    endfor
    call add(select, calendar#text#new(0, o[i * 2], h * j, 'Cursor'))
    let sun = self.sun_position[ij]
    for j in range(sun[2] - sun[1] + mh - 1)
      call add(sunsat, calendar#text#new(2, sun[0], sun[1] + j + 1, ''))
    endfor
    let sat = self.sat_position[ij]
    for j in range(sat[2] - sat[1] + mh - 1)
      call add(sunsat, calendar#text#new(2, sat[0], sat[1] + j + 1, ''))
    endfor
  endif
  return deepcopy(self.days) + select + deepcopy(self.syntax) + sunsat + deepcopy(self.top_syntax)
endfunction

function! s:instance.action(action) dict abort
  let month = b:calendar.month()
  let months = self.get_months()
  let ij = month.sub(months[0])
  let [x, y] = [self.x_months, self.y_months]
  let [i, j] = [ij % x, ij / x]
  if a:action ==# 'left'
    call b:calendar.move_month(self.is_full() ? max([-v:count1, - i]) : -v:count1 * y)
  elseif a:action ==# 'right'
    call b:calendar.move_month(self.is_full() ? min([v:count1, x - 1 - i]) : v:count1 * y)
  elseif index(['prev', 'next', 'space', 'add', 'subtract'], a:action) >= 0
    call b:calendar.move_month(v:count1 * (a:action ==# 'prev' || a:action ==# 'subtract' ? -1 : 1))
  elseif index(['down', 'up', 'scroll_down', 'scroll_up'], a:action) >= 0
    call b:calendar.move_month(v:count1 * (a:action =~# 'down' ? 1 : -1) * x)
  elseif index(['plus', 'minus'], a:action) >= 0
    call b:calendar.move_month(v:count1 * (a:action ==# 'plus' ? 1 : -1) * x - i)
  elseif index(['down_big', 'up_big'], a:action) >= 0
    call b:calendar.move_month(v:count1 * (a:action ==# 'down_big' ? 1 : -1) * (self.is_full() ? x * 2 : len(months)))
  elseif index(['down_large', 'up_large'], a:action) >= 0
    call b:calendar.move_year(v:count1 * (a:action ==# 'down_large' ? 1 : -1))
  elseif a:action ==# 'line_head'
    call b:calendar.move_month(self.is_full() ? -i : -x * y / 2)
  elseif a:action ==# 'line_middle'
    call b:calendar.move_month(self.is_full() ? (x - 1) / 2 - i : 0)
  elseif a:action ==# 'line_last'
    call b:calendar.move_month(self.is_full() ? x - 1 - i : x * y / 2)
  elseif a:action ==# 'bar'
    call b:calendar.move_month(min([v:count1, x]) - (self.is_full() ? i + 1 : (x + 1) / 2))
  elseif a:action ==# 'first_line' || a:action ==# 'first_line_head'
    call b:calendar.move_month(- ij)
  elseif a:action ==# 'last_line'
    call b:calendar.move_month(-month.sub(months[-x]))
  elseif a:action ==# 'last_line_last'
    call b:calendar.move_month(-month.sub(months[-1]))
  elseif a:action ==# 'command_enter' && mode() ==# 'c' && getcmdtype() ==# ':'
    let cmd = calendar#util#getcmdline()
    if cmd =~# '^\s*\d\+\s*$'
      let c = max([min([cmd * 1, 12]), 1])
      call b:calendar.move_month(c - month.get_month())
      return calendar#util#update_keys()
    endif
  endif
endfunction

let s:super_constructor = calendar#constructor#view#new(s:instance)

let &cpo = s:save_cpo
unlet s:save_cpo
