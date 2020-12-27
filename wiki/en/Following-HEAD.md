This page documents changes in master branch since last release v1.5.0

## PreRelease

The next release is v1.6.0:

### Pull Requests

<!-- call SpaceVim#dev#followHEAD#update('en') -->
<!-- SpaceVim follow HEAD en start -->

#### New Features

- Add: documentation for LangSPCGroupName and LangSPC [#4012](https://github.com/SpaceVim/SpaceVim/pull/4012)
- Add vimdoc support in lang#vim layer [#4010](https://github.com/SpaceVim/SpaceVim/pull/4010)
- Add colorscheme template for one [#3999](https://github.com/SpaceVim/SpaceVim/pull/3999)
- Add: one colorscheme palette for light background [#3997](https://github.com/SpaceVim/SpaceVim/pull/3997)
- add lang#sml layer [#3972](https://github.com/SpaceVim/SpaceVim/pull/3972)
- Add test command in zig language plugin [#3970](https://github.com/SpaceVim/SpaceVim/pull/3970)
- Add: introduce splitjoin [#3956](https://github.com/SpaceVim/SpaceVim/pull/3956)
- Add: Support auto_completion_complete_with_key_sequence for coc completion [#3939](https://github.com/SpaceVim/SpaceVim/pull/3939)
- Add: Introduce LSP CodeActions for php and javascript [#3937](https://github.com/SpaceVim/SpaceVim/pull/3937)
- Add: random-candidates for colorscheme layer [#3671](https://github.com/SpaceVim/SpaceVim/pull/3671)
- Add: Spacevim#custom#LangSPC and SpaceVim#custom#LangSPCGroupName [#3260](https://github.com/SpaceVim/SpaceVim/pull/3260)
- Add: custom register language specific mapping function [#2868](https://github.com/SpaceVim/SpaceVim/pull/2868)

#### Feature Changes

- Change fortran indent file format [#3975](https://github.com/SpaceVim/SpaceVim/pull/3975)

#### Bug Fixs

- fix(ctrlp): invocation of printf() had the wrong number of arguments [#4014](https://github.com/SpaceVim/SpaceVim/pull/4014)
- Fix code runner [#4011](https://github.com/SpaceVim/SpaceVim/pull/4011)
- Fix unknown function gtags#update [#4009](https://github.com/SpaceVim/SpaceVim/pull/4009)
- Fix wrong valuable name [#4008](https://github.com/SpaceVim/SpaceVim/pull/4008)
- Fix compare error [#4001](https://github.com/SpaceVim/SpaceVim/pull/4001)
- Fix typos [#4000](https://github.com/SpaceVim/SpaceVim/pull/4000)
- fix(vim-jsx-typescript): remove blank line that was throwing an error [#3998](https://github.com/SpaceVim/SpaceVim/pull/3998)
- Fix vim iskeyword option [#3990](https://github.com/SpaceVim/SpaceVim/pull/3990)
- Fix: ctrlp default root patterns [#3978](https://github.com/SpaceVim/SpaceVim/pull/3978)
- Fix gitstatus not shown in defx [#3973](https://github.com/SpaceVim/SpaceVim/pull/3973)
- fixed tagbar from finding and using bash.exe under windows [#3964](https://github.com/SpaceVim/SpaceVim/pull/3964)
- Fix CtrlP that uses grep for OSX [#3955](https://github.com/SpaceVim/SpaceVim/pull/3955)
- Fix OmniSharpFindType to OmniSharpTypeLookup [#3628](https://github.com/SpaceVim/SpaceVim/pull/3628)
- fix Leaderf neoyank. [#3541](https://github.com/SpaceVim/SpaceVim/pull/3541)
- Fix projectmanager from finding ~/SpaceVim.d in home directory on windows [#3489](https://github.com/SpaceVim/SpaceVim/pull/3489)
- Fix load config [#3064](https://github.com/SpaceVim/SpaceVim/pull/3064)

#### Unmarked PRs

- Update detach_plugin.sh [#4018](https://github.com/SpaceVim/SpaceVim/pull/4018)
- Ignore .git for rg searches [#3996](https://github.com/SpaceVim/SpaceVim/pull/3996)
- Improve tsx support [#3993](https://github.com/SpaceVim/SpaceVim/pull/3993)
- Doc for reinstalling plugins [#3992](https://github.com/SpaceVim/SpaceVim/pull/3992)
- Update language guide [#3986](https://github.com/SpaceVim/SpaceVim/pull/3986)
- Update faq [#3984](https://github.com/SpaceVim/SpaceVim/pull/3984)
- Update doc for key binding SPC f Y [#3983](https://github.com/SpaceVim/SpaceVim/pull/3983)
- Improve ctags database manager [#3981](https://github.com/SpaceVim/SpaceVim/pull/3981)
- Remove useless php plugin [#3979](https://github.com/SpaceVim/SpaceVim/pull/3979)
- Update doc for lang#sml layer [#3977](https://github.com/SpaceVim/SpaceVim/pull/3977)
- preserve g:indentLine_fileTypeExclude setting in layers/ui.vim [#3961](https://github.com/SpaceVim/SpaceVim/pull/3961)
- Improve java layer [#3954](https://github.com/SpaceVim/SpaceVim/pull/3954)
- Doc: add documentation for expand-region key bindings [#3952](https://github.com/SpaceVim/SpaceVim/pull/3952)
- Improve typescript support [#3948](https://github.com/SpaceVim/SpaceVim/pull/3948)
- Improve python support [#3947](https://github.com/SpaceVim/SpaceVim/pull/3947)
- Update doc [#3942](https://github.com/SpaceVim/SpaceVim/pull/3942)
- Update doc for SPC f / [#3935](https://github.com/SpaceVim/SpaceVim/pull/3935)
- Update doc for statusline [#3665](https://github.com/SpaceVim/SpaceVim/pull/3665)
- Update lang#asciidoc layer [#3556](https://github.com/SpaceVim/SpaceVim/pull/3556)
- Update g map [#3496](https://github.com/SpaceVim/SpaceVim/pull/3496)
- Doc: type in doc [#3488](https://github.com/SpaceVim/SpaceVim/pull/3488)
- Update file head [#3379](https://github.com/SpaceVim/SpaceVim/pull/3379)
- Improve terminal support [#3318](https://github.com/SpaceVim/SpaceVim/pull/3318)
- feat: optional support of vim-devicons [#3271](https://github.com/SpaceVim/SpaceVim/pull/3271)
- Create mirror [#3195](https://github.com/SpaceVim/SpaceVim/pull/3195)
- Update Common Lisp support [#3107](https://github.com/SpaceVim/SpaceVim/pull/3107)
- Cache major mode [#3076](https://github.com/SpaceVim/SpaceVim/pull/3076)

<!-- SpaceVim follow HEAD en end -->

## Latest Release

SpaceVim releases v1.5.0 at 2020-08-01, please check the release page:

- [SpaceVim releases v1.5.0](https://spacevim.org/SpaceVim-release-v1.5.0/) for all the details
