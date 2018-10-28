"=============================================================================
" compatible.vim --- SpaceVim compatible API
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

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

function! SpaceVim#api#vim#compatible#get() abort
  return map({
        \ 'execute' : '',
        \ 'system' : '',
        \ 'systemlist' : '',
        \ 'version' : '',
        \ 'has' : '',
        \ 'globpath' : '',
        \ 'matchaddpos' : '',
        \ 'win_screenpos' : '',
        \ },
        \ "function('s:' . v:key)"
        \ )
endfunction

function! s:has(feature) abort
  if a:feature ==# 'python'
    try
      py import vim
      return 1
    catch
      return 0
    endtry
  elseif a:feature ==# 'python3'
    try
      py3 import vim
      return 1
    catch
      return 0
    endtry
  elseif a:feature ==# 'pythonx'
    try
      pyx import vim
      return 1
    catch
      return 0
    endtry
  else
    return has(a:feature)
  endif
endfunction

if has('patch-8.0.1364')
  function! s:win_screenpos(nr) abort
    return win_screenpos(a:nr)
  endfunction
elseif s:has('python')
  function! s:win_screenpos(nr) abort
    if winnr('$') < a:nr || a:nr < 0
      return [0, 0]
    elseif a:nr == 0
      return [pyeval('vim.current.window.row'),
            \ pyeval('vim.current.window.col')]
    endif
    return [pyeval('vim.windows[' . a:nr . '].row'),
          \ pyeval('vim.windows[' . a:nr . '].col')]
  endfunction
elseif s:has('python3')
  function! s:win_screenpos(nr) abort
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
  function! s:win_screenpos(nr) abort
    return [0, 0]
  endfunction
endif

if exists('*execute')
  function! s:execute(cmd, ...) abort
    return call('execute', [a:cmd] + a:000)
  endfunction
else
  function! s:execute(cmd, ...) abort
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
  function! s:system(cmd, ...) abort
    return a:0 == 0 ? system(a:cmd) : system(a:cmd, a:1)
  endfunction
  function! s:systemlist(cmd, ...) abort
    return a:0 == 0 ? systemlist(a:cmd) : systemlist(a:cmd, a:1)
  endfunction
else
  function! s:system(cmd, ...) abort
    if type(a:cmd) == 3
      let cmd = map(a:cmd, 'shellescape(v:val)')
      let cmd = join(cmd, ' ')
      return a:0 == 0 ? system(cmd) : system(cmd, a:1)
    else
      return a:0 == 0 ? system(a:cmd) : system(a:cmd, a:1)
    endif
  endfunction
  if exists('*systemlist')
    function! s:systemlist(cmd, ...) abort
      if type(a:cmd) == 3
        let cmd = map(a:cmd, 'shellescape(v:val)')
        let excmd = join(cmd, ' ')
        return a:0 == 0 ? systemlist(excmd) : systemlist(excmd, a:1)
      else
        return a:0 == 0 ? systemlist(a:cmd) : systemlist(a:cmd, a:1)
      endif
    endfunction
  else
    function! s:systemlist(cmd, ...) abort
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
  function! s:globpath(dir, expr) abort
    return globpath(a:dir, a:expr, 1, 1)
  endfunction
else
  function! s:globpath(dir, expr) abort
    return split(globpath(a:dir, a:expr), '\n')
  endfunction
endif

if has('nvim')
  function! s:version() abort
    let v = api_info().version
    return v.major . '.' . v.minor . '.' . v.patch
  endfunction
else
  function! s:version() abort
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
  function! s:matchaddpos(group, pos, ...) abort
    let priority = get(a:000, 0, 10)
    let id = get(a:000, 1, -1)
    let dict = get(a:000, 2, {})
    return matchaddpos(a:group, a:pos, priority, id, dict)
  endfunction
else
  function! s:matchaddpos(group, pos, ...) abort
    let priority = get(a:000, 0, 10)
    let id = get(a:000, 1, -1)
    let dict = get(a:000, 2, {})
    let pos1 = a:pos[0]
    if type(pos1) == 0
      let id = matchadd(a:group, '\%' . pos1 . 'l', priority, id, dict)
    elseif type(pos1) == 3
      if len(pos1) == 1
        let id = matchadd(a:group, '\%' . pos1[0] . 'l', priority, id, dict)
      elseif len(pos1) == 2
        let id = matchadd(a:group, '\%' . pos1[0] . 'l\%' . pos1[1] . 'c', priority, id, dict)
      elseif len(pos1) == 3
        let id = matchadd(a:group, '\%' . pos1[0] . 'l\%>' . pos1[1] . 'c\%<' . pos1[2] . 'c', priority, id, dict)
      endif
    endif
    if len(a:pos) > 1
      for pos1 in a:pos[1:]
        if type(pos1) == 0
          call matchadd(a:group, '\%' . pos1 . 'l', priority, id, dict)
        elseif type(pos1) == 3
          if len(pos1) == 1
            call matchadd(a:group, '\%' . pos1[0] . 'l', priority, id, dict)
          elseif len(pos1) == 2
            call matchadd(a:group, '\%' . pos1[0] . 'l\%' . pos1[1] . 'c', priority, id, dict)
          elseif len(pos1) == 3
            call matchadd(a:group, '\%' . pos1[0] . 'l\%>' . pos1[1] . 'c\%<' . pos1[2] . 'c', priority, id, dict)
          endif
        endif
      endfor
    endif
    return id
  endfunction
endif


" vim:set et sw=2 cc=80:
