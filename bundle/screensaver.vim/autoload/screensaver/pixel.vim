" =============================================================================
" Filename: autoload/screensaver/pixel.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/02/18 10:07:42.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Load the pixel files on demand.
" The pixel data are saved in files under pixel/.
" For example, the character code of 'F' is 70 so the pixel data is pixel/70.
"   chr: character to get the pixel of
"   returns: pixel data in an array
let s:pixel = { ' ': [ [2], [2], [2], [2], [2] ] }
let s:dir = expand('<sfile>:p:h') . '/pixel/'
function! screensaver#pixel#get(chr) abort
  if a:chr ==# ''
    return repeat([''], 5)
  endif
  if has_key(s:pixel, a:chr)
    return type(s:pixel[a:chr]) == type([]) ? s:pixel[a:chr] : s:pixel[' ']
  endif
  let path = s:dir . char2nr(a:chr)
  if filereadable(path)
    let px = readfile(path)
    let pixel = []
    for i in range(len(px))
      call add(pixel, [])
      let c = '.'
      let n = 0
      for j in range(len(px[i]))
        if px[i][j] ==# c
          let n += 1
        else
          call add(pixel[i], n)
          let c = px[i][j]
          let n = 1
        endif
      endfor
      call add(pixel[i], n)
      if c !=# '.'
      call add(pixel[i], 0)
      endif
    endfor
  else
    let pixel = [ [0], [0], [0], [0], [0] ]
  endif
  let s:pixel[a:chr] = pixel
  return get(s:pixel, a:chr, s:pixel[' '])
endfunction

function! screensaver#pixel#getstr(str, ...) abort
  let pixels = a:0 ? deepcopy(a:1) : [ [0], [0], [0], [0], [0] ]
  if a:str ==# ''
    return pixels
  endif
  for i in range(len(a:str))
    let newpixels = screensaver#pixel#get(a:str[i])
    for j in range(5)
      let pixels[j] = pixels[j][:-2] + [pixels[j][-1] + 2 + newpixels[j][0]] + newpixels[j][1:]
    endfor
  endfor
  let m = min(map(range(5), 'pixels[v:val][0]'))
  for j in range(5)
    let pixels[j][0] -= m
  endfor
  return pixels
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
