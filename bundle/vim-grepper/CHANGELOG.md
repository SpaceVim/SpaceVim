# Change Log

All notable changes to this project will be documented in this file. (Thus, it
won't list single bugfixes or improved documentation.)

## [1.4] - 2016-11-11

### Added

- Probably the most exciting change: two new flags: `-buffer` and `-buffers`. By
  default Grepper recursively searches from the current working directory. Using
  `-buffer` will search the current "buffer" and `-buffers` all loaded
  "buffers". I put the buffers in quotes, because the grep tools obviously work
  on the underlying files, not the buffers itself. So, for best results, save
  before searching. Everyone loves demos, so here it is:
  [demo](https://raw.githubusercontent.com/mhinz/vim-grepper/master/pictures/grepper-demo2.gif).
- `g:grepper` now gets exposed. That is, after running `:Grepper` for the first
  time, `:echo g:grepper` will show you exactly what default entries are used by
  the plugin. If you set `g:grepper` in your vimrc already, it will be enriched
  by all missing default entries. So, if you want to add a new tool or change
  the defaults of an existing tool, have a look at them via `:echo
  g:grepper.tools g:grepper.git`.
- New option: `g:grepper.simple_prompt`. If you work in small windows or your
  grep tool just takes a lot of options, the prompt quickly becomes too long.
  When this option is set, only the name of the grep tool, without any options,
  will be shown.
- When using the operator or visual selection to start a search, `--` is now put
  in front of the quoted query. This avoids issues when searching for anything
  starting with `-`, since it marks the end of options of the grep tool.
- The quickfix/location window always shows the executed command in the
  statusline. Even after closing and reopening it! This requires your Vim to be
  recent enough to accept a third argument for `:h setqflist()`.

### Changed

- Due to what I believe is a bug in Vim, ripgrep, pt, and ack are forced to run
  synchronuously at the moment. See:
  [#65](https://github.com/mhinz/vim-grepper/issues/65). Suggestions welcome.
- Default commands got prefixed: `:Ag` -> `:GrepperAg` and so on.
- Handle consecutive spaces in a query. Previously those were replaced by a
  single space, because of the way the flag parser for `:Grepper` worked.
- The `:Grepper` command doesn't use `-bar` anymore. This avoids pipe escaping
  madness and you can use _exactly_ the same commands you would use in the
  shell. This would just work the way you expect it to work:
  ```
  :Grepper -tool ag -query 'foo|bar' | head -n2
  ```
- I revamped the README to be a much shorter and put all the details in the wiki
  instead. Moreover, two new animated GIFs!

## [1.3] - 2016-09-26

### Added

- Async support for Vim.
- Default commands for all supported tools: `:Grep` for grep, `:Ack` for ack,
  etc. Only exception: `:GG` for `git` to avoid conflicts with
  [fugitive](https://github.com/tpope/vim-fugitive).
- Support for [ripgrep](https://github.com/BurntSushi/ripgrep)
- `-noprompt` flag. Especially useful together with `-grepprg` or `-cword`.
- `-highlight` flag that enables search highlighting for simple queries.
- Flag completion for `:Grepper`. Compare `:Grepper <c-d>` to `:Grepper -<c-d>`.
- `$+` placeholder for `-grepprg`. Gets replaced by all opened files.
- `$.` placeholder for `-grepprg`. Gets replaced by the current buffer name.

### Changed

- Use stdout handler instead of tempfile for async output.
- Use `'nowrap'` in quickfix window.
- When using `-cword`, add the query to the input history.
- `&grepprg` does not get touched anymore.

### Removed

- Quickfix mappings in favor of dedicated plugins like [vim-qf](https://github.com/romainl/vim-qf) or [QFEnter](https://github.com/yssl/QFEnter).
- `-cword!`. Was inconsistent syntax in the first place and can now be replaced
  with `-cword -noprompt`.
- Support for vim-dispatch. See this
  [commit](https://github.com/mhinz/vim-grepper/commit/c345137c336c531209a6082a6fcd5c2722d45773).
- Sift was removed as default tool, because it either needs `grepprg = 'sift $*
  .'` (which makes restricting the search to a subdirectory quite hard) or an
  allocated PTY (which means fighting with all kinds of escape sequences). If
  you're a Go nut, use
  [pt](https://github.com/monochromegane/the_platinum_searcher) instead.

## [1.2] - 2016-01-23

This is mainly a bugfix release and the last release before 2.0 that will bring
quite some changes.

### Changed

- The default order of the tools is this now: `['ag', 'ack', 'grep', 'findstr',
  'sift', 'pt', 'git']`. This was done because not everyone is a git nut like
  me.

## [1.1] - 2016-01-18

50 commits.

### Added

- `CHANGELOG.md` according to [keepachangelog.com](http://keepachangelog.com)
- Support for [sift](https://sift-tool.org)
- `<esc>` can be used to cancel the prompt now (in addition to `<c-c>`)
- `-grepprg` flag (allows more control about the exact command used)
- For ag versions older than 0.25, `--column --nogroup --noheading` is used
  automatically instead of `--vimgrep`
- FAQ (see `:h grepper-faq`)
- Mappings in quickfix window: `o`, `O`, `S`, `v`, `V`, `T` (see `:h
  grepper-mappings`)
- using `-dispatch` implies `-quickfix`
- The quickfix window uses the full width at the bottom of the screen. Location
  lists are opened just below their accompanying windows instead.

### Changed

- Option "open" enabled by default
- Option "switch" enabled by default
- Option "jump" disabled by default
- The "!" for :Grepper was removed. Use `:Grepper -jump` instead.
- improved vim-dispatch support
- `g:grepper.tools` had to contain executables before. It takes arbitrary names
  now.
- Never forget query when switching tools (previously we remembered the query
  only when the operator was used)

## [1.0] - 2015-12-09

First release!

[1.4]: https://github.com/mhinz/vim-grepper/compare/v1.3...v1.4
[1.3]: https://github.com/mhinz/vim-grepper/compare/v1.2...v1.3
[1.2]: https://github.com/mhinz/vim-grepper/compare/v1.1...v1.2
[1.1]: https://github.com/mhinz/vim-grepper/compare/v1.0...v1.1
[1.0]: https://github.com/mhinz/vim-grepper/compare/8b9234f...v1.0
