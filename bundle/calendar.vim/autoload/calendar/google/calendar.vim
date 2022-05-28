" =============================================================================
" Filename: autoload/calendar/google/calendar.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/11/19 07:40:32.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:cache = calendar#cache#new('google')

let s:event_cache = s:cache.new('event')

let g:calendar_google_event_download = 0
let g:calendar_google_event_downloading = {}
let g:calendar_google_event_downloading_list = 0

function! calendar#google#calendar#get_url(type) abort
  return 'https://www.googleapis.com/calendar/v3/' . a:type
endfunction

function! calendar#google#calendar#getCalendarList() abort
  let calendarList = s:cache.get('calendarList')
  if (!g:calendar_google_event_downloading_list) && (type(calendarList) != type({}) ||
        \ calendar#timestamp#update('google_calendarlist', 24 * 60 * 60))
    let g:calendar_google_event_downloading_list = 1
    call calendar#google#client#get_async(s:newid(['calendarList', 0]),
          \ 'calendar#google#calendar#getCalendarList_response',
          \ calendar#google#calendar#get_url('users/me/calendarList'))
  endif
  return type(calendarList) == type({}) ? calendarList : {}
endfunction

function! calendar#google#calendar#getCalendarList_response(id, response) abort
  let [_calendarlist, err; rest] = s:getdata(a:id)
  if a:response.status =~# '^2'
    let cnt = calendar#webapi#decode(a:response.content)
    let content = type(cnt) == type({}) ? cnt : {}
    if has_key(content, 'items') && type(content.items) == type([])
      let content.items = filter(deepcopy(content.items), 'get(v:val, "accessRole", "") ==# "owner"')
            \           + filter(deepcopy(content.items), 'get(v:val, "accessRole", "") !=# "owner"')
      call s:cache.save('calendarList', content)
      let g:calendar_google_event_downloading_list = 0
      let g:calendar_google_event_download = 3
      silent! let b:calendar.event._updated = 3
      silent! call b:calendar.update()
    endif
  elseif a:response.status == 401
    if err == 0
      call calendar#google#client#refresh_token()
      call calendar#google#client#get_async(s:newid(['calendarList', err + 1]),
            \ 'calendar#google#calendar#getCalendarList_response',
            \ calendar#google#calendar#get_url('users/me/calendarList'))
    endif
  endif
endfunction

function! calendar#google#calendar#getMyCalendarList() abort
  let calendarList = calendar#google#calendar#getCalendarList()
  let validCalendar = filter(get(deepcopy(calendarList), 'items', []), 'type(v:val) == type({}) && has_key(v:val, "summary") && has_key(v:val, "id")')
  return filter(validCalendar, 'get(v:val, "selected") && (get(v:val, "accessRole", "") ==# "owner" || (get(v:val, "summary", "") !=# "Phases of the Moon") && get(v:val, "id", "") !~# "holiday@")')
endfunction

function! calendar#google#calendar#getColors() abort
  let colors = s:cache.get('colors')
  if calendar#timestamp#update('google_calendarcolor', 7 * 24 * 60 * 60)
    call calendar#google#client#get_async(s:newid(['calendarColor', 0]),
          \ 'calendar#google#calendar#getColors_response',
          \ calendar#google#calendar#get_url('colors'))
  endif
  return type(colors) == type({}) ? colors : {}
endfunction

function! calendar#google#calendar#getColors_response(id, response) abort
  let [_calendarlist, err; rest] = s:getdata(a:id)
  let colors = s:cache.get('colors')
  if a:response.status =~# '^2'
    let cnt = calendar#webapi#decode(a:response.content)
    let content = type(cnt) == type({}) ? cnt : {}
    if has_key(content, 'event') && type(content.event) == type({})
      call s:cache.save('colors', content)
      silent! call b:calendar.update()
    endif
  endif
endfunction

function! calendar#google#calendar#getEventSummary(year, month) abort
  let calendarList = calendar#google#calendar#getCalendarList()
  let events = []
  if has_key(calendarList, 'items') && type(calendarList.items) == type([]) && len(calendarList.items)
    let [y, m] = [printf('%04d', a:year), printf('%02d', a:month)]
    for item in calendarList.items
      unlet! cnt
      if get(item, 'selected')
        let cnt = s:event_cache.new(item.id).new(y).new(m).get('information')
        if type(cnt) == type({}) && has_key(cnt, 'summary')
          call add(events, cnt)
        else
          call calendar#google#calendar#downloadEvents(a:year, a:month)
          break
        endif
      endif
    endfor
  endif
  return events
endfunction

function! calendar#google#calendar#initialDownload(year, month, index) abort
  let myCalendarList = calendar#google#calendar#getMyCalendarList()
  let key = join([a:year, a:month], '/')
  if a:index < len(myCalendarList) && get(s:initial_download, key, 2) < 2
    call calendar#async#new(printf('calendar#google#calendar#downloadEvents(%d, %d, "%s", %d)', a:year, a:month, myCalendarList[a:index].id, a:index))
  endif
endfunction

let s:initial_download = {}
let s:event_download = {}
function! calendar#google#calendar#getEventsInitial(year, month) abort
  let myCalendarList = calendar#google#calendar#getMyCalendarList()
  let events = {}
  let key = join([a:year, a:month], '/')
  if !get(s:initial_download, key)
    let s:initial_download[key] = 1
    if len(myCalendarList) && calendar#timestamp#update(printf('google_calendar_%04d%02d', a:year, a:month), 30 * 60)
      call calendar#async#new(printf('calendar#google#calendar#initialDownload(%d, %d, 0)', a:year, a:month))
    endif
  endif
endfunction

function! calendar#google#calendar#clearCache() abort
  let s:initial_download = {}
  let s:event_download = {}
  unlet! g:calendar_google_event_download
  call calendar#timestamp#clear()
endfunction

" The optional argument: Forcing initial download. s:initial_download is used to check.
function! calendar#google#calendar#getEvents(year, month, ...) abort
  let s:is_dark = calendar#color#is_dark()
  let calendarList = calendar#google#calendar#getCalendarList()
  let colors = get(calendar#google#calendar#getColors(), 'event', {})
  let events = {}
  let key = join([a:year, a:month], '/')
  if a:0 && a:1
    call calendar#google#calendar#getEventsInitial(a:year, a:month)
  endif
  if type(get(calendarList, 'items')) != type([])
    return events
  endif
  let [y, m] = [printf('%04d', a:year), printf('%02d', a:month)]
  let clock_12hour = calendar#setting#get('clock_12hour')
  for item in calendarList.items
    if !get(item, 'selected')
      continue
    endif
    let isHoliday = item.id =~# 'holiday@group.v.calendar.google.com'
    let isMoon = item.summary ==# 'Phases of the Moon' && &enc ==# 'utf-8' && &fenc ==# 'utf-8'
    let isDayNum = item.summary ==# 'Day of the Year'
    let isWeekNum = item.summary ==# 'Week Numbers'
    let calendarsyn = calendar#color#new_syntax(get(item, 'id', ''), get(item, 'foregroundColor', ''), get(item, 'backgroundColor', ''))
    unlet! cnt
    let cnt = s:event_cache.new(item.id).new(y).new(m).get('information')
    if type(cnt) == type({}) && has_key(cnt, 'summary')
      let index = 0
      while 1
        unlet! c
        let c = s:event_cache.new(item.id).new(y).new(m).get(index)
        if type(c) != type({})
          break
        endif
        let index += 1
        if type(get(c, 'items')) != type([])
          continue
        endif
        for itm in c.items
          if !(has_key(itm, 'start') && (has_key(itm.start, 'date') || has_key(itm.start, 'dateTime'))
                \ && has_key(itm, 'end') && (has_key(itm.end, 'date') || has_key(itm.end, 'dateTime')))
            continue
          endif
          if has_key(itm, 'colorId')
            let foregroundColor = get(get(colors, itm.colorId, {}), 'foreground', get(item, 'foregroundColor', ''))
            let backgroundColor = get(get(colors, itm.colorId, {}), 'background', get(item, 'backgroundColor', ''))
            let syn = calendar#color#new_syntax(get(itm, 'id', ''), foregroundColor, backgroundColor)
          else
            let syn = calendarsyn
          endif
          let ymd = calendar#time#datetime(get(itm.start, 'date', get(itm.start, 'dateTime', '')))
          let endymd = calendar#time#datetime(get(itm.end, 'date', get(itm.end, 'dateTime', '')))
          let isTimeEvent = (!has_key(itm.start, 'date')) && has_key(itm.start, 'dateTime') && (!has_key(itm.end, 'date')) && has_key(itm.end, 'dateTime')
          if len(ymd) != 6 || len(endymd) != 6 || [a:year, a:month] != [ymd[0], ymd[1]]
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
          call add(events[date].events,
                \ extend(itm,
                \ { 'calendarId': item.id
                \ , 'calendarSummary': item.summary
                \ , 'syntax': syn
                \ , 'isTimeEvent': isTimeEvent
                \ , 'isHoliday': isHoliday
                \ , 'isMoon': isMoon
                \ , 'isDayNum': isDayNum
                \ , 'isWeekNum': isWeekNum
                \ , 'starttime': starttime
                \ , 'endtime': endtime
                \ , 'ymdnum': (((ymd[0] * 100 + ymd[1]) * 100) + ymd[2])
                \ , 'hms': ymd[3:]
                \ , 'sec': isTimeEvent ? ((ymd[3] * 60) + ymd[4]) * 60 + ymd[5]
                \        : get(itm, 'summary', '') =~# '\v^\d\d?:\d\d(:\d\d)?\s+' ? s:extract_time_sec(itm.summary) : 0
                \ , 'ymd': ymd[:2]
                \ , 'endhms': endymd[3:]
                \ , 'endymd': endymd[:2] }))
          if isHoliday
            let events[date].holiday = events[date].events[-1].summary
            let events[date].hasHoliday = 1
          endif
          if isMoon
            call s:moon_event(events[date])
          endif
          if isDayNum
            let events[date].daynum = matchstr(events[date].events[-1].summary, '\d\+')
          endif
          if isWeekNum
            let events[date].weeknum = matchstr(events[date].events[-1].summary, '\d\+')
          endif
        endfor
      endwhile
    elseif !get(s:event_download, key)
      let s:event_download[key] = 1
      call calendar#google#calendar#downloadEvents(a:year, a:month)
      break
    endif
  endfor
  for date in keys(events)
    call sort(events[date].events, function('calendar#google#calendar#sorter'))
  endfor
  return events
endfunction

function! s:extract_time_sec(summary) abort
  let xs = matchlist(a:summary, '\v^(\d\d?):(\d\d)%(:(\d\d))?')
  return ((xs[1] * 60) + xs[2]) * 60 + xs[3]
endfunction

function! calendar#google#calendar#sorter(x, y) abort
  return a:x.calendarId ==# a:y.calendarId
        \ ? (a:x.sec == a:y.sec
        \   ? (get(a:x, 'summary', '') > get(a:y, 'summary', '') ? 1 : -1)
        \ : a:x.sec > a:y.sec ? 1 : -1) : 0
endfunction

function! s:moon_event(events) abort
  let s = a:events.events[-1].summary
  let m = s =~# '^New moon'      ? (s:is_dark ? "\u25cb" : "\u25cf")
      \ : s =~# '^First quarter' ? (s:is_dark ? "\u25d1" : "\u25d0")
      \ : s =~# '^Full moon'     ? (s:is_dark ? "\u25cf" : "\u25cb")
      \ : s =~# '^Last quarter'  ? (s:is_dark ? "\u25d0" : "\u25d1")
      \ : ''
  let a:events.moon = calendar#string#truncate(m, 2)
  if m !=# ''
    let a:events.events[-1].summary = a:events.moon . ' ' . a:events.events[-1].summary
  endif
endfunction

function! calendar#google#calendar#getHolidays(year, month) abort
  let _calendarList = s:cache.get('calendarList')
  let calendarList = type(_calendarList) == type({}) ? _calendarList : {}
  let events = {}
  if type(get(calendarList, 'items')) != type([])
    return events
  endif
  let [y, m] = [printf('%04d', a:year), printf('%02d', a:month)]
  for item in calendarList.items
    if !get(item, 'selected') || item.id !~# 'holiday@group.v.calendar.google.com'
      continue
    endif
    unlet! cnt
    let cnt = s:event_cache.new(item.id).new(y).new(m).get('information')
    if type(cnt) != type({}) || !has_key(cnt, 'summary')
      continue
    endif
    let index = 0
    while 1
      unlet! c
      let c = s:event_cache.new(item.id).new(y).new(m).get(index)
      if type(c) != type({})
        break
      endif
      let index += 1
      if type(get(c, 'items')) != type([])
        continue
      endif
      for itm in c.items
        if !(has_key(itm, 'start') && (has_key(itm.start, 'date') || has_key(itm.start, 'dateTime'))
              \ && has_key(itm, 'end') && (has_key(itm.end, 'date') || has_key(itm.end, 'dateTime')))
          continue
        endif
        let date = has_key(itm.start, 'date') ? itm.start.date
              \  : has_key(itm.start, 'dateTime') ? matchstr(itm.start.dateTime, '\d\+-\d\+-\d\+') : ''
        let ymd = map(split(date, '-'), 'v:val + 0')
        let enddate = has_key(itm.end, 'date') ? itm.end.date : has_key(itm.end, 'dateTime') ? matchstr(itm.end.dateTime, '\d\+-\d\+-\d\+') : ''
        let endymd = map(split(enddate, '-'), 'v:val + 0')
        if len(ymd) != 3 || len(endymd) != 3
          continue
        endif
        let date = join(ymd, '-')
        if has_key(itm.end, 'date')
          let endymd = calendar#day#new(endymd[0], endymd[1], endymd[2]).add(-1).get_ymd()
        endif
        if !has_key(events, date)
          let events[date] = { 'events': [], 'hasHoliday': 1 }
        endif
        call add(events[date].events,
              \ extend(itm,
              \ { 'calendarId': item.id
              \ , 'calendarSummary': item.summary
              \ , 'holiday': get(itm, 'summary', '')
              \ , 'isHoliday': 1
              \ , 'isMoon': 0
              \ , 'isDayNum': 0
              \ , 'isWeekNum': 0
              \ , 'starttime': ''
              \ , 'endtime': ''
              \ , 'ymdnum': (((ymd[0] * 100 + ymd[1]) * 100) + ymd[2])
              \ , 'hms': [ 0, 0, 0 ]
              \ , 'ymd': ymd
              \ , 'endhms': [ 0, 0, 0 ]
              \ , 'endymd': endymd }))
      endfor
    endwhile
  endfor
  return events
endfunction

" The optional argument is:
"   The first argument: Specify the calendar id. If this argument is given,
"                       the only one calendar is downloaded.
"   The second argument: Initial download. See calendar#google#calendar#initialDownload.
function! calendar#google#calendar#downloadEvents(year, month, ...) abort
  let calendarList = calendar#google#calendar#getCalendarList()
  let key = join([a:year, a:month], '/')
  if a:0 < 1
    let s:initial_download[key] = 2
  endif
  let month = a:month + 1
  let year = a:year
  if month > 12
    let [year, month] = [year + 1, month - 12]
  endif
  let [timemin, timemax] = [printf('%04d-%02d-01T00:00:00Z', a:year, a:month), printf('%04d-%02d-01T00:00:00Z', year, month)]
  if has_key(g:calendar_google_event_downloading, timemin)
    let g:calendar_google_event_downloading[timemin] = 1
  endif
  if has_key(calendarList, 'items') && type(calendarList.items) == type([]) && len(calendarList.items)
    let [y, m] = [printf('%04d', a:year), printf('%02d', a:month)]
    let j = 0
    while j < len(calendarList.items)
      let item = calendarList.items[j]
      if !get(item, 'selected') || a:0 && item.id !=# a:1
        let j += 1
        continue
      endif
      unlet! cnt
      let cnt = s:event_cache.new(item.id).new(y).new(m).get('information')
      if type(cnt) != type({}) || !has_key(cnt, 'summary') || a:0
        let opt = { 'timeMin': timemin, 'timeMax': timemax, 'singleEvents': 'true' }
        call calendar#google#client#get_async(s:newid(['download', 0, 0, 0, timemin, timemax, y, m, item.id]),
              \ 'calendar#google#calendar#response',
              \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(item.id) . '/events'), opt)
        break
      endif
      let j += 1
    endwhile
    if a:0 > 1
      call calendar#async#new(printf('calendar#google#calendar#initialDownload(%d, %d, %d)', a:year, a:month, a:2 + 1))
    endif
  endif
