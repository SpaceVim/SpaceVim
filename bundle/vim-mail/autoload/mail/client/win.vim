" load APIs
"

let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:BASE64 = SpaceVim#api#import('data#base64')
let s:QUOPRI = SpaceVim#api#import('data#quopri')
let s:ICONV = SpaceVim#api#import('iconv')


let s:bufnr = -1
let s:win_name = 'home'
let s:win_dir = 'INBOX'
let s:win_unseen = {}

function! mail#client#win#open()
  if s:bufnr ==# -1
    split __VIM_MAIL__
    let s:bufnr = bufnr('%')
    setlocal buftype=nofile nobuflisted nolist noswapfile nowrap cursorline nospell nomodifiable nowrap norelativenumber number
    nnoremap <silent><buffer> <F5> :call <SID>refresh()<Cr>
    setfiletype VimMailClient
  else
    split
    exe 'b' . s:bufnr
  endif
  call s:refresh()
endfunction

function! mail#client#win#currentDir()
  return s:win_dir
endfunction

" =?<charset>?<encoding>?<encoded-text>?=
" '=?UTF-8?B?VGhpcyBpcyBhIGhvcnNleTog8J+Qjg==?='
function! s:encode(str) abort
  let origin_str = a:str
  let target_str = ''
  let id = 0
  while !empty(matchstr(origin_str, '^=?[^?]*?[^?]*?[^?]*?='))
    let id += 1
    let str = matchstr(origin_str, '^=?[^?]*?[^?]*?[^?]*?=')
    let origin_str = substitute(origin_str, '^=?[^?]*?[^?]*?[^?]*?=', '', '')
    let charset = matchstr(str, '^=?\zs[^?]*')
    let encoding = matchstr(str, '^=?[^?]*?\zs[^?]*')
    let text = matchstr(str, '^=?[^?]*?[^?]*?\zs[^?]*')
    if encoding ==? 'b'
      let text = s:BASE64.decode(text)
      let target_str .= iconv(text, charset, 'utf-8')
    elseif encoding ==? 'q' && 0
      let text = s:QUOPRI.decode(text)
      let target_str .= text
    else
      let target_str .= str
    endif
  endwhile
  return target_str . origin_str
endfunction


function! s:refresh() abort
  let mails = mail#client#mailbox#get(s:win_dir)
  let lines = ['DATA       FROM                                                SUBJECT']
  for id in keys(mails)
    call add(lines, mails[id]['data'] . '  ' . s:encode(mails[id]['from']) . '  ' . s:encode(mails[id]['subject']))
  endfor
  call setbufvar(s:bufnr, '&modifiable', 1)
  call s:BUFFER.buf_set_lines(s:bufnr, 0, len(lines), 0, lines)
  call setbufvar(s:bufnr, '&modifiable', 0)
endfunction

function! mail#client#win#status() abort
  return {
        \ 'dir' : s:win_dir,
        \ 'unseen' : get(s:win_unseen, 's:win_dir', 0),
        \ }
endfunction



