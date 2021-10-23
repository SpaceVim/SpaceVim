let s:job_id = 0
let s:job_noop_timer = ''

let s:JOB = SpaceVim#api#import('job')

function! mail#client#connect(ip, port)
    let argv = ['telnet', a:ip, a:port]
    let s:job_id = s:JOB.start(argv,
                \ {
                \ 'on_stdout' : function('s:on_stdout'),
                \ 'on_stderr' : function('s:on_stderr'),
                \ 'on_exit' : function('s:on_exit'),
                \ }
                \ )

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

function! s:parser(data) abort
    if type(a:data) == 3
        for data in a:data
            call mail#client#logger#info('STDOUT: ' . data)
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
            endif
        endfor
    else
        echom a:data
    endif
endfunction

function! s:on_stdout(id, data, event) abort
    call s:parser(a:data)
endfunction



function! s:on_stderr(id, data, event) abort
    for data in a:data
        call mail#client#logger#error('STDERR: ' . data)
    endfor
endfunction

function! s:on_exit(id, data, event) abort
    call s:parser(a:data)
    let s:job_id = 0
    if !empty(s:job_noop_timer)
        call timer_stop(s:job_noop_timer)
        let s:job_noop_timer = ''
    endif
endfunction


function! mail#client#send(command)
    call mail#client#logger#info('Send command: ' . a:command)
    call s:JOB.send(s:job_id, a:command)   
endfunction

function! mail#client#open()
    if s:job_id == 0
        let username = input('USERNAME: ')
        let password = input('PASSWORD: ')
        if !empty(username) && !empty(password)
            call mail#client#connect('imap.163.com', 143)
            call mail#client#send(mail#command#login(username, password))
            call mail#client#send(mail#command#select(mail#client#win#currentDir()))
            call mail#client#send(mail#command#fetch('1:15', 'BODY[HEADER.FIELDS ("DATE" "FROM" "SUBJECT")]'))
            call mail#client#send(mail#command#status('INBOX', '["RECENT"]'))
            let s:job_noop_timer = timer_start(20000, function('s:noop'), {'repeat' : -1})
        endif
    endif
    call mail#client#win#open()
endfunction


function! mail#client#unseen()

    return s:mail_unseen

endfunction
