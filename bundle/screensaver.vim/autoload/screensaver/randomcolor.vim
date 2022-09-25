" =============================================================================
" Filename: autoload/screensaver/randomcolor.vim
" Author: itchyny
" License: MIT License
" Last Change: 2017/04/09 22:46:34.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! screensaver#randomcolor#new() abort
  let self = deepcopy(s:self)
  let m = s:hlcolormax / 4
  let self.colornum = [ screensaver#random#number() % (m * 2) + m,
                      \ screensaver#random#number() % (m * 2) + m,
                      \ screensaver#random#number() % (m * 2) + m]
  let self.index = screensaver#random#number() % 3
  return self
endfunction

let s:self = {}
let s:self.time = -1

let s:gui = has('gui_running') || (has('termguicolors') && &termguicolors)
if s:gui
  let s:hlcolormax = 0xff
  let s:colordiff = 0x06
  let s:updatetime = 48
else
  let s:hlcolormax = 6
  let s:colordiff = 1
  let s:updatetime = 6
endif

let s:is_win32cui = (has('win32') || has('win64')) && !s:gui

if s:is_win32cui
  function! s:self.next() dict abort
    let self.time = (get(self, 'time') + 1) % 720
    if self.time % s:updatetime == 0
      let self.hlnumwin32 = screensaver#random#number(1, 14)
    endif
  endfunction
else
  function! s:self.next() dict abort
    let self.time = (get(self, 'time') + 1) % 720
    if self.time % s:updatetime == 0
      let self.index = screensaver#random#number() % 3
    endif
    let n = self.colornum[self.index]
    if self.time % s:updatetime == 0 || !has_key(self, 'diff')
      let self.diff = (n == 0 ? 1 : n == s:hlcolormax - 1 ? -1 : ((screensaver#random#number() % 2) * 2 - 1) * s:colordiff)
    endif
    if n + self.diff < 0 || n + self.diff > s:hlcolormax - 1
      let self.diff = - self.diff
    endif
    let n += self.diff
    let self.colornum[self.index] = n
    let sum = screensaver#util#sum(self.colornum)
    if sum <= s:colordiff * 3 * (1 + s:gui) || (s:hlcolormax - s:colordiff) * 3 * (1 + s:gui) <= sum
      let self.diff = - self.diff
      let self.colornum[self.index] += self.diff * 2
    endif
  endfunction
endif

if s:is_win32cui
  function! s:self.get() dict abort
    return self.hlnumwin32
  endfunction
elseif s:gui
  function! s:self.get() dict abort
    return printf('#%02x%02x%02x', self.colornum[0], self.colornum[1], self.colornum[2])
  endfunction
else
  function! s:self.get() dict abort
    return self.colornum[0] * 36 + self.colornum[1] * 6 + self.colornum[2] + 16
  endfunction
endif

let &cpo = s:save_cpo
unlet s:save_cpo
