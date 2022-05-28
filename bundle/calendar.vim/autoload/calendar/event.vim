" =============================================================================
" Filename: autoload/calendar/event.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/10/17 01:37:16.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Event controller.
" This object handles both local and Google Calendar.
function! calendar#event#new() abort
  let self = deepcopy(s:self)
  if calendar#setting#get('google_calendar')
    let self.event_source_name = 'google'
  else
    let self.event_source_name = 'local'
  endif
  let self.event_source = calendar#event#{self.event_source_name}#new()
  return self
endfunction

let s:self = {}

let s:self.__events = {}
let s:self._holidays = {}
let s:self._updated = 0

function! s:self.updated() dict abort
  if self._updated > 0
    let self._updated -= 1
  endif
  return [self._updated]
endfunction

function! s:self.get_events_one_month(year, month, ...) dict abort
  let events = self.event_source.get_events_one_month(a:year, a:month, a:0 && a:1)
  if self.event_source_name !=# 'google'
    let holiday = self.get_holidays(a:year, a:month)
    for day in keys(holiday)
      if len(holiday[day].events)
        if !has_key(events, day)
          let events[day] = { 'events': [] }
        endif
        let events[day].hasHoliday = 1
        call extend(events[day].events, holiday[day].events)
        let events[day].holiday = holiday[day].events[-1].summary
      endif
    endfor
  endif
  return events
endfunction

function! s:self.clear_cache() dict abort
  let self.__events = {}
  let self._holidays = {}
  let self._updated = 10
  call self.event_source.clear_cache()
endfunction

function! s:self.get_events(year, month) dict abort
  let key = a:year . '-' . a:month
  if self._updated > 0
    let self._updated -= 1
  endif
  if has_key(self.__events, key) && (!calendar#setting#get('google_calendar') || get(g:, 'calendar_google_event_download', 1) <= 0) && !self._updated
    return self.__events[key]
  endif
  let events = self.get_events_one_month(a:year, a:month, 1)
  let [year, month] = calendar#day#new(a:year, a:month, 1).month().add(1).get_ym()
  call extend(events, self.get_events_one_month(year, month, 0))
  let [year, month] = calendar#day#new(a:year, a:month, 1).month().add(-1).get_ym()
  call extend(events, self.get_events_one_month(year, month, 0))
  let self.__events[key] = events
  return self.__events[key]
endfunction

function! s:self.get_holidays(year, month) dict abort
  let key = a:year . '-' . a:month
  if has_key(self._holidays, key) && (!calendar#setting#get('google_calendar') || get(g:, 'calendar_google_event_download', 1) <= 0)
    return self._holidays[key]
  endif
  let self._holidays[key] = calendar#google#calendar#getHolidays(a:year, a:month)
  return self._holidays[key]
endfunction

function! s:self.update(calendarId, eventId, title, year, month, ...) dict abort
  let self._updated = 10
  return self.event_source.update(a:calendarId, a:eventId, a:title, a:year, a:month, a:0 ? a:1 : {})
endfunction

function! s:self.insert(calendarId, title, start, end, year, month, ...) dict abort
  let self._updated = 10
  return self.event_source.insert(a:calendarId, a:title, a:start, a:end, a:year, a:month, a:0 ? a:1 : {})
endfunction

function! s:self.move(calendarId, eventId, destination, year, month) dict abort
  let self._updated = 10
  return self.event_source.move(a:calendarId, a:eventId, a:destination, a:year, a:month)
endfunction

function! s:self.delete(calendarId, eventId, year, month) dict abort
  let self._updated = 10
  return self.event_source.delete(a:calendarId, a:eventId, a:year, a:month)
endfunction

function! s:self.createCalendar() dict abort
  let self._updated = 10
  return self.event_source.createCalendar()
endfunction

function! s:self.calendarList() dict abort
  return self.event_source.calendarList()
endfunction

function! s:self.calendarCandidates() dict abort
  let calendars = self.event_source.calendarList()
  let calendar_candidates = calendar#setting#get('calendar_candidates')
  if type(calendar_candidates) ==# type('') || type(calendar_candidates) ==# type([])
    let cs = []
    for pattern in type(calendar_candidates) ==# type('') ?
          \ split(calendar_candidates, ', *') : calendar_candidates
      for c in calendars
        if c.summary =~# pattern
          call add(cs, c)
        endif
      endfor
    endfor
    let calendars = cs
  endif
  return calendars
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
