"=============================================================================
" json.vim --- SpaceVim json API
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}
let s:self._vim = SpaceVim#api#import('vim')
let s:self._iconv = SpaceVim#api#import('iconv') 

function! s:self._json_null() abort
  return 0
endfunction

function! s:self._json_true() abort
  return 1
endfunction

function! s:self._json_false() abort
  return 0
endfunction

if exists('*json_decode')
  function! s:self.json_decode(json) abort
    if a:json ==# ''
      " instead of throw error, if json is empty string, just return an empty
      " string
      return ''
    endif
    return json_decode(a:json)
  endfunction
else

  function! s:self._fixvar(val) abort
    if self._vim.is_number(a:val)
          \ || self._vim.is_string(a:val)
          \ || empty(a:val)
      return a:val
    elseif self._vim.is_list(a:val) && len(a:val) ==# 1
      if string(a:val[0]) == string(self._json_true)
        return get(v:, 'true', 1)
      elseif string(a:val[0]) ==# string(self._json_false)
        return get(v:, 'false', 0)
      elseif string(a:val[0]) ==# string(self._json_null)
        return get(v:, 'null', 0)
      else
        return a:val
      endif
    elseif self._vim.is_list(a:val) && len(a:val) > 1
      return map(a:val, 'self._fixvar(v:val)')
    elseif self._vim.is_dict(a:val)
      return map(a:val, 'self._fixvar(v:val)')
    endif
  endfunction
  " @vimlint(EVL102, 1, l:true)
  " @vimlint(EVL102, 1, l:false)
  " @vimlint(EVL102, 1, l:null)
  function! s:self.json_decode(json) abort
    let true = [self._json_true]
    let false = [self._json_false]
    let null = [self._json_null]
    " we need to remove \n, because eval() do not work
    let json = join(split(a:json, "\n"), '')
    try
      let object = eval(json)
    catch
      let object = ''
    endtry
    call self._fixvar(object)
    return object
  endfunction
  " @vimlint(EVL102, 0, l:true)
  " @vimlint(EVL102, 0, l:false)
  " @vimlint(EVL102, 0, l:null)
endif

if exists('*json_encode')
  function! s:self.json_encode(val) abort
    return json_encode(a:val)
  endfunction
else
  function! s:self.json_encode(val) abort
    if type(a:val) == type(0)
      return a:val
    elseif type(a:val) == type('')
      let json = '"' . escape(a:val, '\"') . '"'
      let json = substitute(json, "\r", '\\r', 'g')
      let json = substitute(json, "\n", '\\n', 'g')
      let json = substitute(json, "\t", '\\t', 'g')
      let json = substitute(json, '\([[:cntrl:]]\)', '\=printf("\x%02d", char2nr(submatch(1)))', 'g')
      return self._iconv.iconv(json, &encoding, 'utf-8')
    elseif self._vim.is_func(a:val)
      let s = string(a:val)
      if s ==# string(self._json_null)
        return 'null'
      elseif s ==# string(self._json_true)
        return 'true'
      elseif s ==# string(self._json_false)
        return 'false'
      endif
    elseif self._vim.is_list(a:val)
      return '[' . join(map(copy(a:val), 'self.json_encode(v:val)'), ',') . ']'
    elseif self._vim.is_dict(a:val)
      return '{' . join(map(keys(a:val), "self.json_encode(v:val) . ':' . self.json_encode(a:val[v:val])"), ',') . '}'
    else
      return string(a:val)
    endif
  endfunction
endif

function! SpaceVim#api#data#json#get() abort
  return deepcopy(s:self)
endfunction

" vim:set et sw=2:
