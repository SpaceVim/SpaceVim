
let s:nsiconv = expand('<sfile>:p:h:h:gs?[\\/]?#?:s?^.*#autoload\(#\|$\)??:s?$?#?')
let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:tablebase
endfunction

let s:base = {s:nsiconv}codecs#base#import()

let s:tablebase = {}

let s:tablebase.Codec = {}
call extend(s:tablebase.Codec, s:base.Codec)
let s:tablebase.Codec.decoding_table_maxlen = 0
let s:tablebase.Codec.decoding_table = {}
let s:tablebase.Codec.encoding_table_maxlen = 0
let s:tablebase.Codec.encoding_table = {}

function! s:tablebase.Codec.mbtowc(input, start)
  for i in range(self.decoding_table_maxlen)
    if a:start + i >= len(a:input)
      return self.error('UnicodeDecodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
    endif
    let key = join(a:input[a:start : a:start + i], ',')
    if has_key(self.decoding_table, key)
      return [self.decoding_table[key], a:start + i + 1]
    endif
  endfor
  return self.error('UnicodeDecodeError', 'invalid', a:input, a:start, a:start)
endfunction

function! s:tablebase.Codec.wctomb(input, start)
  for i in range(self.encoding_table_maxlen)
    if a:start + i >= len(a:input)
      return self.error('UnicodeEncodeError', 'incomplete', a:input, a:start, len(a:input) - 1)
    endif
    let key = join(a:input[a:start : a:start + i], ',')
    if has_key(self.encoding_table, key)
      return [self.encoding_table[key], a:start + i + 1]
    endif
  endfor
  return self.error('UnicodeEncodeError', 'invalid', a:input, a:start, a:start)
endfunction

