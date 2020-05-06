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
let s:providers = []


function! s:load() abort
  let [global_conf, local_conf] = [{}, {}]
  if filereadable(expand('~/.SpaceVim.d/tasks.toml'))
    let global_conf = s:TOML.parse_file(expand('~/.SpaceVim.d/tasks.toml'))
    for task_key in keys(global_conf)
      let global_conf[task_key]['isGlobal'] = 1
    endfor
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
    if has_key(s:conf[key], 'isGlobal') && s:conf[key].isGlobal
      let task_name = key . '(global)'
    elseif has_key(s:conf[key], 'isDetected') && s:conf[key].isDetected
      let task_name = s:conf[key].detectedName . key . '(detected)'
    else
      let task_name = key
    endif
    call add(ques, [task_name, function('s:select_task'), [key]])
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
  for Provider in s:providers
    call extend(s:conf, call(Provider, []))
  endfor
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
  if has_key(task, 'options') && type(task.options) ==# 4
    if has_key(task.options, 'cwd') && type(task.options.cwd) ==# 1
      let task.options.cwd = s:replace_variables(task.options.cwd)
    endif
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

function! s:detect_npm_tasks() abort
  let detect_task = {}
  let conf = {}
  if filereadable('package.json')
    let conf = s:JSON.json_decode(join(readfile('package.json', ''), ''))
  endif
  if has_key(conf, 'scripts')
    for task_name in keys(conf.scripts)
      call extend(detect_task, {
            \ task_name : {'command' : conf.scripts[task_name], 'isDetected' : 1, 'detectedName' : 'npm:'}
            \ })
    endfor
  endif
  return detect_task
endfunction

function! SpaceVim#plugins#tasks#reg_provider(provider)
  call add(s:providers, a:provider)
endfunction

call SpaceVim#plugins#tasks#reg_provider(funcref('s:detect_npm_tasks'))
