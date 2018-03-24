"for open-browser {{{
" This is my setting.
let g:netrw_nogx = get(g:, 'netrw_nogx', 1) " disable netrw's gx mapping.
"nmap gx <Plug>(openbrowser-smart-search)
"vmap gx <Plug>(openbrowser-smart-search)
"" Open URI under cursor.
nnoremap go <Plug>(openbrowser-open)
"" Open selected URI.
vnoremap go <Plug>(openbrowser-open)
" Search word under cursor.
nnoremap gs <Plug>(openbrowser-search)
" Search selected word.
vnoremap gs <Plug>(openbrowser-search)
" If it looks like URI, Open URI under cursor.
" Otherwise, Search word under cursor.
nnoremap gx <Plug>(openbrowser-smart-search)
" If it looks like URI, Open selected URI.
" Otherwise, Search selected word.
vnoremap gx <Plug>(openbrowser-smart-search)
vnoremap gob :OpenBrowser http://www.baidu.com/s?wd=<C-R>=expand("<cword>")<cr><cr>
nnoremap gob :OpenBrowser http://www.baidu.com/s?wd=<C-R>=expand("<cword>")<cr><cr>
vnoremap gog :OpenBrowser http://www.google.com/?#newwindow=1&q=<C-R>=expand("<cword>")<cr><cr>
nnoremap gog :OpenBrowser http://www.google.com/?#newwindow=1&q=<C-R>=expand("<cword>")<cr><cr>
vnoremap goi :OpenBrowserSmartSearch http://www.iciba.com/<C-R>=expand("<cword>")<cr><cr>
nnoremap goi :OpenBrowserSmartSearch http://www.iciba.com/<C-R>=expand("<cword>")<cr><cr>
" In command-line
":OpenBrowser http://google.com/
":OpenBrowserSearch ggrks
":OpenBrowserSmartSearch http://google.com/
":OpenBrowserSmartSearch ggrks
"}}}
