"=============================================================================
" find.vim --- vim plugin for find
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong 
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Loadding SpaceVim api {{{
scriptencoding utf-8
let s:MPT = SpaceVim#api#import('prompt')
let s:JOB = SpaceVim#api#import('job')
" let s:SYS = SpaceVim#api#import('system')
" let s:BUFFER = SpaceVim#api#import('vim#buffer')
" let s:LIST = SpaceVim#api#import('data#list')
"}}}

let s:MPT._prompt.mpt = ' find '

let s:options_en = {
      \ '-amin' : 'File was last accessed n minutes ago.',
      \ '-anewer' : 'File  was  last  accessed  more recently than file was modified.',
      \ '-atime' : 'File was last accessed n*24 hours ago.',
      \ '-cmin' : "File's status was last changed n minutes ago.",
      \ '-cnewer' : "File's  status  was last changed more recently than file was modified.",
      \ '-ctime' : "File's status was last changed n*24 hours ago.",
      \ '-daystart' : 'Measure times from the beginning of today rather than from 24 hours ago.',
      \ '-depth' : "Process each directory's contents before the directory itself.",
      \ '-exec' : 'Execute command',
      \ '-false' : 'make find command return false',
      \ '-fls' : 'True; like -ls but write to file like -fprint.',
      \ '-follow' : 'a diagnostic message is issued when find encounters a loop of symbolic links.',
      \ '-fprint' : 'True; print the full file name into file file.',
      \ '-fprintf' : 'True;  like  -printf but write to file like -fprint.',
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
      \ '-print' : '假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出。格式为每列一个名称，每个名称前皆有“./”字符串',
      \ '-print0' : '假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出。格式为全部的名称皆在同一行',
      \ '-printf' : '假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出。格式可以自行指定',
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

let s:options = {
      \ '-amin' : '查找在指定时间曾被存取过的文件或目录，单位以分钟计算',
      \ '-anewer' : '查找其存取时间较指定文件或目录的存取时间更接近现在的文件或目录',
      \ '-atime' : '查找在指定时间曾被存取过的文件或目录，单位以24小时计算',
      \ '-cmin' : '查找在指定时间之时被更改过的文件或目录',
      \ '-cnewer' : '查找其更改时间较指定文件或目录的更改时间更接近现在的文件或目录',
      \ '-ctime' : '查找在指定时间之时被更改的文件或目录，单位以24小时计算',
      \ '-daystart' : '从本日开始计算时间',
      \ '-depth' : '从指定目录下最深层的子目录开始查找',
      \ '-exec' : '假设find指令的回传值为True，就执行该指令',
      \ '-false' : '将find指令的回传值皆设为False',
      \ '-fls' : '此参数的效果和指定“-ls”参数类似，但会把结果保存为指定的列表文件',
      \ '-follow' : '排除符号连接',
      \ '-fprint' : '此参数的效果和指定“-print”参数类似，但会把结果保存成指定的列表文件',
      \ '-fprintf' : '此参数的效果和指定“-printf”参数类似，但会把结果保存成指定的列表文件',
      \ '-fstype' : '只寻找该文件系统类型下的文件或目录',
      \ '-gid' : '查找符合指定之群组识别码的文件或目录',
      \ '-group' : '查找符合指定之群组名称的文件或目录',
      \ '-help' : '——help：在线帮助',
      \ '-ilname' : '此参数的效果和指定“-lname”参数类似，但忽略字符大小写的差别',
      \ '-iname' : '指定字符串作为寻找符号连接的范本样式',
      \ '-inum' : '查找符合指定的inode编号的文件或目录',
      \ '-ipath' : '此参数的效果和指定“-path”参数类似，但忽略字符大小写的差别',
      \ '-iregex' : '此参数的效果和指定“-regexe”参数类似，但忽略字符大小写的差别',
      \ '-links' : '查找符合指定的硬连接数目的文件或目录',
      \ '-ls' : '假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出',
      \ '-maxdepth' : '设置最大目录层级',
      \ '-mindepth' : 'Do not apply any tests or actions at levels less than n.',
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
      \ '-print' : '假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出。格式为每列一个名称，每个名称前皆有“./”字符串',
      \ '-print0' : '假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出。格式为全部的名称皆在同一行',
      \ '-printf' : '假设find指令的回传值为Ture，就将文件或目录名称列出到标准输出。格式可以自行指定',
      \ '-prune' : '不寻找字符串作为寻找文件或目录的范本样式',
      \ '-regex' : '指定字符串作为寻找文件或目录的范本样式',
      \ '-size' : '查找符合指定的文件大小的文件',
      \ '-true' : '将find指令的回传值皆设为True',
      \ '-type' : '只寻找符合指定的文件类型的文件',
      \ '-uid' : '查找符合指定的用户识别码的文件或目录',
      \ '-used' : '查找文件或目录被更改之后在指定时间曾被存取过的文件或目录，单位以日计算',
      \ '-user' : '查找符和指定的拥有者名称的文件或目录',
      \ '-version' : '显示版本信息',
      \ '-xdev' : '将范围局限在先行的文件系统中',
      \ '-xtype' : '此参数的效果和指定“-type”参数类似，差别在于它针对符号连接检查'
      \ }

let s:second_option_en = {
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

let s:second_option = {
      \ '-type' :
      \   {
      \     'f' : '普通文件',
      \     'l' : '符号连接',
      \     'd' : '目录',
      \     'c' : '字符设备',
      \     'b' : '块设备',
      \     's' : '套接字',
      \     'p' : 'Fifo',
      \   },
      \ }

let s:finded_files = []
function! s:start_find() abort
  let cmd = 'find -not -iwholename "*.git*" ' . s:MPT._prompt.begin . s:MPT._prompt.cursor . s:MPT._prompt.end
  call s:MPT._clear_prompt()
  let s:MPT._quit = 1
  let line = getline('.')
  noautocmd q
  redraw!
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
  let files = map(filter(s:finded_files, '!empty(v:val)'), "{'filename' : v:val}")
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
  let argv = matchstr(getline('.'), '^-[a-zA-Z0-9]')
  let s:MPT._prompt.begin = substitute(s:MPT._prompt.begin, '-[a-zA-Z]*$', argv, 'g')
  redraw
  call s:MPT._build_prompt()
endfunction

function! s:previous_item() abort
  if line('.') == 1
    normal! G
  else
    normal! k
  endif
  let argv = matchstr(getline('.'), '^-[a-zA-Z0-9]')
  let s:MPT._prompt.begin = substitute(s:MPT._prompt.begin, '-[a-zA-Z]*$', argv, 'g')
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
        \ }
  noautocmd rightbelow split __spacevim_find_argv__
  let s:find_argvs_buffer_id = bufnr('%')
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
  setf SpaceVimFindArgv
  call s:MPT.open()
endfunction

function! s:handle_command_line(cmd) abort
  normal! "_dG
  if empty(a:cmd)
    redraw
    call s:MPT._build_prompt()
    return
  endif
  let argv = split(a:cmd)[-1]
  if a:cmd[-1:] ==# ' ' && argv ==# '-type'
    let line = []
    for item in items(s:second_option_en['-type'])
      call add(line, '  ' . item[0] . repeat(' ', 8 - len(item[0])) . item[1])
    endfor
    call setline(1, line)
  elseif argv =~# '^-[a-zA-Z0-1]*'
    let argvs = filter(deepcopy(s:options_en), 'v:key =~ argv')
    let line = []
    for item in items(argvs)
      call add(line, item[0] . repeat(' ', 15 - len(item[0])) . item[1])
    endfor
    call setline(1, line)
  endif
  redraw
  call s:MPT._build_prompt()
endfunction
