scriptencoding utf-8
""
" @section Introduction, intro
" SpaceVim is a modular configuration for vim/neovim plugins.

""
" @section Configuration, config
" @plugin(name) is configured by these options.

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

function! SpaceVim#defindFuncs() abort
endfunction

function! SpaceVim#loadPlugins() abort

endfunction
