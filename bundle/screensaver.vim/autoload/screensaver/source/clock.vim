" =============================================================================
" Filename: autoload/screensaver/source/clock.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/02/18 10:08:00.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! screensaver#source#clock#new() abort
  return deepcopy(s:self)
endfunction

let s:self = {}
let s:self.time = []
let s:self.timehm = []
let s:self.pixels = []
let s:self.pixelshm = []

function! s:self.start() dict abort
  let [h, w] = [winheight(0) / 4 + 1, (winwidth(0) - 50) / 4 + 1]
  let self.i = max([1, min([max([0, winheight(0) - 5]), screensaver#random#number() % (h * 2) + h])])
  let self.j = max([1, (screensaver#random#number()) % (w * 2) + w])
  let self.di = (screensaver#random#number() % 2) * 2 - 1
  let self.dj = (screensaver#random#number() % 2) * 4 - 2
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
    let pixels = self.pixels
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
  let c = 'syntax match ScreenSaverClock /\%'
  silent! syntax clear ScreenSaverClock
  for i in range(5)
    let [k, p, l] = [self.j, pixels[i], (len(pixels[i]) - 1) / 2]
    for j in range(l)
      let k += p[2 * j]
      exec c . (self.i + i) . 'l\%' . k . 'c.*\%' . (k + p[2 * j + 1]) . 'c/'
      let k += p[2 * j + 1]
    endfor
  endfor
  call self.move()
endfunction

function! s:self.setline() dict abort
  let [self.h, self.w] = [winheight(0), winwidth(0)]
  call setline(1, repeat([repeat(' ', winwidth(0))], winheight(0)))
endfunction

function! s:self.move() dict abort
  let self.i += self.di
  let self.j += self.dj
  if self.di > 0 && self.i + 4 > winheight(0) || self.di < 0 && self.i <= 1
    let self.di = - self.di
    let self.i += self.di * 2
  endif
  if self.dj > 0 && self.j + self.pixelswidth > winwidth(0) || self.dj < 0 && self.j <= 2
    let self.dj = - self.dj
    let self.j += self.dj * 2
  endif
endfunction

function! s:self.end() dict abort
  silent! syntax clear ScreenSaverClock
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
