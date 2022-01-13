function! SpaceVim#api#iconv#codecs#ascii#import() abort
  return s:ascii
endfunction
" SpaceVim#api#iconv#
let s:tablebase = SpaceVim#api#iconv#codecs#tablebase#import()

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

