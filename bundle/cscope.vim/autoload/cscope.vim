"=============================================================================
" cscope.vim --- cscope plugin
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

if exists('s:save_cpo')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

""
" @section Introduction, intro
" @order intro key-mappings dicts functions exceptions layers api faq
" cscope.vim is a smart cscope plugin for SpaceVim.
"
" It will try to find a proper cscope database for current file, then connect
" to it. If there is no proper cscope database for current file, you are
" prompted to specify a folder with a string like --
"
"     Can not find proper cscope db, please input a path to create cscope db
"     for.
"
" Then the plugin will create cscope database for you, connect to it, and find
" what you want. The found result will be listed in a location list window.
" Next
" time when you open the same file or other file that the cscope database can
" be
" used for, the plugin will connect to the cscope database automatically. You
" need not take care of anything about cscope database.
"
" When you have a file edited/added in those folders for which cscope
" databases
" have been created, cscove will automatically update the corresponding
" database.
"
" Cscove frees you from creating/connecting/updating cscope database, let you
" focus on code browsing.

" where to store cscope file?

let s:logger = SpaceVim#logger#derive('cscope')
let s:notify = SpaceVim#api#import('notify')
let s:notify.timeout = 5000
let s:box = SpaceVim#api#import('unicode#box')
let s:box.box_width = 40
let s:FILE = SpaceVim#api#import('file')
let s:JOB = SpaceVim#api#import('job')
let s:JSON = SpaceVim#api#import('data#json')
let s:cscope_cache_dir = s:FILE.unify_path('~/.cache/SpaceVim/cscope/')
let s:cscope_db_index = s:cscope_cache_dir.'index'
let s:dbs = {}

