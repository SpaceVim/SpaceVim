" =============================================================================
" Filename: autoload/calendar/view.vim
" Author: itchyny
" License: MIT License
" Last Change: 2019/08/07 21:22:19.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#view#new() abort
  let self = copy(s:self)
  call self.set_view_source(calendar#setting#get('view_source'))
  call self.set_calendar_views(calendar#setting#get('views'))
  call self.set_index(calendar#setting#get('view'))
  call self.set_task_visibility(calendar#setting#get('task'))
  return self
endfunction

let s:self = {}

let s:self.index = 0
let s:self.calendar_views = ['year', 'month', 'week', 'day_4', 'day_1', 'clock']
let s:self.index_max = len(s:self.calendar_views) - 1
let s:self.updated = 1
let s:self._help = 0
let s:self._task = 0
let s:self._event = 0
let s:self._help_order = []
let s:self._event_order = []

function! s:self.set_calendar_views(views) dict abort
  let views = [ 'year', 'month', 'week', 'weekday', 'day_7', 'day_6', 'day_5', 'day_4', 'day_3', 'day_2', 'day_1', 'day', 'clock', 'event', 'agenda' ]
  let calendar_views = filter(a:views, 'index(views, v:val) >= 0')
  if len(calendar_views) > 0
    let self.calendar_views = calendar_views
    let self.index_max = len(self.calendar_views) - 1
  endif
  return self
endfunction

function! s:self.get_calendar_views() dict abort
  return self.calendar_views[self.index]
endfunction

function! s:self.set_index(view) dict abort
  let i = index(self.calendar_views, a:view)
  if i < 0
    if a:view ==# 'day'
      let i = index(self.calendar_views, 'day_1')
    elseif a:view ==# 'days'
      let days = filter(copy(self.calendar_views), 'v:val =~# "^day_[2-6]"')
      if len(days)
        let i = index(self.calendar_views, days[0])
      endif
    elseif a:view ==# 'week'
      let i = index(self.calendar_views, 'day_7')
    endif
  endif
  let self.index = i < 0 ? 0 : i
  let self.updated = 1
  return self
endfunction

function! s:self.change_index(diff) dict abort
  if calendar#setting#get('cyclic_view')
    let m = self.index_max + 1
    let self.index = (((self.index + a:diff) % m) + m) % m
  else
    let self.index = min([max([self.index + a:diff, 0]), self.index_max])
  endif
  let self.updated = 1
endfunction

function! s:self.event_visible() dict abort
  return self._event
endfunction

function! s:self.task_visible() dict abort
  return self._task
endfunction

function! s:self.set_task_visibility(_task) dict abort
  let self._task = type(a:_task) == type('') ? a:_task ==# '1' : a:_task
endfunction

function! s:self.help_visible() dict abort
  return self._help
endfunction

function! s:self.set_view_source(source) dict abort
  let self.source = a:source
  let self.views = map(deepcopy(self.source), 'calendar#view#{v:val.type}#new(v:val)')
  let self.order = range(len(self.source))
  return self
endfunction

function! s:self.current_view() dict abort
  return self.views[self.current_view_index()]
endfunction

function! s:self.current_view_index() dict abort
  let i = len(self.order) - 1
  while !self.views[self.order[i]].is_visible()
    let i -= 1
  endwhile
  return self.order[i]
endfunction

function! s:self.view_count() dict abort
  let num = 0
  for i in range(len(self.order))
    let num += self.views[self.order[i]].is_visible()
  endfor
  return num
endfunction

function! s:self.visible_num() dict abort
  let num = 0
  for i in range(len(self.views))
    if self.views[i].is_visible()
      let num += 1
    endif
  endfor
  return num
endfunction

function! s:self.event_view() dict abort
  for i in range(len(self.views))
    if self.views[i].source.type ==# 'event'
      return self.views[i]
    endif
  endfor
endfunction

function! s:self.get_overlap() dict abort
  let height = calendar#util#winheight()
  let diffy = max([(height - self.ymax()) / 2, 0])
  let o = []
  let lw = []
  for i in range(height)
    call add(o, [])
    call add(lw, [])
  endfor
  let f = 0
  if self.visible_num() > 1
    for i in range(len(self.order))
      let c = self.views[self.order[i]]
      if c.is_visible()
        let [p, l, h, w] = [c.get_top() + (c.is_absolute() ? 0 : diffy), c.get_left(), c.sizey(), c.sizex()]
        let r = range(p, p + h - 1)
        for j in r
          if j < len(o)
            call add(o[j], i)
            call add(lw[j], [l, w])
            if len(o[j]) <= 1
              continue
            else
              let f = 1
              if len(o[j]) == 2
                if lw[j][0][0] <= l && lw[j][0][0] + lw[j][0][1] >= l
                  call insert(o[j], -1)
                elseif lw[j][0][0] >= l
                  if lw[j][0][0] < l + w
                    call insert(o[j], -1)
                  else
                    let o[j] = [o[j][1], o[j][0]]
                  endif
                endif
              else
                call insert(o[j], -1)
              endif
            endif
          endif
        endfor
      endif
    endfor
  endif
  return [f, o, diffy]
endfunction

function! s:self.ymax() dict abort
  let d = len(self.order)
  let ymax = 0
  for i in range(d)
    let c = self.views[self.order[i]]
    if c.is_visible() && !c.is_absolute()
      let ymax = max([ymax, c.get_top() + c.sizey()])
    endif
  endfor
  return ymax
endfunction

let [s:height, s:width] = [0, 0]
function! s:self.gather(...) dict abort
  let d = len(self.order)
  let updated = self.updated || a:0 && a:1
  for i in range(d)
    let c = self.views[self.order[i]]
    call c.set_index(self.calendar_views[self.index])
    call c.set_size()
    let updated = updated || (c.is_visible() && c.updated()) " Do not break
  endfor
  if !updated | return 1 | endif
  let self.updated = 0
  let [height, width] = [calendar#util#winheight(), calendar#util#winwidth()]
  if [s:height, s:width] != [height, width]
    let [s:height, s:width] = [height, width]
    let s:texts = map(range(s:height), 'calendar#text#new(repeat(" ", s:width), 0, v:val, "")')
    let s:llen = map(range(s:height), '0')
  endif
  let texts = deepcopy(s:texts)
  let llen = deepcopy(s:llen)
  let index = self.current_view_index()
  let [f, v, diffy] = self.get_overlap()
  for i in range(d)
    let c = self.views[self.order[i]]
    if !c.is_visible()
      continue
    endif
    call c.set_selected(self.order[i] == index)
    let r = c.gather(c.is_absolute() ? 0 : diffy)
    for t in r
      if 0 <= t.y && t.y < height
        if t.t && llen[t.y]
          call t.move(llen[t.y], 0)
        endif
        if f && t.t
          call s:split_over(t, texts, v, llen, i, height)
        endif
        let l = texts[t.y].over(t)
        if !t.t | let llen[t.y] = l | endif
      endif
    endfor
  endfor
  return texts
endfunction

function! s:split_over(t, texts, v, llen, i, height) abort
  let t = a:t
  if len(t.syn) && len(t.syn[0]) == 5
    let flg = 0
    for k in range(len(t.syn))
      for j in range(min([t.syn[k][4], a:height - t.y]))
        let flg = flg || len(a:v[t.y + j]) > 1 && a:v[t.y + j][0] != a:i
      endfor
      if flg | break | endif
    endfor
    if flg
      for s in t.split()
        if s.y < a:height
          call s.move(a:llen[s.y] - a:llen[t.y], 0)
          call a:texts[s.y].over(s)
        endif
      endfor
    endif
  endif
endfunction

function! s:self.action(action) dict abort
  let ret = self.current_view().action(a:action)
  if type(ret) == 0 && ret == 0
    if a:action ==# 'redraw'
      call b:calendar.update_force_redraw()
      return 1
    elseif a:action ==# 'tab'
      if self.view_count() > 1 && !self.current_view().on_top()
        let index = self.current_view_index()
        let next = index
        while !self.views[next].is_visible() || next == index
          let next = (next + 1) % len(self.views)
        endwhile
        let idx = index(self.order, next)
        if idx >= 0
          call remove(self.order, idx)
          let self.order = add(self.order, next)
        endif
      endif
    elseif a:action ==# 'shift_tab'
      if self.view_count() > 1 && !self.current_view().on_top()
        let index = self.current_view_index()
        let next = index
        while !self.views[next].is_visible() || next == index
          let next = (next - 1 + len(self.views)) % len(self.views)
        endwhile
        let idx = index(self.order, next)
        if idx >= 0
          call remove(self.order, idx)
          let self.order = add(self.order, next)
        endif
      endif
    elseif a:action ==# 'status'
      let select = calendar#day#join_date(b:calendar.day().get_ymd())
      let selectmd = calendar#day#join_date(b:calendar.day().get_ymd()[1:])
      let today = calendar#day#join_date(calendar#day#today().get_ymd())
      let diffnum = b:calendar.day().sub(calendar#day#today())
      let diff = diffnum >= 0 ? '+' . diffnum : '' . diffnum
      let todaystr = calendar#message#get('today')
      let dayof = b:calendar.day().sub(b:calendar.day().year().head_day()) + 1
      let yeardays = b:calendar.day().year().last_day().sub(b:calendar.day().year().head_day()) + 1
      let daypercent = 100 * dayof / yeardays
      let message = printf('%s %s/%s --%d%%-- %s %s %s', select, dayof, yeardays, daypercent, todaystr, today, diff)
      let winw = calendar#util#winwidth() - 14
      if calendar#string#strdisplaywidth(message) > winw
        let message = printf('%s %s/%s --%d%%-- %s %s', select, dayof, yeardays, daypercent, today, diff)
        if calendar#string#strdisplaywidth(message) > winw
          let message = printf('%s %s/%s %s %s', select, dayof, yeardays, today, diff)
          if calendar#string#strdisplaywidth(message) > winw
            let message = printf('%s %s/%s', select, dayof, yeardays)
            if calendar#string#strdisplaywidth(message) > winw
              let message = printf('%s', select)
              if calendar#string#strdisplaywidth(message) > winw
                let message = printf('%s', selectmd)
              endif
            endif
          endif
        endif
      endif
      call calendar#echo#message(message)
    elseif a:action ==# 'today'
      call b:calendar.move_day(-b:calendar.day().sub(calendar#day#today()))
      call b:calendar.move_second(-b:calendar.time().sub(calendar#time#now()))
    elseif a:action ==# 'help'
      let self.updated = 1
      let ii = -1
      for i in range(len(self.order))
        if self.views[i].source.type ==# 'help'
          let ii = i
        endif
      endfor
      let self._help = !self._help
      if ii >= 0 && self._help
        let self._help_order = copy(self.order)
        let i = index(self.order, ii)
        if i >= 0
          call remove(self.order, i)
          let self.order = add(self.order, ii)
        endif
      elseif has_key(self, '_help_order')
        let self.order = self._help_order
        let self._help = 0
      endif
    elseif a:action ==# 'task'
      if self.current_view().on_top() && self.current_view().source.type !=# 'task'
        return
      endif
      let self.updated = 1
      let ii = -1
      for i in range(len(self.order))
        if self.views[i].source.type ==# 'task'
          let ii = i
        endif
      endfor
      let self._task = !self._task
      if ii >= 0 && self._task
        let self._task_order = copy(self.order)
        let i = index(self.order, ii)
        if i >= 0
          let self.order = self.order[i + 1:] + self.order[:i]
        endif
      elseif has_key(self, '_task_order')
        let self.order = self._task_order
        let self._task = 0
      elseif ii >= 0 && !self._task
        let self.order = filter(copy(self.order), 'v:val != ii') + [ii]
      endif
    elseif a:action ==# 'close_task'
      if self._task
        call self.action('task')
      endif
    elseif a:action ==# 'event'
      if self.current_view().on_top() && self.current_view().source.type !=# 'event'
        return
      endif
      let self.updated = 1
      let ii = -1
      for i in range(len(self.order))
        if self.views[i].source.type ==# 'event'
          let ii = i
        endif
      endfor
      let self._event = !self._event
      if ii >= 0 && self._event
        let self._event_order = copy(self.order)
        let i = index(self.order, ii)
        if i >= 0
          let self.order = self.order[i + 1:] + self.order[:i]
        endif
      elseif has_key(self, '_event_order')
        let self.order = self._event_order
        let self._event = 0
      endif
    elseif a:action ==# 'close_event'
      if self._event
        call self.action('event')
      endif
    elseif a:action ==# 'hide'
      try
        bunload!
      catch
        enew!
      endtry
      return 1
    elseif a:action ==# 'exit'
      bwipeout!
      return 1
    elseif a:action ==# 'view_left'
      call self.change_index(-v:count1)
    elseif a:action ==# 'view_right'
      call self.change_index(v:count1)
    elseif a:action ==# 'command_enter' && mode() ==# 'c'
      if getcmdtype() ==# ':'
        let cmd = calendar#util#getcmdline()
        let digits = []
        if cmd =~# '\v^\s*marks\s*$'
          call b:calendar.mark.showmarks()
          return calendar#util#update_keys()
        elseif cmd =~# '\v^\s*(ma%[rk]\s+|k\s*)[a-z]\s*$'
          let mark = matchstr(cmd, '\v[a-z](\s*$)@=')
          call b:calendar.mark.set(mark)
          return calendar#util#update_keys()
        elseif cmd =~# '\v^\s*delm%[arks]!\s*$'
          call b:calendar.mark.delmarks()
          return calendar#util#update_keys()
        elseif cmd =~# '\v^\s*delm%[arks]\s+[a-z]\s*$'
          let mark = matchstr(cmd, '\v[a-z](\s*$)@=')
          call b:calendar.mark.delmarks(mark)
          return calendar#util#update_keys()
        elseif cmd =~# '\v^\s*\d+\s*$'
          return calendar#util#update_keys()
        elseif cmd =~# '\v^\s*\d+\s*/\s*\d+\s*(/\s*\d+\s*)?$'
          let digits = map(split(cmd, '/'), 'matchstr(v:val, "\\v\\d+") * 1')
        elseif cmd =~# '\v^\s*\d+\s*-\s*\d+\s*(-\s*\d+\s*)?$'
          let digits = map(split(cmd, '-'), 'matchstr(v:val, "\\v\\d+") * 1')
        elseif cmd =~# '\v^\s*\d+\s*\.\s*\d+\s*(\.\s*\d+\s*)?$'
          let digits = map(split(cmd, '\.'), 'matchstr(v:val, "\\v\\d+") * 1')
        elseif cmd =~# '\v^\s*\d+\s+\d+\s*(\s+\d+\s*)?$'
          let digits = map(split(cmd, '\s\+'), 'matchstr(v:val, "\\v\\d+") * 1')
        elseif cmd =~# '\v^\s*\d*\s*(\<\s*)+\d*$'
          let c = matchstr(cmd, '\d\+')
          let d = len(cmd) - len(substitute(cmd, '<', '', 'g'))
          call self.change_index(-max([len(c) ? c + 0 : 1, 1]) * d)
          return calendar#util#update_keys()
        elseif cmd =~# '\v^\s*\d*\s*(\>\s*)+\d*$'
          let c = matchstr(cmd, '\d\+')
          let d = len(cmd) - len(substitute(cmd, '>', '', 'g'))
          call self.change_index(max([len(c) ? c + 0 : 1, 1]) * d)
          return calendar#util#update_keys()
        endif
        if len(digits)
          call b:calendar.set_day(calendar#argument#day(digits, b:calendar.day().get_ymd()))
          call b:calendar.set_month()
          return calendar#util#update_keys()
        else
          return "\<CR>"
        endif
      else
        return "\<CR>"
      endif
    endif
  endif
  return ret
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
