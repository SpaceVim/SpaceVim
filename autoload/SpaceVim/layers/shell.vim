"=============================================================================
" shell.vim --- SpaceVim shell layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section shell, layer-shell
" @parentsection layers
" The shell layer use |:terminal| command if available.
"
" @subsection variable
"
" default_shell: config the default shell to be used by shell layer.
" default_position: config the positione of terminal, by default, it is `top`,
" you can set it to `float` if you are using nvim-0.4.0 or later version. for
" vim users, we need `has('patch-8.2.1266')`
"
" @subsection key bindings
" >
"   SPC '   Open or switch to terminal windows
"   q       Hide terminal windows in normal mode
" <

let s:SYSTEM = SpaceVim#api#import('system')
if has('nvim')
  let s:FLOAT = SpaceVim#api#import('neovim#floating')
else
  let s:FLOAT = SpaceVim#api#import('vim#floating')
endif

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
        \ . string(function('s:open_default_shell')) . ', [0])',
        \ ['open-shell',
        \ [
        \ "[SPC '] is to open or jump to default shell window",
        \ '',
        \ 'Definition: ' . s:file . ':' . s:lnum,
        \ ]
        \ ], 1)
  call SpaceVim#mapping#space#def('nnoremap', ["\""], 'call call('
        \ . string(function('s:open_default_shell')) . ', [1])',
        \ ['open-shell-in-buffer-dir',
        \ [
        \ "[SPC \"] is to open or jump to default shell window with the current file's pwd",
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
  let line = getline('.')
  if isdirectory(line[:-2])
    return "exit\<CR>"
  endif
  return ""
endf
func! SpaceVim#layers#shell#ctrl_u() abort
  let line = getline('.')
  let prompt = getcwd() . '>'
  return repeat("\<BS>", len(line) - len(prompt) + 2)
endfunction

func! SpaceVim#layers#shell#ctrl_r() abort
  let reg = getchar()
  if reg == 43
    return @+
  endif
  return "\<C-r>"
endfunction


func! SpaceVim#layers#shell#ctrl_w() abort
  let cursorpos = getcurpos()
  let line = getline(cursorpos[1])[:cursorpos[2]-1]
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

  return ['default_shell', 'default_position', 'default_height',]

endfunction

function! s:open_terminal(cmd, path) abort
  if has('nvim')
    return termopen(a:cmd, {'cwd': a:path})
  else
    return term_start(a:cmd, {'cwd': a:path, 'hidden': 1})
  endif
endfunction

function! s:support_float_terminal() abort
  if has('nvim')
    return s:FLOAT.exists()
  else
    return has('patch-8.2.1266')
  endif
endfunction

let s:open_terminals_buffers = []
" shell windows shoud be toggleable, and can be hide.


" 1. get the init path
function! s:get_terminal_init_path(usebufdir) abort
  if a:usebufdir
    if getwinvar(winnr(), '&buftype') ==# 'terminal'
      let path = getbufvar(winbufnr(winnr()), '_spacevim_shell_cwd', SpaceVim#plugins#projectmanager#current_root())
    else
      let path = expand('%:p:h')
    endif
  else
    let path = SpaceVim#plugins#projectmanager#current_root()
  endif
  return path
endfunction


" get the terminal bufnr, which has same path
function! s:get_terminal_bufnr(path) abort
  for open_terminal in s:open_terminals_buffers
    if bufexists(open_terminal) && getbufvar(open_terminal, '_spacevim_shell_cwd') ==# a:path
      return open_terminal
    endif
  endfor
endfunction

function! s:open_default_shell(usebufdir) abort
  let path = s:get_terminal_init_path(a:usebufdir)
  let bufnr = s:get_terminal_bufnr(path)
  if bufnr ==# 0
    if s:SYSTEM.isWindows
      let shell = empty($SHELL) ? 'cmd.exe' : $SHELL
    else
      let shell = empty($SHELL) ? 'bash' : $SHELL
    endif
    let bufnr = s:open_terminal(shell, path)
    call add(s:open_terminals_buffers, bufnr)
  endif

  if s:default_position == 'float' && s:support_float_terminal()
    let s:term_win_id =  s:FLOAT.open_win(bufnr, v:true,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : &columns, 
          \ 'height'  : &lines * s:default_height / 100,
          \ 'row': 0,
          \ 'col': &lines - (&lines * s:default_height / 100) - 2
          \ })

    exe win_id2win(s:term_win_id) .  'wincmd w'
  else
    " no terminal window found. Open a new window
    let cmd = s:default_position ==# 'float' ?
          \ 'topleft split' :
          \ s:default_position ==# 'top' ?
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
    exe 'b' . bufnr
    startinsert
  endif



  " " no terminal window with l:path as cwd has been found, let's open one
  " if s:default_shell ==# 'terminal'
  "   if exists(':terminal')
  "     if has('nvim')
  "       if s:SYSTEM.isWindows
  "         let shell = empty($SHELL) ? 'cmd.exe' : $SHELL
  "       else
  "         let shell = empty($SHELL) ? 'bash' : $SHELL
  "       endif
  "       enew
  "       call termopen(shell, {'cwd': l:path})
  "       " @bug cursor is not cleared when open terminal windows.
  "       " in neovim-qt when using :terminal to open a shell windows, the orgin
  "       " cursor position will be highlighted. switch to normal mode and back
  "       " is to clear the highlight.
  "       " This seem a bug of neovim-qt in windows.
  "       "
  "       " cc @equalsraf
  "       if s:SYSTEM.isWindows && has('nvim')
  "         stopinsert
  "         startinsert
  "       endif
  "       let s:term_buf_nr = bufnr('%')
  "       call extend(s:shell_cached_br, {getcwd() : s:term_buf_nr})
  "     elseif has('patch-8.2.1266')
  "     else
  "       " handle vim terminal
  "       if s:SYSTEM.isWindows
  "         let shell = empty($SHELL) ? 'cmd.exe' : $SHELL
  "       else
  "         let shell = empty($SHELL) ? 'bash' : $SHELL
  "       endif
  "       let s:term_buf_nr = term_start(shell, {'cwd': l:path, 'curwin' : 1, 'term_finish' : 'close'})
  "     endif
  "     call add(s:open_terminals_buffers, s:term_buf_nr)
  "     let b:_spacevim_shell = shell
  "     let b:_spacevim_shell_cwd = l:path
  "
  "     " use WinEnter autocmd to update statusline
  "     doautocmd WinEnter
  "     setlocal nobuflisted nonumber norelativenumber
  "
  "     " use q to hide terminal buffer in vim, if vimcompatible mode is not
  "     " enabled, and smart quit is on.
  "     if !empty(g:spacevim_windows_smartclose)  && !g:spacevim_vimcompatible
  "       exe 'nnoremap <buffer><silent> ' . g:spacevim_windows_smartclose . ' :hide<CR>'
  "     endif
  "     startinsert
  "   else
  "     echo ':terminal is not supported in this version'
  "   endif
  " elseif s:default_shell ==# 'VimShell'
  "   VimShell
  "   imap <buffer> <C-d> exit<esc><Plug>(vimshell_enter)
  " endif
endfunction

function! SpaceVim#layers#shell#close_terminal() abort
  for terminal_bufnr in s:open_terminals_buffers
    if bufexists(terminal_bufnr)
      exe 'silent bd!' . terminal_bufnr
    endif
  endfor
endfunction
