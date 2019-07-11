"=============================================================================
" todo.vim --- todo manager for SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')

" @question any other recommanded tag?
let s:labels = map(['fixme', 'question', 'todo', 'idea'], '"@" . v:val')

function! SpaceVim#plugins#todo#list() abort
  call s:open_win()
endfunction

let s:bufnr = 0

function! s:open_win() abort
  if s:bufnr != 0 && bufexists(s:bufnr)
    exe 'bd ' . s:bufnr
  endif
  botright split __todo_manager__
  let lines = &lines * 30 / 100
  exe 'resize ' . lines
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable
  set filetype=SpaceVimTodoManager
  let s:bufnr = bufnr('%')
  call s:update_todo_content()
  nnoremap <buffer><silent> <Enter> :call <SID>open_todo()<cr>
endfunction

" @todo Improve todo manager
function! s:update_todo_content() abort
  let s:todos = []
  let s:todo = {}
  " @fixme fix the rg command for todo manager
  let argv = ['rg','--hidden', '--no-heading', '-g', '!.git', '--color=never', '--with-filename', '--line-number', '--column', '-e', join(s:labels, '|'), '.']
  call SpaceVim#logger#info('todo cmd:' . string(argv))
  let jobid = s:JOB.start(argv, {
        \ 'on_stdout' : function('s:stdout'),
        \ 'on_stderr' : function('s:stderr'),
        \ 'on_exit' : function('s:exit'),
        \ })
  call SpaceVim#logger#info('todo jobid:' . string(jobid))
endfunction

function! s:stdout(id, data, event) abort
  call SpaceVim#logger#info('todomanager stdout: ' . string(a:data))
  for data in a:data
    if !empty(data)
      let file = fnameescape(split(data, ':\d\+:')[0])
      let line = matchstr(data, ':\d\+:')[1:-2]
      let column = matchstr(data, '\(:\d\+\)\@<=:\d\+:')[1:-2]
      let lebal = matchstr(data, join(s:labels, '\|'))
      let title = split(data, lebal)[1]
      " @todo add time tag
      call add(s:todos, 
            \ {
            \ 'file' : file,
            \ 'line' : line,
            \ 'column' : column,
            \ 'title' : title,
            \ 'lebal' : lebal,
            \ }
            \ )
    endif
  endfor
endfunction

function! s:stderr(id, data, event) abort
  call SpaceVim#logger#info('todomanager stderr: ' . string(a:data))
endfunction

function! s:exit(id, data, event ) abort
  call SpaceVim#logger#info('todomanager exit: ' . string(a:data))
  let s:todos = sort(s:todos, function('s:compare_todo'))
  let label_w = max(map(deepcopy(s:todos), 'strlen(v:val.lebal)'))
  let file_w = max(map(deepcopy(s:todos), 'strlen(v:val.file)'))
  let expr = "v:val.lebal . repeat(' ', label_w - strlen(v:val.lebal)) . ' ' ."
        \ .  "SpaceVim#api#import('file').unify_path(v:val.file, ':.') . repeat(' ', file_w - strlen(v:val.file)) . ' ' ."
        \ .  "v:val.title"
  let lines = map(deepcopy(s:todos),expr)
  call s:BUFFER.buf_set_lines(s:bufnr, 0 , -1, 0, lines)
endfunction

function! s:compare_todo(a, b) abort
  let a = index(s:labels, a:a.lebal)
  let b = index(s:labels, a:b.lebal)
  return a == b ? 0 : a > b ? 1 : -1
endfunction

function! s:open_todo() abort
  let todo = s:todos[line('.') - 1]
  try
    close
  catch
  endtry
  exe 'e ' . todo.file
  call cursor(todo.line, todo.column)
  noautocmd normal! :
endfunction

" @todo fuzzy find todo list
" after open todo manager buffer, we should be able to fuzzy find the item we
" need.

