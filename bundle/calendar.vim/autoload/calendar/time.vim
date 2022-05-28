" =============================================================================
" Filename: autoload/calendar/time.vim
" Author: itchyny
" License: MIT License
" Last Change: 2017/05/08 07:45:01.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Time object
"   h: hour
"   m: minute
"   s: second
function! calendar#time#new(h, m, s) abort
  return extend(copy(s:self), { 'h': a:h, 'm': a:m, 's': a:s })
endfunction

if exists('*strftime')
  function! calendar#time#now() abort
    return calendar#time#new(strftime('%H') * 1, strftime('%M') * 1, strftime('%S') * 1)
  endfunction
else
  function! calendar#time#now() abort
    return calendar#time#new(system('date "+%H"') * 1, system('date "+%M"') * 1, system('date "+%S"') * 1)
  endfunction
endif

function! calendar#time#hour12(h) abort
  return a:h == 0 ? 12 : a:h < 13 ? a:h : a:h - 12
endfunction

let s:time_zone_cache = {}
function! calendar#time#time_zone() abort
  let time_zone = calendar#setting#get('time_zone')
  if has_key(s:time_zone_cache, time_zone)
    return s:time_zone_cache[time_zone]
  endif
  if time_zone ==# ''
    return 0
  endif
  let str = time_zone
  let sign_str = str[0] ==# '-' ? '-' : str[0] ==# '+' ? '+' : ''
  let str = str[len(sign_str):]
  let d = matchstr(str, '^\d\+')
  let str = str[len(d):]
  let [ h, m, s ] = [ 0, 0, 0 ]
  let onlyhour = 0
  if len(d) == 1 ||  len(d) == 2
    let h = d + 0
    let onlyhour = 1
  elseif len(d) == 3
    let h = d[0] + 0
    let m = d[1:] + 0
  elseif len(d) == 4
    let h = d[:1] + 0
    let m = d[2:] + 0
  elseif len(d) >= 5
    let h = d[:1] + 0
    let m = d[2:] + 0
    let s = d[4:] + 0
  endif
  let str = substitute(str, '^[^[:digit:]]\+', '', 'g')
  let d = matchstr(str, '^\d\+')
  let str = str[len(d):]
  if len(d) == 1 || len(d) == 2
    if onlyhour
      let m = d + 0
    else
      let s = d + 0
    endif
  elseif len(d) == 3
    if onlyhour
      let m = d[0] + 0
      let s = d[1:] + 0
    else
      let s = d + 0
    endif
  elseif len(d) == 4
    if onlyhour
      let m = d[:1] + 0
      let s = d[2:] + 0
    else
      let s = d + 0
    endif
  endif
  let str = substitute(str, '^[^[:digit:]]\+', '', 'g')
  let d = matchstr(str, '^\d\+')
  if len(d)
    let s = d + 0
  endif
  let s:time_zone_cache[time_zone] = (sign_str ==# '-' ? -1 : 1) * (((h * 60) + m) * 60 + s)
  return s:time_zone_cache[time_zone]
endfunction

let s:time_cache = {}
function! calendar#time#parse(str) abort
  if a:str ==# ''
    return 0
  endif
  if has_key(s:time_cache, a:str)
    return s:time_cache[a:str]
  endif
  let [ h, m, s ] = [ 0, 0, 0 ]
  let timestr = matchstr(a:str, '^\d\+:\d\+\%(:\d\+\)\?')
  let str = a:str[len(timestr):]
  let hms = map(split(timestr, ':'), 'v:val + 0')
  if len(hms) == 3
    let [ h, m, s ] = hms
  elseif len(hms) == 2
    let [ h, m ] = hms
  endif
  let time = ((h * 60) + m) * 60 + s
  if str ==? 'Z'
    let s:time_cache[a:str] = time
    return s:time_cache[a:str]
  endif
  if str ==# ''
    let s:time_cache[a:str] = time - calendar#time#time_zone()
    return s:time_cache[a:str]
  endif
  if has_key(s:time_cache, str)
    let [ dh, dm, ds ] = s:time_cache[str]
  else
    let [ dh, dm, ds ] = [ 0, 0, 0 ]
    let timestr = matchstr(str, '-\?\d\+:\d\+\%(:\d\+\)\?')
    let hms = map(split(timestr, ':'), 'v:val + 0')
    if len(hms) == 3
      let [ dh, dm, ds ] = hms
    elseif len(hms) == 2
      let [ dh, dm ] = hms
    endif
    let s:time_cache[str] = [ dh, dm, ds ]
  endif
  let s:time_cache[a:str] = time - (((dh * 60) + dm) * 60 + ds)
  return s:time_cache[a:str]
endfunction

let s:datetime_cache = {}
function! calendar#time#datetime(str) abort
  let time_zone = calendar#time#time_zone()
  let key = a:str . ',' . time_zone
  if has_key(s:datetime_cache, key)
    return s:datetime_cache[key]
  endif
  let time = a:str =~# 'T' ? calendar#time#parse(matchstr(a:str, 'T\zs.*')) + time_zone : 0
  let ymd = map(split(matchstr(a:str, '\d\+-\d\+-\d\+'), '-'), 'v:val + 0')
  if len(ymd) != 3
    return []
  endif
  let [ y, m, d ] = ymd
  let min = s:div(time, 60)
  let sec = time - 60 * min
  let hour = s:div(min, 60)
  let min -= 60 * hour
  let day = s:div(hour, 24)
  let hour -= 24 * day
  if day != 0
    let [ y, m, d ] = calendar#day#new(y, m, d).add(day).get_ymd()
  endif
  let s:datetime_cache[key] = [ y, m, d, hour, min, sec ]
  return s:datetime_cache[key]
endfunction

let s:self = {}

function! s:div(x, y) abort
  return a:x/a:y-((a:x<0)&&(a:x%a:y))
endfunction

function! s:self.new(h, m, s) dict abort
  return calendar#time#new(a:h, a:m, a:s)
endfunction

function! s:self.get_hms() dict abort
  return [self.h, self.m, self.s]
endfunction

function! s:self.add_hour(diff) dict abort
  let [h, m, s] = self.get_hms()
  let d = 0
  let h += a:diff
  let d += s:div(h, 24)
  let h -= 24 * s:div(h, 24)
  return [d, self.new(h, m, s)]
endfunction

function! s:self.add_minute(diff) dict abort
  let [h, m, s] = self.get_hms()
  let d = 0
  let m += a:diff
  let h += s:div(m, 60)
  let m -= 60 * s:div(m, 60)
  let d += s:div(h, 24)
  let h -= 24 * s:div(h, 24)
  return [d, self.new(h, m, s)]
endfunction

function! s:self.add_second(diff) dict abort
  let [h, m, s] = self.get_hms()
  let d = 0
  let s += a:diff
  let m += s:div(s, 60)
  let s -= 60 * s:div(s, 60)
  let h += s:div(m, 60)
  let m -= 60 * s:div(m, 60)
  let d += s:div(h, 24)
  let h -= 24 * s:div(h, 24)
  return [d, self.new(h, m, s)]
endfunction

function! s:self.second() dict abort
  return self.get_hms()[2]
endfunction

function! s:self.minute() dict abort
  return self.get_hms()[1]
endfunction

function! s:self.hour() dict abort
  return self.get_hms()[0]
endfunction

function! s:self.seconds() dict abort
  return (self.hour() * 60 + self.minute()) * 60 + self.second()
endfunction

function! s:self.add(time) dict abort
  return self.add_second(a:time.seconds())
endfunction

function! s:self.subtract(time) dict abort
  return self.add_second(-a:time.seconds())
endfunction

function! s:self.sub(time) dict abort
  return self.seconds() - a:time.seconds()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
