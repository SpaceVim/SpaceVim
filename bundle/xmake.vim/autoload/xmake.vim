"=============================================================================
" xmake.vim --- xmake support for spacevim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" Original Author: luzhlon
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
" This file is based on:
" https://github.com/luzhlon/xmake.vim/tree/5b20e97f5d0b063a97be23451c730d0278eef927

""
" @section Introduction, intro
" @library
" xmake.vim is a simple plugin for using xmake in vim and neovim.
" This plugin requires SpaceVim API and |job| support.

" load the spacevim APIs:
let s:JOB = SpaceVim#api#import('job')

let s:job = 0       " subprocess of xmake
let s:run = 0       " run this command after building successfully
let s:target = ''   " target to build, build ALL if empty
let s:cb_cexpr = {j,d,s->vim#cadde(join(d, "\n"))}

" Get the bufnr about a target's sourcefiles and headerfiles
func! s:targetbufs(target)
  let nrs = {}
  for i in a:target['sourcefiles'] + a:target['headerfiles']
    let n = bufnr(i)
    if n > 0 && getbufvar(n, '&mod')
      let nrs[n] = 1
    endif
  endfor
  return nrs
endfunction

" Get the bufnrs to save
fun! s:buf2save()
  if empty(s:target)
    " Save all target's file
    let nrs = {}
    for tf in values(g:xmproj['targets'])
      call extend(nrs, s:targetbufs(tf))
    endfor
  else
    " Save s:target's file
    let nrs = s:targetbufs(g:xmproj['targets'][s:target])
  endif
  return keys(nrs)
endfunction
" Save the file before building
fun! s:savefiles()
  let n = bufnr('%')      " save current bufnr
  let bufnrs = s:buf2save()
  let xnr = bufnr('xmake.lua')
  if xnr > 0
    call add(bufnrs, xnr)
  endif
  for nr in bufnrs        " traverse project's files, and save them
    sil! exe nr . 'bufdo!' 'up'
  endfor
  " switch to original buffer
  exe 'b!' n
endfunction

" If exists a xmake subprocess
fun! s:isRunning()
  if !empty(s:job) && job#status(s:job) == 'run'
    echom 'a xmake task is running'
    return 1
  endif
endfunction
" If loaded the xmake's configuration
fun! s:notLoaded()
  if exists('g:xmproj')
    return 0
  endif
  echo 'No xmake-project loaded'
  return 1
endfunction
" Building by xmake
fun! xmake#buildrun(...)
  if s:notLoaded() | return | endif
  if s:isRunning() | return | endif
  " call s:savefiles()          " save files about the target to build
  wall
  let run = a:0 && a:1
  let color = $COLORTERM
  fun! OnQuit(job, code, stream) closure
    let $COLORTERM = color
    if a:code               " open the quickfix if any errors
      echohl Error | echo 'build failure' | echohl
      cadde 'xmake returned ' . a:code
      copen
    else
      echohl MoreMsg | echo 'build success' s:target | echohl
      if run
        let t = get(get(g:xmproj['targets'], s:target, {}), 'targetfile')
        if empty(t)
          call viml#echohl('Error', 'Target not exists:', s:target)
        else
          call qrun#exec(empty(s:target) ? ['xmake', 'run']: t)
        endif
      endif
    endif
  endfunction
  cexpr ''
  let $COLORTERM = 'nocolor'
  " startup the xmake
  let cmd = empty(s:target) ? 'xmake': ['xmake', 'build', s:target]
  if has_key(g:xmproj, 'compiler')
    exe 'compiler' g:xmproj['compiler']
  endif
  let s:job = job#start(cmd, {
        \ 'on_stdout': s:cb_cexpr,
        \ 'on_stderr': s:cb_cexpr,
        \ 'on_exit': funcref('OnQuit')})
endfunction
" Interpret XMake command
fun! xmake#xmake(...)
  let argv = filter(copy(a:000), {i,v->v!=''})
  let argc = len(argv)
  if !argc                            " building all targets without running
    let s:target = ''
    call xmake#buildrun()
  elseif argv[0] == 'run' || argv[0] == 'r'   " building && running
    if argc > 1 | let s:target = argv[1] | endif
    call xmake#buildrun(1)
  elseif argv[0] == 'build'               " building specific target
    if argc > 1 | let s:target = argv[1] | endif
    call xmake#buildrun()
  else                                " else xmake's commands
    if s:isRunning() | return | endif
    cexpr ''
    let opts = {'on_stdout': s:cb_cexpr, 'on_stderr': s:cb_cexpr}
    if argv[0] == 'config' || argv[0] == 'f'
      let opts.on_exit = {job, code -> code ? execute('copen'): xmake#load()}
    endif
    let s:job = job#start(['xmake'] + argv, opts)
  endif
endfunction

fun! s:onload(...)
  " Check the fields
  for t in values(g:xmproj['targets'])
    if empty(t.headerfiles)
      let t.headerfiles = []
    endif
    if empty(t.sourcefiles)
      let t.sourcefiles = []
    endif
  endfor
  " Change UI
  echohl MoreMsg
  echom "XMake-Project loaded successfully"
  echohl
  set title
  let config = g:xmproj.config
  let &titlestring = join([g:xmproj['name'], config.mode, config.arch], ' - ')
  redraw
  " Find compiler
  let cc = get(g:xmproj.config, 'cc', '')
  let cxx = get(g:xmproj.config, 'cxx', '')
  let compiler = ''
  if !empty(cxx)
    let compiler = cxx
  elseif !empty(cc)
    let compiler = cc
  endif
  if !empty(compiler)
    let t = {'cl.exe': 'msvc', 'gcc': 'gcc'}
    let g:xmproj.compiler = t[compiler]
  endif
endfunction

augroup xmake_autoload
  autocmd!
  au User XMakeLoaded call <SID>onload()
augroup END


let s:path = expand('<sfile>:p:h')
let s:xmake_load_stdout_cache = []
let s:xmake_load_tempname = ''
function! s:xmake_load_stdout(id, data, event) abort
  call add(s:xmake_load_stdout_cache, a:data)
endfunction

function! s:xmake_load_exit(id, data, event) abort
    call xmake#log#info('LoadXCfg entered.')
    let err = []
    if a:code
      call add(err, 'xmake returned ' . a:code)
    endif
    let l = ''
    try
      let l = readfile(s:xmake_load_tempname)
      let g:xmproj = json_decode(l[0])
      do User XMakeLoaded
    catch
      let g:_xmake = {}
      let g:_xmake.tmpfile = s:xmake_load_tempname
      let g:_xmake.output = l
      cexpr ''
      call add(err, "XMake-Project loaded unsuccessfully:")
      cadde err | cadde cache | copen
    endtry
endfunction

fun! xmake#load()
  let s:xmake_load_stdout_cache = []
  let s:xmake_load_tempname = tempname()
  let cmdline = ['xmake', 'lua', s:path . '/spy.lua', '-o', s:xmake_load_tempname, 'project']
  call xmake#log#info(cmdline)
  call s:JOB.start(cmdline, {
        \ 'on_stdout' : function('s:s:xmake_load_stdout'),
        \ 'on_exit' : function('s:xmake_load_exit')
        \ }
        \ )
endfunction

" vim:set et sw=2 cc=80: