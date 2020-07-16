"=============================================================================
" SpaceVim.vim --- Initialization and core files for SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section Introduction, intro
" @stylized spacevim
" @library
" @order intro options config layers usage api faq changelog
" SpaceVim is a bundle of custom settings and plugins with a modular
" configuration for Vim. It was inspired by Spacemacs.
"

""
" @section Options, options
" SpaceVim uses `~/.SpaceVim.d/init.toml` as its default global config file.
" You can set all the SpaceVim options and layers in it. `~/.SpaceVim.d/` will
" also be added to runtimepath, so you can write your own scripts in it.
" SpaceVim also supports local config for each project. Place local config
" settings in `.SpaceVim.d/init.toml` in the root directory of your project.
" `.SpaceVim.d/` will also be added to runtimepath.
"
" here is an example setting SpaceVim options:
" >
"   [options]
"     enable-guicolors = true
"     max-column = 120
" <


""
" @section Configuration, config
" If you still want to use `~/.SpaceVim.d/init.vim` as configuration file,
" please take a look at the following options.
"

" Public SpaceVim Options {{{
scriptencoding utf-8

""
" Version of SpaceVim , this value can not be changed.
let g:spacevim_version = '1.5.0-dev'
lockvar g:spacevim_version

""
" @section default_indent, options-default_indent
" @parentsection options
" Change the default indentation of SpaceVim. Default is 2.
" >
"   default_indent = 2
" <

""
" Change the default indentation of SpaceVim. Default is 2.
" >
"   let g:spacevim_default_indent = 2
" <
let g:spacevim_default_indent          = 2
""
" In Insert mode: Use the appropriate number of spaces to insert a <Tab>
let g:spacevim_expand_tab              = 1

""
" @section relativenumber, options-relativenumber
" @parentsection options
" Enable/Disable relativenumber, by default it is enabled.
" >
"   relativenumber = true
" <

""
" Enable/Disable relativenumber in current windows, by default it is enabled.
let g:spacevim_relativenumber          = 1


""
" @section enable_bepo_layout, options-enable_bepo_layout
" @parentsection options
" Enable/Disable bepo layout, by default it is disabled.
" >
"   enable_bepo_layout = true
" <

""
" Enable/Disable bepo layout, by default it is disabled.
let g:spacevim_enable_bepo_layout  = 0


""
" @section max_column, options-max_column
" @parentsection options
" Change the max number of columns for SpaceVim. Default is 120.
" >
"   max_column = 120
" <

""
" Change the max number of columns for SpaceVim. Default is 120.
" >
"   let g:spacevim_max_column = 120
" <
let g:spacevim_max_column              = 120

""
" @section home_files_number, options-home_files_number
" @parentsection options
" Change the list number of files for SpaceVim home. Default is 6.
" >
"   home_files_number = 6
" <

""
" Change the list number of files for SpaceVim home. Default is 6.
" >
"   let g:spacevim_home_files_number = 6
" <
let g:spacevim_home_files_number        = 6


""
" @section enable_guicolors, options-enable_guicolors
" @parentsection options
" Enable true color support in terminal. Default is false.
" >
"   enable_guicolors = true
" <

""
" Enable true color support in terminal. Default is 0.
" >
"   let g:spacevim_enable_guicolors = 1
" <
let g:spacevim_enable_guicolors = 0

""
" @section escape_key_binding, options-escape_key_binding
" @parentsection options
" Set the key binding for switch to normal mode in insert mode.
" Default is `jk`, to disable this key binding, set this option to empty
" string.
" >
"   escape_key_binding = 'jk'
" <

""
" Set the key binding for switch to normal mode in insert mode.
" Default is `jk`, to disable this key binding, set this option to empty
" string.
" >
"   let g:spacevim_escape_key_binding = 'jk'
" <
let g:spacevim_escape_key_binding = 'jk'

""
" @section enable_googlesuggest, options-enable_googlesuggest
" @parentsection options
" Enable/Disable Google suggestions for neocomplete. Default is false.
" >
"   enable_googlesuggest = false
" <

""
" Enable/Disable Google suggestions for neocomplete. Default is 0.
" >
"   let g:spacevim_enable_googlesuggest = 1
" <
let g:spacevim_enable_googlesuggest    = 0

""
" @section windows_leader, options-windows_leader
" @parentsection options
" Window functions leader for SpaceVim. Default is `s`.
" Set to empty to disable this feature, or you can set to another char.
" >
"   windows_leader = ""
" <


""
" Window functions leader for SpaceVim. Default is `s`.
" Set to empty to disable this feature, or you can set to another char.
" >
"   let g:spacevim_windows_leader = ''
" <
let g:spacevim_windows_leader          = 's'

""
" @section enable_insert_leader, options-enable_insert_leader
" @parentsection options
" Enable/Disable spacevim's insert mode leader, default is enable

""
" Enable/Disable spacevim's insert mode leader, default is enable
let g:spacevim_enable_insert_leader    = 1

""
" @section data_dir, options-data_dir
" @parentsection options
" Set the cache directory of SpaceVim. Default is `$XDG_CACHE_HOME` 
" or if not set `~/.cache¸.
" >
"   data_dir = "~/.cache"
" <

