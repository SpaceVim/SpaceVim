"=============================================================================
" tasks.vim --- tasks support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" this plugin is based on vscode task Scheme
" https://code.visualstudio.com/docs/editor/tasks-appendix

""
" @section tasks, usage-tasks
" @parentsection usage
" general guide for tasks manager in SpaceVim.

let s:TOML = SpaceVim#api#import('data#toml')
let s:JSON = SpaceVim#api#import('data#json')
let s:FILE = SpaceVim#api#import('file')
let s:CMP = SpaceVim#api#import('vim#compatible')
let s:SYS = SpaceVim#api#import('system')
let s:MENU = SpaceVim#api#import('cmdlinemenu')

" task object

let s:self = {}
let s:select_task = {}
let s:conf = []
let s:bufnr = -1
let s:variables = {}


function! s:load() abort
  let [global_conf, local_conf] = [{}, {}]
  if filereadable(expand('~/.SpaceVim.d/tasks.toml'))
    let global_conf = s:TOML.parse_file(expand('~/.SpaceVim.d/tasks.toml'))
  endif
  if filereadable('.SpaceVim.d/tasks.toml')
    let local_conf = s:TOML.parse_file('.SpaceVim.d/tasks.toml')
  endif
  let s:conf = extend(global_conf, local_conf)
endfunction

function! s:init_variables() abort
  let s:variables.workspaceFolder = s:FILE.unify_path(SpaceVim#plugins#projectmanager#current_root())
  let s:variables.workspaceFolderBasename = fnamemodify(s:variables.workspaceFolder, ':t')
  let s:variables.file = s:FILE.unify_path(expand('%:p'))
  let s:variables.relativeFile = s:FILE.unify_path(expand('%'), ':.')
  let s:variables.relativeFileDirname = s:FILE.unify_path(expand('%'), ':h')
  let s:variables.fileBasename = expand('%:t')
  let s:variables.fileBasenameNoExtension = expand('%:t:r')
  let s:variables.fileDirname = s:FILE.unify_path(expand('%:p:h'))
  let s:variables.fileExtname = expand('%:e')
  let s:variables.lineNumber = line('.')
  let s:variables.selectedText = ''
  let s:variables.execPath = ''
endfunction

function! s:select_task(taskName) abort
  let s:select_task = s:conf[a:taskName]
endfunction

function! s:pick() abort
  let s:select_task = {}
  let ques = []
  for key in keys(s:conf)
    call add(ques, [key, function('s:select_task'), [key]])
  endfor
  call s:MENU.menu(ques)
  return s:select_task
endfunction

function! s:replace_variables(str) abort
  let str = a:str
  for key in keys(s:variables)
    let str = substitute(str, '${' . key . '}', s:variables[key], 'g')
  endfor
  return str
endfunction

function! SpaceVim#plugins#tasks#get()
  call s:load()
  call s:init_variables()
  let task = s:pick()
  if has_key(task, 'windows') && s:SYS.isWindows
    let task = task.windows
  elseif has_key(task, 'osx') && s:SYS.isOSX
    let task = task.osx
  elseif has_key(task, 'linux') && s:SYS.isLinux
    let task = task.linux
  endif
  if has_key(task, 'command') && type(task.command) ==# 1
    let task.command = s:replace_variables(task.command)
  endif
  return task
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" list all the tasks
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! SpaceVim#plugins#tasks#list()
  call s:load()
  call s:init_variables()
  call s:open_tasks_list_win()


endfunction


function! SpaceVim#plugins#tasks#complete(...)



endfunction


function! s:open_tasks_list_win() abort
  if s:bufnr != 0 && bufexists(s:bufnr)
    exe 'bd ' . s:bufnr
  endif
  botright split __tasks_info__
  let lines = &lines * 30 / 100
  exe 'resize ' . lines
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist nomodifiable
        \ noswapfile
        \ nowrap
        \ cursorline
        \ nospell
        \ nonu
        \ norelativenumber
        \ winfixheight
        \ nomodifiable
  set filetype=SpaceVimTasksInfo
  let s:bufnr = bufnr('%')
endfunction

function! SpaceVim#plugins#tasks#edit(...)
  if get(a:000, 0, 0)
    exe 'e ~/.SpaceVim.d/tasks.toml'
  else
    exe 'e .SpaceVim.d/tasks.toml'
  endif
endfunction
