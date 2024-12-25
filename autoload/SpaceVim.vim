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
" @order intro options config functions layers usage plugins api dev community faq roadmap changelog
" SpaceVim is a modular configuration of Vim and Neovim.
" It's inspired by spacemacs. It manages collections of plugins in layers,
" which help to collect related packages together to provide features.
" This approach helps keep the configuration organized and reduces
" overhead for the user by keeping them from having to think about
" what packages to install.

""
" @section Highlighted Features, features
" @parentsection intro
" 1. Modularization: Plugins are organized in @section(layers).
" 2. Compatible API: A series of @section(api) for Vim/Neovim.
" 3. Great documentation: Everything is documented in `:h SpaceVim`.
" 4. Better experience: Most of the core plugins have been rewritten using Lua.
" 5. Beautiful UI: The interface has been carefully designed.
" 6. Mnemonic key bindings: Key bindings are organized using mnemonic prefixes.
" 7. Lower the risk of RSI: Heavily using the `<Space>` key instead of modifiers.


""
" @section Update and Rollback, update-and-rollback
" @parentsection intro
" @subsection Update SpaceVim itself
" 
" There are several methods of updating the core files of SpaceVim.
" It is recommended to update the packages first; see the next section.
"
" 1. Automatic Updates
" 
" By default, this feature is disabled.
" It would slow down the startup of Vim/Neovim.
" If you like this feature,
" add the following to your custom configuration file.
" >
"   [options]
"     automatic_update = true
" <
" 
" SpaceVim will automatically check for a new version
" every startup. You have to restart Vim after updating.
" 
" 2. Updating from the SpaceVim Buffer
" 
" Users can use command `:SPUpdate SpaceVim` to update SpaceVim.
" This command will open a new buffer to show the process of updating.
" 
" 3. Updating Manually with git
" 
" For users who prefer to use the command line, they can use the following command
" in a terminal to update SpaceVim manually:
" >
"   git -C ~/.SpaceVim pull
" <
" 
" @subsection Update plugins
" 
" Use `:SPUpdate` command to update all the plugins and
" SpaceVim itself. After `:SPUpdate`, you can assign
" plugins need to be updated. Use `Tab` to complete
" plugin names after `:SPUpdate`.
" 
" @subsection Reinstall plugins
" 
" When a plugin has failed to update or is broken, Use the `:SPReinstall`
" command to reinstall the plugin. The plugin's name can be completed via the key binding `<Tab>`.
" 
" For example:
" >
"   :SPReinstall echodoc.vim
" <
" 
" @subsection Get SpaceVim log
" 
" The runtime log of SpaceVim can be obtained via the key binding `SPC h L`.
" To get the debug information about the current SpaceVim environment,
" Use the command `:SPDebugInfo!`. This command will open a new buffer where default information will be shown.
" You can also use `SPC h I` to open a buffer with SpaceVim's issue template.

