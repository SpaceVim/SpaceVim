"=============================================================================
" dart.vim --- SpaceVim lang#dart layer
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#dart, layers-lang-dart
" @parentsection layers
" @subsection Intro
"
" The lang#dart layer provides code completion, documentation lookup, jump to
" definition, dart_repl integration for dart. It uses neomake as default
" syntax checker which is loaded in @section(layer-checkers). To enable this
" layer:
" >
"   [layers]
"     name = "lang#dart"
" <
"
" @subsection Layer options
"
" 1. `dart_sdk_path`: Set the path of dart sdk, by default, it is ''.
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for hack, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"
" This layer use deoplete-dart as default completion plugin for dart. If the
" @section(layer-lsp) is enabled for dart, This plugin will not be loaded.
"
"

if exists('s:flutter_job_id')
  finish
endif

let s:flutter_job_id = 0
let s:dart_sdk_path = ''

let s:JOB = SpaceVim#api#import('job')
let s:NOTI = SpaceVim#api#import('notify')

function! SpaceVim#layers#lang#dart#plugins() abort
  let plugins = []
  call add(plugins, ['dart-lang/dart-vim-plugin', {'merged' : 0}])
  if !SpaceVim#layers#lsp#check_filetype('dart')
    call add(plugins, ['SpaceVim/deoplete-dart', {'merged' : 0}])
  endif
  return plugins
endfunction


function! SpaceVim#layers#lang#dart#config() abort
  call SpaceVim#plugins#runner#reg_runner('dart', 'dart %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('dart', function('s:language_specified_mappings'))
  call SpaceVim#plugins#repl#reg('dart', ['pub', 'global', 'run', 'dart_repl'])
  call add(g:spacevim_project_rooter_patterns, 'pubspec.yaml')
  let g:deoplete#sources#dart#dart_sdk_path = s:dart_sdk_path
endfunction

function! SpaceVim#layers#lang#dart#set_variable(var) abort
  let s:dart_sdk_path = get(a:var, 'dart_sdk_path', s:dart_sdk_path)
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("dart")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
  if SpaceVim#layers#lsp#check_filetype('dart')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>

    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
  let g:_spacevim_mappings_space.l.f = {'name' : '+Flutter'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'f', 'r'], 'call call('
        \ . string(s:_function('s:flutter_run')) . ', [])',
        \ 'flutter-run', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'f', 'D'], 'call SpaceVim#plugins#runner#open("flutter doctor")',
        \ 'flutter-doctor', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'f', 'd'], 'call SpaceVim#plugins#runner#open("flutter devices")',
        \ 'flutter-devices', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'f', 'e'], 'call SpaceVim#plugins#runner#open("flutter emulators")',
        \ 'flutter-emulators', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'f', 'l'], 'call call('
        \ . string(s:_function('s:flutter_send')) . ', ["r"])',
        \ 'flutter-reload', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'f', 's'], 'call call('
        \ . string(s:_function('s:flutter_send')) . ', ["R"])',
        \ 'flutter-restart', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'f', 'q'], 'call call('
        \ . string(s:_function('s:flutter_send')) . ', ["q"])',
        \ 'flutter-quit', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l', 'f', 'E'], 'call call('
        \ . string(s:_function('s:flutter_emulators_launch')) . ', [])',
        \ 'flutter-emulators-launch', 1)
endfunction

function! s:flutter_run() abort
  if s:flutter_job_id ==# 0
    " call s:NOTI.notify(line, 'Normal')
    let s:flutter_job_id = s:JOB.start('flutter run',
          \ {
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_exit'),
          \ }
          \ )
  endif
endfunction

function! s:flutter_send(msg) abort
  if s:flutter_job_id ==# 0
    call s:NOTI.notify('Flutter is not running.', 'WarningMsg')
  else
    call s:JOB.send(s:flutter_job_id, a:msg)
  endif
endfunction

function! s:on_stdout(id, data, event) abort
  for line in filter(a:data, '!empty(v:val)')
    call s:NOTI.notify(line, 'Normal')
  endfor
endfunction

function! s:on_stderr(id, data, event) abort
  for line in filter(a:data, '!empty(v:val)')
    call s:NOTI.notify(line, 'WarningMsg')
  endfor
endfunction

function! s:on_exit(...) abort
  let s:flutter_job_id = 0
endfunction

function! s:flutter_emulators_launch() abort
  call inputsave()
  let emulators = input('emulators id:')
  call inputrestore()
  if !empty(emulators)
    call s:JOB.start(['flutter', 'emulators', '--launch', emulators],
          \ {
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ }
          \ )
  endif
endfunction


" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif

function! SpaceVim#layers#lang#dart#health() abort
  call SpaceVim#layers#lang#dart#plugins()
  call SpaceVim#layers#lang#dart#config()
  return 1
endfunction
