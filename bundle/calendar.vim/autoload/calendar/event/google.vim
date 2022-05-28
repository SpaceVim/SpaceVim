" =============================================================================
" Filename: autoload/calendar/event/google.vim
" Author: itchyny
" License: MIT License
" Last Change: 2017/05/23 22:01:14.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#event#google#new() abort
  return deepcopy(s:self)
endfunction

let s:self = {}
let s:self._key = {}
let s:self._events = {}

function! s:self.get_events_one_month(year, month, ...) dict abort
  let key = a:year . '-' . a:month
  if has_key(self._key, key) && has_key(self._events, key) && get(g:, 'calendar_google_event_download', 1) <= 0 && self._events[key] != {}
    if a:0 && a:1
      call calendar#google#calendar#getEventsInitial(a:year, a:month)
    endif
    return self._events[key]
  endif
  if has_key(self._key, key)
    unlet self._key[key]
  endif
  if has_key(g:, 'calendar_google_event_download')
    if get(g:, 'calendar_google_event_download') > 1
      let g:calendar_google_event_download -= 1
    endif
  endif
  let self._events[key] = calendar#google#calendar#getEvents(a:year, a:month, a:0 && a:1)
  let self._key[key] = 1
  return self._events[key]
endfunction

function! s:self.update(calendarId, eventId, title, year, month, ...) dict abort
  call calendar#google#calendar#update(a:calendarId, a:eventId, a:title, a:year, a:month, a:0 ? a:1 : {})
endfunction

function! s:self.insert(calendarId, title, start, end, year, month, ...) dict abort
  call calendar#google#calendar#insert(a:calendarId, a:title, a:start, a:end, a:year, a:month, a:0 ? a:1 : {})
endfunction

function! s:self.move(calendarId, eventId, destination, year, month) dict abort
  call calendar#google#calendar#move(a:calendarId, a:eventId, a:destination, a:year, a:month)
endfunction

function! s:self.delete(calendarId, eventId, year, month) dict abort
  call calendar#google#calendar#delete(a:calendarId, a:eventId, a:year, a:month)
endfunction

function! s:self.calendarList() dict abort
  return calendar#google#calendar#getMyCalendarList()
endfunction

function! s:self.createCalendar() dict abort
endfunction

function! s:self.clear_cache() dict abort
  call calendar#google#calendar#clearCache()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
