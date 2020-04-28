"=============================================================================
" find.vim --- vim plugin for find
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong 
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Loading SpaceVim api {{{
scriptencoding utf-8
let s:MPT = SpaceVim#api#import('prompt')
let s:JOB = SpaceVim#api#import('job')
" let s:SYS = SpaceVim#api#import('system')
" let s:BUFFER = SpaceVim#api#import('vim#buffer')
" let s:LIST = SpaceVim#api#import('data#list')
"}}}


let s:support_tools = ['find', 'fd']
let s:current_tool = 'find'
let s:MPT._prompt.mpt = ' ' . s:current_tool . ' '
let s:options = {}
let s:second_option = {}
let s:options.find = {
      \ '-amin' : 'File was last accessed n minutes ago.',
      \ '-anewer' : 'File was  last  accessed more recently than file was modified.',
      \ '-atime' : 'File was last accessed n*24 hours ago.',
      \ '-cmin' : "File's status was last changed n minutes ago.",
      \ '-cnewer' : "File's status was last changed more recently than file was modified.",
      \ '-ctime' : "File's status was last changed n*24 hours ago.",
      \ '-daystart' : 'Measure times from the beginning of today rather than from 24 hours ago.',
      \ '-depth' : "Process each directory's contents before the directory itself.",
      \ '-exec' : 'Execute command',
      \ '-false' : 'Make find command return false',
      \ '-fls' : 'True; like -ls but write to file like -fprint.',
      \ '-follow' : 'A diagnostic message is issued when find encounters a loop of symbolic links.',
      \ '-fprint' : 'True; print the full file name into file file.',
      \ '-fprintf' : 'True; like -printf but write to file like -fprint.',
      \ '-fstype' : 'Only list files or directorys with specific filesysten type',
      \ '-gid' : 'Only list files with specific group ID.',
      \ '-group' : 'Only list files with specific group name.',
      \ '-help' : 'show help info',
      \ '-ilname' : '此参数的效果和指定“-lname”参数类似，但忽略字符大小写的差别',
      \ '-iname' : '指定字符串作为寻找符号连接的范本样式',
      \ '-inum' : '查找符合指定的inode编号的文件或目录',
      \ '-ipath' : '此参数的效果和指定“-path”参数类似，但忽略字符大小写的差别',
      \ '-iregex' : '此参数的效果和指定“-regexe”参数类似，但忽略字符大小写的差别',
      \ '-links' : '查找符合指定的硬连接数目的文件或目录',
      \ '-ls' : 'If find command return True, then send all files names to stdout',
      \ '-maxdepth' : 'specific the max path depath',
      \ '-mindepth' : 'specific the min path depath',
      \ '-mmin' : '查找在指定时间曾被更改过的文件或目录，单位以分钟计算',
      \ '-mount' : '此参数的效果和指定“-xdev”相同',
      \ '-mtime' : '查找在指定时间曾被更改过的文件或目录，单位以24小时计算',
      \ '-name' : '指定字符串作为寻找文件或目录的范本样式',
      \ '-newer' : '查找其更改时间较指定文件或目录的更改时间更接近现在的文件或目录',
      \ '-nogroup' : '找出不属于本地主机群组识别码的文件或目录',
      \ '-noleaf' : '不去考虑目录至少需拥有两个硬连接存在',
      \ '-nouser' : '找出不属于本地主机用户识别码的文件或目录',
      \ '-ok' : '此参数的效果和指定“-exec”类似，但在执行指令之前会先询问用户，若回答“y”或“Y”，则放弃执行命令',
      \ '-path' : '指定字符串作为寻找目录的范本样式',
      \ '-perm' : '查找符合指定的权限数值的文件或目录',
      \ '-print' : '假设find指令的回传值为True，就将文件或目录名称列出到标准输出。格式为每列一个名称，每个名称前皆有“./”字符串',
      \ '-print0' : '假设find指令的回传值为True，就将文件或目录名称列出到标准输出。格式为全部的名称皆在同一行',
      \ '-printf' : '假设find指令的回传值为True，就将文件或目录名称列出到标准输出。格式可以自行指定',
      \ '-prune' : '不寻找字符串作为寻找文件或目录的范本样式',
      \ '-regex' : '指定字符串作为寻找文件或目录的范本样式',
      \ '-size' : '查找符合指定的文件大小的文件',
      \ '-true' : '将find指令的回传值皆设为True',
      \ '-type' : '只寻找符合指定的文件类型的文件',
      \ '-uid' : '查找符合指定的用户识别码的文件或目录',
      \ '-used' : '查找文件或目录被更改之后在指定时间曾被存取过的文件或目录，单位以日计算',
      \ '-user' : '查找符和指定的拥有者名称的文件或目录',
      \ '-version' : 'Show version',
      \ '-xdev' : '将范围局限在先行的文件系统中',
      \ '-xtype' : '此参数的效果和指定“-type”参数类似，差别在于它针对符号连接检查'
      \ }
let s:options.fd = {
      \ '-H' : 'Search hidden files and directories',
      \ '-I' : 'Do not respect .(git|fd)ignore files',
      \ '-s' : 'Case-sensitive search',
      \ '-i' : 'Case-insensitive search',
      \ '-t' : 'Filter by type: file (f), directory (d), symlink (l), executable (x), empty (e)',
      \ '-g' : 'Glob-based search',
      \ '-d' : 'Set maximum search depth (default: none)',
      \ '-L' : 'Follow symbolic links',
      \ '-0' : 'Separate results by the null character',
      \ '-F' : 'Treat the pattern as a literal string',
      \ '-e' : 'Filter by file extension',
      \ }

let s:second_option.find = {
      \ '-type' :
      \   {
      \     'f' : 'regular file',
      \     'l' : 'symbolic link',
      \     'd' : 'directory',
      \     'c' : 'character (unbuffered) special',
      \     'b' : 'block (buffered) special',
      \     's' : 'socket',
      \     'p' : 'named pipe (FIFO)',
      \   },
      \ }

let s:second_option.fd = {
      \ '-t' :
      \   {
      \     'f' : 'regular file',
      \     'l' : 'symbolic link',
      \     'd' : 'directory',
      \     'x' : 'executable',
      \     'e' : 'empty',
      \   },
      \ }

function! s:start_find() abort
  if s:current_tool ==# 'find'
    let cmd = 'find -not -iwholename "*.git*" ' . s:MPT._prompt.begin . s:MPT._prompt.cursor . s:MPT._prompt.end
  elseif s:current_tool ==# 'fd'
    let cmd = 'fd ' . s:MPT._prompt.begin . s:MPT._prompt.cursor . s:MPT._prompt.end
  endif
  call s:MPT._clear_prompt()
  let s:MPT._quit = 1
  let line = getline('.')
  noautocmd q
  redraw!
  let s:finded_files = []
  call s:JOB.start(cmd,
        \ {
        \ 'on_stdout' : function('s:find_on_stdout'),
        \ 'on_exit' : function('s:find_on_exit'),
        \ }
        \ )
endfunction

function! s:find_on_stdout(id, data, event) abort
  let s:finded_files += a:data
endfunction

function! s:find_on_exit(id, data, event) abort
  let files = map(filter(deepcopy(s:finded_files), '!empty(v:val)'), "{'filename' : v:val}")
  if !empty(files)
    call setqflist(files)
    copen
  else
    echo 'Can not find anything'
  endif
endfunction

function! s:close_buffer() abort
  noautocmd pclose
  noautocmd q
endfunction
let s:MPT._onclose = function('s:close_buffer')

function! s:next_item() abort
  if line('.') == line('$')
    normal! gg
  else
    normal! j
  endif
  let argv = matchstr(getline('.'), '[-a-zA-Z0-9]*')
  let s:MPT._prompt.begin = substitute(s:MPT._prompt.begin, '[-a-zA-Z0-9]*$', argv, 'g')
  redraw
  call s:MPT._build_prompt()
endfunction

function! s:previous_item() abort
  if line('.') == 1
    normal! G
  else
    normal! k
  endif
  let argv = matchstr(getline('.'), '[-a-zA-Z0-9]*')
  let s:MPT._prompt.begin = substitute(s:MPT._prompt.begin, '[-a-zA-Z0-9]*$', argv, 'g')
  redraw
  call s:MPT._build_prompt()
endfunction

function! SpaceVim#plugins#find#open() abort
  let s:MPT._handle_fly = function('s:handle_command_line')
  let s:MPT._function_key = {
        \ "\<Return>" : function('s:start_find'),
        \ "\<Tab>" : function('s:next_item'),
        \ "\<C-j>" : function('s:next_item'),
        \ "\<S-tab>" : function('s:previous_item'),
        \ "\<C-k>" : function('s:previous_item'),
        \ "\<C-e>" : function('s:switch_tool'),
        \ }
  noautocmd rightbelow split __spacevim_find_argv__
  let s:find_argvs_buffer_id = bufnr('%')
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
  setf SpaceVimFindArgv
  call s:MPT.open()
endfunction

function! s:switch_tool() abort
  normal! "_dG
  if s:current_tool ==# 'find'
    let s:current_tool = 'fd'
  else
    let s:current_tool = 'find'
  endif
  let s:MPT._prompt.begin = ''
  let s:MPT._prompt.cursor = ''
  let s:MPT._prompt.end = ''
  let s:MPT._prompt.mpt = ' ' . s:current_tool . ' '
  redraw
  call s:MPT._build_prompt()
endfunction

function! s:enter() abort

endfunction

function! s:handle_command_line(cmd) abort
  normal! "_dG
  if empty(s:MPT._prompt.begin)
    redraw
    call s:MPT._build_prompt()
    return
  endif
  let argv = split(s:MPT._prompt.begin)[-1]
  if s:MPT._prompt.begin[-1:] ==# ' ' && has_key(s:second_option[s:current_tool], argv)
    let line = []
    for item in items(s:second_option[s:current_tool][argv])
      call add(line, '  ' . item[0] . repeat(' ', 8 - len(item[0])) . item[1])
    endfor
    call setline(1, line)
  elseif argv =~# '^-[a-zA-Z0-1]*'
    let argvs = filter(deepcopy(s:options[s:current_tool]), 'v:key =~ argv')
    let line = []
    for item in items(argvs)
      call add(line, item[0] . repeat(' ', 15 - len(item[0])) . item[1])
    endfor
    call setline(1, line)
  endif
  redraw
  call s:MPT._build_prompt()
endfunction
