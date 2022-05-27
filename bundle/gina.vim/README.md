# 👣 gina.vim

![Version 1.0](https://img.shields.io/badge/version-1.0-yellow.svg)
![Support Vim 8.1 or above](https://img.shields.io/badge/support-Vim%208.1%20or%20above-yellowgreen.svg)
![Support Neovim 0.4 or above](https://img.shields.io/badge/support-Neovim%200.4%20or%20above-yellowgreen.svg)
![Support Git 2.25 or above](https://img.shields.io/badge/support-Git%202.25%20or%20above-green.svg)
[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Doc](https://img.shields.io/badge/doc-%3Ah%20gina-orange.svg)](doc/gina.txt)
[![Doc (dev)](https://img.shields.io/badge/doc-%3Ah%20gina--develop-orange.svg)](doc/gina-develop.txt)

[![reviewdog](https://github.com/lambdalisue/gina.vim/workflows/reviewdog/badge.svg)](https://github.com/lambdalisue/gina.vim/actions?query=workflow%3Areviewdog)
[![vim](https://github.com/lambdalisue/gina.vim/workflows/vim/badge.svg)](https://github.com/lambdalisue/gina.vim/actions?query=workflow%3Avim)
[![neovim](https://github.com/lambdalisue/gina.vim/workflows/neovim/badge.svg)](https://github.com/lambdalisue/gina.vim/actions?query=workflow%3Aneovim)

gina.vim (gina) is a plugin to asynchronously control git repositories.

## Presentation

[![You've been Super Viman. After this talk, you could say you are Super Viman 2 -- Life with gina.vim](https://img.youtube.com/vi/zkANQ9l7YDM/0.jpg)](https://www.youtube.com/watch?v=zkANQ9l7YDM)

I've talked about what the gina.vim is in [VimConf2017](http://vimconf.vim-jp.org/2017/) ([Slide](https://lambdalisue.github.io/vimconf2017/assets/player/KeynoteDHTMLPlayer.html)). Check it out if you would like to feel what the gina.vim is.

## Usage

The following is a schematic image of general working-flow with gina.

```
   ┌─────┬──────────┐
   │     │          │
#DIRTY#  │          ▼
   ▲     │    :Gina status  │ <<  : stage
   │     │          │       │ >>  : unstage
   │     │          │       │ --  : toggle
:write   │       #STAGED#   │ ==  : discard
   ▲     │          │       │ pp  : patch
   │     ├──────────┤       │ dd  : diff
   │     │          ▼
#CLEAN#  │     :Gina commit │ !   : switch --amend
   │     │          │       │ :w  : save cache
   │     ▼          │       │ :q  : commit changes (confirm)
   └────────────────┘       │ :wq : commit changes (immediate)
```

So basically user would

1. Edit contents in a git repository
2. Stage changes with `:Gina status`
3. Commit changes with `:Gina commit`

See `:h gina-usage` for advance usage. Gina provides a lot more features.

## Pros.

- A git detection is fast and accurate
  - It does not require `git` process so incredibly fast
  - Used in [lambdalisue/vim-gita][], for several years
- Commands are asynchronously performed
  - Users don't have to wait `:Gina push` (`git push`)
  - Asynchronous feature in Neovim is great. `:Gina log` (`git log`) on **Linux** repository won't freeze Neovim
- Single command. Users do not need to remember tons of commands
  - `:Gina {command}` will execute a gina command or a git raw command asynchronously
  - `:Gina! {command}` will execute a git raw command asynchronously
  - `:Gina!! {command}` will execute a git raw command in a shell (mainly for `:Gina!! add -p` or `:Gina!! rebase -i`)
- Action based. Users do not need to remember tons of mappings
  - `?` to see the help
  - `a` to select an action to perform (complete with `<Tab>`)
  - `.` to repeat previous action
  - All action can map to an actual keymap
- Author tried to follow Vim's flavor
  - No mapping for `ee` or whatever which conflicts with Vim's native mappings (like vim-gita does...)
- Customizable
  - Users can define action aliases and mappings
  - Users can define default options and aliases of command
  - More
- Tested on all major platforms
  - Powered by [vim-jp/vital.vim][], mean that the things are unit tested
  - Gina add some behaviour test as well

[lambdalisue/vim-gita]: https://github.com/lambdalisue/vim-gita
[vim-jp/vital.vim]: https://github.com/vim-jp/vital.vim

## Contribution

Any contribution including documentations are welcome.

Contributers should install [thinca/vim-themis][] to run tests before sending a PR if they applied some modification to the code.
PRs which does not pass tests won't be accepted.

[thinca/vim-themis]: https://github.com/thinca/vim-themis

## License

The code in gina.vim follows MIT license texted in [LICENSE](./LICENSE).
Contributors need to agree that any modifications sent in this repository follow the license.