endfunction

function! calendar#google#calendar#response(id, response) abort
  let calendarList = calendar#google#calendar#getCalendarList()
  let [_download, err, j, i, timemin, timemax, year, month, id; rest] = s:getdata(a:id)
  let opt = { 'timeMin': timemin, 'timeMax': timemax, 'singleEvents': 'true' }
  if a:response.status =~# '^2'
    let cnt = calendar#webapi#decode(a:response.content)
    let content = type(cnt) == type({}) ? cnt : {}
    if has_key(content, 'items')
      call s:event_cache.new(id).new(year).new(month).save(i, content)
      if i == 0
        call remove(content, 'items')
        call s:event_cache.new(id).new(year).new(month).save('information', content)
      endif
      if has_key(content, 'nextPageToken')
        let opt = extend(opt, { 'pageToken': content.nextPageToken })
        call calendar#google#client#get_async(s:newid(['download', err, j, i + 1, timemin, timemax, year, month, id]),
              \ 'calendar#google#calendar#response',
              \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(id) . '/events'), opt)
      else
        let k = i + 1
        while filereadable(s:event_cache.new(id).new(year).new(month).path(k))
          silent! call s:event_cache.new(id).new(year).new(month).delete(k)
          let k += 1
        endwhile
        let g:calendar_google_event_download = 2
        let j += 1
        while j < len(calendarList.items)
          let item = calendarList.items[j]
          if !get(item, 'selected')
            let j += 1
            continue
          endif
          unlet! cnt
          let cnt = s:event_cache.new(item.id).new(year).new(month).get('information')
          if type(cnt) != type({}) || !has_key(cnt, 'summary')
            call calendar#google#client#get_async(s:newid(['download', 0, j, 0, timemin, timemax, year, month, item.id]),
                  \ 'calendar#google#calendar#response',
                  \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(item.id) . '/events'), opt)
            break
          endif
          let j += 1
        endwhile
        if j == len(calendarList.items)
          let g:calendar_google_event_download = 3
          silent! let b:calendar.event._updated = 5
          silent! call b:calendar.update()
        endif
      endif
    endif
  elseif a:response.status == 401 || a:response.status == 404
    if i == 0 && err == 0
      call calendar#google#client#refresh_token()
      call calendar#google#client#get_async(s:newid(['download', err + 1, j, i, timemin, timemax, year, month, id]),
            \ 'calendar#google#calendar#response',
            \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(id) . '/events'), opt)
    else
      call calendar#google#client#get_async_use_api_key(s:newid(['download', err + 1, j, 0, timemin, timemax, year, month, id]),
            \ 'calendar#google#calendar#response',
            \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(id) . '/events'), opt)
    endif
  endif
endfunction

function! calendar#google#calendar#update(calendarId, eventId, title, year, month, ...) abort
  let opt = a:0 ? a:1 : {}
  if has_key(opt, 'start')
    call s:set_timezone(a:calendarId, opt.start)
  endif
  if has_key(opt, 'end')
    call s:set_timezone(a:calendarId, opt.end)
  endif
  let location = matchstr(a:title, '\%( at \)\@<=.\+$')
  let opt = extend(opt, len(location) ? { 'location': location } : {})
  call calendar#google#client#patch_async(s:newid(['update', 0, a:year, a:month, a:calendarId, a:eventId, a:title, opt]),
        \ 'calendar#google#calendar#update_response',
        \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(a:calendarId) . '/events/' . a:eventId),
        \ { 'calendarId': a:calendarId, 'eventId': a:eventId },
        \ extend({ 'id': a:eventId, 'summary': a:title }, opt))
endfunction

function! calendar#google#calendar#update_response(id, response) abort
  let [_update, err, year, month, calendarId, eventId, title, opt; rest] = s:getdata(a:id)
  if a:response.status =~# '^2'
    call calendar#google#calendar#downloadEvents(year, month, calendarId)
  elseif a:response.status == 401
    if err == 0
      call calendar#google#client#refresh_token()
      call calendar#google#client#patch_async(s:newid(['update', 1, year, month, calendarId, eventId, title, opt]),
            \ 'calendar#google#calendar#update_response',
            \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(calendarId) . '/events/' . eventId),
            \ { 'calendarId': calendarId, 'eventId': eventId },
            \ extend({ 'id': eventId, 'summary': title }, opt))
    else
      call calendar#webapi#echo_error(a:response)
    endif
  else
    call calendar#webapi#echo_error(a:response)
  endif
