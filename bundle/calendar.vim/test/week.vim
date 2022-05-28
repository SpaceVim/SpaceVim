let s:suite = themis#suite('week')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
  language en_US.UTF-8
  unlet! g:calendar_first_day
endfunction

function! s:suite.first_day_index()
  call s:assert.equals(calendar#week#first_day_index(), 0)
  let g:calendar_first_day = 'sunday'
  call s:assert.equals(calendar#week#first_day_index(), 0)
  let g:calendar_first_day = 'Monday'
  call s:assert.equals(calendar#week#first_day_index(), 1)
  let g:calendar_first_day = 'Tuesday'
  call s:assert.equals(calendar#week#first_day_index(), 2)
  let g:calendar_first_day = 'WEDNESDAY'
  call s:assert.equals(calendar#week#first_day_index(), 3)
  let g:calendar_first_day = 'thursday'
  call s:assert.equals(calendar#week#first_day_index(), 4)
  let g:calendar_first_day = 'friday'
  call s:assert.equals(calendar#week#first_day_index(), 5)
  let g:calendar_first_day = 'saturday'
  call s:assert.equals(calendar#week#first_day_index(), 6)
endfunction

function! s:suite.last_day_index()
  call s:assert.equals(calendar#week#last_day_index(), 6)
  let g:calendar_first_day = 'sunday'
  call s:assert.equals(calendar#week#last_day_index(), 6)
  let g:calendar_first_day = 'Monday'
  call s:assert.equals(calendar#week#last_day_index(), 0)
  let g:calendar_first_day = 'Tuesday'
  call s:assert.equals(calendar#week#last_day_index(), 1)
  let g:calendar_first_day = 'WEDNESDAY'
  call s:assert.equals(calendar#week#last_day_index(), 2)
  let g:calendar_first_day = 'thursday'
  call s:assert.equals(calendar#week#last_day_index(), 3)
  let g:calendar_first_day = 'friday'
  call s:assert.equals(calendar#week#last_day_index(), 4)
  let g:calendar_first_day = 'saturday'
  call s:assert.equals(calendar#week#last_day_index(), 5)
endfunction

function! s:suite.is_first_day()
  call s:assert.equals(calendar#week#first_day_index(), 0)
  call s:assert.equals(calendar#week#is_first_day(calendar#day#new(2000, 1, 1)), 0)
  call s:assert.equals(calendar#week#is_first_day(calendar#day#new(2001, 1, 1)), 0)
  call s:assert.equals(calendar#week#is_first_day(calendar#day#new(2004, 1, 1)), 0)
  call s:assert.equals(calendar#week#is_first_day(calendar#day#new(2005, 1, 1)), 0)
  call s:assert.equals(calendar#week#is_first_day(calendar#day#new(2006, 1, 1)), 1)
  call s:assert.equals(calendar#week#is_first_day(calendar#day#new(2007, 1, 1)), 0)
endfunction

function! s:suite.is_last_day()
  call s:assert.equals(calendar#week#is_last_day(calendar#day#new(2000, 1, 1)), 1)
  call s:assert.equals(calendar#week#is_last_day(calendar#day#new(2001, 1, 1)), 0)
  call s:assert.equals(calendar#week#is_last_day(calendar#day#new(2004, 1, 1)), 0)
  call s:assert.equals(calendar#week#is_last_day(calendar#day#new(2005, 1, 1)), 1)
  call s:assert.equals(calendar#week#is_last_day(calendar#day#new(2006, 1, 1)), 0)
  call s:assert.equals(calendar#week#is_last_day(calendar#day#new(2007, 1, 1)), 0)
endfunction

function! s:suite.week_index()
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2000, 1, 1)), 6)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2001, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2004, 1, 1)), 4)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2005, 1, 1)), 6)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2006, 1, 1)), 0)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2007, 1, 1)), 1)
  let g:calendar_first_day = 'monday'
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2000, 1, 1)), 5)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2001, 1, 1)), 0)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2004, 1, 1)), 3)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2005, 1, 1)), 5)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2006, 1, 1)), 6)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2007, 1, 1)), 0)
  let g:calendar_first_day = 'saturday'
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2000, 1, 1)), 0)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2001, 1, 1)), 2)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2004, 1, 1)), 5)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2005, 1, 1)), 0)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2006, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_index(calendar#day#new(2007, 1, 1)), 2)
endfunction

function! s:suite.week_number()
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2000, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2001, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2004, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2005, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2006, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2007, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2010, 12, 31)), 53)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2020, 5, 9)), 19)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2020, 5, 10)), 20)
  let g:calendar_first_day = 'monday'
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2000, 1, 1)), 52)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2001, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2004, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2005, 1, 1)), 53)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2006, 1, 1)), 52)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2007, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2009, 1, 1)), 1)
  call s:assert.equals(calendar#week#week_number(calendar#day#new(2010, 1, 1)), 53)
endfunction
