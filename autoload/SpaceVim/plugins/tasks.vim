"=============================================================================
" tasks.vim --- tasks support
" Copyright (c) 2016-2022 Wang Shidong & Contributors
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
let s:VIM = SpaceVim#api#import('vim')
let s:BUF = SpaceVim#api#import('vim#buffer')

" task object

let s:select_task = {}
let s:task_config = {}
let s:task_viewer_bufnr = -1
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
  let s:task_config = extend(global_conf, local_conf)
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
  let s:select_task = s:task_config[a:taskName]
endfunction

function! s:pick() abort
  let s:select_task = {}
  let ques = []
  for key in keys(s:task_config)
    if has_key(s:task_config[key], 'isGlobal') && s:task_config[key].isGlobal
      let task_name = key . '(global)'
    elseif has_key(s:task_config[key], 'isDetected') && s:task_config[key].isDetected
      let task_name = s:task_config[key].detectedName . key . '(detected)'
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

function! s:expand_task(task) abort
  let task = a:task
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
  if has_key(task, 'args') && s:VIM.is_list(task.args)
    let task.args = map(task.args, 's:replace_variables(v:val)')
  endif
  if has_key(task, 'options') && type(task.options) ==# 4
    if has_key(task.options, 'cwd') && type(task.options.cwd) ==# 1
      let task.options.cwd = s:replace_variables(task.options.cwd)
    endif
  endif
  return task
endfunction

function! SpaceVim#plugins#tasks#get() abort
  call s:load()
  for Provider in s:providers
    call extend(s:task_config, call(Provider, []))
  endfor
  call s:init_variables()
  let task = s:expand_task(s:pick())
  return task
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" list all the tasks
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! SpaceVim#plugins#tasks#list() abort
  call s:load()
  for Provider in s:providers
    call extend(s:task_config, call(Provider, []))
  endfor
  call s:init_variables()
  call s:open_tasks_list_win()
  call s:update_tasks_win_context()
endfunction


function! SpaceVim#plugins#tasks#complete(...) abort



endfunction


function! s:open_tasks_list_win() abort
  if s:task_viewer_bufnr != 0 && bufexists(s:task_viewer_bufnr)
    exe 'bd ' . s:task_viewer_bufnr
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
  let s:task_viewer_bufnr = bufnr('%')
  nnoremap <buffer><silent> <Enter> :call <SID>open_task()<cr>
endfunction

function! s:open_task() abort
  let line = getline('.')
  if line =~# '^\[.*\]'
    let task = matchstr(line, '^\[.*\]')[1:-2]
    if line =~# '^\[.*\]\s\+detected'
      let task = split(task, ':')[1]
    endif
    let task = s:expand_task(s:task_config[task])
    call SpaceVim#mapping#SmartClose()
    call SpaceVim#plugins#runner#run_task(task)
  else
    " not on a task
  endif
endfunction

function! s:update_tasks_win_context() abort
  let lines = ['Task                    Type          Description']
  for task in keys(s:task_config)
    if has_key(s:task_config[task], 'isGlobal') && s:task_config[task].isGlobal ==# 1
      let line = '[' . task . ']' . repeat(' ', 22 - strlen(task))
      let line .= 'global        '
    elseif has_key(s:task_config[task], 'isDetected') && s:task_config[task].isDetected ==# 1
      let line = '[' . s:task_config[task].detectedName . task . ']' . repeat(' ', 22 - strlen(task . s:task_config[task].detectedName))
      let line .= 'detected      '
    else
      let line = '[' . task . ']' . repeat(' ', 22 - strlen(task))
      let line .= 'local         '
    endif
    let line .= get(s:task_config[task], 'description', s:task_config[task].command . ' ' .  join(get(s:task_config[task], 'args', []), ' '))
    call add(lines, line)
  endfor
  call s:BUF.buf_set_lines(s:task_viewer_bufnr, 0, -1, 0, sort(lines))
endfunction

function! SpaceVim#plugins#tasks#edit(...) abort
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

function! SpaceVim#plugins#tasks#reg_provider(provider) abort
  call add(s:providers, a:provider)
endfunction

call SpaceVim#plugins#tasks#reg_provider(function('s:detect_npm_tasks'))
