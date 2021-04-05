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

function! s:echo(msg) abort
  echon a:msg
endfunction

if !exists('g:cscope_cmd')
  if executable('cscope')
    let g:cscope_cmd = 'cscope'
  else
    call s:echo('cscope: command not found')
    finish
  endif
endif

let s:FILE = SpaceVim#api#import('file')
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
      call add(dirtyDirs, s:dbs[d].root)
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
      echohl WarningMsg | echo 'Can not find '.a:word.' with querytype as '.a:action.'.' | echohl None
    endtry
  endif
endfunction

function! s:RmDBfiles() abort
  let odbs = split(globpath(s:cscope_cache_dir, '*'), "\n")
  for f in odbs
    call delete(f, 'rf')
  endfor
endfunction


function! s:CheckNewFile(dir, newfile) abort
  let dir = s:FILE.path_to_fname(a:dir)
  let id = s:dbs[dir]['id']
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


function! s:ListFiles(dir) abort
  let d = []
  let f = []
  let cwd = a:dir
  try
    while cwd != ''
      let a = split(globpath(cwd, '*'), "\n")
      for fn in a
        if getftype(fn) ==# 'dir'
          if !exists('g:cscope_ignored_dir') || fn !~? g:cscope_ignored_dir
            call add(d, fn)
          endif
        elseif getftype(fn) !=# 'file'
          continue
        else
          if stridx(fn, ' ') !=# -1
            let fn = '"'.fn.'"'
          endif
          call add(f, fn)
        endif
      endfor
      let cwd = len(d) ? remove(d, 0) : ''
    endwhile
  catch /^Vim:Interrupt$/
  catch
    echo 'caught' v:exception
  endtry
  return f
endfunction

""
" update all existing cscope databases in case that you disable cscope database
" auto update.
function! cscope#update_databeses() abort
  call s:updateDBs(map(keys(s:dbs), 's:dbs[v:val].root'))
endfunction


""
" Create databases for current project
function! cscope#create_databeses() abort
  let dir = SpaceVim#plugins#projectmanager#current_root()
  call s:InitDB(dir)
endfunction


" 0 -- loaded
" 1 -- cancelled
function! s:AutoloadDB(dir) abort
  let ret = 0
  let m_dir = s:GetBestPath(a:dir)
  if m_dir == ''
    echohl WarningMsg | echo 'Can not find proper cscope db, please input a path to generate cscope db for.' | echohl None
    let m_dir = input('', a:dir, 'dir')
    if m_dir !=# ''
      let m_dir = s:CheckAbsolutePath(m_dir, a:dir)
      call s:InitDB(m_dir)
      call s:LoadDB(m_dir)
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
    call s:CreateDB(d, 0)
  endfor
  call s:FlushIndex()
endfunction


""
" clear databases
function! cscope#clear_databases(...) abort
  silent cs kill -1
  if a:0 == 0
    let s:dbs = {}
    call s:RmDBfiles()
  else
    let dir = s:FILE.path_to_fname(a:1)
    let id = s:dbs[dir]['id']
    call delete(s:cscope_cache_dir. dir . '/cscope.files')
    call delete(s:cscope_cache_dir. dir . '/cscope.db')
    unlet s:dbs[dir]
    call s:echo('database cleared: ' . s:cscope_cache_dir. dir .'/cscope.db')
    call s:FlushIndex()
  endif
endfunction

" complete function for command :CscopeClear
function! cscope#listDirs(A,L,P) abort
  return map(keys(s:dbs), 's:dbs[v:val].root')
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
  let f = s:FILE.path_to_fname(a:dir)
  let bestDir = ''
  for d in keys(s:dbs)
    if stridx(f, d) == 0 && len(d) > len(bestDir)
      return s:dbs[d].root
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

function! s:InitDB(dir) abort
  let id = localtime()
  let dir = s:FILE.path_to_fname(a:dir)
  let s:dbs[dir] = {}
  let s:dbs[dir]['id'] = id
  let s:dbs[dir]['loadtimes'] = 0
  let s:dbs[dir]['dirty'] = 0
  let s:dbs[dir]['root'] = a:dir
  call s:CreateDB(a:dir, 1)
  call s:FlushIndex()
endfunction


function! s:add_databases(db) abort
  exe 'silent cs add ' . a:db
  if cscope_connection(2, a:db) == 1
    call s:echo('cscope added: ' . a:db)
    return 0
  else
    return 1
  endif
endfunction

function! s:LoadDB(dir) abort
  let dir = s:FILE.path_to_fname(a:dir)
  silent cs kill -1
  call s:add_databases(s:cscope_cache_dir . dir .'/cscope.db')
  let s:dbs[dir]['loadtimes'] = s:dbs[dir]['loadtimes'] + 1
  call s:FlushIndex()
endfunction

function! cscope#list_databases() abort
  let dirs = keys(s:dbs)
  if len(dirs) == 0
    echo 'You have no cscope dbs now.'
  else
    let s = ['  PROJECT_ROOT                   LOADTIMES']
    for d in dirs
      let id = s:dbs[d]['id']
      if cscope_connection(2, s:cscope_cache_dir. d . '/cscope.db') == 1
        let l = printf('* %s                   %d', s:dbs[d].root, s:dbs[d]['loadtimes'])
      else
        let l = printf('  %s                   %d', s:dbs[d].root, s:dbs[d]['loadtimes'])
      endif
      call add(s, l)
    endfor
    echo join(s, "\n")
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
      call s:InitDB(m_dir)
    endif
    call s:LoadDB(m_dir)
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

function! s:CreateDB(dir, init) abort
  let dir = s:FILE.path_to_fname(a:dir)
  let id = s:dbs[dir]['id']
  let cscope_files = s:cscope_cache_dir . dir . '/cscope.files'
  let cscope_db = s:cscope_cache_dir . dir . '/cscope.db'
  if ! isdirectory(s:cscope_cache_dir . dir)
    call mkdir(s:cscope_cache_dir . dir)
  endif
  if !filereadable(cscope_files) || a:init
    let files = s:ListFiles(a:dir)
    call writefile(files, cscope_files)
  endif
  try
    exec 'silent cs kill '.cscope_db
  catch
  endtry
  let save_x = @x
  redir @x
  exec 'silent !'.g:cscope_cmd.' -b -i '.cscope_files.' -f'.cscope_db
  redi END
  if @x =~# "\nCommand terminated\n"
    echohl WarningMsg | echo 'Failed to create cscope database for ' . a:dir | echohl None
  else
    let s:dbs[dir]['dirty'] = 0
    call s:echo('database created: ' . cscope_db)
  endif
  let @x = save_x
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
