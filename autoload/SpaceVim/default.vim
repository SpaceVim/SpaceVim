scriptencoding utf-8
function! SpaceVim#default#SetOptions() abort
  " basic vim settiing
  if has('gui_running')
    set guioptions-=m " Hide menu bar.
    set guioptions-=T " Hide toolbar
    set guioptions-=L " Hide left-hand scrollbar
    set guioptions-=r " Hide right-hand scrollbar
    set guioptions-=b " Hide bottom scrollbar
    set showtabline=0 " Hide tabline
    set guioptions-=e " Hide tab
    if WINDOWS()
      " please install the font in 'Dotfiles\font'
      set guifont=DejaVu_Sans_Mono_for_Powerline:h11:cANSI:qDRAFT
    elseif OSX()
      set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11
    else
      set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 11
    endif
  endif

  " indent use backspace delete indent, eol use backspace delete line at
  " begining start delete the char you just typed in if you do not use set
  " nocompatible ,you need this
  set backspace=indent,eol,start

  " Shou number and relativenumber
  set relativenumber
  set number

  " set fillchar
  hi VertSplit ctermbg=NONE guibg=NONE
  set fillchars+=vert:│

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

  " tab options:
  set tabstop=4
  set expandtab
  set softtabstop=4
  set shiftwidth=4

  " autoread
  set autoread

  " backup
  set backup
  set undofile
  set undolevels=1000
  let g:data_dir = $HOME . '/.data/'
  let g:backup_dir = g:data_dir . 'backup'
  let g:swap_dir = g:data_dir . 'swap'
  let g:undo_dir = g:data_dir . 'undofile'
  if finddir(g:data_dir) ==# ''
    silent call mkdir(g:data_dir)
  endif
  if finddir(g:backup_dir) ==# ''
    silent call mkdir(g:backup_dir)
  endif
  if finddir(g:swap_dir) ==# ''
    silent call mkdir(g:swap_dir)
  endif
  if finddir(g:undo_dir) ==# ''
    silent call mkdir(g:undo_dir)
  endif
  unlet g:backup_dir
  unlet g:swap_dir
  unlet g:data_dir
  unlet g:undo_dir
  set undodir=$HOME/.data/undofile
  set backupdir=$HOME/.data/backup
  set directory=$HOME/.data/swap

  " no fold enable
  set nofoldenable
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
  set scrolloff=3
  set incsearch
  set hlsearch
  set laststatus=2
  set wildignorecase
  set mouse=nv
  set hidden
  set ttimeout
  set ttimeoutlen=50
  set lazyredraw
  if has('patch-7.4.314')
    " don't give ins-completion-menu messages.
    set shortmess+=c
  endif
endfunction

function! SpaceVim#default#SetPlugins() abort

  call add(g:spacevim_plugin_groups, 'web')
  call add(g:spacevim_plugin_groups, 'lang')
  call add(g:spacevim_plugin_groups, 'edit')
  call add(g:spacevim_plugin_groups, 'ui')
  call add(g:spacevim_plugin_groups, 'tools')
  call add(g:spacevim_plugin_groups, 'checkers')
  call add(g:spacevim_plugin_groups, 'format')
  call add(g:spacevim_plugin_groups, 'chat')
  call add(g:spacevim_plugin_groups, 'git')
  call add(g:spacevim_plugin_groups, 'javascript')
  call add(g:spacevim_plugin_groups, 'ruby')
  call add(g:spacevim_plugin_groups, 'python')
  call add(g:spacevim_plugin_groups, 'scala')
  call add(g:spacevim_plugin_groups, 'lang#go')
  call add(g:spacevim_plugin_groups, 'lang#markdown')
  call add(g:spacevim_plugin_groups, 'scm')
  call add(g:spacevim_plugin_groups, 'editing')
  call add(g:spacevim_plugin_groups, 'indents')
  call add(g:spacevim_plugin_groups, 'navigation')
  call add(g:spacevim_plugin_groups, 'misc')

  call add(g:spacevim_plugin_groups, 'core')
  call SpaceVim#layers#load('core#statusline')
  call SpaceVim#layers#load('core#tabline')
  call add(g:spacevim_plugin_groups, 'default')
  call add(g:spacevim_plugin_groups, 'unite')
  call add(g:spacevim_plugin_groups, 'github')
  if has('python3')
    call add(g:spacevim_plugin_groups, 'denite')
  endif
  call add(g:spacevim_plugin_groups, 'ctrlp')
  call add(g:spacevim_plugin_groups, 'autocomplete')
  if ! has('nvim')
    call add(g:spacevim_plugin_groups, 'vim')
  else
    call add(g:spacevim_plugin_groups, 'nvim')
  endif
  if OSX()
    call add(g:spacevim_plugin_groups, 'osx')
  endif
  if WINDOWS()
    call add(g:spacevim_plugin_groups, 'windows')
  endif
  if LINUX()
    call add(g:spacevim_plugin_groups, 'linux')
  endif
