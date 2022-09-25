" =============================================================================
" Filename: autoload/screensaver/source/largeclock.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/02/18 10:08:14.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! screensaver#source#largeclock#new() abort
  return deepcopy(s:self)
endfunction

let s:self = {}
let s:self.time = []
let s:self.timehm = []
let s:self.pixels = []
let s:self.pixelshm = []

function! s:self.start() dict abort
  let self.hl = screensaver#randomhighlight#new({ 'name': 'ScreenSaverClock' })
  call self.setline()
endfunction

function! s:self.redraw() dict abort
  if [self.h, self.w] != [winheight(0), winwidth(0)]
    call self.setline()
  endif
  call self.hl.highlight()
  let [h, m, s] = screensaver#util#time()
  if self.time == [h, m, s]
    return
  else
    let self.time = [h, m, s]
    if self.timehm != [h, m]
      let self.timehm = [h, m]
      let self.pixelshm = screensaver#pixel#getstr(printf('%d:%02d:', h, m))
    endif
    let pixels = screensaver#pixel#getstr(printf('%02d', s), self.pixelshm)
    let self.pixels = pixels
    let self.pixelswidth = screensaver#util#sum(pixels[0])
  endif
  let a = max([1, min([winheight(0) * 3 / 4 / 5, winwidth(0) / 62])])
  let x = max([1, (winheight(0) + 1 - 5 * a) / 2])
  let y = max([1, (winwidth(0) - self.pixelswidth * a) / 2])
  let c = 'syntax match ScreenSaverClock /\%>'
  silent! syntax clear ScreenSaverClock
  for i in range(5)
    let [n, p, l] = [y, pixels[i], (len(pixels[i]) - 1) / 2]
    for j in range(l)
      let n += p[2 * j] * a
      exec c . (x + i * a - 1) . 'l\%<' . (x + i * a + a) . 'l\%' . n . 'c.*\%' . (n + p[2 * j + 1] * a) . 'c/'
      let n += p[2 * j + 1] * a
    endfor
  endfor
endfunction

function! s:self.setline() dict abort
  let [self.h, self.w] = [winheight(0), winwidth(0)]
  call setline(1, repeat([repeat(' ', winwidth(0))], winheight(0)))
endfunction

function! s:self.end() dict abort
  silent! syntax clear ScreenSaverClock
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
