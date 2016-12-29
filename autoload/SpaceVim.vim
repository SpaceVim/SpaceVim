scriptencoding utf-8
function! SpaceVim#init() abort
    "Vim settings
    let g:settings                         = get(g:, 'settings', {})
    let g:settings.default_indent          = 2
    let g:settings.max_column              = 120
    let g:settings.enable_googlesuggest    = 0
    let g:settings.auto_download_neobundle = 0
    let g:settings.neobundle_installed     = 0
    let g:settings.dein_installed          = 0
    let g:settings.vim_plug_installed      = 0
    let g:settings.plugin_bundle_dir       = $HOME. join(['', '.cache', 'vimfiles', ''], '/')
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
    let g:settings.plugin_groups = []
    let g:settings.smartcloseignorewin     = ['__Tagbar__' , 'vimfiler:default']
    let g:settings.smartcloseignoreft      = ['help']
    let g:settings.altmoveignoreft         = ['Tagbar' , 'vimfiler']
    let g:settings.enable_javacomplete2_py = 0
    let g:settings.src_root                = 'E:\sources\'
    let g:settings.hosts_url               = 'https://raw.githubusercontent.com/racaljk/hosts/master/hosts'
    let g:settings.wildignore              = '*/tmp/*,*.so,*.swp,*.zip,*.class,tags,*.jpg,
                \*.ttf,*.TTF,*.png,*/target/*,
                \.git,.svn,.hg,.DS_Store'

endfunction

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

function! SpaceVim#Layer(layer, opt) abort

endfunction

function! SpaceVim#end() abort
    for s:group in g:settings.plugin_groups_exclude
        let s:i = index(g:settings.plugin_groups, s:group)
        if s:i != -1
            call remove(g:settings.plugin_groups, s:i)
        endif
    endfor
    if g:settings.vim_help_language ==# 'cn'
        call add(g:settings.plugin_groups, 'chinese')
    endif
    if g:settings.use_colorscheme==1
        call add(g:settings.plugin_groups, 'colorscheme')
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
endfunction


function! SpaceVim#default() abort
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
    if OSX()
        call add(g:settings.plugin_groups, 'osx')
    endif
    if WINDOWS()
        call add(g:settings.plugin_groups, 'windows')
    endif
    if LINUX()
        call add(g:settings.plugin_groups, 'linux')
    endif
endfunction

function! SpaceVim#defindFuncs() abort
endfunction
