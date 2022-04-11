"=============================================================================
" repl.vim --- REPL process support for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section repl, usage-repl
" @parentsection usage
" In language layer, REPL key bindings has been added. To start a REPL
" process, the default key binding is `SPC l s i` . Key bindings for sending
" code to REPL process only support following types: `line`, `selection` and
" `buffer` . All of the key binding is mapped to function
" `SpaceVim#plugins#repl#send`. The first argument is {type}. To send raw
" string, use `raw` as type, for example:
" >
"   call SpaceVim#plugins#repl#send('raw', 'print("hello world!")')
" >

let s:JOB = SpaceVim#api#import('job')
let s:VIM = SpaceVim#api#import('vim')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:WINDOW = SpaceVim#api#import('vim#window')
let s:STRING = SpaceVim#api#import('data#string')
let s:SPI = SpaceVim#api#import('unicode#spinners') 

let s:LOGGER =SpaceVim#logger#derive('repl')

augroup spacevim_repl
  autocmd!
  autocmd VimLeavePre * call s:close()
augroup END


function! SpaceVim#plugins#repl#start(ft) abort
  call s:LOGGER.info('start repl for filetype:' . a:ft)
  let exe = get(s:exes, a:ft, '')
  call s:LOGGER.info('get the command:' . a:ft)
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
" raw: send raw string to REPL process

function! SpaceVim#plugins#repl#send(type, ...) abort
  if !exists('s:job_id')
    echom('Please start REPL via the key binding "SPC l s i" first.')
  elseif s:job_id == 0
    echom('please restart the REPL')
  else
    if a:type ==# 'line'
      call s:JOB.send(s:job_id, [getline('.'), ''])
    elseif a:type ==# 'raw'
      let context = get(a:000, 0, '')
      if !empty(context) && s:VIM.is_string(context)
        call s:JOB.send(s:job_id, context)
      endif
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
  call s:open_windows()
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

function! s:remove_lf(data) abort
  return map(a:data, 'substitute(v:val, nr2char(13) . "$", "", "g")')
endfunction

function! s:on_stdout(job_id, data, event) abort
  if bufexists(s:bufnr)
    call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, s:remove_lf(a:data))
    let s:lines += len(a:data)
    if s:WINDOW.get_cursor(s:winid)[0] == s:BUFFER.line_count(s:bufnr) - len(a:data)
      call s:WINDOW.set_cursor(s:winid, [s:BUFFER.line_count(s:bufnr), 0])
    endi
    call s:update_statusline()
  endif
endfunction

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

function! s:close_repl() abort
  " stop the job if it is running.
  if exists('s:job_id') && s:job_id > 0
    call s:JOB.stop(s:job_id)
    let s:job_id = 0
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

let s:bufnr = 0
let s:winid = -1
function! s:open_windows() abort
  if s:bufnr != 0 && bufexists(s:bufnr)
    exe 'bd ' . s:bufnr
  endif
  botright split __REPL__
  let lines = &lines * 30 / 100
  exe 'resize ' . lines
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable
  set filetype=SpaceVimREPL
  nnoremap <silent><buffer> q :call <SID>close()<cr>
  augroup spacevim_repl
    autocmd!
    autocmd BufWipeout <buffer> call <SID>close_repl()
  augroup END
  let s:bufnr = bufnr('%')
  let s:winid = win_getid(winnr())
  wincmd p
endfunction
