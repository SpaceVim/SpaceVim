
let s:nsiconv = expand('<sfile>:p:h:h:gs?[\\/]?#?:s?^.*#autoload\(#\|$\)??:s?$?#?')
let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:ascii
endfunction

let s:tablebase = {s:nsiconv}codecs#tablebase#import()

let s:ascii = {}

let s:ascii.Codec = {}
call extend(s:ascii.Codec, s:tablebase.Codec)
let s:ascii.Codec.encoding = 'ASCII'

let s:ascii.Codec.decoding_table_maxlen = 1
let s:ascii.Codec.decoding_table = {}
for s:i in range(0x80)
  let s:ascii.Codec.decoding_table[s:i] = [s:i]
endfor
unlet s:i

let s:ascii.Codec.encoding_table_maxlen = 1
let s:ascii.Codec.encoding_table = {}
for s:i in range(0x80)
  let s:ascii.Codec.encoding_table[s:i] = [s:i]
endfor
unlet s:i

