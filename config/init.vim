scriptencoding utf-8
" Enable nocompatible
if has('vim_starting')
    if &compatible
        set nocompatible
    endif
endif

" Fsep && Psep
if has('win16') || has('win32') || has('win64')
    let s:Psep = ';'
    let s:Fsep = '\'
else
    let s:Psep = ':'
    let s:Fsep = '/'
endif
"Use English for anything in vim
if WINDOWS()
    silent exec 'lan mes en_US.UTF-8'
elseif OSX()
    silent exec 'language en_US'
else
    let s:uname = system('uname -s')
    if s:uname ==# "Darwin\n"
        " in mac-terminal
        silent exec 'language en_US'
    else
        " in linux-terminal
        silent exec 'language en_US.utf8'
    endif
endif

" try to set encoding to utf-8
if WINDOWS()
    " Be nice and check for multi_byte even if the config requires
    " multi_byte support most of the time
    if has('multi_byte')
        " Windows cmd.exe still uses cp850. If Windows ever moved to
        " Powershell as the primary terminal, this would be utf-8
        set termencoding=cp850
        " Let Vim use utf-8 internally, because many scripts require this
        set encoding=utf-8
        setglobal fileencoding=utf-8
        " Windows has traditionally used cp1252, so it's probably wise to
        " fallback into cp1252 instead of eg. iso-8859-15.
        " Newer Windows files might contain utf-8 or utf-16 LE so we might
        " want to try them first.
        set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
    endif

else
    " set default encoding to utf-8
    set encoding=utf-8
    set termencoding=utf-8
endif

" Enable 256 colors
if $COLORTERM ==# 'gnome-terminal'
    set t_Co=256
endif

"Vim settings
let g:settings                         = get(g:, 'settings', {})
let g:settings.default_indent          = 2
let g:settings.max_column              = 120
let g:settings.enable_googlesuggest    = 0
let g:settings.auto_download_neobundle = 0
let g:settings.neobundle_installed     = 0
let g:settings.dein_installed          = 0
let g:settings.vim_plug_installed      = 0
let g:settings.plugin_bundle_dir       = $HOME. join(['', '.cache', 'vimfiles', ''],s:Fsep)
let g:settings.autocomplete_method     = ''
let g:settings.enable_cursorcolumn     = 0
let g:settings.enable_neomake          = 1
let g:settings.enable_ycm              = 0
let g:settings.enable_neocomplcache    = 0
let g:settings.enable_cursorline       = 0
let g:settings.error_symbol            = '✖'
let g:settings.warning_symbol          = '⚠'
let g:settings.use_colorscheme         = 1
let g:settings.vim_help_language       = 'en'
let g:settings.colorscheme             = 'gruvbox'
let g:settings.colorscheme_default     = 'desert'
let g:settings.filemanager             = 'vimfiler'
let g:settings.plugin_manager          = 'dein'  " neobundle or dein or vim-plug
let g:settings.checkinstall            = 0
let g:settings.hiddenfileinfo          = 1
let g:settings.plugin_groups_exclude   = []
let g:settings.smartcloseignorewin     = ['__Tagbar__' , 'vimfiler:default']
let g:settings.smartcloseignoreft      = ['help']
let g:settings.altmoveignoreft         = ['Tagbar' , 'vimfiler']
let g:settings.enable_javacomplete2_py = 0
let g:settings.src_root                = 'E:\sources\'
let g:settings.hosts_url               = 'https://raw.githubusercontent.com/racaljk/hosts/master/hosts'
let g:settings.wildignore              = '*/tmp/*,*.so,*.swp,*.zip,*.class,tags,*.jpg,
            \*.ttf,*.TTF,*.png,*/target/*,
            \.git,.svn,.hg,.DS_Store'

"core vimrc
let g:settings.plugin_groups = []
call add(g:settings.plugin_groups, 'web')
call add(g:settings.plugin_groups, 'javascript')
call add(g:settings.plugin_groups, 'ruby')
call add(g:settings.plugin_groups, 'python')
call add(g:settings.plugin_groups, 'scala')
call add(g:settings.plugin_groups, 'go')
call add(g:settings.plugin_groups, 'scm')
call add(g:settings.plugin_groups, 'editing')
call add(g:settings.plugin_groups, 'indents')
call add(g:settings.plugin_groups, 'navigation')
call add(g:settings.plugin_groups, 'misc')

call add(g:settings.plugin_groups, 'core')
call add(g:settings.plugin_groups, 'unite')
if has('python3')
    call add(g:settings.plugin_groups, 'denite')
endif
call add(g:settings.plugin_groups, 'ctrlp')
call add(g:settings.plugin_groups, 'autocomplete')
if ! has('nvim')
    call add(g:settings.plugin_groups, 'vim')
else
    call add(g:settings.plugin_groups, 'nvim')
endif


if g:settings.vim_help_language ==# 'cn'
    call add(g:settings.plugin_groups, 'chinese')
endif
if g:settings.use_colorscheme==1
    call add(g:settings.plugin_groups, 'colorscheme')
endif
if OSX()
    call add(g:settings.plugin_groups, 'osx')
endif
if WINDOWS()
    call add(g:settings.plugin_groups, 'windows')
endif
if LINUX()
    call add(g:settings.plugin_groups, 'linux')
endif

if has('nvim')
    let g:settings.autocomplete_method = 'deoplete'
elseif has('lua')
    let g:settings.autocomplete_method = 'neocomplete'
else
    let g:settings.autocomplete_method = 'neocomplcache'
endif
if g:settings.enable_ycm
    let g:settings.autocomplete_method = 'ycm'
endif
if g:settings.enable_neocomplcache
    let g:settings.autocomplete_method = 'neocomplcache'
endif

for s:group in g:settings.plugin_groups_exclude
    let s:i = index(g:settings.plugin_groups, s:group)
    if s:i != -1
        call remove(g:settings.plugin_groups, s:i)
    endif
endfor

" python host for neovim
let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
if WINDOWS()
    let g:python_host_prog = 'D:\Python27\python.exe'
    let g:python3_host_prog = 'C:\Users\wsdjeg\AppData\Local\Programs\Python\Python35-32\python.exe'
endif
