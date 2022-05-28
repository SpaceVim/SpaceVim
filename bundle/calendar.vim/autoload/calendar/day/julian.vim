" =============================================================================
" Filename: autoload/calendar/day/julian.vim
" Author: itchyny
" License: MIT License
" Last Change: 2017/05/07 22:12:02.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! s:div(x, y) abort
  return a:x/a:y-((a:x<0)&&(a:x%a:y))
endfunction

function! calendar#day#julian#new(y, m, d) abort
  return s:constructor.new(a:y, a:m, a:d)
endfunction

function! calendar#day#julian#new_mjd(mjd) abort
  return s:constructor.new_mjd(a:mjd)
endfunction

function! calendar#day#julian#today() abort
  return s:constructor.new_mjd(calendar#day#today_mjd())
endfunction

let s:self = {}

function! s:self.new(y, m, d) dict abort
  let y = a:y - (a:m < 3)
  let mjd = s:div(y*1461,4)+((a:m+12*(a:m<3)-3)*153+2)/5+a:d-678884
  return extend(self.new_mjd(mjd), { '_ymd': [a:y, a:m, a:d] })
endfunction

function! s:self.new_mjd(mjd) dict abort
  return s:constructor.new_mjd(a:mjd)
endfunction

let s:_ = {}
function! s:self.get_ymd() dict abort
  if has_key(self, 'ymd') | return self.ymd | endif
  if has_key(s:_, self.mjd) | return s:_[self.mjd] | endif
  let c = self.mjd + 678883
  let d = s:div(4 * c + 3, 1461)
  let e = c - s:div(1461 * d, 4)
  let m = (5 * e + 2) / 153
  let day = e - (153 * m + 2) / 5 + 1
  let month = m + 3 - 12 * (m / 10)
  let year = d + m / 10
  let self.ymd = [year, month, day]
  let s:_[self.mjd] = self.ymd
  return self.ymd
endfunction

function! s:self.is_gregorian() dict abort
  return 0
endfunction

function! s:self.get_calendar() dict abort
  return 'julian'
endfunction

let s:constructor = calendar#constructor#day#new(s:self)

let &cpo = s:save_cpo
unlet s:save_cpo
