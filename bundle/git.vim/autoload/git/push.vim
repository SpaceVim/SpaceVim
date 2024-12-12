"=============================================================================
" push.vim --- push command for git.vim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" License: GPLv3
"=============================================================================
if has('nvim-0.9.0')
  function! git#push#complete(ArgLead, CmdLine, CursorPos) abort
    return luaeval('require("git.command.push").complete(vim.api.nvim_eval("a:ArgLead"), vim.api.nvim_eval("a:CmdLine"), vim.api.nvim_eval("a:CursorPos"))')
  endfunction
else

  let s:JOB = SpaceVim#api#import('job')
  let s:NOTI = SpaceVim#api#import('notify')

  let s:push_jobid = 0

  function! git#push#run(...) abort

    if s:push_jobid != 0
      call s:NOTI.notify('previous push not finished')
      return
    endif

    let s:NOTI.notify_max_width = float2nr( &columns * 0.3)
    let s:std_data = {
          \ 'stderr' : [],
          \ 'stdout' : [],
          \ }
    let cmd = ['git', 'push']
    if len(a:1) > 0
      let cmd += a:1
    endif
    let s:push_jobid = s:JOB.start(cmd, {
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_exit'),
          \ }
          \ )

    if s:push_jobid == -1
      call s:NOTI.notify('`git` is not executable')
      let s:push_jobid = 0
    endif

  endfunction

  function! s:on_exit(id, data, event) abort
    if a:data != 0
      for line in s:std_data.stderr
        let s:NOTI.notify_max_width = max([strwidth(line) + 5, s:NOTI.notify_max_width])
        call s:NOTI.notify(line, 'WarningMsg')
      endfor
    else
      for line in s:std_data.stderr
        let s:NOTI.notify_max_width = max([strwidth(line) + 5, s:NOTI.notify_max_width])
        call s:NOTI.notify(line)
      endfor
    endif
    let s:push_jobid = 0
  endfunction


  function! s:on_stdout(id, data, event) abort
    for line in filter(a:data, '!empty(v:val) && v:val !~# "^remote:"')
      let s:NOTI.notify_max_width = max([strwidth(line) + 5, s:NOTI.notify_max_width])
      call s:NOTI.notify(line, 'Normal')
    endfor
  endfunction


  " https://stackoverflow.com/questions/57016157/how-to-stop-git-from-writing-non-errors-to-stderr
  "
  " why git push normal info to stderr

  function! s:on_stderr(id, data, event) abort
    call extend(s:std_data.stderr, filter(a:data, '!empty(v:val) && v:val !~# "^remote:"'))
  endfunction

  function! s:options() abort
    return [
          \ '-u',
          \ '--set-upstream',
          \ '-d', '--delete'
          \ ]
  endfunction

  function! git#push#complete(ArgLead, CmdLine, CursorPos) abort
    let str = a:CmdLine[:a:CursorPos-1]
    if str =~# '^Git\s\+push\s\+-$'
      return join(s:options(), "\n")
    elseif str =~# '^Git\s\+push\s\+[^ ]*$' || str =~# '^Git\s\+push\s\+-u\s\+[^ ]*$'
      return join(s:remotes(), "\n")
    else
      let remote = matchstr(str, '\(Git\s\+push\s\+\)\@<=[^ ]*')
      return s:remote_branch(remote)
    endif
  endfunction

  function! s:remotes() abort
    return map(systemlist('git remote'), 'trim(v:val)')
  endfunction

  function! s:remote_branch(remote) abort
    let branchs = systemlist('git branch -a')
    if v:shell_error
      return ''
    else
      let branchs = join(map(filter(branchs, 'v:val =~ "\s*remotes/" . a:remote . "/[^ ]*$"'), 'trim(v:val)[len(a:remote) + 9:]'), "\n")
      return branchs
    endif
  endfunction
endif
