"=============================================================================
" logger.vim --- SpaceVim logger API
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
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

let s:TIME = SpaceVim#api#import('time')

let s:self = {
      \ 'name' : '',
      \ 'silent' : 1,
      \ 'level' : 1,
      \ 'verbose' : 1,
      \ 'file' : '',
      \ 'temp' : [],
      \ 'clock' : reltime(),
      \ }

"0 : debug, info, warn, error
"1 : info, warn, error
"2 : warn, error
"3 : error
let s:self.levels = ['Debug', 'Info', 'Warn', 'Error']

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

function! s:self._build_msg(msg, l) abort
  let msg = a:msg
  let time = strftime('%H:%M:%S')
  let log = printf('[ %s ] [%s] [%8S] [ %5s ] %s',
        \ self.name,
        \ time,
        \ printf('%00.3f' ,s:TIME.reltimefloat(reltime(self.clock))),
        \ self.levels[a:l],
        \ msg)
  return log
endfunction

function! s:self.error(msg) abort
  let log = self._build_msg(a:msg, 3)
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
  let log = self._build_msg(a:msg, 2)
  if (!self.silent && self.verbose >= 2) || get(a:000, 0, 0) == 1
    echohl WarningMsg
    echom log
    echohl None
  endif
  call self.write(log)
endfunction

function! s:self.debug(msg) abort
  if self.level > 0
    return
  endif
  let log = self._build_msg(a:msg, 0)
  if !self.silent && self.verbose >= 4
    echom log
  endif
  call self.write(log)
endfunction

function! s:self.info(msg) abort
  if self.level > 1
    return
  endif
  let log = self._build_msg(a:msg, 1)
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
  if !empty(matchstr(a:msg, self.levels[3]))
    return 1
  elseif !empty(matchstr(a:msg, self.levels[2]))
    return a:l <= 2
  elseif !empty(matchstr(a:msg, self.levels[1]))
    return a:l <= 1
  else
    return a:l <= 0
  end
endfunction

function! s:self.clear(level) abort
  let self.temp = filter(deepcopy(self.temp), '!self._comp(v:val, a:level)')
endfunction
