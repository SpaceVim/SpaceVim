# Change Log

This is the Changelog for the vim-airline project.

## [0.12] - Unreleased
- New features
  - Extensions:
    - [poetv](https://github.com/petobens/poet-v) support
    - [vim-lsp](https://github.com/prabirshrestha/vim-lsp) support
    - [zoomwintab](https://github.com/troydm/zoomwintab.vim) support
    - [Vaffle](https://github.com/cocopon/vaffle.vim) support
    - [vim-dirvish](https://github.com/justinmk/vim-dirvish) support
- Improvements
  - git branch can also be displayed using [gina.vim](https://github.com/lambdalisue/gina.vim)
  - coc extensions can also show additional status messages
  - [coc-git](https://github.com/neoclide/coc-git) extension integrated into hunks extension
- Other
  - Introduce Vim script static analysis using [reviewdog](https://github.com/reviewdog/action-vint)
  - Added multiple Vim versions to unit tests using Travis CI

## [0.11] - 2019-11-10
- New features
  - Extensions:
    - [Coc](https://github.com/neoclide/coc.nvim) support
    - [Defx](https://github.com/Shougo/defx.nvim) support
    - [gina](https://github.com/lambdalisue/gina.vim) support
    - [vim-bookmark](https://github.com/MattesGroeger/vim-bookmarks) support
    - [vista.vim](https://github.com/liuchengxu/vista.vim) support
    - [tabws](https://github.com/s1341/vim-tabws) support for the tabline
- Improvements
  - The statusline can be configured to be shown on top (in the tabline)
    Set the `g:airline_statusline_ontop` to enable this experimental feature.
  - If `buffer_idx_mode=2`, up to 89 mappings will be exposed to access more
    buffers directly (issue [#1823](https://github.com/vim-airline/vim-airline/issues/1823))
  - Allow to use `random` as special theme name, which will switch to a random
    airline theme (at least if a random number can be generated :()
  - The branch extensions now also displays whether the repository is in a clean state
    (will append a ! or ⚡if the repository is considered dirty).
  - The whitespace extensions will also check for conflict markers
  - `:AirlineRefresh` command now takes an additional `!` attribute, that **skips** 
    recreating the highlighting groups (which might have a serious performance
    impact if done very often, as might be the case when the configuration variable 
    `airline_skip_empty_sections` is active).
  - airline can now also detect multiple cursor mode (issue [#1933](https://github.com/vim-airline/vim-airline/issues/1933))
  - expose hunks output using the function `airline#extensions#hunks#get_raw_hunks()` to the outside [#1877](https://github.com/vim-airline/vim-airline/pull/1877)
  - expose wordcount affected filetype list to the public using the `airline#extensions#wordcount#filetypes` variable [#1887](https://github.com/vim-airline/vim-airline/pull/1887)
  - for the `:AirlineExtension` command, indicate whether the extension has been loaded from an external source [#1890](https://github.com/vim-airline/vim-airline/issues/1890)
  - correctly load custom wordcount formatters [#1896](https://github.com/vim-airline/vim-airline/issues/1896)
  - add a new short_path formatter for the tabline [#1898](https://github.com/vim-airline/vim-airline/pull/1898)
  - several improvements to the branch, denite and tabline extension, as well as the async code for Vim and Neovim
  - the term extension supports [neoterm](https://github.com/kassio/neoterm) vim plugin

## [0.10] - 2018-12-15
- New features
  - Extensions:
    - [LanguageClient](https://github.com/autozimu/LanguageClient-neovim)
    - [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)
    - [vim-localsearch](https://github.com/mox-mox/vim-localsearch)
    - [xtabline](https://github.com/mg979/vim-xtabline)
    - [vim-grepper](https://github.com/mhinz/vim-grepper)
  - Add custom AirlineModeChanged autocommand, allowing to call user defined commands
    whenever airline displays a different mode
  - New :AirlineExtensions command, to show which extensions have been loaded
  - Detect several new modes (e.g. completion, virtual replace, etc)
- Improvements
  - Various performance improvements, should Vim keep responsive, even when
    many highlighting groups need to be re-created
  - Rework tabline extension
  - Refactor [vim-ctrlspace](https://github.com/szw/vim-ctrlspace) extension
  - Refactor the wordcount extension
  - Reworked the po extension
  - Allow to disable line numbers for the [Ale Extension](https://github.com/w0rp/ale)
  - [fugitive](https://github.com/tpope/vim-fugitive) plugin has been refactored
    causing adjustments for vim-airline, also uses Fugitives new API calls
  - some improvements to Vims terminal mode
  - Allow to use alternative seperators for inactive windows ([#1236](https://github.com/vim-airline/vim-airline/issues/1236))
  - Statusline can be set to inactive, whenever Vim loses focus (using FocusLost autocommand)

## [0.9] - 2018-01-15
- Changes
  - Look of default Airline Symbols has been improved [#1397](https://github.com/vim-airline/vim-airline/issues/1397)
  - Airline does now set `laststatus=2` if needed
  - Syntastic extension now displays warnings and errors separately
  - Updates on Resize and SessionLoad events
  - Add `maxlinenr` symbol to `airline_section_z`
  - Add quickfix title to inactive windows
- Improvements
  - Many performance improvements (using caching and async feature when possible)
  - Cache changes to highlighting groups if `g:airline_highlighting_cache = 1` is set
  - Allow to skip empty sections by setting `g:airline_skip_empty_sections` variable
  - Make use of improved Vim Script API, if available (e.g. getwininfo())
  - Support for Vims terminal feature (very experimental since it hasn't been stabilized yet)
  - More configuration for the tabline extension (with clickable buffers for Neovim)
  - Works better on smaller window sizes
  - Make airline aware of git worktrees
  - Improvements to the fugitive extension [#1603](https://github.com/vim-airline/vim-airline/issues/1603)
  - Allows for configurable fileformat output if `g:airline#parts#ffenc#skip_expected_string` is set
  - Improvements to the documentation
- New features
  - Full async support for Vim 8 and Neovim
  - Extensions:
    - [vim-bufmru](https://github.com/mildred/vim-bufmru)
    - [xkb-switch](https://github.com/ierton/xkb-switch)
    - [input-source-switcher](https://github.com/vovkasm/input-source-switcher)
    - [vimagit](https://github.com/jreybert/vimagit)
    - [denite](https://github.com/Shougo/denite.nvim)
    - [dein](https://github.com/Shougo/dein.vim)
    - [vimtex](https://github.com/lervag/vimtex)
    - [minpac](https://github.com/k-takata/minpac/)
    - [vim-cursormode](https://github.com/vheon/vim-cursormode)
    - [Neomake](https://github.com/neomake/neomake)
    - [Ale](https://github.com/w0rp/ale)
    - [vim-obsession](https://github.com/tpope/vim-obsession)
    - spell (can also display Spell language)
    - keymap
  - Formatters:
    - Formatters for JavaScript [#1617](https://github.com/vim-airline/vim-airline/issues/1617)
    - Tabline: Allow for custom formatter for `tab_nr_type` [#1418](https://github.com/vim-airline/vim-airline/issues/1418)
    - Customizable wordcount formatter [#1584](https://github.com/vim-airline/vim-airline/issues/1584)
  - Add User autocommand for Theme changing [#1226](https://github.com/vim-airline/vim-airline/issues/1226)
  - Shows mercurial mq status if hg mq extension is enabled

## [0.8] - 2016-03-09
- Changes
  - Airline converted to an organization and moved to new [repository](https://github.com/vim-airline/vim-airline)
  - Themes have been split into an separate repository [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)
- Improvements
  - Extensions
    - branch: support Git and Mercurial simultaneously, untracked files
    - whitespace: new mixed-indent rule
  - Windows support
  - Many bug fixes
  - Support for Neovim
- New features
  - Many new themes
  - Extensions/integration
    - [taboo](https://github.com/gcmt/taboo.vim)
    - [vim-ctrlspace](https://github.com/szw/vim-ctrlspace)
    - [quickfixsigns](https://github.com/tomtom/quickfixsigns_vim)
    - [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
    - [po.vim](http://www.vim.org/scripts/script.php?script_id=695)
    - [unicode.vim](https://github.com/chrisbra/unicode.vim)
    - wordcount
    - crypt indicator
    - byte order mark indicator
  - Tabline's tab mode can display splits simultaneously

## [0.7] - 2014-12-10
- New features
    - accents support; allowing multiple colors/styles in the same section
    - extensions: eclim
    - themes: understated, monochrome, murmur, sol, lucius
- Improvements
    -  solarized theme; support for 8 color terminals
    -  tabline resizes dynamically based on number of open buffers
    -  miscellaneous bug fixes

## [0.6] - 2013-10-08

- New features
    - accents support; allowing multiple colors/styles in the same section
    - extensions: eclim
    - themes: understated, monochrome, murmur, sol, lucius
- Improvements
    - solarized theme; support for 8 color terminals
    - tabline resizes dynamically based on number of open buffers
    - miscellaneous bug fixes

## [0.5] - 2013-09-13

- New features
    - smart tabline extension which displays all buffers when only one tab is visible
    - automatic section truncation when the window resizes
    - support for a declarative style of configuration, allowing parts to contain metadata such as minimum window width or conditional visibility
    - themes: zenburn, serene
- Other
    - a sizable chunk of vim-airline is now running through a unit testing suite, automated via Travis CI

## [0.4] - 2013-08-26

 - New features
    - integration with csv.vim and vim-virtualenv
    - hunks extension for vim-gitgutter and vim-signify
    - automatic theme switching with matching colorschemes
    - commands: AirlineToggle
    - themes: base16 (all variants)
 - Improvements
    - integration with undotree, tagbar, and unite
 - Other
    - refactored core and exposed statusline builder and pipeline
    - all extension related g:airline_variables have been deprecated in favor of g:airline#extensions# variables
    - extensions found in the runtimepath outside of the default distribution will be automatically loaded

## [0.3] - 2013-08-12

-  New features
    -  first-class integration with tagbar
    -  white space detection for trailing spaces and mixed indentation
    -  introduced warning section for syntastic and white space detection
    -  improved ctrlp integration: colors are automatically selected based on the current airline theme
    -  new themes: molokai, bubblegum, jellybeans, tomorrow
-  Bug fixes
    -  improved handling of eventignore used by other plugins
-  Other
    - code cleaned up for clearer separation between core functionality and extensions
    - introduced color extraction from highlight groups, allowing themes to be generated off of the active colorscheme (e.g. jellybeans and tomorrow)
    - License changed to MIT

## [0.2] - 2013-07-28

-  New features
      - iminsert detection
      - integration with vimshell, vimfiler, commandt, lawrencium
      - enhanced bufferline theming
      - support for ctrlp theming
      - support for custom window excludes
- New themes
      - luna and wombat
- Bug fixes
      - refresh branch name after switching with a shell command

## [0.1] - 2013-07-17

- Initial release
  - integration with other plugins: netrw, unite, nerdtree, undotree, gundo, tagbar, minibufexplr, ctrlp
  - support for themes: 8 included

[0.12]: https://github.com/vim-airline/vim-airline/compare/v0.11...HEAD
[0.11]: https://github.com/vim-airline/vim-airline/compare/v0.10...v0.11
[0.10]: https://github.com/vim-airline/vim-airline/compare/v0.9...v0.10
[0.9]: https://github.com/vim-airline/vim-airline/compare/v0.8...v0.9
[0.8]: https://github.com/vim-airline/vim-airline/compare/v0.7...v0.8
[0.7]: https://github.com/vim-airline/vim-airline/compare/v0.6...v0.7
[0.6]: https://github.com/vim-airline/vim-airline/compare/v0.5...v0.6
[0.5]: https://github.com/vim-airline/vim-airline/compare/v0.4...v0.5
[0.4]: https://github.com/vim-airline/vim-airline/compare/v0.3...v0.4
[0.3]: https://github.com/vim-airline/vim-airline/compare/v0.2...v0.3
[0.2]: https://github.com/vim-airline/vim-airline/compare/v0.1...v0.2
[0.1]: https://github.com/vim-airline/vim-airline/releases/tag/v0.1
