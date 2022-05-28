" =============================================================================
" Filename: autoload/calendar/constructor/day_hybrid.vim
" Author: itchyny
" License: MIT License
" Last Change: 2017/05/07 22:07:20.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#constructor#day_hybrid#new(y, m, d) abort
  let constructor = extend({ 'switch_mjd': calendar#day#gregorian#new(a:y, a:m, a:d).mjd }, s:constructor)
  let constructor.switch_day = calendar#day#gregorian#new_mjd(constructor.switch_mjd)
  let constructor.month_constructor = calendar#constructor#month#new(constructor)
  let constructor.year_constructor = calendar#constructor#year#new(constructor)
  return constructor
endfunction

let s:constructor = {}

function! s:constructor.new(y, m, d) dict abort
  let mjd = calendar#day#gregorian#new(a:y, a:m, a:d).mjd
  if mjd < self.switch_mjd
    let mjd = calendar#day#julian#new(a:y, a:m, a:d).mjd
    if mjd > self.switch_mjd
      let mjd = deepcopy(self.switch_mjd)
    endif
  endif
  let instance = self.new_mjd(mjd)
  let instance._ymd = [a:y, a:m, a:d]
  return instance
endfunction

function! s:constructor.new_mjd(mjd) dict abort
  let instance = s:super_constructor.new_mjd(a:mjd)
  let instance.constructor = self
  let instance.switch_mjd = self.switch_mjd
  let instance.switch_day = self.switch_day
  return instance
endfunction

function! s:constructor.today() dict abort
  return self.new_mjd(calendar#day#today_mjd())
endfunction

let s:instance = {}

function! s:instance.new(y, m, d) dict abort
  return self.constructor.new(a:y, a:m, a:d)
endfunction

function! s:instance.new_mjd(mjd) dict abort
  return self.constructor.new_mjd(a:mjd)
endfunction

function! s:instance.get_ymd() dict abort
  if has_key(self, 'ymd') | return self.ymd | endif
  let self.ymd = calendar#day#{self.get_calendar()}#new_mjd(self.mjd).get_ymd()
  return self.ymd
endfunction

function! s:instance.is_gregorian() dict abort
  return self.mjd >= self.switch_mjd
endfunction

function! s:instance.get_calendar() dict abort
  return self.is_gregorian() ? 'gregorian' : 'julian'
endfunction

let s:super_constructor = calendar#constructor#day#new(s:instance)

let &cpo = s:save_cpo
unlet s:save_cpo
