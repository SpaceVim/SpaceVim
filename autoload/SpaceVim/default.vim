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
        if !empty(g:spacevim_guifont)
            exe 'set guifont=' . g:spacevim_guifont
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
    call add(g:spacevim_plugin_groups, 'checkers')
    call add(g:spacevim_plugin_groups, 'chat')
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
