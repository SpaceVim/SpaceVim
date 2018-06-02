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
      \ '-expty' : '寻找文件大小为0 Byte的文件，或目录下没有任何子目录或文件的空目录',
      \ '-false' : '将find指令的回传值皆设为False',
      \ '-fls' : '此参数的效果和指定“-ls”参数类似，但会把结果保存为指定的列表文件',
      \ '-follow' : '排除符号连接',
      \ '-fprint' : '此参数的效果和指定“-print”参数类似，但会把结果保存成指定的列表文件',
      \ '-fprint0' : '此参数的效果和指定“-print0”参数类似，但会把结果保存成指定的列表文件',
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
      \ '-mindepth' : '设置最小目录层级',
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
      \ '-typ' : '只寻找符合指定的文件类型的文件',
      \ '-uid' : '查找符合指定的用户识别码的文件或目录',
      \ '-used' : '查找文件或目录被更改之后在指定时间曾被存取过的文件或目录，单位以日计算',
      \ '-user' : '查找符和指定的拥有者名称的文件或目录',
      \ '-version' : '显示版本信息',
      \ '-xdev' : '将范围局限在先行的文件系统中',
      \ '-xtype' : '此参数的效果和指定“-type”参数类似，差别在于它针对符号连接检查'
      \ }

function! SpaceVim#plugins#find#open() abort
  let s:MPT._handle_fly = function('s:handle_command_line')
  noautocmd rightbelow split __spacevim_find_argv__
  let s:find_argvs_buffer_id = bufnr('%')
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
  setf SpaceVimFindArgv
  call s:MPT.open()
endfunction

function! s:handle_command_line(cmd) abort
  normal! "_dG
  if empty(a:cmd)
    return
  endif
  let argvs = filter(deepcopy(s:options), 'v:key =~ split(a:cmd)[-1]')
  let line = []
  for item in items(argvs)
    call add(line, item[0] . repeat(' ', 15 - len(item[0])) . item[1])
  endfor
  call setline(1, line)
endfunction
