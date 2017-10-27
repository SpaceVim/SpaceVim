let s:qflist = []


let s:filestack = []

function! SpaceVim#plugins#quickfix#setqflist(list, ...)
  let s:qflist = a:list
endfunction


function! SpaceVim#plugins#quickfix#getqflist()

  return s:qflist

endfunction


function! SpaceVim#plugins#quickfix#next()



endfunction


function! SpaceVim#plugins#quickfix#pre()



endfunction


function! SpaceVim#plugins#quickfix#enter()

  let file = get(s:filestack, line('.') - 1, {})
  if !empty(file)
    wincmd p
    exe 'e' file.name
    exe file.lnum
  endif
endfunction

let s:BUFFER = SpaceVim#api#import('vim#buffer')
function! SpaceVim#plugins#quickfix#openwin()
  call s:BUFFER.open({
        \ 'bufname' : '__quickfix__',
        \ 'cmd' : 'setl buftype=nofile bufhidden=wipe filetype=SpaceVimQuickFix nomodifiable nowrap nobuflisted',
        \ 'mode' : 'rightbelow split ',
        \ })
  call s:BUFFER.resize(10, '')
  call s:mappings()
  call s:update_stack()
  let lines = []
  for file in s:qflist
    let line = ''
    if has_key(file, 'abbr')
      let line .= file.abbr
    elseif has_key(file, 'filename')
      let line .= file.name
    elseif has_key(file, 'bufnr')
      let line .= bufname(file.bufnr)
    endif
    let line .= '    '
    if has_key(file, 'type')
      let line .= '|' . file.type . '|'
    endif
    let line .= file.text
    call add(lines, line)
  endfor
  call setbufvar(bufnr('%'),'&ma', 1)
  call s:BUFFER.buf_set_lines(bufnr('%'), 0, len(lines) - 1, 0, lines)
  call setbufvar(bufnr('%'),'&ma', 0)
endfunction

function! s:mappings() abort
  nnoremap <buffer><silent> <cr> :call SpaceVim#plugins#quickfix#enter()<cr>
  nnoremap <buffer><silent> q :close<cr>
endfunction

function! s:update_stack() abort
  let s:filestack = []
  for item in s:qflist
    let file = {}
    if has_key(item, 'bufnr') && bufexists(item.bufnr)
      let file.name = bufname(item.bufnr)
    elseif has_key(item, 'bufname')
      let file.name = item.bufname
    elseif has_key(item, 'filename') 
      let file.name = item.filename
    else
      let file.name = ''
    endif
    let file.lnum = item.lnum
    let file.col = item.col
    call add(s:filestack, file)
  endfor
endfunction

function! SpaceVim#plugins#quickfix#swapqf()
  call SpaceVim#plugins#quickfix#setqflist(getqflist())
  call SpaceVim#plugins#quickfix#openwin()
endfunction
