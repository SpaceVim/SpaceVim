"=============================================================================
" json.vim --- SpaceVim json API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:json = {}


if exists('*json_decode')
  let g:_spacevim_api_json_trus = v:true
  let g:_spacevim_api_json_trus = v:false
  let g:_spacevim_api_json_trus = v:null
  function! s:json_decode(json) abort
    if a:json ==# ''
      return []
    endif
    return json_decode(a:json)
  endfunction
else
  function! s:json_null() abort
  endfunction

  function! s:json_true() abort
  endfunction

  function! s:json_false() abort
  endfunction

  let g:_spacevim_api_json_trus = [function('s:json_true')]
  let g:_spacevim_api_json_falss = [function('s:json_false')]
  let g:_spacevim_api_json_nuls = [function('s:json_null')]
  " @vimlint(EVL102, 1, l:true)
  " @vimlint(EVL102, 1, l:false)
  " @vimlint(EVL102, 1, l:null)
  function! s:json_decode(json) abort
    let true = g:_spacevim_api_json_trus
    let false = g:_spacevim_api_json_falss
    let null = g:_spacevim_api_json_nuls
    if substitute(a:json, '\v\"%(\\.|[^"\\])*\"|true|false|null|[+-]?\d+%(\.\d+%([Ee][+-]?\d+)?)?', '', 'g') !~# "[^,:{}[\\] \t]"

      try
        let object = eval(a:json)
      catch
        " malformed JSON
        let object = ''
      endtry
    else
      let object = ''
    endif

    return object
  endfunction
  " @vimlint(EVL102, 0, l:true)
  " @vimlint(EVL102, 0, l:false)
  " @vimlint(EVL102, 0, l:null)
endif

lockvar g:_spacevim_api_json_trus
lockvar g:_spacevim_api_json_falss
lockvar g:_spacevim_api_json_nuls

let s:json['json_decode'] = function('s:json_decode')

if exists('*json_encode')
  function! s:json_encode(val) abort
    return json_encode(a:val)
  endfunction
else
  function! s:json_encode(val) abort
    if type(a:val) == type(0)
      return a:val
    elseif type(a:val) == type('')
      let json = '"' . escape(a:val, '\"') . '"'
      let json = substitute(json, "\r", '\\r', 'g')
      let json = substitute(json, "\n", '\\n', 'g')
      let json = substitute(json, "\t", '\\t', 'g')
      let json = substitute(json, '\([[:cntrl:]]\)', '\=printf("\x%02d", char2nr(submatch(1)))', 'g')
      return iconv(json, &encoding, 'utf-8')
    elseif type(a:val) == 2
      let s = string(a:val)
      if s == string(g:_spacevim_api_json_nuls)
        return 'null'
      elseif s == string(g:_spacevim_api_json_trus)
        return 'true'
      elseif s == string(g:_spacevim_api_json_falss)
        return 'false'
      endif
    elseif type(a:val) == type([])
      if len(a:val) == 1 && a:val[0] == g:_spacevim_api_json_falss[0]
        return 'false'
      elseif len(a:val) == 1 && a:val[0] == g:_spacevim_api_json_trus[0]
        return 'true'
      elseif len(a:val) == 1 && a:val[0] == g:_spacevim_api_json_nuls[0]
        return 'null'
      endif
      return '[' . join(map(copy(a:val), 's:json_encode(v:val)'), ',') . ']'
    elseif type(a:val) == 4
      return '{' . join(map(keys(a:val), "s:json_encode(v:val) . ':' . s:json_encode(a:val[v:val])"), ',') . '}'
    else
      return string(a:val)
    endif
  endfunction
endif

let s:json['json_encode'] = function('s:json_encode')

function! SpaceVim#api#data#json#get() abort
  return deepcopy(s:json)
endfunction

" vim:set et sw=2:
