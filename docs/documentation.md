---
title:  "Documentation"
---

# SpaceVim Documentation

- [Core Pillars](#core-pillars)
    - [Mnemonic](#mnemonic)
    - [Discoverable](#discoverable)
    - [Consistent](#consistent)
    - [Crowd-Configured](#crowd-configured)
- [Highlighted features](#highlighted-features)
- [Screenshots](#screenshots)
- [Who can benefit from this?](#who-can-benefit-from-this)
- [Update and Rollback](#update-and-rollback)
    - [Update SpaceVim itself](#update-spacevim-itself)
        - [Automatic Updates](#automatic-updates)
        - [Updating from the SpaceVim Buffer](#updating-from-the-spacevim-buffer)
        - [Updating Manually with git](#updating-manually-with-git)
    - [Update plugins](#update-plugins)
- [Custom Configuration](#custom-configuration)
    - [Automatic Generation](#automatic-generation)
    - [Alternative directory](#alternative-directory)
    - [Synchronization of dotfile changes](#synchronization-of-dotfile-changes)
    - [Dotfile Contents](#dotfile-contents)
        - [Configuration functions](#configuration-functions)
        - [Custom variables](#custom-variables)
    - [Declaring Configuration layers](#declaring-configuration-layers)
        - [Setting configuration layers variables](#setting-configuration-layers-variables)
        - [Disabling layer services in other layers](#disabling-layer-services-in-other-layers)
        - [Selecting/Ignoring packages of a layer](#selectingignoring-packages-of-a-layer)
        - [Excluding packages](#excluding-packages)
- [Awesome ui](#awesome-ui)
    - [Colorscheme](#colorscheme)
    - [Font](#font)
    - [UI Toggles](#ui-toggles)
    - [statusline](#statusline)
- Features
    - [Modular configuration](#modular-configuration)
    - [Awesome ui](#awesome-ui)
    - [Mnemonic key bindings](#mnemonic-key-bindings)
    - [Neovim centric - Dark powered mode](#neovim-centric---dark-powered-mode-of-spacevim)
    - [Language specific mode](#language-specific-mode)
    - [Unite centric work-flow](#unite-centric-work-flow)
    - [multiple leader mode](#multiple-leader-mode)
- [Custom configuration](#custom-configuration)
- [Layers](https://spacevim.org/layers)
- [APIs](#apis)

## Core Pillars

Four core pillars: Mnemonic, Discoverable, Consistent and “Crowd-Configured”.

If any of these core pillars is violated open an issue and we’ll try our best to fix it.

### Mnemonic

Key bindings are organized using mnemonic prefixes like b for buffer, p for project, s for search, h for help, etc…

### Discoverable

Innovative real-time display of available key bindings. Simple query system to quickly find available layers, packages, and more.

### Consistent

Similar functionalities have the same key binding everywhere thanks to a clearly defined set of conventions. Documentation is mandatory for any layer that ships with Spacemacs.

### Crowd-Configured

Community-driven configuration provides curated packages tuned by power users and bugs are fixed quickly.

## Highlighted features

- **Great documentation:** access documentation in Vim with
    <kbd>:h SpaceVim</kbd>.
- **Beautiful GUI:** you'll love the awesome UI and its useful features.
- **Mnemonic key bindings:** commands have mnemonic prefixes like
    <kbd>[Window]</kbd> for all the window and buffer commands or <kbd>[Unite]</kbd> for the
    unite work flow commands.
- **Lazy load plugins:** Lazy-load 90% of plugins with [dein.vim]
- **Batteries included:** discover hundreds of ready-to-use packages nicely
    organised in configuration layers following a set of
    [conventions](http://spacevim.org/development/).
- **Neovim centric:** Dark powered mode of SpaceVim

## Screenshots

### welcome page

![2017-04-29-20 54 49](https://cloud.githubusercontent.com/assets/13142418/25555650/d7d2c07e-2d1e-11e7-975d-646a07b38a62.png)

### working flow

![screen shot 2017-04-26 at 4 28 07 pm](https://cloud.githubusercontent.com/assets/296716/25455341/6af0b728-2a9d-11e7-9721-d2a694dde1a8.png)

Neovim on iTerm2 using the SpaceVim color scheme _base16-solarized-dark_

Depicts a common frontend development scenario with JavaScript (jQuery), SASS, and PHP buffers.

Non-code buffers show a Neovim terminal, a TagBar window, a Vimfiler window and a TernJS definition window.

to get more screenshots, see: [issue #415](https://github.com/SpaceVim/SpaceVim/issues/415)

## Who can benefit from this?

- the **elementary** vim users.
- Vim users pursuing a beautiful appearance.
- Vim users wanting to lower the [risk of RSI](http://en.wikipedia.org/wiki/Repetitive_strain_injury).
- Vim users wanting to learn a different way to edit files.
- Vim users wanting a simple but deep configuration system.

## Update and Rollback

### Update SpaceVim itself

There are several methods of updating the core files of SpaceVim. It is recommended to update the packages first; see the next section.

#### Automatic Updates

NOTE: By default, this feature is disabled, It will slow down the startup of vim/neovim. If you like this feature, add `let g:spacevim_automatic_update = 1` to your custom configuration file.

SpaceVim will automatically check for a new version every startup. You must restart Vim after updating.

#### Updating from the SpaceVim Buffer

Use `:SPUpdate SpaceVim` in SpaceVim buffer, This command will open a buffer to show the process of updating.

#### Updating Manually with git

To update manually close Vim and update the git repository:

`git -C ~/.SpaceVim pull`.

### Update plugins

Use `:SPUpdate` command will update all the plugins and SpaceVim itself. after `:SPUpdate`, you can assign plugins need to be updated. Use <kbd>Tab</kbd> to complete plugin names after `:SPUpdate`.

## Configuration layers

This section is an overview of layers. A more extensive introduction to writing configuration layers can be found in [SpaceVim's layers page](http://spacevim.org/layers/) (recommended reading!).

## Custom Configuration

User configuration can be stored in your ~/.SpaceVim.d directory.

### Automatic Generation

The very first time SpaceVim starts up, it will ask you several questions and then create the `SpaceVim.d/init.vim` in your `HOME` directory.

### Alternative directory

`~/.SpaceVim.d/` will be added to `&runtimepath` of vim. read <kbd>:h rtp</kbd>.

It is also possible to override the location of `~/.SpaceVim.d/` using the environment variable `SPACEVIMDIR`. Of course you can also use symlinks to change the location of this directory.

SpaceVim also support local config file for project, the init file is `.SpaceVim.d/init.vim`
in the root of your project. `.SpaceVim.d/` will also be added into runtimepath.

here is an example config file for SpaceVim:

```vim
" Here are some basic customizations, please refer to the ~/.SpaceVim.d/init.vim
" file for all possible options:
let g:spacevim_default_indent = 3
let g:spacevim_max_column     = 80

" Change the default directory where all miscellaneous persistent files go.
" By default it is ~/.cache/vimfiles.
let g:spacevim_plugin_bundle_dir = '~/.cache/vimfiles'

" set SpaceVim colorscheme
let g:spacevim_colorscheme = 'jellybeans'

" Set plugin manager, you want to use, default is dein.vim
let g:spacevim_plugin_manager = 'dein'  " neobundle or dein or vim-plug

" use space as `<Leader>`
let mapleader = "\<space>"

" Set windows shortcut leader [Window], default is `s`
let g:spacevim_windows_leader = 's'

" Set unite work flow shortcut leader [Unite], default is `f`
let g:spacevim_unite_leader = 'f'

" By default, language specific plugins are not loaded. This can be changed
" with the following, then the plugins for go development will be loaded.
call SpaceVim#layers#load('lang#go')

" loaded ui layer
call SpaceVim#layers#load('ui')

" If there is a particular plugin you don't like, you can define this
" variable to disable them entirely:
let g:spacevim_disabled_plugins=[
    \ ['junegunn/fzf.vim'],
    \ ]

" If you want to add some custom plugins, use these options:
let g:spacevim_custom_plugins = [
    \ ['plasticboy/vim-markdown', {'on_ft' : 'markdown'}],
    \ ['wsdjeg/GitHub.vim'],
    \ ]

" set the guifont
let g:spacevim_guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
```

Comprehensive documentation is available for each layer by <kbd>:h SpaceVim</kbd>.

## Awesome ui

SpaceVim has a minimalistic and distraction free UI:

- custom airline with color feedback according to current check status
- custom icon in sign column and error feedbacks for checker.

### Colorschemes

The default colorscheme of SpaceVim is [gruvbox](https://github.com/morhetz/gruvbox). There are two variants of this colorscheme, a dark one and a light one. Some aspects of these colorscheme can be customized in the custom configuration file, read <kbd>:h gruvbox</kbd>.

It is possible to define your default themes in your `~/.SpaceVim.d/init.vim` with the variable colorschemes. For instance, to specify [vim-one with dark colorscheme](https://github.com/rakr/vim-one):

```vim
let g:spacevim_colorscheme = 'one'
let g:spacevim_colorscheme_bg = 'dark'
```

Mappings	| Description
------------- | ----------------------
<kbd>SPC T n</kbd> | switch to next random colorscheme listed in colorscheme layer.
<kbd>SPC T s</kbd> | select a theme using a unite buffer.

all the included colorscheme can be found in [colorscheme layer](http://spacevim.org/layers/colorscheme/).

**NOTE**:

SpaceVim use true colors by default, so you should make sure your terminal support true colors. for more information see: [Colours in terminal](https://gist.github.com/XVilka/8346728)

### Font

The default font used by SpaceVim is DejaVu Sans Mono for Powerline. It is recommended to install it on your system if you wish to use it.

To change the default font set the variable `g:spacevim_guifont` in your `~/.SpaceVim.d/init.vim` file. By default its value is:

```vim
let g:spacevim_guifont = 'DejaVu\ Sans\ Mono\ for\ Powerline\ 11'
```

If the specified font is not found, the fallback one will be used (depends on your system). Also note that changing this value has no effect if you are running Vim/Neovim in terminal.

### UI Toggles

Some UI indicators can be toggled on and off (toggles start with t and T):

Key Binding	| Description
----------- | -----------
SPC t 8	| highlight any character past the 80th column
SPC t f	| display the fill column (by default the fill column is set to 80)
SPC t h h	| toggle highlight of the current line
SPC t h i	| toggle highlight indentation levels
SPC t h c	| toggle highlight indentation current column
SPC t h s	| toggle syntax highlighting
SPC t i	| toggle indentation guide at point
SPC t n	| toggle line numbers
SPC T ~	| display ~ in the fringe on empty lines
SPC T F	| toggle frame fullscreen
SPC T f	| toggle display of the fringe
SPC T m	| toggle menu bar
SPC T t	| toggle tool bar

### Statusline && tabline

The statusline and tabline is a heavily customized [airline](https://github.com/vim-airline/vim-airline) with the following capabilities:

- tabline index of each buffer or tab.
- vim mode (INSERT/NORMAL etc.)
- git info : diff/branch
- checker info: numbers of errors and warnings.
- trailing line number.

Key Binding | Description
----------- | -----------
`SPC [1-9]` | jump to the index of tabline.


## Manual

### Discovering

#### Mappings

##### Mappings guide

A guide buffer is displayed each time the prefix key is pressed in normal mode. It lists the available key bindings and their short description.
The prefix can be `[SPC]`, `[Window]`, `[denite]`, `<leader>` and `[unite]`.

The default key of these prefix is:

Prefix name | custom option and default value        | description
----------- | -------------------------------------- | -----------
`[SPC]`     | NONE / `<Space>`                       | default mapping prefix of SpaceVim
`[Window]`  | `g:spacevim_windows_leader` / `s`      | window mapping prefix of SpaceVim
`[denite]`  | `g:spacevim_denite_leader` / `F`       | denite mapping prefix of SpaceVim
`[unite]`   | `g:spacevim_unite_leader` / `f`        | unite mapping prefix of SpaceVim
`<leader>`  | `mapleader` / ``\``                    | default leader prefix of vim/neovim

By default the guide buffer will be displayed 1000ms after the key has been pressed. You can change the delay by setting `'timeoutlen'` option to your liking (the value is in milliseconds). 

for example, after pressing `<Space>` in normal mode, you will see :

![2017-05-07_1365x157](https://cloud.githubusercontent.com/assets/13142418/25778673/ae8c3168-3337-11e7-8536-ee78d59e5a9c.png)

this guide show you all the available key bindings begin with `[SPC]`, you can type `b` for all the buffer mappings, `p` for project mappings, etc. after pressing `<C-h>` in guide buffer, you will get paging and help info in the statusline.

key | description
---- | -----
`u` | undo pressing
`n` | next page of guide buffer
`p` | previous page of guide buffer


##### Unide/Denite describe key bindings

It is possible to search for specific key bindings by pressing `?` in the root of guide buffer.

To narrow the list, just insert the mapping keys or description of what mapping you want, Unite/Denite will fuzzy find the mappings, to find buffer related mappings:

![2017-05-07_1363x365](https://cloud.githubusercontent.com/assets/13142418/25779196/2f370b0a-3345-11e7-977c-a2377d23286e.png)

then use `<Tab>` or `<Up>` and `<Down>` to select the mapping, press `<Enter>` will execute that command.

#### Getting help

Denite/Unite is powerful tool to  unite all interfaces. it was meant to be like [Helm](https://github.com/emacs-helm/helm) for Vim. These mappings is for getting help info about functions, variables etc:

Mappings |	Description
--------- | --------------
SPC h d b	describe bindings in a helm buffer
SPC h d c	describe current character under point
SPC h d d	describe current expression under point
SPC h d f	describe a function
SPC h d F	describe a face
SPC h d k	describe a key
SPC h d K	describe a keymap
SPC h d l	copy last pressed keys that you can paste in gitter chat
SPC h d m	describe current modes
SPC h d p	describe a package (Emacs built-in function)
SPC h d P	describe a package (Spacemacs layer information)
SPC h d s	copy system information that you can paste in gitter chat
SPC h d t	describe a theme
SPC h d v	describe a variable


Other help key bindings:

Mappings | Description
-------- | ------------
SPC h SPC | discover SpaceVim documentation, layers and packages using unite
SPC h i	| search in info pages with the symbol at point
SPC h k	| show top-level bindings with which-key
SPC h m	| search available man pages
SPC h n	| browse emacs news

Navigation key bindings in help-mode:

Mappings | Description
-------- | ------------
g b or [ | go back (same as clicking on [back] button)
g f or ] | go forward (same as clicking on [forward] button)
g h	| go to help for symbol under point

Reporting an issue:

Mappings | Description
-------- | ------------
SPC h I	| Open SpaceVim GitHub issue page with pre-filled information

#### Available layers

##### Available packages in Spacemacs

##### New packages from ELPA repositories

####Toggles



# Features

## Awesome ui

- outline + filemanager + checker
    ![2017-02-01_1360x721](https://cloud.githubusercontent.com/assets/13142418/22506638/84705532-e8bc-11e6-8b72-edbdaf08426b.png)

## Mnemonic key bindings

Key bindings are organized using mnemonic prefixes like b for buffer, p for project, s for search, h for help, etc…

**SPC mapping root** : SPC means `<Space>` on the keyboard.

Key           | Description
------------- | ----------------------
<kbd>SPC !</kbd> | shell cmd
<kbd>SPC a</kbd> | +applications
<kbd>SPC b</kbd> | +buffers
<kbd>SPC 1...9</kbd> | windows 1...9




## Language specific mode

## Key Mapping

<iframe width='853' height='480' src='https://embed.coggle.it/diagram/WMlKuKS0uwABF2j1/a35e36df1d64e7b4f5fd7f956bf97a16b194cadb92d82d83e25aaf489349b0d8' frameborder='0' allowfullscreen></iframe>

### c/c++ support

1. code completion: autocompletion and fuzzy match.
![2017-02-01_1359x720](https://cloud.githubusercontent.com/assets/13142418/22505960/df9068de-e8b8-11e6-943e-d79ceca095f1.png)
2. syntax check: Asynchronous linting and make framework.
![2017-02-01_1359x722](https://cloud.githubusercontent.com/assets/13142418/22506340/e28b4782-e8ba-11e6-974b-ca29574dcc1f.png)

### go support

1. code completion:
![2017-02-01_1360x721](https://cloud.githubusercontent.com/assets/13142418/22508345/8215c5e4-e8c4-11e6-95ec-f2a6e1e2f4d2.png)
2. syntax check:
![2017-02-01_1359x720](https://cloud.githubusercontent.com/assets/13142418/22509944/108b6508-e8cb-11e6-8104-6310a29ae796.png)

### python support

1. code completion:
![2017-02-02_1360x724](https://cloud.githubusercontent.com/assets/13142418/22537799/7d1d47fe-e948-11e6-8168-a82e3f688554.png)
2. syntax check:
![2017-02-02_1358x720](https://cloud.githubusercontent.com/assets/13142418/22537883/36de7b5e-e949-11e6-866f-73c48e8f59aa.png)

## Neovim centric - Dark powered mode of SpaceVim.

By default, SpaceVim use these dark powered plugins:

1. [deoplete.nvim](https://github.com/Shougo/deoplete.nvim) - Dark powered asynchronous completion framework for neovim
2. [dein.vim](https://github.com/Shougo/dein.vim) - Dark powered Vim/Neovim plugin manager

TODO:

1. [defx.nvim](https://github.com/Shougo/defx.nvim) - Dark powered file explorer
2. [deoppet.nvim](https://github.com/Shougo/deoppet.nvim) - Dark powered snippet plugin
3. [denite.nvim](https://github.com/Shougo/denite.nvim) - Dark powered asynchronous unite all interfaces for Neovim/Vim8

## Modular configuration

## Multiple leader mode

### Global origin vim leader, default : `\`

Vim's origin global leader can be used in all modes.

### Local origin vim leader, default : `,`

Vim's origin local leader can be used in all the mode.

### Windows function leader, default : `s`

Windows function leader can only be used in normal mode.
For the list of mappings see the [link](#window-management)

### Unite work flow leader, default : `f`

Unite work flow leader can only be used in normal mode. Unite leader need unite groups.

## Unite centric work-flow

![unite](https://cloud.githubusercontent.com/assets/13142418/23955542/26fd5348-09d5-11e7-8253-1f43991439b0.png)

- List all the plugins has been installed, fuzzy find what you want, default action is open the github website of current plugin. default key is `<leader>lp`
![2017-01-21_1358x725](https://cloud.githubusercontent.com/assets/13142418/22175019/ce42d902-e027-11e6-89cd-4f44f70a10cd.png)

- List all the mappings and description: `f<space>`
![2017-02-01_1359x723](https://cloud.githubusercontent.com/assets/13142418/22507351/24af0d74-e8c0-11e6-985e-4a1404b629ed.png)

- List all the starred repos in github.com, fuzzy find and open the website of the repo. default key is `<leader>ls`
![2017-02-01_1359x722](https://cloud.githubusercontent.com/assets/13142418/22506915/deb99caa-e8bd-11e6-9b80-316281ddb48c.png)

#### Plugin Highlights

- Package management with caching enabled and lazy loading
- Project-aware tabs and label
- Vimfiler as file-manager + SSH connections
- Go completion via vim-go and gocode
- Javascript completion via Tern
- PHP completion, indent, folds, syntax
- Python jedi completion, pep8 convention
- Languages: Ansible, css3, csv, json, less, markdown, mustache
- Helpers: Undo tree, bookmarks, git, tmux navigation,
    hex editor, sessions, and much more.

    _Note_ that 90% of the plugins are **[lazy-loaded]**.
    [lazy-loaded]: ./config/plugins.vim

#### Non Lazy-Loaded Plugins

Name           | Description
-------------- | ----------------------
[dein.vim] | Dark powered Vim/Neovim plugin manager
[vimproc] | Interactive command execution
[colorschemes] | Awesome color-schemes
[file-line] | Allow opening a file in a given line
[neomru] | MRU source for Unite
[cursorword] | Underlines word under cursor
[gitbranch] | Lightweight git branch detection
[gitgutter] | Shows git diffs in the gutter
[tinyline] | Tiny great looking statusline
[tagabana] | Central location for all tags
[bookmarks] | Bookmarks, works independently from vim marks
[tmux-navigator] | Seamless navigation between tmux panes and vim splits

#### Lazy-Loaded Plugins

##### Language

Name           | Description
-------------- | ----------------------
[html5] | HTML5 omnicomplete and syntax
[mustache] | Mustache and handlebars syntax
[markdown] | Markdown syntax highlighting
[ansible-yaml] | Additional support for Ansible
[jinja] | Jinja support in vim
[less] | Syntax for LESS
[css3-syntax] | CSS3 syntax support to vim's built-in `syntax/css.vim`
[csv] | Handling column separated data
[pep8-indent] | Nicer Python indentation
[logstash] | Highlights logstash configuration files
[tmux] | vim plugin for tmux.conf
[json] | Better JSON support
[toml] | Syntax for TOML
[i3] | i3 window manager config syntax
[Dockerfile] | syntax and snippets for Dockerfile
[go] | Go development
[jedi-vim] | Python jedi autocompletion library
[ruby] | Ruby configuration files
[portfile] | Macports portfile configuration files
[javascript] | Enhanced Javascript syntax
[javascript-indent] | Javascript indent script
[tern] | Provides Tern-based JavaScript editing support
[php] | Up-to-date PHP syntax file
[phpfold] | PHP folding
[phpcomplete] | Improved PHP omnicompletion
[phpindent] | PHP official indenting
[phpspec] | PhpSpec integration

##### Commands

Name           | Description
-------------- | ----------------------
[vimfiler] | Powerful file explorer
[NERD Commenter] | Comment tool - no comment necessary
[vinarise] | Hex editor
[syntastic] | Syntax checking hacks
[gita] | An awesome git handling plugin
[gista] | Manipulate gists in Vim
[undotree] | Ultimate undo history visualizer
[incsearch] | Improved incremental searching
[expand-region] | Visually select increasingly larger regions of text
[open-browser] | Open URI with your favorite browser
[prettyprint] | Pretty-print vim variables
[quickrun] | Run commands quickly
[ref] | Integrated reference viewer
[dictionary] | Dictionary.app interface
[vimwiki] | Personal Wiki for Vim
[thesaurus] | Look up words in an online thesaurus

##### Commands

Name           | Description
-------------- | ----------------------
[goyo] | Distraction-free writing
[limelight] | Hyperfocus-writing
[matchit] | Intelligent pair matching
[indentline] | Display vertical indention lines
[choosewin] | Choose window to use, like tmux's 'display-pane'

##### Completion

Name           | Description
-------------- | ----------------------
[delimitmate] | Insert mode auto-completion for quotes, parenthesis, brackets
[echodoc] | Print objects' documentation in echo area
[deoplete] | Neovim: Dark powered asynchronous completion framework
[neocomplete] | Next generation completion framework
[neosnippet] | Contains neocomplete snippets source

##### Unite

Name           | Description
-------------- | ----------------------
[unite] | Unite and create user interfaces
[unite-colorscheme] | Browse colorschemes
[unite-filetype] | Select file type
[unite-history] | Browse history of command/search
[unite-build] | Build with Unite interface
[unite-outline] | File "outline" source for unite
[unite-tag] | Tags source for Unite
[unite-quickfix] | Quickfix source for Unite
[neossh] | SSH interface for plugins
[unite-pull-request] | GitHub pull-request source for Unite
[junkfile] | Create temporary files for memo and testing
[unite-issue] | Issue manager for JIRA and GitHub

##### Operators & Text Objects

Name           | Description
-------------- | ----------------------
[operator-user] | Define your own operator easily
[operator-replace] | Operator to replace text with register content
[operator-surround] | Operator to enclose text objects
[textobj-user] | Create your own text objects
[textobj-multiblock] | Handle multiple brackets objects


#### Custom Key bindings

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`y` | visual | Copy selection to X11 clipboard ("+y)
`Ctrl`+`c` | Normal | Copy full path of current buffer to X11 clipboard
`<leader>`+`Ctrl`+`c` | Normal | Copy github.com url of current buffer to X11 clipboard(if it is a github repo)
`<leader>`+`Ctrl`+`l` | Normal/visual | Copy github.com url of current lines to X11 clipboard(if it is a github repo)
`<leader>`+`p` | Normal/visual | Paste selection from X11 clipboard ("+p)
`Ctrl`+`f` | Normal | Smart page forward (C-f/C-d)
`Ctrl`+`b` | Normal | Smart page backwards (C-b/C-u)
`Ctrl`+`e` | Normal | Smart scroll down (3C-e/j)
`Ctrl`+`y` | Normal | Smart scroll up (3C-y/k)
`Ctrl`+`q` | Normal | `Ctrl`+`w`
`Ctrl`+`x` | Normal | Switch buffer and placement
`Up,Down` | Normal | Smart up and down
`}` | Normal | After paragraph motion go to first non-blank char (}^)
`<` | Visual/Normal | Indent to left and re-select
`>` | Visual/Normal | Indent to right and re-select
`Tab` | Visual | Indent to right and re-select
`Shift`+`Tab` | Visual | Indent to left and re-select
`gp` | Normal | Select last paste
`Q`/`gQ` | Normal | Disable EX-mode (<Nop>)
`Ctrl`+`a` | Command | Navigation in command line
`Ctrl`+`b` | Command | Move cursor backward in command line
`Ctrl`+`f` | Command | Move cursor forward in command line

##### File Operations

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`cd` | Normal | Switch to the directory of the open buffer
`<leader>`+`w` | Normal/visual | Write (:w)
`Ctrl`+`s` | Normal/visual/Command | Write (:w)
`:w!!` | Command | Write as root (%!sudo tee > /dev/null %)

##### Editor UI

Key   | Mode | Action
----- |:----:| ------------------
`F2` | _All_ | Toggle tagbar
`F3` | _All_ | Toggle Vimfiler
`<leader>` + num | Normal | Jump to the buffer whit the num index
`<Alt>` + num | Normal | Jump to the buffer whit the num index, this only works in neovim
`<Alt>` + `h`/`<Left>` | Normal | Jump to left buffer in the tabline, this only works in neovim
`<Alt>` + `l`/`<Right>` | Normal | Jump to Right buffer in the tabline, this only works in neovim
`<leader>`+`ts` | Normal | Toggle spell-checker (:setlocal spell!)
`<leader>`+`tn` | Normal | Toggle line numbers (:setlocal nonumber!)
`<leader>`+`tl` | Normal | Toggle hidden characters (:setlocal nolist!)
`<leader>`+`th` | Normal | Toggle highlighted search (:set hlsearch!)
`<leader>`+`tw` | Normal | Toggle wrap (:setlocal wrap! breakindent!)
`g0` | Normal | Go to first tab (:tabfirst)
`g$` | Normal | Go to last tab (:tablast)
`gr` | Normal | Go to previous tab (:tabprevious)
`Ctrl`+`<Dow>` | Normal | Move to split below (<C-w>j)
`Ctrl`+`<Up>` | Normal | Move to upper split (<C-w>k)
`Ctrl`+`<Left>` | Normal | Move to left split (<C-w>h)
`Ctrl`+`<Right>` | Normal | Move to right split (<C-w>l)
`*` | Visual | Search selection forwards
`#` | Visual | Search selection backwards
`,`+`Space` | Normal | Remove all spaces at EOL
`Ctrl`+`r` | Visual | Replace selection
`<leader>`+`lj` | Normal | Next on location list
`<leader>`+`lk` | Normal | Previous on location list
`<leader>`+`S` | Normal/visual | Source selection

##### Window Management

Key   | Mode | Action
----- |:----:| ------------------
`q` | Normal | Smart buffer close
`s`+`p` | Normal | Split nicely
`s`+`v` | Normal | :split
`s`+`g` | Normal | :vsplit
`s`+`t` | Normal | Open new tab (:tabnew)
`s`+`o` | Normal | Close other windows (:only)
`s`+`x` | Normal | Remove buffer, leave blank window
`s`+`q` | Normal | Closes current buffer (:close)
`s`+`Q` | Normal | Removes current buffer, left buffer in the tabline will be displayed, if there is no buffer on the left, the right buffer will be displayed, if this is the last buffer in the tabline, then an empty buffer will be displayed.
`Tab` | Normal | Next window or tab
`Shift`+`Tab` | Normal | Previous window or tab
`<leader>`+`sv` | Normal | Split with previous buffer
`<leader>`+`sg` | Normal | Vertical split with previous buffer

SpaceVim has mapped normal <kbd>q</kbd> as smart buffer close, the normal func of <kbd>q</kbd>
can be get by <kbd>`<leader>` q r</kbd>

##### Native functions

Key   | Mode | Action
----- |:----:| ------------------
`<leader>` + `qr` | Normal | Same as native `q`
`<leader>` + `qr/` | Normal | Same as native `q/`, open cmdwin
`<leader>` + `qr?` | Normal | Same as native `q?`, open cmdwin
`<leader>` + `qr:` | Normal | Same as native `q:`, open cmdwin

##### Plugin: Unite

Key   | Mode | Action
----- |:----:| ------------------
`[unite]` | Normal | unite leader, default is `f`, `:h g:spacevim_unite_leader`
`[unite]`+`r` | Normal | Resumes Unite window
`[unite]`+`f` | Normal | Opens Unite file recursive search
`[unite]`+`i` | Normal | Opens Unite git file search
`[unite]`+`g` | Normal | Opens Unite grep with ag (the_silver_searcher)
`[unite]`+`u` | Normal | Opens Unite source
`[unite]`+`t` | Normal | Opens Unite tag
`[unite]`+`T` | Normal | Opens Unite tag/include
`[unite]`+`l` | Normal | Opens Unite location list
`[unite]`+`q` | Normal | Opens Unite quick fix
`[unite]`+`e` | Normal | Opens Unite register
`[unite]`+`j` | Normal | Opens Unite jump, change
`[unite]`+`h` | Normal | Opens Unite history/yank
`[unite]`+`s` | Normal | Opens Unite session
`[unite]`+`n` | Normal | Opens Unite session/new
`[unite]`+`o` | Normal | Opens Unite outline
`[unite]`+`c` | Normal | Opens Unite buffer bookmark file in current directory
`[unite]`+`b` | Normal | Opens Unite buffer bookmark file in buffer directory
`[unite]`+`ma` | Normal | Opens Unite mapping
`[unite]`+`<space>` | Normal | Opens Unite menu:CustomKeyMaps
`[unite]`+`me` | Normal | Opens Unite output messages
`<leader>`+`bl` | Normal | Opens Unite buffers, mru, bookmark
`<leader>`+`ta` | Normal | Opens Unite tab
`<leader>`+`ugf` | Normal | Opens Unite file with word at cursor
`<leader>`+`ugt` | Normal/visual | Opens Unite tag with word at cursor
| **Within _Unite_ buffers** |||
`Ctrl`+`h/k/l/r` | Normal | Un-map
`Ctrl`+`r` | Normal | Redraw
`Ctrl`+`j` | Insert | Select next line
`Ctrl`+`k` | Insert | Select previous line
`'` | Normal | Toggle mark current candidate, up
`e` | Normal | Run default action
`Ctrl`+`v` | Normal | Open in a split
`Ctrl`+`s` | Normal | Open in a vertical split
`Ctrl`+`t` | Normal | Open in a new tab
`Tab` | Normal | `Ctrl`+`w`+`w`
`Escape` | Normal | Exit unite
`jj` | Insert | Leave Insert mode
`r` | Normal | Replace ('search' profile) or rename
`Tab` | Insert | Unite autocompletion
`Ctrl`+`z` | Normal/insert | Toggle transpose window
`Ctrl`+`w` | Insert | Delete backward path

##### Plugin: VimFiler

Key   | Mode | Action
----- |:----:| ------------------
`<F3>` | Normal | Toggle file explorer
| **Within _VimFiler_ buffers** |||
`Ctrl`+`j` | Normal | Un-map
`Ctrl`+`l` | Normal | Un-map
`E` | Normal | Un-map
`sv` | Normal | Split edit
`sg` | Normal | Vertical split edit
`p` | Normal | Preview
`i` | Normal | Switch to directory history
`v` | Normal | Quick look
`gx` | Normal | Execute with vimfiler associated
`'` | Normal | Toggle mark current line
`V` | Normal | Clear all marks
`Ctrl`+`r` | Normal | Redraw

##### Plugin: neocomplete

Key   | Mode | Action
----- |:----:| ------------------
`Enter` | Insert | Smart snippet expansion
`Ctrl`+`space` | Insert | Autocomplete with Unite
`Tab` | Insert/select | Smart tab movement or completion
`Ctrl`+`j/k/f/b` | Insert | Movement in popup
`Ctrl`+`g` | Insert | Undo completion
`Ctrl`+`l` | Insert | Complete common string
`Ctrl`+`o` | Insert | Expand snippet
`Ctrl`+`y` | Insert | Close pop-up
`Ctrl`+`e` | Insert | Close pop-up
`Ctrl`+`l` | Insert | Complete common string
`Ctrl`+`d` | Insert | Scroll down
`Ctrl`+`u` | Insert | Scroll up

##### Plugin: NERD Commenter

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`cc` | Normal/visual | Comment out the current line or text selected in visual mode.
`<leader>`+`cn` | Normal/visual | Same as cc but forces nesting.
`<leader>`+`cu` | Normal/visual | Uncomments the selected line(s).
`<leader>`+`cs` | Normal/visual | Comments out the selected lines with a pretty block formatted layout.
`<leader>`+`cy` | Normal/visual | Same as cc except that the commented line(s) are yanked first.

##### Plugin: Goyo and Limelight

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`G` | Normal | Toggle distraction-free writing

##### Plugin: ChooseWin

Key   | Mode | Action
----- |:----:| ------------------
`-` | Normal | Choose a window to edit
`<leader>`+`-` | Normal | Switch editing window with selected

##### Plugin: Bookmarks

Key   | Mode | Action
----- |:----:| ------------------
`m`+`a` | Normal | Show list of all bookmarks
`m`+`m` | Normal | Toggle bookmark in current line
`m`+`n` | Normal | Jump to next bookmark
`m`+`p` | Normal | Jump to previous bookmark
`m`+`i` | Normal | Annotate bookmark

As SpaceVim use above bookmarks mappings, so you can not use `a`, `m`, `n`, `p` or `i` registers to mark current position, but other registers should works will. if you really need to use these registers, you can add `nnoremap <leader>m m` to your custom configuration, then you use use `a` registers via `\ma`

##### Plugin: Gita

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`gs` | Normal | Git status
`<leader>`+`gd` | Normal | Git diff
`<leader>`+`gc` | Normal | Git commit
`<leader>`+`gb` | Normal | Git blame
`<leader>`+`gp` | Normal | Git push

##### Plugin: vim-signify

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`hj` / `]c` | Normal | Jump to next hunk
`<leader>`+`hk` / `[c` | Normal | Jump to previous hunk
`<leader>`+`hJ` / `]C` | Normal | Jump to last hunk
`<leader>`+`hK` / `[C` | Normal | Jump to first hunk

##### Misc Plugins

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`gu` | Normal | Open undo tree
`<leader>`+`i` | Normal | Toggle indentation lines
`<leader>`+`j` | Normal | Start smalls
`<leader>`+`r` | Normal | Quickrun
`<leader>`+`?` | Normal | Dictionary
`<leader>`+`W` | Normal | Wiki
`<leader>`+`K` | Normal | Thesaurus


<!-- plublic links -->
[dein.vim]: https://github.com/Shougo/dein.vim
[vimproc]: https://github.com/Shougo/vimproc.vim
[colorschemes]: https://github.com/rafi/awesome-vim-colorschemes
[file-line]: https://github.com/bogado/file-line
[neomru]: https://github.com/Shougo/neomru.vim
[cursorword]: https://github.com/itchyny/vim-cursorword
[gitbranch]: https://github.com/itchyny/vim-gitbranch
[gitgutter]: https://github.com/airblade/vim-gitgutter
[bookmarks]: https://github.com/MattesGroeger/vim-bookmarks
[tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[tinyline]: https://github.com/rafi/vim-tinyline
[tagabana]: https://github.com/rafi/vim-tagabana

[html5]: https://github.com/othree/html5.vim
[mustache]: https://github.com/mustache/vim-mustache-handlebars
[markdown]: https://github.com/rcmdnk/vim-markdown
[ansible-yaml]: https://github.com/chase/vim-ansible-yaml
[jinja]: https://github.com/mitsuhiko/vim-jinja
[less]: https://github.com/groenewege/vim-less
[css3-syntax]: https://github.com/hail2u/vim-css3-syntax
[csv]: https://github.com/chrisbra/csv.vim
[pep8-indent]: https://github.com/hynek/vim-python-pep8-indent
[logstash]: https://github.com/robbles/logstash.vim
[tmux]: https://github.com/tmux-plugins/vim-tmux
[json]: https://github.com/elzr/vim-json
[toml]: https://github.com/cespare/vim-toml
[i3]: https://github.com/PotatoesMaster/i3-vim-syntax
[Dockerfile]: https://github.com/ekalinin/Dockerfile.vim
[go]: https://github.com/fatih/vim-go
[jedi-vim]: https://github.com/davidhalter/jedi-vim
[ruby]: https://github.com/vim-ruby/vim-ruby
[portfile]: https://github.com/jstrater/mpvim
[javascript]: https://github.com/jelera/vim-javascript-syntax
[javascript-indent]: https://github.com/jiangmiao/simple-javascript-indenter
[tern]: https://github.com/marijnh/tern_for_vim
[php]: https://github.com/StanAngeloff/php.vim
[phpfold]: https://github.com/rayburgemeestre/phpfolding.vim
[phpcomplete]: https://github.com/shawncplus/phpcomplete.vim
[phpindent]: https://github.com/2072/PHP-Indenting-for-VIm
[phpspec]: https://github.com/rafi/vim-phpspec
[vimfiler]: https://github.com/Shougo/vimfiler.vim
[tinycomment]: https://github.com/rafi/vim-tinycomment
[vinarise]: https://github.com/Shougo/vinarise.vim
[syntastic]: https://github.com/scrooloose/syntastic
[gita]: https://github.com/lambdalisue/vim-gita
[gista]: https://github.com/lambdalisue/vim-gista
[undotree]: https://github.com/mbbill/undotree
[incsearch]: https://github.com/haya14busa/incsearch.vim
[expand-region]: https://github.com/terryma/vim-expand-region
[open-browser]: https://github.com/tyru/open-browser.vim
[prettyprint]: https://github.com/thinca/vim-prettyprint
[quickrun]: https://github.com/thinca/vim-quickrun
[ref]: https://github.com/thinca/vim-ref
[dictionary]: https://github.com/itchyny/dictionary.vim
[vimwiki]: https://github.com/vimwiki/vimwiki
[thesaurus]: https://github.com/beloglazov/vim-online-thesaurus
[goyo]: https://github.com/junegunn/goyo.vim
[limelight]: https://github.com/junegunn/limelight.vim
[matchit]: http://www.vim.org/scripts/script.php?script_id=39
[indentline]: https://github.com/Yggdroot/indentLine
[choosewin]: https://github.com/t9md/vim-choosewin
[delimitmate]: https://github.com/Raimondi/delimitMate
[echodoc]: https://github.com/Shougo/echodoc.vim
[deoplete]: https://github.com/Shougo/deoplete.nvim
[neocomplete]: https://github.com/Shougo/neocomplete.vim
[neosnippet]: https://github.com/Shougo/neosnippet.vim
[unite]: https://github.com/Shougo/unite.vim
[unite-colorscheme]: https://github.com/ujihisa/unite-colorscheme
[unite-filetype]: https://github.com/osyo-manga/unite-filetype
[unite-history]: https://github.com/thinca/vim-unite-history
[unite-build]: https://github.com/Shougo/unite-build
[unite-outline]: https://github.com/h1mesuke/unite-outline
[unite-tag]: https://github.com/tsukkee/unite-tag
[unite-quickfix]: https://github.com/osyo-manga/unite-quickfix
[neossh]: https://github.com/Shougo/neossh.vim
[unite-pull-request]: https://github.com/joker1007/unite-pull-request
[junkfile]: https://github.com/Shougo/junkfile.vim
[unite-issue]: https://github.com/rafi/vim-unite-issue
[operator-user]: https://github.com/kana/vim-operator-user
[operator-replace]: https://github.com/kana/vim-operator-replace
[operator-surround]: https://github.com/rhysd/vim-operator-surround
[textobj-user]: https://github.com/kana/vim-textobj-user
[textobj-multiblock]: https://github.com/osyo-manga/vim-textobj-multiblock
