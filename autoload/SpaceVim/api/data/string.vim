let s:file = {}

function! s:trim(str) abort
  let str = substitute(a:str, '\s*$', '', 'g')
  return substitute(str, '^\s*', '', 'g')
endfunction

let s:file['trim'] = function('s:trim')

function! s:fill(str, length) abort
  if strwidth(a:str) <= a:length
    return a:str . repeat(' ', a:length - strwidth(a:str))
  else
    let l = 0
    for i in range(strchars(a:str) - 1)
      if strwidth(strcharpart(a:str, 0, i)) > a:length
        break
      else
        let l = i
      endif
    endfor
    let str = strcharpart(a:str, 0, l)
    return str . repeat(' ', a:length - strwidth(str))
  endif
endfunction

let s:file['fill'] = function('s:fill')

function! s:trim_start(str) abort
  return substitute(a:str, '^\s*', '', 'g')
endfunction

let s:file['trim_start'] = function('s:trim_start')

function! s:trim_end(str) abort
  return substitute(a:str, '\s*$', '', 'g')
endfunction

let s:file['trim_end'] = function('s:trim_end')

function! SpaceVim#api#data#string#get() abort
  return deepcopy(s:file)
endfunction

" vim:set et sw=2:
