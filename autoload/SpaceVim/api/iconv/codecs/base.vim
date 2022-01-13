function! SpaceVim#api#iconv#codecs#base#import() abort
  return s:base
endfunction

let s:error = SpaceVim#api#iconv#codecs#error#import()

let s:base = {}

let s:base.Codec = {}
let s:base.Codec.encoding = ''
let s:base.Codec.errors = ''

function! s:base.Codec.new() abort
  let obj = copy(self)
  call obj.__init__()
  return obj
endfunction

function! s:base.Codec.__init__() abort
  " pass
endfunction

function! s:base.Codec.decode(input, errors) abort
  let self.errors = a:errors
  let out = []
  let i = 0
  while i < len(a:input)
    let [buf, i] = self.mbtowc(a:input, i)
    call extend(out, buf)
  endwhile
  return out
endfunction

function! s:base.Codec.mbtowc(input, start) abort
  throw 'NotImplemented'
endfunction

function! s:base.Codec.encode(input, errors) abort
  let self.errors = a:errors
  let out = []
  let i = 0
  while i < len(a:input)
    let [buf, i] = self.wctomb(a:input, i)
    call extend(out, buf)
  endwhile
  return out
endfunction

function! s:base.Codec.wctomb(input, start) abort
  throw 'NotImplemented'
endfunction

function! s:base.Codec.error(class, reason, object, start, end) abort
  if a:class ==# 'UnicodeDecodeError'
    let exception = printf("%s: '%s' codec can't decode bytes in position %d-%d: %s", a:class, self.encoding, a:start, a:end, a:reason)
  elseif a:class ==# 'UnicodeEncodeError'
    let exception = printf("%s: '%s' codec can't encode character in position %d-%d: %s", a:class, self.encoding, a:start, a:end, a:reason)
  else
    throw printf('unknown class: %s', a:class)
  endif
  return s:error.handle(self.errors, exception, a:object, a:start, a:end)
endfunction

