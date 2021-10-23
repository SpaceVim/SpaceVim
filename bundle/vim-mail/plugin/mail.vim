"=============================================================================
" mail.vim --- mail manager for vim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://github.com/vim-mail/vim-mail
" License: MIT license
"=============================================================================


let g:mail_command = 'telnet'
let g:mail_method = 'imap'
let g:mail_sending_name = 'Shidong Wang'
let g:mail_sending_address = 'wsdjeg@163.com'
let g:mail_logger_silent = 0
if !exists('g:mail_directory')
    let g:mail_directory = expand('~/.vim-mail/')
endif
