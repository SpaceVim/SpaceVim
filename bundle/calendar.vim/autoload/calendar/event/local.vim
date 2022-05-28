" =============================================================================
" Filename: autoload/calendar/event/local.vim
" Author: itchyny
" License: MIT License
" Last Change: 2021/01/30 16:44:33.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#event#local#new() abort
  return deepcopy(s:self)
endfunction

let s:cache = calendar#cache#new('local')

let s:event_cache = s:cache.new('event')

let s:self = {}
let s:self._key = {}
let s:self._events = {}

function! s:self.get_events_one_month(year, month, ...) dict abort
  let events = {}
  let calendarList = self.calendarList()
  let [y, m] = [printf('%04d', a:year), printf('%02d', a:month)]
  let clock_12hour = calendar#setting#get('clock_12hour')
  for calendar in calendarList
    let syn = calendar#color#new_syntax(get(calendar, 'id', ''), get(calendar, 'foregroundColor', ''), get(calendar, 'backgroundColor'))
    unlet! c
    let c = s:event_cache.new(calendar.id).new(y).new(m).get('0')
    if type(c) != type({}) || type(get(c, 'items')) != type([])
      continue
    endif
    for itm in c.items
      if !(has_key(itm, 'start') && (has_key(itm.start, 'date') || has_key(itm.start, 'dateTime'))
            \ && has_key(itm, 'end') && (has_key(itm.end, 'date') || has_key(itm.end, 'dateTime')))
        continue
      endif
      let isTimeEvent = (!has_key(itm.start, 'date')) && has_key(itm.start, 'dateTime') && (!has_key(itm.end, 'date')) && has_key(itm.end, 'dateTime')
      let ymd = calendar#time#datetime(get(itm.start, 'date', get(itm.start, 'dateTime', '')))
      let endymd = calendar#time#datetime(get(itm.end, 'date', get(itm.end, 'dateTime', '')))
      if len(ymd) != 6 || len(endymd) != 6
        continue
      endif
      let date = join(ymd[:2], '-')
      if has_key(itm.end, 'date')
        let endymd = ymd[:2] == [endymd[0], endymd[1], endymd[2] - 1] ? ymd : calendar#day#new(endymd[0], endymd[1], endymd[2]).add(-1).get_ymd() + endymd[3:]
      endif
      if clock_12hour
        let start_postfix = ymd[3] < 12 || ymd[3] == 24 ? 'am' : 'pm'
        let end_postfix = endymd[3] < 12 || endymd[3] == 24 ? 'am' : 'pm'
        let starttime = ymd[5] ?
              \ printf('%d:%02d:%02d%s', calendar#time#hour12(ymd[3]), ymd[4], ymd[5], start_postfix ==# end_postfix ? '' : start_postfix) :
              \ printf('%d:%02d%s', calendar#time#hour12(ymd[3]), ymd[4], start_postfix ==# end_postfix ? '' : start_postfix)
        let endtime = endymd[5] ?
              \ printf('%d:%02d:%02d%s', calendar#time#hour12(endymd[3]), endymd[4], endymd[5], end_postfix) :
              \ printf('%d:%02d%s', calendar#time#hour12(endymd[3]), endymd[4], end_postfix)
      else
        let starttime = ymd[5] ? printf('%d:%02d:%02d', ymd[3], ymd[4], ymd[5]) : printf('%d:%02d', ymd[3], ymd[4])
        let endtime = endymd[5] ? printf('%d:%02d:%02d', endymd[3], endymd[4], endymd[5]) : printf('%d:%02d', endymd[3], endymd[4])
      endif
      if !has_key(events, date)
        let events[date] = { 'events': [] }
      endif
      call add(events[date].events, extend(itm,
            \ { 'calendarId': calendar.id
            \ , 'calendarSummary': calendar.summary
            \ , 'syntax': syn
            \ , 'isTimeEvent': isTimeEvent
            \ , 'isHoliday': 0
            \ , 'isMoon': 0
            \ , 'isDayNum': 0
            \ , 'isWeekNum': 0
            \ , 'starttime': starttime
            \ , 'endtime': endtime
            \ , 'ymdnum': (((ymd[0] * 100 + ymd[1]) * 100) + ymd[2])
            \ , 'hms': ymd[3:]
            \ , 'sec': isTimeEvent ? ((ymd[3] * 60) + ymd[4]) * 60 + ymd[5]
            \        : get(itm, 'summary', '') =~# '\v^\d\d?:\d\d(:\d\d)?\s+' ? s:extract_time_sec(itm.summary) : 0
            \ , 'ymd': ymd[:2]
            \ , 'endhms': endymd[3:]
            \ , 'endymd': endymd[:2] }))
    endfor
  endfor
  for date in keys(events)
    call sort(events[date].events, function('s:events_sorter'))
  endfor
  return events
endfunction

function! s:extract_time_sec(summary) abort
  let xs = matchlist(a:summary, '\v^(\d\d?):(\d\d)%(:(\d\d))?')
  return ((xs[1] * 60) + xs[2]) * 60 + xs[3]
endfunction

function! s:events_sorter(x, y) abort
  return a:x.calendarId ==# a:y.calendarId
        \ ? (a:x.sec == a:y.sec
        \   ? (get(a:x, 'summary', '') > get(a:y, 'summary', '') ? 1 : -1)
        \ : a:x.sec > a:y.sec ? 1 : -1) : 0
endfunction

function! s:self.update(calendarId, eventId, title, year, month, ...) dict abort
  let calendarList = self.calendarList()
  let [y, m] = [printf('%04d', a:year), printf('%02d', a:month)]
  for calendar in calendarList
    if calendar.id ==# a:calendarId
      let c = s:event_cache.new(calendar.id).new(y).new(m).get('0')
      let cnt = type(c) == type({}) && has_key(c, 'items') && type(c.items) == type([]) ? c : { 'items': [] }
      for i in range(len(cnt.items))
        if cnt.items[i].id ==# a:eventId
          let cnt.items[i].summary = a:title
          call extend(cnt.items[i], a:0 ? a:1 : {})
          call s:event_cache.new(calendar.id).new(y).new(m).save('0', cnt)
          return
        endif
      endfor
    endif
  endfor
endfunction

function! s:self.insert(calendarId, title, start, end, year, month, ...) dict abort
  let calendarList = self.calendarList()
  let [y, m] = [printf('%04d', a:year), printf('%02d', a:month)]
  if a:start =~# '\v^\d+[-/]\d+[-/]\d+'
    let ymd = map(split(matchstr(a:start, '\v^\d+[-/]\d+[-/]\d+'), '[-/]'), 'v:val + 0')
    let [y, m] = [printf('%04d', ymd[0]), printf('%02d', ymd[1])]
  elseif a:start =~# '\v^\d+[-/]\d+'
    let md = map(split(matchstr(a:start, '\v^\d+[-/]\d+'), '[-/]'), 'v:val + 0')
    let m = printf('%04d', md[0])
  endif
  for calendar in calendarList
    if calendar.id ==# a:calendarId
      let c = s:event_cache.new(calendar.id).new(y).new(m).get('0')
      let cnt = type(c) == type({}) && has_key(c, 'items') && type(c.items) == type([]) ? c : { 'items': [] }
      call add(cnt.items,
            \ { 'id': calendar#util#id()
            \ , 'summary': a:title
            \ , 'start': a:start =~# '\vT\d+' ? { 'dateTime': a:start } : { 'date': a:start }
            \ , 'end': a:end =~# '\vT\d+' ? { 'dateTime': a:end } : { 'date': a:end }
            \ })
      call s:event_cache.new(calendar.id).new(y).new(m).save('0', cnt)
      return
    endif
  endfor
endfunction

function! s:self.move(calendarId, eventId, destination, year, month) dict abort
  let calendarList = self.calendarList()
  let [y, m] = [printf('%04d', a:year), printf('%02d', a:month)]
  let event = {}
  for calendar in calendarList
    if calendar.id ==# a:calendarId
      let c = s:event_cache.new(calendar.id).new(y).new(m).get('0')
      let cnt = type(c) == type({}) && has_key(c, 'items') && type(c.items) == type([]) ? c : { 'items': [] }
      for i in range(len(cnt.items))
        if cnt.items[i].id ==# a:eventId
          let event = deepcopy(cnt.items[i])
          call remove(cnt.items, i)
          call s:event_cache.new(calendar.id).new(y).new(m).save('0', cnt)
          break
        endif
      endfor
    endif
  endfor
  for calendar in calendarList
    if calendar.id ==# a:destination
      let c = s:event_cache.new(calendar.id).new(y).new(m).get('0')
      let cnt = type(c) == type({}) && has_key(c, 'items') && type(c.items) == type([]) ? c : { 'items': [] }
      call add(cnt.items,
            \ { 'id': calendar#util#id()
            \ , 'summary': event.summary
            \ , 'start': event.start
            \ , 'end': event.end
            \ })
      call s:event_cache.new(calendar.id).new(y).new(m).save('0', cnt)
      return
    endif
  endfor
endfunction

function! s:self.delete(calendarId, eventId, year, month) dict abort
  let calendarList = self.calendarList()
  let [y, m] = [printf('%04d', a:year), printf('%02d', a:month)]
  for calendar in calendarList
    if calendar.id ==# a:calendarId
      let c = s:event_cache.new(calendar.id).new(y).new(m).get('0')
      let cnt = type(c) == type({}) && has_key(c, 'items') && type(c.items) == type([]) ? c : { 'items': [] }
      for i in range(len(cnt.items))
        if cnt.items[i].id ==# a:eventId
          call remove(cnt.items, i)
          call s:event_cache.new(calendar.id).new(y).new(m).save('0', cnt)
          return
        endif
      endfor
    endif
  endfor
endfunction

function! s:self.calendarList() dict abort
  if has_key(self, '_calendarList')
    return self._calendarList
  endif
  let self._calendarList = []
  let cnt = s:cache.get('calendarList')
  if type(cnt) == type({}) && has_key(cnt, 'items') && type(cnt.items) == type([])
    let self._calendarList = filter(cnt.items, 'has_key(v:val, "id") && has_key(v:val, "summary")')
  endif
  return self._calendarList
endfunction

function! s:self.createCalendar() dict abort
  let cnt = s:cache.get('calendarList')
  if type(cnt) == type({}) && has_key(cnt, 'items') && type(cnt.items) == type([])
    let c = cnt
  else
    let c = { 'items': [] }
  endif
  redraw
  let calendarTitle = input(calendar#message#get('input_calendar_name'))
  if len(calendarTitle)
    let colors = []
    for itm in c.items
      if has_key(itm, 'backgroundColor')
        call add(colors, itm.backgroundColor)
      endif
    endfor
    let newcolors = filter(calendar#color#colors(), 'index(colors, v:val) >= 0')
    if len(newcolors) == 0
      let newcolors = calendar#color#colors()
    endif
    call add(c.items,
          \ { 'id': calendar#util#id()
          \ , 'summary': calendarTitle
          \ , 'backgroundColor': newcolors[0]
          \ , 'foregroundColor': '#000000'
          \ })
    call s:cache.save('calendarList', c)
    if has_key(self, '_calendarList')
      unlet! self._calendarList
    endif
  endif
endfunction

function! s:self.clear_cache() dict abort
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
