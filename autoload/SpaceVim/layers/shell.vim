"=============================================================================
" shell.vim --- SpaceVim shell layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section shell, layer-shell
" @parentsection layers
" SpaceVim uses deol.nvim for shell support in neovim and uses vimshell for
" vim. For more info, read |deol| and |vimshell|.
"
" @subsection variable
"
" default_shell: config the default shell to be used by shell layer.
"
" @subsection key bindings
" >
"   SPC '   Open or switch to terminal windows
"   q       Hide terminal windows in normal mode
" <

let s:SYSTEM = SpaceVim#api#import('system')

function! SpaceVim#layers#shell#plugins() abort
  let plugins = []
  if has('nvim')
    call add(plugins,['Shougo/deol.nvim'])
  endif
  call add(plugins,['Shougo/vimshell.vim',                { 'on_cmd':['VimShell']}])
  return plugins
endfunction

let s:file = expand('<sfile>:~')
let s:lnum = expand('<slnum>') + 2
function! SpaceVim#layers#shell#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ["'"], 'call call('
        \ . string(function('s:open_default_shell')) . ', [])',
        \ ['open shell',
        \ [
        \ "[SPC '] is to open or jump to default shell window",
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ], 1)

  if has('nvim') || exists(':tnoremap') == 2
    exe 'tnoremap <silent><C-Right> <C-\><C-n>:<C-u>wincmd l<CR>'
    exe 'tnoremap <silent><C-Left>  <C-\><C-n>:<C-u>wincmd h<CR>'
    exe 'tnoremap <silent><C-Up>    <C-\><C-n>:<C-u>wincmd k<CR>'
    exe 'tnoremap <silent><C-Down>  <C-\><C-n>:<C-u>wincmd j<CR>'
    exe 'tnoremap <silent><M-Left>  <C-\><C-n>:<C-u>bprev<CR>'
    exe 'tnoremap <silent><M-Right>  <C-\><C-n>:<C-u>bnext<CR>'
    exe 'tnoremap <silent><esc>     <C-\><C-n>'
    if s:SYSTEM.isWindows
      exe 'tnoremap <expr><silent><C-d>  SpaceVim#layers#shell#terminal()'
      exe 'tnoremap <expr><silent><C-u>  SpaceVim#layers#shell#ctrl_u()'
      exe 'tnoremap <expr><silent><C-w>  SpaceVim#layers#shell#ctrl_w()'
      exe 'tnoremap <expr><silent><C-r>  SpaceVim#layers#shell#ctrl_r()'
    endif
  endif
  " in window gvim, use <C-d> to close terminal buffer

endfunction

" FIXME: 
func! SpaceVim#layers#shell#terminal() abort
  let line = getline('$')
  if isdirectory(line[:-2])
    return "exit\<CR>"
  endif
  return "\<C-d>"
endf
func! SpaceVim#layers#shell#ctrl_u() abort
  let line = getline('$')
  let prompt = getcwd() . '>'
  return repeat("\<BS>", len(line) - len(prompt) + 2)
endfunction

func! SpaceVim#layers#shell#ctrl_r() abort
  let reg = getchar()
  if reg == 43
    return @+
  endif
endfunction

func! SpaceVim#layers#shell#ctrl_w() abort
  let cursorpos = term_getcursor(s:term_buf_nr)
  let line = getline(cursorpos[0])[:cursorpos[1]-1]
  let str = matchstr(line, '[^ ]*\s*$')
  return repeat("\<BS>", len(str))
endfunction


let s:default_shell = 'terminal'
let s:default_position = 'top'
let s:default_height = 30
" the shell should be cached base on the root of a project, cache the terminal
" buffer id in: s:shell_cached_br 
let s:enable_project_shell = 1
let s:shell_cached_br = {}

function! SpaceVim#layers#shell#set_variable(var) abort
  let s:default_shell = get(a:var, 'default_shell', 'terminal')
  let s:default_position = get(a:var, 'default_position', 'top')
  let s:default_height = get(a:var, 'default_height', 30)
  let s:enable_project_shell = get(a:var, 'enable_project_shell', 1)
endfunction

function! SpaceVim#layers#shell#get_options() abort

  return ['default_shell', 'default_position', 'default_height']

endfunction

let s:shell_win_nr = -1
let s:term_buf_nr = -1
" shell windows shoud be toggleable, and can be hide.
function! s:open_default_shell() abort
  if s:shell_win_nr != 0 && getwinvar(s:shell_win_nr, '&buftype') ==# 'terminal' && &buftype !=# 'terminal'
    exe s:shell_win_nr .  'wincmd w'
    " fuck gvim bug, startinsert do not work in gvim
    if has('nvim')
      startinsert
    else
      normal! a
    endif
    return
  endif
  if &buftype ==# 'terminal'
    if has('nvim')
      startinsert
    else
      normal! a
    endif
    return
  endif
  let cmd = s:default_position ==# 'top' ?
        \ 'topleft split' :
        \ s:default_position ==# 'bottom' ?
        \ 'botright split' :
        \ s:default_position ==# 'right' ?
        \ 'rightbelow vsplit' : 'leftabove vsplit'
  exe cmd
  let lines = &lines * s:default_height / 100
  if lines < winheight(0) && (s:default_position ==# 'top' || s:default_position ==# 'bottom')
    exe 'resize ' . lines
  endif
  if bufexists(s:term_buf_nr)
    exe 'silent b' . s:term_buf_nr
    " clear the message 
    if has('nvim')
      startinsert
    else
      normal! a
    endif
    return
  endif
  if s:default_shell ==# 'terminal'
    if exists(':terminal')
      if has('nvim')
        if s:SYSTEM.isWindows
          let shell = empty($SHELL) ? 'cmd.exe' : $SHELL
        else
          let shell = empty($SHELL) ? 'bash' : $SHELL
        endif
        terminal
        " @bug cursor is not cleared when open terminal windows.
        " in neovim-qt when using :terminal to open a shell windows, the orgin
        " cursor position will be highlighted. switch to normal mode and back
        " is to clear the highlight.
        " This seem a bug of neovim-qt in windows.
        "
        " cc @equalsraf
        if s:SYSTEM.isWindows && has('nvim')
          stopinsert
          startinsert
        endif
        let s:term_buf_nr = bufnr('%')
        call extend(s:shell_cached_br, {getcwd() : s:term_buf_nr})
      else
        if s:SYSTEM.isWindows
          let shell = empty($SHELL) ? 'cmd.exe' : $SHELL
        else
          let shell = empty($SHELL) ? 'bash' : $SHELL
        endif
        let s:term_buf_nr = term_start(shell, {'curwin' : 1, 'term_finish' : 'close'})
      endif
      let b:_spacevim_shell = shell
      " use WinEnter autocmd to update statusline
      doautocmd WinEnter
      let s:shell_win_nr = winnr()
      let w:shell_layer_win = 1
      setlocal nobuflisted nonumber norelativenumber
      " use q to hide terminal buffer in vim, if vimcompatible mode is not
      " enabled, and smart quit is on.
      if g:spacevim_windows_smartclose == 0 && !g:spacevim_vimcompatible
        nnoremap <buffer><silent> q :hide<CR>
      endif
      startinsert
    else
      echo ':terminal is not supported in this version'
    endif
  elseif s:default_shell ==# 'VimShell'
    VimShell
    imap <buffer> <C-d> exit<esc><Plug>(vimshell_enter)
  endif
endfunction

function! SpaceVim#layers#shell#close_terminal()
  if bufexists(s:term_buf_nr)
    exe 'silent bd!' . s:term_buf_nr
  endif
endfunction