endfunction

function! calendar#google#calendar#insert(calendarId, title, start, end, year, month, ...) abort
  let start = a:start =~# 'T\d' && len(a:start) > 10 ? { 'dateTime': a:start } : { 'date': a:start }
  let end = a:end =~# 'T\d' && len(a:end) > 10 ? { 'dateTime': a:end } : { 'date': a:end }
  let location = matchstr(a:title, '\%( at \)\@<=.\+$')
  let opt = len(location) ? { 'location': location } : {}
  let recurrence = a:0 ? a:1 : {}
  if has_key(recurrence, 'week') || has_key(recurrence, 'day')
    call extend(opt, { 'recurrence': [ 'RRULE:' . (
          \ has_key(recurrence, 'week') ? ('FREQ=WEEKLY;COUNT=' . recurrence.week) :
          \ has_key(recurrence, 'day') ? ('FREQ=DAILY;COUNT=' . recurrence.day) :
          \ '') ] })
  endif
  call s:set_timezone(a:calendarId, start)
  call s:set_timezone(a:calendarId, end)
  call calendar#google#client#post_async(s:newid(['insert', 0, a:year, a:month, a:calendarId, start, end, a:title, opt]),
        \ 'calendar#google#calendar#insert_response',
        \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(a:calendarId) . '/events'),
        \ { 'calendarId': a:calendarId },
        \ extend({ 'summary': a:title, 'start': start, 'end': end, 'transparency': 'transparent' }, opt))
