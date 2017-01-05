function! SpaceVim#default#SetOptions() abort
    " basic vim settiing
    if has("gui_running")
        set guioptions-=m " 隐藏菜单栏
        set guioptions-=T " 隐藏工具栏
        set guioptions-=L " 隐藏左侧滚动条
        set guioptions-=r " 隐藏右侧滚动条
        set guioptions-=b " 隐藏底部滚动条
        set showtabline=0 " 隐藏Tab栏
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

    "显示相对行号
    set relativenumber

    " 显示行号
    set number

    " 自动缩进,自动智能对齐
    set autoindent
    set smartindent
    set cindent

    " 状态栏预览命令
    set wildmenu

    "整词换行
    set linebreak

    "Tab键的宽度
    set tabstop=4
    "用空格来执行tab
    set expandtab
    " 统一缩进为4
    set softtabstop=4
    set shiftwidth=4
    "set nobackup
    set backup
    set undofile
    set undolevels=1000
    let g:data_dir = $HOME . '/.data/'
    let g:backup_dir = g:data_dir . 'backup'
    let g:swap_dir = g:data_dir . 'swap'
    let g:undo_dir = g:data_dir . 'undofile'
    if finddir(g:data_dir) == ''
        silent call mkdir(g:data_dir)
    endif
    if finddir(g:backup_dir) == ''
        silent call mkdir(g:backup_dir)
    endif
    if finddir(g:swap_dir) == ''
        silent call mkdir(g:swap_dir)
    endif
    if finddir(g:undo_dir) == ''
        silent call mkdir(g:undo_dir)
    endif
    unlet g:backup_dir
    unlet g:swap_dir
    unlet g:data_dir
    unlet g:undo_dir
    set undodir=$HOME/.data/undofile
    set backupdir=$HOME/.data/backup
    set directory=$HOME/.data/swap
    set nofoldenable                "关闭自动折叠 折叠按键 'za'
    set nowritebackup
    set matchtime=0
    set ruler
    set showcmd						"命令行显示输入的命令
    set showmatch					"设置匹配模式,显示匹配的括号
    set showmode					"命令行显示当前vim的模式
    "menuone: show the pupmenu when only one match
    set completeopt=menu,menuone,longest " disable preview scratch window,
    set complete=.,w,b,u,t " h: 'complete'
    set pumheight=15 " limit completion menu height
    set scrolloff=7               "最低显示行数
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
