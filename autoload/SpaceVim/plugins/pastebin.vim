"=============================================================================
" pastebin.vim --- Pastebin support for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:JOB = SpaceVim#api#import('job')
let s:LOGGER =SpaceVim#logger#derive('pastebin')
let s:job_id = -1

function! SpaceVim#plugins#pastebin#paste() abort
  let s:url = ''
  let context = s:get_visual_selection()
  if empty(context)
    call s:LOGGER.info('no selection text, skipped.')
    return
  endif
  " let ft = &filetype
  if s:job_id != -1
    call s:LOGGER.info('previous job has not been finished, killed!')
    call s:JOB.stop(s:job_id)
  endif
  let cmd = 'curl -s -F "content=<-" http://dpaste.com/api/v2/'
  let s:job_id =  s:JOB.start(cmd,{
        \ 'on_stdout' : function('s:on_stdout'),
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_exit' : function('s:on_exit'),
        \ })
  call s:LOGGER.info('job id: '. s:job_id)
  call s:JOB.send(s:job_id, split(context, "\n"))
  call s:JOB.chanclose(s:job_id, 'stdin')
endfunction
function! s:on_stdout(job_id, data, event) abort
  for url in filter(a:data, '!empty(v:val)')
    call s:LOGGER.info('stdout: '. url)
    let s:url = url
  endfor
endfunction

function! s:on_stderr(job_id, data, event) abort
  call s:LOGGER.warn('stderr:' . string(a:data))
endfunction

function! s:on_exit(job_id, data, event) abort
  let s:job_id = -1
  if a:data ==# 0 && !empty(s:url)
    let @+ = s:url . '.txt'
    echo 'Pastbin: ' . s:url . '.txt'
  else
    call s:LOGGER.warn('exit code: ' . string(a:data))
    call s:LOGGER.warn('url: ' . s:url)
  endif
endfunction

" ref: https://stackoverflow.com/a/6271254
function! s:get_visual_selection() abort
  " Why is this not a built-in Vim script function?!
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  " check v-block mode
  if visualmode() ==# "\<C-v>"
    for i in range(len(lines))
      let lines[i] = lines[i][: column_end - (&selection ==# 'inclusive' ? 1 : 2)]
      let lines[i] = lines[i][column_start - 1:]
    endfor
  else
    let lines[-1] = lines[-1][: column_end - (&selection ==# 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
  endif
  return join(lines, "\n")
endfunction
