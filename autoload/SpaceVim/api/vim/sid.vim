"=============================================================================
" sid.vim --- SpaceVim SID API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section sid, api-vim-sid
" @parentsection api
"" Capture command

let s:self = {}

let s:DICT = SpaceVim#api#import('data#dict')

let s:self._cache = {}

function! s:self._capture(command) abort
  try
    let save_verbose = &verbose
    let &verbose = 0
    redir => out
    silent execute a:command
  finally
    redir END
    let &verbose = save_verbose
  endtry
  return out
endfunction
function! s:self._unify_path(path) abort
  return resolve(fnamemodify(a:path, ':p:gs?[\\/]?/?'))
endfunction
"" Capture command and return lines
function! s:self._capture_lines(command) abort
  return split(self._capture(a:command), "\n")
endfunction


function! s:self.scriptnames() abort
  let sdict = {} " { sid: path }
  for line in self._capture_lines(':scriptnames')
    let [sid, path] = split(line, '\m^\s*\d\+\zs:\s\ze')
    let sdict[str2nr(sid)] = self._unify_path(path)  " str2nr(): '  1' -> 1
  endfor
  return sdict
endfunction

function! s:self.get_sid_from_path(path) abort
  let path = self._unify_path(a:path)
  let scriptnames = s:DICT.swap(self.scriptnames())
  if has_key(scriptnames, path)
    return scriptnames[path]
  else
    return -1
  endif
endfunction

function! SpaceVim#api#vim#sid#get() abort
    return deepcopy(s:self)
endfunction
