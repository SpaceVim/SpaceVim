let s:LOG = SpaceVim#api#import('logger')

call s:LOG.set_name('git.vim')
call s:LOG.set_level(1)
call s:LOG.set_silent(1)
call s:LOG.set_verbose(1)

function! git#logger#info(msg)

    call s:LOG.info(a:msg)

endfunction


function! git#logger#view()
  let info = "### git.vim runtime log :\n\n"
  let info .= "```log\n"

  let info .= s:LOG.view(s:LOG.level)

  let info .= "\n```\n"
  tabnew +setl\ nobuflisted
  nnoremap <buffer><silent> q :bd!<CR>
  for msg in split(info, "\n")
    call append(line('$'), msg)
  endfor
  normal! "_dd
  setl nomodifiable
  setl buftype=nofile
  setl filetype=markdown
endfunction

function! git#logger#clear() abort
    call s:LOG.clear(1)
endfunction
