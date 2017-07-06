---
title:  "Documentation"
---

# SpaceVim Documentation

<!-- vim-markdown-toc GFM -->
* [Core Pillars](#core-pillars)
    * [Mnemonic](#mnemonic)
    * [Discoverable](#discoverable)
    * [Consistent](#consistent)
    * [Crowd-Configured](#crowd-configured)
* [Highlighted features](#highlighted-features)
* [Screenshots](#screenshots)
    * [welcome page](#welcome-page)
    * [working flow](#working-flow)
* [Who can benefit from this?](#who-can-benefit-from-this)
* [Update and Rollback](#update-and-rollback)
    * [Update SpaceVim itself](#update-spacevim-itself)
        * [Automatic Updates](#automatic-updates)
        * [Updating from the SpaceVim Buffer](#updating-from-the-spacevim-buffer)
        * [Updating Manually with git](#updating-manually-with-git)
    * [Update plugins](#update-plugins)
* [Configuration layers](#configuration-layers)
* [Custom Configuration](#custom-configuration)
    * [Automatic Generation](#automatic-generation)
    * [Alternative directory](#alternative-directory)
* [Awesome ui](#awesome-ui)
    * [Colorschemes](#colorschemes)
    * [Font](#font)
    * [UI Toggles](#ui-toggles)
    * [Statusline && tabline](#statusline--tabline)
        * [statusline](#statusline)
        * [tabline](#tabline)
* [Manual](#manual)
    * [Completion](#completion)
        * [Unite/Denite](#unitedenite)
            * [Mappings within unite/denite buffer](#mappings-within-unitedenite-buffer)
    * [Discovering](#discovering)
        * [Mappings](#mappings)
            * [Mappings guide](#mappings-guide)
            * [Unide/Denite describe key bindings](#unidedenite-describe-key-bindings)
        * [Getting help](#getting-help)
        * [Available layers](#available-layers)
            * [Available plugins in SpaceVim](#available-plugins-in-spacevim)
            * [New packages from ELPA repositories](#new-packages-from-elpa-repositories)
        * [Toggles](#toggles)
    * [Navigating](#navigating)
        * [Point/Cursor](#pointcursor)
        * [Vim motions with vim-easymotion](#vim-motions-with-vim-easymotion)
            * [quick-jump-link mode (TODO)](#quick-jump-link-mode-todo)
        * [Unimpaired bindings](#unimpaired-bindings)
        * [Jumping, Joining and Splitting](#jumping-joining-and-splitting)
            * [Jumping](#jumping)
            * [Joining and splitting](#joining-and-splitting)
        * [Window manipulation](#window-manipulation)
            * [Window manipulation key bindings](#window-manipulation-key-bindings)
        * [Buffers and Files](#buffers-and-files)
            * [Buffers manipulation key bindings](#buffers-manipulation-key-bindings)
            * [Create a new empty buffer](#create-a-new-empty-buffer)
            * [Special Buffers](#special-buffers)
            * [Files manipulations key bindings](#files-manipulations-key-bindings)
            * [Vim and SpaceVim files](#vim-and-spacevim-files)
        * [File tree](#file-tree)
            * [File tree navigation](#file-tree-navigation)
            * [Open file with file tree.](#open-file-with-file-tree)
    * [Commands starting with `g`](#commands-starting-with-g)
    * [Commands starting with `z`](#commands-starting-with-z)
    * [Auto-saving](#auto-saving)
    * [Searching](#searching)
        * [With an external tool](#with-an-external-tool)
            * [Useful key bindings](#useful-key-bindings)
            * [Searching in current file](#searching-in-current-file)
            * [Searching in all loaded buffers](#searching-in-all-loaded-buffers)
            * [Searching in an arbitrary directory](#searching-in-an-arbitrary-directory)
            * [Searching in a project](#searching-in-a-project)
            * [Background searching in a project](#background-searching-in-a-project)
            * [Searching the web](#searching-the-web)
        * [Searching on the fly](#searching-on-the-fly)
        * [Persistent highlighting](#persistent-highlighting)
    * [Editing](#editing)
        * [Text insertion commands](#text-insertion-commands)
        * [Multi-Encodings](#multi-encodings)
    * [Errors handling](#errors-handling)
* [Achievements](#achievements)
    * [issues](#issues)
    * [Stars, forks and watchers](#stars-forks-and-watchers)
* [Features](#features)
    * [Awesome ui](#awesome-ui-1)
    * [Mnemonic key bindings](#mnemonic-key-bindings)
* [Language specific mode](#language-specific-mode)
* [Key Mapping](#key-mapping)
    * [c/c++ support](#cc-support)
    * [go support](#go-support)
    * [python support](#python-support)
* [Neovim centric - Dark powered mode of SpaceVim.](#neovim-centric---dark-powered-mode-of-spacevim)
* [Modular configuration](#modular-configuration)
* [Multiple leader mode](#multiple-leader-mode)
    * [Global origin vim leader](#global-origin-vim-leader)
    * [Local origin vim leader](#local-origin-vim-leader)
    * [Windows function leader](#windows-function-leader)
    * [Unite work flow leader](#unite-work-flow-leader)
* [Unite centric work-flow](#unite-centric-work-flow)
        * [Plugin Highlights](#plugin-highlights)
        * [Non Lazy-Loaded Plugins](#non-lazy-loaded-plugins)
    * [Lazy-Loaded Plugins](#lazy-loaded-plugins)
        * [Language](#language)
            * [Commands](#commands)
            * [Commands](#commands-1)
            * [Completion](#completion-1)
            * [Unite](#unite)
            * [Operators & Text Objects](#operators--text-objects)
        * [Custom Key bindings](#custom-key-bindings)
            * [File Operations](#file-operations)
            * [Editor UI](#editor-ui)
            * [Window Management](#window-management)
            * [Native functions](#native-functions)
            * [Plugin: Unite](#plugin-unite)
            * [Plugin: neocomplete](#plugin-neocomplete)
            * [Plugin: NERD Commenter](#plugin-nerd-commenter)
            * [Plugin: Goyo and Limelight](#plugin-goyo-and-limelight)
            * [Plugin: ChooseWin](#plugin-choosewin)
            * [Plugin: Bookmarks](#plugin-bookmarks)
            * [Plugin: Gina/Gita](#plugin-ginagita)
            * [Plugin: vim-signify](#plugin-vim-signify)
            * [Misc Plugins](#misc-plugins)

<!-- vim-markdown-toc -->

## Core Pillars

Four core pillars: Mnemonic, Discoverable, Consistent and “Crowd-Configured”.

If any of these core pillars is violated open an issue and we’ll try our best to fix it.

### Mnemonic

Key bindings are organized using mnemonic prefixes like b for buffer, p for project, s for search, h for help, etc…

### Discoverable

Innovative real-time display of available key bindings. Simple query system to quickly find available layers, packages, and more.

### Consistent

Similar functionalities have the same key binding everywhere thanks to a clearly defined set of conventions. Documentation is mandatory for any layer that ships with SpaceVim.

### Crowd-Configured

Community-driven configuration provides curated packages tuned by power users and bugs are fixed quickly.

## Highlighted features

- **Great documentation:** access documentation in Vim with
    <kbd>:h SpaceVim</kbd>.
- **Minimalistic and nice graphical UI:** you'll love the awesome UI and its useful features.
- **Keep your fingers on the home row:** for quicker editing with support for QWERTY and BEPO layouts.
- **Mnemonic key bindings:** commands have mnemonic prefixes like
    <kbd>[Window]</kbd> for all the window and buffer commands or <kbd>[Unite]</kbd> for the
    unite work flow commands.
- **Fast boot time:** Lazy-load 90% of plugins with [dein.vim]
- **Lower the risk of RSI:** by heavily using the space bar instead of modifiers. 
- **Batteries included:** discover hundreds of ready-to-use packages nicely
    organised in configuration layers following a set of
    [conventions](http://spacevim.org/development/).
- **Neovim centric:** Dark powered mode of SpaceVim

## Screenshots

### welcome page

![welcome-page](https://cloud.githubusercontent.com/assets/13142418/26402270/28ad72b8-40bc-11e7-945e-003f41e057be.png)

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
SPC t b	| toggle background
SPC t t	| open tabs manager
SPC T ~	| display ~ in the fringe on empty lines
SPC T F	| toggle frame fullscreen
SPC T f	| toggle display of the fringe
SPC T m	| toggle menu bar
SPC T t	| toggle tool bar

### Statusline && tabline

The statusline and tabline are heavily customized with the following capabilities:

- tabline index of each buffer or tab.
- vim mode (INSERT/NORMAL etc.)
- git info : diff/branch
- checker info: numbers of errors and warnings.
- trailing line number.

Key Binding | Description
----------- | -----------
`SPC [1-9]` | jump to the index of tabline.

#### statusline

The `core#statusline` layer provide a heavily customized powerline with the following capabilities:, It is inspired by spacemacs's mode-line.


- show the window number
- color code for current state
- show the number of search results
- toggle syntax checking info
- toggle battery info
- toggle minor mode lighters

Reminder of the color codes for the states:

Mode | Color
--- |  ---
Normal | Grey
Insert | Blus
Visual | Orange
Replace | Aqua

all the colors based on the current colorscheme

Some elements can be dynamically toggled:

Key Binding	| Description
----------- | -----------
`SPC t m b` | toggle the battery status (need to install acpi)
`SPC t m c` | toggle the org task clock (available in org layer)
`SPC t m m` | toggle the minor mode lighters
`SPC t m M` | toggle the major mode
`SPC t m n` | toggle the cat! (if colors layer is declared in your dotfile)
`SPC t m p` | toggle the cursor position
`SPC t m t` | toggle the time
`SPC t m T` | toggle the mode line itself
`SPC t m v` | toggle the version control info

**Powerline font installation:**

By defalut SpaceVim use  [DejaVu Sans Mono for Powerline](https://github.com/powerline/fonts/tree/master/DejaVuSansMono), to make statusline render correctly, you need to install the font. [powerline extra symbols](https://github.com/ryanoasis/powerline-extra-symbols) also should be installed.

**syntax checking integration:**

When syntax checking minor mode is enabled, a new element appears showing the number of errors, warnings.

syntax checking integration in statusline.

**Search index integration:**

Search index shows the number of occurrence when performing a search via `/` or `?`. SpaceVim integrates nicely the search status by displaying it temporarily when n or N are being pressed. See the 20/22 segment on the screenshot below.

![search status](https://cloud.githubusercontent.com/assets/13142418/26313080/578cc68c-3f3c-11e7-9259-a27419d49572.png)

_search index in statusline_

**Battery status integration:**

_acpi_ displays the percentage of total charge of the battery as well as the time remaining to charge or discharge completely the battery.

A color code is used for the battery status:

Battery State | Color
------------ | ----
Charging | Green
Discharging | Orange
Critical | Red

all the colors based on the current colorscheme

**Statusline separators:**

It is possible to easily customize the statusline separator by setting the `g:spacevim_statusline_separator` variable in your custon configration file and then redraw the statusline. For instance if you want to set back the separator to the well-known arrow separator add the following snippet to your configuration file:

```vim
let g:spacevim_statusline_separator = 'arrow'
```

here is an exhaustive set of screenshots for all the available separator:

Separator | Screenshot
--------- | ----------
`arrow` | ![separator-arrow](https://cloud.githubusercontent.com/assets/13142418/26234639/b28bdc04-3c98-11e7-937e-641c9d85c493.png)
`curve` | ![separator-curve](https://cloud.githubusercontent.com/assets/13142418/26248272/42bbf6e8-3cd4-11e7-8792-665447040f49.png)
`slant` | ![separator-slant](https://cloud.githubusercontent.com/assets/13142418/26248515/53a65ea2-3cd5-11e7-8758-d079c5a9c2d6.png)
`nil` | ![separator-nil](https://cloud.githubusercontent.com/assets/13142418/26249776/645a5a96-3cda-11e7-9655-0aa1f76714f4.png)
`fire` | ![separator-fire](https://cloud.githubusercontent.com/assets/13142418/26274142/434cdd10-3d75-11e7-811b-e44cebfdca58.png)

**Minor Modes:**

The minor mode area can be toggled on and off with `SPC t m m`

Unicode symbols are displayed by default. Setting the variable `g:spacevim_statusline_unicode_symbols` to nil in your custom configuration file will display ASCII characters instead (may be useful in terminal if you cannot set an appropriate font).

The letters displayed in the statusline correspond to the key bindings used to toggle them.

Key Binding | Unicode | ASCII | Mode
----------- | ------- | ----- | ----
`SPC t 8` | ⑧ | 8 | toggle highlight of characters for long lines
`SPC t f` | ⓕ | f | fill-column-indicator mode
`SPC t s` | ⓢ | s | syntax checking (neomake)
`SPC t S` | Ⓢ | S | enabled in spell checking
`SPC t w` | ⓦ | w | whitespace mode

#### tabline

Buffers will be listed on tabline if there is only one tab, each item contains the index, filetype icon and the bufname. if there are more than one tab, all tabs will be listed on the tabline. each item can be quickly accessed using `<Leader> number`. default `<Leader>` is `\`.

Key Binding | Description
----------- | -----------
`<Leader> 1` | jump to index 1 on tabline
`<Leader> 2` | jump to index 2 on tabline
`<Leader> 3` | jump to index 3 on tabline
`<Leader> 4` | jump to index 4 on tabline
`<Leader> 5` | jump to index 5 on tabline
`<Leader> 6` | jump to index 6 on tabline
`<Leader> 7` | jump to index 7 on tabline
`<Leader> 8` | jump to index 8 on tabline
`<Leader> 9` | jump to index 9 on tabline

## Manual

### Completion

#### Unite/Denite

please checkout the documentation of unite and denite via `:h unite` and `:h denite`.

##### Mappings within unite/denite buffer

Mappings         | Mode          | description
--------         | ----          | -----------
`Ctrl`+`h/k/l/r` | Normal        | Un-map
`Ctrl`+`l`       | Normal        | Redraw
`Tab`            | Insert        | Select next line
`Tab`            | Normal        | Select actions
`Shift` + `Tab`  | Insert        | Select previous line
`Space`          | Normal        | Toggle mark current candidate, up
`Enter`          | Normal        | Run default action
`Ctrl`+`v`       | Normal        | Open in a split
`Ctrl`+`s`       | Normal        | Open in a vertical split
`Ctrl`+`t`       | Normal        | Open in a new tab
`Ctrl` + `g`     | Normal        | Exit unite
`jk`             | Insert        | Leave Insert mode
`r`              | Normal        | Replace ('search' profile) or rename
`Ctrl`+`z`       | Normal/insert | Toggle transpose window
`Ctrl`+`w`       | Insert        | Delete backward path

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

![mapping-guide](https://cloud.githubusercontent.com/assets/13142418/25778673/ae8c3168-3337-11e7-8536-ee78d59e5a9c.png)

this guide show you all the available key bindings begin with `[SPC]`, you can type `b` for all the buffer mappings, `p` for project mappings, etc. after pressing `<C-h>` in guide buffer, you will get paging and help info in the statusline.

key  | description
---- | -----
`u`  | undo pressing
`n`  | next page of guide buffer
`p`  | previous page of guide buffer

to defined custom SPC mappings, use `SpaceVim#custom#SPC()`. here is an example:

```vim
call SpaceVim#custom#SPC('nnoremap', ['f', 't'], 'echom "hello world"', 'test custom SPC', 1)
```


##### Unide/Denite describe key bindings

It is possible to search for specific key bindings by pressing `?` in the root of guide buffer.

To narrow the list, just insert the mapping keys or description of what mapping you want, Unite/Denite will fuzzy find the mappings, to find buffer related mappings:

![unite-mapping](https://cloud.githubusercontent.com/assets/13142418/25779196/2f370b0a-3345-11e7-977c-a2377d23286e.png)

then use `<Tab>` or `<Up>` and `<Down>` to select the mapping, press `<Enter>` will execute that command.

#### Getting help

Denite/Unite is powerful tool to  unite all interfaces. it was meant to be like [Helm](https://github.com/emacs-helm/helm) for Vim. These mappings is for getting help info about functions, variables etc:

Mappings | Description
-------- | ------------
SPC h SPC | discover SpaceVim documentation, layers and packages using unite
SPC h i	| get help with the symbol at point
SPC h k	| show top-level bindings with which-key
SPC h m	| search available man pages

Reporting an issue:

Mappings | Description
-------- | ------------
SPC h I	| Open SpaceVim GitHub issue page with pre-filled information

#### Available layers

All layers can be easily discovered via `:SPLayer -l` accessible with `SPC h l`.

##### Available plugins in SpaceVim

All plugins can be easily discovered via `<leader> l p`.

##### New packages from ELPA repositories

#### Toggles

both the toggles mappings started with `[SPC] t` or `[SPC] T`. you can find it in the mapping guide.

### Navigating

#### Point/Cursor

Navigation is performed using the Vi key bindings `hjkl`.

Key Binding | Description
----------- | -----------
`h` | move cursor left (origin vim key, no mappings)
`j` | move cursor down (origin vim key, no mappings)
`k` | move cursor up (origin vim key, no mappings)
`l` | move cursor right (origin vim key, no mappings)
`H` | move cursor to the top of the screen (origin vim key, no mappings)
`L` | move cursor to the bottom of the screen (origin vim key, no mappings)
`SPC j 0` | go to the beginning of line (and set a mark at the previous location in the line)
`SPC j $` | go to the end of line (and set a mark at the previous location in the line)
`SPC t -` | lock the cursor at the center of the screen

#### Vim motions with vim-easymotion

##### quick-jump-link mode (TODO)

https://github.com/easymotion/vim-easymotion/issues/315

Similar to easymotion or `f` in vimperator for firefox, this mode allows one to jump to any link in help file with two key strokes.

mapping | description
------- | -----------
`o` | initiate quick jump link mode in help buffer

#### Unimpaired bindings

Mappings | Description
-------- | -----------
`[ SPC` | Insert space above
`] SPC` | Insert space below
`[ b` | Go to previous buffer
`] b` | Go to next buffer
`[ f` | Go to previous file in directory
`] f` | Go to next file in directory
`[ l` | Go to the previous error
`] l` | Go to the next error
`[ c` | Go to the previous vcs hunk
`] c` | Go to the next vcs hunk
`[ q` | Go to the previous error
`] q` | Go to the next error
`[ t` | Go to the previous frame
`] t` | Go to the next frame
`[ w` | Go to the previous window
`] w` | Go to the next window
`[ e` | Move line up
`] e` | Move line down
`[ p` | Paste above current line
`] p` | Paste below current line
`g p` | Select pasted text


#### Jumping, Joining and Splitting

The `SPC j` prefix is for jumping, joining and splitting.

##### Jumping

Key Binding | Description
----------- | -----------
`SPC j 0` | go to the beginning of line (and set a mark at the previous location in the line)
`SPC j $` | go to the end of line (and set a mark at the previous location in the line)
`SPC j b` | jump backward
`SPC j f` | jump forward
`SPC j d` | jump to a listing of the current directory
`SPC j D` | jump to a listing of the current directory (other window)
`SPC j i` | jump to a definition in buffer (denite outline)
`SPC j I` | jump to a definition in any buffer (denite outline)
`SPC j j` | jump to a character in the buffer (easymotion)
`SPC j J` | jump to a suite of two characters in the buffer (easymotion)
`SPC j k` | jump to next line and indent it using auto-indent rules
`SPC j l` | jump to a line with avy (easymotion)
`SPC j q` | show the dumb-jump quick look tooltip (TODO)
`SPC j u` | jump to a URL in the current window
`SPC j v` | jump to the definition/declaration of an Emacs Lisp variable (TODO)
`SPC j w` | jump to a word in the current buffer (easymotion)

##### Joining and splitting

Key Binding | Description
----------- | -----------
`J` | join the current line with the next line
`SPC j k` | go to next line and indent it using auto-indent rules
`SPC j n` | split the current line at point, insert a new line and auto-indent
`SPC j o` | split the current line at point but let point on current line
`SPC j s` | split a quoted string or s-expression in place
`SPC j S` | split a quoted string or s-expression, insert a new line and auto-indent

#### Window manipulation

##### Window manipulation key bindings

Every window has a number displayed at the start of the statusline and can be quickly accessed using `SPC number`.

Key Binding | Description
----------- | -----------
`SPC 1` | go to window number 1
`SPC 2` | go to window number 2
`SPC 3` | go to window number 3
`SPC 4` | go to window number 4
`SPC 5` | go to window number 5
`SPC 6` | go to window number 6
`SPC 7` | go to window number 7
`SPC 8` | go to window number 8
`SPC 9` | go to window number 9

Windows manipulation commands (start with `w`):

Key Binding | Description
----------- | -----------
`SPC w TAB` | switch to alternate window in the current frame (switch back and forth)
`SPC w =` | balance split windows
`SPC w b` | force the focus back to the minibuffer (TODO)
`SPC w c` | Distraction-free reading current window
`SPC w C` | Distraction-free reading other windows via vim-choosewin
`SPC w d` | delete a window
`SPC u SPC w d` | delete a window and its current buffer (does not delete the file) (TODO)
`SPC w D` | delete another window using vim-choosewin
`SPC u SPC w D` | delete another window and its current buffer using vim-choosewin (TODO)
`SPC w t` | toggle window dedication (dedicated window cannot be reused by a mode) (TODO)
`SPC w f` | toggle follow mode (TODO)
`SPC w F` | create new tab(frame)
`SPC w h` | move to window on the left
`SPC w H` | move window to the left
`SPC w j` | move to window below
`SPC w J` | move window to the bottom
`SPC w k` | move to window above
`SPC w K` | move window to the top
`SPC w l` | move to window on the right
`SPC w L` | move window to the right
`SPC w m` | maximize/minimize a window (maximize is equivalent to delete other windows) (TODO, now only support maximize)
`SPC w M` | swap windows using vim-choosewin
`SPC w o` | cycle and focus between tabs
`SPC w p m` | open messages buffer in a popup window (TODO)
`SPC w p p` | close the current sticky popup window (TODO)
`SPC w r` | rotate windows forward
`SPC w R` | rotate windows backward
`SPC w s or SPC w -` | horizontal split
`SPC w S` | horizontal split and focus new window
`SPC w u` | undo window layout (used to effectively undo a closed window) (TODO)
`SPC w U` | redo window layout (TODO)
`SPC w v or SPC w /` | vertical split
`SPC w V` | vertical split and focus new window
`SPC w w` | cycle and focus between windows
`SPC w W` | select window using vim-choosewin

#### Buffers and Files

##### Buffers manipulation key bindings

Buffer manipulation commands (start with `b`):

Key Binding | Description
----------- | -----------
`SPC TAB` | switch to alternate buffer in the current window (switch back and forth)
`SPC b b` | switch to a buffer (via denite/unite)
`SPC b d` | kill the current buffer (does not delete the visited file)
`SPC u SPC b d` | kill the current buffer and window (does not delete the visited file) (TODO)
`SPC b D` | kill a visible buffer using vim-choosewin
`SPC u SPC b D` | kill a visible buffer and its window using ace-window(TODO)
`SPC b C-d` | kill other buffers
`SPC b C-D` | kill buffers using a regular expression(TODO)
`SPC b e` | erase the content of the buffer (ask for confirmation)
`SPC b h` | open *SpaceVim* home buffer
`SPC b n` | switch to next buffer avoiding special buffers
`SPC b m` | open *Messages* buffer
`SPC u SPC b m` | kill all buffers and windows except the current one(TODO)
`SPC b p` | switch to previous buffer avoiding special buffers
`SPC b P` | copy clipboard and replace buffer (useful when pasting from a browser)
`SPC b R` | revert the current buffer (reload from disk)
`SPC b s` | switch to the *scratch* buffer (create it if needed)
`SPC b w` | toggle read-only (writable state)
`SPC b Y` | copy whole buffer to clipboard (useful when copying to a browser)
`z f` | Make current function or comments visible in buffer as much as possible (TODO)

##### Create a new empty buffer

Key Binding | Description
----------- | -----------
`SPC b N h` | create new empty buffer in a new window on the left
`SPC b N j` | create new empty buffer in a new window at the bottom
`SPC b N k` | create new empty buffer in a new window above
`SPC b N l` | create new empty buffer in a new window below
`SPC b N n` | create new empty buffer in current window

##### Special Buffers

In SpaceVim, there are many special buffers, these buffers are created by plugins or SpaceVim isself. and all of this buffers are not listed.

##### Files manipulations key bindings

Files manipulation commands (start with f):

Key Binding | Description
----------- | -----------
`SPC f b` | go to file bookmarks
`SPC f c` | copy current file to a different location(TODO)
`SPC f C d` | convert file from unix to dos encoding
`SPC f C u` | convert file from dos to unix encoding
`SPC f D` | delete a file and the associated buffer (ask for confirmation)
`SPC f E` | open a file with elevated privileges (sudo edit)(TODO)
`SPC f f` | open file
`SPC f F` | try to open the file under point
`SPC f o` | open a file using the default external program(TODO)
`SPC f R` | rename the current file(TODO)
`SPC f s` | save a file
`SPC f S` | save all files
`SPC f r` | open a recent file
`SPC f t` | toggle file tree side bar
`SPC f T` | show file tree side bar
`SPC f y` | show and copy current file absolute path in the cmdline


##### Vim and SpaceVim files

Convenient key bindings are located under the prefix `SPC f v` to quickly navigate between Vim and SpaceVim specific files.

Key Binding | Description
----------- | -----------
`SPC f v v` | display and copy SpaceVim version
`SPC f v d` | open SpaceVim custom configuration file

#### File tree

SpaceVim use vimfiler as the default file tree, and the default key binding is `F3`, and SpaceVim also provide `SPC f t` and `SPC f T` to open the file tree. to change the file explore to nerdtree:

```vim
" the default value is vimfiler
let g:spacevim_filemanager = 'nerdtree'
```

VCS integration is supported, there will be a colum status, this feature maybe make vimfiler slow, so it is not enabled by default. to enable this feature, add `let g:spacevim_enable_vimfiler_gitstatus = 1` to your custom config. here is any picture for this feature:

![file-tree](https://user-images.githubusercontent.com/13142418/26881817-279225b2-4bcb-11e7-8872-7e4bd3d1c84e.png)

##### File tree navigation

Navigation is centered on the `hjkl` keys with the hope of providing a fast navigation experience like in [vifm](https://github.com/vifm):


Key Binding | Description
-----------| -----------
`<F3>` or `SPC f t` | Toggle file explorer
| **Within _VimFiler_ buffers** | |
`<Left>` or `h`     | go to parent node and collapse expanded directory
`<Down>` or `j`     | select next file or directory
`<Up>` or `k`       | select previous file or directory
`<Right>` or `l`    | open selected file or expand directory
`Ctrl`+`j`          | Un-map
`Ctrl`+`l`          | Un-map
`E`                 | Un-map
`.`                 | toggle visible ignored files
`sv`                | Split edit
`sg`                | Vertical split edit
`p`                 | Preview
`i`                 | Switch to directory history
`v`                 | Quick look
`gx`                | Execute with vimfiler associated
`'`                 | Toggle mark current line
`V`                 | Clear all marks
`Ctrl`+`r`          | Redraw

##### Open file with file tree.

If there is only one file buffer opened, a file is opened in the active window, otherwise we need to use vim-choosewin to select a window to open the file.

Key Binding | Description
-----------| -----------
`l` or `Enter` | open file in one window
`sg` | open file in an vertically split window
`sv` | open file in an horizontally split window
<<<<<<< HEAD

### Commands starting with `g`

after pressing prefix `g` in normal mode, if you do not remember the mappings, you will see the guide which will tell you the functional of all mappings starting with `g`.

Key Binding | Description
-----------| -----------
`g#` | search under cursor backward
`g$` | go to rightmost character
`g&` | repeat last ":s" on all lines
`g'` | jump to mark
`g*` | search under cursor forward
`g+` | newer text state
`g,` | newer position in change list
`g-` | older text state
`g/` | stay incsearch
`g0` | go to leftmost character
`g;` | older position in change list
`g<` | last page of previous command output
`g<Home>` | go to leftmost character
`gE` | end of previous word
`gF` | edit file under cursor(jump to line after name)
`gH` | select line mode
`gI` | insert text in column 1
`gJ` | join lines without space
`gN` | visually select previous match
`gQ` | switch to Ex mode
`gR` | enter VREPLACE mode
`gT` | previous tag page
`gU` | make motion text uppercase
`g]` | tselect cursor tag
`g^` | go to leftmost no-white character
`g_` | go to last char
`` g` `` | jump to mark
`ga` | print ascii value of cursor character
`gd` | goto definition
`ge` | go to end of previous word
`gf` | edit file under cursor
`gg` | go to line N
`gh` | select mode
`gi` | insert text after '^ mark
`gj` | move cursor down screen line
`gk` | move cursor up screen line
`gm` | go to middle of screenline
`gn` | visually select next match
`go` | goto byte N in the buffer
`gs` | sleep N seconds
`gt` | next tag page
`gu` | make motion text lowercase
`g~` | swap case for Nmove text
`g<End>` | go to rightmost character
`g<C-G>` | show cursor info

### Commands starting with `z`

after pressing prefix `z` in normal mode, if you do not remember the mappings, you will see the guide which will tell you the functional of all mappings starting with `z`.

Key Binding | Description
-----------| -----------
`z<Right>` | scroll screen N characters to left
`z+` | cursor to screen top line N
`z-` | cursor to screen bottom line N
`z.` | cursor line to center
`z<CR>` | cursor line to top
`z=` | spelling suggestions
`zA` | toggle folds recursively
`zC` | close folds recursively
`zD` | delete folds recursively
`zE` | eliminate all folds
`zF` | create a fold for N lines
`zG` | mark good spelled(update internal-wordlist)
`zH` | scroll half a screenwidth to the right
`zL` | scroll half a screenwidth to the left
`zM` | set `foldlevel` to zero
`zN` | set `foldenable`
`zO` | open folds recursively
`zR` | set `foldlevel` to deepest fold
`zW` | mark wrong spelled
`zX` | re-apply `foldleve`
`z^` | cursor to screen bottom line N
`za` | toggle a fold
`zb` | redraw, cursor line at bottom
`zc` | close a fold
`zd` | delete a fold
`ze` | right scroll horizontally to cursor position
`zf` | create a fold for motion
`zg` | mark good spelled
`zh` | scroll screen N characters to right
`zi` | toggle foldenable
`zj` | mode to start of next fold
`zk` | mode to end of previous fold
`zl` | scroll screen N characters to left
`zm` | subtract one from `foldlevel`
`zn` | reset `foldenable`
`zo` | open fold
`zr` | add one to `foldlevel`
`zs` | left scroll horizontally to cursor position
`zt` | cursor line at top of window
`zv` | open enough folds to view cursor line
`zx` | re-apply foldlevel and do "zV"
`zz` | smart scroll
`z<Left>` | scroll screen N characters to right

### Auto-saving

### Searching

#### With an external tool

SpaceVim can be interfaced with different searching tools like:

- [rg - ripgrep](https://github.com/BurntSushi/ripgrep)
- [ag - the silver searcher](https://github.com/ggreer/the_silver_searcher)
- [pt - the platinum searcher](https://github.com/monochromegane/the_platinum_searcher)
- [ack](https://beyondgrep.com/)
- grep

The search commands in SpaceVim are organized under the `SPC s` prefix with the next key is the tool to use and the last key is the scope. For instance `SPC s a b` will search in all opened buffers using `ag`.

If the last key (determining the scope) is uppercase then the current word under the cursor is used as default input for the search. For instance `SPC s a B` will search with word under cursor.

If the tool key is omitted then a default tool will be automatically selected for the search. This tool corresponds to the first tool found on the system of the list `g:spacevim_search_tools`, the default order is `rg`, `ag`, `pt`, `ack` then `grep`. For instance `SPC s b` will search in the opened buffers using `pt` if `rg` and `ag` have not been found on the system.

The tool keys are:

Tool | Key
-----------| -----------
ag | a
grep | g
ack | k
rg | r
pt | t

The available scopes and corresponding keys are:

Scope | Key
-----------| -----------
opened buffers | b
files in a given directory | f
current project | p

It is possible to search in the current file by double pressing the second key of the sequence, for instance `SPC s a a` will search in the current file with `ag`.

Notes:

- `rg`, `ag` and `pt` are optimized to be used in a source control repository but they can be used in an arbitrary directory as well.
- It is also possible to search in several directories at once by marking them in the unite buffer.

**Beware** if you use `pt`, [TCL parser tools](https://core.tcl.tk/tcllib/doc/trunk/embedded/www/tcllib/files/apps/pt.html) also install a command line tool called `pt`.

##### Useful key bindings

Key Binding | Description
-----------| -----------
`SPC r l` | resume the last completion buffer
`` SPC s ` `` | go back to the previous place before jump
Prefix argument | will ask for file extensions

##### Searching in current file

Key Binding | Description
-----------| -----------
`SPC s s` | search with the first found tool
`SPC s S` | search with the first found tool with default input
`SPC s a a` | ag
`SPC s a A` | ag with default input
`SPC s g g` | grep
`SPC s g G` | grep with default input
`SPC s r r` | rg
`SPC s r R` | rg with default input

##### Searching in all loaded buffers

Key Binding | Description
-----------| -----------
`SPC s b` | search with the first found tool
`SPC s B` | search with the first found tool with default input
`SPC s a b` | ag
`SPC s a B` | ag with default input
`SPC s g b` | grep
`SPC s g B` | grep with default input
`SPC s k b` | ack
`SPC s k B` | ack with default input
`SPC s r b` | rg
`SPC s r B` | rg with default input
`SPC s t b` | pt
`SPC s t B` | pt with default input

##### Searching in an arbitrary directory

Key Binding | Description
-----------| -----------
`SPC s f` | search with the first found tool
`SPC s F` | search with the first found tool with default input
`SPC s a f` | ag
`SPC s a F` | ag with default text
`SPC s g f` | grep
`SPC s g F` | grep with default text
`SPC s k f` | ack
`SPC s k F` | ack with default text
`SPC s r f` | rg
`SPC s r F` | rg with default text
`SPC s t f` | pt
`SPC s t F` | pt with default text

##### Searching in a project

Key Binding | Description
-----------| -----------
`SPC /` or `SPC s p` | search with the first found tool
`SPC *` or `SPC s P` | search with the first found tool with default input
`SPC s a p` | ag
`SPC s a P` | ag with default text
`SPC s g p` | grep
`SPC s g p` | grep with default text
`SPC s k p` | ack
`SPC s k P` | ack with default text
`SPC s t p` | pt
`SPC s t P` | pt with default text
`SPC s r p` | rg
`SPC s r P` | rg with default text

**Hint**: It is also possible to search in a project without needing to open a file beforehand. To do so use `SPC p p` and then `C-s` on a given project to directly search into it like with `SPC s p`. (TODO)

##### Background searching in a project

Background search keyword in a project, when searching done, the count will be shown on the statusline.

Key Binding	| Description
----------- | -----------
`SPC s j` | searching input expr background with the first found tool
`SPC s J` | searching cursor word background with the first found tool
`SPC s l` | List all searching result in quickfix buffer
`SPC s a j` | ag
`SPC s a J` | ag with default text
`SPC s g j` | grep
`SPC s g J` | grep with default text
`SPC s k j` | ack
`SPC s k J` | ack with default text
`SPC s t j` | pt
`SPC s t J` | pt with default text
`SPC s r j` | rg
`SPC s r J` | rg with default text

##### Searching the web

Key Binding	| Description
-----------| -----------
`SPC s w g` | Get Google suggestions in vim. Opens Google results in Browser.
`SPC s w w` | Get Wikipedia suggestions in vim. Opens Wikipedia page in Browser.(TODO)

**Note**: to enable google suggestions in vim, you need to add `let g:spacevim_enable_googlesuggest = 1` to your custom Configuration file.

#### Searching on the fly

Key Binding	| Description
-----------| -----------
`SPC s g G` | Searching in project on the fly with default tools

key binding in FlyGrep buffer:

Key Binding	Description
-----------| -----------
`<Esc>` | close FlyGrep buffer
`<Enter>` | open file at the cursor line
`<Tab>` | move cursor line down
`<S-Tab>` | move cursor line up
`<Bs>` | remove last character
`<C-w>` | remove the Word before the cursor
`<C-u>` | remove the Line before the cursor
`<C-k>` | remove the Line after the cursor
`<C-a>`/`<Home>` | Go to the beginning of the line
`<C-e>`/`<End>` | Go to the end of the line


#### Persistent highlighting

SpaceVim uses `g:spacevim_search_highlight_persist` to keep the searched expression highlighted until the next search. It is also possible to clear the highlighting by pressing `SPC s c` or executing the ex command `:noh`.

### Editing

#### Text insertion commands

Text insertion commands (start with `i`):

Key binding | Description
`SPC i l l` | insert lorem-ipsum list
`SPC i l p` | insert lorem-ipsum paragraph
`SPC i l s` | insert lorem-ipsum sentence
`SPC i p 1` | insert simple password
`SPC i p 2` | insert stronger password
`SPC i p 3` | insert password for paranoids
`SPC i p p` | insert a phonetically easy password
`SPC i p n` | insert a numerical password
`SPC i u` | Search for Unicode characters and insert them into the active buffer.
`SPC i U 1` | insert UUIDv1 (use universal argument to insert with CID format)
`SPC i U 4` | insert UUIDv4 (use universal argument to insert with CID format)
`SPC i U U` | insert UUIDv4 (use universal argument to insert with CID format)

#### Multi-Encodings

SpaceVim use utf-8 as default encoding. there are four options for these case:

- fileencodings (fencs): ucs-bom,utf-8,default,latin1
- fileencoding (fenc): utf-8
- encoding (enc): utf-8
- termencoding (tenc): utf-8 (only supported in vim)

to fix messy display: `SPC e a` is the mapping for auto detect the file encoding. after detecting file encoding, you can run the command below to fix the encoding:

```vim
set enc=utf-8
write
```

### Errors handling

SpaceVim uses [neomake](https://github.com/neomake/neomake) to gives error feedback on the fly. The checks are only performed at save time by default.

Errors management mappings (start with e):

Mappings | Description
-------- | -----------
`SPC t s` | toggle syntax checker
`SPC e c` | clear all errors
`SPC e h` | describe a syntax checker
`SPC e l` | toggle the display of the list of errors/warnings
`SPC e n` | go to the next error
`SPC e p` | go to the previous error
`SPC e v` | verify syntax checker setup (useful to debug 3rd party tools configuration)
`SPC e .` | error transient state

The next/previous error mappings and the error transient state can be used to browse errors from syntax checkers as well as errors from location list buffers, and indeed anything that supports vim's location list. This includes for example search results that have been saved to a location list buffer.

Custom sign symbol:

Symbol | Description | Custom option
------ | ----------- | -------------
`✖` | Error | `g:spacevim_error_symbol`
`➤` | warning | `g:spacevim_warning_symbol`

<!-- SpaceVim Achievements start -->
## Achievements

### issues

Achievements | Account
----- | -----
[100th issue(issue)](https://github.com/SpaceVim/SpaceVim/issues/100) | [BenBergman](https://github.com/BenBergman)

### Stars, forks and watchers

Achievements | Account
----- | -----
First stargazers | [monkeydterry](https://github.com/monkeydterry)
100th stargazers | [naraj](https://github.com/naraj)
1000th stargazers | [icecity96](https://github.com/icecity96)
2000th stargazers | [frowhy](https://github.com/frowhy)
3000th stargazers | [purkylin](https://github.com/purkylin)

<!-- SpaceVim Achievements end -->

## Features

### Awesome ui

- outline + filemanager + checker

![awesome ui](https://cloud.githubusercontent.com/assets/13142418/22506638/84705532-e8bc-11e6-8b72-edbdaf08426b.png)

### Mnemonic key bindings

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
![completion-fuzzy-match](https://cloud.githubusercontent.com/assets/13142418/22505960/df9068de-e8b8-11e6-943e-d79ceca095f1.png)
2. syntax check: Asynchronous linting and make framework.
![syntax-check](https://cloud.githubusercontent.com/assets/13142418/22506340/e28b4782-e8ba-11e6-974b-ca29574dcc1f.png)

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

### Global origin vim leader

Vim's origin global leader can be used in all modes.

### Local origin vim leader

Vim's origin local leader can be used in all the mode.

### Windows function leader

Windows function leader can only be used in normal mode.
For the list of mappings see the [link](#window-management)

### Unite work flow leader

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

### Lazy-Loaded Plugins

#### Language

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

##### Plugin: Gina/Gita

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`gs` | Normal | Git status
`<leader>`+`gd` | Normal | Git diff
`<leader>`+`gc` | Normal | Git commit
`<leader>`+`gb` | Normal | Git blame
`<leader>`+`gp` | Normal | Git push
`<leader>`+`ga` | Normal | Git add current buffer
`<leader>`+`gA` | Normal | Git add all files

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
