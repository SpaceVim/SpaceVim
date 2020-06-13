"=============================================================================
" ui.vim --- SpaceVim ui layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8
function! SpaceVim#layers#ui#plugins() abort
  let plugins = [
        \ [g:_spacevim_root_dir . 'bundle/indentLine', {'merged' : 0}],
        \ [g:_spacevim_root_dir . 'bundle/tagbar', {'loadconf' : 1, 'merged' : 0}],
        \ [g:_spacevim_root_dir . 'bundle/tagbar-makefile.vim', {'merged': 0}],
        \ [g:_spacevim_root_dir . 'bundle/tagbar-proto.vim', {'merged': 0}],
        \ [g:_spacevim_root_dir . 'bundle/vim-choosewin', {'merged' : 0}],
        \ [g:_spacevim_root_dir . 'bundle/vim-startify', {'loadconf' : 1, 'merged' : 0}],
        \ ]
  if !SpaceVim#layers#isLoaded('core#statusline')
    call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-airline',                { 'merged' : 0, 
          \ 'loadconf' : 1}])
    call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-airline-themes',         { 'merged' : 0}])
  endif

  return plugins

endfunction

function! SpaceVim#layers#ui#config() abort
  if g:spacevim_colorscheme_bg ==# 'dark'
    let g:indentLine_color_term = get(g:, 'indentLine_color_term', 239)
    let g:indentLine_color_gui = get(g:, 'indentLine_color_gui', '#504945')
  else
    let g:indentLine_color_gui = get(g:, 'indentLine_color_gui', '#d5c4a1')
  endif
  let g:indentLine_char = get(g:, 'indentLine_char', '┊')
  let g:indentLine_concealcursor = 'niv'
  let g:indentLine_conceallevel = 2
  let g:indentLine_fileTypeExclude = ['help', 'man', 'startify', 'vimfiler', 'json']
  let g:better_whitespace_filetypes_blacklist = ['diff', 'gitcommit', 'unite',
        \ 'qf', 'help', 'markdown', 'leaderGuide',
        \ 'startify'
        \ ]
  let g:signify_disable_by_default = 0
  let g:signify_line_highlight = 0

  if s:enable_sidebar
    noremap <silent> <F2> :call SpaceVim#plugins#sidebar#toggle()<CR>
  else
    noremap <silent> <F2> :TagbarToggle<CR>
  endif

  if !empty(g:spacevim_windows_smartclose)
    call SpaceVim#mapping#def('nnoremap <silent>', g:spacevim_windows_smartclose, ':<C-u>call SpaceVim#mapping#SmartClose()<cr>',
          \ 'smart-close-windows',
          \ 'call SpaceVim#mapping#SmartClose()')
  endif
  " Ui toggles
  call SpaceVim#mapping#space#def('nnoremap', ['t', '8'], 'call call('
        \ . string(s:_function('s:toggle_fill_column')) . ', [])',
        \ 'highlight-long-lines', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'b'], 'call call('
        \ . string(s:_function('s:toggle_background')) . ', [])',
        \ 'toggle background', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['w', '.'], 'call call('
        \ . string(s:_function('s:win_resize_transient_state')) . ', [])',
        \ 'windows-transient-state', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'c'], 'call call('
        \ . string(s:_function('s:toggle_conceallevel')) . ', [])',
        \ 'toggle conceallevel', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 't'], 'call SpaceVim#plugins#tabmanager#open()',
        \ 'open-tabs-manager', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'f'], 'call call('
        \ . string(s:_function('s:toggle_colorcolumn')) . ', [])',
        \ 'fill-column-indicator', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'h'], 'call call('
        \ . string(s:_function('s:toggle_cursorline')) . ', [])',
        \ ['toggle-highlight-current-line',
        \ [
        \ 'SPC t h h is to toggle the highlighting of cursorline'
        \ ]
        \ ], 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'i'], 'call call('
        \ . string(s:_function('s:toggle_indentline')) . ', [])',
        \ ['toggle-highlight-indentation-levels',
        \ [
        \ 'SPC t h i is to running :IndentLinesToggle which is definded in indentLine'
        \ ]
        \ ], 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'c'], 'set cursorcolumn!',
        \ 'toggle-highlight-current-column', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 's'], 'call call('
        \ . string(s:_function('s:toggle_syntax_hi')) . ', [])',
        \ 'toggle-syntax-highlighting', 1)

  call SpaceVim#mapping#space#def('nnoremap', ['T', 'F'], '<F11>',
        \ 'fullscreen-frame', 0)
  call SpaceVim#mapping#space#def('nnoremap', ['T', 'm'], 'call call('
        \ . string(s:_function('s:toggle_menu_bar')) . ', [])',
        \ 'toggle-menu-bar', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['T', 'f'], 'call call('
        \ . string(s:_function('s:toggle_win_fringe')) . ', [])',
        \ 'toggle-win-fringe', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['T', 't'], 'call call('
        \ . string(s:_function('s:toggle_tool_bar')) . ', [])',
        \ 'toggle-tool-bar', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['T', '~'], 'call call('
        \ . string(s:_function('s:toggle_end_of_buffer')) . ', [])',
        \ 'display ~ in the fringe on empty lines', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'S'], 'call call('
        \ . string(s:_function('s:toggle_spell_check')) . ', [])',
        \ 'toggle-spell-checker', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'p'], 'call call('
        \ . string(s:_function('s:toggle_paste')) . ', [])',
        \ 'toggle-paste-mode', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'l'], 'setlocal list!',
        \ 'toggle-hidden-listchars', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'W'], 'setlocal wrap!',
        \ 'toggle-wrap-line', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'w'], 'call call('
        \ . string(s:_function('s:toggle_whitespace')) . ', [])',
        \ 'toggle-highlight-tail-spaces', 1)

  " download gvimfullscreen.dll from github, copy gvimfullscreen.dll to
  " the directory that has gvim.exe
  if has('nvim')
    nnoremap <silent> <F11> :call <SID>toggle_full_screen()<Cr>
  else
    nnoremap <silent> <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<cr>
  endif
