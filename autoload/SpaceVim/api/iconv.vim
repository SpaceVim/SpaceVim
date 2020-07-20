let s:self = {}


if has('iconv') && !has('nvim')
  function! s:self.iconv(str, from, to) abort
    return iconv(a:str, a:from, a:to)
  endfunction
else
  function! s:self.iconv(str, from, to) abort
    " let errors = get(a:000, 0, 'strict')
    return s:iconv.iconv(a:str, a:from, a:to, 'strict')
  endfunction
endif


let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:iconv
endfunction

function {s:ns}iconv(expr, from, to, ...)
  let errors = get(a:000, 0, 'strict')
  try
    return s:iconv.iconv(a:expr, a:from, a:to, errors)
  endtry
endfunction

function {s:ns}iconvb(expr, from, to, ...)
  let errors = get(a:000, 0, 'strict')
  try
    return s:iconv.iconvb(a:expr, a:from, a:to, errors)
  endtry
endfunction

let s:bytes = {s:ns}bytes#import()

let s:iconv = {}

function s:iconv.iconv(expr, from, to, errors)
  return s:bytes.bytes2str(self.iconvb(a:expr, a:from, a:to, a:errors))
endfunction

function s:iconv.iconvb(expr, from, to, errors)
  let expr = s:bytes.tobytes(a:expr)
  return self._iconv(expr, a:from, a:to, a:errors)
endfunction

function s:iconv._iconv(expr, from, to, errors)
  let from = tolower(a:from)
  let to = tolower(a:to)

  if !has_key(self.codecs, from)
    throw printf('unknown encoding: %s', from)
  endif

  if !has_key(self.codecs, to)
    throw printf('unknown encoding: %s', to)
  endif

  let decoder_module = call(self.codecs[from], [])
  let encoder_module = call(self.codecs[to], [])

  let decoder = decoder_module.Codec.new()
  let encoder = encoder_module.Codec.new()

  let u = decoder.decode(a:expr, a:errors)
  let s = encoder.encode(u, a:errors)

  return s
endfunction

let s:iconv.codecs = {
      \ "ascii": function(s:ns."codecs#ascii#import"),
      \ "utf-8": function(s:ns."codecs#utf8#import"),
      \ "utf-16": function(s:ns."codecs#utf16#import"),
      \ "utf-16be": function(s:ns."codecs#utf16be#import"),
      \ "utf-16le": function(s:ns."codecs#utf16le#import"),
      \ "utf-32": function(s:ns."codecs#utf32#import"),
      \ "utf-32be": function(s:ns."codecs#utf32be#import"),
      \ "utf-32le": function(s:ns."codecs#utf32le#import"),
      \ "latin1": function(s:ns."codecs#_8859_1#import"),
      \ "iso-8859-1": function(s:ns."codecs#_8859_1#import"),
      \ "iso-8859-2": function(s:ns."codecs#_8859_2#import"),
      \ "iso-8859-3": function(s:ns."codecs#_8859_3#import"),
      \ "iso-8859-4": function(s:ns."codecs#_8859_4#import"),
      \ "iso-8859-5": function(s:ns."codecs#_8859_5#import"),
      \ "iso-8859-6": function(s:ns."codecs#_8859_6#import"),
      \ "iso-8859-7": function(s:ns."codecs#_8859_7#import"),
      \ "iso-8859-8": function(s:ns."codecs#_8859_8#import"),
      \ "iso-8859-9": function(s:ns."codecs#_8859_9#import"),
      \ "iso-8859-10": function(s:ns."codecs#_8859_10#import"),
      \ "iso-8859-11": function(s:ns."codecs#_8859_11#import"),
      \ "iso-8859-13": function(s:ns."codecs#_8859_13#import"),
      \ "iso-8859-14": function(s:ns."codecs#_8859_14#import"),
      \ "iso-8859-15": function(s:ns."codecs#_8859_15#import"),
      \ "cp037": function(s:ns."codecs#_cp037#import"),
      \ "cp1026": function(s:ns."codecs#_cp1026#import"),
      \ "cp1250": function(s:ns."codecs#_cp1250#import"),
      \ "cp1251": function(s:ns."codecs#_cp1251#import"),
      \ "cp1252": function(s:ns."codecs#_cp1252#import"),
      \ "cp1253": function(s:ns."codecs#_cp1253#import"),
      \ "cp1254": function(s:ns."codecs#_cp1254#import"),
      \ "cp1255": function(s:ns."codecs#_cp1255#import"),
      \ "cp1256": function(s:ns."codecs#_cp1256#import"),
      \ "cp1257": function(s:ns."codecs#_cp1257#import"),
      \ "cp1258": function(s:ns."codecs#_cp1258#import"),
      \ "cp437": function(s:ns."codecs#_cp437#import"),
      \ "cp500": function(s:ns."codecs#_cp500#import"),
      \ "cp737": function(s:ns."codecs#_cp737#import"),
      \ "cp775": function(s:ns."codecs#_cp775#import"),
      \ "cp850": function(s:ns."codecs#_cp850#import"),
      \ "cp852": function(s:ns."codecs#_cp852#import"),
      \ "cp855": function(s:ns."codecs#_cp855#import"),
      \ "cp857": function(s:ns."codecs#_cp857#import"),
      \ "cp860": function(s:ns."codecs#_cp860#import"),
      \ "cp861": function(s:ns."codecs#_cp861#import"),
      \ "cp862": function(s:ns."codecs#_cp862#import"),
      \ "cp863": function(s:ns."codecs#_cp863#import"),
      \ "cp864": function(s:ns."codecs#_cp864#import"),
      \ "cp865": function(s:ns."codecs#_cp865#import"),
      \ "cp866": function(s:ns."codecs#_cp866#import"),
      \ "cp869": function(s:ns."codecs#_cp869#import"),
      \ "cp874": function(s:ns."codecs#_cp874#import"),
      \ "cp875": function(s:ns."codecs#_cp875#import"),
      \ "cp932": function(s:ns."codecs#_cp932#import"),
      \ "cp936": function(s:ns."codecs#_cp936#import"),
      \ "cp949": function(s:ns."codecs#_cp949#import"),
      \ "cp950": function(s:ns."codecs#_cp950#import"),
      \ "euc-jp": function(s:ns."codecs#_euc_jp#import"),
      \ }

function! SpaceVim#api#iconv#get()

  return deepcopy(s:self)

endfunction
