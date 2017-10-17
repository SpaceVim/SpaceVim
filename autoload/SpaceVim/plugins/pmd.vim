"=============================================================================
" pmd.vim --- Integrates PMD using Vim quickfix mode
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

" init plugin values

let s:options = {
      \ '-R' : {
      \ 'description' : 'Comma separated list of ruleset names to use',
      \ 'complete' : [],
      \ },
      \ '-f' : {
      \ 'description' : '',
      \ 'complete' : ['text'],
      \ },
      \ '-d' : {
      \ 'description' : 'Root directory for sources',
      \ 'complete' : 'file',
      \ },
      \ '-cache' : {
      \ 'description' : 'Set cache file',
      \ 'complete' : 'file',
      \ },
      \ }

if !exists('Pmd_Cmd')
    let g:Pmd_Cmd = ['pmd']
endif

if !exists('Pmd_Rulesets')
    let g:Pmd_Rulesets = ["-R", "java-basic,java-design", "-property", "xsltFilename=my-own.xs"]
endif

if !exists('Pmd_silent_stderr')
  let g:Pmd_silent_stderr = 1
endif

" load SpaceVim APIs

let s:JOB = SpaceVim#api#import('job')
let s:CMD = SpaceVim#api#import('vim#command')

" set APIs

let s:CMD.options = s:options

let s:rst = []

function! s:on_pmd_stdout(id, data, event) abort
    for data in a:data
        let info = split(data, '\:\d\+\:')
        if len(info) == 2
            let [fname, text] = info
            let lnum = matchstr(data, '\:\d\+\:')[1:-2]
            call add(s:rst, {
                        \ 'filename' : fnamemodify(fname, ':p'),
                        \ 'lnum' : lnum,
                        \ 'text' : text,
                        \ })
        endif
    endfor
endfunction

function! s:on_pmd_stderr(id, data, event) abort
  let s:JOB._message += a:data
  if g:Pmd_silent_stderr == 0
    echom string(a:data)
  endif
endfunction

function! s:on_pmd_exit(id, data, event) abort
    call setqflist(s:rst)
    let s:rst = []
    copen
endfunction

function! SpaceVim#plugins#pmd#run(...)
  let argv = g:Pmd_Cmd + a:000
  if index(a:000, '-R') == -1
    let argv += g:Pmd_Rulesets
  endif
  if index(argv, '-d') == -1
    echohl ErrorMsg | echo 'you need to run PMD with -d option!'
    return
  endif
  call s:JOB.start(argv,
        \ {
        \ 'on_stdout' : function('s:on_pmd_stdout'),
        \ 'on_stderr' : function('s:on_pmd_stderr'),
        \ 'on_exit' : function('s:on_pmd_exit'),
        \ }
        \ )
endfunction

function! SpaceVim#plugins#pmd#debug()
  call s:CMD.debug()
  call s:JOB.debug()
endfunction


function! SpaceVim#plugins#pmd#complete(ArgLead, CmdLine, CursorPos)
  return s:CMD.complete(a:ArgLead, a:CmdLine, a:CursorPos)
endfunction

