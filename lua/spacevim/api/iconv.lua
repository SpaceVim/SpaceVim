local M = {}
local has = require('spacevim').has
local fn = require('spacevim').fn

if has('iconv') == 1 and has('nvim') == 0 then
    function M.iconv(str, from, to)
        return fn.iconv(str, from, to)   
    end
else
    function M.iconv(str, from, to)
        return iconv.iconv(str, from, to, 'strict')   
    end
end

function M.import()
    return iconv
end

function M.iconv(expr, from, to, ...)
    local argvs = ...
    local errors = 'strict'
    if argvs ~= nil then
        errors = argvs[1]
    end
    return iconv.iconv(expr, from, to, errors)
end





function! SpaceVim#api#iconv#iconvb(expr, from, to, ...) abort
  let errors = get(a:000, 0, 'strict')
  try
    return s:iconv.iconvb(a:expr, a:from, a:to, errors)
  endtry
endfunction

let s:bytes = SpaceVim#api#iconv#bytes#import()

let s:iconv = {}

function! s:iconv.iconv(expr, from, to, errors) abort
  return s:bytes.bytes2str(self.iconvb(a:expr, a:from, a:to, a:errors))
endfunction

function! s:iconv.iconvb(expr, from, to, errors) abort
  let expr = s:bytes.tobytes(a:expr)
  return self._iconv(expr, a:from, a:to, a:errors)
endfunction

function! s:iconv._iconv(expr, from, to, errors) abort
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
      \ 'ascii': function('SpaceVim#api#iconv#codecs#ascii#import'),
      \ 'utf-8': function('SpaceVim#api#iconv#codecs#utf8#import'),
      \ 'utf-16': function('SpaceVim#api#iconv#codecs#utf16#import'),
      \ 'utf-16be': function('SpaceVim#api#iconv#codecs#utf16be#import'),
      \ 'utf-16le': function('SpaceVim#api#iconv#codecs#utf16le#import'),
      \ 'utf-32': function('SpaceVim#api#iconv#codecs#utf32#import'),
      \ 'utf-32be': function('SpaceVim#api#iconv#codecs#utf32be#import'),
      \ 'utf-32le': function('SpaceVim#api#iconv#codecs#utf32le#import'),
      \ 'latin1': function('SpaceVim#api#iconv#codecs#_8859_1#import'),
      \ 'iso-8859-1': function('SpaceVim#api#iconv#codecs#_8859_1#import'),
      \ 'iso-8859-2': function('SpaceVim#api#iconv#codecs#_8859_2#import'),
      \ 'iso-8859-3': function('SpaceVim#api#iconv#codecs#_8859_3#import'),
      \ 'iso-8859-4': function('SpaceVim#api#iconv#codecs#_8859_4#import'),
      \ 'iso-8859-5': function('SpaceVim#api#iconv#codecs#_8859_5#import'),
      \ 'iso-8859-6': function('SpaceVim#api#iconv#codecs#_8859_6#import'),
      \ 'iso-8859-7': function('SpaceVim#api#iconv#codecs#_8859_7#import'),
      \ 'iso-8859-8': function('SpaceVim#api#iconv#codecs#_8859_8#import'),
      \ 'iso-8859-9': function('SpaceVim#api#iconv#codecs#_8859_9#import'),
      \ 'iso-8859-10': function('SpaceVim#api#iconv#codecs#_8859_10#import'),
      \ 'iso-8859-11': function('SpaceVim#api#iconv#codecs#_8859_11#import'),
      \ 'iso-8859-13': function('SpaceVim#api#iconv#codecs#_8859_13#import'),
      \ 'iso-8859-14': function('SpaceVim#api#iconv#codecs#_8859_14#import'),
      \ 'iso-8859-15': function('SpaceVim#api#iconv#codecs#_8859_15#import'),
      \ 'cp037': function('SpaceVim#api#iconv#codecs#_cp037#import'),
      \ 'cp1026': function('SpaceVim#api#iconv#codecs#_cp1026#import'),
      \ 'cp1250': function('SpaceVim#api#iconv#codecs#_cp1250#import'),
      \ 'cp1251': function('SpaceVim#api#iconv#codecs#_cp1251#import'),
      \ 'cp1252': function('SpaceVim#api#iconv#codecs#_cp1252#import'),
      \ 'cp1253': function('SpaceVim#api#iconv#codecs#_cp1253#import'),
      \ 'cp1254': function('SpaceVim#api#iconv#codecs#_cp1254#import'),
      \ 'cp1255': function('SpaceVim#api#iconv#codecs#_cp1255#import'),
      \ 'cp1256': function('SpaceVim#api#iconv#codecs#_cp1256#import'),
      \ 'cp1257': function('SpaceVim#api#iconv#codecs#_cp1257#import'),
      \ 'cp1258': function('SpaceVim#api#iconv#codecs#_cp1258#import'),
      \ 'cp437': function('SpaceVim#api#iconv#codecs#_cp437#import'),
      \ 'cp500': function('SpaceVim#api#iconv#codecs#_cp500#import'),
      \ 'cp737': function('SpaceVim#api#iconv#codecs#_cp737#import'),
      \ 'cp775': function('SpaceVim#api#iconv#codecs#_cp775#import'),
      \ 'cp850': function('SpaceVim#api#iconv#codecs#_cp850#import'),
      \ 'cp852': function('SpaceVim#api#iconv#codecs#_cp852#import'),
      \ 'cp855': function('SpaceVim#api#iconv#codecs#_cp855#import'),
      \ 'cp857': function('SpaceVim#api#iconv#codecs#_cp857#import'),
      \ 'cp860': function('SpaceVim#api#iconv#codecs#_cp860#import'),
      \ 'cp861': function('SpaceVim#api#iconv#codecs#_cp861#import'),
      \ 'cp862': function('SpaceVim#api#iconv#codecs#_cp862#import'),
      \ 'cp863': function('SpaceVim#api#iconv#codecs#_cp863#import'),
      \ 'cp864': function('SpaceVim#api#iconv#codecs#_cp864#import'),
      \ 'cp865': function('SpaceVim#api#iconv#codecs#_cp865#import'),
      \ 'cp866': function('SpaceVim#api#iconv#codecs#_cp866#import'),
      \ 'cp869': function('SpaceVim#api#iconv#codecs#_cp869#import'),
      \ 'cp874': function('SpaceVim#api#iconv#codecs#_cp874#import'),
      \ 'cp875': function('SpaceVim#api#iconv#codecs#_cp875#import'),
      \ 'cp932': function('SpaceVim#api#iconv#codecs#_cp932#import'),
      \ 'cp936': function('SpaceVim#api#iconv#codecs#_cp936#import'),
      \ 'cp949': function('SpaceVim#api#iconv#codecs#_cp949#import'),
      \ 'cp950': function('SpaceVim#api#iconv#codecs#_cp950#import'),
      \ 'euc-jp': function('SpaceVim#api#iconv#codecs#_euc_jp#import'),
      \ }

function! SpaceVim#api#iconv#get() abort

  return deepcopy(s:self)

endfunction
