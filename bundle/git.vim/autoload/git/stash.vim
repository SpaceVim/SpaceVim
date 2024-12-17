""
" @section git-stash, stash
" @parentsection commands
" This commands is to manage git stash.
" >
"   :Git stash list
" <

if has('nvim-0.9.0')
  function! git#stash#complete(ArgLead, CmdLine, CursorPos) abort
    return luaeval('require("git.command.stash").complete(vim.api.nvim_eval("a:ArgLead"), vim.api.nvim_eval("a:CmdLine"), vim.api.nvim_eval("a:CursorPos"))')
  endfunction
else
  let s:JOB = SpaceVim#api#import('job')
  let s:NOTI = SpaceVim#api#import('notify')
  let s:BUFFER = SpaceVim#api#import('vim#buffer')


  let s:stash_show_bufnr = -1
  " @todo rewrite Git stash in lua
  function! git#stash#run(args) abort

    let cmd = ['git', 'stash'] + a:args
    let subcmd = get(a:args, 0, '')
    if !empty(subcmd) && index(['drop', 'show'], subcmd) > -1
      let subcmd = subcmd . '_'
    else
      let subcmd = ''
    endif

    call git#logger#debug('git-stash cmd:' . string(cmd))
    let s:lines = []
    call s:JOB.start(cmd,
          \ {
          \ 'on_stderr' : function('s:on_' . subcmd . 'stderr'),
          \ 'on_stdout' : function('s:on_' . subcmd . 'stdout'),
          \ 'on_exit'   : function('s:on_' . subcmd . 'exit'),
          \ }
          \ )
  endfunction

  function! s:on_stdout(id, data, event) abort
    for line in filter(a:data, '!empty(v:val)')
      call git#logger#debug('git-stash stdout:' . line)
      call s:NOTI.notify(line, 'Normal')
    endfor
  endfunction

  function! s:on_stderr(id, data, event) abort
    for data in a:data
      call git#logger#debug('git-stash stderr:' . data)
    endfor
  endfunction

  function! s:on_exit(id, data, event) abort
    call git#logger#debug('git-stash exit data:' . string(a:data))
    if a:data ==# 0
      " echo 'done!'
    else
      " echo 'failed!'
    endif
  endfunction

  function! s:on_drop_stdout(id, data, event) abort
    for line in filter(a:data, '!empty(v:val)')
      call git#logger#debug('git-stash stdout:' . line)
      call s:NOTI.notify(line, 'Normal')
    endfor
  endfunction

  function! s:on_drop_stderr(id, data, event) abort
    for line in filter(a:data, '!empty(v:val)')
      call git#logger#debug('git-stash stdout:' . line)
      call s:NOTI.notify(line, 'WarningMsg')
    endfor
  endfunction

  function! s:on_drop_exit(id, data, event) abort
    call git#logger#debug('git-stash exit data:' . string(a:data))
    if a:data ==# 0
      " echo 'done!'
    else
      " echo 'failed!'
    endif
  endfunction

  function! s:on_show_stdout(id, data, event) abort
    for data in a:data
      call git#logger#debug('git-stash stdout:' . data)
    endfor
    let s:lines += a:data
  endfunction

  function! s:on_show_stderr(id, data, event) abort
    for line in filter(a:data, '!empty(v:val)')
      call git#logger#debug('git-stash stdout:' . line)
      call s:NOTI.notify(line, 'WarningMsg')
    endfor
  endfunction

  function! s:on_show_exit(id, data, event) abort
    call git#logger#debug('git-stash exit data:' . string(a:data))
    if a:data ==# 0
      if !bufexists(s:stash_show_bufnr)
        let s:stash_show_bufnr = s:openStashShowBuffer()
      endif
      call s:BUFFER.buf_set_lines(s:stash_show_bufnr, 0 , -1, 0, s:lines)
    endif
  endfunction

  function! s:openStashShowBuffer() abort
    edit git://blame
    normal! "_dd
    setl nobuflisted
    setl nomodifiable
    setl nonumber norelativenumber
    setl buftype=nofile
    setf git-diff
    setl syntax=diff
    nnoremap <buffer><silent> q :bd!<CR>
    return bufnr('%')
  endfunction

  function! s:sub_commands() abort
    return join([
          \ 'list',
          \ 'show',
          \ 'drop',
          \ 'pop', 'apply',
          \ 'branch',
          \ 'clear',
          \ 'save',
          \ 'push',
          \ ],
          \ "\n")
  endfunction

  function! git#stash#complete(ArgLead, CmdLine, CursorPos) abort

    let str = a:CmdLine[:a:CursorPos-1]
    if str =~# '^Git\s\+stash\s\+[a-z]\=$'
      return s:sub_commands()
    else
      return ''
    endif

  endfunction

endif
