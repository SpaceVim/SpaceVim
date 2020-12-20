
let s:nsiconv = expand('<sfile>:p:h:h:gs?[\\/]?#?:s?^.*#autoload\(#\|$\)??:s?$?#?')
let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:utf16le
endfunction

let s:base = {s:nsiconv}codecs#base#import()

let s:utf16le = {}

let s:utf16le.Codec = {}
call extend(s:utf16le.Codec, s:base.Codec)
let s:utf16le.Codec.encoding = "UTF-16LE"

function! s:utf16le.Codec.mbtowc(input, start)
  if a:start + 1 >= len(a:input)
    return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
  endif
  let wc = a:input[a:start + 0] + (a:input[a:start + 1] * 0x100)
  if wc >= 0xd800 && wc < 0xdc00
    if a:start + 3 >= len(a:input)
      return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
    endif
    let wc2 = a:input[a:start + 2] + (a:input[a:start + 3] * 0x100)
    if !(wc2 >= 0xdc00 && wc2 < 0xe000)
      return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start + 3)
    endif
    let pwc = 0x10000 + ((wc - 0xd800) * 0x400) + (wc2 - 0xdc00)
    return [[pwc], a:start + 4]
  elseif wc >= 0xdc00 && wc < 0xe000
    return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start + 1)
  else
    return [[wc], a:start + 2]
  endif
endfunction

function! s:utf16le.Codec.wctomb(input, start)
  let wc = a:input[a:start]
  if !(wc >= 0xd800 && wc < 0xe000)
    if wc < 0x10000
      return [[wc % 0x100, wc / 0x100], a:start + 1]
    elseif wc < 0x110000
      let wc1 = 0xd800 + ((wc - 0x10000) / 0x400)
      let wc2 = 0xdc00 + ((wc - 0x10000) % 0x400)
      return [[wc1 % 0x100, wc1 / 0x100, wc2 % 0x100, wc2 / 0x100], a:start + 1]
    endif
  endif
  return self.error('UnicodeEncodeError', 'invalid', a:input, a:start, a:start)
endfunction

