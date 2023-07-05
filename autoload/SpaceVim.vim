"=============================================================================
" SpaceVim.vim --- Initialization and core files for SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

""
" @section Introduction, intro
" @stylized spacevim
" @library
" @order intro options config functions layers usage plugins api dev faq changelog
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
" please take a look at the following options add @section(functions)


""
" @section Public functions, functions
" All of these functions can be used in `~/.SpaceVim.d/init.vim` and bootstrap
" functions.


let s:SYSTEM = SpaceVim#api#import('system')

" Public SpaceVim Options {{{

""
" Version of SpaceVim , this value can not be changed.
let g:spacevim_version = '2.3.0-dev'
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
" @section expand_tab, options-expand_tab
" @parentsection options
" In Insert mode: Use the appropriate number of spaces to insert a <Tab>

""
" In Insert mode: Use the appropriate number of spaces to insert a <Tab>
let g:spacevim_expand_tab              = 1

""
" @section enable_list_mode, options-enable_list_mode
" @parentsection options
" Enable/Disable list mode, by default it is disabled.

""
" Enable/Disable list mode, by default it is disabled.
let g:spacevim_enable_list_mode        = 0

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
" Enable/Disable line wrap of vim
let g:spacevim_wrap_line = 0

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
" @section windisk_encoding, options-windisk_encoding
" @parentsection options
" Setting the encoding of windisk info. by default it is `cp936`.
" >
"   windisk_encoding = 'cp936'
" <

let g:spacevim_windisk_encoding = 'cp936'

""
" @section default_custom_leader, options-default_custom_leader
" @parentsection options
" Change the default custom leader of SpaceVim. Default is <Space>.
" >
"   default_custom_leader = "<Space>"
" <

""
" Change the default custom leader of SpaceVim. Default is <Space>.
" >
"   let g:spacevim_default_custom_leader = '<Space>'
" <
let g:spacevim_default_custom_leader = '<Space>'

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
" @section code_runner_focus, options-code_runner_focus
" @parentsection options
" enable/disable code runner window focus mode, by default this option is
" `false`, to enable this mode, set this option to `true`.
" >
"   code_runner_focus = true
" <

""
" enable/disable code runner window focus mode, by default this option is 0,
" to enable this mode, set this option to 1.
let g:spacevim_code_runner_focus = 0

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
" @section file_searching_tools, options-file_searching_tools
" @parentsection options
" Set the default file searching tool used by `SPC f /`, by default it is `[]`.
" The first item in this list is the name of the tool, the second one is the
" default command. for example:
" >
"   file_searching_tools = ['find', 'find -not -iwholename "*.git*" ']
" <

let g:spacevim_file_searching_tools = []

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

if !isdirectory(g:spacevim_data_dir)
  call mkdir(g:spacevim_data_dir, 'p')
endif

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
"   let g:spacevim_plugin_bundle_dir = g:spacevim_data_dir.'vimplugs'
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
" @section leader_guide_theme, options-leader_guide_theme
" @parentsection options
" Enable/Disable realtime leader guide. Default is true. to disable it:
" Set the key mapping guide theme, the default theme is `leaderguide`.
"
" available themes:
"
" - `leaderguide`: same as LeaderGuide.vim
"
" - `whichkey`: same as which-key.nvim
" >
"   leader_guide_theme = 'leaderguide'
" <

