" =============================================================================
" Filename: autoload/calendar/cipher.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:25:35.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Caesar cipher functions.
" This DOES NOT encrypt a message into a code difficult to revive the
" original message. This module is used for the client id and api key of
" the default google client in setting.vim, because I don't want to save
" the keys in raw strings, which can be extracted easily.
" Reference: http://en.wikipedia.org/wiki/Caesar_cipher

function! calendar#cipher#cipher(val, num) abort
  if type(a:val) == type('')
    return s:cipher(a:val, a:num)
  elseif type(a:val) == type(0)
    return s:cipher(a:val . '', a:num)
  elseif type(a:val) == type([])
    return map(a:val, 'calendar#cipher#cipher(v:val, a:num)')
  elseif type(a:val) == type({})
    let ret = {}
    for key in keys(a:val)
      let ret[key] = calendar#cipher#cipher(a:val[key], a:num)
    endfor
    return ret
  endif
endfunction

function! calendar#cipher#decipher(val, num) abort
  return calendar#cipher#cipher(a:val, - a:num)
endfunction

function! s:cipher(str, num) abort
  let ret = ''
  let r = range(len(a:str))
  for i in r
    let nr = char2nr(a:str[i])
    if 32 <= nr && nr < 127
      let nr = nr + a:num - 32
      while nr < 0
        let nr += 127 - 32
      endwhile
      let nr = nr % (127 - 32) + 32
      let ret .= nr2char(nr)
    else
      return ''
    endif
  endfor
  return ret
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
