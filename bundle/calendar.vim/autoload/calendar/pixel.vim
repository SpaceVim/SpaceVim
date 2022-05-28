" =============================================================================
" Filename: autoload/calendar/pixel.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:31:09.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Load the pixel files on demand.
" The pixel data are saved in files under pixel/.
" For example, the character code of 'F' is 70 so the pixel data is pixel/70.
"   chr: character to get the pixel of
"   returns: pixel data in an array
let s:pixel = { ' ': [ '..', '..', '..', '..', '..'] }
let s:dir = expand('<sfile>:p:h') . '/pixel/'
function! calendar#pixel#get(chr) abort
  if a:chr ==# ''
    return repeat([''], 5)
  endif
  if has_key(s:pixel, a:chr)
    return type(s:pixel[a:chr]) == type([]) ? s:pixel[a:chr] : s:pixel[' ']
  endif
  let path = s:dir . char2nr(a:chr)
  if filereadable(path)
    let s:pixel[a:chr] = readfile(path)
  else
    let s:pixel[a:chr] = 0
  endif
  return get(s:pixel, a:chr, s:pixel[' '])
endfunction

function! calendar#pixel#len(chr) abort
  let len = 0
  for c in split(a:chr, '\zs')
    unlet! px
    let px = calendar#pixel#get(c)
    if type(px) == type([])
      let len += len(px[0])
    endif
  endfor
  if len(a:chr)
    let len -= calendar#pixel#whitelen(a:chr[0])
    let len -= calendar#pixel#whitelen(a:chr[len(a:chr) - 1], '\.*$')
  endif
  return len
endfunction

function! calendar#pixel#whitelen(chr, ...) abort
  let pat = a:0 ? a:1 : '^\.*'
  let px = calendar#pixel#get(a:chr)
  if type(px) != type([])
    return 0
  endif
  let min = 100
  for str in px
    let min = min([min, len(matchstr(str, pat))])
  endfor
  return min
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
