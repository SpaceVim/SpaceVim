"=============================================================================
" repl.vim --- REPL plugin for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:JOB = SpaceVim#api#import('job')
let s:VIM = SpaceVim#api#import('vim')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:WINDOW = SpaceVim#api#import('vim#window')
let s:STRING = SpaceVim#api#import('data#string')
let s:SPI = SpaceVim#api#import('unicode#spinners') 

" @todo direction configurable
" g:repl_direction
" g:repl_vertical
let s:direction = get(g:, 'repl_direction', 'botright split')
let s:vertical = get(g:, 'repl_vertical', 0)


" ======================================
" Init valuables
" ======================================
" s:bufnr: the buffer number of repl buffer
" s:winid: the window-ID of repl window. This value is for get/set cursor
" positions, and only works in new vim.
let s:bufnr = 0
let s:winid = -1

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
  if !exists('s:job_id')
    echom('Please start REPL via the key binding "SPC l s i" first.')
  elseif s:job_id == 0
    echom('please retart the REPL')
  else
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
    endif
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
  call s:open_repl_window(SpaceVim#plugins#repl#isopen()
        \ && SpaceVim#plugins#runner#isopen())
  call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 3, 0, ['[REPL executable] ' . string(a:exe), '', repeat('-', 20)])
  call s:WINDOW.set_cursor(s:winid, [s:BUFFER.line_count(s:bufnr), 0])
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
  call s:SPI.apply('dot1',  'g:_spacevim_repl_spinners')
endfunction

" @vimlint(EVL103, 1, a:job_id)
" @vimlint(EVL103, 1, a:data)
" @vimlint(EVL103, 1, a:event)

if has('nvim') && exists('*chanclose')
  function! s:on_stdout(job_id, data, event) abort
    let s:_out_data[-1] .= a:data[0]
    call extend(s:_out_data, a:data[1:])
    if s:_out_data[-1] ==# '' && len(s:_out_data) > 1
      if bufexists(s:bufnr)
        call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, map(s:_out_data[:-2], "substitute(v:val,  nr2char(13) . \"$\"', '', 'g')"))
        let s:lines += len(s:_out_data) - 1
        if s:WINDOW.get_cursor(s:winid)[0] == s:BUFFER.line_count(s:bufnr) - len(s:_out_data) + 1
          call s:WINDOW.set_cursor(s:winid, [s:BUFFER.line_count(s:bufnr), 0])
        endi
        call s:update_statusline()
      endif
      let s:_out_data = ['']
    elseif  s:_out_data[-1] !=# '' && len(s:_out_data) > 1
      if bufexists(s:bufnr)
        call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, map(s:_out_data[:-2], "substitute(v:val, '$', '', 'g')"))
        let s:lines += len(s:_out_data) - 1
        if s:WINDOW.get_cursor(s:winid)[0] == s:BUFFER.line_count(s:bufnr) - len(s:_out_data) + 1
          call s:WINDOW.set_cursor(s:winid, [s:BUFFER.line_count(s:bufnr), 0])
        endi
        call s:update_statusline()
      endif
      let s:_out_data = [s:_out_data[-1]]
    endif
  endfunction
else
  function! s:on_stdout(job_id, data, event) abort
    if bufexists(s:bufnr)
      call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, a:data)
      let s:lines += len(a:data)
      if s:WINDOW.get_cursor(s:winid)[0] == s:BUFFER.line_count(s:bufnr) - len(a:data)
        call s:WINDOW.set_cursor(s:winid, [s:BUFFER.line_count(s:bufnr), 0])
      endi
      call s:update_statusline()
    endif
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
  let s:job_id = 0
endfunction

function! s:update_statusline() abort
  redrawstatus!
endfunction
" @vimlint(EVL103, 0, a:job_id)
" @vimlint(EVL103, 0, a:data)
" @vimlint(EVL103, 0, a:event)



function! s:close() abort
  " stop the job if it is running.
  if exists('s:job_id') && s:job_id > 0
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
let g:_spacevim_repl_spinners = ''
function! SpaceVim#plugins#repl#status() abort
  if s:status.is_running == 1
    return 'running' . g:_spacevim_repl_spinners
  elseif s:status.is_exit == 1
    return 'exit code : ' . s:status.exit_code 
          \ . '    time: ' . s:STRING.trim(reltimestr(s:end_time))
  endif
endfunction



" ====================================
" REPL buffer manager
" ====================================
function! s:clear_buffer() abort
  if s:bufnr != 0 && bufexists(s:bufnr)
    call s:BUFFER.buf_set_lines(s:bufnr, 0 , -1, 0, [])
  endif
endfunction
function! s:init_buffer() abort
  let s:bufnr = s:BUFFER.bufadd('__REPL__')
  call s:VIM.setbufvar(s:bufnr,{
        \ 'filetype' : 'SpaceVimREPL',
        \ 'buftype' : 'nofile',
        \ 'buflisted' : 0,
        \ 'list' : 0,
        \ 'swapfile' : 0,
        \ 'cursorline' : 0,
        \ 'spell' : 0,
        \ 'number' : 0,
        \ 'relativenumber' : 0,
        \ 'winfixheight' : 1,
        \ 'modifiable' : 0,
        \ })
endfunction


function! s:open_repl_window(isopen) abort
  call s:init_buffer()
  if !a:isopen
    exe s:direction '__REPL__'
    if !s:vertical
      let lines = &lines * 30 / 100
      exe 'resize ' . lines
    endif
    nnoremap <silent><buffer> q :call <SID>close()<cr>
    " win_getid is 7.4.1557
    let s:winid = s:WINDOW.getid(bufwinnr(s:bufnr))
  else
    let s:winid = max([SpaceVim#plugins#repl#winid(), SpaceVim#plugins#runner#winid()])
    call s:WINDOW.set_buf(s:winid, s:bufnr)
  endif
  wincmd p
endfunction

function! SpaceVim#plugins#repl#toggle() abort

endfunction

function! SpaceVim#plugins#repl#isopen() abort
  return s:WINDOW.is_opened(s:winid)
endfunction

function! SpaceVim#plugins#repl#winid() abort
  return s:winid
endfunction
