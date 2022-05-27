let s:DateTime = vital#gina#import('DateTime')


function! gina#core#timestamper#new(...) abort
  let timestamper = extend({
        \ 'now': s:DateTime.now(),
        \ 'months': 3,
        \ 'format1': '%d %b',
        \ 'format2': '%d %b, %Y',
        \}, get(a:000, 0, {})
        \)
  let timestamper = extend(timestamper, s:timestamper, 'keep')
  let timestamper._cache_timezone = {}
  let timestamper._cache_datetime = {}
  let timestamper._cache_timestamp = {}
  return timestamper
endfunction


" Timestamper ----------------------------------------------------------------
let s:timestamper = {}

function! s:timestamper.timezone(timezone) abort
  if has_key(self._cache_timezone, a:timezone)
    return self._cache_timezone[a:timezone]
  endif
  let timezone = s:DateTime.timezone(a:timezone)
  let self._cache_timezone[a:timezone] = timezone
  return timezone
endfunction

function! s:timestamper.datetime(epoch, timezone) abort
  let cname = a:epoch . a:timezone
  if has_key(self._cache_datetime, cname)
    return self._cache_datetime[cname]
  endif
  let timezone = self.timezone(a:timezone)
  let datetime = s:DateTime.from_unix_time(a:epoch, timezone)
  let self._cache_datetime[cname] = datetime
  return datetime
endfunction

function! s:timestamper.format(epoch, timezone) abort
  let cname = a:epoch . a:timezone
  if has_key(self._cache_timestamp, cname)
    return self._cache_timestamp[cname]
  endif
  let datetime = self.datetime(a:epoch, a:timezone)
  let timedelta = datetime.delta(self.now)
  if timedelta.duration().months() < self.months
    let timestamp = timedelta.about()
  elseif datetime.year() == self.now.year()
    let timestamp = datetime.strftime(self.format1)
  else
    let timestamp = datetime.strftime(self.format2)
  endif
  let self._cache_timestamp[cname] = timestamp
  return timestamp
endfunction
