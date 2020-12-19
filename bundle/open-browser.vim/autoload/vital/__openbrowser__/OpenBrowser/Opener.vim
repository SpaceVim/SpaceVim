" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! s:_vital_depends() abort
  return [
  \ 'Process',
  \ 'Vim.Message',
  \]
endfunction

function! s:_vital_loaded(V) abort
  let s:Process = a:V.import('Process')
  let s:Msg = a:V.import('Vim.Message')
endfunction


function! s:new_from_excmd(excmd) abort
  return {
  \ 'excmd': a:excmd,
  \ 'open': function('s:_ExcmdOpener_open'),
  \}
endfunction

function! s:new_from_shellcmd(system_args, background, use_vimproc) abort
  return {
  \ 'system_args': a:system_args,
  \ 'background': a:background,
  \ 'use_vimproc': a:use_vimproc,
  \ 'open': function('s:_ShellCmdOpener_open'),
  \}
endfunction

function! s:_ExcmdOpener_open() abort dict
  try
    execute self.excmd
    return 1
  catch
    call s:Msg.error('open-browser failed to open in vim...: '
    \          . 'v:exception = ' . v:exception
    \          . ', v:throwpoint = ' . v:throwpoint)
    return 0
  endtry
endfunction

function! s:_ShellCmdOpener_open() abort dict
  try
    call s:Process.system(
    \   self.system_args,
    \   {'use_vimproc': self.use_vimproc, 'background': self.background}
    \)
    " Cannot check v:shell_error here
    " because browser is spawned in background process
    " so can't check its return value.
    return 1
  catch
    call s:Msg.error('open-browser failed to open URI...')
    call s:Msg.error('v:exception = ' . v:exception)
    call s:Msg.error('v:throwpoint = ' . v:throwpoint)
    return 0
  endtry
endfunction


let &cpo = s:save_cpo
