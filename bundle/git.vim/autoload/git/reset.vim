"=============================================================================
" reset.vim --- git reset command
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if has('nvim-0.9.0')
  function! git#reset#complete(ArgLead, CmdLine, CursorPos) abort
    return luaeval('require("git.command.reset").complete(vim.api.nvim_eval("a:ArgLead"), vim.api.nvim_eval("a:CmdLine"), vim.api.nvim_eval("a:CursorPos"))')
  endfunction
else
  let s:JOB = SpaceVim#api#import('job')


  function! git#reset#run(args)

    if len(a:args) == 1 && a:args[0] ==# '%'
      let cmd = ['git', 'reset', 'HEAD', expand('%')] 
    else
      let cmd = ['git', 'reset'] + a:args
    endif
    call git#logger#debug('git-reset cmd:' . string(cmd))
    call s:JOB.start(cmd,
          \ {
          \ 'on_exit' : function('s:on_exit'),
          \ }
          \ )

  endfunction

  function! s:on_exit(id, data, event) abort
    call git#logger#debug('git-reset exit data:' . string(a:data))
    if a:data ==# 0
      if exists(':GitGutter')
        GitGutter
      endif
      echo 'done!'
    else
      echo 'failed!'
    endif
  endfunction

  function! git#reset#complete(ArgLead, CmdLine, CursorPos)

    return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

  endfunction
endif