""
" Set the cache directory of SpaceVim. Default is `$XDG_CACHE_HOME` 
" or if not set `~/.cache¸.
" >
"   let g:spacevim_data_dir = '~/.cache'
" <
let g:spacevim_data_dir
      \ = $XDG_CACHE_HOME != ''
      \   ? $XDG_CACHE_HOME . SpaceVim#api#import('file').separator
      \   : expand($HOME. join(['', '.cache', ''],
      \     SpaceVim#api#import('file').separator))

""
" @section plugin_bundle_dir, options-plugin_bundle_dir
" @parentsection options
" Set the cache directory of plugins. Default is `$data_dir/vimfiles`.
" >
"   plugin_bundle_dir = "~/.cache/vimplugs"
" <

""
" Set the cache directory of plugins. Default is `$data_dir/vimfiles`.
" >
"   let g:spacevim_plugin_bundle_dir = g:spacevim_data_dir.'/vimplugs'
" <
let g:spacevim_plugin_bundle_dir
      \ = g:spacevim_data_dir . join(['vimfiles', ''],
      \ SpaceVim#api#import('file').separator)

""
" @section realtime_leader_guide, options-realtime_leader_guide
" @parentsection options
" Enable/Disable realtime leader guide. Default is true. to disable it:
" >
"   realtime_leader_guide = false
" <

""
" Enable/Disable realtime leader guide. Default is 1. to disable it:
" >
"   let g:spacevim_realtime_leader_guide = 0
" <
let g:spacevim_realtime_leader_guide   = 1

""
" @section enable_key_frequency, options-enable_key_frequency
" @parentsection options
" Enable/Disable key frequency catching of SpaceVim. default value is 0. to
" enable it:
" >
"   enable_key_frequency = true
" <

""
" Enable/Disable key frequency catching of SpaceVim. default value is 0. to
" enable it:
" >
"   let g:spacevim_enable_key_frequency = 1
" <
let g:spacevim_enable_key_frequency = 0
if (has('python3') && SpaceVim#util#haspy3lib('neovim')) &&
      \ (has('nvim') || (has('patch-8.0.0027')))

  ""
  " @section autocomplete_method, options-autocomplete_method
  " @parentsection options
  " Set the autocomplete engine of spacevim, the default logic is:
  " >
  "   if has('python3')
  "     let g:spacevim_autocomplete_method = 'deoplete'
  "   elseif has('lua')
  "     let g:spacevim_autocomplete_method = 'neocomplete'
  "   elseif has('python')
  "     let g:spacevim_autocomplete_method = 'completor'
  "   elseif has('timers')
  "     let g:spacevim_autocomplete_method = 'asyncomplete'
  "   else
  "     let g:spacevim_autocomplete_method = 'neocomplcache'
  "   endif
  " <
  "
  " and you can alse set this option to coc, then coc.nvim will be used.

  ""
  " Set the autocomplete engine of spacevim, the default logic is:
  " >
  "   if has('python3')
  "     let g:spacevim_autocomplete_method = 'deoplete'
  "   elseif has('lua')
  "     let g:spacevim_autocomplete_method = 'neocomplete'
  "   elseif has('python')
  "     let g:spacevim_autocomplete_method = 'completor'
  "   elseif has('timers')
  "     let g:spacevim_autocomplete_method = 'asyncomplete'
  "   else
  "     let g:spacevim_autocomplete_method = 'neocomplcache'
  "   endif
  " <
  "
  " and you can alse set this option to coc, then coc.nvim will be used.
  let g:spacevim_autocomplete_method = 'deoplete'
elseif has('lua')
  let g:spacevim_autocomplete_method = 'neocomplete'
elseif has('python') && ((has('job') && has('timers') && has('lambda')) || has('nvim'))
  let g:spacevim_autocomplete_method = 'completor'
elseif has('timers')
  let g:spacevim_autocomplete_method = 'asyncomplete'
else
  let g:spacevim_autocomplete_method = 'neocomplcache'
endif

""
" @section enable_neomake, options-enable_neomake
" @parentsection options
" SpaceVim default checker is neomake. If you want to use syntastic, use:
" >
"   enable_neomake = false
" <

""
" SpaceVim default checker is neomake. If you want to use syntastic, use:
" >
"   let g:spacevim_enable_neomake = 0
" <
let g:spacevim_enable_neomake          = 1

""
" @section enable_ale, options-enable_ale
" @parentsection options
" Use ale for syntax checking, disabled by default.
" >
"   enable_ale = true
" <

""
" Use ale for syntax checking, disabled by default.
" >
"   let g:spacevim_enable_ale = 1
" <
let g:spacevim_enable_ale          = 0

""
" @section guifont, options-guifont
" @parentsection options
" Set the guifont of SpaceVim. Default is empty.
" >
"   guifont = "SauceCodePro Nerd Font Mono:h11"
" <

""
" Set the guifont of SpaceVim. Default is empty.
" >
"   let g:spacevim_guifont = "SauceCodePro Nerd Font Mono:h11"
" <
let g:spacevim_guifont                 = ''

""
" @section enable_ycm, options-enable_ycm
" @parentsection options
" Enable/Disable YouCompleteMe. Default is false.
" >
"   enable_ycm = true
" <

""
" Enable/Disable YouCompleteMe. Default is 0.
" >
"   let g:spacevim_enable_ycm = 1
" <
let g:spacevim_enable_ycm              = 0

""
" @section sidebar_width, options-sidebar_width
" @parentsection options
" Set the width of the SpaceVim sidebar. Default is 30.
" This value will be used by tagbar and vimfiler.

""
" Set the width of the SpaceVim sidebar. Default is 30.
" This value will be used by tagbar and vimfiler.
let g:spacevim_sidebar_width           = 30

""
" @section snippet_engine, options-snippet_engine
" @parentsection options
" Set the snippet engine of SpaceVim, default is neosnippet. to enable
" ultisnips:
" >
"   snippet_engine = "ultisnips"
" <

""
" Set the snippet engine of SpaceVim, default is neosnippet. to enable
" ultisnips:
" >
"   let g:spacevim_snippet_engine = "ultisnips"
" <
let g:spacevim_snippet_engine = 'neosnippet'
let g:spacevim_enable_neocomplcache    = 0

""
" @section enable_cursorline, options-enable_cursorline
" @parentsection options
" Enable/Disable cursorline. Default is true, cursorline will be
" highlighted in normal mode.To disable this feature:
" >
"   enable_cursorline = false
" <

""
" Enable/Disable cursorline. Default is 1, cursorline will be
" highlighted in normal mode.To disable this feature:
" >
"   let g:spacevim_enable_cursorline = 0
" <
let g:spacevim_enable_cursorline       = 1
""
" @section statusline_separator, options-statusline_separator
" @parentsection options
" Set the statusline separators of statusline, default is 'nil'
" >
"   Separators options:
"     1. arrow
"     2. curve
"     3. slant
"     4. nil
"     5. fire
" <
"
" See more details in: http://spacevim.org/documentation/#statusline
"

""
" Set the statusline separators of statusline, default is 'nil'
" >
"   Separators options:
"     1. arrow
"     2. curve
"     3. slant
"     4. nil
"     5. fire
" <
"
" See more details in: http://spacevim.org/documentation/#statusline
"
let g:spacevim_statusline_separator = 'nil'
""
" @section statusline_iseparator, options-statusline_iseparator
" @parentsection options
" Set the statusline separators of statusline in inactive windows, default is
" 'nil'
" >
"   Separators options:
"     1. arrow
"     2. curve
"     3. slant
"     4. nil
"     5. fire
" <
"
" See more details in: http://spacevim.org/documentation/#statusline
"

""
" Set the statusline separators of statusline in inactive windows, default is
" 'nil'
" >
"   Separators options:
"     1. arrow
"     2. curve
"     3. slant
"     4. nil
"     5. fire
" <
"
" See more details in: http://spacevim.org/documentation/#statusline
"
let g:spacevim_statusline_iseparator = 'nil'

""
" @section enable_statusline_bfpath, options-enable_statusline_bfpath
" @parentsection options
" Enable/Disable showing full path of current buffer on statusline, disabled
" by default, to enable this feature:
" >
"   enable_statusline_bfpath = true
" <

""
" Enable/Disable showing full path of current buffer on statusline, disabled
" by default, to enable this feature:
" >
"   enable_statusline_bfpath = true
" <
let g:spacevim_enable_statusline_bfpath = 0

""
" @section enable_statusline_tag, options-enable_statusline_tag
" @parentsection options
" Enable/Disable showing current tag on statusline
" >
"   enable_statusline_tag = false
" <

""
" Enable/Disable showing current tag on statusline
let g:spacevim_enable_statusline_tag = 1
""
" @section statusline_left_sections, options-statusline_left_sections
" @parentsection options
" Define the left section of statusline in active windows. By default:
" >
"   statusline_left_sections = [
"     'winnr',
"     'filename',
"     'major mode',
"     'minor mode lighters',
"     'version control info'
"     ]
" <

""
" Define the left section of statusline in active windows. By default:
" >
"   let g:spacevim_statusline_left_sections =
"     \ [
"     \ 'winnr',
"     \ 'filename',
"     \ 'major mode',
"     \ 'minor mode lighters',
"     \ 'version control info'
"     \ ]
" <
let g:spacevim_statusline_left_sections = ['winnr', 'filename', 'major mode',
      \ 'search count',
      \ 'syntax checking', 'minor mode lighters',
      \ ]
""
" Define the right section of statusline in active windows. By default:
" >
"   g:spacevim_statusline_right_sections =
"     \ [
"     \ 'fileformat',
"     \ 'cursorpos',
"     \ 'percentage'
"     \ ]
" <
let g:spacevim_statusline_right_sections = ['fileformat', 'cursorpos', 'percentage']

""
" Enable/Disable unicode symbols in statusline
let g:spacevim_statusline_unicode_symbols = 1
""
" Enable/Disable language specific leader, by default you can use `,` ket
" instead of `SPC` `l`.
let g:spacevim_enable_language_specific_leader = 1

""
" @section enable_statusline_mode, options-enable_statusline_mode
" @parentsection options
" Enable/Disable display mode. Default is 0, mode will be
" displayed in statusline. To enable this feature:
" >
"   enable_statusline_mode = true
" <

""
" Enable/Disable display mode. Default is 0, mode will be
" displayed in statusline. To enable this feature:
" >
"   let g:spacevim_enable_statusline_mode = 1
" <
let g:spacevim_enable_statusline_mode     = 0
""
" Set the statusline/tabline palette of color, default values depends on the theme
" >
"   let g:spacevim_custom_color_palette = [
"     \ ['#282828', '#b8bb26', 246, 235],
"     \ ['#a89984', '#504945', 239, 246],
"     \ ['#a89984', '#3c3836', 237, 246],
"     \ ['#665c54', 241],
"     \ ['#282828', '#83a598', 235, 109],
"     \ ['#282828', '#fe8019', 235, 208],
"     \ ['#282828', '#8ec07c', 235, 108],
"     \ ['#282828', '#689d6a', 235, 72],
"     \ ['#282828', '#8f3f71', 235, 132],
"     \ ]
" <
"
let g:spacevim_custom_color_palette = []

""
" @section enable_cursorcolumn, options-enable_cursorcolumn
" @parentsection options
" Enable/Disable cursorcolumn. Default is 0, cursorcolumn will be
" highlighted in normal mode. To enable this feature:
" >
"   enable_cursorcolumn = true
" <

""
" Enable/Disable cursorcolumn. Default is 0, cursorcolumn will be
" highlighted in normal mode. To enable this feature:
" >
"   let g:spacevim_enable_cursorcolumn = 1
" <
let g:spacevim_enable_cursorcolumn     = 0

""
" @section error_symbol, options-error_symbol
" @parentsection options
" Set the error symbol for SpaceVim's syntax maker. Default is '✖'.
" >
"   error_symbol = "+"
" <

""
" Set the error symbol for SpaceVim's syntax maker. Default is '✖'.
" >
"   let g:spacevim_error_symbol = '+'
" <
let g:spacevim_error_symbol            = '✖'

""
" @section warning_symbol, options-warning_symbol
" @parentsection options
" Set the warning symbol for SpaceVim's syntax maker. Default is '⚠'.
" >
"   warning_symbol = '!'
" <

""
" Set the warning symbol for SpaceVim's syntax maker. Default is '⚠'.
" >
"   let g:spacevim_warning_symbol = '!'
" <
let g:spacevim_warning_symbol          = '⚠'

""
" @section info_symbol, options-info_symbol
" @parentsection options
" Set the information symbol for SpaceVim's syntax maker. Default is '🛈'.
" >
"   info_symbol = 'i'
" <

""
" Set the information symbol for SpaceVim's syntax maker. Default is '🛈'.
" >
"   let g:spacevim_info_symbol = 'i'
" <
let g:spacevim_info_symbol             = SpaceVim#api#import('messletters').circled_letter('i')

""
" @section terminal_cursor_shape, options-terminal_cursor_shape
" @parentsection options
" Set the SpaceVim cursor shape in the terminal.
" >
"   0 : to prevent Nvim from changing the cursor shape.
"   1 : to enable non-blinking mode-sensitive cursor.
"   2 : to enable blinking mode-sensitive cursor (default).
" >
" Host terminal must support the DECSCUSR CSI escape sequence.
" Depending on the terminal emulator, using this option with nvim under
" tmux might require adding the following to ~/.tmux.conf:
" >
"   set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
" <

""
" Set the SpaceVim cursor shape in the terminal.
" >
"   0 : to prevent Nvim from changing the cursor shape.
"   1 : to enable non-blinking mode-sensitive cursor.
"   2 : to enable blinking mode-sensitive cursor (default).
" >
" Host terminal must support the DECSCUSR CSI escape sequence.
" Depending on the terminal emulator, using this option with nvim under
" tmux might require adding the following to ~/.tmux.conf:
" >
"   set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
" <
let g:spacevim_terminal_cursor_shape = 2
""
" @section vim_help_language, options-vim_help_language
" @parentsection options
" Set the help language of vim. Default is 'en'.
" You can change it to Chinese.
" >
"   vim_help_language = "cn"
" <

""
" Set the help language of vim. Default is 'en'.
" You can change it to Chinese.
" >
"   let g:spacevim_vim_help_language = 'cn'
" <
let g:spacevim_vim_help_language       = 'en'
""
" @section language, options-language
" @parentsection options
" Set the message language of vim. Default is 'en_US.UTF-8'.
" >
"   language = 'en_CA.utf8'
" <

""
" Set the message language of vim. Default is 'en_US.UTF-8'.
" >
"   let g:spacevim_language = 'en_CA.utf8'
" <
let g:spacevim_language                = ''
""
" @section keep_server_alive, options-keep_server_alive
" @parentsection options
" Option for keep the spacevim server ailive

""
" Option for keep the spacevim server ailive
let g:spacevim_keep_server_alive = 1
""
" @section colorscheme, options-colorscheme
" @parentsection options
" The colorscheme of SpaceVim. Default is 'gruvbox'.

""
" The colorscheme of SpaceVim. Default is 'gruvbox'.
let g:spacevim_colorscheme             = 'gruvbox'
""
" @section colorscheme_bg, options-colorscheme_bg
" @parentsection options
" The background of colorscheme. Default is 'dark'.

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
" @section filemanager, options-filemanager
" @parentsection options
" The default file manager of SpaceVim. Default is 'vimfiler'.
" you can also use nerdtree or defx

""
" The default file manager of SpaceVim. Default is 'vimfiler'.
" you can also use nerdtree or defx
let g:spacevim_filemanager             = 'vimfiler'
""
" @section filetree_direction, options-filetree_direction
" @parentsection options
" Config the direction of file tree. Default is 'right'. you can also set to
" 'left'. 
"
" NOTE: if it is 'left', the tagbar will be move to right.

""
" Config the direction of file tree. Default is 'right'. you can also set to
" 'left'. 
"
" NOTE: if it is 'left', the tagbar will be move to right.
let g:spacevim_filetree_direction             = 'right'

let g:spacevim_sidebar_direction        = ''
""
" The default plugin manager of SpaceVim.
" if has patch 7.4.2071, the default value is dein. Otherwise it is neobundle.
" Options are dein, neobundle, or vim-plug.
if has('patch-7.4.2071')
  let g:spacevim_plugin_manager          = 'dein'
else
  let g:spacevim_plugin_manager          = 'neobundle'
endif

""
" @section plugin_manager_processes, options-plugin_manager_processes
" @parentsection options
" Set the max process of SpaceVim plugin manager

""
" Set the max process of SpaceVim plugin manager
let g:spacevim_plugin_manager_processes = 16

""
" @section checkinstall, options-checkinstall
" @parentsection options
" Enable/Disable checkinstall on SpaceVim startup. Default is true.
" >
"   checkinstall = true
" <

""
" Enable/Disable checkinstall on SpaceVim startup. Default is 1.
" >
"   let g:spacevim_checkinstall = 1
" <
let g:spacevim_checkinstall            = 1
""
" @section vimcompatible, options-vimcompatible
" @parentsection options
" Enable/Disable vimcompatible mode, by default it is false. 
" to enable vimcompatible mode, just add:
" >
"   vimcompatible = true
" <
" In vimcompatible mode all vim origin key bindings will not be changed.
"
" Includes:
" >
"   q       smart quit windows
"   s       windows key bindings leader
"   ,       language specific leader
"   <C-a>   move cursor to beginning in command line mode
"   <C-b>   move cursor to left in command line mode
"   <C-f>   move cursor to right in command line mode
"   <C-x>   switch buffer
" <

""
" Enable/Disable vimcompatible mode, by default it is false. 
" to enable vimcompatible mode, just add:
" >
"   let g:spacevim_vimcompatible = 1
" <
" In vimcompatible mode all vim origin key bindings will not be changed.
"
" Includes:
" >
"   q       smart quit windows
"   s       windows key bindings leader
"   ,       language specific leader
"   <C-a>   move cursor to beginning in command line mode
"   <C-b>   move cursor to left in command line mode
"   <C-f>   move cursor to right in command line mode
"   <C-x>   switch buffer
" <
let g:spacevim_vimcompatible           = 0
""
" @section enable_debug, options-enable_debug
" @parentsection options
" Enable/Disable debug mode for SpaceVim. Default is false.
" >
"   enable_debug = true
" <

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
let g:spacevim_gitcommit_pr_icon       = ''
let g:spacevim_gitcommit_issue_icon    = ''
""
" @section buffer_index_type, options-buffer_index_type
" @parentsection options
" Set SpaceVim buffer index type, default is 4.
" >
"   # types:
"   # 0: 1 ➛ ➊
"   # 1: 1 ➛ ➀
"   # 2: 1 ➛ ⓵
"   # 3: 1 ➛ ¹
"   # 4: 1 ➛ 1
"   buffer_index_type = 1
" <


""
" Set SpaceVim buffer index type, default is 4.
" >
"   " types:
"   " 0: 1 ➛ ➊
"   " 1: 1 ➛ ➀
"   " 2: 1 ➛ ⓵
"   " 3: 1 ➛ ¹
"   " 4: 1 ➛ 1
"   let g:spacevim_buffer_index_type = 1
" <
let g:spacevim_buffer_index_type = 4

""
" @section windows_index_type, options-windows_index_type
" @parentsection options
" Set SpaceVim windows index type, default is 3.
" >
"   # types:
"   # 0: 1 ➛ ➊
"   # 1: 1 ➛ ➀
"   # 2: 1 ➛ ⓵
"   # 3: 1 ➛ 1
"   windows_index_type = 1
" <



""
" Set SpaceVim windows index type, default is 3.
" >
"   " types:
"   " 0: 1 ➛ ➊
"   " 1: 1 ➛ ➀
"   " 2: 1 ➛ ⓵
"   " 3: 1 ➛ 1
"   let g:spacevim_windows_index_type = 1
" <
let g:spacevim_windows_index_type = 3
""
" @section enable_tabline_ft_icon, options-enable_tabline_ft_icon
" @parentsection options
" Enable/Disable tabline filetype icon. default is false. To enable this
" feature:
" >
"   enable_tabline_ft_icon = true
" <


""
" Enable/Disable tabline filetype icon. default is 0.
let g:spacevim_enable_tabline_ft_icon = 0
""
" Enable/Disable os fileformat icon. default is 0.
let g:spacevim_enable_os_fileformat_icon = 0
""
" Set the github username, It will be used for getting your starred repos, and
" fuzzy find the repo you want.
let g:spacevim_github_username         = ''
""
" @section windows_smartclose, options-windows_smartclose
" @parentsection options
" Set the default key for smart close windows, default is `q`.
" to disable this feature, just set it to empty string:
" >
"   windows_smartclose = ""
" <

""
" Set the default key for smart close windows, default is `q`.
let g:spacevim_windows_smartclose      = 'q'
""
" Disable plugins by name.
" >
"   let g:spacevim_disabled_plugins = ['vim-foo', 'vim-bar']
" <
let g:spacevim_disabled_plugins        = []
""
" @section custom_plugins, usage-custom_plugins
" @parentsection usage
" Add custom plugins.
" >
"   [[custom_plugins]]
"     name = 'vimwiki/vimwiki'
"     merged = false
" <

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
" change the default filetype icon for a specific filtype.
" >
"   let g:spacevim_filetype_icons['md'] = ''
" <
let g:spacevim_filetype_icons           = {}
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
" Default search tools supported by flygrep. The default order is ['rg', 'ag',
" 'pt', 'ack', 'grep', 'findstr']
let g:spacevim_search_tools            = ['rg', 'ag', 'pt', 'ack', 'grep', 'findstr']
""
" Set the project rooter patterns, by default it is
" `['.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']`
let g:spacevim_project_rooter_patterns = ['.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
""
" Enable/Disable changing directory automatically. Enabled by default.
let g:spacevim_project_rooter_automatically = 1
""
" Enable/Disable finding outermost directory for project root detection.
let g:spacevim_project_rooter_outermost = 1

""
" Config the command line prompt for flygrep and denite etc.
let g:spacevim_commandline_prompt = '➭'

""
" Option for setting todo labels in current project.
let g:spacevim_todo_labels = map(['fixme', 'question', 'todo', 'idea'], '"@" . v:val')

""
" @section lint_on_the_fly, options-lint_on_the_fly
" @parentsection options
" Enable/Disable lint on the fly feature of SpaceVim's maker. Default is true.
" >
"   lint_on_the_fly = false
" <

""
" Enable/Disable lint on the fly feature of SpaceVim's maker. Default is 0.
" >
"   let g:spacevim_lint_on_the_fly = 0
" <
let g:spacevim_lint_on_the_fly         = 0

""
" @section retry_cnt, options-retry_cnt
" @parentsection options
" Set the number of retries for SpaceVim Update when failed. Default is 3.
" Set to 0 to disable this feature, or you can set to another number.
" >
"   update_retry_cnt = 3
" <


""
" Set the number of retries for SpaceVim Update when failed. Default is 3.
" Set to 0 to disable this feature, or you can set to another number.
" >
"   let g:spacevim_update_retry_cnt = 3
" <
let g:spacevim_update_retry_cnt          = 3
""
" @section enable_vimfiler_welcome, options-enable_vimfiler_welcome
" @parentsection options
" Enable/Disable vimfiler in the welcome windows. Default is true.
" This will cause vim to start up slowly if there are too many files in the
" current directory.
" >
"   enable_vimfiler_welcome = false
" <

""
" Enable/Disable vimfiler in the welcome windows. Default is 1.
" This will cause vim to start up slowly if there are too many files in the
" current directory.
" >
"   let g:spacevim_enable_vimfiler_welcome = 0
" <
let g:spacevim_enable_vimfiler_welcome = 1
""
" @section autocomplete_parens, options-autocomplete_parens
" @parentsection options
" Enable/Disable autocompletion of parentheses, default is true (enabled).
" >
"   autocomplete_parens = false
" <

""
" Enable/Disable autocompletion of parentheses, default is 1 (enabled).
let g:spacevim_autocomplete_parens = 1
""
" Enable/Disable gitstatus column in vimfiler buffer, default is 0.
let g:spacevim_enable_vimfiler_gitstatus = 0
""
" Enable/Disable filetypeicon column in vimfiler buffer, default is 0.
let g:spacevim_enable_vimfiler_filetypeicon = 0
let g:spacevim_smartcloseignorewin     = ['__Tagbar__' , 'vimfiler:default']
let g:spacevim_smartcloseignoreft      = [
      \ 'tagbar',
      \ 'vimfiler',
      \ 'defx',
      \ 'SpaceVimRunner',
      \ 'SpaceVimREPL',
      \ 'SpaceVimQuickFix',
      \ 'HelpDescribe',
      \ 'VebuggerShell',
      \ 'VebuggerTerminal',
      \ 'SpaceVimTabsManager'
      \ ]
let g:_spacevim_altmoveignoreft         = ['Tagbar' , 'vimfiler']
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

" }}}


" Private SpaceVim options
let g:_spacevim_mappings = {}
let g:_spacevim_mappings_space_custom = []
let g:_spacevim_mappings_space_custom_group_name = []
let g:_spacevim_neobundle_installed     = 0
let g:_spacevim_dein_installed          = 0
let g:_spacevim_vim_plug_installed      = 0

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

if !exists('g:leaderGuide_hspace')
  let g:leaderGuide_hspace = 5
endif

let g:spacevim_leader_guide_hspace = 5

if !exists('g:leaderGuide_flatten')
  let g:leaderGuide_flatten = 1
endif

let g:spacevim_leader_guide_flatten = 1

if !exists('g:leaderGuide_default_group_name')
  let g:leaderGuide_default_group_name = ''
endif

let g:spacevim_leader_guide_default_group_name = ''

if !exists('g:leaderGuide_max_size')
  let g:leaderGuide_max_size = 0
endif

let g:spacevim_leader_guide_max_size = 0

if !exists('g:leaderGuide_submode_mappings')
  let g:leaderGuide_submode_mappings =
        \ { '<C-C>': 'win_close', 'n': 'page_down', 'p': 'page_up', 'u' : 'undo'}
endif

let g:spacevim_leader_guide_submode_mappings = {'<C-C>': 'win_close'}

" SpaceVim/LanguageClient-neovim {{{
if !exists('g:LanguageClient_serverCommands')
  let g:LanguageClient_serverCommands = {}
endif
" }}}


command -nargs=1 LeaderGuide call SpaceVim#mapping#guide#start_by_prefix('0', <args>)
command -range -nargs=1 LeaderGuideVisual call SpaceVim#mapping#guide#start_by_prefix('1', <args>)

function! SpaceVim#end() abort
  if !g:spacevim_vimcompatible
    call SpaceVim#mapping#def('nnoremap <silent>', '<Tab>', ':wincmd w<CR>', 'Switch to next window or tab','wincmd w')
    call SpaceVim#mapping#def('nnoremap <silent>', '<S-Tab>', ':wincmd p<CR>', 'Switch to previous window or tab','wincmd p')
  endif
  if g:spacevim_vimcompatible
    let g:spacevim_windows_leader = ''
    let g:spacevim_windows_smartclose = ''
  endif

  if !g:spacevim_vimcompatible
    nnoremap <silent><C-x> <C-w>x
    cnoremap <C-f> <Right>
    " Navigation in command line
    cnoremap <C-a> <Home>
    cnoremap <C-b> <Left>
    " @bug_vim with <silent> command line can not be cleared
    cnoremap <expr> <C-k> repeat('<Delete>', strchars(getcmdline()) - getcmdpos() + 1)

    "Use escape_key_binding switch to normal mode
    if !empty(g:spacevim_escape_key_binding)
      exe printf('inoremap %s <esc>', g:spacevim_escape_key_binding)
    endif
  endif
  call SpaceVim#server#connect()

  if g:spacevim_enable_neocomplcache
    let g:spacevim_autocomplete_method = 'neocomplcache'
  endif
  if g:spacevim_enable_ycm
    if has('python') || has('python3')
      let g:spacevim_autocomplete_method = 'ycm'
    else
      call SpaceVim#logger#warn('YCM need +python or +python3 support, force to using ' . g:spacevim_autocomplete_method)
    endif
  endif
  if g:spacevim_keep_server_alive
    call SpaceVim#server#export_server()
  endif
  if !empty(g:spacevim_windows_leader)
    call SpaceVim#mapping#leader#defindWindowsLeader(g:spacevim_windows_leader)
  endif
  call SpaceVim#mapping#g#init()
  call SpaceVim#mapping#z#init()
  call SpaceVim#mapping#leader#defindKEYs()
  call SpaceVim#mapping#space#init()
  if !SpaceVim#mapping#guide#has_configuration()
    let g:leaderGuide_map = {}
    call SpaceVim#mapping#guide#register_prefix_descriptions('', 'g:leaderGuide_map')
  endif
  if g:spacevim_vim_help_language ==# 'cn'
    let &helplang = 'cn'
  elseif g:spacevim_vim_help_language ==# 'ja'
    let &helplang = 'jp'
  endif
  ""
  " generate tags for SpaceVim
  let help = fnamemodify(g:_spacevim_root_dir, ':p:h') . '/doc'
  try
    exe 'helptags ' . help
  catch
    call SpaceVim#logger#warn('Failed to generate helptags for SpaceVim')
  endtry

  ""
  " set language
  if !empty(g:spacevim_language)
    silent exec 'lan ' . g:spacevim_language
  endif

  if SpaceVim#layers#isLoaded('core#statusline')
    call SpaceVim#layers#core#statusline#init()
  endif

  " tab options:
  set smarttab
  let &expandtab = g:spacevim_expand_tab
  let &tabstop = g:spacevim_default_indent
  let &softtabstop = g:spacevim_default_indent
  let &shiftwidth = g:spacevim_default_indent

  let g:unite_source_menu_menus =
        \ get(g:,'unite_source_menu_menus',{})
  let g:unite_source_menu_menus.CustomKeyMaps = {'description':
        \ 'Custom mapped keyboard shortcuts                   [unite]<SPACE>'}
  let g:unite_source_menu_menus.CustomKeyMaps.command_candidates =
        \ get(g:unite_source_menu_menus.CustomKeyMaps,'command_candidates', [])
  let g:unite_source_menu_menus.MyStarredrepos = {'description':
        \ 'All github repos starred by me                   <leader>ls'}
  let g:unite_source_menu_menus.MyStarredrepos.command_candidates =
        \ get(g:unite_source_menu_menus.MyStarredrepos,'command_candidates', [])
  let g:unite_source_menu_menus.MpvPlayer = {'description':
        \ 'Musics list                   <leader>lm'}
  let g:unite_source_menu_menus.MpvPlayer.command_candidates =
        \ get(g:unite_source_menu_menus.MpvPlayer,'command_candidates', [])

  if g:spacevim_realtime_leader_guide
    nnoremap <silent><nowait> <leader> :<c-u>LeaderGuide get(g:, 'mapleader', '\')<CR>
    vnoremap <silent> <leader> :<c-u>LeaderGuideVisual get(g:, 'mapleader', '\')<CR>
  endif
  let g:leaderGuide_max_size = 15
  call SpaceVim#plugins#load()

  call SpaceVim#plugins#projectmanager#RootchandgeCallback()

  call SpaceVim#util#loadConfig('general.vim')



  call SpaceVim#autocmds#init()

  if has('nvim')
    call SpaceVim#util#loadConfig('neovim.vim')
  endif

  call SpaceVim#util#loadConfig('commands.vim')
  filetype plugin indent on
  syntax on
endfunction


" return [status, dir]
" status: 0 : no argv
"         1 : dir
"         2 : filename
function! s:parser_argv() abort
  if !argc()
    return [0]
  elseif argv(0) =~# '/$'
    let f = fnamemodify(expand(argv(0)), ':p')
    if isdirectory(f)
      return [1, f]
    else
      return [1, getcwd()]
    endif
  elseif argv(0) ==# '.'
    return [1, getcwd()]
  elseif isdirectory(expand(argv(0)))
    return [1, fnamemodify(expand(argv(0)), ':p')]
  else
    return [2, argv()]
  endif
endfunction

function! SpaceVim#begin() abort

  call SpaceVim#util#loadConfig('functions.vim')
  call SpaceVim#util#loadConfig('init.vim')

  " Before loading SpaceVim, We need to parser argvs.
  let s:status = s:parser_argv()
  " If do not start Vim with filename, Define autocmd for opening welcome page
  if s:status[0] == 0
    let g:_spacevim_enter_dir = fnamemodify(getcwd(), ':~')
    call SpaceVim#logger#info('Startup with no argv, current dir is used: ' . g:_spacevim_enter_dir )
    augroup SPwelcome
      au!
      autocmd VimEnter * call SpaceVim#welcome()
    augroup END
  elseif s:status[0] == 1
    let g:_spacevim_enter_dir = fnamemodify(s:status[1], ':~')
    call SpaceVim#logger#info('Startup with directory: ' . g:_spacevim_enter_dir  )
    augroup SPwelcome
      au!
      autocmd VimEnter * call SpaceVim#welcome()
    augroup END
  else
    call SpaceVim#logger#info('Startup with argv: ' . string(s:status[1]) )
  endif
  call SpaceVim#default#options()
  call SpaceVim#default#layers()
  call SpaceVim#default#keyBindings()
  call SpaceVim#commands#load()
endfunction

function! SpaceVim#welcome() abort
  call SpaceVim#logger#info('try to open SpaceVim welcome page')
  if get(g:, '_spacevim_session_loaded', 0) == 1
    call SpaceVim#logger#info('start SpaceVim with session file, skip welcome page')
    return
  endif
  exe 'cd' fnameescape(g:_spacevim_enter_dir)
  if exists('g:_spacevim_checking_flag') && g:_spacevim_checking_flag
    return
  endif
  if exists(':Startify') == 2
    Startify
    if isdirectory(bufname(1))
      bwipeout! 1
    endif
  endif
  if g:spacevim_enable_vimfiler_welcome
        \ && get(g:, '_spacevim_checking_flag', 0) == 0
    if exists(':VimFiler') == 2
      VimFiler
      wincmd p
    elseif exists(':Defx') == 2
      Defx
      wincmd p
    elseif exists(':NERDTree') == 2
      NERDTree
      wincmd p
    endif
  endif
endfunction

""
" @section Usage, usage
"   the usage guide for SpaceVim

""
" @section FAQ, faq
" This is a list of the frequently asked questions about SpaceVim.
"
" 1. How do I enable YouCompleteMe?
"
"   Step 1: Add `enable_ycm = true` to custom_config. By default it should be
"   `~/.SpaceVim.d/init.toml`.
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
" 
"
" 2. How to add custom snippet?
" 
"  SpaceVim uses neosnippet as the default snippet engine. This can be changed
" by @section(options-snippet_engine) option.
"
"  If you want to add a snippet for a current filetype, run |:NeoSnippetEdit|
" command. A buffer will be opened and you can add your custom snippet.
" By default this buffer will be save in `~/.SpaceVim.d/snippets`.
"
"  For more info about how to write snippet, please
" read |neosnippet-snippet-syntax|.
"
"
" 3. Where is `<c-f>` in cmdline-mode?
" 
"   `<c-f>` is the default value of |cedit| option, but in SpaceVim we use that
" binding as `<Right>`, so maybe you can change the `cedit` option or use
"   `<leader>+<c-f>`.
"
" 4. How to use `<Space>` as `<Leader>`?
" 
"   Add `let g:mapleader = "\<Space>"` to bootstrap function.
" 
" 5. Why does Vim freeze after pressing Ctrl-s?
"
"   This is a feature of terminal emulators. You can use `Ctrl-q` to unfreeze Vim. To disable
" this feature you need the following in either `~/.bash_profile` or `~/.bashrc`:
">
"   stty -ixon
"<
"
" 6. How to enable `+py` and `+py3` in Neovim?
"
"   In Neovim we can use `g:python_host_prog` and `g:python3_host_prog`
"   to config python prog. But in SpaceVim the custom configuration file is
"   loaded after SpaceVim core code. So in SpaceVim itself, if we using `:py`
"   command, it may cause errors.
"   
"   So we introduce two new environment variables: `PYTHON_HOST_PROG` and
"   `PYTHON3_HOST_PROG`.
"
"   For example:
" >
"   export PYTHON_HOST_PROG='/home/q/envs/neovim2/bin/python'
"   export PYTHON3_HOST_PROG='/home/q/envs/neovim3/bin/python'
" <

""
" @section Changelog, changelog
" Following HEAD: changes in master branch since last release v1.4.0
"
" https://github.com/SpaceVim/SpaceVim/wiki/Following-HEAD
"
" 2020-04-05: v1.4.0
"
" https://spacevim.org/SpaceVim-release-v1.4.0/
"
" 2019-11-04: v1.3.0
"
" https://spacevim.org/SpaceVim-release-v1.3.0/
"
" 2019-07-17: v1.2.0
"
" https://spacevim.org/SpaceVim-release-v1.2.0/
"
" 2019-04-08: v1.1.0
"
" https://spacevim.org/SpaceVim-release-v1.1.0/
"
" 2018-12-25: v1.0.0
"
" https://spacevim.org/SpaceVim-release-v1.0.0/
"
" 2018-09-26: v0.9.0
"
" https://spacevim.org/SpaceVim-release-v0.9.0/
"
" 2018-06-18: v0.8.0
"
" https://spacevim.org/SpaceVim-release-v0.8.0/
"
" 2018-03-18: v0.7.0
"
" https://spacevim.org/SpaceVim-release-v0.7.0/
"
" 2017-12-30: v0.6.0
"
" https://spacevim.org/SpaceVim-release-v0.6.0/
"
" 2017-11-06: v0.5.0
"
" https://spacevim.org/SpaceVim-release-v0.5.0/
"
" 2017-08-05: v0.4.0
"
" https://spacevim.org/SpaceVim-release-v0.4.0/
"
" 2017-06-27: v0.3.1
"
" https://spacevim.org/SpaceVim-release-v0.3.1/
"
" 2017-05-31: v0.3.0
"
" https://spacevim.org/SpaceVim-release-v0.3.0/
"
" 2017-03-30: v0.2.0
"
" https://spacevim.org/SpaceVim-release-v0.2.0/
"
" 2017-01-26: v0.1.0
"
" https://spacevim.org/SpaceVim-release-v0.1.0/
"

" vim:set et sw=2 cc=80:
