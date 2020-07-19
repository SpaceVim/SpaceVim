"=============================================================================
" logger.vim --- SpaceVim logger API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section logger, api-logger
" @parentsection api
" provides some functions to manager logger
"
" set_silent({silent})
"
"   {silent} is a Boolean. by default it is false, and log will be print to
"   screen.

let s:self = {
      \ 'name' : '',
      \ 'silent' : 1,
      \ 'level' : 1,
      \ 'verbose' : 1,
      \ 'file' : '',
      \ 'temp' : [],
      \ }

"1 : log all messages
"2 : log warning and error messages
"3 : log error messages only
let s:levels = ['Info', 'Warn', 'Error']

function! SpaceVim#api#logger#get() abort
  return deepcopy(s:self)
endfunction

function! s:self.set_silent(sl) abort
  let self.silent = a:sl
endfunction

function! s:self.set_verbose(vb) abort
  let self.verbose = a:vb
endfunction

function! s:self.set_level(l) abort
  let self.level = a:l
endfunction

function! s:self.error(msg) abort
  let time = strftime('%H:%M:%S')
  let log = '[ ' . self.name . ' ] [' . time . '] [ ' . s:levels[2] . ' ] ' . a:msg
  if !self.silent && self.verbose >= 1
    echohl Error
    echom log
    echohl None
  endif
  call self.write(log)
endfunction

function! s:self.write(msg) abort
  call add(self.temp, a:msg)
  if empty(self.file)
    return
  endif
  if !isdirectory(fnamemodify(self.file, ':p:h'))
    call mkdir(expand(fnamemodify(self.file, ':p:h')), 'p')
  endif
  let flags = filewritable(self.file) ? 'a' : ''
  call writefile([a:msg], self.file, flags)
endfunction

function! s:self.warn(msg, ...) abort
  if self.level > 2
    return
  endif
  let time = strftime('%H:%M:%S')
  let log = '[ ' . self.name . ' ] [' . time . '] [ ' . s:levels[1] . ' ] ' . a:msg
  if (!self.silent && self.verbose >= 2) || get(a:000, 0, 0) == 1
    echohl WarningMsg
    echom log
    echohl None
  endif
  call self.write(log)
endfunction

function! s:self.info(msg) abort
  if self.level > 1
    return
  endif
  let time = strftime('%H:%M:%S')
  let log = '[ ' . self.name . ' ] [' . time . '] [ ' . s:levels[0] . ' ] ' . a:msg
  if !self.silent && self.verbose >= 3
    echom log
  endif
  call self.write(log)
endfunction

function! s:self.set_name(name) abort
  let self.name = a:name
endfunction

function! s:self.get_name() abort
  return self.name
endfunction

function! s:self.set_file(file) abort
  let self.file = a:file
endfunction

function! s:self.view(l) abort
  let info = ''
  if filereadable(self.file)
    let logs = readfile(self.file, '')
    let info .= join(filter(logs, 'self._comp(v:val, a:l)'), "\n")
  else
    let info .= '[ ' . self.name . ' ] : logger file ' . self.file
          \ . ' does not exists, only log for current process will be shown!'
    let info .= "\n"
    let info .= join(filter(deepcopy(self.temp), 'self._comp(v:val, a:l)'), "\n")
  endif
  return info
endfunction

function! s:self._comp(msg, l) abort
  if a:msg =~# '\[ ' . self.name . ' \] \[\d\d\:\d\d\:\d\d\] \[ '
        \ . s:levels[2] . ' \]'
    return 1
  elseif a:msg =~# '\[ ' . self.name . ' \] \[\d\d\:\d\d\:\d\d\] \[ '
        \ . s:levels[1] . ' \]'
    if a:l > 2
      return 0
    else
      return 1
    endif
  else
    if a:l > 1
      return 0
    else
      return 1
    endif
  endif
endfunction

function! s:self.clear(level) abort
  let self.temp = filter(deepcopy(self.temp), '!self._comp(v:val, a:level)')
endfunction
