let s:logger_level = get(g:, 'spacevim_debug_level', 1)
let s:levels = ['Info', 'Warn', 'Error']
let s:logger_file = expand('~/.cache/SpaceVim/SpaceVim.log')
let s:log_temp = []

""
" @public
" Set debug level of SpaceVim. Default is 1.
"
"     1 : log all messages
"
"     2 : log warning and error messages
"
"     3 : log error messages only
function! SpaceVim#logger#setLevel(level) abort
  let s:logger_level = a:level
endfunction

function! SpaceVim#logger#info(msg) abort
  if g:spacevim_enable_debug && s:logger_level <= 1
    call s:wite(s:warpMsg(a:msg, 1))
  else
    call add(s:log_temp,s:warpMsg(a:msg,1))
  endif
endfunction

function! SpaceVim#logger#warn(msg) abort
  let msg = s:warpMsg(a:msg, 2)
  echohl WarningMsg
  echomsg msg
  echohl NONE
  if g:spacevim_enable_debug && s:logger_level <= 2
    call s:wite(s:warpMsg(a:msg, 2))
  else
    call add(s:log_temp,s:warpMsg(a:msg,2))
  endif
endfunction

function! SpaceVim#logger#error(msg) abort
  if get(g:, 'spacevim_enable_debug', 1) && s:logger_level <= 3
    call s:wite(s:warpMsg(a:msg, 3))
  else
    call add(s:log_temp,s:warpMsg(a:msg,3))
  endif
endfunction

function! s:wite(msg) abort
  if !isdirectory(expand('~/.cache/SpaceVim/'))
    call mkdir(expand('~/.cache/SpaceVim/'), 'p')
  endif
  let flags = filewritable(s:logger_file) ? 'a' : ''
  call writefile([a:msg], s:logger_file, flags)
endfunction


function! SpaceVim#logger#viewLog(...) abort
  let info = "### SpaceVim Options :\n\n"
  let info .= "```viml\n"
  let info .= join(SpaceVim#options#list(), "\n")
  let info .= "\n```\n"
  let info .= "\n\n"

  let info .= "### SpaceVim Health checking :\n\n"
  let info .= SpaceVim#health#report()
  let info .= "\n\n"

  let info .= "### SpaceVim runtime log :\n\n"
  let info .= "```log\n"

  let l = s:logger_level
  if filereadable(s:logger_file)
    let logs = readfile(s:logger_file, '')
    let info .= join(filter(logs,
          \ "v:val =~# '\[ SpaceVim \] \[\d\d\:\d\d\:\d\d\] \["
          \ . s:levels[l] . "\]'"), "\n")
  else
    let info .= '[ SpaceVim ] : logger file ' . s:logger_file
          \ . ' does not exists, only log for current process will be shown!'
    let info .= join(filter(s:log_temp,
          \ "v:val =~# '\[ SpaceVim \] \[\d\d\:\d\d\:\d\d\] \["
          \ . s:levels[l] . "\]'"), "\n")
  endif
  let info .= "\n```\n"
  if a:0 > 0
    if a:1 == 1
      tabnew +setl\ nobuflisted
      nnoremap <buffer><silent> q :bd!<CR>
      for msg in split(info, "\n")
        call append(line('$'), msg)
      endfor
      normal! "_dd
      setl nomodifiable
      setl buftype=nofile
      setl filetype=markdown
    else
      echo info
    endif
  else
    return info
  endif
endfunction

""
" @public
" Set the log output file of SpaceVim. Default is `~/.SpaceVim/.SpaceVim.log`.
function! SpaceVim#logger#setOutput(file) abort
  let s:logger_file = a:file
endfunction

function! s:warpMsg(msg,l) abort
  let time = strftime('%H:%M:%S')
  let log = '[ SpaceVim ] [' . time . '] [' . s:levels[a:l - 1] . '] ' . a:msg
  return log
endfunction

function! SpaceVim#logger#echoWarn(msg) abort
  echohl WarningMsg
  echom s:warpMsg(a:msg, 1)
  echohl None
endfunction

" vim:set et sw=2 cc=80:
