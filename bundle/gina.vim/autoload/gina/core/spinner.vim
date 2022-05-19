scriptencoding utf-8

if $LANG ==# 'C'
  let s:frames = ['-', '\', '|', '/']
else
  let s:frames = ['⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷']
endif

function! gina#core#spinner#new(expr, ...) abort
  let options = extend({
        \ 'frames': g:gina#core#spinner#frames,
        \ 'message': g:gina#core#spinner#message,
        \ 'delaytime': g:gina#core#spinner#delaytime,
        \ 'updatetime': g:gina#core#spinner#updatetime,
        \}, a:0 ? a:1 : {})
  let spinner = deepcopy(s:spinner)
  let spinner._bufnr = bufnr(a:expr)
  let spinner._frames = options.frames
  let spinner._message = options.message
  let spinner._delaytime = options.delaytime
  let spinner._updatetime = options.updatetime
  return spinner
endfunction

function! gina#core#spinner#start(expr, ...) abort
  let spinner = gina#core#spinner#new(a:expr, a:0 ? a:1 : {})
  call spinner.start_delay()
  return spinner
endfunction



function! s:_spinner_next() abort dict
  let index = self._index + 1
  let self._index = index >= len(self._frames) ? 0 : index
  return self._index
endfunction

function! s:_spinner_text() abort dict
  let face = self._frames[self._index]
  return ' ' . face . ' ' . self._message
endfunction

function! s:_spinner_start_delay() abort dict
  if self._timer isnot# v:null || self._timer_delay isnot# v:null || self._delaytime < 0
    return
  endif
  let self._timer_delay = timer_start(
        \ self._delaytime,
        \ self.start,
        \)
endfunction

function! s:_spinner_start(...) abort dict
  if self._timer isnot# v:null || self._delaytime < 0
    return
  endif
  silent! call timer_stop(self._timer_delay)
  let self._statusline = getbufvar(self._bufnr, '&statusline')
  let self._timer = timer_start(
        \ self._updatetime,
        \ function('s:update_spinner', [self]),
        \ { 'repeat': -1 }
        \)
  let self._timer_delay = v:null
endfunction

function! s:_spinner_stop() abort dict
  if self._timer_delay isnot# v:null
    call timer_stop(self._timer_delay)
    let self._timer_delay = v:null
  endif
  if self._timer is# v:null
    return
  endif
  call timer_stop(self._timer)
  call setbufvar(self._bufnr, '&statusline', self._statusline)
  let self._timer = v:null
endfunction

function! s:update_spinner(spinner, timer) abort
  if !bufexists(a:spinner._bufnr)
    call a:spinner.stop()
  elseif bufwinnr(a:spinner._bufnr) >= 0
    call a:spinner.next()
    call setbufvar(a:spinner._bufnr, '&statusline', a:spinner.text())
  endif
endfunction

let s:spinner = {
      \ '_timer': v:null,
      \ '_timer_delay': v:null,
      \ '_bufnr': 0,
      \ '_index': 0,
      \ 'next': function('s:_spinner_next'),
      \ 'text': function('s:_spinner_text'),
      \ 'start': function('s:_spinner_start'),
      \ 'start_delay': function('s:_spinner_start_delay'),
      \ 'stop': function('s:_spinner_stop'),
      \}


call gina#config(expand('<sfile>'), {
      \ 'frames': s:frames,
      \ 'message': 'Loading ...',
      \ 'delaytime': 500,
      \ 'updatetime': 100,
      \})
