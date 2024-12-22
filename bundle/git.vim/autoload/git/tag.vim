""
" @section git-tag, tag
" @parentsection commands
" This commands is to run `git tag` commands.
" >
"   :Git tag --list
" <
"
" @subsection Command line completion
"
" complete git tag options after `Git tag -<cursor>`, 
"
" complete git tags after `-d` option.

if has('nvim-0.9.0')
  function! git#tag#complete(ArgLead, CmdLine, CursorPos) abort
    return luaeval('require("git.command.tag").complete(vim.api.nvim_eval("a:ArgLead"), vim.api.nvim_eval("a:CmdLine"), vim.api.nvim_eval("a:CursorPos"))')
  endfunction
else
  let s:JOB = SpaceVim#api#import('job')
  let s:NT = SpaceVim#api#import('notify')
  let s:jobid = -1
  let s:stderr_data = []

  function! git#tag#run(argvs) abort

    if s:jobid != -1
      call s:NT.notify('previous tag command is not finished')
      return
    endif

    let s:NT.notify_max_width = float2nr(&columns * 0.3)

    let s:stderr_data = []

    let cmd = ['git', 'tag'] + a:argvs
    call git#logger#debug('git-tag cmd:' . string(cmd))
    let s:jobid = s:JOB.start(cmd,
          \ {
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_exit'),
          \ }
          \ )

    if s:jobid == -1
      call s:NT.notify('`git` is not executable', 'WarningMsg')
    endif

  endfunction

  function! s:on_stdout(id, data, event) abort
    if a:id != s:jobid
      return
    endif
    for line in a:data
      call s:NT.notify(line)
    endfor
  endfunction

  function! s:on_stderr(id, data, event) abort
    if a:id != s:jobid
      return
    endif
    for line in a:data
      call add(s:stderr_data, line)
    endfor
  endfunction

  function! s:on_exit(id, data, event) abort
    call git#logger#debug('git-tag exit data:' . string(a:data))
    if a:id != s:jobid
      return
    endif
    if a:data ==# 0
      for line in s:stderr_data
        call s:NT.notify(line)
      endfor
    else
      for line in s:stderr_data
        call s:NT.notify(line, 'WarningMsg')
      endfor
    endif
    let s:jobid = -1
  endfunction

  function! s:options() abort
    return [
          \ '--list',
          \ ]
  endfunction

  function! git#tag#complete(ArgLead, CmdLine, CursorPos) abort
    let str = a:CmdLine[:a:CursorPos-1]
    if str =~# '^Git\s\+tag\s\+-$'
      return join(s:options(), "\n")
    elseif str =~# '^Git\s\+tag\s\+[^ ]*$'
      return join(s:options(), "\n")
    else
      return ''
    endif

  endfunction

endif
