"=============================================================================
" mail.vim --- mail manager for vim
" Copyright (c) 2016-2022 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://github.com/vim-mail/vim-mail
" License: MIT license
"=============================================================================


let g:mail_command = 'telnet'
let g:mail_method = 'imap'
let g:mail_sending_name = 'Shidong Wang'
let g:mail_sending_address = 'wsdjeg@163.com'
let g:mail_logger_silent = 0

let g:mail_imap_host = get(g:, 'mail_imap_host', 'imap.163.com')
let g:mail_imap_port = get(g:, 'mail_imap_port', 143)
let g:mail_imap_login = get(g:, 'mail_imap_login', '')
let g:mail_imap_password = get(g:, 'mail_imap_password', '')

if !exists('g:mail_directory')
    let g:mail_directory = expand('~/.vim-mail/')
endif
