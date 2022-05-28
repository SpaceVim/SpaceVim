" =============================================================================
" Filename: autoload/calendar/constructor/year.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:28:04.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#constructor#year#new(day_constructor) abort
  return extend({ 'day_constructor': a:day_constructor, 'cache': {} }, s:constructor)
endfunction

let s:constructor = {}

function! s:constructor.new(y) dict abort
  let instance = copy(s:instance)
  let instance.day_constructor = self.day_constructor
  let instance._y = a:y
  let instance.constructor = self
  return instance
endfunction

let s:instance = {}

function! s:instance.new(y) dict abort
  return self.constructor.new(a:y)
endfunction

function! s:instance.add(diff) dict abort
  return self.new(self.get_y() + a:diff)
endfunction

function! s:instance.sub(year) dict abort
  return self.get_y() - a:year.get_y()
endfunction

function! s:instance.eq(year) dict abort
  return self.get_y() == a:year.get_y()
endfunction

function! s:instance.is_valid() dict abort
  return self.head_day().is_valid() && self.last_day().is_valid()
endfunction

function! s:instance.get_y() dict abort
  if has_key(self, 'y') | return self.y | endif
  let self.y = self.head_day().get_ymd()[0]
  return self.y
endfunction

function! s:instance.get_year() dict abort
  return self.get_y()
endfunction

function! s:instance.get_month() dict abort
  return self.head_day().get_month()
endfunction

function! s:instance.get_day() dict abort
  return self.head_day().get_day()
endfunction

function! s:instance.head_day() dict abort
  if has_key(self, '_head_day') | return self._head_day | endif
  let self._head_day = self.day_constructor.new(self._y, 1, 1)
  return self._head_day
endfunction

function! s:instance.last_day() dict abort
  if has_key(self, '_last_day') | return self._last_day | endif
  let self._last_day = self.day_constructor.new(self._y + 1, 1, 1).add(-1)
  return self._last_day
endfunction

function! s:instance.head_month() dict abort
  if has_key(self, '_head_month') | return self._head_month | endif
  let self._head_month = self.head_day().month()
  return self._head_month
endfunction

function! s:instance.last_month() dict abort
  if has_key(self, '_last_month') | return self._last_month | endif
  let self._last_month = self.last_day().month()
  return self._last_month
endfunction

function! s:instance.days() dict abort
  if has_key(self, '_days') | return self._days | endif
  let self._days = self.last_day().sub(self.head_day()) + 1
  return self._days
endfunction

function! s:instance.get_months() dict abort
  if has_key(self, '__months') | return self.__months | endif
  if has_key(self.constructor.cache, self.get_y()) | return self.constructor.cache[self.get_y()] | endif
  let months = []
  call add(months, self.head_month())
  while !self.last_month().eq(months[-1])
    call add(months, months[-1].add(1))
  endwhile
  let self.__months = months
  let self.constructor.cache[self.get_y()] = months
  return months
endfunction

function! s:instance.day() dict abort
  return self.head_day()
endfunction

function! s:instance.month() dict abort
  return self.head_month()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