""
" Enable/Disable realtime leader guide. Default is true. to disable it:
" Set the key mapping guide theme, the default theme is `leaderguide`.
"
" available themes:
"
" - `leaderguide`: same as LeaderGuide.vim
"
" - `whichkey`: same as which-key.nvim
" >
"   let g:spacevim_leader_guide_theme = 'leaderguide'
" <
let g:spacevim_leader_guide_theme = 'leaderguide'

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
if (has('python3') 
      \ && (SpaceVim#util#haspy3lib('neovim')
      \ || SpaceVim#util#haspy3lib('pynvim'))) &&
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
  " If you are using neovim, you can also set this option to `nvim-cmp`, then
  " nvim-cmp will be used.

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

  " neocomplete does not work with Vim 8.2.1066
elseif has('lua') && !has('patch-8.2.1066')
  let g:spacevim_autocomplete_method = 'neocomplete'
elseif has('python') && ((has('job') && has('timers') && has('lambda')) || has('nvim'))
  let g:spacevim_autocomplete_method = 'completor'
elseif has('timers')
  let g:spacevim_autocomplete_method = 'asyncomplete'
else
  let g:spacevim_autocomplete_method = 'neocomplcache'
endif

""
" @section lint_engine, options-lint_engine
" @parentsection options
" Set the lint engine used in checkers layer, the default engine is neomake,
" if you want to use ale, use:
" >
"   lint_engine = 'ale'
" <
" NOTE: the `enable_neomake` and `enable_ale` option has been deprecated.
" *spacevim-options-enable_naomake*
" *spacevim-options-enable_ale*

""
" Set the lint engine used in checkers layer, the default engine is neomake,
" if you want to use ale, use:
" >
"   let g:spacevim_lint_engine = 'ale'
" <
let g:spacevim_lint_engine = 'neomake'

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
let g:spacevim_guifont                 = 'SauceCodePro Nerd Font Mono:h11'

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
" This value will be used by tagbar and filetree.

""
" Set the width of the SpaceVim sidebar. Default is 30.
" This value will be used by tagbar and filetree.
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
" @section statusline_left, options-statusline_left
" @parentsection options
" Define the left section of statusline in active windows. By default:
" >
"   statusline_left = [
"     'winnr',
"     'filename',
"     'major mode',
"     'minor mode lighters',
"     'version control info'
"     ]
" <
" `statusline_left_sections` is deprecated, use `statusline_left` instead. 

""
" Define the left section of statusline in active windows. By default:
" >
"   let g:spacevim_statusline_left =
"     \ [
"     \ 'winnr',
"     \ 'filename',
"     \ 'major mode',
"     \ 'minor mode lighters',
"     \ 'version control info'
"     \ ]
" <
" `g:spacevim_statusline_left_sections` is deprecated,
" use `g:spacevim_statusline_left` instead. 
let g:spacevim_statusline_left = ['winnr', 'filename', 'major mode',
      \ 'search count',
      \ 'syntax checking', 'minor mode lighters',
      \ ]
""
" @section statusline_right, options-statusline_right
" @parentsection options
" Define the right section of statusline in active windows. By default:
" >
"   statusline_right = [
"     'fileformat',
"     'cursorpos',
"     'percentage'
"     ]
" <
"
" The following sections can be used in this option:
" - fileformat: the format of current file
" - cursorpos: the corsur position
" - percentage: the percent of current page
" - totallines: the total lines of current buffer
"
" `statusline_right_sections` is deprecated, use `statusline_right` instead. 

""
" Define the right section of statusline in active windows. By default:
" >
"   g:spacevim_statusline_right =
"     \ [
"     \ 'fileformat',
"     \ 'cursorpos',
"     \ 'percentage'
"     \ ]
" <
"
" `g:spacevim_statusline_right_sections` is deprecated,
" use `g:spacevim_statusline_right` instead. 
let g:spacevim_statusline_right = ['fileformat', 'cursorpos', 'percentage']

""
" @section statusline_unicode, options-statusline_unicode
" @parentsection options
" Enable/Disable unicode symbols in statusline, includes the mode icons and
" fileformat icons. This option is enabled by default, to disable it:
" >
"   statusline_unicode = false
" <

""
" Enable/Disable unicode symbols in statusline, includes the mode icons and
" fileformat icons. This option is enabled by default, to disable it:
" >
"   let g:spacevim_statusline_unicode = 0
" <
let g:spacevim_statusline_unicode = 1
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
" The default file manager of SpaceVim. Default is 'nerdtree'.
" you can also use defx or vimfiler

""
" The default file manager of SpaceVim. Default is 'nerdtree'.
" you can also use defx or vimfiler
let g:spacevim_filemanager             = 'nerdtree'
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
" @section disabled_plugins, options-disabled_plugins
" @parentsection options
" >
"   disabled_plugins = ['vim-foo', 'vim-bar']
" <

""
" Disable plugins by name.
" >
"   let g:spacevim_disabled_plugins = ['vim-foo', 'vim-bar']
" <
let g:spacevim_disabled_plugins        = []
""
" @section custom_plugins, usage-custom_plugins
" @parentsection usage
" If you want to add custom plugin, use `custom_plugins` section. For example:
" if you want to add https://github.com/vimwiki/vimwiki, add following code
" into your configuration file.
" >
"   [[custom_plugins]]
"     repo = 'vimwiki/vimwiki'
"     merged = false
" <
" Use one custom_plugins for each plugin, example:
" >
"   [[custom_plugins]]
"     repo = 'vimwiki/vimwiki'
"     merged = false
"   [[custom_plugins]]
"     repo = 'wsdjeg/vim-j'
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
" NOTE: the `lint_on_save` option has been deprecated. Please use layer option
" of @section(layers-checkers) layer.
let g:spacevim_lint_on_save            = 1
""
" @section search_tools, options-search_tools
" @parentsection options
" Default search tools supported by flygrep. The default order is ['rg', 'ag',
" 'pt', 'ack', 'grep', 'findstr', 'git']
" The `git` command means using `git-grep`. If you prefer to use `git-grep` by
" default. You can change this option to:
" >
"   [options]
"     search_tools = ['git', 'rg', 'ag']
" <

""
" Default search tools supported by flygrep. The default order is ['rg', 'ag',
" 'pt', 'ack', 'grep', 'findstr', 'git']
let g:spacevim_search_tools            = ['rg', 'ag', 'pt', 'ack', 'grep', 'findstr', 'git']
""
" @section project_rooter_patterns, options-project_rooter_patterns
" @parentsection options
" Set the project root patterns, SpaceVim determines the root directory of the
" project based on this option. By default it is:
" >
"   ['.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
" <

""
" Set the project root patterns, SpaceVim determines the root directory of the
" project based on this option. By default it is:
" >
"   ['.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
" <
let g:spacevim_project_rooter_patterns = ['.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']


""
" @section project_non_root, options-project_non_root
" @parentsection options
" This option set the default behavior for non-project files.
" - `current`: change to file's dir, like `autochdir`
" - `''`: do not change directory
" - `home`: change to home directory

let g:spacevim_project_non_root = ''


""
" @section enable_projects_cache, options-enable_projects_cache
" @parentsection options
" Enable/Disable cross session projects cache. Enabled by default.

""
" Enable/Disable cross session projects cache. Enabled by default.
let g:spacevim_enable_projects_cache = 1
""
" @section projects_cache_num, options-projects_cache_num
" @parentsection options
" Setting the numbers of cached projects, by default it is 20.

""
" Setting the numbers of cached projects, by default it is 20.
let g:spacevim_projects_cache_num = 20
""
" @section project_auto_root, options-project_auto_root
" @parentsection options
" Enable/Disable project root detection. By default, SpaceVim will change the
" directory to the project root directory based on `project_rooter_patterns`
" option. To disable this feature:
" >
"   [options]
"     project_auto_root = false
" <
" NOTE: *g:spacevim_project_rooter_automatically* and
" *SpaceVim-options-project_rooter_automatically* are deprecated.

""
" Enable/Disable changing directory automatically. Enabled by default.
let g:spacevim_project_auto_root = 1
""
" @section project_rooter_outermost, options-project_rooter_outermost
" @parentsection options
" Enable/Disable finding outermost directory for project root detection.
" By default SpaceVim will find the outermost directory based on
" `project_rooter_patterns`. To find nearest directory, you need to disable
" this option:
" >
"   [options]
"     project_rooter_outermost = false
" <

""
" Enable/Disable finding outermost directory for project root detection.
" By default SpaceVim will find the outermost directory based on
" `project_rooter_patterns`. To find nearest directory, you need to disable
" this option:
" >
"   let g:spacevim_project_rooter_outermost = 0
" <
let g:spacevim_project_rooter_outermost = 1
""
" @section commandline_prompt, options-commandline_prompt
" @parentsection options
" Config the command line prompt for flygrep and denite etc.
" Default is `>`, for example:
" >
"   commandline_prompt = '➭'
" <

""
" Config the command line prompt for flygrep and denite etc.
let g:spacevim_commandline_prompt = '>'

""
" @section todo_labels, options-todo_labels
" @parentsection options
" Option for setting todo labels in current project.

""
" Option for setting todo labels in current project.
let g:spacevim_todo_labels = ['fixme', 'question', 'todo', 'idea']

""
" @section todo_prefix, options-todo_prefix
" @parentsection options
" Option for setting todo prefix in current project.
" The default is `@`

let g:spacevim_todo_prefix = '@'

""
" @section lint_on_the_fly, options-lint_on_the_fly
" @parentsection options
" Enable/Disable lint on the fly feature of SpaceVim's maker. Default is true.
" >
"   lint_on_the_fly = false
" <
" NOTE: the `lint_on_the_fly` option has been deprecated. Please use layer option
" of @section(layers-checkers) layer.

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
let g:spacevim_smartcloseignorewin     = ['__Tagbar__' , 'vimfiler:default']
let g:spacevim_smartcloseignoreft      = [
      \ 'tagbar',
      \ 'neo-tree',
      \ 'vimfiler',
      \ 'defx',
      \ 'NvimTree',
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
""
" @section src_root, options-src_root
" @parentsection options
" set default sources root of all your projects. default is `E:\sources\`.
" >
"   src_root = 'E:\sources\'
" <

let g:spacevim_src_root                = 'E:\sources\'
""
" The host file url. This option is for Chinese users who can not use
" Google and Twitter.
let g:spacevim_hosts_url
      \ = 'https://raw.githubusercontent.com/racaljk/hosts/master/hosts'
""
" @section wildignore, options-wildignore
" @parentsection options
" A list of file patterns when file match it will be ignored.
" >
"   wildignore =  '*/tmp/*,*.so,*.swp,*.zip,*.class,tags,*.jpg,*.ttf,*.TTF,*.png,*/target/*,.git,.svn,.hg,.DS_Store,*.svg'
" <

let g:spacevim_wildignore
      \ = '*/tmp/*,*.so,*.swp,*.zip,*.class,tags,*.jpg,*.ttf,*.TTF,*.png,*/target/*,.git,.svn,.hg,.DS_Store,*.svg'

" }}}


" Private SpaceVim options
let g:_spacevim_mappings = {}
let g:_spacevim_mappings_space_custom = []
let g:_spacevim_mappings_space_custom_group_name = []
let g:_spacevim_mappings_leader_custom = []
let g:_spacevim_mappings_leader_custom_group_name = []
let g:_spacevim_mappings_language_specified_space_custom = {}
let g:_spacevim_mappings_lang_group_name = {}
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


command! -nargs=1 LeaderGuide call SpaceVim#mapping#guide#start_by_prefix('0', <args>)
command! -range -nargs=1 LeaderGuideVisual call SpaceVim#mapping#guide#start_by_prefix('1', <args>)

function! SpaceVim#end() abort
  if g:spacevim_vimcompatible
    let g:spacevim_windows_leader = ''
    let g:spacevim_windows_smartclose = ''
  endif

  if !g:spacevim_vimcompatible
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
  " generate tags for SpaceVim
  let help = fnamemodify(g:_spacevim_root_dir, ':p:h') . '/doc'
  try
    exe 'helptags ' . help
  catch
    call SpaceVim#logger#warn('Failed to generate helptags for SpaceVim')
  endtry
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
  let &wrap = g:spacevim_wrap_line
  let &list = g:spacevim_enable_list_mode

  if g:spacevim_default_indent > 0
    let &tabstop = g:spacevim_default_indent
    let &softtabstop = g:spacevim_default_indent
    let &shiftwidth = g:spacevim_default_indent
  endif

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

  exe 'set wildignore+=' . g:spacevim_wildignore
  " shell
  if has('filterpipe')
    set noshelltemp
  endif
  if g:spacevim_enable_guicolors == 1
    if !has('nvim') && has('patch-7.4.1770')
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    if exists('+termguicolors')
      set termguicolors
    elseif exists('+guicolors')
      set guicolors
    endif
  endif

  call SpaceVim#autocmds#init()

  if g:spacevim_colorscheme !=# '' "{{{
    try
      exec 'set background=' . g:spacevim_colorscheme_bg
      exec 'colorscheme ' . g:spacevim_colorscheme
    catch
      exec 'colorscheme '. g:spacevim_colorscheme_default
    endtry
  else
    exec 'colorscheme '. g:spacevim_colorscheme_default
  endif
  if g:spacevim_hiddenfileinfo == 1 && has('patch-7.4.1570')
    set shortmess+=F
  endif
  if !empty(g:spacevim_guifont)
    try
      let &guifont = g:spacevim_guifont
    catch
      call SpaceVim#logger#error('failed to set guifont to: '
            \ . g:spacevim_guifont)
      call SpaceVim#logger#error('       exception: ' . v:exception)
      call SpaceVim#logger#error('       throwpoint: ' . v:throwpoint)
    endtry
  endif

  if !has('nvim-0.2.0') && !has('nvim')
    " In old version of neovim, &guicursor do not support cursor shape
    " setting.
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = g:spacevim_terminal_cursor_shape
  else
    if g:spacevim_terminal_cursor_shape == 0
      " prevent nvim from changing the cursor shape
      set guicursor=
    elseif g:spacevim_terminal_cursor_shape == 1
      " enable non-blinking mode-sensitive cursor
      set guicursor=n-v-c:block-blinkon0,i-ci-ve:ver25-blinkon0,r-cr:hor20,o:hor50
    elseif g:spacevim_terminal_cursor_shape == 2
      " enable blinking mode-sensitive cursor
      set guicursor=n-v-c:block-blinkon10,i-ci-ve:ver25-blinkon10,r-cr:hor20,o:hor50
    endif
    set guicursor+=a:Cursor/lCursor
  endif
  filetype plugin indent on
  syntax on
endfunction


" return [status, dir]
" status: 0 : no argv
"         1 : dir
"         2 : default arguments
"
" argc() return number of files
" argv() return a list of files/directories
function! s:parser_argv() abort
  if exists('v:argv')
    " if use embed nvim
    " for exmaple: neovim-qt
    " or only run vim/neovim without argvs
    if len(v:argv) == 1
      return [0]
    elseif index(v:argv, '--embed') !=# -1 
      if  v:argv[-1] =~# '/$'
        let f = fnamemodify(expand(v:argv[-1]), ':p')
        if isdirectory(f)
          return [1, f]
        else
          return [1, getcwd()]
        endif
      elseif v:argv[-1] ==# '.'
        return [1, getcwd()]
      elseif isdirectory(expand(v:argv[-1]))
        return [1, fnamemodify(expand(v:argv[-1]), ':p')]
      elseif filereadable(v:argv[-1])
        return [2, get(v:, 'argv', ['failed to get v:argv'])]
      elseif v:argv[-1] != '--embed' && get(v:argv, -2, '') != '--cmd'
        return [2, v:argv[-1]]
      else
        return [0]
      endif
    elseif index(v:argv, '-d') !=# -1
      " this is  diff mode
      return [2, 'diff mode, use default arguments:' . string(v:argv)]
    elseif v:argv[-1] =~# '/$'
      let f = fnamemodify(expand(v:argv[-1]), ':p')
      if isdirectory(f)
        return [1, f]
      else
        return [1, getcwd()]
      endif
    elseif v:argv[-1] ==# '.'
      return [1, getcwd()]
    elseif isdirectory(expand(v:argv[-1]))
      return [1, fnamemodify(expand(v:argv[-1]), ':p')]
    else
      return [2, get(v:, 'argv', ['failed to get v:argv'])]
    endif
  else
    if !argc() && line2byte('$') == -1
      return [0]
    elseif argv()[0] =~# '/$'
      let f = fnamemodify(expand(argv()[0]), ':p')
      if isdirectory(f)
        return [1, f]
      else
        return [1, getcwd()]
      endif
    elseif argv()[0] ==# '.'
      return [1, getcwd()]
    elseif isdirectory(expand(argv()[0]))
      return [1, fnamemodify(expand(argv()[0]), ':p')]
    else
      return [2, string(argv())]
    endif
  endif
endfunction

function! SpaceVim#begin() abort


  "Use English for anything in vim
  try
    if s:SYSTEM.isWindows
      silent exec 'lan mes en_US.UTF-8'
    elseif s:SYSTEM.isOSX
      silent exec 'language en_US.UTF-8'
    else
      let s:uname = system('uname -s')
      if s:uname ==# "Darwin\n"
        " in mac-terminal
        silent exec 'language en_US.UTF-8'
      elseif s:uname ==# "SunOS\n"
        " in Sun-OS terminal
        silent exec 'lan en_US.UTF-8'
      elseif s:uname ==# "FreeBSD\n"
        " in FreeBSD terminal
        silent exec 'lan en_US.UTF-8'
      else
        " in linux-terminal
        silent exec 'lan en_US.UTF-8'
      endif
    endif
  catch /^Vim\%((\a\+)\)\=:E197/
    call SpaceVim#logger#error('Can not set language to en_US.utf8')
  catch /^Vim\%((\a\+)\)\=:E319/
    call SpaceVim#logger#error('Can not set language to en_US.utf8, language not implemented in this Vim build')
  endtry

  " try to set encoding to utf-8
  if s:SYSTEM.isWindows
    " Be nice and check for multi_byte even if the config requires
    " multi_byte support most of the time
    if has('multi_byte')
      " Windows cmd.exe still uses cp850. If Windows ever moved to
      " Powershell as the primary terminal, this would be utf-8
      if exists('&termencoding') && !has('nvim')
        set termencoding=cp850
      endif
      setglobal fileencoding=utf-8
      " Windows has traditionally used cp1252, so it's probably wise to
      " fallback into cp1252 instead of eg. iso-8859-15.
      " Newer Windows files might contain utf-8 or utf-16 LE so we might
      " want to try them first.
      set fileencodings=ucs-bom,utf-8,gbk,utf-16le,cp1252,iso-8859-15,cp936
    endif

  else
    if exists('&termencoding') && !has('nvim')
      set termencoding=utf-8
    endif
    set fileencoding=utf-8
    set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
  endif

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
    call SpaceVim#logger#info('Startup with argv: ' . string(s:status[0]) )
  endif
  if has('nvim-0.7')
    try
      " @fixme unknown font error
      lua require('spacevim.default').options()
    catch

    endtry
  else
    call SpaceVim#default#options()
  endif
  call SpaceVim#default#layers()
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
    if isdirectory(bufname(1)) && bufnr() !=# 1
      " startify will not change the buffer name
      " if you run `nvim test/`, the buffer name is `test/`.
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
    elseif exists(':NvimTreeOpen') == 2
      try
        " @fixme there are some errors
        NvimTreeOpen
      catch

      endtry
      " the statusline of nvimtree is not udpated when open nvim tree in
      " welcome function
      doautocmd WinEnter
      wincmd p
    elseif exists(':Neotree') == 2
      NeoTreeShow
    endif
  endif
endfunction

""
" @section Usage, usage
"   General guide for using SpaceVim. Including layer configuration, bootstrap
"   function.

""
" @section undo-tree, usage-undotree
" @parentsection usage
" Undo tree visualizes the undo history and makes it easier to browse and
" switch between different undo branches.The default key binding is `F7`.
" If `+python` or `+python3` is enabled, `vim-mundo` will be used,
" otherwise `undotree` will be used.
" 
" Key bindings within undo tree windows:
" >
"    key bindings     description
"    `G`              move bottom
"    `J`              move older write
"    `K`              move newer write
"    `N`              previous match
"    `P`              play to
"    `<2-LeftMouse>`  mouse click
"    `/`              search
"    `<CR>`           preview
"    `d`              diff
"    `<down>`         move older
"    `<up>`           move newer
"    `i`              toggle inline
"    `j`              move older
"    `k`              move newer
"    `n`              next match
"    `o`              preview
"    `p`              diff current buffer
"    `q`              quit
"    `r`              diff
"    `gg`             move top
"    `?`              toggle help
" <

""
" @section windows-and-tabs, usage-windows-and-tabs
" @parentsection usage
" @subsection Windows related key bindings
" Window manager key bindings can only be used in normal mode.
" The default leader `[WIN]` is `s`, you can change it via `windows_leader`
" option:
" >
"   [options]
"     windows_leader = "s"
" <
" The following key bindings can be used to manager vim windows and tabs.
" >
"     Key Bindings | Descriptions
"     ------------ | --------------------------------------------------
"     q            | Smart buffer close
"     WIN v        | :split
"     WIN V        | Split with previous buffer
"     WIN g        | :vsplit
"     WIN G        | Vertically split with previous buffer
"     WIN t        | Open new tab (:tabnew)
"     WIN o        | Close other windows (:only)
"     WIN x        | Remove buffer, leave blank window
"     WIN q        | Remove current buffer
"     WIN Q        | Close current buffer (:close)
"     Shift-Tab    | Switch to alternate window (switch back and forth)
" <

""
" @section search-and-replace, usage-search-and-replace
" @parentsection usage
" This section document how to find and replace text in SpaceVim.
"
" @subsection Searching with  an external tool
"
" SpaceVim can be interfaced with different searching tools like:
" 1. rg - ripgrep
" 2. ag - the silver searcher
" 3. pt - the platinum searcher
" 4. ack
" 5. grep
" The search commands in SpaceVim are organized under the `SPC s` prefix
" with the next key being the tool to use and the last key is the scope.
" For instance, `SPC s a b` will search in all opened buffers using `ag`.
" 
" If the `<scope>` is uppercase then the current word under the cursor
" is used as default input for the search.
" For instance, `SPC s a B` will search for the word under the cursor.
" 
" If the tool key is omitted then a default tool will be automatically
" selected for the search. This tool corresponds to the first tool found
" on the system from the list `search_tools`, the default order is
" `['rg', 'ag', 'pt', 'ack', 'grep', 'findstr', 'git']`.
" For instance `SPC s b` will search in the opened buffers using
" `pt` if `rg` and `ag` have not been found on the system.
" 
" The tool keys are:
" >
"     Tool     | Key
"     ---------|-----
"     ag       | a
"     grep     | g
"     git grep | G
"     ack      | k
"     rg       | r
"     pt       | t
" <
" The available scopes and corresponding keys are:
" >
"     Scope                      | Key
"     ---------------------------|-----
"     opened buffers             | b
"     buffer directory           | d
"     files in a given directory | f
"     current project            | p
" <
" Instead of using flygrep to search text. SpaceVim also provides a general
" async searcher. The key binding is `SPC s j`, an input promote will be
" opened. After inserting text and press enter. searching results will be
" displayed in quickfix window.

""
" @section buffers-and-files, usage-buffers-and-files
" @parentsection usage
" @subsection Buffers manipulation key bindings
" All buffers key bindings are start with `b` prefix:
" >
"   Key Bindings	Descriptions
"   SPC <Tab>	    switch to alternate buffer in the current window (switch back and forth)
"   SPC b .	      buffer transient state
"   SPC b b	      switch to a buffer (via denite/unite)
"   SPC b d	      kill the current buffer (does not delete the visited file)
"   SPC u SPC b d	kill the current buffer and window (does not delete the visited file) (TODO)
"   SPC b D	      kill a visible buffer using vim-choosewin
" <


""
" @section command-line-mode, usage-command-line-mode
" @parentsection usage
" After pressing `:`, you can switch to command line mode, here is a list
" of key bindings can be used in command line mode:
" >
"   Key bindings    Descriptions
"   Ctrl-a          move cursor to beginning
"   Ctrl-b          Move cursor backward in command line
"   Ctrl-f          Move cursor forward in command line
"   Ctrl-w          delete a whole word
"   Ctrl-u          remove all text before cursor
"   Ctrl-k          remove all text after cursor
"   Ctrl-c/Esc      cancel command line mode
"   Tab             next item in popup menu
"   Shift-Tab       previous item in popup menu
" <

""
" @section Development, dev
"
" SpaceVim is a joint effort of all contributors.
" We encourage you to participate in SpaceVim's development.
" We have some guidelines that we need all contributors to follow.


""
" @section commit-style-guide, dev-commit-style-guide
" @parentsection dev
" A git commit message consists a three distinct parts separated by black line.
" >
"   Type (scope): Subject
" 
"   body
"
"   footer
" <
" types:
"
" - `feat`: a new feature
" - `fix`: a bug fix
" - `change`: no backward compatible changes
" - `docs`: changes to documentation
" - `style`: formatting, missing semi colons, etc; no code change
" - `refactor`: refactoring production code
" - `test`: adding tests, refactoring test; no production code change
" - `chore`: updating build tasks, package manager configs, etc; no production code change
"
" scopes:
"
" - `api`: files in `autoload/SpaceVim/api/` and `docs/api/` directory
" - `layer`: files in `autoload/SpaceVim/layers/` and `docs/layers/` directory
" - `plugin`: files in `autoload/SpaceVim/plugins/` directory
" - `bundle`: files in `bundle/` directory
" - `core`: other files in this repository
"
" subject:
"
" Subjects should be no greater than 50 characters,
" should begin with a capital letter and do not end with a period.
"
" Use an imperative tone to describe what a commit does,
" rather than what it did. For example, use change; not changed or changes.
"
" body:
"
" Not all commits are complex enough to warrant a body,
" therefore it is optional and only used when a commit requires a bit of explanation and context.
"
" footer:
"
" The footer is optional and is used to reference issue tracker IDs.

""
" @section alternate file, usage-alternate-file
" @parentsection usage
" SpaceVim provides a built-in alternate file manager, the command is `:A`.
"
" To use this feature, you can create a `.project_alt.json` file in the root
" of your project. for example:
" >
"    {
"      "autoload/SpaceVim/layers/lang/*.vim" :
"          {
"             "doc" : "docs/layers/lang/{}.md"
"          },
"    }
" <
" after adding this configuration, when edit the source file 
" `autoload/SpaceVim/layers/lang/java.vim`,
" you can use `:A doc` switch to `docs/layers/lang/java.md`

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
" Following HEAD: changes in master branch since last release v2.0.0
"
" https://github.com/SpaceVim/SpaceVim/wiki/Following-HEAD
"
" 2022-07-02: v2.0.0
"
" https://spacevim.org/SpaceVim-release-v2.0.0/
"
" 2021-06-16: v1.9.0
"
" https://spacevim.org/SpaceVim-release-v1.9.0/
"
" 2021-06-16: v1.8.0
"
" https://spacevim.org/SpaceVim-release-v1.8.0/
"
" 2021-06-16: v1.7.0
"
" https://spacevim.org/SpaceVim-release-v1.7.0/
"
" 2020-12-31: v1.6.0
"
" https://spacevim.org/SpaceVim-release-v1.6.0/
"
" 2020-08-01: v1.5.0
"
" https://spacevim.org/SpaceVim-release-v1.5.0/
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
