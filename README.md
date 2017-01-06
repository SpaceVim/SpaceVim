### SpaceVim

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20SpaceVim-orange.svg?style=flat-square)](doc/SpaceVim.txt)
[![QQ](https://img.shields.io/badge/QQ群-121056965-blue.svg)](https://jq.qq.com/?_wv=1027&k=43DB6SG)
[![Gitter](https://badges.gitter.im/SpaceVim/SpaceVim.svg)](https://gitter.im/SpaceVim/SpaceVim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
<head>
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-89745542-1', 'auto');
ga('send', 'pageview');

</script>
</head>

SpaceVim is a Modular configuration, a bundle of custom settings and plugins, for Vim. It
got inspired by [spacemacs](https://github.com/syl20bnr/spacemacs).

For learning about Vim in general, read
[vim-galore](https://github.com/mhinz/vim-galore).

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput) 

##### Install

```sh
curl -sLf https://raw.githubusercontent.com/SpaceVim/SpaceVim/dev/install.sh | bash
```
before use SpaceVim, you should install the plugin by `call dein#install()`

installation of neovim/vim with python support:
> [neovim installation](https://github.com/neovim/neovim/wiki/Installing-Neovim) 

> [Building Vim from source](https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source)

#### Features

- Neovim-centric
- [Modular configuration](#modular-configuration)
- Lazy-load 90% of plugins with [dein.vim]
- Robust, yet light weight
- [Unite centric work-flow](#unite-centric-work-flow)
- [Awesome ui](#awesome-ui)
- [Language specific mode](#language-specific-mode)
- Extensive Neocomplete setup
- Central location for tags
- Lightweight simple status/tabline
- Premium color-schemes

#### Structure
- [config](./config)/ - Configuration
  - [plugins](./config/plugins)/ - Plugin configurations
  - [mappings.vim](./config/mappings.vim) - Key mappings
  - [autocmds.vim](./config/autocmds.vim) - autocmd group
  - [general.vim](./config/general.vim) - General configuration
  - [init.vim](./config/init.vim) - `runtimepath` initialization
  - [neovim.vim](./config/neovim.vim) - Neovim specific setup
  - [plugins.vim](./config/plugins.vim) - Plugin bundles
  - [commands.vim](./config/commands.vim) - Commands
  - [functions.vim](./config/functions.vim) - Functions
  - [main.vim](./config/main.vim) - Main config
- [ftplugin](./ftplugin)/ - Language specific custom settings
- [snippets](../../snippets)/ - Code snippets
- [filetype.vim](./filetype.vim) - Custom filetype detection
- [init.vim](./init.vim) - Sources `config/main.vim`
- [vimrc](./vimrc) - Sources `config/main.vim`

#### Modular configuration

SpaceVim will load custom configuration from `~/.local.vim` and `.local.vim` in current directory.

here is an example:

```viml
" here are some basic customizations, please refer to the top of the vimrc file for all possible options
let g:spacevim_default_indent = 3
let g:spacevim_max_column     = 80
let g:spacevim_colorscheme    = 'my_awesome_colorscheme'
let g:spacevim_plugin_manager = 'dein'  " neobundle or dein or vim-plug

" change the default directory where all miscellaneous persistent files go
let g:spacevim_cache_dir = "/some/place/else"

" by default, language specific plugins are not loaded.  this can be changed with the following:
let g:spacevim_plugin_groups_exclude = ['ruby', 'python']

" if there are groups you want always loaded, you can use this:
let g:spacevim_plugin_groups_include = ['go']

" alternatively, you can set this variable to load exactly what you want
let g:spacevim_plugin_groups = ['core', 'web']

" if there is a particular plugin you don't like, you can define this variable to disable them entirely
let g:spacevim_disabled_plugins=['vim-foo', 'vim-bar']

" anything defined here are simply overrides
set wildignore+=\*/node_modules/\*
set guifont=Wingdings:h10
```

#### Unite centric work-flow
- List all the plugins has been installed, fuzzy find what you want,
    default action is open the github website of current plugin. default key is `<leader>lp`
    ![2016-12-29-22 31 27](https://cloud.githubusercontent.com/assets/13142418/21545996/c48d7728-ce16-11e6-8e30-0c72139f642f.png)

- List all the mappings and description: `f<space>`
    ![2016-12-29-22 35 29](https://cloud.githubusercontent.com/assets/13142418/21546066/4896c5e2-ce17-11e6-8246-945b924df9aa.png)

- List all the starred repos in github.com, fuzzy find and open the website of the repo. default key is `<leader>ls`
    ![2016-12-29-22 38 52](https://cloud.githubusercontent.com/assets/13142418/21546148/c6836618-ce17-11e6-82a9-81e90017dbf1.png)

#### Awesome ui
- outline + filemanager + checker
    ![2017-01-03-21 26 03](https://cloud.githubusercontent.com/assets/13142418/21609104/74567ce4-d1fb-11e6-9495-16aa5ad2e42d.png)

#### Language specific mode
- java
- viml
- rust
- php
- c/c++
- js
- python


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
[tinycomment] | Robust but light-weight commenting
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
[delimitmate] | Insert mode auto-completion for quotes, parens, brackets
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
`<leader>`+`y` | Normal/visual | Copy selection to X11 clipboard ("+y)
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
`<leader>`+`cd` | Normal | Switch to the root directory(vim-rooter)
`<leader>`+`w` | Normal/visual | Write (:w)
`Ctrl`+`s` | _All_ | Write (:w)
`W!!` | Command | Write as root

##### Editor UI

Key   | Mode | Action
----- |:----:| ------------------
`F2` | _All_ | Toggle tagbar
`F3` | _All_ | Toggle Vimfiler
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
`s`+`Q` | Normal | Removes current buffer (:bdelete)
`Tab` | Normal | Next window or tab
`Shift`+`Tab` | Normal | Previous window or tab
`<leader>`+`sv` | Normal | Split with previous buffer
`<leader>`+`sg` | Normal | Vertical split with previous buffer

##### Plugin: Unite

Key   | Mode | Action
----- |:----:| ------------------
`;`+`r` | Normal | Resumes Unite window
`;`+`f` | Normal | Opens Unite file recursive search
`;`+`i` | Normal | Opens Unite git file search
`;`+`g` | Normal | Opens Unite grep with ag (the_silver_searcher)
`;`+`u` | Normal | Opens Unite source
`;`+`t` | Normal | Opens Unite tag
`;`+`T` | Normal | Opens Unite tag/include
`;`+`l` | Normal | Opens Unite location list
`;`+`q` | Normal | Opens Unite quick fix
`;`+`e` | Normal | Opens Unite register
`;`+`j` | Normal | Opens Unite jump, change
`;`+`h` | Normal | Opens Unite history/yank
`;`+`s` | Normal | Opens Unite session
`;`+`o` | Normal | Opens Unite outline
`;`+`ma` | Normal | Opens Unite mapping
`;`+`me` | Normal | Opens Unite output messages
`<leader>`+`b` | Normal | Opens Unite buffers, mru, bookmark
`<leader>`+`ta` | Normal | Opens Unite tab
`<leader>`+`gf` | Normal | Opens Unite file with word at cursor
`<leader>`+`gt` | Normal/visual | Opens Unite tag with word at cursor
`<leader>`+`gg` | Visual | Opens Unite navigate with word at cursor
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
`;`+`e` | Normal | Toggle file explorer
`;`+`a` | Normal | Toggle file explorer on current file
| **Within _VimFiler_ buffers** |||
`Ctrl`+`j` | Normal | Un-map
`Ctrl`+`l` | Normal | Un-map
`E` | Normal | Un-map
`sv` | Normal | Split edit
`sg` | Normal | Vertical split edit
`p` | Normal | Preview
`i` | Normal | Switch to directory history
`Ctrl`+`r` | Normal | Redraw
`Ctrl`+`q` | Normal | Quick look

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

##### Plugin: TinyComment

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`v` | Normal/visual | Toggle single-line comments
`<leader>`+`V` | Normal/visual | Toggle comment block

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

##### Plugin: Gita

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`gs` | Normal | Git status
`<leader>`+`gd` | Normal | Git diff
`<leader>`+`gc` | Normal | Git commit
`<leader>`+`gb` | Normal | Git blame
`<leader>`+`gB` | Normal | Open in browser
`<leader>`+`gp` | Normal | Git push

##### Plugin: GitGutter

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`hj` | Normal | Jump to next hunk
`<leader>`+`hk` | Normal | Jump to previous hunk
`<leader>`+`hs` | Normal | Stage hunk
`<leader>`+`hr` | Normal | Revert hunk
`<leader>`+`hp` | Normal | Preview hunk

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

#### Enjoy!

#### Credits & Thanks
- [vimdoc](https://github.com/google/vimdoc) generate doc file for SpaceVim
- [Rafael Bodill](https://github.com/rafi) and his vim-config
- [Bailey Ling](https://github.com/bling) and his dotvim

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