endfunction

let s:fullscreen_flag = 0
function! s:toggle_full_screen() abort
  if s:fullscreen_flag == 0
    call GuiWindowFullScreen(1)
    let s:fullscreen_flag = 1
  else
    call GuiWindowFullScreen(0)
    let s:fullscreen_flag = 0
  endif
endfunction

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif
let s:tmflag = 0
function! s:toggle_menu_bar() abort
  if !s:tmflag
    set go+=m
    let s:tmflag = 1
  else
    set go-=m
    let s:tmflag = 0
  endif
endfunction

let s:ttflag = 0
function! s:toggle_tool_bar() abort
  if !s:ttflag
    set go+=T
    let s:ttflag = 1
  else
    set go-=T
    let s:ttflag = 0
  endif
endfunction

if &cc ==# '80'
  let s:ccflag = 1
else
  let s:ccflag = 0
endif
function! s:toggle_colorcolumn() abort
  if !s:ccflag
    let &cc = g:spacevim_max_column
    let s:ccflag = 1
  else
    set cc=
    let s:ccflag = 0
  endif
  call SpaceVim#layers#core#statusline#toggle_mode('fill-column-indicator')
endfunction

let s:fcflag = 0
" use &textwidth option instead of 80
function! s:toggle_fill_column() abort
  if !s:fcflag
    if !&textwidth
      let &colorcolumn=join(range(81,999),',')
    else
      let &colorcolumn=join(range(&textwidth + 1,999),',')
    endif
    let s:fcflag = 1
  else
    set cc=
    let s:fcflag = 0
  endif
  call SpaceVim#layers#core#statusline#toggle_mode('hi-characters-for-long-lines')
endfunction

function! s:toggle_indentline() abort
  IndentLinesToggle
endfunction

let s:shflag = 0
function! s:toggle_syntax_hi() abort
  if !s:shflag
    syntax off
    let s:shflag = 1
  else
    syntax on
    let s:shflag = 0
  endif
endfunction

let s:ebflag = 0
let s:HI = SpaceVim#api#import('vim#highlight')
function! s:toggle_end_of_buffer() abort
  if !s:ebflag
    if &background ==# 'dark'
      hi EndOfBuffer guifg=white
    else
      hi EndOfBuffer guifg=gray
    endif
    let s:ebflag = 1
  else
    if (exists('+termguicolors') && &termguicolors) || has('gui_running')
      let normalbg = s:HI.group2dict('Normal').guibg
    else
      let normalbg = s:HI.group2dict('Normal').ctermbg
    endif
    exe 'hi! EndOfBuffer guifg=' . normalbg . ' guibg=' . normalbg
    let s:ebflag = 0
  endif
endfunction

let s:tfflag = 0
function! s:toggle_win_fringe() abort
  if !s:tfflag
    set guioptions+=L
    set guioptions+=r
    let s:tfflag = 1
  else
    set guioptions-=L
    set guioptions-=r
    let s:tfflag = 0
  endif
endfunction

function! s:toggle_cursorline() abort
  setl cursorline!
  let g:_spacevim_cursorline_flag = g:_spacevim_cursorline_flag * -1
endfunction

function! s:toggle_spell_check() abort
  if &l:spell
    let &l:spell = 0
  else
    let &l:spell = 1
  endif
  call SpaceVim#layers#core#statusline#toggle_mode('spell-checking')
  if &l:spell == 1
    echo 'spell-checking enabled.'
  else
    echo 'spell-checking disabled.'
  endif
endfunction

function! s:toggle_paste() abort
  if &l:paste
    let &l:paste = 0
  else
    let &l:paste = 1
  endif
  call SpaceVim#layers#core#statusline#toggle_mode('paste-mode')
  if &l:paste == 1
    echo 'paste-mode enabled.'
  else
    echo 'paste-mode disabled.'
  endif
  
endfunction

let s:whitespace_enable = 0
function! s:toggle_whitespace() abort
  if s:whitespace_enable
    DisableWhitespace
    let s:whitespace_enable = 0
  else
    EnableWhitespace
    let s:whitespace_enable = 1
  endif
  call SpaceVim#layers#core#statusline#toggle_section('whitespace')
  call SpaceVim#layers#core#statusline#toggle_mode('whitespace')
endfunction

function! s:toggle_conceallevel() abort
    if &conceallevel == 0 
        setlocal conceallevel=2
    else
        setlocal conceallevel=0
    endif
endfunction

function! s:toggle_background() abort
    let s:tbg = &background
    " Inversion
    if s:tbg ==# 'dark'
        set background=light
    else
        set background=dark
    endif
endfunction


function! s:win_resize_transient_state() abort
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Windows Resize Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ {
        \ 'key' : 'H',
        \ 'desc' : 'left',
        \ 'func' : '',
        \ 'cmd' : 'wincmd h',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'J',
        \ 'desc' : 'below',
        \ 'func' : '',
        \ 'cmd' : 'wincmd j',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'K',
        \ 'desc' : 'up',
        \ 'func' : '',
        \ 'cmd' : 'wincmd k',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'L',
        \ 'desc' : 'right',
        \ 'func' : '',
        \ 'cmd' : 'wincmd l',
        \ 'exit' : 0,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : 'h',
        \ 'desc' : 'decrease width',
        \ 'func' : '',
        \ 'cmd' : 'vertical resize -1',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'l',
        \ 'desc' : 'increase width',
        \ 'func' : '',
        \ 'cmd' : 'vertical resize +1',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'j',
        \ 'desc' : 'decrease height',
        \ 'func' : '',
        \ 'cmd' : 'resize -1',
        \ 'exit' : 0,
        \ },
        \ {
        \ 'key' : 'k',
        \ 'desc' : 'increase height',
        \ 'func' : '',
        \ 'cmd' : 'resize +1',
        \ 'exit' : 0,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction


let s:enable_sidebar = 0

function! SpaceVim#layers#ui#set_variable(var) abort

  let s:enable_sidebar = get(a:var,
        \ 'enable_sidebar',
        \ 0)

endfunction
