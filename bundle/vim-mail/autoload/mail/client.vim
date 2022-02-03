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
" 一月份＝JAN.  Jan.=January
" 二月份＝FEB.  Feb.=February
" 三月份＝MAR.  Mar.=March
" 四月份＝APR.  Apr.=April
" 五月份＝MAY    May=May
" 六月份＝JUN.  Jun.=June
" 七月份＝JUL.  Jul.=July
" 八月份＝AUG.  Aug.=August
" 九月份＝SEP.  Sept.=September
" 十月份＝OCT.  Oct.=October
" 十一月份＝NOV. Nov.=November
" 十二月份＝DEC. Dec.=December
let s:__months = {
      \ 'Jan' : 1,
      \ 'Feb' : 2,
      \ 'Mar' : 3,
      \ 'Apr' : 4,
      \ 'May' : 5,
      \ 'Jun' : 6,
      \ 'Jul' : 7,
      \ 'Aug' : 8,
      \ 'Sep' : 9,
      \ 'Oct' : 10,
      \ 'Nov' : 11,
      \ 'Dec' : 12,
      \ }

let s:__week = {
      \ 'Sun' : 7,
      \ 'Mon' : 1,
      \ 'Tue' : 2,
      \ 'Wed' : 3,
      \ 'Thu' : 4,
      \ 'Fri' : 5,
      \ 'Sat' : 6,
      \ }

" Date: Sun, 24 Oct 2021 05:56:21 +0000
" Date: 23 Oct 2021 18:55:36 +0800
" Date: Wed, 13 Oct 2021 14:00:24 +0800 (CST)
function! s:convert(date) abort
  let week = matchstr(a:date, '^\(Sun\|Mon\|Tue\|Wed\|Thu\|Fri\|Sat\)')
  let day = matchstr(a:date, '\d\+')
  let mounth = get(s:__months, matchstr(a:date, '\d\+\s\zs\S\+'), '00')
  let year = matchstr(a:date, '\d\+\s\S\+\s\zs\d\+')
  let time = matchstr(a:date, '\d\+:\d\+:\d\+')
  return printf('%04d-%02d-%02d', year, mounth, day) . ' ' . time
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

" [ vim-mail ] [15:52:30] [ Info ] Send command: WKHCh FETCH 6:6 BODY[TEXT]
" [ vim-mail ] [15:52:30] [ Info ] STDOUT: * 6 FETCH (BODY[TEXT] {14}
" [ vim-mail ] [15:52:30] [ Info ] STDOUT: Ym9keSAxMjM0
" [ vim-mail ] [15:52:30] [ Info ] STDOUT: )
" [ vim-mail ] [15:52:30] [ Info ] STDOUT: WKHCh OK Fetch completed
" [ vim-mail ] [15:52:30] [ Info ] STDOUT:

let s:stdout_is_context = 0
function! s:on_stdout(id, data, event) abort
  for data in a:data
    call mail#logger#info('STDOUT: ' . data)
    if s:stdout_is_context
      if data =~ 'OK Fetch completed'
        let s:stdout_is_context = 0
      else
      endif
    else
      if data =~ '^\* \d\+ FETCH '
        let s:_mail_id = matchstr(data, '\d\+')
      elseif data =~ '^\*\s\+\d\+\s\+FETCH\s(BODY[TEXT\]'
        let s:stdout_is_context = 1
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
