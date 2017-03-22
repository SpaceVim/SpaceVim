"=============================================================================
" SpaceVim.vim --- Initialization and core files for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

""
" @section Introduction, intro
" @stylized spacevim
" @library
" @order intro version dicts functions exceptions layers api faq
" SpaceVim is a bundle of custom settings and plugins with a modular
" configuration for Vim. It was inspired by Spacemacs.
"

""
" @section CONFIGURATION, config
" SpaceVim uses `~/.SpaceVim.d/init.vim` as its default global config file.
" You can set all the SpaceVim options and layers in it. `~/.SpaceVim.d/` will
" also be added to runtimepath, so you can write your own scripts in it.
" SpaceVim also supports local config for each project. Place local config 
" settings in `.SpaceVim.d/init.vim` in the root directory of your project.
" `.SpaceVim.d/` will also be added to runtimepath.

""
" Version of SpaceVim , this value can not be changed.
scriptencoding utf-8
let g:spacevim_version = '0.2.0-dev'
lockvar g:spacevim_version
""
" Change the default indentation of SpaceVim. Default is 2.
" >
"   let g:spacevim_default_indent = 2
" <
let g:spacevim_default_indent          = 2
""
" Change the max number of columns for SpaceVim. Default is 120.
" >
"   let g:spacevim_max_column = 120
" <
let g:spacevim_max_column              = 120
""
" Enable true color support in terminal. Default is 1.
" >
"   let g:spacevim_enable_guicolors = 1
" <
let g:spacevim_enable_guicolors = 1
""
" Enable/Disable Google suggestions for neocomplete. Default is 0.
" >
"   let g:spacevim_enable_googlesuggest = 1
" <
let g:spacevim_enable_googlesuggest    = 0
""
" Window functions leader for SpaceVim. Default is `s`. 
" Set to empty to disable this feature, or you can set to another char.
" >
"   let g:spacevim_windows_leader = ''
" <
let g:spacevim_windows_leader          = 's'
""
" Unite work flow leader of SpaceVim. Default is `f`.
" Set to empty to disable this feature, or you can set to another char.
let g:spacevim_unite_leader            = 'f'
""
" Denite work flow leader of SpaceVim. Default is `F`.
" Set to empty to disable this feature, or you can set to another char.
let g:spacevim_denite_leader            = 'F'
let g:spacevim_neobundle_installed     = 0
let g:spacevim_dein_installed          = 0
let g:spacevim_vim_plug_installed      = 0
""
" Set the cache directory of plugins. Default is `~/.cache/vimfiles`.
" >
"   let g:spacevim_plugin_bundle_dir = '~/.cache/vimplugs'
" <
let g:spacevim_plugin_bundle_dir
      \ = $HOME. join(['', '.cache', 'vimfiles', ''],
      \ SpaceVim#api#import('file').separator)
""
" Enable/Disable realtime leader guide. Default is 0.
" >
"   let g:spacevim_realtime_leader_guide = 1
" <
let g:spacevim_realtime_leader_guide   = 0
let g:spacevim_autocomplete_method     = ''
let g:spacevim_enable_cursorcolumn     = 0
""
" SpaceVim default checker is neomake. If you want to use syntastic, use:
" >
"   let g:spacevim_enable_neomake = 0
" <
let g:spacevim_enable_neomake          = 1
""
" Set the guifont of SpaceVim. Default is empty.
" >
"   let g:spacevim_guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
" <
let g:spacevim_guifont                 = ''
""
" Enable/Disable YouCompleteMe. Default is 0.
" >
"   let g:spacevim_enable_ycm = 1
" <
let g:spacevim_enable_ycm              = 0
""
" Set the width of the SpaceVim sidebar. Default is 30.
" This value will be used by tagbar and vimfiler.
let g:spacevim_sidebar_width           = 30
let g:spacevim_enable_neocomplcache    = 0
""
" Enable/Disable cursorline. Default is 0.
" >
"   let g:spacevim_enable_cursorline = 1
" <
let g:spacevim_enable_cursorline       = 0
""
" Set the error symbol for SpaceVim's syntax maker. Default is '✖'.
" >
"   let g:spacevim_error_symbol = '+'
" <
let g:spacevim_error_symbol            = '✖'
""
" Set the warning symbol for SpaceVim's syntax maker. Default is '⚠'.
" >
"   let g:spacevim_warning_symbol = '!'
" <
let g:spacevim_warning_symbol          = '⚠'
let g:spacevim_use_colorscheme         = 1
""
" Set the help language of vim. Default is 'en'. 
" You can change it to Chinese.
" >
"   let g:spacevim_vim_help_language = 'chinese'
" <
let g:spacevim_vim_help_language       = 'en'
""
" Set the message language of vim. Default is 'en_US.UTF-8'.
" >
"   let g:spacevim_language = 'en_CA.utf8'
" <
let g:spacevim_language                = ''
""
" The colorscheme of SpaceVim. Default is 'gruvbox'.
let g:spacevim_colorscheme             = 'gruvbox'
""
" The default colorscheme of SpaceVim. Default is 'desert'. 
" This colorscheme will be used if the colorscheme set by 
" `g:spacevim_colorscheme` is not installed.
" >
"   let g:spacevim_colorscheme_default = 'other_color'
" <
let g:spacevim_colorscheme_default     = 'desert'
""
" Enable/disable simple mode of SpaceVim. Default is 0.
" In this mode, only few plugins will be installed.
" >
"   let g:spacevim_simple_mode = 1
" <
let g:spacevim_simple_mode             = 0
""
" The default file manager of SpaceVim. Default is 'vimfiler'.
let g:spacevim_filemanager             = 'vimfiler'
""
" The default plugin manager of SpaceVim. Default is 'dein'.
" Options are dein, neobundle, or vim-plug.
let g:spacevim_plugin_manager          = 'dein'
""
" Enable/Disable checkinstall on SpaceVim startup. Default is 1.
" >
"   let g:spacevim_checkinstall = 0
" <
let g:spacevim_checkinstall            = 1
""
" Enable/Disable debug mode for SpaceVim. Default is 0.
" >
"   let g:spacevim_enable_debug = 1
" <
let g:spacevim_enable_debug            = 0
""
" Set the debug level of SpaceVim. Default is 1.
let g:spacevim_debug_level             = 1
let g:spacevim_hiddenfileinfo          = 1
let g:spacevim_plugin_groups_exclude   = []
""
" Set SpaceVim buffer index type, default is 0.
" >
"   " types:
"   " 0: 1 ➛ ➊ 
"   " 1: 1 ➛ ➀
"   " 2: 1 ➛ ⓵
"   " 3: 1 ➛ ¹
"   " 4: 1 ➛ 1
"   let g:spacevim_buffer_index_type = 1
" <
let g:spacevim_buffer_index_type = 0
""
" Enable/Disable tabline filetype icon. default is 0.
let g:spacevim_enable_tabline_filetype_icon = 0
""
" Enable/Disable os fileformat icon. default is 0.
let g:spacevim_enable_os_fileformat_icon = 0
""
" Plugin groups to be loaded.
" >
"    let g:spacevim_plugin_groups = ['core', 'lang']
" <
let g:spacevim_plugin_groups           = []
""
" Disable plugins by name.
" >
"   let g:spacevim_disabled_plugins = ['vim-foo', 'vim-bar']
" <
let g:spacevim_disabled_plugins        = []
""
" Add custom plugins.
" >
"   let g:spacevim_custom_plugins = [
"               \ ['plasticboy/vim-markdown', 'on_ft' : 'markdown'],
"               \ ['wsdjeg/GitHub.vim'],
"               \ ]
" <
let g:spacevim_custom_plugins          = []
""
" SpaceVim will load the global config after local config if set to 1. Default
" is 0. If you have a local config, the global config will not be loaded. 
" >
"   let g:spacevim_force_global_config = 1
" <
let g:spacevim_force_global_config     = 0
""
" Enable/Disable powerline symbols. Default is 1.
let g:spacevim_enable_powerline_fonts  = 1
""
" Enable/Disable lint on save feature of SpaceVim's maker. Default is 1.
" >
"   let g:spacevim_lint_on_save = 0
" <
let g:spacevim_lint_on_save            = 1
""
" Enable/Disable vimfiler in the welcome windows. Default is 1. 
" This will cause vim to start up slowly if there are too many files in the
" current directory. 
" >
"   let g:spacevim_enable_vimfiler_welcome = 0
" <
let g:spacevim_enable_vimfiler_welcome = 1
let g:spacevim_smartcloseignorewin     = ['__Tagbar__' , 'vimfiler:default']
let g:spacevim_smartcloseignoreft      = ['help']
let g:spacevim_altmoveignoreft         = ['Tagbar' , 'vimfiler']
let g:spacevim_enable_javacomplete2_py = 0
let g:spacevim_src_root                = 'E:\sources\'
""
" The host file url. This option is for Chinese users who can not use
" Google and Twitter.
let g:spacevim_hosts_url
      \ = 'https://raw.githubusercontent.com/racaljk/hosts/master/hosts'
let g:spacevim_wildignore
      \ = '*/tmp/*,*.so,*.swp,*.zip,*.class,tags,*.jpg,
      \*.ttf,*.TTF,*.png,*/target/*,
      \.git,.svn,.hg,.DS_Store,*.svg'
" privite options
let g:_spacevim_mappings = {}
" TODO merge leader guide

if !exists('g:leaderGuide_vertical')
  let g:leaderGuide_vertical = 0
endif

let g:spacevim_leader_guide_vertical = 0

if !exists('g:leaderGuide_sort_horizontal')
  let g:leaderGuide_sort_horizontal = 0
endif

let g:spacevim_leader_guide_sort_horizontal = 0

if !exists('g:leaderGuide_position')
  let g:leaderGuide_position = 'botright'
endif

let g:spacevim_leader_guide_position = 'botright'

if !exists('g:leaderGuide_run_map_on_popup')
  let g:leaderGuide_run_map_on_popup = 1
endif

let g:spacevim_leader_guide_run_map_on_popup = 1

if !exists("g:leaderGuide_hspace")
  let g:leaderGuide_hspace = 5
endif

let g:spacevim_leader_guide_hspace = 5

if !exists("g:leaderGuide_flatten")
  let g:leaderGuide_flatten = 1
endif

let g:spacevim_leader_guide_flatten = 1

if !exists("g:leaderGuide_default_group_name")
  let g:leaderGuide_default_group_name = ""
endif

let g:spacevim_leader_guide_default_group_name = ""

if !exists("g:leaderGuide_max_size")
  let g:leaderGuide_max_size = 0
endif

let g:spacevim_leader_guide_max_size = 0

if !exists("g:leaderGuide_submode_mappings")
  let g:leaderGuide_submode_mappings = {'<C-C>': "win_close"}
endif

let g:spacevim_leader_guide_submode_mappings = {'<C-C>': "win_close"}

if !SpaceVim#mapping#guide#has_configuration()
  let g:leaderGuide_map = {}
  call SpaceVim#mapping#guide#register_prefix_descriptions('', 'g:leaderGuide_map')
endif


command -nargs=1 LeaderGuide call SpaceVim#mapping#guide#start_by_prefix('0', <args>)
"====

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
  if !empty(g:spacevim_denite_leader)
    call SpaceVim#mapping#leader#defindDeniteLeader(g:spacevim_denite_leader)
  endif
  call SpaceVim#mapping#leader#defindglobalMappings()
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

  ""
  " set language
  if !empty(g:spacevim_language)
    silent exec 'lan ' . g:spacevim_language
  endif

  if g:spacevim_realtime_leader_guide
    nnoremap <silent><nowait> <leader> :<c-u>LeaderGuide get(g:, 'mapleader', '\')<CR>
    vnoremap <silent> <leader> :<c-u>LeaderGuideVisual get(g:, 'mapleader', '\')<CR>
  endif
  let g:leaderGuide_max_size = 15
  let g:leaderGuide_submode_mappings = 
        \ { '<C-C>': 'win_close', '<PageDown>': 'page_down', '<PageUp>': 'page_up'}
  call SpaceVim#plugins#load()
endfunction


function! SpaceVim#default() abort
  call SpaceVim#default#SetOptions()
  call SpaceVim#default#SetPlugins()
  call SpaceVim#default#SetMappings()
  call SpaceVim#commands#load()
endfunction

function! SpaceVim#defindFuncs() abort
endfunction


function! SpaceVim#welcome() abort
  if exists(':Startify') == 2
    Startify
  endif
  if g:spacevim_enable_vimfiler_welcome
    if exists(':VimFiler') == 2 
      VimFiler
      wincmd p
    elseif exists(':NERDTreeToggle') == 2
      NERDTreeToggle
      wincmd p
    endif
  endif
endfunction

""
" @section FAQ, faq
"1. How do I enable YouCompleteMe? 
" >
"   I do not recommend using YouCompleteMe.
"   It is too big as a vim plugin. Also, I do not like using submodules in a vim
"   plugin. It is hard to manage with a plugin manager.
"
"   Step 1: Add `let g:spacevim_enable_ycm = 1` to custom_config. By default
"   it should be `~/.SpaceVim/init.vim`.
"
"   Step 2: Get into the directory of YouCompleteMe's author. By default it
"   should be `~/.cache/vimfiles/repos/github.com/Valloric/`. If you find the
"   directory `YouCompleteMe` in it, go into it. Otherwise clone
"   YouCompleteMe repo by
"   `git clone https://github.com/Valloric/YouCompleteMe.git`. After cloning,
"   get into it and run `git submodule update --init --recursive`.
"
"   Step 3: Compile YouCompleteMe with the features you want. If you just want
"   C family support, run `./install.py --clang-completer`.
" <
"
" 2. How to add custom snippet?
" >
"   SpaceVim uses neosnippet as the default snippet engine. If you want to add
"   a snippet for a vim filetype, open a vim file and run `:NeoSnippetEdit`
"   command. A buffer will be opened and you can add your custom snippet. 
"   By default this buffer will be save in `~/.SpaceVim/snippets`. 
"   If you want to use another directory:
"
"   let g:neosnippet#snippets_directory = '~/path/to/snip_dir'
"   
"   For more info about how to write snippet, please 
"   read |neosnippet-snippet-syntax|.
" <
"
" 3. Where is `<c-f>` in cmdline-mode?
" >
"   `<c-f>` is the default value of |cedit| option, but in SpaceVim we use that
"   binding as `<Right>`, so maybe you can change the `cedit` option or use
"   `<leader>+<c-f>`.
" <
"
" 4. How to use `<space>` as `<leader>`?
" >
"   Add `let mapleader = "\<space>"` to `~/.SpaceVim.d/init.vim`
" <



" vim:set et sw=2 cc=80:
