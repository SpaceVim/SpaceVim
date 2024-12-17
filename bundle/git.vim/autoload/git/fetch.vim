"=============================================================================
" fetch.vim --- Git fetch command
" Copyright 2021 Eric Wong
" Author: Eric Wong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


if has('nvim-0.9.0')
  function! git#fetch#complete(ArgLead, CmdLine, CursorPos) abort
    return luaeval('require("git.command.fetch").complete(vim.api.nvim_eval("a:ArgLead"), vim.api.nvim_eval("a:CmdLine"), vim.api.nvim_eval("a:CursorPos"))')
  endfunction
else

  ""
  " @section git-fetch, fetch
  " @parentsection commands
  " This commands is to fetch remote repo.
  " >
  "   :Git fetch --all
  " <

  let s:JOB = SpaceVim#api#import('job')

  function! git#fetch#run(args)

    let cmd = ['git', 'fetch'] + a:args
    call git#logger#debug('git-fetch cmd:' . string(cmd))
    call s:JOB.start(cmd,
          \ {
          \ 'on_exit' : function('s:on_exit'),
          \ }
          \ )

  endfunction

  function! s:on_exit(id, data, event) abort
    call git#logger#debug('git-fetch exit data:' . string(a:data))
    if a:data ==# 0
      echo 'fetch done!'
    else
      echo 'fetch failed!'
    endif
  endfunction

  function! git#fetch#complete(ArgLead, CmdLine, CursorPos)

    if a:ArgLead =~# '^-'
      return s:options()
    endif
    let str = a:CmdLine[:a:CursorPos-1]
    if str =~# '^Git\s\+fetch\s\+[^ ]*$'
      return join(s:remotes(), "\n")
    else
      return ''
    endif

  endfunction

  function! s:remotes() abort
    return map(systemlist('git remote'), 'trim(v:val)')
  endfunction

  function! s:options() abort
    return join([
          \ '--all',
          \ '--multiple',
          \ ], "\n")
  endfunction
endif
