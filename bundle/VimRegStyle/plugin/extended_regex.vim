function! ExtendedRegexObject(...)
  return call('extended_regex#ExtendedRegex', a:000)
endfunction

" ERex is a global object with access to Vim's vars:
let ERex = ExtendedRegexObject()
