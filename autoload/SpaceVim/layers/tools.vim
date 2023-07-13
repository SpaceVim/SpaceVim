"=============================================================================
" tools.vim --- SpaceVim tools layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:CMP')
  finish
endif

let s:CMP = SpaceVim#api#import('vim#compatible')

function! SpaceVim#layers#tools#plugins() abort
  let plugins = []
  call add(plugins, ['tpope/vim-scriptease',                      { 'merged' : 0}])
  call add(plugins, ['lymslive/vimloo',                           { 'merged' : 0}])
  call add(plugins, ['lymslive/vnote',                            { 'merged' : 0}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/rainbow',     { 'merged' : 0}])
  call add(plugins, ['mbbill/fencview',                           { 'on_cmd' : 'FencAutoDetect'}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-cheat',   { 'on_cmd' : 'Cheat'}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-unstack', { 'merged' : 0}])
  call add(plugins, ['wsdjeg/Mysql.vim',                          { 'on_cmd' : 'SQLGetConnection'}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/SourceCounter.vim',                  { 'on_cmd' : 'SourceCounter'}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/calendar.vim',{ 'on_cmd' : 'Calendar'}])
  call add(plugins, ['junegunn/limelight.vim',                    { 'on_cmd' : 'Limelight'}])
  call add(plugins, ['junegunn/goyo.vim',                         { 'on_cmd' : 'Goyo', 'loadconf' : 1}])
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-bookmarks',
        \ {'merged': 0,
        \ 'loadconf_before' : 1}])
  if s:CMP.has('python3')
    call add(plugins, ['fedorenchik/VimCalc3', {'on_cmd' : 'Calc'}])
  elseif s:CMP.has('python')
    call add(plugins, ['gregsexton/VimCalc', {'on_cmd' : 'Calc'}])
  endif

  return plugins
endfunction

function! SpaceVim#layers#tools#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'l'], 'Calendar', 'vim-calendar', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['e', 'a'], 'FencAutoDetect',
        \ 'auto-detect-file-encoding', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['a', 'c'], 'Calc', 'vim-calculator', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'c'],
        \ 'Goyo', 'centered-buffer-mode', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', 'C'],
        \ 'ChooseWin | Goyo', 'choose-window-centered-buffer-mode', 1)

  " bootmark key binding
  nnoremap <silent> mm :<C-u>BookmarkToggle<Cr>
  nnoremap <silent> mc :<C-u>BookmarkClear<Cr>
  nnoremap <silent> mi :<C-u>BookmarkAnnotate<Cr>
  nnoremap <silent> ma :<C-u>BookmarkShowAll<Cr>
  nnoremap <silent> mn :<C-u>BookmarkNext<Cr>
  nnoremap <silent> mp :<C-u>BookmarkPrev<Cr>
  if maparg('<C-_>', 'v') ==# ''
    vnoremap <silent> <C-_> <Esc>:Ydv<CR>
  endif
  if maparg('<C-_>', 'n') ==# ''
    nnoremap <silent> <C-_> <Esc>:Ydc<CR>
  endif
endfunction

function! SpaceVim#layers#tools#health() abort
  call SpaceVim#layers#tools#plugins()
  call SpaceVim#layers#tools#config()
  return 1
endfunction

" vim:set et sw=2 cc=80:
