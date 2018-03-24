"=============================================================================
" search.vim --- search tools in SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:search_tools = {}
let s:search_tools.namespace = {
      \ 'rg' : 'r',
      \ 'ag' : 'a',
      \ 'pt' : 't',
      \ 'ack' : 'k',
      \ 'grep' : 'g',
      \ }
let s:search_tools.a = {}
let s:search_tools.a.command = 'ag'
let s:search_tools.a.default_opts =
      \ [
      \ '-i', '--vimgrep', '--hidden', '--ignore',
      \ '.hg', '--ignore', '.svn', '--ignore', '.git', '--ignore', '.bzr',
      \ ]
let s:search_tools.a.recursive_opt = []
let s:search_tools.a.expr_opt = []
let s:search_tools.a.fixed_string_opt = ['-F']
let s:search_tools.a.default_fopts = ['--nonumber']
let s:search_tools.a.smart_case = ['-S']
let s:search_tools.a.ignore_case = ['-i']

let s:search_tools.t = {}
let s:search_tools.t.command = 'pt'
let s:search_tools.t.default_opts = ['--nogroup', '--nocolor']
let s:search_tools.t.recursive_opt = []
let s:search_tools.t.expr_opt = ['-e']
let s:search_tools.t.fixed_string_opt = []
let s:search_tools.t.default_fopts = []
let s:search_tools.t.smart_case = ['-S']
let s:search_tools.t.ignore_case = ['-i']

let s:search_tools.r = {}
let s:search_tools.r.command = 'rg'
let s:search_tools.r.default_opts = ['--hidden', '--no-heading', '--vimgrep']
let s:search_tools.r.recursive_opt = []
let s:search_tools.r.expr_opt = ['-e']
let s:search_tools.r.fixed_string_opt = ['-F']
let s:search_tools.r.default_fopts = ['--hidden', '-N']
let s:search_tools.r.smart_case = ['-S']
let s:search_tools.r.ignore_case = ['-i']

let s:search_tools.k = {}
let s:search_tools.k.command = 'ack'
let s:search_tools.k.default_opts = ['-i', '--no-heading', '--no-color', '-k', '-H']
let s:search_tools.k.recursive_opt = []
let s:search_tools.k.expr_opt = []
let s:search_tools.k.fixed_string_opt = []
let s:search_tools.k.default_fopts = []
let s:search_tools.k.smart_case = ['--smart-case']
let s:search_tools.k.ignore_case = ['--ignore-case']

let s:search_tools.g = {}
let s:search_tools.g.command = 'grep'
let s:search_tools.g.default_opts = ['-inHr']
let s:search_tools.g.expr_opt = ['-e']
let s:search_tools.g.fixed_string_opt = ['-F']
let s:search_tools.g.recursive_opt = ['.']
let s:search_tools.g.default_fopts = []
let s:search_tools.g.smart_case = []
let s:search_tools.g.ignore_case = ['-i']

function! SpaceVim#mapping#search#grep(key, scope)
  let cmd = s:search_tools[a:key]['command']
  let opt = s:search_tools[a:key]['default_opts']
  let ropt = s:search_tools[a:key]['recursive_opt']
  if a:scope ==# 'b'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : input('grep pattern:'),
          \ 'files':'@buffers',
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  elseif a:scope ==# 'B'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : expand('<cword>'),
          \ 'files':'@buffers',
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  elseif a:scope ==# 'p'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : input('grep pattern:'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  elseif a:scope ==# 'P'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : expand('<cword>'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  elseif a:scope ==# 'f'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : input('grep pattern:'),
          \ 'dir' : input('arbitrary dir:', '', 'dir'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  elseif a:scope ==# 'F'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : expand('<cword>'),
          \ 'dir' : input('arbitrary dir:', '', 'dir'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ })
  endif
endfunction

function! SpaceVim#mapping#search#default_tool() abort
  if !has_key(s:search_tools, 'default_exe')
    for t in get(g:, 'spacevim_search_tools', ['rg', 'ag', 'pt', 'ack', 'grep'])
      if executable(t)
        let s:search_tools.default_exe = t
        let key = s:search_tools.namespace[t]
        let s:search_tools.default_opt = s:search_tools[key]['default_opts']
        let s:search_tools.default_ropt = s:search_tools[key]['recursive_opt']
        let s:search_tools.expr_opt = s:search_tools[key]['expr_opt']
        let s:search_tools.fixed_string_opt = s:search_tools[key]['fixed_string_opt']
        let s:search_tools.ignore_case = s:search_tools[key]['ignore_case']
        let s:search_tools.smart_case = s:search_tools[key]['smart_case']
        break
      endif
    endfor
  endif
  return [
        \ s:search_tools.default_exe,
        \ s:search_tools.default_opt,
        \ s:search_tools.default_ropt,
        \ s:search_tools.expr_opt,
        \ s:search_tools.fixed_string_opt,
        \ s:search_tools.ignore_case,
        \ s:search_tools.smart_case,
        \ ]
endfunction

function! SpaceVim#mapping#search#getFopt(exe) abort
        let key = s:search_tools.namespace[a:exe]
        return s:search_tools[key]['default_fopts']
endfunction
