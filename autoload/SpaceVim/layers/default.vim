"=============================================================================
" default.vim --- SpaceVim default layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#default#plugins() abort
endfunction

function! SpaceVim#layers#defaultconfig() abort

  " indent use backspace delete indent, eol use backspace delete line at
  " begining start delete the char you just typed in if you do not use set
  " nocompatible ,you need this
  set backspace=indent,eol,start
  set nrformats-=octal
  set listchars=tab:→\ ,eol:↵,trail:·,extends:↷,precedes:↶
  set fillchars=vert:│,fold:·

  set laststatus=2

  " hide cmd
  set noshowcmd

  " indent
  set autoindent
  set smartindent
  set cindent

  " show wildmenu
  set wildmenu

  " do not break words.
  set linebreak

  " Enable line number
  set number

  " Automatically read a file changed outside of vim
  set autoread

  " Set SpaceVim data directory {{{
  " use ~/.cache/SpaceVim/ as default data directory, create the directory if
  " it does not exist.
  set backup
  set undofile
  set undolevels=1000
  let g:data_dir = $HOME . '/.cache/SpaceVim/'
  let g:backup_dir = g:data_dir . 'backup'
  let g:swap_dir = g:data_dir . 'swap'
  let g:undo_dir = g:data_dir . 'undofile'
  let g:conf_dir = g:data_dir . 'conf'
  if finddir(g:data_dir) ==# ''
    silent call mkdir(g:data_dir, 'p', 0700)
  endif
  if finddir(g:backup_dir) ==# ''
    silent call mkdir(g:backup_dir, 'p', 0700)
  endif
  if finddir(g:swap_dir) ==# ''
    silent call mkdir(g:swap_dir, 'p', 0700)
  endif
  if finddir(g:undo_dir) ==# ''
    silent call mkdir(g:undo_dir, 'p', 0700)
  endif
  if finddir(g:conf_dir) ==# ''
    silent call mkdir(g:conf_dir, 'p', 0700)
  endif
  unlet g:data_dir
  unlet g:backup_dir
  unlet g:swap_dir
  unlet g:undo_dir
  unlet g:conf_dir
  set undodir=$HOME/.cache/SpaceVim/undofile
  set backupdir=$HOME/.cache/SpaceVim/backup
  set directory=$HOME/.cache/SpaceVim/swap
  " }}}

  set nowritebackup
  set matchtime=0
  set ruler
  set showmatch
  set showmode
  "menuone: show the pupmenu when only one match
  " disable preview scratch window,
  set completeopt=menu,menuone,longest
  " h: 'complete'
  set complete=.,w,b,u,t
  " limit completion menu height
  set pumheight=15
  set scrolloff=1
  set sidescrolloff=5
  set display+=lastline
  set incsearch
  set hlsearch
  set wildignorecase
  set mouse=nv
  set hidden
  set ttimeout
  set ttimeoutlen=50
  if has('patch-7.4.314')
    " don't give ins-completion-menu messages.
    set shortmess+=c
  endif
  set shortmess+=s
  " Do not wrap lone lines
  set nowrap

  " yank and paste
  if has('unnamedplus')
    xnoremap <Leader>y "+y
    xnoremap <Leader>d "+d
    nnoremap <Leader>p "+p
    nnoremap <Leader>P "+P
    xnoremap <Leader>p "+p
    xnoremap <Leader>P "+P
  else
    xnoremap <Leader>y "*y
    xnoremap <Leader>d "*d
    nnoremap <Leader>p "*p
    nnoremap <Leader>P "*P
    xnoremap <Leader>p "*p
    xnoremap <Leader>P "*P
  endif
endfunction
