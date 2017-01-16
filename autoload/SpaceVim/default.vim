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
    set nofoldenable                " no fold enable
    set nowritebackup
    set matchtime=0
    set ruler
    set showcmd
    set showmatch
    set showmode
    "menuone: show the pupmenu when only one match
    set completeopt=menu,menuone,longest " disable preview scratch window,
    set complete=.,w,b,u,t " h: 'complete'
    set pumheight=15 " limit completion menu height
    set scrolloff=7
    set incsearch
    set autowrite
    set hlsearch
    set laststatus=2
    set completeopt=longest,menu
    set wildignorecase
    let g:markdown_fenced_languages = ['vim', 'java', 'bash=sh', 'sh', 'html', 'python']
    set mouse=
    set hidden
    set ttimeout
    set ttimeoutlen=50
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
    call add(g:spacevim_plugin_groups, 'go')
    call add(g:spacevim_plugin_groups, 'scm')
    call add(g:spacevim_plugin_groups, 'editing')
    call add(g:spacevim_plugin_groups, 'indents')
    call add(g:spacevim_plugin_groups, 'navigation')
    call add(g:spacevim_plugin_groups, 'misc')

    call add(g:spacevim_plugin_groups, 'core')
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
    "全局映射
    "也可以通过'za'打开或者关闭折叠
    imap <silent><expr><TAB> SpaceVim#mapping#tab()
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    inoremap <silent><expr><CR> SpaceVim#mapping#enter()
    inoremap <silent> <Leader><Tab> <C-r>=MyLeaderTabfunc()<CR>
    inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
    inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
    imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
    smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
    nnoremap <silent><leader><space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
    "Super paste it does not work
    "ino <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>
    "对于没有权限的文件使用 :w!!来保存
    cnoremap w!! %!sudo tee > /dev/null %
    " cmap W!! w !sudo tee % >/dev/null   " I can not understand
    " Save a file with sudo
    " http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN


    " 映射Ctrl+上下左右来切换窗口
    nnoremap <silent><C-Right> :<C-u>wincmd l<CR>
    nnoremap <silent><C-Left>  :<C-u>wincmd h<CR>
    nnoremap <silent><C-Up>    :<C-u>wincmd k<CR>
    nnoremap <silent><C-Down>  :<C-u>wincmd j<CR>
    if has('nvim')
        exe 'tnoremap <silent><C-Right> <C-\><C-n>:<C-u>wincmd l<CR>'
        exe 'tnoremap <silent><C-Left>  <C-\><C-n>:<C-u>wincmd h<CR>'
        exe 'tnoremap <silent><C-Up>    <C-\><C-n>:<C-u>wincmd k<CR>'
        exe 'tnoremap <silent><C-Down>  <C-\><C-n>:<C-u>wincmd j<CR>'
        exe 'tnoremap <silent><esc>     <C-\><C-n>'
    endif

    "for buftabs
    noremap <silent><Leader>bp :bprev<CR>
    noremap <silent><Leader>bn :bnext<CR>

    "Quickly add empty lines
    nnoremap <silent>[<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>
    nnoremap <silent>]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>

    "Use jk switch to normal model
    inoremap jk <esc>

    "]e or [e move current line ,count can be useed
    nnoremap <silent>[e  :<c-u>execute 'move -1-'. v:count1<cr>
    nnoremap <silent>]e  :<c-u>execute 'move +'. v:count1<cr>

    "]<End> or ]<Home> move current line to the end or the begin of current buffer
    nnoremap <silent>]<End> ddGp``
    nnoremap <silent>]<Home> ddggP``
    vnoremap <silent>]<End> dGp``
    vnoremap <silent>]<Home> dggP``


    "Ctrl+Shift+上下移动当前行
    nnoremap <silent><C-S-Down> :m .+1<CR>==
    nnoremap <silent><C-S-Up> :m .-2<CR>==
    inoremap <silent><C-S-Down> <Esc>:m .+1<CR>==gi
    inoremap <silent><C-S-Up> <Esc>:m .-2<CR>==gi
    "上下移动选中的行
    vnoremap <silent><C-S-Down> :m '>+1<CR>gv=gv
    vnoremap <silent><C-S-Up> :m '<-2<CR>gv=gv
    "background
    noremap <silent><leader>bg :call ToggleBG()<CR>
    "numbers
    noremap <silent><leader>nu :call ToggleNumber()<CR>
    " download gvimfullscreen.dll from github, copy gvimfullscreen.dll to
    " the directory that has gvim.exe
    nnoremap <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<cr>
    " yark and paste
    vmap <Leader>y "+y
    vmap <Leader>d "+d
    nmap <Leader>p "+p
    nmap <Leader>P "+P
    vmap <Leader>p "+p
    vmap <Leader>P "+P

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

    " Select last paste
    nnoremap <silent><expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

    " Disable Q and gQ
    nnoremap Q <Nop>
    nnoremap gQ <Nop>

    " Navigate window
    nnoremap <silent><C-q> <C-w>
    nnoremap <silent><C-x> <C-w>x

    " Navigation in command line
    cnoremap <C-a> <Home>
    cnoremap <C-b> <Left>
    cnoremap <C-f> <Right>

    " When pressing <leader>cd switch to the directory of the open buffer
    " map <Leader>cd :cd %:p:h<CR>:pwd<CR>       "I use <Plug>RooterChangeToRootDirectory

    " Fast saving
    nnoremap <Leader>w :w<CR>
    vnoremap <Leader>w <Esc>:w<CR>
    nnoremap <C-s> :<C-u>w<CR>
    vnoremap <C-s> :<C-u>w<CR>
    cnoremap <C-s> <C-u>w<CR>

    " Toggle editor visuals
    nmap <Leader>ts :setlocal spell!<cr>
    nmap <Leader>tn :setlocal nonumber! norelativenumber!<CR>
    nmap <Leader>tl :setlocal nolist!<CR>
    nmap <Leader>th :nohlsearch<CR>
    nmap <Leader>tw :setlocal wrap! breakindent!<CR>

    " Tabs
    nnoremap <silent>g0 :<C-u>tabfirst<CR>
    nnoremap <silent>g$ :<C-u>tablast<CR>
    nnoremap <silent>gr :<C-u>tabprevious<CR>

    " Remove spaces at the end of lines
    nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

    " C-r: Easier search and replace
    xnoremap <C-r> :<C-u>call VSetSearch('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>

    " Location list movement
    nmap <silent><Leader>lj :lnext<CR>
    nmap <silent><Leader>lk :lprev<CR>
    nmap <silent><Leader>lq :lclose<CR>

    " quickfix list movement
    nmap <silent><Leader>qj :cnext<CR>
    nmap <silent><Leader>qk :cprev<CR>
    nmap <silent><Leader>qq :cclose<CR>

    " Duplicate lines
    nnoremap <Leader>d m`YP``
    vnoremap <Leader>d YPgv

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

    call SpaceVim#mapping#def('vnoremap', '<Leader>S', "y:execute @@<CR>:echo 'Sourced selection.'<CR>",
                \ 'Sourced selection.',
                \ "echo 'Use <leader>S to sourced selection.'")
    call SpaceVim#mapping#def('nnoremap','<Leader>S',"^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>",'Source line',
                \ "echo 'Use <leader>S to sourced line.'")

    call SpaceVim#mapping#def('nnoremap <silent>', '<C-c>', ':<c-u>call zvim#util#CopyToClipboard()<cr>',
                \ 'Copy buffer absolute path to X11 clipboard','call zvim#util#CopyToClipboard()')
    call SpaceVim#mapping#def('nnoremap <silent>', '<Leader><C-c>',
                \ ':<c-u>call zvim#util#CopyToClipboard(1)<cr>',
                \ 'Yank the github link of current file to X11 clipboard',
                \ 'call zvim#util#CopyToClipboard(1)')
    call SpaceVim#mapping#def('nnoremap <silent>', '<Leader><C-l>',
                \ ':<c-u>call zvim#util#CopyToClipboard(2)<cr>',
                \ 'Yank the github link of current line to X11 clipboard',
                \ 'call zvim#util#CopyToClipboard(2)')
    call SpaceVim#mapping#def('vnoremap <silent>', '<Leader><C-l>',
                \ ':<c-u>call zvim#util#CopyToClipboard(3)<cr>',
                \ 'Yank the github link of current selection to X11 clipboard',
                \ 'call zvim#util#CopyToClipboard(3)')
    call SpaceVim#mapping#def('nnoremap <silent>', '<Tab>', ':wincmd w<CR>', 'Switch to next window or tab','wincmd w')
    call SpaceVim#mapping#def('nnoremap <silent>', '<S-Tab>', ':wincmd p<CR>', 'Switch to previous window or tab','wincmd p')
    call SpaceVim#mapping#def('nnoremap <silent>', 'q', ':<C-u>call zvim#util#SmartClose()<cr>',
                \ 'Smart close windows',
                \ 'call zvim#util#SmartClose()')
    call SpaceVim#mapping#def('nnoremap <silent>', '<Leader>qr', 'q', 'Toggle recording','')
    call SpaceVim#mapping#def('nnoremap <silent>', '<Leader>sv', ':split<CR>:wincmd p<CR>:e#<CR>',
                \'Open previous buffer in split window' , 'split|wincmd p|e#')
    call SpaceVim#mapping#def('nnoremap <silent>', '<Leader>sg', ':vsplit<CR>:wincmd p<CR>:e#<CR>',
                \'Open previous buffer in vsplit window' , 'vsplit|wincmd p|e#')
    call SpaceVim#mapping#def('nnoremap <silent>', 'gf', ':call zvim#gf()<CR>', 'Jump to a file under cursor', '')
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