endfunction

function! calendar#google#calendar#insert_response(id, response) abort
  let [_insert, err, year, month, calendarId, start, end, title, opt; rest] = s:getdata(a:id)
  if a:response.status =~# '^2'
    call calendar#google#calendar#downloadEvents(year, month, calendarId)
  elseif a:response.status == 401
    if err == 0
      call calendar#google#client#refresh_token()
      call calendar#google#client#post_async(s:newid(['insert', 1, year, month, calendarId, start, end, title, opt]),
            \ 'calendar#google#calendar#insert_response',
            \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(calendarId) . '/events'),
            \ { 'calendarId': calendarId },
            \ extend({ 'summary': title, 'start': start, 'end': end, 'transparency': 'transparent'  }, opt))
    endif
  else
    call calendar#webapi#echo_error(a:response)
  endif
endfunction

function! calendar#google#calendar#move(calendarId, eventId, destination, year, month) abort
  call calendar#google#client#post_async(s:newid(['move', 0, a:year, a:month, a:calendarId, a:eventId, a:destination]),
        \ 'calendar#google#calendar#move_response',
        \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(a:calendarId) . '/events/' . a:eventId . '/move'),
        \ { 'destination': a:destination }, {})
endfunction

function! calendar#google#calendar#move_response(id, response) abort
  let [_move, err, year, month, calendarId, eventId, destination; rest] = s:getdata(a:id)
  if a:response.status =~# '^2'
    call calendar#google#calendar#downloadEvents(year, month, calendarId)
    call calendar#google#calendar#downloadEvents(year, month, destination)
  elseif a:response.status == 401
    if err == 0
      call calendar#google#client#refresh_token()
      call calendar#google#client#patch_async(s:newid(['move', 1, year, month, calendarId, eventId, destination]),
            \ 'calendar#google#calendar#move_response',
            \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(calendarId) . '/events/' . eventId . '/move'),
            \ { 'destination': destination }, {})
    else
      call calendar#webapi#echo_error(a:response)
    endif
  else
    call calendar#webapi#echo_error(a:response)
  endif
endfunction

function! calendar#google#calendar#delete(calendarId, eventId, year, month) abort
  call calendar#google#client#delete_async(s:newid(['delete', 0, a:year, a:month, a:calendarId, a:eventId]),
        \ 'calendar#google#calendar#delete_response',
        \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(a:calendarId) . '/events/' . a:eventId),
        \ { 'calendarId': a:calendarId, 'eventId': a:eventId }, {})
endfunction

function! calendar#google#calendar#delete_response(id, response) abort
  let [_delete, err, year, month, calendarId, eventId; rest] = s:getdata(a:id)
  if a:response.status =~# '^2' || a:response.status ==# '410'
    call calendar#google#calendar#downloadEvents(year, month, calendarId)
  elseif a:response.status == 401
    if err == 0
      call calendar#google#client#refresh_token()
      call calendar#google#client#delete_async(s:newid(['delete', 1, year, month, calendarId, eventId]),
            \ 'calendar#google#calendar#delete_response',
            \ calendar#google#calendar#get_url('calendars/' . s:event_cache.escape(calendarId) . '/events/' . eventId),
            \ { 'calendarId': calendarId, 'eventId': eventId })
    else
      call calendar#webapi#echo_error(a:response)
    endif
  else
    call calendar#webapi#echo_error(a:response)
  endif
endfunction

function! s:set_timezone(calendarId, obj) abort
  let timezone = calendar#setting#get('time_zone')
  if has_key(a:obj, 'dateTime')
    let a:obj.dateTime .= timezone
  else
    let a:obj.timeZone = timezone
  endif
  if has_key(a:obj, 'dateTime')
    let a:obj.date = function('calendar#webapi#null')
  elseif has_key(a:obj, 'date')
    let a:obj.dateTime = function('calendar#webapi#null')
  endif
endfunction

let s:id_data = {}
function! s:newid(data) abort
  let id = join([ 'google', 'calendar', a:data[0] ], '_') . '_' . calendar#util#id()
  let s:id_data[id] = a:data
  return id
endfunction

function! s:getdata(id) abort
  return s:id_data[a:id]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
