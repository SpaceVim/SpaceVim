""
" @section Introduction, intro
" @stylized Maktaba
" @library
" @order intro version dicts functions exceptions layers autocomplete colorscheme layer_lang_java layer_lang_php layer_lang_c faq
"   SpaceVim is a Modular configuration, a bundle of custom settings
" and plugins, for Vim. It got inspired by spacemacs.

""
" Version of SpaceVim , this value can not be changed.
scriptencoding utf-8
let g:spacevim_version = '0.1.0-dev'
lockvar g:spacevim_version
""
" Change the default indent of SpaceVim. default is 2.
" >
"   let g:spacevim_default_indent = 2
" <
let g:spacevim_default_indent          = 2
""
" Change the max column of SpaceVim, default is 120.
" >
"   let g:spacevim_max_column = 120
" <
let g:spacevim_max_column              = 120
""
" Enable true color support in terminal.
" >
"   let g:spacevim_enable_guicolors = 1
" <
let g:spacevim_enable_guicolors = 1
""
" Enable/Disable google suggestion for neocomplete. by default it is Disabled.
" you can enable it by:
" >
"   let g:spacevim_enable_googlesuggest = 1
" <
let g:spacevim_enable_googlesuggest    = 0
""
" Windows function leader of SpaceVim, default is `s`, set to empty to disable
" this feature, or you can set to other char.
" >
"   let g:spacevim_windows_leader = ''
" <
let g:spacevim_windows_leader          = 's'
""
" Unite work flow leader of SpaceVim, default is `f`, set to empty to disable
" this feature, or you can set to other char.
let g:spacevim_unite_leader            = 'f'
let g:spacevim_neobundle_installed     = 0
let g:spacevim_dein_installed          = 0
let g:spacevim_vim_plug_installed      = 0
""
" Set the cache dir of plugins, by default, it is `~/.cache/vimfiles`.
" you can set it by:
" >
"   let g:spacevim_plugin_bundle_dir = '~/.cache/vimplugs'
" <
let g:spacevim_plugin_bundle_dir       = $HOME. join(['', '.cache', 'vimfiles', ''], '/')
""
" Disable/Enable realtime leader guide, by default it is 0.
" to enable this feature:
" >
"   let g:spacevim_realtime_leader_guide = 1
" <
let g:spacevim_realtime_leader_guide   = 0
let g:spacevim_autocomplete_method     = ''
let g:spacevim_enable_cursorcolumn     = 0
let g:spacevim_enable_neomake          = 1
""
" set the guifont of Spacevim, default is empty.
" >
"   let g:spacevim_guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
" <
let g:spacevim_guifont                 = ''
""
" Disable/Enable YouCompleteMe, by default it is disabled. To enable it:
" >
"   let g:spacevim_enable_ycm = 1
" <
let g:spacevim_enable_ycm              = 0
let g:spacevim_enable_neocomplcache    = 0
""
" Enable cursorline
" >
"   let g:spacevim_enable_cursorline = 1
" <
let g:spacevim_enable_cursorline       = 0
""
" Set the error symbol of SpaceVim's syntax maker.
" example: >
"   let g:spacevim_error_symbol = '+'
" <
let g:spacevim_error_symbol            = '✖'
""
" Set the warning symbol of SpaceVim's syntax maker.
" example: >
"   let g:spacevim_warning_symbol = '!'
" <
let g:spacevim_warning_symbol          = '⚠'
let g:spacevim_use_colorscheme         = 1
""
" Set the help language of vim. By default it is `en`, you can change it to
" chinese.
" >
"   let g:spacevim_vim_help_language = 'chinese'
" <
let g:spacevim_vim_help_language       = 'en'
""
" The colorscheme of SpaceVim, if colorscheme groups are installed.
let g:spacevim_colorscheme             = 'gruvbox'
""
" The default colorscheme of SpaceVim. By default SpaceVim use desert, if
" colorscheme which name is the value of g:spacevim_colorscheme has not been
" installed.you can change it in custom config file.
" >
"   let g:spacevim_colorscheme_default = 'other_color'
" <
let g:spacevim_colorscheme_default     = 'desert'
""
" Disable/Enable simple mode of SpaceVim, in this mode, only few plugins will be
" installed.
" >
"   let g:spacevim_simple_mode = 1
" <
let g:spacevim_simple_mode             = 0
""
" The default file manager of SpaceVim.
let g:spacevim_filemanager             = 'vimfiler'
""
" The default plugin manager of SpaceVim, dein, neobundle or vim-plug. by
" default it is dein.
let g:spacevim_plugin_manager          = 'dein'  " neobundle or dein or vim-plug
""
" Enable/Disable checkinstall on SpaceVim startup. by default is 1.
"
" To disable it: >
"   let g:spacevim_checkinstall = 0
" <
let g:spacevim_checkinstall            = 1
""
" Enable/Disable debug mode for SpaceVim, by default it is disabled.
"
" to enable it: >
"   let g:spacevim_enable_debug = 1
" <
let g:spacevim_enable_debug            = 0
""
" Set the debug level of SpaceVim, by default it is 1.
let g:spacevim_debug_level             = 1
let g:spacevim_hiddenfileinfo          = 1
let g:spacevim_plugin_groups_exclude   = []


""
" groups of plugins should be loaded.
"
" example: >
"    let g:spacevim_plugin_groups = ['core', 'lang']
" <
" now Space Vim support these groups:
let g:spacevim_plugin_groups           = []
""
" Disable plugins by names.
" example: >
"   let g:spacevim_disabled_plugins = ['vim-foo', 'vim-bar']
" <
let g:spacevim_disabled_plugins        = []
""
" Add custom plugins
" >
"   let g:spacevim_custom_plugins = [
"               \ ['plasticboy/vim-markdown', 'on_ft' : 'markdown'],
"               \ ['wsdjeg/GitHub.vim'],
"               \ ]
" <
let g:spacevim_custom_plugins          = []
""
" SpaceVim will load global config after local config if set to 1. by default
" it is 0, if you has local config, the global config will not be loaded.
" >
"   let g:spacevim_force_global_config = 1
" <
let g:spacevim_force_global_config     = 0
""
" enable/disable SpaceVim with powerline symbols.
let g:spacevim_enable_powerline_fonts  = 1
""
" Enable/Disable lint on save feature of SpaceVim's maker.
"
" To disable lint on save:
" >
"   let g:spacevim_lint_on_save = 0
" <
let g:spacevim_lint_on_save            = 1
let g:spacevim_smartcloseignorewin     = ['__Tagbar__' , 'vimfiler:default']
let g:spacevim_smartcloseignoreft      = ['help']
let g:spacevim_altmoveignoreft         = ['Tagbar' , 'vimfiler']
let g:spacevim_enable_javacomplete2_py = 0
let g:spacevim_src_root                = 'E:\sources\'
""
" The host file url. this option is for chinese users who can not use
" google and twitter.
let g:spacevim_hosts_url               = 'https://raw.githubusercontent.com/racaljk/hosts/master/hosts'
let g:spacevim_wildignore              = '*/tmp/*,*.so,*.swp,*.zip,*.class,tags,*.jpg,
            \*.ttf,*.TTF,*.png,*/target/*,
            \.git,.svn,.hg,.DS_Store'

function! SpaceVim#loadCustomConfig() abort
    let custom_confs_old = SpaceVim#util#globpath(getcwd(), '.local.vim')
    let custom_confs = SpaceVim#util#globpath(getcwd(), '.SpaceVim.d/init.vim')
    let custom_glob_conf_old = expand('~/.local.vim')
    let custom_glob_conf = expand('~/.SpaceVim.d/init.vim')
    " the old value will be remove
    if filereadable(custom_glob_conf_old)
        exe 'source ' . custom_glob_conf_old
    endif
    if !empty(custom_confs_old)
        exe 'source ' . custom_confs_old[0]
    endif

    if !empty(custom_confs)
        if isdirectory('.SpaceVim.d')
            exe 'set rtp ^=' . expand('.SpaceVim.d')
        endif
        exe 'source ' . custom_confs[0]
        if filereadable(custom_glob_conf) && g:spacevim_force_global_config
            if isdirectory(expand('~/.SpaceVim.d/'))
                set runtimepath^=~/.SpaceVim.d
            endif
            exe 'source ' . custom_glob_conf
        endif
    elseif filereadable(custom_glob_conf)
        if isdirectory(expand('~/.SpaceVim.d/'))
            set runtimepath^=~/.SpaceVim.d
        endif
        exe 'source ' . custom_glob_conf
    endif
endfunction


function! SpaceVim#end() abort
    if !empty(g:spacevim_windows_leader)
        call SpaceVim#mapping#leader#defindWindowsLeader(g:spacevim_windows_leader)
    endif
    if !empty(g:spacevim_unite_leader)
        call SpaceVim#mapping#leader#defindUniteLeader(g:spacevim_unite_leader)
    endif
    if g:spacevim_simple_mode
        let g:spacevim_plugin_groups = ['core']
    else
        for s:group in g:spacevim_plugin_groups_exclude
            let s:i = index(g:spacevim_plugin_groups, s:group)
            if s:i != -1
                call remove(g:spacevim_plugin_groups, s:i)
            endif
        endfor
        if g:spacevim_vim_help_language ==# 'cn'
            call add(g:spacevim_plugin_groups, 'chinese')
        endif
        if g:spacevim_use_colorscheme==1
            call add(g:spacevim_plugin_groups, 'colorscheme')
        endif

        if has('nvim')
            let g:spacevim_autocomplete_method = 'deoplete'
        elseif has('lua')
            let g:spacevim_autocomplete_method = 'neocomplete'
        else
            let g:spacevim_autocomplete_method = 'neocomplcache'
        endif
        if g:spacevim_enable_ycm
            let g:spacevim_autocomplete_method = 'ycm'
        endif
        if g:spacevim_enable_neocomplcache
            let g:spacevim_autocomplete_method = 'neocomplcache'
        endif
    endif
    ""
    " generate tags for SpaceVim
    let help = fnamemodify(g:Config_Main_Home, ':p:h:h') . '/doc'
    exe 'helptags ' . help

    call SpaceVim#plugins#load()
endfunction


function! SpaceVim#default() abort
    call SpaceVim#default#SetOptions()
    call SpaceVim#default#SetPlugins()
    call SpaceVim#default#SetMappings()
endfunction

function! SpaceVim#defindFuncs() abort
endfunction


function! SpaceVim#welcome() abort
    VimFiler
    wincmd p
    Startify
endfunction

""
" @section FAQ, faq
" 1. How to enable YouCompleteMe?
