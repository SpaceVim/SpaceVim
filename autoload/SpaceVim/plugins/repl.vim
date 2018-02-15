"=============================================================================
" repl.vim --- REPL process support for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:STRING = SpaceVim#api#import('data#string')

augroup spacevim_repl
  autocmd!
  autocmd VimLeavePre * call s:close()
augroup END


function! SpaceVim#plugins#repl#start(ft) abort

  let exe = get(s:exes, a:ft, '')

  if !empty(exe)
    call s:start(exe)
  else
    echohl WarningMsg
    echo 'no REPL executable for current filetype'
    echohl None
  endif

endfunction

" supported argvs:
" buffer: send current buffer to REPL process
" line: send line under cursor to REPL process
" selection: send selection text to REPL process

function! SpaceVim#plugins#repl#send(type) abort
  if a:type ==# 'line'
    call s:JOB.send(s:job_id, [getline('.'), ''])
  elseif a:type ==# 'buffer'
    call s:JOB.send(s:job_id, getline(1, '$') + [''])
  elseif a:type ==# 'selection'
    let begin = getpos("'<")
    let end = getpos("'>")
    if begin[1] != 0 && end[1] != 0
      call s:JOB.send(s:job_id, getline(begin[1], end[1]) + [''])
    else
      echohl WarningMsg
      echo 'no selection text'
      echohl None
    endif
  else
  endif
endfunction



function! s:start(exe) abort
  let s:lines = 0
  let s:status = {
        \ 'is_running' : 1,
        \ 'is_exit' : 0,
        \ 'has_errors' : 0,
        \ 'exit_code' : 0
        \ }
  let s:start_time = reltime()
  call s:open_windows()
  call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 3, 0, ['[REPL executable] ' . string(a:exe), '', repeat('-', 20)])
  let s:lines += 3
  let s:_out_data = ['']
  let s:_current_line = ''
  " this only for has('nvim') && exists('*chanclose')
  let s:_out_data = ['']
  let s:job_id =  s:JOB.start(a:exe,{
        \ 'on_stdout' : function('s:on_stdout'),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ })
endfunction

" @vimlint(EVL103, 1, a:job_id)
" @vimlint(EVL103, 1, a:data)
" @vimlint(EVL103, 1, a:event)

if has('nvim') && exists('*chanclose')
  function! s:on_stdout(job_id, data, event) abort
    let s:_out_data[-1] .= a:data[0]
    call extend(s:_out_data, a:data[1:])
    if s:_out_data[-1] ==# '' && len(s:_out_data) > 1
      call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, s:_out_data[:-2])
      let s:lines += len(s:_out_data) - 1
      let s:_out_data = ['']
    elseif  s:_out_data[-1] !=# '' && len(s:_out_data) > 1
      call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, s:_out_data[:-2])
      let s:lines += len(s:_out_data) - 1
      let s:_out_data = [s:_out_data[-1]]
    endif
  endfunction
else
  function! s:on_stdout(job_id, data, event) abort
    call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, a:data)
    let s:lines += len(a:data)
    call s:update_statusline()
  endfunction
endif

function! s:on_stderr(job_id, data, event) abort
  let s:status.has_errors = 1
  call s:on_stdout(a:job_id, a:data, a:event)
endfunction

function! s:on_exit(job_id, data, event) abort
  let s:end_time = reltime(s:start_time)
  let s:status.is_exit = 1
  let s:status.exit_code = a:data
  let done = ['', '[Done] exited with code=' . a:data . ' in ' . s:STRING.trim(reltimestr(s:end_time)) . ' seconds']
  if bufexists(s:bufnr)
    call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, done)
  endif
  call s:update_statusline()

endfunction

function! s:update_statusline() abort
  redrawstatus!
endfunction
" @vimlint(EVL103, 0, a:job_id)
" @vimlint(EVL103, 0, a:data)
" @vimlint(EVL103, 0, a:event)

function! s:close() abort
  if exists('s:job_id') && s:job_id != 0
    call s:JOB.stop(s:job_id)
    let s:job_id = 0
  endif
  if s:bufnr != 0 && bufexists(s:bufnr)
    exe 'bd ' s:bufnr
  endif
endfunction

let s:exes = {}

function! SpaceVim#plugins#repl#reg(ft, execute) abort

  call extend(s:exes, {a:ft : a:execute}) 

endfunction

function! SpaceVim#plugins#repl#status() abort
  if s:status.is_running == 1
    return 'running'
  elseif s:status.is_exit == 1
    return 'exit code : ' . s:status.exit_code 
          \ . '    time: ' . s:STRING.trim(reltimestr(s:end_time))
  endif
endfunction

let s:bufnr = 0
function! s:open_windows() abort
  if s:bufnr != 0 && bufexists(s:bufnr)
    exe 'bd ' . s:bufnr
  endif
  botright split __REPL__
  let lines = &lines * 30 / 100
  exe 'resize ' . lines
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
  set filetype=SpaceVimREPL
  nnoremap <silent><buffer> q :call <SID>close()<cr>
  let s:bufnr = bufnr('%')
  wincmd p
endfunction
