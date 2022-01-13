" date and time library.

function! s:_init() abort
  let s:NUM_SECONDS = 60
  let s:NUM_MINUTES = 60
  let s:NUM_HOURS = 24
  let s:NUM_DAYS_OF_WEEK = 7
  let s:NUM_MONTHS = 12
  let s:SECONDS_OF_HOUR = s:NUM_SECONDS * s:NUM_MINUTES
  let s:SECONDS_OF_DAY = s:SECONDS_OF_HOUR * s:NUM_HOURS
  let s:ERA_TIME = s:_g2jd(1, 1, 1)
  let s:EPOC_TIME = s:_g2jd(1970, 1, 1)

  let s:MONTHS = map(range(1, 12),
  \   's:from_date(1970, v:val, 1, 0, 0, 0, 0).unix_time()')
  let s:WEEKS = map(range(4, 10),
  \   's:from_date(1970, 1, v:val, 0, 0, 0, 0).unix_time()')
  let s:AM_PM_TIMES = map([0, 12],
  \   's:from_date(1970, 1, 1, v:val, 0, 0, 0).unix_time()')

  " default values
  call extend(s:DateTime, {
  \   '_year': 0,
  \   '_month': 1,
  \   '_day': 1,
  \   '_hour': 0,
  \   '_minute': 0,
  \   '_second': 0,
  \   '_timezone': s:timezone(),
  \ })
  call extend(s:TimeDelta, {
  \   '_days': 0,
  \   '_seconds': 0,
  \ })
  let s:tz_default_offset = s:timezone().offset()
endfunction

" Creates a DateTime object with current time from system.
function! s:now(...) abort
  let now = s:from_unix_time(localtime())
  if a:0
    let now = now.to(s:timezone(a:1))
  endif
  return now
endfunction

" Creates a DateTime object from given unix time.
function! s:from_unix_time(unix_time, ...) abort
  let tz = call('s:timezone', a:000)
  return call('s:from_date',
  \   map(split(strftime('%Y %m %d %H %M %S', a:unix_time)),
  \       'str2nr(v:val, 10)')).to(tz)
endfunction

" Creates a DateTime object from given date and time.
" @param year = 1970
" @param month = 1
" @param day = 1
" @param hour = 0
" @param minute = 0
" @param second = 0
" @param timezone = ''
function! s:from_date(...) abort
  let o = copy(s:DateTime)
  let [o._year, o._month, o._day, o._hour, o._minute, o._second, tz] =
  \   a:000 + [1970, 1, 1, 0, 0, 0, ''][a:0 :]
  let o._timezone = s:timezone(tz)
  return o._normalize()
endfunction

