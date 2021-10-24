let s:job_id = 0
let s:job_noop_timer = ''

let s:JOB = SpaceVim#api#import('job')

function! mail#client#connect(ip, port)
  if has('nvim')
    let s:job_id = sockconnect('tcp', a:ip . ':' . a:port,
          \ {
            \ 'on_data' : function('s:on_stdout'),
            \ }
            \ )
    call mail#logger#info('mail client job id:' . s:job_id)
  else
    let s:job_channel = ch_open(a:ip . ':' . a:port,
          \ {
            \ 'callback' : function('s:data_handle'),
            \ }
            \ )
    call mail#logger#info('mail client job channel:' . s:job_channel)
  endif
endfunction

" Wed, 06 Sep 2017 02:55:41 +0000  ===> 2017-09-06
let s:__months = {
      \ 'Sep' : 9,
      \ }
function! s:convert(date) abort
  let info = split(a:date, ' ')
  let year = info[3]
  let m = get(s:__months, info[2], 00)
  let day = len(info[1]) == 1 ? '0' . info[1] : info[1]
  return join([year, m, day], '-')
endfunction

function! s:noop(id) abort
  call mail#client#send(mail#command#noop())
endfunction

let s:_mail_id = -1
let s:_mail_date = ''
let s:_mail_from = ''
let s:_mail_subject = ''
let s:mail_unseen = 0

function! s:data_handle(...) abort
  call s:on_stdout(1,1, [a:1])
endfunction

function! s:on_stdout(id, data, event) abort
  for data in a:data
    call mail#logger#info('STDOUT: ' . data)
    if data =~ '^\* \d\+ FETCH '
      let s:_mail_id = matchstr(data, '\d\+')
    elseif data =~ '^From: '
      let s:_mail_from = substitute(data, '^From: ', '', 'g')
      let s:_mail_from .= repeat(' ', 50 - len(s:_mail_from))
    elseif data =~ '^Date: '
      let s:_mail_date = s:convert(substitute(data, '^Date: ', '', 'g'))
    elseif data =~ '^Subject: '
      let s:_mail_subject = substitute(data, '^Subject: ', '', 'g')
      call mail#client#mailbox#updatedir(s:_mail_id, s:_mail_from, s:_mail_date, s:_mail_subject, mail#client#win#currentDir())
    elseif data =~ '* STATUS INBOX'
      let s:mail_unseen = matchstr(data, '\d\+')
    elseif data =~# '* OK Coremail System IMap Server Ready'
      call mail#client#send(mail#command#login(g:mail_imap_login, g:mail_imap_password))
      call mail#client#send(mail#command#select(mail#client#win#currentDir()))
      call mail#client#send(mail#command#fetch('1:15', 'BODY[HEADER.FIELDS ("DATE" "FROM" "SUBJECT")]'))
      call mail#client#send(mail#command#status('INBOX', '["RECENT"]'))
      let s:job_noop_timer = timer_start(20000, function('s:noop'), {'repeat' : -1})
    endif
  endfor
endfunction



function! s:on_stderr(id, data, event) abort
  for data in a:data
    call mail#logger#error('STDERR: ' . data)
  endfor
endfunction

function! s:on_exit(id, data, event) abort
  let s:job_id = 0
  if !empty(s:job_noop_timer)
    call timer_stop(s:job_noop_timer)
    let s:job_noop_timer = ''
  endif
endfunction


function! mail#client#send(command)
  call mail#logger#info('Send command: ' . a:command)
  if has('nvim')
    if s:job_id >= 0
      call chansend(s:job_id, [a:command, ''])
    else
      call mail#logger#info('skipped!, job id is:' . s:job_id)
    endif
  else
    call ch_sendraw(s:job_channel, a:command . "\n")
  endif
endfunction

function! mail#client#open()
  if s:job_id == 0
    if !empty(g:mail_imap_login) && !empty(g:mail_imap_password)
      call mail#client#connect(g:mail_imap_host, g:mail_imap_port)
    endif
  endif
  call mail#client#win#open()
endfunction


function! mail#client#unseen()

  return s:mail_unseen

endfunction