""
" @section Options, options
" The very first time SpaceVim starts up, it will ask you to choose a mode,
" `basic mode` or `dark powered mode`. Then it will create a 
" `.SpaceVim.d/init.toml` file in your $HOME directory.
" All the user configuration files are stored in ~/.SpaceVim.d/ directory.
" 
" `~/.SpaceVim.d/` will also be added to |'runtimepath'|.
" 
" It is also possible to override the location of `~/.SpaceVim.d/` by
" using the environment variable `$SPACEVIMDIR`.
" Of course, symlinks can be used to change the location of this directory.
" 
" SpaceVim also supports project specific configuration files.
" The project configuration file is `.SpaceVim.d/init.toml` in the root of
" the project. The directory `{project root}/.SpaceVim.d/` will also be
" added to the |'runtimepath'|.
" 
" NOTE:Please be aware that if there are errors in your init.toml,
" all the setting in this toml file will not be applied.
" 
" All SpaceVim options can be found in @section(options), the option name is
" same as the old vim option, but with the `g:spacevim_` prefix removed. For example:
" >
"   g:spacevim_enable_statusline_tag -> enable_statusline_tag
" <
" If the fuzzy finder layer is loaded, users can use key binding `SPC h SPC`
" to fuzzy find the documentation of SpaceVim options.
" 
" @subsection Add custom plugins
" 
" If you want to add plugins from GitHub, just add the repo name to the custom_plugins section:
" >
"   [[custom_plugins]]
"     repo = 'lilydjwg/colorizer'
"     # `on_cmd` option means this plugin will be loaded
"     # only when the specific commands are called.
"     # for example, when `:ColorHighlight` or `:ColorToggle`
"     # commands are called.
"     on_cmd = ['ColorHighlight', 'ColorToggle']
"     # `on_func` option means this plugin will be loaded
"     # only when the specific functions are called.
"     # for example, when `colorizer#ColorToggle()` function is called.
"     on_func = 'colorizer#ColorToggle'
"     # `merged` option is used for merging plugins directory.
"     # When `merged` is `true`, all files in this custom plugin
"     # will be merged into `~/.cache/vimfiles/.cache/init.vim/`
"     # for neovim or `~/.cache/vimfiles/.cache/vimrc/` for vim.
"     merged = false
"     # For more options see `:h dein-options`.
" <
" You can also use the url of the repository, for example:
" >
"   [[custom_plugins]]
"     repo = "https://gitlab.com/code-stats/code-stats-vim.git"
"     merged = false
" <
" To add multiple custom plugins:
" >
"   [[custom_plugins]]
"     repo = 'lilydjwg/colorizer'
"     merged = false
" 
"   [[custom_plugins]]
"     repo = 'joshdick/onedark.vim'
"     merged = false
" <
" If you want to disable plugins which are added by SpaceVim,
" you can use the options: @section(options-disabled_plugins).
" >
"   [options]
"     # NOTE: the value should be a list, and each item is the name of the plugin.
"     disabled_plugins = ["clighter", "clighter8"]
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
let g:spacevim_version = '2.5.0-dev'

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
" @section if_ruby, options-if_ruby
" @parentsection options
" Neovim if_ruby provider is too slow, If you are sure that your nvim does not
" support ruby, set this option to false. default is true.

let g:spacevim_if_ruby = 1

""
" @section enable_list_mode, options-enable_list_mode
" @parentsection options
" Enable/Disable list mode, by default it is disabled.

""
" Enable/Disable list mode, by default it is disabled.
let g:spacevim_enable_list_mode        = 0

""
" @section lazy_conf_timeout, options-lazy_conf_timeout
" @parentsection options
" set the waiting time of lazy loading config in milliseconds. This will be
" applied to load layer config, and lazy plugin, and end function of SpaceVim.
" default is 300 ms.

let g:spacevim_lazy_conf_timeout = 200

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
if has('nvim-0.9.0')
  let g:spacevim_autocomplete_method = 'nvim-cmp'
