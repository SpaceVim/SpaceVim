
let s:nsiconv = expand('<sfile>:p:h:h:gs?[\\/]?#?:s?^.*#autoload\(#\|$\)??:s?$?#?')
let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:utf32
endfunction

let s:base = {s:nsiconv}codecs#base#import()

let s:utf32 = {}

let s:utf32.Codec = {}
call extend(s:utf32.Codec, s:base.Codec)
let s:utf32.Codec.encoding = "UTF-32"
let s:utf32.Codec.istate = 0
let s:utf32.Codec.ostate = 0

function! s:utf32.Codec.mbtowc(input, start)
  if a:start + 3 >= len(a:input)
    return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
  endif
  let wc = self.istate
        \ ? a:input[a:start + 0] + (a:input[a:start + 1] * 0x100) + (a:input[a:start + 2] * 0x10000) + (a:input[a:start + 3] * 0x1000000)
        \ : (a:input[a:start + 0] * 0x1000000) + (a:input[a:start + 1] * 0x10000) + (a:input[a:start + 2] * 0x100) + a:input[a:start + 3]
  if wc == 0x0000feff
    return [[], a:start + 4]
  elseif wc == 0xfffe0000
    let self.istate = !self.istate
    return [[], a:start + 4]
  else
    if wc >= 0 && wc < 0x110000 && !(wc >= 0xd800 && wc < 0xe000)
      return [[wc], a:start + 4]
    else
      return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start + 3)
    endif
  endif
endfunction

function! s:utf32.Codec.wctomb(input, start)
  let res = []
  let wc = a:input[a:start]
  if wc >= 0 && wc < 0x110000 && !(wc >= 0xd800 && wc < 0xe000)
    if !self.ostate
      call add(res, 0x00)
      call add(res, 0x00)
      call add(res, 0xFE)
      call add(res, 0xFF)
    endif
    if wc >= 0 && wc < 0x110000
      call add(res, 0x00)
      call add(res, wc / 0x10000 % 0x100)
      call add(res, wc / 0x100 % 0x100)
      call add(res, wc % 0x100)
      let self.ostate = 1
      return [res, a:start + 1]
    endif
  endif
  return self.error('UnicodeEncodeError', 'invalid', a:input, a:start, a:start)
endfunction

