
let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:error
endfunction

let s:error = {}

function s:error.handle(errors, exception, object, start, end)
  if !has_key(self, a:errors)
    throw printf("unknown errors: %s", a:errors)
  endif
  return call(self[a:errors], [a:exception, a:object, a:start, a:end], self)
endfunction

function s:error.strict(exception, object, start, end)
  throw a:exception
endfunction

function s:error.ignore(exception, object, start, end)
  if a:exception =~ '^UnicodeDecodeError:'
    return [[], a:end + 1]
  elseif a:exception =~ '^UnicodeEncodeError:'
    return [[], a:end + 1]
  else
    throw printf("error.ignore: can't handle error: %s", exception)
  endif
endfunction

function s:error.replace(exception, object, start, end)
  if a:exception =~ '^UnicodeDecodeError:'
    let out = map(a:object[a:start : a:end], 'char2nr("?")')
    return [out, a:end + 1]
  elseif a:exception =~ '^UnicodeEncodeError:'
    let out = map(a:object[a:start : a:end], 'char2nr("?")')
    return [out, a:end + 1]
  else
    throw printf("error.replace: can't handle error: %s", exception)
  endif
endfunction

function s:error.backslashreplace(exception, object, start, end)
  if a:exception =~ '^UnicodeDecodeError:'
    let out = []
    for x in a:object[a:start : a:end]
      let s = printf('\x%02x', x)
      call extend(out, map(range(len(s)), 'char2nr(s[v:val])'))
    endfor
    return [out, a:end + 1]
  elseif a:exception =~ '^UnicodeEncodeError:'
    let out = []
    for x in a:object[a:start : a:end]
      if x < 0x10000
        let s = printf('\u%04x', x)
      else
        let s = printf('\U%08x', x)
      endif
      call extend(out, map(range(len(s)), 'char2nr(s[v:val])'))
    endfor
    return [out, a:end + 1]
  else
    throw printf("error.backslashreplace: can't handle error: %s", exception)
  endif
endfunction