""
" search your {word} with {action} in the database suitable for current
" file.
function! cscope#find(action, word) abort
  let dirtyDirs = []
  for d in keys(s:dbs)
    if s:dbs[d]['dirty'] == 1
      call add(dirtyDirs, d)
    endif
  endfor
  if len(dirtyDirs) > 0
    call s:updateDBs(dirtyDirs)
  endif
  let dbl = s:AutoloadDB(SpaceVim#plugins#projectmanager#current_root())
  if dbl == 0
    try
      exe ':silent lcs f '.a:action.' '.a:word
      if g:cscope_open_location == 1
        lw
      endif
    catch
      let message = 'Can not find '.a:word.' with querytype as '.a:action.'.'
      let s:notify.notify_max_width = strwidth(message) + 10
      call s:notify.notify(message, 'WarningMsg')
    endtry
  elseif dbl == 2 " the database does not init, the process has been started.
      let message = 'start to init database, please try later!'
      let s:notify.notify_max_width = strwidth(message) + 10
      call s:notify.notify(message, 'WarningMsg')
  endif
endfunction

function! s:RmDBfiles() abort
  let odbs = split(globpath(s:cscope_cache_dir, '*'), "\n")
  for f in odbs
    call delete(f, 'rf')
  endfor
endfunction


function! s:CheckNewFile(dir, newfile) abort
  let id = s:dbs[a:dir]['id']
  let dir = s:FILE.path_to_fname(a:dir)
  let cscope_files = s:cscope_cache_dir. dir .'/cscope.files'
  let files = readfile(cscope_files)
  " @todo support threshold
  " if len(files) > g:cscope_split_threshold
  "   let cscope_files = s:cscope_cache_dir.id."_inc.files"
  "   if filereadable(cscope_files)
  "     let files = readfile(cscope_files)
  "   else
  "     let files = []
  "   endif
  " endif
  if count(files, a:newfile) == 0
    call add(files, a:newfile)
    call writefile(files, cscope_files)
  endif
endfunction

function! s:FlushIndex() abort
  call writefile([s:JSON.json_encode(s:dbs)], s:cscope_db_index)
endfunction


function! s:on_list_file_exit(id, date, event) abort

endfunction


let s:list_files_process = {}

function! s:list_files_stdout(id, data, event) abort
  call extend(s:list_files_process['jobid' . a:id].cscope_files, a:data)
endfunction

function! s:list_files_exit(id, date, event) abort
  if a:date == 0
    call writefile(s:list_files_process['jobid' . a:id].cscope_files,
          \ s:list_files_process['jobid' . a:id].cscope_files_path
          \ )
    call s:run_create_database_job(s:list_files_process['jobid' . a:id].dir,
          \ s:list_files_process['jobid' . a:id].cscope_files_path,
          \ s:list_files_process['jobid' . a:id].cscope_db,
          \ s:list_files_process['jobid' . a:id].load,
          \ )
  else
    call s:logger.warn('failed to list files in dir:' . s:list_files_process['jobid' . a:id].dir)
  endif
endfunction

function! s:list_project_files(dir, cscope_files, cscope_db, load) abort
  let jobid = s:JOB.start(['rg', '--color=never', '--files', a:dir], {
        \ 'on_stdout' : function('s:list_files_stdout'),
        \ 'on_exit' : function('s:list_files_exit')
        \ })
  let s:list_files_process['jobid' . jobid] = {
        \ 'jobid' : jobid,
        \ 'dir' : a:dir,
        \ 'cscope_files' : [],
        \ 'cscope_db' : a:cscope_db,
        \ 'load' : a:load,
        \ 'cscope_files_path' : a:cscope_files
        \ }
endfunction

""
" update all existing cscope databases in case that you disable cscope database
" auto update.
function! cscope#update_databeses() abort
  call s:updateDBs(keys(s:dbs))
endfunction


""
" Create databases for current project
function! cscope#create_databeses() abort
  let dir = SpaceVim#plugins#projectmanager#current_root()
  call s:init_database(dir, 0)
endfunction


" 0 -- loaded
" 1 -- cancelled
" 2 -- init db
function! s:AutoloadDB(dir) abort
  let ret = 0
  let m_dir = s:GetBestPath(a:dir)
  if m_dir == ''
    echohl WarningMsg | echo 'Can not find proper cscope db, please input a path to generate cscope db for.' | echohl None
    let m_dir = input('', a:dir, 'dir')
    if m_dir !=# ''
      let m_dir = s:CheckAbsolutePath(m_dir, a:dir)
      call s:init_database(m_dir, 1)
      let ret = 2
    else
      let ret = 1
    endif
  else
    let id = s:dbs[m_dir]['id']
    if cscope_connection(2, s:cscope_cache_dir. m_dir .'/cscope.db') == 0
      call s:LoadDB(s:dbs[m_dir].root)
    endif
  endif
  return ret
endfunction

function! s:updateDBs(dirs) abort
  for d in a:dirs
    call s:create_database(d, 0, 0)
  endfor
endfunction


""
" clear databases
function! cscope#clear_databases(...) abort
  silent cs kill -1
  if a:0 == 0
    let s:dbs = {}
    call s:notify.notify('All databases cleared!', 'String')
    call s:RmDBfiles()
  else
    let dir = s:FILE.path_to_fname(a:1)
    call delete(s:cscope_cache_dir. dir . '/cscope.files')
    call delete(s:cscope_cache_dir. dir . '/cscope.db')
    unlet s:dbs[a:1]
    let message = 'databases cleared:' . a:1
    let s:notify.notify_max_width = strwidth(message) + 10
    call s:notify.notify(message, 'WarningMsg')
    call s:logger.info('database cleared: ' . s:cscope_cache_dir. dir .'/cscope.db')
    call s:FlushIndex()
  endif
endfunction

" complete function for command :CscopeClear
function! cscope#listDirs(A,L,P) abort
  return keys(s:dbs)
endfunction

function! ToggleLocationList() abort
  let l:own = winnr()
  lw
  let l:cwn = winnr()
  if(l:cwn == l:own)
    if &buftype ==# 'quickfix'
      lclose
    elseif len(getloclist(winnr())) > 0
      lclose
    else
      echohl WarningMsg | echo 'No location list.' | echohl None
    endif
  endif
endfunction

function! s:GetBestPath(dir) abort
  let f = a:dir
  let bestDir = ''
  for d in keys(s:dbs)
    if stridx(f, d) == 0 && len(d) > len(bestDir)
      return d
    endif
  endfor
  return ''
endfunction


function! s:CheckAbsolutePath(dir, defaultPath) abort
  let d = a:dir
  while 1
    if !isdirectory(d)
      echohl WarningMsg | echo 'Please input a valid path.' | echohl None
      let d = input('', a:defaultPath, 'dir')
    elseif (len(d) < 2 || (d[0] != '/' && d[1] != ':'))
      echohl WarningMsg | echo 'Please input an absolute path.' | echohl None
      let d = input('', a:defaultPath, 'dir')
    else
      break
    endif
  endwhile
  let d = s:FILE.unify_path(d)
  return d
endfunction


" init a database, a database should has following keys:
" 1. id: this will be removed
" 2. loadtimes:
" 3. dirty:
" 4. root: path of the project
"
" the argv: dir, load?
"
" if load == 1, the database will be loaded after init

function! s:init_database(dir, load) abort
  call s:logger.debug('start to init database for:' . a:dir)
  let id = localtime()
  let s:dbs[a:dir] = {}
  let s:dbs[a:dir]['id'] = id
  let s:dbs[a:dir]['loadtimes'] = 0
  let s:dbs[a:dir]['dirty'] = 0
  let s:dbs[a:dir]['root'] = a:dir
  call s:create_database(a:dir, 1, a:load)
endfunction


function! s:add_databases(db) abort
  exe 'silent cs add ' . a:db
  if cscope_connection(2, a:db) == 1
    call s:logger.info('cscope added: ' . a:db)
    return 0
  else
    return 1
  endif
endfunction

function! s:LoadDB(dir) abort
  let dir = s:FILE.path_to_fname(a:dir)
  silent cs kill -1
  call s:add_databases(s:cscope_cache_dir . dir .'/cscope.db')
  let s:dbs[a:dir]['loadtimes'] = s:dbs[a:dir]['loadtimes'] + 1
  call s:FlushIndex()
endfunction

function! cscope#list_databases() abort
  let dirs = keys(s:dbs)
  let databases = []
  if len(dirs) == 0
    call s:notify.notify('no cscope dbs now.', 'WarningMsg')
    call s:notify.notify('Press SPC m c i to init.', 'WarningMsg')
  else
    for d in dirs
      let id = s:dbs[d]['id']
      if cscope_connection(2, s:cscope_cache_dir. d . '/cscope.db') == 1
        " let l = printf('* %s                   %d', s:dbs[d].root, )
        let l = {
              \ 'project' : '* ' .d,
              \ 'loadtimes' : s:dbs[d]['loadtimes']
              \ }
      else
        let l = {
              \ 'project' : ' ' .d,
              \ 'loadtimes' : s:dbs[d]['loadtimes']
              \ }
      endif
      call add(databases, l)
    endfor
    let table = s:box.drawing_table(s:JSON.json_encode(databases), ['project', 'loadtimes'])
    echo join(table, "\n")
  endif
endfunction

function! cscope#loadIndex() abort
  let s:dbs = {}
  if ! isdirectory(s:cscope_cache_dir)
    call mkdir(s:cscope_cache_dir)
  elseif filereadable(s:cscope_db_index)
    let s:dbs = s:JSON.json_decode(join(readfile(s:cscope_db_index, ''), ''))
  else
    call s:RmDBfiles()
  endif
endfunction

function! cscope#preloadDB() abort
  let dirs = split(g:cscope_preload_path, s:FILE.pathSeparator)
  for m_dir in dirs
    let m_dir = s:CheckAbsolutePath(m_dir, m_dir)
    let m_key = s:FILE.path_to_fname(m_dir)
    if !has_key(s:dbs, m_key)
      call s:init_database(m_dir, 1)
    endif
  endfor
endfunction

function! cscope#find_interactive(pat) abort
  call inputsave()
  let qt = input("\nChoose a querytype for '".a:pat."'(:help cscope-find)\n  c: functions calling this function\n  d: functions called by this function\n  e: this egrep pattern\n  f: this file\n  g: this definition\n  i: files #including this file\n  s: this C symbol\n  t: this text string\n\n  or\n  <querytype><pattern> to query `pattern` instead of '".a:pat."' as `querytype`, Ex. `smain` to query a C symbol named 'main'.\n> ")
  call inputrestore()
  if len(qt) > 1
    call cscope#find(qt[0], qt[1:])
  elseif len(qt) > 0
    call cscope#find(qt, a:pat)
  endif
  call feedkeys("\<CR>")
endfunction

function! cscope#onChange() abort
  let m_dir = s:GetBestPath(expand('%:p:h'))
  if m_dir != ''
    let s:dbs[m_dir]['dirty'] = 1
    call s:FlushIndex()
    call s:CheckNewFile(s:dbs[m_dir].root, expand('%:p'))
    redraw
  endif
endfunction

function! s:on_create_db_exit(id, data, event) abort
  let d = s:create_db_process['jobid' . a:id].dir
  if a:data !=# 0
    echohl WarningMsg | echo 'Failed to create cscope database for ' . d | echohl None
  else
    let s:dbs[d]['dirty'] = 0
    let message = 'database created for: ' . d
    let s:notify.notify_max_width = strwidth(message) + 10
    call s:notify.notify(message, 'WarningMsg')
    if s:create_db_process['jobid' . a:id].load
      call s:LoadDB(d)
    else
      call s:FlushIndex()
    endif
  endif
endfunction


let s:create_db_process = {}


" argvs:
" dir: the path of project
" init: init database?
" load: load after init
function! s:create_database(dir, init, load) abort
  let dir = s:FILE.path_to_fname(a:dir)
  let cscope_files = s:cscope_cache_dir . dir . '/cscope.files'
  let cscope_db = s:cscope_cache_dir . dir . '/cscope.db'
  try
    exec 'silent cs kill '.cscope_db
  catch
  endtry
  if !isdirectory(s:cscope_cache_dir . dir)
    call mkdir(s:cscope_cache_dir . dir)
  endif
  if !filereadable(cscope_files) || a:init
    call s:list_project_files(a:dir, cscope_files, cscope_db, a:load)
  endif
endfunction

function! s:run_create_database_job(dir, cscope_files, cscope_db, load) abort
  if !executable(g:cscope_cmd)
      call s:notify.notify('''cscope'' is not executable!', 'WarningMsg')
      return
  endif
  let jobid = s:JOB.start([g:cscope_cmd, '-b', '-i', a:cscope_files, '-f', a:cscope_db], {
        \ 'on_exit' : function('s:on_create_db_exit')
        \ })
  let s:create_db_process['jobid' . jobid] = {
        \ 'jobid' : jobid,
        \ 'dir' : a:dir,
        \ 'load' : a:load,
        \ 'cscope_db' : a:cscope_db,
        \ }

endfunction

""
" toggle the location list for found results.
function! cscope#toggleLocationList() abort

endfunction

function! cscope#process_data(query) abort
  let data = cscope#execute_command(a:query)

  let results = []

  for i in split(data, '\n')
    call add(results, cscope#line_parse(i))
  endfor

  return results
endfunction

function! cscope#find_this_symbol(keyword) abort
  return 'cscope -d -L0 ' . shellescape(a:keyword)
endfunction

function! cscope#global_definition(keyword) abort
  return 'cscope -d -L1 ' . shellescape(a:keyword)
endfunction

function! cscope#functions_called_by(keyword) abort
  return 'cscope -d -L2 ' . shellescape(a:keyword)
endfunction

function! cscope#functions_calling(keyword) abort
  return 'cscope -d -L3 ' . shellescape(a:keyword)
endfunction

function! cscope#text_string(keyword) abort
  return 'cscope -d -L4 ' . shellescape(a:keyword)
endfunction

function! cscope#egrep_pattern(keyword) abort
  return 'cscope -d -L6 ' . shellescape(a:keyword)
endfunction

function! cscope#find_file(keyword) abort
  return 'cscope -d -L7 ' . shellescape(a:keyword)
endfunction

function! cscope#including_this_file(keyword) abort
  return 'cscope -d -L8 ' . shellescape(a:keyword)
endfunction

function! cscope#assignments_to_symbol(keyword) abort
  return 'cscope -d -L9 ' . shellescape(a:keyword)
endfunction

function! cscope#line_parse(line) abort
  let details = split(a:line)
  return {
        \    'line': a:line,
        \    'file_name': details[0],
        \    'function_name': details[1],
        \    'line_number': str2nr(details[2], 10),
        \    'code_line': join(details[3:])
        \  }
endfunction


""
" @section FAQ, faq
" This is a section of all the faq about this plugin.

""
" @section KEY MAPPINGS, key-mappings
" The default key mappings has been removed from the plugin itself, since
" users may prefer different choices.
"
" So to use the plugin, you must define your own key mappings first.
"
" Below is the minimum key mappings.
" >
"   nnoremap <leader>fa :call cscope#findInteractive(expand('<cword>'))<CR>
"   nnoremap <leader>l :call cscope#toggleLocationList()<CR>
" <
"
" Some optional key mappings to search directly.
" >
"   s: Find this C symbol
"   nnoremap  <leader>fs :call cscope#find('s', expand('<cword>'))<CR>
"   " g: Find this definition
"   nnoremap  <leader>fg :call cscope#find('g', expand('<cword>'))<CR>
"   " d: Find functions called by this function
"   nnoremap  <leader>fd :call cscope#find('d', expand('<cword>'))<CR>
"   " c: Find functions calling this function
"   nnoremap  <leader>fc :call cscope#find('c', expand('<cword>'))<CR>
"   " t: Find this text string
"   nnoremap  <leader>ft :call cscope#find('t', expand('<cword>'))<CR>
"   " e: Find this egrep pattern
"   nnoremap  <leader>fe :call cscope#find('e', expand('<cword>'))<CR>
"   " f: Find this file
"   nnoremap  <leader>ff :call cscope#find('f', expand('<cword>'))<CR>
"   " i: Find files #including this file
"   nnoremap  <leader>fi :call cscope#find('i', expand('<cword>'))<CR>
" <

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et sw=2 cc=80:
