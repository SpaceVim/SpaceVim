" Vim library for short description
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" 		Israel Chauca F. <israelchauca@gmail.com>
" Version:	0.1
" Description:	Long description.
" Last Change:	2013-02-03
" License:	Vim License (see :help license)
" Location:	autoload/extended_regex.vim
" Website:	https://github.com/Raimondi/extended_regex
"
" See extended_regex.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help extended_regex

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" load guard
" uncomment after plugin development
" Remove the conditions you do not need, they are there just as an example.
"if exists("g:loaded_lib_extended_regex")
"      \ || v:version < 700
"      \ || v:version == 703 && !has('patch338')
"      \ || &compatible
"  let &cpo = s:save_cpo
"  finish
"endif
"let g:loaded_lib_extended_regex = 1

" Private Functions: {{{1

" Library Interface: {{{1

function! extended_regex#ExtendedRegex(...)
  let erex = {}
  let erex.lookup_function = ''
  let erex.lookup_dict = {}

  func erex.default_lookup(name) dict
    return eval(a:name)
  endfunc

  "TODO: revisit this with eval() solution
  func erex.lookup(name) dict
    if empty(self.lookup_function)
      return call(self.default_lookup, [a:name], self)
    else
      "TODO: this 'self' dict arg needs to be the object's self...
      return call(self.lookup_function, [a:name], self.lookup_dict)
    endif
  endfunc

  func erex.expand_composition_atom(ext_reg) dict
    let ext_reg = a:ext_reg
    let composition_atom = '\\%{\s*\([^,} \t]\+\)\%(\s*,\s*\(\d\+\)\%(\s*,\s*\(.\{-}\)\)\?\)\?\s*}'
    let remaining = match(ext_reg, composition_atom)
    while remaining != -1
      let [_, name, cnt, sep ;__] = matchlist(ext_reg, composition_atom)
      let cnt = cnt ? cnt : 1
      let sep = escape(escape(sep, '.*[]$^'), '\\')
      let pattern = escape(self.lookup(name), '\\' )
      let ext_reg = substitute(ext_reg, composition_atom, join(repeat([pattern], cnt), sep), '')
      let remaining = match(ext_reg, composition_atom)
    endwhile
    return ext_reg
  endfunc

  func erex.expand(ext_reg) dict
    return self.expand_composition_atom(a:ext_reg)
  endfunc

  func erex.parse_multiline_regex(ext_reg) dict
    return substitute(substitute(substitute(a:ext_reg, '#\s\+\S\+', '', 'g'), '\\\@<! ', '', 'g'), '\(\\\\\)\@<=\zs\s\+', '', 'g')
  endfunc

  " common public API

  func erex.register_lookup(callback) dict
    let self.lookup_function = a:callback
  endfunc

  func erex.register_lookup_dict(dict) dict
    let self.lookup_dict = a:dict
  endfunc

  func erex.parse(ext_reg) dict
    return self.expand(self.parse_multiline_regex(a:ext_reg))
  endfunc

  if a:0
    call erex.register_lookup(a:1)
    if a:0 > 1
      call erex.register_lookup_dict(a:2)
    endif
  endif

  return erex
endfunction
" Teardown:{{{1
"reset &cpo back to users setting
let &cpo = s:save_cpo

" vim: set sw=2 sts=2 et fdm=marker:
