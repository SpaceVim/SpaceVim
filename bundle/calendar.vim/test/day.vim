let s:suite = themis#suite('day')
let s:assert = themis#helper('assert')

function! s:suite.gregorian()
  let tests = [
        \ [[2000, 1, 1], 51544, 6],
        \ [[2020, 12, 31], 59214, 4],
        \ [[2023, 1, 1], 59945, 0],
        \ [[1858, 11, 17], 0, 3],
        \ [[1600, 1, 1], -94553, 6],
        \ [[1582, 10, 15], -100840, 5],
        \ [[1580, 1, 1], -101858, 2],
        \ ]
  for test in tests
    let [ymd, mjd, week] = test
    let day = calendar#day#gregorian#new(ymd[0], ymd[1], ymd[2])
    call s:assert.equals(day.is_valid(), 1)
    call s:assert.equals(day.get_ymd(), ymd)
    call s:assert.equals(day.get_year(), ymd[0])
    call s:assert.equals(day.get_month(), ymd[1])
    call s:assert.equals(day.get_day(), ymd[2])
    call s:assert.equals(day.mjd, mjd)
    call s:assert.equals(day.week(), week)
    call s:assert.equals(day.year().get_year(), ymd[0])
    call s:assert.equals(day.month().get_year(), ymd[0])
    call s:assert.equals(day.month().get_month(), ymd[1])
    call s:assert.equals(day.is_gregorian(), 1)
  endfor
endfunction

function! s:suite.julian()
  let tests = [
        \ [[2000, 1, 1], 51557, 5],
        \ [[2020, 12, 31], 59227, 3],
        \ [[2023, 1, 1], 59958, 6],
        \ [[1858, 11, 17], 12, 1],
        \ [[1600, 1, 1], -94543, 2],
        \ [[1582, 10, 4], -100841, 4],
        \ [[1580, 1, 1], -101848, 5],
        \ ]
  for test in tests
    let [ymd, mjd, week] = test
    let day = calendar#day#julian#new(ymd[0], ymd[1], ymd[2])
    call s:assert.equals(day.is_valid(), 1)
    call s:assert.equals(day.get_ymd(), ymd)
    call s:assert.equals(day.get_year(), ymd[0])
    call s:assert.equals(day.get_month(), ymd[1])
    call s:assert.equals(day.get_day(), ymd[2])
    call s:assert.equals(day.mjd, mjd)
    call s:assert.equals(day.week(), week)
    call s:assert.equals(day.year().get_year(), ymd[0])
    call s:assert.equals(day.month().get_year(), ymd[0])
    call s:assert.equals(day.month().get_month(), ymd[1])
    call s:assert.equals(day.is_gregorian(), 0)
  endfor
endfunction

function! s:suite.default()
  let tests = [
        \ [[2000, 1, 1], 51544, 6, 1],
        \ [[2020, 12, 31], 59214, 4, 1],
        \ [[2023, 1, 1], 59945, 0, 1],
        \ [[1858, 11, 17], 0, 3, 1],
        \ [[1600, 1, 1], -94553, 6, 1],
        \ [[1582, 10, 15], -100840, 5, 1],
        \ [[1582, 10, 4], -100841, 4, 0],
        \ [[1580, 1, 1], -101848, 5, 0],
        \ ]
  for test in tests
    let [ymd, mjd, week, is_gregorian] = test
    let day = calendar#day#default#new(ymd[0], ymd[1], ymd[2])
    call s:assert.equals(day.is_valid(), 1)
    call s:assert.equals(day.get_ymd(), ymd)
    call s:assert.equals(day.get_year(), ymd[0])
    call s:assert.equals(day.get_month(), ymd[1])
    call s:assert.equals(day.get_day(), ymd[2])
    call s:assert.equals(day.mjd, mjd)
    call s:assert.equals(day.week(), week)
    call s:assert.equals(day.year().get_year(), ymd[0])
    call s:assert.equals(day.month().get_year(), ymd[0])
    call s:assert.equals(day.month().get_month(), ymd[1])
    call s:assert.equals(day.is_gregorian(), is_gregorian)
  endfor
endfunction

function! s:suite.british()
  let tests = [
        \ [[2000, 1, 1], 51544, 6, 1],
        \ [[2020, 12, 31], 59214, 4, 1],
        \ [[2023, 1, 1], 59945, 0, 1],
        \ [[1858, 11, 17], 0, 3, 1],
        \ [[1752, 9, 14], -38779, 4, 1],
        \ [[1752, 9, 2], -38780, 3, 0],
        \ [[1600, 1, 1], -94543, 2, 0],
        \ [[1582, 10, 15], -100830, 1, 0],
        \ [[1582, 10, 4], -100841, 4, 0],
        \ [[1580, 1, 1], -101848, 5, 0],
        \ ]
  for test in tests
    let [ymd, mjd, week, is_gregorian] = test
    let day = calendar#day#british#new(ymd[0], ymd[1], ymd[2])
    call s:assert.equals(day.is_valid(), 1)
    call s:assert.equals(day.get_ymd(), ymd)
    call s:assert.equals(day.get_year(), ymd[0])
    call s:assert.equals(day.get_month(), ymd[1])
    call s:assert.equals(day.get_day(), ymd[2])
    call s:assert.equals(day.mjd, mjd)
    call s:assert.equals(day.week(), week)
    call s:assert.equals(day.year().get_year(), ymd[0])
    call s:assert.equals(day.month().get_year(), ymd[0])
    call s:assert.equals(day.month().get_month(), ymd[1])
    call s:assert.equals(day.is_gregorian(), is_gregorian)
  endfor
endfunction

function! s:suite.add_sub()
  let tests = [
        \ [[2000, 1, 1], 1000, [2002, 9, 27]],
        \ [[2020, 12, 31], -10000, [1993, 8, 15]],
        \ [[1600, 1, 1], 1000000, [4337, 11, 28]],
        \ [[1582, 10, 15], -1, [1582, 10, 4]],
        \ [[1582, 10, 4], 1, [1582, 10, 15]],
        \ [[1, 1, 1], 1000000, [2738, 11, 27]],
        \ ]
  for test in tests
    let [ymd, diff, new_ymd] = test
    let day = calendar#day#new(ymd[0], ymd[1], ymd[2])
    call s:assert.equals(day.add(diff).get_ymd(), new_ymd)
    call s:assert.equals(day.sub(calendar#day#new(new_ymd[0], new_ymd[1], new_ymd[2])), -diff)
    call s:assert.equals(calendar#day#new(new_ymd[0], new_ymd[1], new_ymd[2]).sub(day), diff)
  endfor
endfunction
