This page documents changes in master branch since last release v1.8.0

## PreRelease

The next release is v1.9.0:

### Pull Requests

<!-- call SpaceVim#dev#followHEAD#update('en') -->
<!-- SpaceVim follow HEAD en start -->

#### New Features

- be7d6130 feat(logger): add syntax highlighting for runtime log
- 1ff40354 feat(help): add help description for `SPC b d`
- 93d8a153 feat(ssh): change ssh tab name to SSH(user@ip:port)
- cefb3756 feat(mail): add function to view mail context
- 6adb53df feat(mail): improve vim-mail plugin
- 5ec1b3be feat(mail): add login & password option
- 31ab74f8 feat(mail): add mail layer option
- fa43ef20 feat(mail): use bundle vim-mail
- 04e4b3d1 feat(format): add vim-codefmt support
- 83aa15f1 feat(edit): support fullwidth vertical bar
- 3f872452 feat(ssh): add `ssh` layer
- 5c68676c feat(lang#go): add lsp support for golang
- 5f4b6798 feat(git): add omnifunc for git commit buffer
- 2b40c524 feat(lang#julia): add lsp key bindings for julia
- da40455f feat(lang#rust): add more lsp key bindings for rust
- 773aa07b feat(lang#javascript): add more lsp key bindings
- 6ad6022d feat(unicode#box, lsp): improve drawing_box() && workspace viewer
- cc73d9dd feat(lsp): add vim-language-server command
- 5b76a80c feat(lsp): use `unicode#box` api to display workspace list
- 35bdf0da feat(lsp): make SPC e c support to clear diagnostics
- aa3deb1f feat(lang#python): add `g D` to jump type definition
- 309728bc feat(lang#python): add more lsp key bindings
- 55365f64 feat(`checkers`): support lsp diagnostic jumping
- c6156bf7 feat(`lang#vim`): add workspace related key bindings
- e8a75bc7 feat(`lang#vim`): add `SPC l s` key binding
- 9d374eaa feat(`lang#vim`): add `SPC l x` key binding
- 22b663b5 feat(layer): add `treesitter` layer
- da18ba0a feat(lsp): add neovim-lsp (#4319)
- 516e0525 feat(core): update to v1.9.0-dev

#### Bug Fixs

- 4a2e19fa fix(windisk): fix `s:open_disk` function
- 5d9a0975 fix(lang#python): fix typo in coverage key bindings
- 41740374 fix(chat): fix message handler
- 7b77ec76 fix(chat): fix close windows key binding
- 18dd27e2 fix(chat): fix server database path
- 7797732b fix(chat): fix chatting server port
- cf1b82ef fix(chat): include test files
- 17aac814 fix(mail): fix date format
- 1cc4282c fix(mail): fix mail logger
- 66b253e9 fix(core): fix neovim-qt welcome page
- 7f0b6651 fix(core): fix parser_argv function
- a41fc80e fix(ssh): fix layer test
- cf9b7c08 fix(flygrep): save previous windows id
- 0d2f9082 fix(lang#c): fix `clang_std` option
- 63c2bbf5 fix(flygrep): fix replace mode of flygrep
- 1127b6aa fix(bundle): fix bundle ident-blacnkline
- 53e2a5cd fix(colorscheme): fix VertSplit highlight of colorscheme `one`
- 4e0f3529 fix(lang#lua): fix unknown variable
- a7bedbc5 fix(flygrep): fix flygrep replace mode with grep command
- 82d36bb8 fix(lsp): avoid unknown function error
- 6767f4da fix(checkers): clear lsp diagnostics for normal buffer
- c32aa6f2 fix(`lsp`): fix lsp support in nvim
- 43fc0e8d fix(lang#vim): fix `lang#vim` layer key bindings
- 57211cc4 fix(treesitter): fix layer test
<!-- SpaceVim follow HEAD en end -->

## Latest Release

SpaceVim releases v1.8.0 at 2021-10-04, please check the release page:

- [SpaceVim releases v1.8.0](https://spacevim.org/SpaceVim-release-v1.8.0/) for all the details
