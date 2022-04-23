"=============================================================================
" todo.vim --- todo manager for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section todo manager, plugins-todomanager
" @parentsection plugins
" The `todomanager` plugin provides todo manager support for SpaceVim.
" 
" @subsection Key bindings
" >
"   Key binding     Description
"   SPC a o         open todo manager windows
" <
" 
" @subsection Configuration
"
" The todo manager labels can be set via @section(options-todo_labels)

let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:SYS = SpaceVim#api#import('system')
let s:LOG = SpaceVim#logger#derive('todo')
let s:REG = SpaceVim#api#import('vim#regex')


let [
      \ s:grep_default_exe,
      \ s:grep_default_opt,
      \ s:grep_default_ropt,
      \ s:grep_default_expr_opt,
      \ s:grep_default_fix_string_opt,
      \ s:grep_default_ignore_case,
      \ s:grep_default_smart_case
      \ ] = SpaceVim#mapping#search#default_tool()

function! SpaceVim#plugins#todo#list() abort
  call s:open_win()
endfunction

let s:bufnr = -1
let s:todo_jobid = -1

function! s:open_win() abort
  if s:bufnr != 0 && bufexists(s:bufnr)
    exe 'bd ' . s:bufnr
  endif
  botright split __todo_manager__
  " @todo add win_getid api
  let s:winnr = winnr('#')
  let lines = &lines * 30 / 100
  exe 'resize ' . lines
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable
  set filetype=SpaceVimTodoManager
  let s:bufnr = bufnr('%')
  call s:update_todo_content()
  augroup spacevim_plugin_todo
    autocmd! * <buffer>
    autocmd WinEnter <buffer> call s:WinEnter()
  augroup END
  nnoremap <buffer><silent> <Enter> :call <SID>open_todo()<cr>
endfunction

function! s:WinEnter() abort
  " @todo add win_getid api
  let s:winnr = winnr('#')
endfunction

" @todo Improve todo manager
function! s:update_todo_content() abort
  if exists('g:spacevim_todo_labels')
        \ && type(g:spacevim_todo_labels) == type([])
        \ && !empty(g:spacevim_todo_labels)
    let s:labels = g:spacevim_todo_labels
    let s:prefix = g:spacevim_todo_prefix
  else
    let s:labels = ['fixme', 'question', 'todo', 'idea']
    let s:prefix = '@'
  endif

  let s:todos = []
  let s:todo = {}
  let s:labels_regex = s:get_labels_regex()
  let s:labels_partten = s:get_labels_pattern()
  let argv = [s:grep_default_exe] + 
        \ s:grep_default_opt +
        \ s:grep_default_expr_opt
  let argv += [s:labels_regex]
  if s:SYS.isWindows && (s:grep_default_exe ==# 'rg' || s:grep_default_exe ==# 'ag' || s:grep_default_exe ==# 'pt' )
    let argv += ['.']
  elseif s:SYS.isWindows && s:grep_default_exe ==# 'findstr'
    let argv += ['*.*']
  elseif !s:SYS.isWindows && s:grep_default_exe ==# 'rg'
    let argv += ['./']
  endif
  let argv += s:grep_default_ropt
  call s:LOG.info('cmd: ' . string(argv))
  call s:LOG.info('   labels_partten: ' . s:labels_partten)
  let s:todo_jobid = s:JOB.start(argv, {
        \ 'on_stdout' : function('s:stdout'),
        \ 'on_stderr' : function('s:stderr'),
        \ 'on_exit' : function('s:exit'),
        \ })
  call s:LOG.info('jobid: ' . string(s:todo_jobid))
endfunction

function! s:stdout(id, data, event) abort
  if a:id !=# s:todo_jobid
    return
  endif
  for data in a:data
    call s:LOG.info('stdout: ' . data)
    if !empty(data)
      let file = fnameescape(split(data, ':\d\+:')[0])
      let line = matchstr(data, ':\d\+:')[1:-2]
      let column = matchstr(data, '\(:\d\+\)\@<=:\d\+:')[1:-2]
      let label = matchstr(data, s:labels_partten)
      let title = get(split(data, label), 1, '')
      " @todo add time tag
      call add(s:todos, 
            \ {
            \ 'file' : file,
            \ 'line' : line,
            \ 'column' : column,
            \ 'title' : title,
            \ 'label' : label,
            \ }
            \ )
    endif
  endfor
endfunction

function! s:stderr(id, data, event) abort
  if a:id !=# s:todo_jobid
    return
  endif
  for date in a:data
    call s:LOG.info('stderr: ' . string(a:data))
  endfor
endfunction

function! s:exit(id, data, event ) abort
  if a:id !=# s:todo_jobid
    return
  endif
  call s:LOG.info('todomanager exit: ' . string(a:data))
  let s:todos = sort(s:todos, function('s:compare_todo'))
  let label_w = max(map(deepcopy(s:todos), 'strlen(v:val.label)'))
  let file_w = max(map(deepcopy(s:todos), 'strlen(v:val.file)'))
  let expr = "v:val.label . repeat(' ', label_w - strlen(v:val.label)) . ' ' ."
        \ .  "SpaceVim#api#import('file').unify_path(v:val.file, ':.') . repeat(' ', file_w - strlen(v:val.file)) . ' ' ."
        \ .  "v:val.title"
  let lines = map(deepcopy(s:todos),expr)
  call s:BUFFER.buf_set_lines(s:bufnr, 0 , -1, 0, lines)
endfunction

function! s:compare_todo(a, b) abort
  let a = index(s:labels, a:a.label)
  let b = index(s:labels, a:b.label)
  return a == b ? 0 : a > b ? 1 : -1
endfunction

function! s:open_todo() abort
  let todo = s:todos[line('.') - 1]
  try
    close
  catch
  endtry
  exe s:winnr .  'wincmd w'
  exe 'e ' . todo.file
  call cursor(todo.line, todo.column)
  noautocmd normal! :
endfunction

" @fixme expr for different tools
" when using rg,   [join(s:labels, '|')]
" when using grep, [join(s:labels, '\|')]
function! s:get_labels_regex()
  if s:grep_default_exe ==# 'rg'
    let separator = '|'
  elseif s:grep_default_exe ==# 'grep'
    let separator = '\|'
  elseif s:grep_default_exe ==# 'findstr'
    let separator = ' '
  else
    let separator = '|'
  endif

  return join(map(copy(s:labels), "s:prefix . v:val . '\\b'"),
  \ separator)
endfunc

function! s:get_labels_pattern()
  return s:REG.parser(s:get_labels_regex(), 0)
endfunc


" @todo fuzzy find todo list
" after open todo manager buffer, we should be able to fuzzy find the item we
" need.

