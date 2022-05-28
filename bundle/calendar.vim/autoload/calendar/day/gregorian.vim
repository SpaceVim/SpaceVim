" =============================================================================
" Filename: autoload/calendar/day/gregorian.vim
" Author: itchyny
" License: MIT License
" Last Change: 2017/05/07 22:04:31.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! s:div(x, y) abort
  return a:x/a:y-((a:x<0)&&(a:x%a:y))
endfunction

function! calendar#day#gregorian#new(y, m, d) abort
  return s:constructor.new(a:y, a:m, a:d)
endfunction

function! calendar#day#gregorian#new_mjd(mjd) abort
  return s:constructor.new_mjd(a:mjd)
endfunction

function! calendar#day#gregorian#today() abort
  return s:constructor.new_mjd(calendar#day#today_mjd())
endfunction

let s:self = {}

function! s:self.new(y, m, d) dict abort
  let y = a:y - (a:m < 3)
  let mjd = s:div(y*1461,4)+s:div(y,400)-s:div(y,100)+((a:m+12*(a:m<3)-3)*153+2)/5+a:d-678882
  return extend(self.new_mjd(mjd), { '_ymd': [a:y, a:m, a:d] })
endfunction

function! s:self.new_mjd(mjd) dict abort
  return s:constructor.new_mjd(a:mjd)
endfunction

let s:_ = {}
let s:days = { '1': 31, '2': 28, '3': 31, '4': 30, '5': 31, '6': 30, '7': 31, '8': 31, '9': 30, '10': 31, '11': 30, '12': 31 }
function! s:self.get_ymd() dict abort
  if has_key(self, 'ymd') | return self.ymd | endif
  let _ = self.mjd
  if has_key(s:_, _) | return s:_[_] | endif
  if has_key(s:_, _ - 1) && s:_[_ - 1][2] < s:days[s:_[_ - 1][1]]
    let p = s:_[_ - 1]
    let s:_[_] = [p[0], p[1], p[2] + 1]
    return s:_[_]
  endif
  let a = _ + 2432045
  let b = s:div(4 * a + 3, 146097)
  let c = a - s:div(146097 * b, 4)
  let d = (4 * c + 3) / 1461
  let e = c - (1461 * d) / 4
  let m = (5 * e + 2) / 153
  let day = e - (153 * m + 2) / 5 + 1
  let month = m + 3 - 12 * (m / 10)
  let year = 100 * b + d - 4800 + m / 10
  let self.ymd = [year, month, day]
  let s:_[_] = self.ymd
  return self.ymd
endfunction

function! s:self.is_gregorian() dict abort
  return 1
endfunction

function! s:self.get_calendar() dict abort
  return 'gregorian'
endfunction

let s:constructor = calendar#constructor#day#new(s:self)

let &cpo = s:save_cpo
unlet s:save_cpo
