" =============================================================================
" Filename: autoload/screensaver/source/password.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/02/18 10:08:31.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! screensaver#source#password#new() abort
  return deepcopy(s:self)
endfunction

function! screensaver#source#password#set(password) abort
  if s:set_password
    call screensaver#util#error('[screensaver] The password is already set. You cannot change the password.')
    return
  endif
  if !exists('*sha256')
    call screensaver#util#error('[screensaver] This Vim does not support sha256 function. You cannot use the password feature.')
    return
  endif
  let s:set_password = 1
  let s:self.password = a:password
endfunction

if exists('*sha256')
  function! s:sha256(str) abort
    return sha256(a:str)
  endfunction
else
  function! s:sha256(str) abort
    return a:str
  endfunction
endif

let s:self = {}
let s:self.password = s:sha256('')
let s:self.input = ''
let s:set_password = 0

function! s:self.start() dict abort
  let save_cpo = &cpo
  set cpo&vim
  call b:screensaver.restorecursor()
  set updatetime=40                " b:screensaver restores the option.
  call setline(1, repeat([''], winheight(0)))
  for c in range(32) + range(127, 255)
    exec 'nnoremap <buffer> <Char-' . c . '> <Nop>'
    exec 'nnoremap <buffer> <S-Char-' . c . '> <Nop>'
    exec 'nnoremap <buffer> <C-Char-' . c . '> <Nop>'
  endfor
  let cs = [ 'Left', 'Right', 'Up', 'Down', 'Help',
           \ 'Home', 'End', 'Del', 'PageUp', 'PageDown', 'Bar', 'Insert', 'Mouse',
           \ 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12',
           \ ]
  for c in cs
    exec 'nnoremap <buffer> <' . c . '> <Nop>'
    exec 'nnoremap <buffer> <C-' . c . '> <Nop>'
    exec 'nnoremap <buffer> <S-' . c . '> <Nop>'
  endfor
  for c in range(32, 126)
    exec 'nnoremap <silent><buffer> <Char-' . c . '> :<C-u>silent! call b:screensaver.source.inputchar(' . c . ')<Cr>'
    exec 'nnoremap <silent><buffer> <C-Char-' . c . '> <Nop>'
  endfor
  for c in ['<C-c>', '<C-d>', '<C-u>', '<C-w>']
    exec 'nnoremap <silent><buffer> ' . c . ' :<C-u>silent! call b:screensaver.source.clear()<Cr>'
  endfor
  for c in ['<Bs>', '<Del>', '<Undo>']
    exec 'nnoremap <silent><buffer> ' . c . ' :<C-u>silent! call b:screensaver.source.backspace()<Cr>'
  endfor
  for c in ['<Esc>']
    exec 'nnoremap <silent><buffer> ' . c . ' :<C-u>silent! call b:screensaver.previous()<Cr>'
  endfor
  for c in ['<Cr>']
    exec 'nnoremap <silent><buffer> ' . c . ' :<C-u>silent! call b:screensaver.source.enter()<Cr>'
  endfor
  let &cpo = save_cpo
endfunction

function! s:self.inputchar(c) dict abort
  let self.input .= nr2char(a:c)
endfunction

function! s:self.clear() dict abort
  let self.input = ''
  call b:screensaver.redraw()
endfunction

function! s:self.backspace() dict abort
  let self.input = self.input[:-2]
endfunction

function! s:self.enter() dict abort
  if self.password ==# s:sha256(self.input)
    call b:screensaver.end(1)
  else
    if self.input ==# ''
      let self.count = get(self, 'count') + 1
      if self.count > 2
        call b:screensaver.previous()
      endif
    endif
    let self.input = ''
  endif
endfunction

function! s:self.redraw() dict abort
  call setline(1, repeat([''], winheight(0)))
  let m = 'Password: ' . repeat('*', len(self.input))
  let w = repeat(' ', max([(winwidth(0) - len(m)) / 2, 0]))
  let i = winheight(0) * 3 / 7 + 1
  call setline(i, w . m . ' ')
  call cursor(i, len(w . m) + 1)
  if !s:set_password
    let m = 'The password is not set. Please press Enter.'
    let w = repeat(' ', max([(winwidth(0) - len(m)) / 2, 0]))
    call setline(i + 2, w . m)
  endif
endfunction

function! s:self.end() dict abort
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
