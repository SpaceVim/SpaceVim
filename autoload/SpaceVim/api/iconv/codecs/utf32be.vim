
let s:nsiconv = expand('<sfile>:p:h:h:gs?[\\/]?#?:s?^.*#autoload\(#\|$\)??:s?$?#?')
let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:utf32be
endfunction

let s:base = {s:nsiconv}codecs#base#import()

let s:utf32be = {}

let s:utf32be.Codec = {}
call extend(s:utf32be.Codec, s:base.Codec)
let s:utf32be.Codec.encoding = "UTF-32BE"

function! s:utf32be.Codec.mbtowc(input, start)
  if a:start + 3 >= len(a:input)
    return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
  endif
  let wc = (a:input[a:start + 0] * 0x1000000) + (a:input[a:start + 1] * 0x10000) + (a:input[a:start + 2] * 0x100) + a:input[a:start + 3]
  if wc >= 0 && wc < 0x110000 && !(wc >= 0xd800 && wc < 0xe000)
    return [[wc], a:start + 4]
  else
    return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start + 3)
  endif
endfunction

function! s:utf32be.Codec.wctomb(input, start)
  let wc = a:input[a:start]
  if wc >= 0 && wc < 0x110000 && !(wc >= 0xd800 && wc < 0xe000)
    return [[0, wc / 0x10000 % 0x100, wc / 0x100 % 0x100, wc % 0x100], a:start + 1]
  endif
  return self.error('UnicodeEncodeError', 'invalid', a:input, a:start, a:start)
endfunction

