"=============================================================================
" api.vim --- the list of telegram apis
" Copyright (c) 2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://github.com/wsdjeg/telegram.vim
" License: GPLv3
"=============================================================================


""
" set the bot token
let g:telegram_bot_token = get(g:, 'telegram_bot_token', '')

""
" set http proxy for example:
" >
"   let g:telegram_http_proxy = 'http://127.0.0.1:8787'
" <
let g:telegram_http_proxy = ''
""
" set https proxy for example:
" >
"   let g:telegram_https_proxy = 'http://127.0.0.1:8787'
" <
let g:telegram_https_proxy = ''
