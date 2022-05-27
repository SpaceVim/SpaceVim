"=============================================================================
" tasks.vim --- tasks support
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:is_loaded')
  finish
else
  let s:is_loaded = 1
endif


" this plugin is based on vscode task Scheme
" https://code.visualstudio.com/docs/editor/tasks-appendix

""
" @section tasks, usage-tasks
" @parentsection usage
" To integrate with external tools, SpaceVim introduced a task manager system,
" which is similar to VSCode's tasks-manager.
" There are two kinds of task configurations file:
"
" - `~/.SpaceVim.d/tasks.toml`: global tasks configuration
" - `.SpaceVim.d/tasks.toml`: project local tasks configuration
"
" The tasks defined in the global tasks configuration can be overrided by
" project local tasks configuration.
"
" @subsection Key bindings
" >
"   Key binding     Description
"   SPC p t l       list all available tasks
"   SPC p t e       edit project tesk
"   SPC p t r       pick tesk to run
"   SPC p t c       clear tasks
" <
"
" @subsection custom task
" This is a basic task configuration for running `echo hello world`,
" and print the results to the runner window.
" >
"   [my-task]
"     command = 'echo'
"     args = ['hello world']
" <
"
" To run the task in the background, you need to set `isBackground` to `true`:
" >
"   [my-task]
"     command = 'echo'
"     args = ['hello world']
"     isBackground = true
" <
"
" The following task properties are available:
"
" 1. `command`:  The actual command to execute.
" 2. `args`: The arguments passed to the command, it should be a list of strings and may be omitted.
" 3. `options`: Override the defaults for `cwd`,`env` or `shell`.
" 4. `isBackground`: Specifies whether the task should run in the background. by default, it is `false`.
" 5. `description`: Short description of the task
" 6. `problemMatcher`: Problems matcher of the task
"
" Note: When a new task is executed, it will kill the previous task.
" If you want to keep the task, run it in background by setting
" `isBackground` to `true`.
"
" SpaceVim supports variable substitution in the task properties,
" The following predefined variables are supported:
"
" - `{workspaceFolder}`: The project's root directory
" - `{workspaceFolderBasename}`: The name of current project's root directory
" - `{file}`: The path of current file
" - `{relativeFile}`: The current file relative to project root
" - `{relativeFileDirname}`: The current file's dirname relative to workspaceFolder
" - `{fileBasename}`: The current file's basename
" - `{fileBasenameNoExtension}`: The current file's basename without file extension
" - `{fileDirname}`: The current file's dirname
" - `{fileExtname}`: The current file's extension
" - `{cwd}`: The task runner's current working directory on startup
" - `{lineNumber}`: The current selected line number in the active file
"
" For example: Supposing that you have the following requirements:
"
" A file located at `/home/your-username/your-project/folder/file.ext` opened in your editor;
" The directory `/home/your-username/your-project` opened as your root workspace.
" So you will have the following values for each variable:
"
" - `{workspaceFolder}`: `/home/your-username/your-project/`
" - `{workspaceFolderBasename}`: `your-project`
" - `{file}`: `/home/your-username/your-project/folder/file.ext`
" - `{relativeFile}`: `folder/file.ext`
" - `{relativeFileDirname}`: `folder/`
" - `{fileBasename}`: `file.ext`
" - `{fileBasenameNoExtension}`: `file`
" - `{fileDirname}`: `/home/your-username/your-project/folder/`
" - `{fileExtname}`: `.ext`
" - `{lineNumber}`: line number of the cursor
"
" @subsection Task Problems Matcher
"
" Problem matcher is used to capture the message in the task output
" and show a corresponding problem in quickfix windows.
"
" `problemMatcher` supports `errorformat` and `pattern` properties.
"
" If the `errorformat` property is not defined, the `&errorformat` option will be used.
" >
"   [test_problemMatcher]
"     command = "echo"
"     args = ['.SpaceVim.d/tasks.toml:6:1 test error message']
"     isBackground = true
"   [test_problemMatcher.problemMatcher]
"     useStdout = true
"     errorformat = '%f:%l:%c\ %m'
" <
"
" If `pattern` is defined, the `errorformat` option will be ignored.
" Here is an example:
" >
"   [test_regexp]
"     command = "echo"
"     args = ['.SpaceVim.d/tasks.toml:12:1 test error message']
"     isBackground = true
"   [test_regexp.problemMatcher]
"     useStdout = true
"   [test_regexp.problemMatcher.pattern]
"     regexp = '\(.*\):\(\d\+\):\(\d\+\)\s\(\S.*\)'
"     file = 1
"     line = 2
"     column = 3
"     #severity = 4
"     message = 4
" <
"
" @subsection Task auto-detection
"
" Currently, SpaceVim can auto-detect tasks for npm.
" the tasks manager will parse the `package.json` file for npm packages.
"
" @subsection Task provider
"
" Some tasks can be automatically detected by the task provider. For example,
" a Task Provider could check if there is a specific build file, such as `package.json`,
" and create npm tasks.
"
" To build a task provider, you need to use the Bootstrap function.
" The task provider should be a vim function that returns a task object.
"
" here is an example for building a task provider.
"
" >
"    function! s:make_tasks() abort
"      if filereadable('Makefile')
"        let subcmds = filter(readfile('Makefile', ''), "v:val=~#'^.PHONY'")
"        let conf = {}
"        for subcmd in subcmds
"          let commands = split(subcmd)[1:]
"          for cmd in commands
"            call extend(conf, {
"                  \ cmd : {
"                    \ 'command': 'make',
"                    \ 'args' : [cmd],
"                    \ 'isDetected' : 1,
"                    \ 'detectedName' : 'make:'
"                    \ }
"                    \ })
"          endfor
"        endfor
"        return conf
"      else
"        return {}
"      endif
"    endfunction
"    call SpaceVim#plugins#tasks#reg_provider(function('s:make_tasks'))
" <
"
" With the above configuration, you will see the following tasks in the SpaceVim repo:

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
    call SpaceVim#mapping#SmartClose()
    call SpaceVim#plugins#runner#run_task(s:expand_task(s:task_config[task]))
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
