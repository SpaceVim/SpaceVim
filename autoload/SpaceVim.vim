scriptencoding utf-8
""
" @section Introduction, intro
" SpaceVim is a modular configuration for vim/neovim plugins.

""
" @section Configuration, config
" @plugin(name) is configured by these options.

""
" Version of SpaceVim , this value can not be changed.
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
let g:spacevim_auto_download_neobundle = 0
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
let g:spacevim_autocomplete_method     = ''
let g:spacevim_enable_cursorcolumn     = 0
let g:spacevim_enable_neomake          = 1
""
" set the guifont of Spacevim, default is empty.
let g:spacevim_guifont                 = ''
""
" Enable ycm or not, but default it is 0.
let g:spacevim_enable_ycm              = 0
let g:spacevim_enable_neocomplcache    = 0
let g:spacevim_enable_cursorline       = 0
""
" The error symbol used by maker.
let g:spacevim_error_symbol            = '✖'
let g:spacevim_warning_symbol          = '⚠'
let g:spacevim_use_colorscheme         = 1
let g:spacevim_vim_help_language       = 'en'
""
" The colorscheme of SpaceVim, if colorscheme groups are installed.
let g:spacevim_colorscheme             = 'gruvbox'
""
" The default colorscheme of SpaceVim.
let g:spacevim_colorscheme_default     = 'desert'
""
" The default file manager of SpaceVim.
let g:spacevim_filemanager             = 'vimfiler'
""
" The default plugin manager of SpaceVim, dein, neobundle or vim-plug. by
" default it is dein.
let g:spacevim_plugin_manager          = 'dein'  " neobundle or dein or vim-plug
""
" Enable/Disable checkinstall on SpaceVim startup. by default is 0.
"
" To enable it: >
"   let g:spacevim_checkinstall = 1
" <
let g:spacevim_checkinstall            = 0
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
" enable/disable SpaceVim with powerline symbols.
let g:spacevim_enable_powerline_fonts  = 1
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
    let custom_confs = SpaceVim#util#globpath(getcwd(), '.local.vim')
    let custom_glob_conf = expand('~/.local.vim')
    if filereadable(custom_glob_conf)
        exe 'source ' . custom_glob_conf
    endif
    if !empty(custom_confs)
        exe 'source ' . custom_confs[0]
    endif
endfunction

""
" @public
" Load the {layer} you want :
" autocompletion : Make SpaceVim support autocompletion.
" unite : Unite centric work-flow
function! SpaceVim#Layer(layer) abort
    if index(g:spacevim_plugin_groups, a:layer) == -1
        call add(g:spacevim_plugin_groups, a:layer)
    endif
endfunction

function! SpaceVim#end() abort
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
    ""
    " generate tags for SpaceVim
    let help = fnamemodify(g:Config_Main_Home, ':p:h:h') . '/doc'
    exe 'helptags ' . help
endfunction


function! SpaceVim#default() abort
    call SpaceVim#default#SetOptions()
    call SpaceVim#default#SetPlugins()
endfunction

function! SpaceVim#defindFuncs() abort
endfunction

function! SpaceVim#loadPlugins() abort

endfunction