elseif (has('python3') 
      \ && (SpaceVim#util#haspy3lib('neovim')
      \ || SpaceVim#util#haspy3lib('pynvim'))) &&
      \ (has('nvim') || (has('patch-8.0.0027')))

  ""
  " @section autocomplete_method, options-autocomplete_method
  " @parentsection options
  " Set the autocomplete engine of spacevim, the default logic is:
  " >
  "   if has('nvim-0.9.0')
  "     let g:spacevim_autocomplete_method = 'nvim-cmp'
  "   elseif has('python3')
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
  "   if has('nvim-0.9.0')
  "     let g:spacevim_autocomplete_method = 'nvim-cmp'
  "   elseif has('python3')
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
" you can also use:
" 1. defx
" 2. vimfiler
" 3. neo-tree
" 4: nvim-tree

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
" @section todo_close_list, options-close_list
" @parentsection options
" Option for setting todo windows behavior when open item in todo list.
" Default is `true`, set to `false` will not close todo windows.

""
" Option for setting todo windows behavior when open item in todo list.
" Default is 1, set to 0 will not close todo windows.
let g:spacevim_todo_close_list = 0

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
      \ 'SpaceVimTabsManager',
      \ 'SpaceVimGitRemoteManager'
      \ ]
let g:_spacevim_altmoveignoreft         = ['Tagbar' , 'vimfiler']
let g:_spacevim_mappings_space = {}
let g:_spacevim_mappings_prefixs = {}
let g:_spacevim_mappings_windows = {}
let g:_spacevim_statusline_fileformat = ''
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

function! s:lazy_end(...) abort

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
  exe 'set wildignore+=' . g:spacevim_wildignore
  " shell
  if has('filterpipe')
    set noshelltemp
  endif

endfunction

let g:_spacevim_mappings_prefixs['[SPC]'] = {'name' : '+SPC prefix'}
let g:_spacevim_mappings_space.t = {'name' : '+Toggles'}
let g:_spacevim_mappings_space.t.h = {'name' : '+Toggles highlight'}
let g:_spacevim_mappings_space.t.m = {'name' : '+modeline'}
let g:_spacevim_mappings_space.T = {'name' : '+UI toggles/themes'}
let g:_spacevim_mappings_space.a = {'name' : '+Applications'}
let g:_spacevim_mappings_space.b = {'name' : '+Buffers'}
let g:_spacevim_mappings_space.f = {'name' : '+Files'}
let g:_spacevim_mappings_space.j = {'name' : '+Jump/Join/Split'}
let g:_spacevim_mappings_space.m = {'name' : '+Major-mode'}
let g:_spacevim_mappings_space.w = {'name' : '+Windows'}
let g:_spacevim_mappings_space.p = {'name' : '+Projects/Packages'}
let g:_spacevim_mappings_space.h = {'name' : '+Help'}
let g:_spacevim_mappings_space.n = {'name' : '+Narrow/Numbers'}
let g:_spacevim_mappings_space.q = {'name' : '+Quit'}
let g:_spacevim_mappings_space.l = {'name' : '+Language Specified'}
let g:_spacevim_mappings_space.s = {'name' : '+Searching/Symbol'}
let g:_spacevim_mappings_space.r = {'name' : '+Registers/rings/resume'}
let g:_spacevim_mappings_space.d = {'name' : '+Debug'}
let g:_spacevim_mappings_space.F = {'name' : '+Tabs'}
let g:_spacevim_mappings_space.e = {'name' : '+Errors/Encoding'}
let g:_spacevim_mappings_space.B = {'name' : '+Global buffers'}
let g:_spacevim_mappings_space.f.v = {'name' : '+Vim/SpaceVim'}
let g:_spacevim_mappings_space.i = {'name' : '+Insertion'}
let g:_spacevim_mappings_space.i = {'name' : '+Insertion'}
let g:_spacevim_mappings_space.i.l = {'name' : '+Lorem-ipsum'}
let g:_spacevim_mappings_space.i.p = {'name' : '+Passwords/Picker'}
let g:_spacevim_mappings_space.i.U = {'name' : '+UUID'}

function! SpaceVim#end() abort
  let &tabline = ' '
  if has('timers')
    call timer_start(g:spacevim_lazy_conf_timeout, function('s:lazy_end'))
  else
    call s:lazy_end()
  endif

  if SpaceVim#layers#isLoaded('core#statusline')
    call SpaceVim#layers#core#statusline#init()
  endif

  call SpaceVim#plugins#load()

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
    call SpaceVim#logger#info('v:argv is:' . string(v:argv))
    " if use embed nvim
    " for exmaple: neovim-qt
    " or only run vim/neovim without argvs
    if len(v:argv) == 1 || (len(v:argv) == 2 && index(v:argv, '--embed') == 1)
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
      elseif v:argv[-1] == '-p' && v:argv[-2] == '--embed'
        return [0]
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
    elseif len(v:argv) == 3 && v:argv[-1] == 'VIM' && v:argv[-2] == '--servername'
      return [0]
    else
      return [2, get(v:, 'argv', ['failed to get v:argv'])]
    endif
  else
    call SpaceVim#logger#info(printf('argc is %s, argv is %s, line2byte is %s', string(argc()), string(argv()), string(line2byte('$'))))
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
  call SpaceVim#logger#info('startup status:' . string(s:status))
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
    if has('timers')
      call timer_start(500, function('s:open_filetree'))
    else
      call s:open_filetree()
    endif
  endif
endfunction

function! s:open_filetree(...) abort
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
" All buffer related key bindings are start with `SPC b`, and all files
" related key bindings are start with `SPC f`.
" @subsection Buffers manipulation key bindings
" 
" Buffer manipulation commands (start with `b`):
" >
"   Key Bindings       | Descriptions
"   -------------------| ------------------------------------------------
"   SPC <Tab>          | switch to alternate buffer in the current window
"   SPC b .            | buffer transient state
"   SPC b b            | switch to a buffer (need fuzzy finder layer)
"   SPC b d            | kill the current buffer
"   SPC b D            | kill a visible buffer using vim-choosewin
"   SPC b Ctrl-d       | kill other buffers
"   SPC b Ctrl-Shift-d | kill buffers using a regular expression
"   SPC b e            | erase the content of the buffer (ask for confirmation)
"   SPC b n            | switch to next buffer avoiding special buffers
"   SPC b m            | open Messages buffer
"   SPC b o            | kill all saved buffers and windows
"   SPC b p            | switch to previous buffer avoiding special buffers
"   SPC b P            | copy clipboard and replace buffer
"   SPC b R            | revert the current buffer (reload from disk)
"   SPC b s            | switch to the scratch buffer (create it if needed)
"   SPC b w            | toggle read-only (writable state)
"   SPC b Y            | copy whole buffer to clipboard
" <
" 
" @subsection Create a new empty buffer
"
" The following key bindings can be used to create new buffer.
" >
"   Key Bindings | Descriptions
"   ------------ | -----------------------------------------------------
"   SPC b N h    | create new empty buffer in a new window on the left
"   SPC b N j    | create new empty buffer in a new window at the bottom
"   SPC b N k    | create new empty buffer in a new window above
"   SPC b N l    | create new empty buffer in a new window below
"   SPC b N n    | create new empty buffer in current window
" <
" @subsection Special Buffers
" 
" Buffers created by plugins are not normal files, and they will not be listed
" on tabline. And also will not be listed by `SPC b b` key binding in fuzzy finder
" layer.
" 
" @subsection File manipulation key bindings
" 
" Files manipulation commands (start with `f`):
" >
"   Key Bindings | Descriptions
"   ------------ | ---------------------------------------------------------
"    SPC f /     | Find files with find or fd command
"    SPC f b     | go to file bookmarks
"    SPC f C d   | convert file from unix to dos encoding
"    SPC f C u   | convert file from dos to unix encoding
"    SPC f D     | delete a file and the associated buffer with confirmation
"    SPC f W     | save a file with elevated privileges (sudo layer)
"    SPC f f     | fuzzy find files in buffer directory
"    SPC f F     | fuzzy find cursor file in buffer directory
"    SPC f o     | Find current file in file tree
"    SPC f R     | rename the current file
"    SPC f s     | save a file
"    SPC f a     | save as new file name
"    SPC f S     | save all files
"    SPC f r     | open a recent file
"    SPC f t     | toggle file tree side bar
"    SPC f T     | show file tree side bar
"    SPC f d     | toggle disk manager in Windows OS
"    SPC f y     | show and copy current file absolute path in the cmdline
"    SPC f Y     | show and copy remote url of current file
" <
" NOTE: If you are using Windows, you need to install
" findutils(https://www.gnu.org/software/findutils/) or
" fd(https://github.com/sharkdp/fd).
" If you are using scoop(https://github.com/lukesampson/scoop) to install
" packages, commands in `C:\WINDOWS\system32` will override the User `PATH`,
" so you need to put the scoop binary path before `C:\WINDOWS\system32` in `PATH`.
" 
" After pressing `SPC f /`, the find window will be opened.
" It is going to run `find` or `fd` command asynchronously.
" By default, `find` is the default tool, you can use `ctrl-e` to switch tools.
" 
" To change the default file searching tool, you can use
" `file_searching_tools` in the `[options]` section.
" It is `[]` by default.
" >
"   [options]
"     file_searching_tools = ['find', 'find -not -iwholename "*.git*" ']
" <
" 
" The first item is the name of the tool, the second one is the default searching command.
" 
" @subsection Vim and SpaceVim files
" 
" Convenient key bindings are located under the prefix `SPC f v` to quickly
" navigate between Vim and SpaceVim specific files.
" >
"   Key Bindings | Descriptions
"   ------------ | ------------------------------------------------
"    SPC f v v   | display and copy SpaceVim version
"    SPC f v d   | open SpaceVim custom configuration file
"    SPC f v s   | list all loaded vim scripts, like  :scriptnames
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
" @section License, dev-license
" @parentsection dev
" The license is GPLv3 for all the parts of SpaceVim. This includes:
" 1. The initialization and core files.
" 2. All the layer files.
" 3. The documentation
"
" For files not belonging to SpaceVim like bundle packages,
" refer to the header file. Those files should not have an empty header,
" we may not accept code without a proper header file.

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
" @section merge requese, dev-merge-request
" @parentsection dev
" 
" @subsection Steps
"
" The following steps describe how to create a new merge request using mail.
" 
" 1. create new empty repository on github，gitlab or any other platform.
" 2. clone your repository 
" >
"   git clone ${YOUR_OWN_REPOSITORY_URL}
" <
" 3. add upstream remote
" >
"   git remote add upstream https://spacevim.org/git/repos/SpaceVim/
" <
" 4. create new branch based on `upstream/master`
" >
"   git fetch upstream
"   git checkout -b new_branch upstream/master
" <
" 5. edit, commit and push to your own repository
" >
"   git push -u origin
" <
" 6. send merge request to mail list.
"   
"     email address: `spacevim@googlegroups.com`
"     
"     email title:
" 
"     The title of the email should contain one of the following prefixes::
" 
"     `Add:` Adding new features.
"
"     `Change:` Change default behaviors or the existing features.
"
"     `Fix:` Fix some bugs.
"
"     `Remove:` Remove some existing features.
"
"     `Doc:` Update the help files.
"
"     `Website:` Update the content of website.
" 
"     Here is an example:
" 
"     `Website: Update the lang#c layer page.`
" 
"     Email context:
" 
"     The context should contain the url of repository and the branch name.
"
"     It is better to add some description about the changes. For example:
"     >
"     repo url: https://gitlab.com/wsdjeg/hello.git
"     branch: fix_scrollbar
" 
"     when switch windows, the highlight of scrollbar is wrong.
"     here is the reproduce steps:
" 
"     。。。。
"     <
" 
" @subsection Simple PRs
" 
" 1. Branch from `master`
" 2. One topic per PR
" 3. One commit per PR
" 4. If you have several commits on different topics, close the PR and create one PR per topic
" 5. If you still have several commits, squash them into only one commit
" 
" @subsection Complex PRs
" 
" Squash only the commits with uninteresting changes like typos, syntax fixes, etc.
" And keep the important and isolated steps in different commits.
" 
" Those PRs are merged and explicitly not fast-forwarded.

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
" @section Toggle UI, usage-toggle-ui
" @parentsection usage
" Some UI indicators can be toggled on and off (toggles start with t and T):
" >
"   Key Bindings      | Descriptions
"   ----------------- | -----------------------------------------
"    SPC t 8          | highlight characters past the 80th column
"    SPC t a          | toggle autocomplete 
"    SPC t f          | display the fill column 
"    SPC t h h        | toggle highlight of the current line
"    SPC t h i        | toggle highlight indentation levels
"    SPC t h c        | toggle highlight current column
"    SPC t h s        | toggle syntax highlighting
"    SPC t i          | toggle indentation guide at point
"    SPC t n          | toggle line numbers
"    SPC t b          | toggle background
"    SPC t c          | toggle conceal
"    SPC t p          | toggle paste mode
"    SPC t P          | toggle auto parens mode
"    SPC t t          | open tabs manager
"    SPC T ~          | display ~ in the fringe on empty lines
"    SPC T F  /  F11  | toggle frame fullscreen
"    SPC T f          | toggle display of the fringe
"    SPC T m          | toggle menu bar
"    SPC T t          | toggle tool bar
" <

""
" @section Error handling, usage-error-handling
" @parentsection usage
" The @section(layers-checkers) and @section(layers-lsp) provide error
" handling features. The checkers layer uses
" neomake(https://github.com/neomake/neomake) by default.
" The syntax checking is only performed at save time by default.
" 
" Error management mappings (start with e):
" >
"   Mappings  | Descriptions
"   --------- | --------------------------------------------------
"    SPC t s  | toggle syntax checker
"    SPC e c  | clear all errors
"    SPC e h  | describe a syntax checker
"    SPC e l  | toggle the display of the list of errors/warnings
"    SPC e n  | go to the next error
"    SPC e p  | go to the previous error
"    SPC e v  | verify syntax checker setup 
"    SPC e .  | error transient state
" <
" The next/previous error mappings and the error transient state can be used
" to browse errors from syntax checkers as well as errors from location list
" buffers, and indeed anything that supports Vim's location list. This
" includes for example search results that have been saved to a location
" list buffer.
" 
" Custom sign symbol:
" >
"   Symbol | Descriptions | Custom options
"   ------ | ------------ | ----------------
"    ✖     | Error        |  error_symbol
"    ➤     | warning      |  warning_symbol
"    ⓘ     | Info         |  info_symbol
" <
" @subsection quickfix list navigation
" >
"   Mappings       | Descriptions
"   -------------- | --------------------------------------
"    <Leader> q l  | Open quickfix list window
"    <Leader> q c  | clear quickfix list
"    <Leader> q n  | jump to next item in quickfix list
"    <Leader> q p  | jump to previous item in quickfix list
" <

""
" @section Editing, usage-editing
" @parentsection usage
"
" @subsection Moving text
" >
"   Key               | Action
"   ----------------- | -----------------------------
"    >  /  Tab        | Indent to right and re-select
"    <  /  Shift-Tab  | Indent to left and re-select
"    Ctrl-Shift-Up    | move lines up
"    Ctrl-Shift-Down  | move lines down
" <
" @subsection Code indentation
" 
" The default indentation of code is 2, which is controlled by the option
" @section(options-default_indent).
" If you prefer to use 4 as code indentation. Just add the following snippet
" to the `[options]` section in the SpaceVim's configuration file:
" >
"   [options]
"     default_indent = 4
" <
" The `default_indent` option will be applied to vim's `&tabstop`,
" `&softtabstop` and `&shiftwidth` options. By default, when the user inserts
" a `<Tab>`, it will be expanded to spaces. This feature can be disabled by
" `expand_tab` option the `[options]` section:
" >
"   [options]
"     default_indent = 4
"     expand_tab = true
" <
" @subsection Text manipulation commands
" 
" Text related commands (start with `x`):
" >
"   Key Bindings     | Descriptions
"   ---------------- | -------------------------------------------------------
"    SPC x a #       | align region at #
"    SPC x a %       | align region at %
"    SPC x a &       | align region at &
"    SPC x a (       | align region at (
"    SPC x a )       | align region at )
"    SPC x a [       | align region at [
"    SPC x a ]       | align region at ]
"    SPC x a {       | align region at {
"    SPC x a }       | align region at }
"    SPC x a ,       | align region at ,
"    SPC x a .       | align region at . (for numeric tables)
"    SPC x a :       | align region at :
"    SPC x a ;       | align region at ;
"    SPC x a =       | align region at =
"    SPC x a ¦       | align region at ¦
"    SPC x a <Bar>   | align region at \|
"    SPC x a SPC     | align region at [SPC]
"    SPC x a r       | align region at user-specified regexp
"    SPC x a o       | align region at operators  +-*/  etc
"    SPC x c         | count the number of chars/words/lines in the region
"    SPC x d w       | delete trailing whitespace
"    SPC x d SPC     | Delete all spaces and tabs around point
"    SPC x g t       | translate current word using Google Translate
"    SPC x i c       | change symbol style to  lowerCamelCase
"    SPC x i C       | change symbol style to  UpperCamelCase
"    SPC x i i       | cycle symbol naming styles (i to keep cycling)
"    SPC x i -       | change symbol style to  kebab-case
"    SPC x i k       | change symbol style to  kebab-case
"    SPC x i _       | change symbol style to  under_score
"    SPC x i u       | change symbol style to  under_score
"    SPC x i U       | change symbol style to  UP_CASE
"    SPC x j c       | set the justification to center
"    SPC x j l       | set the justification to left
"    SPC x j r       | set the justification to right
"    SPC x J         | move down a line of text (enter transient state)
"    SPC x K         | move up a line of text (enter transient state)
"    SPC x l d       | duplicate a line or region
"    SPC x l r       | reverse lines
"    SPC x l s       | sort lines (ignorecase)
"    SPC x l S       | sort lines (case-senstive)
"    SPC x l u       | uniquify lines (ignorecase)
"    SPC x l U       | uniquify lines (case-senstive)
"    SPC x t c       | swap (transpose) the current character with previous one
"    SPC x t C       | swap (transpose) the current character with next one
"    SPC x t w       | swap (transpose) the current word with previous one
"    SPC x t W       | swap (transpose) the current word with next one
"    SPC x t l       | swap (transpose) the current line with previous one
"    SPC x t L       | swap (transpose) the current line with next one
"    SPC x u         | lowercase text
"    SPC x U         | uppercase text
"    SPC x ~         | toggle case text
"    SPC x w c       | count the words in the select region
" <
" @subsection Text insertion commands
" 
" Text insertion commands (start with `i`):
" >
"   Key bindings | Descriptions
"   ------------ | ---------------------------------------------------------------------
"    SPC i l l   | insert lorem-ipsum list
"    SPC i l p   | insert lorem-ipsum paragraph
"    SPC i l s   | insert lorem-ipsum sentence
"    SPC i p 1   | insert simple password
"    SPC i p 2   | insert stronger password
"    SPC i p 3   | insert password for paranoids
"    SPC i p p   | insert a phonetically easy password
"    SPC i p n   | insert a numerical password
"    SPC i u     | Search for Unicode characters and insert them into the active buffer.
"    SPC i U 1   | insert UUIDv1 (use universal argument to insert with CID format)
"    SPC i U 4   | insert UUIDv4 (use universal argument to insert with CID format)
"    SPC i U U   | insert UUIDv4 (use universal argument to insert with CID format)
" >
" NOTE: You can specify the number of password characters using a prefix
" argument (i.e. `10 SPC i p 1` will generate a 10 character simple password).
" 
" @subsection Expand regions of text
" 
" Key bindings available in visual mode:
" >
"   Key bindings | Descriptions
"   ------------ | -------------------------------------------------
"    v           | expand visual selection of text to larger region
"    V           | shrink visual selection of text to smaller region
" <
" @subsection Increase/Decrease numbers
" >
"   Key Bindings | Descriptions
"   ------------ | ------------------------------------------------
"    SPC n +     | increase the number and initiate transient state
"    SPC n -     | decrease the number and initiate transient state
" <
" In transient state:
" >
"   Key Bindings  | Descriptions
"   ------------- | -------------------------------------------
"    +            | increase the number under the cursor by one
"    -            | decrease the number under the cursor by one
"   Any other key | leave the transient state
" <
" Tip: You can set the step (1 by default) by using a prefix argument
" (i.e. `10 SPC n +` will add 10 to the number under the cursor).
" 
" @subsection Copy and paste
" 
" If `has('unnamedplus')`, the register used by `<Leader> y` is `+`,
" otherwise it is `*`. Read `:h registers` for more info about other registers.
" >
"   Key          | Descriptions
"   ------------ | --------------------------------------------
"    <Leader> y  | Copy selected text to system clipboard
"    <Leader> p  | Paste text from system clipboard after here
"    <Leader> P  | Paste text from system clipboard before here
"    <Leader> Y  | Copy selected text to pastebin
" <
" To change the command of clipboard, you need to use bootstrap after function:
" >
"   " for example, to use tmux clipboard:
"   function! myspacevim#after() abort
"     call clipboard#set('tmux load-buffer -', 'tmux save-buffer -')
"   endfunction
" <
" 
" within the runtime log (`SPC h L`), the clipboard command will be displayed:
" 
" >
"   [ clipboard ] [11:00:35] [670.246] [ Info  ] yank_cmd is:'tmux load-buffer -'
"   [ clipboard ] [11:00:35] [670.246] [ Info  ] paste_cmd is:'tmux save-buffer -'
" >
" 
" The `<Leader> Y` key binding will copy selected text to a pastebin server.
" It requires `curl` in your `$PATH`. The default command is:
" >
"   curl -s -F "content=<-" http://dpaste.com/api/v2/
" <
" This command will read stdin and copy it to dpaste server. It is same as:
" >
"   echo "selected text" | curl -s -F "content=<-" http://dpaste.com/api/v2/
" <
" 
" @subsection Commenting
" 
" Comments are handled by nerdcommenter, it’s bound to the following keys.
" >
"   Key Bindings | Descriptions
"   ------------ | -------------------------------------------------------
"    SPC ;       | comment operator
"    SPC c a     | switch to the alternative set of delimiters
"    SPC c h     | hide/show comments
"    SPC c l     | toggle line comments
"    SPC c L     | comment lines
"    SPC c u     | uncomment lines
"    SPC c p     | toggle paragraph comments
"    SPC c P     | comment paragraphs
"    SPC c s     | comment with pretty layout
"    SPC c t     | toggle comment on line
"    SPC c T     | comment the line under the cursor
"    SPC c y     | toggle comment and yank
"    SPC c Y     | yank and comment
"    SPC c $     | comment current line from cursor to the end of the line
" <
" Tip: `SPC ;` will start operator mode, in this mode, you can use a motion 
" command to comment lines. For example, `SPC ; 4 j` will comment the current
" line and the following 4 lines.
" 
" @subsection Undo tree
" 
" Undo tree visualizes the undo history and makes it easier to browse
" and switch between different undo branches. The default key binding is `F7`.
" If `+python` or `+python3` is enabled, mundo will be loaded,
" otherwise undotree will be loaded.
" 
" Key bindings within undo tree windows:
" >
"   key bindings    | description
"   --------------- | -------------------
"    G              | move bottom
"    J              | move older write
"    K              | move newer write
"    N              | previous match
"    P              | play to
"    <2-LeftMouse>  | mouse click
"    /              | search
"    <CR>           | preview
"    d              | diff
"    <down>         | move older
"    <up>           | move newer
"    i              | toggle inline
"    j              | move older
"    k              | move newer
"    n              | next match
"    o              | preview
"    p              | diff current buffer
"    q              | quit
"    r              | diff
"    gg             | move top
"    ?              | toggle help
" <
" @subsection Multi-Encodings
" 
" SpaceVim uses utf-8 as the default encoding. There are four options for this:
" 
" 1. fileencodings (fencs): ucs-bom,utf-8,default,latin1
" 2. fileencoding (fenc): utf-8
" 3. encoding (enc): utf-8
" 4. termencoding (tenc): utf-8 (only supported in Vim)
" 
" To fix a messy display: `SPC e a` is the mapping to auto detect the file
" encoding. After detecting the file encoding, you can run the command below
" to fix it:
" >
"   set enc=utf-8
"   write
" <

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
" @section Community, community
"
" @subsection News
" 
" The news about spacevim will be post on twitter, feel free to follow them:
" 
" https://x.com/SpaceVim
" 
" @subsection Asking for help
" 
" If you have any questions about using SpaceVim, check out the following context first, which may contain the answers:
" 
" @section(faq): Some of the most frequently asked questions are answered there.
" @section(usage): It is the general documentation of SpaceVim.
" 
" @subsection Feedback
" 
" If you run into a bug, or want a new feature, please use the mail list:
" 
" send email to spacevim@googlegroups.com
" 
" To subscribe the maillist, send anything to：spacevim+subscribe@googlegroups.com

""
" @section Roadmap, roadmap
" The roadmap defines the project direction and priorities. If you have any
" suggestions , please checkout @section(community).
" 
" @subsection To-Do List
" 
" - [x] rewrite statusline plugin with lua
" - [x] rewrite tabline plugin with lua
" - [ ] merge website context into :h SpaceVim
" 
" @subsection Completed
" 
" All completed functions can be found in @section(changelog)


""
" @section Changelog, changelog
" Following HEAD: changes in master branch since last release v2.2.0
"
" https://spacevim.org/following-head/
"
" 2024-03-24: v2.3.0
"
" https://spacevim.org/SpaceVim-release-v2.3.0/
"
" 2023-07-05: v2.2.0
"
" https://spacevim.org/SpaceVim-release-v2.2.0/
"
" 2023-03-30: v2.1.0
"
" https://spacevim.org/SpaceVim-release-v2.1.0/
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

" vim:set et sw=2 cc=80:
