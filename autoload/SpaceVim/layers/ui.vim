"=============================================================================
" ui.vim --- SpaceVim ui layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8
function! SpaceVim#layers#ui#plugins() abort
  let plugins = [
        \ ['Yggdroot/indentLine', {'merged' : 0}],
        \ ['majutsushi/tagbar', {'loadconf' : 1}],
        \ ['tenfyzhong/tagbar-makefile.vim', {'merged': 0}],
        \ ['tenfyzhong/tagbar-proto.vim', {'merged': 0}],
        \ ['lvht/tagbar-markdown',{'merged' : 0}],
        \ ['t9md/vim-choosewin', {'merged' : 0}],
        \ ['mhinz/vim-startify', {'loadconf' : 1, 'merged' : 0}],
        \ ]
  if !SpaceVim#layers#isLoaded('core#statusline')
    call add(plugins, ['vim-airline/vim-airline',                { 'merged' : 0, 
          \ 'loadconf' : 1}])
    call add(plugins, ['vim-airline/vim-airline-themes',         { 'merged' : 0}])
  endif

  return plugins

endfunction

function! SpaceVim#layers#ui#config() abort
  if g:spacevim_colorscheme_bg == 'dark'
    let g:indentLine_color_term = get(g:, 'indentLine_color_term', 239)
    let g:indentLine_color_gui = get(g:, 'indentLine_color_gui', '#504945')
  else
    let g:indentLine_color_gui = get(g:, 'indentLine_color_gui', '#d5c4a1')
  endif
  let g:indentLine_char = get(g:, 'indentLine_char', '┊')
  let g:indentLine_concealcursor = 'niv'
  let g:indentLine_conceallevel = 2
  let g:indentLine_fileTypeExclude = ['help', 'man', 'startify', 'vimfiler']
  let g:signify_disable_by_default = 0
  let g:signify_line_highlight = 0
  noremap <silent> <F2> :silent TagbarToggle<CR>
  if !empty(g:spacevim_windows_smartclose)
    call SpaceVim#mapping#def('nnoremap <silent>', g:spacevim_windows_smartclose, ':<C-u>call zvim#util#SmartClose()<cr>',
          \ 'Smart close windows',
          \ 'call zvim#util#SmartClose()')
  endif
  " Ui toggles
  call SpaceVim#mapping#space#def('nnoremap', ['t', '8'], 'call call('
        \ . string(s:_function('s:toggle_fill_column')) . ', [])',
        \ 'toggle-colorcolumn', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'b'], 'call ToggleBG()',
        \ 'toggle background', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 't'], 'call SpaceVim#plugins#tabmanager#open()',
        \ 'Open tabs manager', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'f'], 'call call('
        \ . string(s:_function('s:toggle_colorcolumn')) . ', [])',
        \ 'toggle-colorcolumn', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'h'], 'set cursorline!',
        \ 'toggle highlight of the current line', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'i'], 'call call('
        \ . string(s:_function('s:toggle_indentline')) . ', [])',
        \ ['toggle highlight indentation levels',
        \ [
        \ 'SPC t h i is to running :IndentLinesToggle which is definded in indentLine'
        \ ]
        \ ], 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 'c'], 'set cursorcolumn!',
        \ 'toggle highlight indentation current column', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'h', 's'], 'call call('
        \ . string(s:_function('s:toggle_syntax_hi')) . ', [])',
        \ 'toggle syntax highlighting', 1)

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
        \ 'toggle spell checker', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['t', 'w'], 'call call('
        \ . string(s:_function('s:toggle_whitespace')) . ', [])',
        \ 'toggle the whitespace', 1)
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
    set cc=80
    let s:ccflag = 1
  else
    set cc=
    let s:ccflag = 0
  endif
  call SpaceVim#layers#core#statusline#toggle_mode('fill-column-indicator')
endfunction

let s:fcflag = 0
function! s:toggle_fill_column() abort
  if !s:fcflag
    let &colorcolumn=join(range(80,999),',')
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

function! s:toggle_whitespace() abort
  call SpaceVim#layers#core#statusline#toggle_section('whitespace')
  call SpaceVim#layers#core#statusline#toggle_mode('whitespace')
endfunction
