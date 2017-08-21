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
let g:spacevim_version = '0.5.0-dev'
lockvar g:spacevim_version
""
" Change the default indentation of SpaceVim. Default is 2.
" >
"   let g:spacevim_default_indent = 2
" <
let g:spacevim_default_indent          = 2
""
" Enable/Disable relativenumber, by default it is enabled.
let g:spacevim_relativenumber          = 1
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
""
" Enable/Disable spacevim's insert mode leader, default is enable
let g:spacevim_enable_insert_leader    = 1
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
" Enable/Disable realtime leader guide. Default is 1. to disable it:
" >
"   let g:spacevim_realtime_leader_guide = 0
" <
let g:spacevim_realtime_leader_guide   = 1
""
" Enable/Disable key frequency catching of SpaceVim. default value is 0. to
" enable it:
" >
"   let g:spacevim_enable_key_frequency = 1
" <
let g:spacevim_enable_key_frequency = 0
let g:spacevim_autocomplete_method     = ''
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
""
" Set the snippet engine of SpaceVim, default is neosnippet. to enable
" ultisnips:
" >
"   let g:spacevim_snippet_engine = 'ultisnips'
" <
let g:spacevim_snippet_engine = 'neosnippet'
let g:spacevim_enable_neocomplcache    = 0
""
" Enable/Disable cursorline. Default is 1, cursorline will be
" highlighted in normal mode.To disable this feature:
" >
"   let g:spacevim_enable_cursorline = 0
" <
let g:spacevim_enable_cursorline       = 1
""
" Set the statusline separators of statusline, default is 'arrow'
" >
"   Separatos options:
"     1. arrow
"     2. curve
"     3. slant
"     4. nil
"     5. fire
" <
"
" See more details in: http://spacevim.org/documentation/#statusline
"
let g:spacevim_statusline_separator = 'arrow'
let g:spacevim_statusline_inactive_separator = 'arrow'
""
" Enable/Disable cursorcolumn. Default is 0, cursorcolumn will be
" highlighted in normal mode. To enable this feature:
" >
"   let g:spacevim_enable_cursorcolumn = 1
" <
let g:spacevim_enable_cursorcolumn     = 0
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
""
" Set the SpaceVim cursor shape in the terminal. Set to 0 to prevent Nvim from
" changing the cursor shape.  Set to 1 to enable non-blinking mode-sensitive
" cursor (this is the default).  Set to 2 to enable blinking mode-sensitive
" cursor. Host terminal must support the DECSCUSR CSI escape sequence.
"
" Depending on the terminal emulator, using this option with nvim under
" tmux might require adding the following to ~/.tmux.conf:
" >
"   set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
" <
let g:spacevim_terminal_cursor_shape = 2
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
" The background of colorscheme. Default is 'dark'.
let g:spacevim_colorscheme_bg             = 'dark'
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
" Set the max process of SpaceVim plugin manager
let g:spacevim_plugin_manager_max_processes = 8
""
" Enable/Disable checkinstall on SpaceVim startup. Default is 1.
" >
"   let g:spacevim_checkinstall = 1
" <
let g:spacevim_checkinstall            = 1
""
" Enable/Disable debug mode for SpaceVim. Default is 0.
" >
"   let g:spacevim_enable_debug = 1
" <
let g:spacevim_enable_debug            = 0
""
" Auto disable touchpad when switch to insert mode or focuslost in neovim.
let g:spacevim_auto_disable_touchpad   = 1
""
" Set the debug level of SpaceVim. Default is 1. see
" |SpaceVim#logger#setLevel()|
let g:spacevim_debug_level             = 1
let g:spacevim_hiddenfileinfo          = 1
let g:spacevim_plugin_groups_exclude   = []
let g:spacevim_gitcommit_pr_icon       = 'p'
let g:spacevim_gitcommit_issue_icon    = 'i'
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
" Set SpaceVim windows index type, default is 0.
" >
"   " types:
"   " 0: 1 ➛ ➊ 
"   " 1: 1 ➛ ➀
"   " 2: 1 ➛ ⓵
"   let g:spacevim_windows_index_type = 1
" <
let g:spacevim_windows_index_type = 0
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
" Set the github username, It will be used for getting your starred repos, and
" fuzzy find the repo you want.
let g:spacevim_github_username         = ''
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
let g:spacevim_search_tools            = ['rg', 'ag', 'pt', 'ack', 'grep']
""
" Enable/Disable lint on the fly feature of SpaceVim's maker. Default is 0.
" >
"   let g:spacevim_lint_on_the_fly = 0
" <
let g:spacevim_lint_on_the_fly         = 0
""
" Enable/Disable vimfiler in the welcome windows. Default is 1. 
" This will cause vim to start up slowly if there are too many files in the
" current directory. 
" >
"   let g:spacevim_enable_vimfiler_welcome = 0
" <
let g:spacevim_enable_vimfiler_welcome = 1
""
" Enable/Disable gitstatus colum in vimfiler buffer, default is 0.
let g:spacevim_enable_vimfiler_gitstatus = 0
""
" Enable/Disable filetypeicon colum in vimfiler buffer, default is 0.
let g:spacevim_enable_vimfiler_filetypeicon = 0
let g:spacevim_smartcloseignorewin     = ['__Tagbar__' , 'vimfiler:default']
let g:spacevim_smartcloseignoreft      = ['help', 'tagbar', 'vimfiler']
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
let g:_spacevim_mappings_space_custom = []

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
  let g:leaderGuide_submode_mappings = 
        \ { '<C-C>': 'win_close', 'n': 'page_down', 'p': 'page_up', 'u' : 'undo'}
endif

let g:spacevim_leader_guide_submode_mappings = {'<C-C>': "win_close"}



command -nargs=1 LeaderGuide call SpaceVim#mapping#guide#start_by_prefix('0', <args>)
command -range -nargs=1 LeaderGuideVisual call SpaceVim#mapping#guide#start_by_prefix('1', <args>)

function! SpaceVim#loadCustomConfig() abort
  let custom_confs_old = SpaceVim#util#globpath(getcwd(), '.local.vim')
  let custom_confs = SpaceVim#util#globpath(getcwd(), '.SpaceVim.d/init.vim')
  let custom_glob_conf_old = expand('~/.local.vim')
  let custom_glob_conf = expand('~/.SpaceVim.d/init.vim')

  if has('timers')
    if !filereadable(custom_glob_conf_old) && !filereadable(custom_glob_conf)
      " if there is no custom config auto generate it.
      augroup SpaceVimBootstrap
        au!
        au VimEnter * call timer_start(10, function('SpaceVim#custom#autoconfig'))
      augroup END
    endif
  endif
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
  call SpaceVim#mapping#leader#defindKEYs()
  call SpaceVim#mapping#space#init()
  call SpaceVim#mapping#g#init()
  call SpaceVim#mapping#z#init()
  if !SpaceVim#mapping#guide#has_configuration()
    let g:leaderGuide_map = {}
    call SpaceVim#mapping#guide#register_prefix_descriptions('', 'g:leaderGuide_map')
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

  ""
  " set language
  if !empty(g:spacevim_language)
    silent exec 'lan ' . g:spacevim_language
  endif

  if index(g:spacevim_plugin_groups, 'core#statusline') != -1
    call SpaceVim#layers#core#statusline#init()
  endif

  if !g:spacevim_relativenumber
    set norelativenumber
  endif

  if g:spacevim_realtime_leader_guide
    nnoremap <silent><nowait> <leader> :<c-u>LeaderGuide get(g:, 'mapleader', '\')<CR>
    vnoremap <silent> <leader> :<c-u>LeaderGuideVisual get(g:, 'mapleader', '\')<CR>
  endif
  let g:leaderGuide_max_size = 15
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
  exe 'cd' fnameescape(g:_spacevim_enter_dir)
  if exists('g:_spacevim_checking_flag') && g:_spacevim_checking_flag
    return
  endif
  if exists(':Startify') == 2
    Startify
    if isdirectory(bufname(1))
      bwipeout! 1
    endif
    if exists(':IndentLinesDisable')
      IndentLinesDisable
    endif
  endif
  if g:spacevim_enable_vimfiler_welcome
        \ && get(g:, '_spacevim_checking_flag', 0) == 0
    if exists(':VimFiler') == 2 
      VimFiler
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
"   it should be `~/.SpaceVim.d/init.vim`.
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
