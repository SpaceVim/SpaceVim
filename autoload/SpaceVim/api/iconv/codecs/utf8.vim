
let s:nsiconv = expand('<sfile>:p:h:h:gs?[\\/]?#?:s?^.*#autoload\(#\|$\)??:s?$?#?')
let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:utf8
endfunction

let s:base = {s:nsiconv}codecs#base#import()

let s:utf8 = {}

let s:utf8.Codec = {}
call extend(s:utf8.Codec, s:base.Codec)
let s:utf8.Codec.encoding = "UTF-8"

function s:utf8.Codec.CheckByte(c)
  return (a:c >= 0x80) && ((a:c - 0x80) < 0x40)
endfunction

function! s:utf8.Codec.mbtowc(input, start)
  let c = a:input[a:start]

  if c < 0x80
    return [[c], a:start + 1]
  elseif c < 0xc2
    return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start)
  elseif c < 0xe0
    if a:start + 1 >= len(a:input)
      return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
    endif
    if !(self.CheckByte(a:input[a:start + 1]))
      return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start + 1)
    endif
    let wc = ((c % 0x20) * 0x40) + (a:input[a:start + 1] - 0x80)
    return [[wc], a:start + 2]
  elseif c < 0xf0
    if a:start + 2 >= len(a:input)
      return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
    endif
    if !(self.CheckByte(a:input[a:start + 1])
          \ && self.CheckByte(a:input[a:start + 2])
          \ && (c >= 0xe1 || a:input[a:start + 1] >= 0xa0))
      return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start + 2)
    endif
    let wc = ((c % 0x10) * 0x1000)
          \ + ((a:input[a:start + 1] - 0x80) * 0x40)
          \ + (a:input[a:start + 2] - 0x80)
    return [[wc], a:start + 3]
  elseif c < 0xf8
    if a:start + 3 >= len(a:input)
      return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
    endif
    if !(self.CheckByte(a:input[a:start + 1])
          \ && self.CheckByte(a:input[a:start + 2])
          \ && self.CheckByte(a:input[a:start + 3])
          \ && (c >= 0xf1 || a:input[a:start + 1] >= 0x90))
      return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start + 3)
    endif
    let wc = ((c % 0x08) * 0x40000)
          \ + ((a:input[a:start + 1] - 0x80) * 0x1000)
          \ + ((a:input[a:start + 2] - 0x80) * 0x40)
          \ + (a:input[a:start + 3] - 0x80)
    return [[wc], a:start + 4]
  elseif c < 0xfc
    if a:start + 4 >= len(a:input)
      return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
    endif
    if !(self.CheckByte(a:input[a:start + 1])
          \ && self.CheckByte(a:input[a:start + 2])
          \ && self.CheckByte(a:input[a:start + 3])
          \ && self.CheckByte(a:input[a:start + 4])
          \ && (c >= 0xf9 || a:input[a:start + 1] >= 0x88))
      return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start + 4)
    endif
    let wc = ((c % 0x04) * 0x1000000)
          \ + ((a:input[a:start + 1] - 0x80) * 0x40000)
          \ + ((a:input[a:start + 2] - 0x80) * 0x1000)
          \ + ((a:input[a:start + 3] - 0x80) * 0x40)
          \ + (a:input[a:start + 4] - 0x80)
    return [[wc], a:start + 5]
  elseif c < 0xfe
    if a:start + 5 >= len(a:input)
      return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
    endif
    if !(self.CheckByte(a:input[a:start + 1])
          \ && self.CheckByte(a:input[a:start + 2])
          \ && self.CheckByte(a:input[a:start + 3])
          \ && self.CheckByte(a:input[a:start + 4])
          \ && self.CheckByte(a:input[a:start + 5])
          \ && (c >= 0xfd || a:input[a:start + 1] >= 0x84))
      return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start + 5)
    endif
    let wc = ((c % 0x02) * 0x40000000)
          \ + ((a:input[a:start + 1] - 0x80) * 0x1000000)
          \ + ((a:input[a:start + 2] - 0x80) * 0x40000)
          \ + ((a:input[a:start + 3] - 0x80) * 0x1000)
          \ + ((a:input[a:start + 4] - 0x80) * 0x40)
          \ + (a:input[a:start + 5] - 0x80)
    return [[wc], a:start + 6]
  else
    return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start)
  endif
endfunction

function! s:utf8.Codec.wctomb(input, start)
  let wc = a:input[a:start]

  let cnt = 0
  if wc < 0x80
    let cnt = 1
  elseif wc < 0x800
    let cnt = 2
  elseif wc < 0x10000
    let cnt = 3
  elseif wc < 0x200000
    let cnt = 4
  elseif wc < 0x4000000
    let cnt = 5
  elseif wc <= 0x7fffffff
    let cnt = 6
  else
    return self.error('UnicodeEncodeError', 'invalid', a:input, a:start, a:start)
  endif

  let r = []
  if cnt >= 6
    call insert(r, 0x80 + (wc % 0x40))
    let wc = (wc / 0x40) + 0x4000000
  endif
  if cnt >= 5
    call insert(r, 0x80 + (wc % 0x40))
    let wc = (wc / 0x40) + 0x200000
  endif
  if cnt >= 4
    call insert(r, 0x80 + (wc % 0x40))
    let wc = (wc / 0x40) + 0x10000
  endif
  if cnt >= 3
    call insert(r, 0x80 + (wc % 0x40))
    let wc = (wc / 0x40) + 0x800
  endif
  if cnt >= 2
    call insert(r, 0x80 + (wc % 0x40))
    let wc = (wc / 0x40) + 0xc0
  endif
  if cnt >= 1
    call insert(r, wc)
  endif
  return [r, a:start + 1]
endfunction

