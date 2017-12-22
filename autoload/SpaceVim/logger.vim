let s:LOGGER = SpaceVim#api#import('logger')

call s:LOGGER.set_name('SpaceVim')
call s:LOGGER.set_level(1)
call s:LOGGER.set_silent(0)
call s:LOGGER.set_verbose(1)

function! SpaceVim#logger#info(msg) abort

  call s:LOGGER.info(a:msg)

endfunction

function! SpaceVim#logger#warn(msg) abort

  call s:LOGGER.warn(a:msg)

endfunction


function! SpaceVim#logger#error(msg) abort

  call s:LOGGER.error(a:msg)

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

  let info .= s:LOGGER.view(s:LOGGER.level)

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
" Set debug level of SpaceVim. Default is 1.
"
"     1 : log all messages
"
"     2 : log warning and error messages
"
"     3 : log error messages only
function! SpaceVim#logger#setLevel(level) abort
  call s:LOGGER.set_level(a:level)
endfunction

""
" @public
" Set the log output file of SpaceVim. Default is empty.
function! SpaceVim#logger#setOutput(file) abort
  call s:LOGGER.set_file(a:file)
endfunction
