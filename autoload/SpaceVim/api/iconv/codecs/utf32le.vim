
let s:nsiconv = expand('<sfile>:p:h:h:gs?[\\/]?#?:s?^.*#autoload\(#\|$\)??:s?$?#?')
let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:utf32le
endfunction

let s:base = {s:nsiconv}codecs#base#import()

let s:utf32le = {}

let s:utf32le.Codec = {}
call extend(s:utf32le.Codec, s:base.Codec)
let s:utf32le.Codec.encoding = "UTF-32LE"

function! s:utf32le.Codec.mbtowc(input, start)
  if a:start + 3 >= len(a:input)
    return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
  endif
  let wc = a:input[a:start + 0] + (a:input[a:start + 1] * 0x100) + (a:input[a:start + 2] * 0x10000) + (a:input[a:start + 3] * 0x1000000)
  if wc >= 0 && wc < 0x110000 && !(wc >= 0xd800 && wc < 0xe000)
    return [[wc], a:start + 4]
  else
    return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start + 3)
  endif
endfunction

function! s:utf32le.Codec.wctomb(input, start)
  let wc = a:input[a:start]
  if wc >= 0 && wc < 0x110000 && !(wc >= 0xd800 && wc < 0xe000)
    return [[wc % 0x100, wc / 0x100 % 0x100, wc / 0x10000 % 0x100, 0], a:start + 1]
  endif
  return self.error('UnicodeEncodeError', 'invalid', a:input, a:start, a:start)
endfunction

function s:utf32le.flush()
  return []
endfunction

