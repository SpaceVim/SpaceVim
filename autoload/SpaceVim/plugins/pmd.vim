"=============================================================================
" pmd.vim --- Integrates PMD using Vim quickfix mode
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

" init plugin values

let s:options = {
      \ '-f' : {
      \ 'description' : '',
      \ 'complete' : ['text'],
      \ },
      \ '-d' : {
      \ 'description' : 'Root directory for sources',
      \ 'complete' : 'file',
      \ },
      \ }

if !exists('Pmd_Cmd')
    let g:Pmd_Cmd = ['pmd']
endif

if !exists('Pmd_Cache_Dir')
  let g:Pmd_Cache_Dir = '~/.cache/pmd/'
endif

if !exists('Pmd_Rulesets')
    let g:Pmd_Rulesets = ["-R", "java-basic,java-design", "-property", "xsltFilename=my-own.xs"]
endif

" load SpaceVim APIs

let s:JOB = SpaceVim#api#import('job')
let s:CMD = SpaceVim#api#import('vim#command')

" set APIs

let s:CMD.options = s:options

function! s:on_pmd_stdout(id, data, event) abort
  echom string(a:data)
endfunction

function! s:on_pmd_stderr(id, data, event) abort
  echom string(a:data)
endfunction

function! s:on_pmd_exit(id, data, event) abort
  echom string(a:data)
endfunction

function! SpaceVim#plugins#pmd#run(...)
  let argv = g:Pmd_Cmd + ['-cache', g:Pmd_Cache_Dir]
  let argv += a:000 + g:Pmd_Rulesets
  echom s:JOB.start(argv,
        \ {
        \ 'on_stdout' : function('s:on_pmd_stdout'),
        \ 'on_stderr' : function('s:on_pmd_stderr'),
        \ 'on_exit' : function('s:on_pmd_exit'),
        \ }
        \ )
endfunction

function! SpaceVim#plugins#pmd#debug()
  call s:CMD.debug()
endfunction


function! SpaceVim#plugins#pmd#complete(ArgLead, CmdLine, CursorPos)
  return s:CMD.complete(a:ArgLead, a:CmdLine, a:CursorPos)
endfunction
