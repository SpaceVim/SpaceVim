" vim:foldmethod=marker:fen:
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_openbrowser') && g:loaded_openbrowser
  finish
endif
let g:loaded_openbrowser = 1

if !(has('unix') || has('win32'))
  echohl WarningMsg
  echomsg 'Your platform is not supported!'
  echohl None
  finish
endif


" For backward compatibility,
" - OpenBrowser()
" - OpenBrowserSearch()

function! OpenBrowser(...)
  return call('openbrowser#open', a:000)
endfunction

function! OpenBrowserSearch(...)
  return call('openbrowser#search', a:000)
endfunction



" Ex command
command!
\   -nargs=+
\   OpenBrowser
\   call openbrowser#_cmd_open(<q-args>)
command!
\   -nargs=+ -complete=customlist,openbrowser#_cmd_search_complete
\   OpenBrowserSearch
\   call openbrowser#_cmd_search(<q-args>)
command!
\   -nargs=+ -complete=customlist,openbrowser#_cmd_search_complete
\   OpenBrowserSmartSearch
\   call openbrowser#_cmd_smart_search(<q-args>)



" Key-mapping
nnoremap <silent> <Plug>(openbrowser-open) :<C-u>call openbrowser#_keymap_open('n')<CR>
xnoremap <silent> <Plug>(openbrowser-open) :<C-u>call openbrowser#_keymap_open('v')<CR>
nnoremap <silent> <Plug>(openbrowser-open-incognito) :<C-u>call openbrowser#_keymap_open('n', 0, ['--incognito'])<CR>
xnoremap <silent> <Plug>(openbrowser-open-incognito) :<C-u>call openbrowser#_keymap_open('v', 0, ['--incognito'])<CR>
nnoremap <silent> <Plug>(openbrowser-search) :<C-u>call openbrowser#_keymap_search('n')<CR>
xnoremap <silent> <Plug>(openbrowser-search) :<C-u>call openbrowser#_keymap_search('v')<CR>
nnoremap <silent> <Plug>(openbrowser-smart-search) :<C-u>call openbrowser#_keymap_smart_search('n')<CR>
xnoremap <silent> <Plug>(openbrowser-smart-search) :<C-u>call openbrowser#_keymap_smart_search('v')<CR>


" Popup menus for Right-Click
if !get(g:, 'openbrowser_no_default_menus', (&guioptions =~# 'M'))
  function! s:add_menu() abort
    if get(g:, 'openbrowser_menu_lang',
    \      &langmenu isnot# '' ? &langmenu : v:lang) =~# '^ja'
      runtime! lang/openbrowser_menu_ja.vim
    endif

    nnoremenu PopUp.-OpenBrowserSep- <Nop>
    xnoremenu PopUp.-OpenBrowserSep- <Nop>
    nmenu <silent> PopUp.Open\ URL <Plug>(openbrowser-open)
    xmenu <silent> PopUp.Open\ URL <Plug>(openbrowser-open)
    nmenu <silent> PopUp.Open\ Word(s) <Plug>(openbrowser-search)
    xmenu <silent> PopUp.Open\ Word(s) <Plug>(openbrowser-search)
    nmenu <silent> PopUp.Open\ URL\ or\ Word(s) <Plug>(openbrowser-smart-search)
    xmenu <silent> PopUp.Open\ URL\ or\ Word(s) <Plug>(openbrowser-smart-search)
  endfunction

  augroup openbrowser-menu
    autocmd!
    autocmd GUIEnter * call s:add_menu()
  augroup END
endif


let &cpo = s:save_cpo
