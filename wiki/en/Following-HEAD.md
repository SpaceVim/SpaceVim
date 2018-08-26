This page documents changes in master branch since last release v0.8.0

## PreRelease

The next release is v0.9.0.

### Added

- Add material theme ([#1833](https://github.com/SpaceVim/SpaceVim/pull/1833))
- Add floobits layer ([#1697](https://github.com/SpaceVim/SpaceVim/pull/1697))
- Add `SPC b b` key binding in `fzf` layer ([#1725](https://github.com/SpaceVim/SpaceVim/pull/1725))
- Add test for `toml`, `number`, `file`, `icon` and `highlight` API ([#1849](https://github.com/SpaceVim/SpaceVim/pull/1849))
- Add lsp support for julia ([#1850](https://github.com/SpaceVim/SpaceVim/pull/1850))
- Add lsp support for typescript ([#1870](https://github.com/SpaceVim/SpaceVim/pull/1870))
- Add lsp support for elixir ([#2037](https://github.com/SpaceVim/SpaceVim/pull/2037))
- Add lsp support for bash ([#2045](https://github.com/SpaceVim/SpaceVim/pull/2045))
- Add option for disabling parentheses autocompletion ([#1920](https://github.com/SpaceVim/SpaceVim/pull/1920))
- Add Docker build of Neovim and SpaceVim ([#1923](https://github.com/SpaceVim/SpaceVim/pull/1923))
- Add gist manager vim-gista ([#1936](https://github.com/SpaceVim/SpaceVim/pull/1936))
- Add `lang#kotlin` layer ([#1996](https://github.com/SpaceVim/SpaceVim/pull/1996))
- Add `lang#dockerfile` layer ([#2001](https://github.com/SpaceVim/SpaceVim/pull/2001))
- Add `lang#agda` layer ([#1941](https://github.com/SpaceVim/SpaceVim/pull/1941))
- Add `lang#autohotkey` layer ([#2021](https://github.com/SpaceVim/SpaceVim/pull/2021))
- Add `lang#swift` layer ([#2027](https://github.com/SpaceVim/SpaceVim/pull/2027))
- Add `lang#nim` layer ([#2018](https://github.com/SpaceVim/SpaceVim/pull/2018))
- Add `lang#purescript` layer ([#2054](https://github.com/SpaceVim/SpaceVim/pull/2054))
- Add `lang#WebAssembly` layer ([#2068](https://github.com/SpaceVim/SpaceVim/pull/2068))
- Add `lang#erlang` layer ([#2074](https://github.com/SpaceVim/SpaceVim/pull/2074))
- Add `lang#fsharp` layer ([#2081](https://github.com/SpaceVim/SpaceVim/pull/2081))
- Add `lang#plantuml` layer ([#2085](https://github.com/SpaceVim/SpaceVim/pull/2085))
- Add `lang#elm` layer, improve REPL highlight ([#2088](https://github.com/SpaceVim/SpaceVim/pull/2088))

### Improvement

- Improve tab manager ([#1887](https://github.com/SpaceVim/SpaceVim/pull/1887))
- Improve flygep ([#1898](https://github.com/SpaceVim/SpaceVim/pull/1898), [#1961](https://github.com/SpaceVim/SpaceVim/pull/1961), [#1960](https://github.com/SpaceVim/SpaceVim/pull/1960), [#1929](https://github.com/SpaceVim/SpaceVim/pull/1929), [#1802](https://github.com/SpaceVim/SpaceVim/pull/1802))
- Improve plugin manager ([#1962](https://github.com/SpaceVim/SpaceVim/pull/1962))
- Support mouse click in tabline ([#1902](https://github.com/SpaceVim/SpaceVim/pull/1902))
- Add go def function for python ([#1969](https://github.com/SpaceVim/SpaceVim/pull/1969), [#1999](https://github.com/SpaceVim/SpaceVim/pull/1999))
- neovim `+py` and `+py3` support ([#1988](https://github.com/SpaceVim/SpaceVim/pull/1988))
- Improve debug info ([#1991](https://github.com/SpaceVim/SpaceVim/pull/1991))
- Improve `tmux` layer ([#1970](https://github.com/SpaceVim/SpaceVim/pull/1970))
- Improve statusline mode text and color ([#2034](https://github.com/SpaceVim/SpaceVim/pull/2034))
- Improve `lang#perl` layer, add layer doc ([#2041](https://github.com/SpaceVim/SpaceVim/pull/2041))
- Improve `lang#scala` layer, add layer doc ([#2077](https://github.com/SpaceVim/SpaceVim/pull/2077))
- Improve `fzf` layer, add helptags source ([#2047](https://github.com/SpaceVim/SpaceVim/pull/2047))

### Changed

- Allow customization of `vimfiler_quick_look_command` ([#1889](https://github.com/SpaceVim/pull/1889))
- Change `enable_statusline_display_mode` to `enable_statusline_mode` ([#1843](https://github.com/SpaceVim/SpaceVim/pull/1843))
- Recover spell and list option in go layer ([#1872](https://github.com/SpaceVim/SpaceVim/pull/1872))
- Remove textwidth option in autocmd ([#1931](https://github.com/SpaceVim/SpaceVim/pull/1931))
- Reduce number of default plugins ([#1932](https://github.com/SpaceVim/SpaceVim/pull/1932))
- Recover modeline option ([#1992](https://github.com/SpaceVim/SpaceVim/pull/1992))

### Fixed

- Fix open folder by relative path, can not find directory in cdpath ([#1957](https://github.com/SpaceVim/SpaceVim/pull/1957))
- Fix plugins manager, unkown function `term_start` ([#1881](https://github.com/SpaceVim/SpaceVim/pull/1881), [#1880](https://github.com/SpaceVim/SpaceVim/pull/1880))
- Fix project manager, can not find root of project ([#1883](https://github.com/SpaceVim/SpaceVim/pull/1883))
- Fix resume key bindings [#1885](https://github.com/SpaceVim/SpaceVim/pull/1885)
- Fix nerdtree key bindings [#1903](https://github.com/SpaceVim/SpaceVim/pull/1903)
- Fix inactive windows statusline ([#1913](https://github.com/SpaceVim/SpaceVim/pull/1913))
- Fix key binding `SPC f t` ([#1900](https://github.com/SpaceVim/SpaceVim/pull/1900))
- Fix lsp support for haskell, javascript and typescript ([#1894](https://github.com/SpaceVim/SpaceVim/pull/1894))
- can not set `windows_leader` to empty string ([#1990](https://github.com/SpaceVim/SpaceVim/pull/1990))
- Setting 'verbose' flag to positive value breaks mappings guides ([#2017](https://github.com/SpaceVim/SpaceVim/pull/2017))
- Fix whitespace toggle ([#2032](https://github.com/SpaceVim/SpaceVim/pull/2032))
- Fix Unknown function: TSOnBufEnter for nvim-typescript ([#2062](https://github.com/SpaceVim/SpaceVim/pull/2062))
- Fix icon in windows ([#2082](https://github.com/SpaceVim/SpaceVim/pull/2082))
- Fix toggle highlight tail spaces ([#2080](https://github.com/SpaceVim/SpaceVim/pull/2080))

### Removed

### Doc, Wiki && Website

- Update version to v0.9.0-dev ([#1842](https://github.com/SpaceVim/SpaceVim/pull/1842))
- Update faq for why using toml ([#1838](https://github.com/SpaceVim/SpaceVim/pull/1838))
- Update faq for using SpaceVim without overwrite vimrc ([#1848](https://github.com/SpaceVim/SpaceVim/pull/1848))
- Improve pull request template ([#1852](https://github.com/SpaceVim/SpaceVim/pull/1852))
- Update layer page ([#1860](https://github.com/SpaceVim/SpaceVim/pull/1860), [#2930](https://github.com/SpaceVim/SpaceVim/pull/1930))
- Update javascript layer doc ([#1884](https://github.com/SpaceVim/SpaceVim/pull/1884))
- Change disqua to gitment ([#1904](https://github.com/SpaceVim/SpaceVim/pull/1904), [#1905](https://github.com/SpaceVim/SpaceVim/pull/1905), [#1906](https://github.com/SpaceVim/SpaceVim/pull/1906), [#1907](https://github.com/SpaceVim/SpaceVim/pull/1907), [#1908](https://github.com/SpaceVim/SpaceVim/pull/1908))
- Add post about meetup in HangZhou ([#1875](https://github.com/SpaceVim/SpaceVim/pull/1875))
- Update doc for disable plugin ([#1951](https://github.com/SpaceVim/SpaceVim/pull/1951))
- Update readme ([#1924](https://github.com/SpaceVim/SpaceVim/pull/1924), [#1895](https://github.com/SpaceVim/SpaceVim/pull/1895))
- Update post time location ([#1916](https://github.com/SpaceVim/SpaceVim/pull/1916))
- Type ([#1915](https://github.com/SpaceVim/SpaceVim/pull/1915), [#1914](https://github.com/SpaceVim/SpaceVim/pull/1914))
- Add api doc ([#1896](https://github.com/SpaceVim/SpaceVim/pull/1896))
- Update follow HEAD ([#1886](https://github.com/SpaceVim/SpaceVim/pull/1886), [#1953](https://github.com/SpaceVim/SpaceVim/pull/1953))
- Update doc for bootstrap function ([#1980](https://github.com/SpaceVim/SpaceVim/pull/1980))
- Update doc for debug upstream plugins ([#1981](https://github.com/SpaceVim/SpaceVim/pull/1981))
- Update doc windows key bindings ([#1995](https://github.com/SpaceVim/SpaceVim/pull/1995))
- Add doc for `lang#rust` layer ([#2052](https://github.com/SpaceVim/SpaceVim/pull/2052))
- Add doc for `sudo` layer ([#2011](https://github.com/SpaceVim/SpaceVim/pull/2011))
- Update key notations ([#1940](https://github.com/SpaceVim/SpaceVim/pull/1940))
- Update getting help page in wiki ([#2025](https://github.com/SpaceVim/SpaceVim/pull/2025))

### Others

- Fix ci lint ([#1946](https://github.com/SpaceVim/SpaceVim/pull/1946), [#1945](https://github.com/SpaceVim/SpaceVim/pull/1945), [#1944](https://github.com/SpaceVim/SpaceVim/pull/1944), [#1942](https://github.com/SpaceVim/SpaceVim/pull/1942))
- Add todo manager for SpaceVim development ([#1939](https://github.com/SpaceVim/SpaceVim/pull/1939))
- Add code owner for javascript layer ([#2003](https://github.com/SpaceVim/SpaceVim/pull/2003), [#2009](https://github.com/SpaceVim/SpaceVim/pull/2009))

## Latest Release

SpaceVim releases v0.8.0 at 2018-06-18, please check the
[release page](https://spacevim.org/SpaceVim-release-v0.8.0/) for all the details