" Creates a DateTime object from format.
function! dein#DateTime#from_format(string, format, ...) abort
  let o = copy(s:DateTime)
  let locale = a:0 ? a:1 : ''
  let remain = a:string
  let skip_pattern = ''
  for f in s:_split_format(a:format)
    if type(f) == v:t_string
      let pat = '^' . skip_pattern . '\V' . escape(f, '\')
      let matched_len = len(matchstr(remain, pat))
      if matched_len == 0
        throw join([
        \   'vital: DateTime: Parse error:',
        \   'input: ' . a:string,
        \   'format: ' . a:format,
        \ ], "\n")
      endif
      let remain = remain[matched_len :]
    else  " if type(f) == v:t_list
      let info = f[0]
      if info[0] ==# '#skip'
        let skip_pattern = info[1]
      else
        let remain = s:_read_format(o, f, remain, skip_pattern, locale)
        let skip_pattern = ''
      endif
    endif
    unlet f
  endfor
  return o._normalize()
endfunction
" @vimlint(EVL102, 1, l:locale)
function! s:_read_format(datetime, descriptor, remain, skip_pattern, locale) abort
  " "o", "key", "value" and "locale" are used by parse_conv
  let o = a:datetime
  let locale = a:locale " for parse_conv
  let [info, flag, width] = a:descriptor
  let key = '_' . info[0]
  if !has_key(o, key)
    let key = '_'
  endif
  let Captor = info[1]
  if type(Captor) == v:t_func
    let pattern = call(Captor, [a:locale], {})
    if type(pattern) == v:t_list
      let candidates = pattern
      unlet pattern
      let pattern = '\%(' . join(candidates, '\|') . '\)'
    endif
  elseif type(Captor) == v:t_list
    if width ==# ''
      let width = Captor[1]
    endif
    let pattern = '\d\{1,' . width . '}'
    if flag ==# '_'
      let pattern = '\s*' . pattern
    endif
  else  " if type(Captor) == v:t_string
    let pattern = Captor
  endif

  let value = matchstr(a:remain, '^' . a:skip_pattern . pattern)
  let matched_len = len(value)

  if exists('candidates')
    let value = index(candidates, value)
  elseif type(Captor) == v:t_list
    let value = str2nr(value, 10)
  endif

  if 4 <= len(info)
    let l:['value'] = eval(info[3])
  endif
  if key !=# '_'
    let o[key] = value
  endif
  return a:remain[matched_len :]
endfunction
" @vimlint(EVL102, 0, l:locale)

" Creates a DateTime object from Julian day.
function! s:from_julian_day(jd, ...) abort
  let tz = call('s:timezone', a:000)
  let second = 0
  if type(a:jd) == v:t_float
    let jd = float2nr(floor(a:jd))
    let second = float2nr(s:SECONDS_OF_DAY * (a:jd - jd))
  else
    let jd = a:jd
  endif
  let [year, month, day] = s:_jd2g(jd)
  return s:from_date(year, month, day, 12, 0, second, '+0000').to(tz)
endfunction

" Creates a new TimeZone object.
function! s:timezone(...) abort
  let info = a:0 ? a:1 : ''
  if s:_is_class(info, 'TimeZone')
    return info
  endif
  if info is# ''
    unlet info
    let info = s:_default_tz()
  endif
  let tz = copy(s:TimeZone)
  if type(info) == v:t_number
    let tz._offset = info * s:NUM_MINUTES * s:NUM_SECONDS
  elseif type(info) == v:t_string
    let list = matchlist(info, '\v^([+-])?(\d{1,2}):?(\d{1,2})?$')
    if !empty(list)
      let tz._offset = str2nr(list[1] . s:NUM_SECONDS) *
      \                (str2nr(list[2]) * s:NUM_MINUTES + str2nr(list[3]))
    else
      " TODO: TimeZone names
      throw 'vital: DateTime: Unknown timezone: ' . string(info)
    endif
  else
    throw 'vital: DateTime: Invalid timezone: ' . string(info)
  endif
  return tz
endfunction

" Creates a new TimeDelta object.
function! s:delta(...) abort
  let info = a:0 ? a:1 : ''
  if s:_is_class(info, 'TimeDelta')
    return info
  endif
  let d = copy(s:TimeDelta)
  if a:0 == 2 && type(a:1) == v:t_number && type(a:2) == v:t_number
    let d._days = a:1
    let d._seconds = a:2
  else
    let a = copy(a:000)
    while 2 <= len(a) && type(a[0]) == v:t_number && type(a[1]) == v:t_string
      let [value, unit] = remove(a, 0, 1)
      if unit =~? '^sec\%(onds\?\)\?$'
        let d._seconds += value
      elseif unit =~? '^min\%(utes\?\)\?$'
        let d._seconds += value * s:NUM_SECONDS
      elseif unit =~? '^hours\?$'
        let d._seconds += value * s:SECONDS_OF_HOUR
      elseif unit =~? '^days\?$'
        let d._days += value
      elseif unit =~? '^weeks\?$'
        let d._days += value * s:NUM_DAYS_OF_WEEK
      else
        throw 'vital: DateTime: Invalid unit for delta(): ' . string(unit)
      endif
    endwhile
    if !empty(a)
      throw 'vital: DateTime: Invalid arguments for delta(): ' . string(a)
    endif
  endif
  return d._normalize()
endfunction

function! s:compare(d1, d2) abort
  return a:d1.compare(a:d2)
endfunction

" Returns month names according to the current or specified locale.
" @param fullname = false
" @param locale = ''
function! s:month_names(...) abort
  return s:_names(s:MONTHS, a:0 && a:1 ? '%B' : '%b', get(a:000, 1, ''))
endfunction

" Returns weekday names according to the current or specified locale.
" @param fullname = false
" @param locale = ''
function! s:weekday_names(...) abort
  return s:_names(s:WEEKS, a:0 && a:1 ? '%A' : '%a', get(a:000, 1, ''))
endfunction

" Returns am/pm names according to the current or specified locale.
" @param lowercase = false
" @param locale = ''
function! s:am_pm_names(...) abort
  let [lowercase, locale] = a:000 + [0, ''][a:0 :]
  let names = s:_am_pm_names(lowercase, locale)
  if lowercase
    " Some environments do not support %P.
    " In this case, use tolower() of %p instead of.
    let failed = names[0] ==# '' || names[0] ==# 'P'
    if failed
      let names = s:_am_pm_names(0, locale)
      call map(names, 'tolower(v:val)')
    endif
  endif
  return names
endfunction

function! s:_am_pm_names(lowercase, locale) abort
  return s:_names(s:AM_PM_TIMES, a:lowercase ? '%P' : '%p', a:locale)
endfunction

" Returns 1 if the year is a leap year.
function! s:is_leap_year(year) abort
  return a:year % 4 == 0 && a:year % 100 != 0 || a:year % 400 == 0
endfunction


" ----------------------------------------------------------------------------
let s:Class = {}
function! s:Class._clone() abort
  return filter(copy(self), 'v:key !~# "^__"')
endfunction
function! s:_new_class(class) abort
  return extend({'class': a:class}, s:Class)
endfunction
function! s:_is_class(obj, class) abort
  return type(a:obj) == v:t_dict && get(a:obj, 'class', '') ==# a:class
endfunction

" ----------------------------------------------------------------------------
let s:DateTime = s:_new_class('DateTime')
function! s:DateTime.year() abort
  return self._year
endfunction
function! s:DateTime.month() abort
  return self._month
endfunction
function! s:DateTime.day() abort
  return self._day
endfunction
function! s:DateTime.hour() abort
  return self._hour
endfunction
function! s:DateTime.minute() abort
  return self._minute
endfunction
function! s:DateTime.second() abort
  return self._second
endfunction
function! s:DateTime.timezone(...) abort
  if a:0
    let dt = self._clone()
    let dt._timezone = call('s:timezone', a:000)
    return dt
  endif
  return self._timezone
endfunction
function! s:DateTime.day_of_week() abort
  if !has_key(self, '__day_of_week')
    let self.__day_of_week = self.timezone(0).days_from_era() % 7
  endif
  return self.__day_of_week
endfunction
function! s:DateTime.day_of_year() abort
  if !has_key(self, '__day_of_year')
    let self.__day_of_year = self.timezone(0).julian_day() -
    \                       s:_g2jd(self._year, 1, 1) + 1
  endif
  return self.__day_of_year
endfunction
function! s:DateTime.days_from_era() abort
  if !has_key(self, '__day_from_era')
    let self.__day_from_era = self.julian_day() - s:ERA_TIME + 1
  endif
  return self.__day_from_era
endfunction
function! s:DateTime.julian_day(...) abort
  let utc = self.to(0)
  let jd = s:_g2jd(utc._year, utc._month, utc._day)
  if a:0 && a:1
    if has('float')
      let jd += (utc.seconds_of_day() + 0.0) / s:SECONDS_OF_DAY - 0.5
    elseif utc._hour < 12
      let jd -= 1
    endif
  endif
  return jd
endfunction
function! s:DateTime.seconds_of_day() abort
  return (self._hour * s:NUM_MINUTES + self._minute)
  \      * s:NUM_SECONDS + self._second
endfunction
function! s:DateTime.quarter() abort
  return (self._month - 1) / 3 + 1
endfunction
function! s:DateTime.unix_time() abort
  if !has_key(self, '__unix_time')
    if self._year < 1969 ||
          \ (!has('num64') && (2038 < self._year))
      let self.__unix_time = -1
    else
      let utc = self.to(0)
      let self.__unix_time = (utc.julian_day() - s:EPOC_TIME) *
      \  s:SECONDS_OF_DAY + utc.seconds_of_day()
      if self.__unix_time < 0
        let self.__unix_time = -1
      endif
    endif
  endif
  return self.__unix_time
endfunction
function! s:DateTime.is_leap_year() abort
  return s:is_leap_year(self._year)
endfunction
function! s:DateTime.is(dt) abort
  return self.compare(a:dt) == 0
endfunction
function! s:DateTime.compare(dt) abort
  return self.delta(a:dt).sign()
endfunction
function! s:DateTime.delta(dt) abort
  let left = self.to(0)
  let right = a:dt.to(0)
  return s:delta(left.days_from_era() - right.days_from_era(),
  \              (left.seconds_of_day() + left.timezone().offset()) -
  \              (right.seconds_of_day() + right.timezone().offset()))
endfunction
function! s:DateTime.to(...) abort
  let dt = self._clone()
  if a:0 == 1 && !s:_is_class(a:1, 'TimeDelta')
    let tz = s:timezone(a:1)
    let dt._second += tz.offset() - dt.timezone().offset()
    let dt._timezone = tz
    return dt._normalize()
  endif
  let delta = call('s:delta', a:000)
  let dt._day += delta._days
  let dt._second += delta._seconds
  return dt._normalize()
endfunction
" @vimlint(EVL102, 1, l:locale)
function! s:DateTime.format(format, ...) abort
  let locale = a:0 ? a:1 : ''
  let result = ''
  for f in s:_split_format(a:format)
    if type(f) == v:t_string
      let result .= f
    elseif type(f) == v:t_list
      let [info, flag, width] = f
      let padding = ''
      if type(info[1]) == v:t_list
        let [padding, w] = info[1]
        if width ==# ''
          let width = w
        endif
      endif
      if has_key(self, info[0])
        let value = self[info[0]]()
        if 2 < len(info)
          let l:['value'] = eval(info[2])
        endif
      elseif 2 < len(info)
        let value = info[2]
      else
        let value = ''
      endif
      if flag ==# '^'
        let value = toupper(value)
      elseif flag ==# '-'
        let padding = ''
      elseif flag ==# '_'
        let padding = ' '
      elseif flag ==# '0'
        let padding = '0'
      endif
      let result .= printf('%' . padding . width . 's', value)
      unlet value
    endif
    unlet f
  endfor
  return result
endfunction
" @vimlint(EVL102, 0, l:locale)
function! s:DateTime.strftime(format, ...) abort
  let tz = self.timezone()
  let ts = self.unix_time() + tz.offset() - s:tz_default_offset
  let locale = get(a:000, 0, '')
  let format = a:format =~? '%z'
        \ ? substitute(a:format, '%z', tz.offset_string(), 'g')
        \ : a:format
  if empty(locale)
    return strftime(format, ts)
  else
    let expr = printf('strftime(%s, %d)', string(format), ts)
    return s:_with_locale(expr, locale)
  endif
endfunction
function! s:DateTime.to_string() abort
  return self.format('%c')
endfunction
function! s:DateTime._normalize() abort
  let next = 0
  for unit in ['second', 'minute', 'hour']
    let key = '_' . unit
    let self[key] += next
    let [next, self[key]] =
    \   s:_divmod(self[key], s:['NUM_' . toupper(unit . 's')])
  endfor
  let self._day += next
  let [self._year, self._month, self._day] =
  \   s:_jd2g(s:_g2jd(self._year, self._month, self._day))
  return self
endfunction

let s:DateTime['+'] = s:DateTime.to
let s:DateTime['-'] = s:DateTime.delta
let s:DateTime['=='] = s:DateTime.is


" ----------------------------------------------------------------------------
let s:TimeZone = s:_new_class('TimeZone')
function! s:TimeZone.offset() abort
  return self._offset
endfunction
function! s:TimeZone.minutes() abort
  return self._offset / s:NUM_SECONDS
endfunction
function! s:TimeZone.hours() abort
  return self._offset / s:SECONDS_OF_HOUR
endfunction
function! s:TimeZone.sign() abort
  return self._offset < 0 ? -1 : 0 < self._offset ? 1 : 0
endfunction
function! s:TimeZone.offset_string() abort
  return substitute(self.w3c(), ':', '', '')
endfunction
function! s:TimeZone.w3c() abort
  let sign = self._offset < 0 ? '-' : '+'
  let minutes = abs(self._offset) / s:NUM_SECONDS
  return printf('%s%02d:%02d', sign,
  \             minutes / s:NUM_MINUTES, minutes % s:NUM_MINUTES)
endfunction

" ----------------------------------------------------------------------------
let s:TimeDelta = s:_new_class('TimeDelta')
function! s:TimeDelta.seconds() abort
  return self._seconds % s:NUM_SECONDS
endfunction
function! s:TimeDelta.minutes() abort
  return self._seconds / s:NUM_SECONDS % s:NUM_MINUTES
endfunction
function! s:TimeDelta.hours() abort
  return self._seconds / s:SECONDS_OF_HOUR
endfunction
function! s:TimeDelta.days() abort
  return self._days
endfunction
function! s:TimeDelta.weeks() abort
  return self._days / s:NUM_DAYS_OF_WEEK
endfunction
function! s:TimeDelta.months() abort
  return self._days / 30
endfunction
function! s:TimeDelta.years() abort
  return self._days / 365
endfunction
function! s:TimeDelta.total_seconds() abort
  return self._days * s:SECONDS_OF_DAY + self._seconds
endfunction
function! s:TimeDelta.is(td) abort
  return self.subtract(a:td).sign() == 0
endfunction
function! s:TimeDelta.sign() abort
  if self._days < 0 || self._seconds < 0
    return -1
  elseif 0 < self._days || 0 < self._seconds
    return 1
  endif
  return 0
endfunction
function! s:TimeDelta.negate() abort
  let td = self._clone()
  let td._days = -self._days
  let td._seconds = -self._seconds
  return td._normalize()
endfunction
function! s:TimeDelta.duration() abort
  return self.sign() < 0 ? self.negate() : self
endfunction
function! s:TimeDelta.add(...) abort
  let n = self._clone()
  let other = call('s:delta', a:000)
  let n._days += other._days
  let n._seconds += other._seconds
  return n._normalize()
endfunction
function! s:TimeDelta.subtract(...) abort
  let other = call('s:delta', a:000)
  return self.add(other.negate())
endfunction
function! s:TimeDelta.about() abort
  if self.sign() == 0
    return 'now'
  endif
  let dir = self.sign() < 0 ? 'ago' : 'later'
  let d = self.duration()
  if d._days == 0
    if d._seconds < s:NUM_SECONDS
      let val = d.seconds()
      let unit = val == 1 ? 'second' : 'seconds'
    elseif d._seconds < s:SECONDS_OF_HOUR
      let val = d.minutes()
      let unit = val == 1 ? 'minute' : 'minutes'
    else
      let val = d.hours()
      let unit = val == 1 ? 'hour' : 'hours'
    endif
  else
    if d._days < s:NUM_DAYS_OF_WEEK
      let val = d.days()
      let unit = val == 1 ? 'day' : 'days'
    elseif d._days < 30
      let val = d.weeks()
      let unit = val == 1 ? 'week' : 'weeks'
    elseif d._days < 365
      let val = d.months()
      let unit = val == 1 ? 'month' : 'months'
    else
      let val = d.years()
      let unit = val == 1 ? 'year' : 'years'
    endif
  endif
  return printf('%d %s %s', val, unit, dir)
endfunction
function! s:TimeDelta.to_string() abort
  let str = self.sign() < 0 ? '-' : ''
  let d = self.duration()
  if d._days != 0
    let str .= d._days . (d._days == 1 ? 'day' : 'days') . ', '
  endif
  let str .= printf('%02d:%02d:%02d', d.hours(), d.minutes(), d.seconds())
  return str
endfunction
function! s:TimeDelta._normalize() abort
  let over_days = self._seconds / s:SECONDS_OF_DAY
  let self._days += over_days
  let self._seconds = self._seconds % s:SECONDS_OF_DAY

  if self._days < 0 && 0 < self._seconds
    let self._days += 1
    let self._seconds -= s:SECONDS_OF_DAY
  elseif 0 < self._days && self._seconds < 0
    let self._days -= 1
    let self._seconds += s:SECONDS_OF_DAY
  endif
  return self
endfunction

" ----------------------------------------------------------------------------

" Converts Gregorian Calendar to Julian day
function! s:_g2jd(year, month, day) abort
  let [next, month] = s:_divmod(a:month - 1, s:NUM_MONTHS)
  let year = a:year + next + 4800 - (month <= 1)
  let month += month <= 1 ? 10 : -2
  return a:day + (153 * month + 2) / 5 + s:_div(1461 * year, 4) - 32045
  \      - s:_div(year, 100) + s:_div(year, 400)
endfunction

" Converts Julian day to Gregorian Calendar
function! s:_jd2g(jd) abort
  let t = a:jd + 68569
  let n = s:_div(4 * t, 146097)
  let t -= s:_div(146097 * n + 3, 4) - 1
  let i = (4000 * t) / 1461001
  let t += -(1461 * i) / 4 + 30
  let j = (80 * t) / 2447
  let x = j / 11
  let day = t - (2447 * j) / 80
  let month = j + 2 - (12 * x)
  let year = 100 * (n - 49) + i + x
  return [year, month, day]
endfunction

function! s:_names(dates, format, locale) abort
  return s:_with_locale('map(copy(a:1), "strftime(a:2, v:val)")',
  \                     a:locale, copy(a:dates), a:format)
endfunction

function! s:_with_locale(expr, locale, ...) abort
  let current_locale = ''
  if a:locale !=# ''
    let current_locale = v:lc_time
    execute 'language time' a:locale
  endif
  try
    return eval(a:expr)
  finally
    if a:locale !=# ''
      execute 'language time' current_locale
    endif
  endtry
endfunction

function! s:_div(n, d) abort
  return s:_divmod(a:n, a:d)[0]
endfunction
function! s:_mod(n, d) abort
  return s:_divmod(a:n, a:d)[1]
endfunction
function! s:_divmod(n, d) abort
  let [q, mod] = [a:n / a:d, a:n % a:d]
  return mod != 0 && (a:d < 0) != (mod < 0) ? [q - 1, mod + a:d] : [q, mod]
endfunction


" ----------------------------------------------------------------------------
function! s:_month_abbr(locale) abort
  return s:month_names(0, a:locale)
endfunction
function! s:_month_full(locale) abort
  return s:month_names(1, a:locale)
endfunction
function! s:_weekday_abbr(locale) abort
  return s:weekday_names(0, a:locale)
endfunction
function! s:_weekday_full(locale) abort
  return s:weekday_names(1, a:locale)
endfunction
function! s:_am_pm_lower(locale) abort
  return s:am_pm_names(1, a:locale)
endfunction
function! s:_am_pm_upper(locale) abort
  return s:am_pm_names(0, a:locale)
endfunction

" key = descriptor
" value = string (format alias)
" value = [field, captor, format_conv, parse_conv]
" at format:
"   field = function name of source.
"   captor = [flat, width] for number format.
"   format_conv = expr for convert. some variables are available.
"   parse_conv = unused.
" at parse:
"   field = param name (with "_")
"           if it doesn't exist, the descriptor can't use.
"   field = #skip
"           in this case, captor is a skipping pattern
"   captor = pattern to match.
"   captor = [flat, width] for number format.
"   captor = a function to return a pattern or candidates.
"   format_conv = unused.
"   parse_conv = expr for convert. some variables are available.
let s:format_info = {
\   '%': ['', '%', '%'],
\   'a': ['day_of_week', function('s:_weekday_abbr'),
\         's:_weekday_abbr(locale)[value]'],
\   'A': ['day_of_week', function('s:_weekday_full'),
\         's:_weekday_full(locale)[value]'],
\   'b': ['month', function('s:_month_abbr'),
\         's:_month_abbr(locale)[value - 1]', 'value + 1'],
\   'B': ['month', function('s:_month_full'),
\         's:_month_full(locale)[value - 1]', 'value + 1'],
\   'c': '%F %T %z',
\   'C': ['year', ['0', 2], '(value + 99) / 100', 'o[key] % 100 + value * 100'],
\   'd': ['day', ['0', 2]],
\   'D': '%m/%d/%y',
\   'e': '%_m/%_d/%_y',
\   'F': '%Y-%m-%d',
\   'h': '%b',
\   'H': ['hour', ['0', 2]],
\   'I': ['hour', ['0', 2], 's:_mod(value - 1, 12) + 1', 'value % 12'],
\   'j': ['day_of_year', ['0', 3]],
\   'k': '%_H',
\   'l': '%_I',
\   'm': ['month', ['0', 2]],
\   'M': ['minute', ['0', 2]],
\   'n': ['', '\_s*', "\n"],
\   'p': ['hour', function('s:_am_pm_upper'),
\         's:_am_pm_upper(locale)[value / 12]', 'o[key] + value * 12'],
\   'P': ['hour', function('s:_am_pm_lower'),
\         's:_am_pm_lower(locale)[value / 12]', 'o[key] + value * 12'],
\   'r': '%I:%M:%S %p',
\   'R': '%H:%M',
\   's': ['unix_time', ['', '']],
\   'S': ['second', ['0', 2]],
\   't': ['', '\_.*', "\t"],
\   'u': ['day_of_week', ['0', 1], 'value == 0 ? 7 : value'],
\   'U': 'TODO',
\   'T': '%H:%M:%S',
\   'w': ['day_of_week', ['0', 1]],
\   'y': ['year', ['0', 2], 'value % 100',
\         '(o[key] != 0 ? o[key] : (value < 69 ? 2000 : 1900)) + value'],
\   'Y': ['year', ['0', 4]],
\   'z': ['timezone', '\v[+-]?%(\d{1,2})?:?%(\d{1,2})?', 'value.offset_string()',
\         's:timezone(empty(value) ? 0 : value)'],
\   '*': ['#skip', '.\{-}', ''],
\ }
let s:DESCRIPTORS_PATTERN = '[' . join(keys(s:format_info), '') . ']'

" 'foo%Ybar%02m' => ['foo', ['Y', '', -1], 'bar', ['m', '0', 2], '']
function! s:_split_format(format) abort
  let res = []
  let pat = '\C%\([-_0^#]\?\)\(\d*\)\(' . s:DESCRIPTORS_PATTERN . '\)'
  let format = a:format
  while format !=# ''
    let i = match(format, pat)
    if i < 0
      let res += [format]
      break
    endif
    if i != 0
      let res += [format[: i - 1]]
      let format = format[i :]
    endif
    let [matched, flag, width, d] = matchlist(format, pat)[: 3]
    let format = format[len(matched) :]
    let info = s:format_info[d]
    if type(info) == v:t_string
      let format = info . format
    else
      let res += [[info, flag, width]]
    endif
    unlet info
  endwhile
  return res
endfunction

if has('win32') " This means any versions of windows https://github.com/vim-jp/vital.vim/wiki/Coding-Rule#how-to-check-if-the-runtime-os-is-windows
  function! s:_default_tz() abort
    let hm = map(split(strftime('%H %M', 0), ' '), 'str2nr(v:val)')
    if str2nr(strftime('%Y', 0)) != 1970
      let tz_sec = s:SECONDS_OF_DAY - hm[0] * s:SECONDS_OF_HOUR - hm[1] * s:NUM_SECONDS
      return printf('-%02d%02d', tz_sec / s:SECONDS_OF_HOUR, (tz_sec / s:NUM_SECONDS) % s:NUM_MINUTES)
    endif
    return printf('+%02d%02d', hm[0], hm[1])
  endfunction
else
  function! s:_default_tz() abort
    return strftime('%z')
  endfunction
endif

call s:_init()
