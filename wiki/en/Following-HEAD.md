This page documents changes in master branch since last release v0.8.0

## PreRelease

The next release is v0.9.0.

### Added

- Add material theme ([#1833](https://github.com/SpaceVim/SpaceVim/pull/1833))
- Add floobits layer ([#1697](https://github.com/SpaceVim/SpaceVim/pull/1697))
- Add `SPC b b ` key binding in fzf layer ([#1725](https://github.com/SpaceVim/SpaceVim/pull/1725))
- Add test for toml, number, file, icon and highlight API ([#1849](https://github.com/SpaceVim/SpaceVim/pull/1849))
- Add lsp support for julia ([#1850](https://github.com/SpaceVim/SpaceVim/pull/1850))
- Add lsp support for typescript ([#1870](https://github.com/SpaceVim/SpaceVim/pull/1870))
- Add option for disabling parentheses autocompletion ([#1920](https://github.com/SpaceVim/SpaceVim/pull/1920))
- Add Docker build of Neovim and SpaceVim ([#1923](https://github.com/SpaceVim/SpaceVim/pull/1923))
- Add gist manager vim-gista ([#1936](https://github.com/SpaceVim/SpaceVim/pull/1936))

### Improvement

- Improve tab manager ([#1887](https://github.com/SpaceVim/SpaceVim/pull/1887))
- Improve flygep ([#1898](https://github.com/SpaceVim/SpaceVim/pull/1898), [#1961](https://github.com/SpaceVim/SpaceVim/pull/1961), [#1960](https://github.com/SpaceVim/SpaceVim/pull/1960), [#1929](https://github.com/SpaceVim/SpaceVim/pull/1929), [#1802](https://github.com/SpaceVim/SpaceVim/pull/1802))
- Improve plugin manager ([#1962](https://github.com/SpaceVim/SpaceVim/pull/1962))
- Support mouse click in tabline ([#1902](https://github.com/SpaceVim/SpaceVim/pull/1902))
- Add go def function for python ([#1969](https://github.com/SpaceVim/SpaceVim/pull/1969))
- neovim +py and +py3 support ([#1988](https://github.com/SpaceVim/SpaceVim/pull/1988))
- Improve debug info ([#1991](https://github.com/SpaceVim/SpaceVim/pull/1991))

### Changed

- Allow customization of `vimfiler_quick_look_command` ([#1889](https://github.com/SpaceVim/pull/1889))
- Change the option name `enable_statusline_display_mode` to `enable_statusline_mode` ([#1843](https://github.com/SpaceVim/SpaceVim/pull/1843))
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

### Others

- Fix ci lint ([#1946](https://github.com/SpaceVim/SpaceVim/pull/1946), [#1945](https://github.com/SpaceVim/SpaceVim/pull/1945), [#1944](https://github.com/SpaceVim/SpaceVim/pull/1944), [#1942](https://github.com/SpaceVim/SpaceVim/pull/1942))
- Add todo manager for SpaceVim development ([#1939](https://github.com/SpaceVim/SpaceVim/pull/1939))

## Latest Release

SpaceVim releases v0.8.0 at 2018-06-18, please check the
[release page](https://spacevim.org/SpaceVim-release-v0.8.0/) for all the details
