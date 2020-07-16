"=============================================================================
" compatible.vim --- SpaceVim compatible API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:has_cache = {}

let s:SYS = SpaceVim#api#import('system')

""
" @section vim#compatible, api-vim-compatible
" @parentsection api
"
" @subsection Functions
"
" execute(cmd)
"
"   run vim command, and return the output of such command.
"
" system(cmd)
"
"   like |system()| but can accept list as argv.
"
" systemlist(cmd)
"
"   like |systemlist()| but can accept list as argv.
"
" has(feature)
"
"   check if {feature} is supported in current version.
"
" getjumplist()
"
"   return a list of jump position, like result of |:jump|


" Load SpaceVim API:

let s:STRING = SpaceVim#api#import('data#string')

let s:self = {}

function! s:self.has(feature) abort
  if has_key(s:has_cache, a:feature)
    return s:has_cache[a:feature]
  endif

  if a:feature ==# 'python'
    try
      py import vim
      let s:has_cache['python'] = 1
      return 1
    catch
      let s:has_cache['python'] = 0
      return 0
    endtry
  elseif a:feature ==# 'python3'
    try
      py3 import vim
      let s:has_cache['python3'] = 1
      return 1
    catch
      let s:has_cache['python3'] = 0
      return 0
    endtry
  elseif a:feature ==# 'pythonx'
    try
      pyx import vim
      let s:has_cache['pythonx'] = 1
      return 1
    catch
      let s:has_cache['pythonx'] = 0
      return 0
    endtry
  else
    return has(a:feature)
  endif
endfunction

if has('patch-8.0.1364')
  function! s:self.win_screenpos(nr) abort
    return win_screenpos(a:nr)
  endfunction

elseif s:self.has('python')
  function! s:self.win_screenpos(nr) abort

    if winnr('$') < a:nr || a:nr < 0
      return [0, 0]
    elseif a:nr == 0
      return [pyeval('vim.current.window.row'),
            \ pyeval('vim.current.window.col')]
    endif
    return [pyeval('vim.windows[' . a:nr . '].row'),
          \ pyeval('vim.windows[' . a:nr . '].col')]
  endfunction

elseif s:self.has('python3')
  function! s:self.win_screenpos(nr) abort

    if winnr('$') < a:nr || a:nr < 0
      return [0, 0]
    elseif a:nr == 0
      return [py3eval('vim.current.window.row'),
            \ py3eval('vim.current.window.col')]
    endif
    return [py3eval('vim.windows[' . a:nr . '].row'),
          \ py3eval('vim.windows[' . a:nr . '].col')]
  endfunction
else
  " @vimlint(EVL103, 1, a:nr)
  function! s:self.win_screenpos(nr) abort
    return [0, 0]
  endfunction
  " @vimlint(EVL103, 0, a:nr)
endif

if exists('*execute')
  function! s:self.execute(cmd, ...) abort
    return call('execute', [a:cmd] + a:000)
  endfunction
else
  function! s:self.execute(cmd, ...) abort
    if a:0 == 0
      let s = 'silent'
    else
      let s = a:1
    endif
    let output = ''
    redir => output
    if s ==# 'silent'
      silent execute a:cmd
    elseif s ==# 'silent!'
      silent! execute a:cmd
    else
      execute a:cmd
    endif
    redir END
    return output
  endfunction
endif

if has('nvim')
  function! s:self.system(cmd, ...) abort
    return a:0 == 0 ? system(a:cmd) : system(a:cmd, a:1)
  endfunction
  function! s:self.systemlist(cmd, ...) abort
    return a:0 == 0 ? systemlist(a:cmd) : systemlist(a:cmd, a:1)
  endfunction
else
  function! s:self.system(cmd, ...) abort
    if type(a:cmd) == 3
      let cmd = map(a:cmd, 'shellescape(v:val)')
      let cmd = join(cmd, ' ')
      return a:0 == 0 ? system(cmd) : system(cmd, a:1)
    else
      return a:0 == 0 ? system(a:cmd) : system(a:cmd, a:1)
    endif
  endfunction
  if exists('*systemlist')
    function! s:self.systemlist(cmd, ...) abort
      if type(a:cmd) == 3
        let cmd = map(a:cmd, 'shellescape(v:val)')
        let excmd = join(cmd, ' ')
        return a:0 == 0 ? systemlist(excmd) : systemlist(excmd, a:1)
      else
        return a:0 == 0 ? systemlist(a:cmd) : systemlist(a:cmd, a:1)
      endif
    endfunction
  else
    function! s:self.systemlist(cmd, ...) abort
      if type(a:cmd) == 3
        let cmd = map(a:cmd, 'shellescape(v:val)')
        let excmd = join(cmd, ' ')
        return a:0 == 0 ? split(system(excmd), "\n")
              \ : split(system(excmd, a:1), "\n")
      else
        return a:0 == 0 ? split(system(a:cmd), "\n")
              \ : split(system(a:cmd, a:1), "\n")
      endif
    endfunction
  endif
endif

if has('patch-7.4.279')
  function! s:self.globpath(dir, expr) abort
    return globpath(a:dir, a:expr, 1, 1)
  endfunction
else
  function! s:self.globpath(dir, expr) abort
    return split(globpath(a:dir, a:expr), '\n')
  endfunction
endif

if has('nvim')
  function! s:self.version() abort
    let v = api_info().version
    return v.major . '.' . v.minor . '.' . v.patch
  endfunction
else
  function! s:self.version() abort
    redir => l:msg
    silent! execute ':version'
    redir END
    return s:parser(matchstr(l:msg,'\(Included\ patches:\ \)\@<=[^\n]*'))
  endfunction
  function! s:parser(version) abort
    let v_list = split(a:version, ',')
    if len(v_list) == 1
      let patch = split(v_list[0], '-')[1]
      let v = v:version[0:0] . '.' . v:version[2:2] . '.' . patch
    else
      let v = v:version[0:0] . '.' . v:version[2:2] . '(' . a:version . ')'
    endif
    return v
  endfunction
endif


" patch 7.4.330  add function matchaddpos()

" patch 7.4.792 add dict argv to matchaddpos() (only conceal)
" patch 7.4.1740  syn-cchar defined with matchadd() does not appear
" patch 8.1.0218 update dict argv (add window)



" - A number.  This whole line will be highlighted.  The first
" line has number 1.
" - A list with one number, e.g., [23]. The whole line with this
" number will be highlighted.
" - A list with two numbers, e.g., [23, 11]. The first number is
" the line number, the second one is the column number (first
" column is 1, the value must correspond to the byte index as
" |col()| would return).  The character at this position will
" be highlighted.
" - A list with three numbers, e.g., [23, 11, 3]. As above, but
" the third number gives the length of the highlight in bytes.

if exists('*matchaddpos')
  function! s:self.matchaddpos(group, pos, ...) abort
    let priority = get(a:000, 0, 10)
    let id = get(a:000, 1, -1)
    let argv = [priority, id]
    if has('patch-7.4.792')
      let dict = get(a:000, 2, {})
      call add(argv, dict)
    endif
    return call('matchaddpos', [a:group, a:pos] + argv)
  endfunction
else
  function! s:self.matchaddpos(group, pos, ...) abort
    let priority = get(a:000, 0, 10)
    let id = get(a:000, 1, -1)
    let argv = [priority, id]
    if has('patch-7.4.792')
      let dict = get(a:000, 2, {})
      call add(argv, dict)
    endif
    let pos1 = a:pos[0]
    if type(pos1) == 0
      let id = call('matchadd', [a:group, '\%' . pos1 . 'l'] + argv)
    elseif type(pos1) == 3
      if len(pos1) == 1
        let id = call('matchadd', [a:group, '\%' . pos1[0] . 'l'] + argv)
      elseif len(pos1) == 2
        let id = call('matchadd', [a:group, '\%' . pos1[0] . 'l\%' . pos1[1] . 'c'] + argv)
      elseif len(pos1) == 3
        let id = call('matchadd', [a:group, '\%' . pos1[0] . 'l\%>' . pos1[1] . 'c\%<' . pos1[2] . 'c'] + argv)
      endif
    endif
    if len(a:pos) > 1
      for pos1 in a:pos[1:]
        if type(pos1) == 0
          let id = call('matchadd', [a:group, '\%' . pos1 . 'l'] + argv)
        elseif type(pos1) == 3
          if len(pos1) == 1
            let id = call('matchadd', [a:group, '\%' . pos1[0] . 'l'] + argv)
          elseif len(pos1) == 2
            let id = call('matchadd', [a:group, '\%' . pos1[0] . 'l\%' . pos1[1] . 'c'] + argv)
          elseif len(pos1) == 3
            let id = call('matchadd', [a:group, '\%' . pos1[0] . 'l\%>' . pos1[1] . 'c\%<' . pos1[2] . 'c'] + argv)
          endif
        endif
      endfor
    endif
    return id
  endfunction
endif

function! s:self.set_buf_line() abort

endfunction

if exists('*getjumplist')
  function! s:self.getjumplist() abort
    return getjumplist()
  endfunction
else
  "
  " the following entries:
  " bufnr		buffer number
  " col		column number
  " coladd		column offset for 'virtualedit'
  " filename	filename if available
  " lnum		line number
  function! s:self.getjumplist() abort
    let jumpinfo = split(self.execute(':jumps'), "\n")[1:-2]
    let result = []
    "   20   281   23 -invalid-
    for info in jumpinfo
      let [jump, line, col] = s:STRING.split(info, '', 0, 4)[0:2]
      call add(result, {
            \ 'bufnr' : jump,
            \ 'lnum' : line,
            \ 'col' : col,
            \ 'coladd' : 0,
            \ })
    endfor
    return result
  endfunction
endif

if s:SYS.isWindows
  function! s:self.resolve(path) abort
    let cmd = 'dir /a "' . a:path . '" | findstr SYMLINK'
    " 2018/12/07 周五  下午 10:23    <SYMLINK>      vimfiles [C:\Users\Administrator\.SpaceVim]
    " ref: https://superuser.com/questions/524669/checking-where-a-symbolic-link-points-at-in-windows-7
    silent let rst = system(cmd)
    if !v:shell_error
      let dir = split(rst)[-1][1:-2]
      return dir
    endif
    return a:path
  endfunction
else
  function! s:self.resolve(path) abort
    return resolve(a:path)
  endfunction
endif



function! SpaceVim#api#vim#compatible#get() abort
  return deepcopy(s:self)
endfunction


" vim:set et sw=2 cc=80:
