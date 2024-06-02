"=============================================================================
" history.vim --- history manager
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:FILE = SpaceVim#api#import('file')
let s:JSON = SpaceVim#api#import('data#json')
let s:LOG = SpaceVim#logger#derive('history')
let s:BUF = SpaceVim#api#import('vim#buffer')
let s:history_cache_path = s:FILE.unify_path(g:spacevim_data_dir, ':p') . 'SpaceVim/nvim_history.json'
let s:filepos = {}

function! SpaceVim#plugins#history#readcache() abort
  call s:LOG.debug('read cache')
  call s:read_cache()
endfunction
function! SpaceVim#plugins#history#writecache() abort
  call s:LOG.debug('write cache')
  call s:write_cache()
endfunction

function! SpaceVim#plugins#history#jumppos() abort
  " nvim filename 
  " BufReadPost event before VimEnter
  if empty(s:filepos)
    call s:read_cache()
  endif
  let [l, c] = get(s:filepos, expand('%:p'), [0, 0])
  call s:LOG.debug(printf('jump to pos: [%s, %s]', l, c))
  if l != 0 && c != 0
    call cursor(l, c)
  endif
endfunction

function! SpaceVim#plugins#history#savepos() abort
  if empty(s:BUF.bufname()) || &buftype == 'nofile'
    return
  endif
  call s:LOG.debug('save pos for:' . s:BUF.bufname())
  let [_, l, c, _] = getpos('.')
  call s:LOG.debug(printf('line %d, col %d', l, c))
  if l != 0 && c != 0 && filereadable(s:BUF.bufname())
    let s:filepos[expand('%:p')] = [l, c]
  endif
endfunction



function! s:read_cache() abort
  if filereadable(s:history_cache_path)
    let his = s:JSON.json_decode(join(readfile(s:history_cache_path, ''), ''))
    if type(his) ==# type({})
      call map(deepcopy(his.cmd), 'histadd("cmd", v:val)')
      call map(deepcopy(his.search), 'histadd("search", v:val)')
      let s:filepos = get(his, 'filepos', {})
    endif
  endif
endfunction

function! s:write_cache() abort
  let his = { 'cmd' : [], 'filepos' : s:filepos, 'search' : []}
  for i in range(1, 100)
    let cmd = histget('cmd', 0 - i)
    if empty(cmd)
      break
    endif
    call insert(his.cmd, cmd)
  endfor
  for i in range(1, 100)
    let search = histget('search', 0 - i)
    if empty(search)
      break
    endif
    call insert(his.search, search)
  endfor
  call writefile([s:JSON.json_encode(his)], s:history_cache_path)
endfunction


