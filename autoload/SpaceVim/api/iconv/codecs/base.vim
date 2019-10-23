
let s:nsiconv = expand('<sfile>:p:h:h:gs?[\\/]?#?:s?^.*#autoload\(#\|$\)??:s?$?#?')
let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:base
endfunction

let s:error = {s:nsiconv}codecs#error#import()

let s:base = {}

let s:base.Codec = {}
let s:base.Codec.encoding = ""
let s:base.Codec.errors = ""

function s:base.Codec.new()
  let obj = copy(self)
  call obj.__init__()
  return obj
endfunction

function s:base.Codec.__init__()
  " pass
endfunction

function s:base.Codec.decode(input, errors)
  let self.errors = a:errors
  let out = []
  let i = 0
  while i < len(a:input)
    let [buf, i] = self.mbtowc(a:input, i)
    call extend(out, buf)
  endwhile
  return out
endfunction

function s:base.Codec.mbtowc(input, start)
  throw "NotImplemented"
endfunction

function s:base.Codec.encode(input, errors)
  let self.errors = a:errors
  let out = []
  let i = 0
  while i < len(a:input)
    let [buf, i] = self.wctomb(a:input, i)
    call extend(out, buf)
  endwhile
  return out
endfunction

function s:base.Codec.wctomb(input, start)
  throw "NotImplemented"
endfunction

function s:base.Codec.error(class, reason, object, start, end)
  if a:class == 'UnicodeDecodeError'
    let exception = printf("%s: '%s' codec can't decode bytes in position %d-%d: %s", a:class, self.encoding, a:start, a:end, a:reason)
  elseif a:class == 'UnicodeEncodeError'
    let exception = printf("%s: '%s' codec can't encode character in position %d-%d: %s", a:class, self.encoding, a:start, a:end, a:reason)
  else
    throw printf("unknown class: %s", a:class)
  endif
  return s:error.handle(self.errors, exception, a:object, a:start, a:end)
endfunction

