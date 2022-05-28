" =============================================================================
" Filename: autoload/calendar/constructor/day.vim
" Author: itchyny
" License: MIT License
" Last Change: 2017/05/07 22:22:26.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#constructor#day#new(instance) abort
  let constructor = extend({ 'instance': a:instance }, s:constructor)
  let constructor.month_constructor = calendar#constructor#month#new(constructor)
  let constructor.year_constructor = calendar#constructor#year#new(constructor)
  return constructor
endfunction

let s:constructor = {}

function! s:constructor.new(y, m, d) dict abort
  return extend(self.instance.new(a:y, a:m, a:d), { 'constructor': self })
endfunction

" Modified Julian Day
" Reference: http://en.wikipedia.org/wiki/Julian_day
function! s:constructor.new_mjd(mjd) dict abort
  return extend(extend(copy(s:instance), self.instance), { 'mjd': a:mjd, 'constructor': self })
endfunction

let s:instance = {}

function! s:div(x, y) abort
  return a:x/a:y-((a:x<0)&&(a:x%a:y))
endfunction

function! s:instance.add(diff) dict abort
  return self.new_mjd(self.mjd + a:diff)
endfunction

function! s:instance.add_month(diff) dict abort
  let [y, m, d] = self.get_ymd()
  let m += a:diff - 1
  let y += s:div(m, 12)
  let m -= 12 * s:div(m, 12)
  let m += 1
  let new_day = self.new(y, m, d)
  let new_month = self.constructor.month_constructor.new(y, m)
  if !new_day.is_valid()
    if new_day.sub(new_month.head_day()) > 0
      while !(new_day.eq_month(new_month.head_day()))
        let new_day = new_day.add(-1)
      endwhile
    else
      while !(new_day.eq_month(new_month.head_day()))
        let new_day = new_day.add(1)
      endwhile
    endif
  endif
  return new_day
endfunction

function! s:instance.add_year(diff) dict abort
  return self.add_month(a:diff * 12)
endfunction

function! s:instance.sub(day) dict abort
  return self.mjd - a:day.mjd
endfunction

function! s:instance.week() dict abort
  if has_key(self, '_week') | return self._week | endif
  let m = self.mjd + 3
  let self._week = m % 7 + 7 * ((m < 0) && (m % 7))
  return self._week
endfunction

function! s:instance.today() dict abort
  return self.new_mjd(calendar#day#today_mjd())
endfunction

function! s:instance.eq(day) dict abort
  return self.mjd == a:day.mjd
endfunction

function! s:instance.eq_month(day) dict abort
  return self.month().eq(a:day.month())
endfunction

function! s:instance.eq_year(day) dict abort
  return self.year().eq(a:day.year())
endfunction

function! s:instance.eq_week(day) dict abort
  return self.week() == a:day.week()
endfunction

function! s:instance.is_sunday() dict abort
  return self.week() == 0
endfunction

function! s:instance.is_monday() dict abort
  return self.week() == 1
endfunction

function! s:instance.is_tuesday() dict abort
  return self.week() == 2
endfunction

function! s:instance.is_wednesday() dict abort
  return self.week() == 3
endfunction

function! s:instance.is_thursday() dict abort
  return self.week() == 4
endfunction

function! s:instance.is_friday() dict abort
  return self.week() == 5
endfunction

function! s:instance.is_saturday() dict abort
  return self.week() == 6
endfunction

function! s:instance.is_valid() dict abort
  return !has_key(self, '_ymd') || self._ymd == self.get_ymd()
endfunction

function! s:instance.get_year() dict abort
  return self.get_ymd()[0]
endfunction

function! s:instance.get_month() dict abort
  return self.get_ymd()[1]
endfunction

function! s:instance.get_day() dict abort
  return self.get_ymd()[2]
endfunction

function! s:instance.month() dict abort
  if has_key(self, '_month') | return self._month | endif
  let [y, m, d] = self.get_ymd()
  let self._month = self.constructor.month_constructor.new(y, m)
  return self._month
endfunction

function! s:instance.year() dict abort
  if has_key(self, '_year') | return self._year | endif
  let self._year = self.constructor.year_constructor.new(self.get_year())
  return self._year
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
