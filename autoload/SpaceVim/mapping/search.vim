"=============================================================================
" search.vim --- search tools in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" How to add new search tools?
"
" first, namespace should avoid b d f j p B D F J P
" then, the exist namespace should be avoid too

let s:search_tools = {}
let s:search_tools.namespace = {
      \ 'rg' : 'r',
      \ 'ag' : 'a',
      \ 'pt' : 't',
      \ 'ack' : 'k',
      \ 'grep' : 'g',
      \ 'findstr' : 'i',
      \ }
let s:search_tools.a = {}
let s:search_tools.a.command = 'ag'
let s:search_tools.a.default_opts =
      \ [
      \ '-i', '--nocolor', '--filename', '--noheading', '--column', '--hidden', '--ignore',
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
let s:search_tools.r.default_opts = [
      \ '--hidden', '--no-heading', '--color=never', '--with-filename', '--line-number', '--column',
      \ '-g', '!.git'
      \ ]
let s:search_tools.r.recursive_opt = []
let s:search_tools.r.expr_opt = ['-e']
let s:search_tools.r.fixed_string_opt = ['-F']
let s:search_tools.r.default_fopts = ['-N']
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

let s:search_tools.i = {}
let s:search_tools.i.command = 'findstr'
let s:search_tools.i.default_opts = ['/RSN']
let s:search_tools.i.recursive_opt = []
let s:search_tools.i.expr_opt = []
let s:search_tools.i.fixed_string_opt = []
let s:search_tools.i.default_fopts = []
let s:search_tools.i.smart_case = []
let s:search_tools.i.ignore_case = ['/I']

function! SpaceVim#mapping#search#grep(key, scope) abort
  let cmd = s:search_tools[a:key]['command']
  let opt = s:search_tools[a:key]['default_opts']
  let ropt = s:search_tools[a:key]['recursive_opt']
  let ignore = s:search_tools[a:key]['ignore_case']
  let smart = s:search_tools[a:key]['smart_case']
  let expr = s:search_tools[a:key]['expr_opt']
  if a:scope ==# 'b'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : input('grep pattern:'),
          \ 'files':'@buffers',
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ 'ignore_case' : ignore,
          \ 'smart_case' : smart,
          \ 'expr_opt' : expr,
          \ })
  elseif a:scope ==# 'B'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : expand('<cword>'),
          \ 'files':'@buffers',
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ 'ignore_case' : ignore,
          \ 'smart_case' : smart,
          \ 'expr_opt' : expr,
          \ })
  elseif a:scope ==# 'p'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : input('grep pattern:'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ 'ignore_case' : ignore,
          \ 'smart_case' : smart,
          \ 'expr_opt' : expr,
          \ })
  elseif a:scope ==# 'P'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : expand('<cword>'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ 'ignore_case' : ignore,
          \ 'smart_case' : smart,
          \ 'expr_opt' : expr,
          \ })
  elseif a:scope ==# 'd'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : input('grep pattern:'),
          \ 'dir' : fnamemodify(expand('%'), ':p:h'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ 'ignore_case' : ignore,
          \ 'smart_case' : smart,
          \ 'expr_opt' : expr,
          \ })
  elseif a:scope ==# 'D'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : expand('<cword>'),
          \ 'dir' : fnamemodify(expand('%'), ':p:h'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ 'ignore_case' : ignore,
          \ 'smart_case' : smart,
          \ 'expr_opt' : expr,
          \ })
  elseif a:scope ==# 'f'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : input('grep pattern:'),
          \ 'dir' : input('arbitrary dir:', '', 'dir'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ 'ignore_case' : ignore,
          \ 'smart_case' : smart,
          \ 'expr_opt' : expr,
          \ })
  elseif a:scope ==# 'F'
    call SpaceVim#plugins#flygrep#open({
          \ 'input' : expand('<cword>'),
          \ 'dir' : input('arbitrary dir:', '', 'dir'),
          \ 'cmd' : cmd,
          \ 'opt' : opt,
          \ 'ropt' : ropt,
          \ 'ignore_case' : ignore,
          \ 'smart_case' : smart,
          \ 'expr_opt' : expr,
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
    if !has_key(s:search_tools, 'default_exe')
      return ['', '', '', '', '', '', '']
    endif
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


" the profile of a search tool should be:
" { 'ag' : { 
"   'namespace' : '',         " a single char a-z
"   'command' : '',           " executable
"   'default_opts' : [],      " default options
"   'recursive_opt' : [],     " default recursive options
"   'expr_opt' : '',          " option for enable expr mode
"   'fixed_string_opt' : '',  " option for enable fixed string mode
"   'ignore_case' : '',       " option for enable ignore case mode
"   'smart_case' : '',        " option for enable smart case mode
"   }
"  }
"
"  so the finale command line is :
"  [command] 
"  + [ignore_case_opt]? 
"  + [smart_case_opt]?
"  + [string_opt]/[expr_opt]?
"  + {expr}
"  + {files or dir}
"  + [roptions]
function! SpaceVim#mapping#search#profile(opt) abort

  for key in keys(a:opt)
    if has_key(s:search_tools.namespace, key)
      for opt_key in keys(s:search_tools[s:search_tools.namespace[key]])
        if has_key(a:opt[key], opt_key)
          let s:search_tools[s:search_tools.namespace[key]][opt_key] = a:opt[key][opt_key]
        endif
      endfor
    else
      call s:add_new_search_tool(a:opt[key])
    endif
  endfor

endfunction

function! SpaceVim#mapping#search#getprofile(...) abort

  if a:0 > 0
    let tool = get(s:search_tools.namespace, a:1, '')
    if !empty(tool)
      return deepcopy(s:search_tools[tool])
    endif
  else
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
    if has_key(s:search_tools, 'default_exe')
      return deepcopy(s:search_tools[s:search_tools.namespace[s:search_tools.default_exe]])
    endif
  endif

endfunction

function! s:add_new_search_tool(tool) abort
  " TODO: add new tools,
  " 1. we should check namespace
endfunction