endfunction

function! SpaceVim#default#SetMappings() abort

  "mapping
  imap <silent><expr><TAB> SpaceVim#mapping#tab#i_tab()
  imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
  imap <silent><expr><S-TAB> SpaceVim#mapping#shift_tab()
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  imap <silent><expr><CR> SpaceVim#mapping#enter#i_enter()
  inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
  inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
  inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
  inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
  smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
  " Save a file with sudo
  " http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN
  cnoremap w!! %!sudo tee > /dev/null %


  " Use Ctrl+* to jump between windows
  nnoremap <silent><C-Right> :<C-u>wincmd l<CR>
  nnoremap <silent><C-Left>  :<C-u>wincmd h<CR>
  nnoremap <silent><C-Up>    :<C-u>wincmd k<CR>
  nnoremap <silent><C-Down>  :<C-u>wincmd j<CR>
  if has('nvim')
    exe 'tnoremap <silent><C-Right> <C-\><C-n>:<C-u>wincmd l<CR>'
    exe 'tnoremap <silent><C-Left>  <C-\><C-n>:<C-u>wincmd h<CR>'
    exe 'tnoremap <silent><C-Up>    <C-\><C-n>:<C-u>wincmd k<CR>'
    exe 'tnoremap <silent><C-Down>  <C-\><C-n>:<C-u>wincmd j<CR>'
    exe 'tnoremap <silent><M-Left>  <C-\><C-n>:<C-u>bprev<CR>'
    exe 'tnoremap <silent><M-Right>  <C-\><C-n>:<C-u>bnext<CR>'
    exe 'tnoremap <silent><esc>     <C-\><C-n>'
  endif


  "Use jk switch to normal mode
  inoremap jk <esc>

  "]<End> or ]<Home> move current line to the end or the begin of current buffer
  nnoremap <silent>]<End> ddGp``
  nnoremap <silent>]<Home> ddggP``
  vnoremap <silent>]<End> dGp``
  vnoremap <silent>]<Home> dggP``


  "Ctrl+Shift+Up/Down to move up and down
  nnoremap <silent><C-S-Down> :m .+1<CR>==
  nnoremap <silent><C-S-Up> :m .-2<CR>==
  inoremap <silent><C-S-Down> <Esc>:m .+1<CR>==gi
  inoremap <silent><C-S-Up> <Esc>:m .-2<CR>==gi
  vnoremap <silent><C-S-Down> :m '>+1<CR>gv=gv
  vnoremap <silent><C-S-Up> :m '<-2<CR>gv=gv
  " download gvimfullscreen.dll from github, copy gvimfullscreen.dll to
  " the directory that has gvim.exe
  nnoremap <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<cr>

  " Start new line
  inoremap <S-Return> <C-o>o

  " Improve scroll, credits: https://github.com/Shougo
  nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
        \ 'zt' : (winline() == 1) ? 'zb' : 'zz'
  noremap <expr> <C-f> max([winheight(0) - 2, 1])
        \ ."\<C-d>".(line('w$') >= line('$') ? "L" : "H")
  noremap <expr> <C-b> max([winheight(0) - 2, 1])
        \ ."\<C-u>".(line('w0') <= 1 ? "H" : "L")
  noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
  noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")

  " Select blocks after indenting
  xnoremap < <gv
  xnoremap > >gv|

  " Use tab for indenting in visual mode
  xnoremap <Tab> >gv|
  xnoremap <S-Tab> <gv
  nnoremap > >>_
  nnoremap < <<_

  " smart up and down
  nnoremap <silent><Down> gj
  nnoremap <silent><Up> gk


  " Use Q format lines
  map Q gq

  " Navigate window
  nnoremap <silent><C-q> <C-w>
  nnoremap <silent><C-x> <C-w>x

  " Navigation in command line
  cnoremap <C-a> <Home>
  cnoremap <C-b> <Left>
  cnoremap <C-f> <Right>


  " Fast saving
  nnoremap <C-s> :<C-u>w<CR>
  vnoremap <C-s> :<C-u>w<CR>
  cnoremap <C-s> <C-u>w<CR>

  " Tabs
  nnoremap <silent>g0 :<C-u>tabfirst<CR>
  nnoremap <silent>g$ :<C-u>tablast<CR>
  nnoremap <silent>gr :<C-u>tabprevious<CR>

  " Remove spaces at the end of lines
  nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

  " C-r: Easier search and replace
  xnoremap <C-r> :<C-u>call <SID>VSetSearch()<CR>:,$s/<C-R>=@/<CR>//gc<left><left><left>
  function! s:VSetSearch() abort
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  "irssi like hot key
  nnoremap <silent><M-1> :<C-u>call <SID>tobur(1)<CR>
  nnoremap <silent><M-2> :<C-u>call <SID>tobur(2)<CR>
  nnoremap <silent><M-3> :<C-u>call <SID>tobur(3)<CR>
  nnoremap <silent><M-4> :<C-u>call <SID>tobur(4)<CR>
  nnoremap <silent><M-5> :<C-u>call <SID>tobur(5)<CR>
  nnoremap <silent><M-Right> :<C-U>call <SID>tobur("bnext")<CR>
  nnoremap <silent><M-Left> :<C-U>call <SID>tobur("bprev")<CR>

  call SpaceVim#mapping#def('nnoremap <silent>','<M-x>',':call chat#qq#OpenMsgWin()<cr>',
        \ 'Open qq chatting room','call chat#chatting#OpenMsgWin()')
  call SpaceVim#mapping#def('nnoremap <silent>','<M-w>',':call chat#weixin#OpenMsgWin()<cr>',
        \ 'Open weixin chatting room','call chat#chatting#OpenMsgWin()')
  call SpaceVim#mapping#def('nnoremap <silent>','<M-c>',':call chat#chatting#OpenMsgWin()<cr>',
        \ 'Open chatting room','call chat#chatting#OpenMsgWin()')

  call SpaceVim#mapping#def('nnoremap <silent>','g=',':call zvim#format()<cr>','format current buffer','call zvim#format')

  call SpaceVim#mapping#def('nnoremap <silent>', '<C-c>', ':<c-u>call zvim#util#CopyToClipboard()<cr>',
        \ 'Copy buffer absolute path to X11 clipboard','call zvim#util#CopyToClipboard()')
  call SpaceVim#mapping#def('nnoremap <silent>', '<Tab>', ':wincmd w<CR>', 'Switch to next window or tab','wincmd w')
  call SpaceVim#mapping#def('nnoremap <silent>', '<S-Tab>', ':wincmd p<CR>', 'Switch to previous window or tab','wincmd p')
  call SpaceVim#mapping#def('nnoremap <silent>', 'q', ':<C-u>call zvim#util#SmartClose()<cr>',
        \ 'Smart close windows',
        \ 'call zvim#util#SmartClose()')
endfunction

fu! s:tobur(num) abort
  if index(get(g:,'spacevim_altmoveignoreft',[]), &filetype) == -1
    if a:num ==# 'bnext'
      bnext
    elseif a:num ==# 'bprev'
      bprev
    else
      let ls = split(execute(':ls'), "\n")
      let buffers = []
      for b in ls
        let nr = matchstr(b, '\d\+')
        call add(buffers, nr)
      endfor
      if len(buffers) >= a:num
        exec 'buffer ' . buffers[a:num - 1]
      endif
    endif
  endif
endf

function! SpaceVim#default#UseSimpleMode() abort

endfunction

" vim:set et sw=2:
