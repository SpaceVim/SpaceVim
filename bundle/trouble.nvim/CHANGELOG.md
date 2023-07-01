# Changelog

## [2.3.0](https://github.com/folke/trouble.nvim/compare/v2.2.3...v2.3.0) (2023-05-25)


### Features

* filter diagnostics by severity level ([#285](https://github.com/folke/trouble.nvim/issues/285)) ([b1f607f](https://github.com/folke/trouble.nvim/commit/b1f607ff0f2c107faf8b0c26d09877028b549d63))

## [2.2.3](https://github.com/folke/trouble.nvim/compare/v2.2.2...v2.2.3) (2023-05-22)


### Bug Fixes

* set window options locally ([#282](https://github.com/folke/trouble.nvim/issues/282)) ([a5649c9](https://github.com/folke/trouble.nvim/commit/a5649c9a60d7c5aa2fed1781057af3f29b10f167))

## [2.2.2](https://github.com/folke/trouble.nvim/compare/v2.2.1...v2.2.2) (2023-04-17)


### Bug Fixes

* **util:** auto_jump when trouble is open. Fixes [#144](https://github.com/folke/trouble.nvim/issues/144) ([e4f1623](https://github.com/folke/trouble.nvim/commit/e4f1623b51e18eb4e2835446e50886062c339f80))
* **util:** save position in jump list before jump. Fixes [#143](https://github.com/folke/trouble.nvim/issues/143) Fixes [#235](https://github.com/folke/trouble.nvim/issues/235) ([f0477b0](https://github.com/folke/trouble.nvim/commit/f0477b0e78d9a16ff326e356235876ff3f87882d))

## [2.2.1](https://github.com/folke/trouble.nvim/compare/v2.2.0...v2.2.1) (2023-03-26)


### Bug Fixes

* **icons:** fixed deprecated icons with nerdfix ([39db399](https://github.com/folke/trouble.nvim/commit/39db3994c8de87b0b5ca7a4d3d415926f201f1fc))

## [2.2.0](https://github.com/folke/trouble.nvim/compare/v2.1.1...v2.2.0) (2023-02-28)


### Features

* enable looping during next/prev ([#232](https://github.com/folke/trouble.nvim/issues/232)) ([fc4c0f8](https://github.com/folke/trouble.nvim/commit/fc4c0f82c9181f3c27a4cbdd5db97c110fd78ee9))
* expose renderer.signs. Fixes [#252](https://github.com/folke/trouble.nvim/issues/252) ([5581e73](https://github.com/folke/trouble.nvim/commit/5581e736c8afc8b227ad958ded1929c8a39f049e))

## [2.1.1](https://github.com/folke/trouble.nvim/compare/v2.1.0...v2.1.1) (2023-02-19)


### Bug Fixes

* ensure that the diagnostic parameters are complete ([#179](https://github.com/folke/trouble.nvim/issues/179)) ([210969f](https://github.com/folke/trouble.nvim/commit/210969fce79e7d11554c61bca263d7e1ac77bde0))
* icorrect row/line in diagnostics. Fixes [#264](https://github.com/folke/trouble.nvim/issues/264) ([32fa4ed](https://github.com/folke/trouble.nvim/commit/32fa4ed742fc91f3075c98edd3c131b716b9d782))

## [2.1.0](https://github.com/folke/trouble.nvim/compare/v2.0.1...v2.1.0) (2023-02-18)


### Features

* expose `require("trouble").is_open()` ([2eb27b3](https://github.com/folke/trouble.nvim/commit/2eb27b34442894e903fdc6e01edea6d7c476be63))

## [2.0.1](https://github.com/folke/trouble.nvim/compare/v2.0.0...v2.0.1) (2023-02-16)


### Bug Fixes

* **init:** version check ([73eea32](https://github.com/folke/trouble.nvim/commit/73eea32efec2056cdce7593787390fc9aadf9c0c))

## [2.0.0](https://github.com/folke/trouble.nvim/compare/v1.0.2...v2.0.0) (2023-02-16)


### ⚠ BREAKING CHANGES

* Trouble now requires Neovim >= 0.7.2

### Features

* Trouble now requires Neovim &gt;= 0.7.2 ([ef93259](https://github.com/folke/trouble.nvim/commit/ef9325970b341d436f43c50ce876aa0a665d3cf0))


### Bug Fixes

* Focus parent before closing ([#259](https://github.com/folke/trouble.nvim/issues/259)) ([66b057b](https://github.com/folke/trouble.nvim/commit/66b057b2b07881bceb969624f4c3b5727703c2c8))
* **preview:** properly load buffer when showing preview ([949199a](https://github.com/folke/trouble.nvim/commit/949199a9ac60ce784a417f90388b8f173ef53819))
* **util:** properly load a buffer when jumping to it ([bf0eeea](https://github.com/folke/trouble.nvim/commit/bf0eeead88d59d51003f4da1b649b4977ed90e2b))


### Performance Improvements

* dont load buffers when processing items. Get line with luv instead ([82c9a9a](https://github.com/folke/trouble.nvim/commit/82c9a9a9cd2cd2cdb05e05a3e6538529e2473e14))

## [1.0.2](https://github.com/folke/trouble.nvim/compare/v1.0.1...v1.0.2) (2023-02-10)


### Bug Fixes

* **telescope:** properly fix issue with relative filenames in telescope. See [#250](https://github.com/folke/trouble.nvim/issues/250) ([7da0821](https://github.com/folke/trouble.nvim/commit/7da0821d20342751a7eedecd28cf16040146cbf7))

## [1.0.1](https://github.com/folke/trouble.nvim/compare/v1.0.0...v1.0.1) (2023-01-23)


### Bug Fixes

* ensure first line is selected when padding is false ([#233](https://github.com/folke/trouble.nvim/issues/233)) ([b2d6ac8](https://github.com/folke/trouble.nvim/commit/b2d6ac8607e1ab612a85c1ec563aaff3a60f0603))
* **telescope:** correctly use cwd for files. Fixes [#250](https://github.com/folke/trouble.nvim/issues/250) ([3174767](https://github.com/folke/trouble.nvim/commit/3174767c61b3786e65d78f539c60c6f70d26cdbe))

## 1.0.0 (2023-01-04)


### ⚠ BREAKING CHANGES

* renamed use_lsp_diagnostic_signs to use_diagnostic_signs
* removed deprecated commands

### Features

* added "hover" action that defaults to "K" to show the full multiline text [#11](https://github.com/folke/trouble.nvim/issues/11) ([9111a5e](https://github.com/folke/trouble.nvim/commit/9111a5eb7881a84cd66107077118614e218fba61))
* added actions for opening in new tab, split and vsplit. Fixes [#36](https://github.com/folke/trouble.nvim/issues/36) ([c94cc59](https://github.com/folke/trouble.nvim/commit/c94cc599badb7086878559653ec705ed68579682))
* added mapping for jump & close (defaults to "o") [#15](https://github.com/folke/trouble.nvim/issues/15) ([09de784](https://github.com/folke/trouble.nvim/commit/09de78495bad194b2d0d85498a1c1a7996182a71))
* added support for vim.diagnostics and Neovim 0.7 ([735dcd5](https://github.com/folke/trouble.nvim/commit/735dcd599871179a835d1e0ebd777d4db24c2c72))
* allow proper passing of plugin options ([79513ed](https://github.com/folke/trouble.nvim/commit/79513ed42a273a1bc80d82c7e1117d3a2e0f2c79))
* Api to go to first and last items ([#157](https://github.com/folke/trouble.nvim/issues/157)) ([0649811](https://github.com/folke/trouble.nvim/commit/0649811e69a11dea4708a19deee9ab0b1e90313e))
* better preview and mode ([160fa6c](https://github.com/folke/trouble.nvim/commit/160fa6cb213db6c7a421450b67adc495ae69cef0))
* command complete ([9923b01](https://github.com/folke/trouble.nvim/commit/9923b01692a238535420d58e440b139a89c3de46))
* comments to open/toggle workspace or ducument mode directly ([f7db1c2](https://github.com/folke/trouble.nvim/commit/f7db1c29d7eb76cb3310e0aa56a4d546420e7814))
* config for auto_preview ([0ad97fb](https://github.com/folke/trouble.nvim/commit/0ad97fb67b21579729090214cbb3bce78fd153b7))
* define multiple keybindings for the same action (better for defaults) ([bf8e8ee](https://github.com/folke/trouble.nvim/commit/bf8e8ee63c38103fb42de0b889810b584e378962))
* expose items ([#41](https://github.com/folke/trouble.nvim/issues/41)) ([4f84ca4](https://github.com/folke/trouble.nvim/commit/4f84ca4530829b9448c6f13530c26df6d7020fd0))
* indent lines ([f9e6930](https://github.com/folke/trouble.nvim/commit/f9e6930b5188593b9e6408d8937093d04198e90a))
* inital version ([980fb07](https://github.com/folke/trouble.nvim/commit/980fb07fd33ea0f72b274e1ad3c8626bf8a14ac9))
* Lsp implementation ([#50](https://github.com/folke/trouble.nvim/issues/50)) ([069cdae](https://github.com/folke/trouble.nvim/commit/069cdae61d58d2477b150af91692ace636000d47))
* lsp references, loclist and quickfix lists! ([0b852c8](https://github.com/folke/trouble.nvim/commit/0b852c8418d65191983b2c9b8f90ad6d7f45ff51))
* made it easier to integrate with trouble ([1dd72c2](https://github.com/folke/trouble.nvim/commit/1dd72c22403519c160b0c694762091971bcf191e))
* make file grouping and padding configurable ([#66](https://github.com/folke/trouble.nvim/issues/66)) ([ff40475](https://github.com/folke/trouble.nvim/commit/ff40475143ecd40c86f13054935f3afc5653c469))
* make position of the trouble list configurable (top, bottom, left or right) [#27](https://github.com/folke/trouble.nvim/issues/27) ([0c9ca5e](https://github.com/folke/trouble.nvim/commit/0c9ca5e10c2e5dd8d8479e864e12383b1d614273))
* make signs configurable ([ff9fd51](https://github.com/folke/trouble.nvim/commit/ff9fd51ab05398c83c2a0b384999d49269d95572))
* make sorting keys configurable ([#190](https://github.com/folke/trouble.nvim/issues/190)) ([68d3dc5](https://github.com/folke/trouble.nvim/commit/68d3dc52fe49375fe556af69d1e91e0a88b67935))
* next/previous API. Implements [#44](https://github.com/folke/trouble.nvim/issues/44) ([a2a7dbf](https://github.com/folke/trouble.nvim/commit/a2a7dbfefc5ebdf1a9c1d37e9df1d26a3b13c1cd))
* option to automatically jump when there is only one result (fixes [#57](https://github.com/folke/trouble.nvim/issues/57)) ([#79](https://github.com/folke/trouble.nvim/issues/79)) ([09fafb2](https://github.com/folke/trouble.nvim/commit/09fafb2e01fbaa4fe6ecede10a7e7a738464deba))
* **providers.lsp:** Add definitions support  ([#20](https://github.com/folke/trouble.nvim/issues/20)) ([a951198](https://github.com/folke/trouble.nvim/commit/a95119893c8dfd4b4bed42da97d601c25c7a495f))
* sort files by current directory and prefer non-hidden ([ea9a5e3](https://github.com/folke/trouble.nvim/commit/ea9a5e331b70cf4011081c951015033f0079a0cc))
* sort items by severity / filename / lnum / col ([4a45782](https://github.com/folke/trouble.nvim/commit/4a45782db943f95500b61ffce187bf4cada954ae))
* sort results by row and column isntead of just row ([#118](https://github.com/folke/trouble.nvim/issues/118)) ([5897b09](https://github.com/folke/trouble.nvim/commit/5897b09933731298382e86a5cf4d1a4861630873))
* **telescope provider:** (Smart) multiselect ([#39](https://github.com/folke/trouble.nvim/issues/39)) ([45ff198](https://github.com/folke/trouble.nvim/commit/45ff198f4d436d256f02b14db9c817024c7fc85c))
* Telescope support ([9c81e16](https://github.com/folke/trouble.nvim/commit/9c81e16adec697ffd0b694eb86e14cfee453917d))
* use vim.notify for logging ([293118e](https://github.com/folke/trouble.nvim/commit/293118e195639c373a6a744621b9341e5e18f6e4))


### Bug Fixes

* Add nowait option to keymap ([#30](https://github.com/folke/trouble.nvim/issues/30)) ([4375f1f](https://github.com/folke/trouble.nvim/commit/4375f1f0b2457fcbb91d32de457e6e3b3bb7eba7))
* added additional space between message and code ([aae12e7](https://github.com/folke/trouble.nvim/commit/aae12e7b23b3a2b8337ec5b1d6b7b4317aa3929b))
* added compatibility to retrieve signs from vim.diagnostic ([dab82ef](https://github.com/folke/trouble.nvim/commit/dab82ef0f39893f50908881fdc5e96bfb1578ba1))
* added suport for vim.diagnostic hl groups ([d25a8e6](https://github.com/folke/trouble.nvim/commit/d25a8e6779462127fb227397fa92b07bced8a6fe))
* added support for new handler signatures (backward compatible with 0.5) ([87cae94](https://github.com/folke/trouble.nvim/commit/87cae946aee4798bee621ea6108224c08c218d69))
* auto_open was broken. Fixed now [#29](https://github.com/folke/trouble.nvim/issues/29) ([a2f2b92](https://github.com/folke/trouble.nvim/commit/a2f2b9248bed41522d8caa3a7e9932981c4087ec))
* better detection of the parent window ([4c5fd8a](https://github.com/folke/trouble.nvim/commit/4c5fd8abaf6058312ebe52f662ca002bf0aa9f77))
* default to current window in jump_to_item ([#175](https://github.com/folke/trouble.nvim/issues/175)) ([ec24219](https://github.com/folke/trouble.nvim/commit/ec242197b1f72cabe17dfd61119c896f58bda672))
* don't "edit" en existing buffer. Use "buffer" instead. ([#5](https://github.com/folke/trouble.nvim/issues/5), [#6](https://github.com/folke/trouble.nvim/issues/6)) ([abef115](https://github.com/folke/trouble.nvim/commit/abef1158c0ff236333f67f9f091e5d9ae67d6a89))
* don't steal focus on auto_open. Fixes [#48](https://github.com/folke/trouble.nvim/issues/48) ([36b6813](https://github.com/folke/trouble.nvim/commit/36b6813a2103d85b469a61721b030903ddd8b3b3))
* don't try to fetch sign for "other" ([5b50990](https://github.com/folke/trouble.nvim/commit/5b509904f8865bea7d09b7a686e139077a2484c6))
* don't use file sorter for items without a valid filename ([20469be](https://github.com/folke/trouble.nvim/commit/20469be985143d024c460d95326ebeff9971d714))
* dont advance two items at a time. Fixes https://github.com/folke/todo-comments.nvim/issues/39 ([7de8bc4](https://github.com/folke/trouble.nvim/commit/7de8bc46164ec1f787dee34b6843b61251b1ea91))
* files without col/row should be set to col=1 and row=1 [#22](https://github.com/folke/trouble.nvim/issues/22) ([fcd5f1f](https://github.com/folke/trouble.nvim/commit/fcd5f1fc035ee3d9832c63a307247c09f25c9cd1))
* filetype set too early ([#230](https://github.com/folke/trouble.nvim/issues/230)) ([c4da921](https://github.com/folke/trouble.nvim/commit/c4da921ba613aa6d6659dc18edc204c37e4b8833))
* fixed auto_open swicth_to_parent. Fixes [#7](https://github.com/folke/trouble.nvim/issues/7) ([7cf1aa1](https://github.com/folke/trouble.nvim/commit/7cf1aa1195245d3098097bc3a2510dc358c87363))
* give focus back to correct window when closing ([#72](https://github.com/folke/trouble.nvim/issues/72)) ([a736b8d](https://github.com/folke/trouble.nvim/commit/a736b8db9f49b8b49ac96fbab7f8e396032cfa37))
* handle normal api calls to trouble as it should [#42](https://github.com/folke/trouble.nvim/issues/42) ([52b875d](https://github.com/folke/trouble.nvim/commit/52b875d1aaf88f32e9f070a0119190c3e65b51a5))
* if grouping is off, decrease indent ([#140](https://github.com/folke/trouble.nvim/issues/140)) ([ed65f84](https://github.com/folke/trouble.nvim/commit/ed65f84abc4a1e5d8f368d7e02601fc0357ea15e))
* lazy include telescope when needed ([7e3d4f9](https://github.com/folke/trouble.nvim/commit/7e3d4f9efc157bbfeb3e37837f8ded9289c48f25))
* lsp diag creates ugly buffers for unopened files in the workspace. Fixed now ([91d1139](https://github.com/folke/trouble.nvim/commit/91d1139d85407b99bd4d2f6850200a793631679b))
* lsp diagnostics codes ([dbbd523](https://github.com/folke/trouble.nvim/commit/dbbd523d91fe51e8421909147bf069b1ec780720))
* lsp handler error log ([#95](https://github.com/folke/trouble.nvim/issues/95)) ([063aefd](https://github.com/folke/trouble.nvim/commit/063aefd69a8146e27cde860c9ddd807891e5a119))
* **lsp:** avoid overwriting uri of result ([#60](https://github.com/folke/trouble.nvim/issues/60)) ([655391c](https://github.com/folke/trouble.nvim/commit/655391c2f592ef61943b6325030333dfacc54757))
* only use old hl groups when they exist (Fixes [#49](https://github.com/folke/trouble.nvim/issues/49)) ([d4ce76f](https://github.com/folke/trouble.nvim/commit/d4ce76fa82cdbd12dcf9dbfa682dae89b2a143ac))
* possible vim.NIL on diagnostics code ([1faa347](https://github.com/folke/trouble.nvim/commit/1faa347a93748531b5e418d84276c93da21b86a7))
* prevent segfault on closing ([756f09d](https://github.com/folke/trouble.nvim/commit/756f09de113a775ab16ba6d26c090616b40a999d))
* properly close trouble window on close ([d10ee4b](https://github.com/folke/trouble.nvim/commit/d10ee4bc99b8e2bb842c2274316db400b197cca9))
* properly exit when trouble is the last window. Fixes [#24](https://github.com/folke/trouble.nvim/issues/24) ([2b27b96](https://github.com/folke/trouble.nvim/commit/2b27b96c7893ac534ba0cbfc95d52c6c609a0b20))
* remove useless "no results" notification ([#164](https://github.com/folke/trouble.nvim/issues/164)) ([da61737](https://github.com/folke/trouble.nvim/commit/da61737d860ddc12f78e638152834487eabf0ee5)), closes [#154](https://github.com/folke/trouble.nvim/issues/154)
* removed space betweend rendering of source + code ([b676029](https://github.com/folke/trouble.nvim/commit/b6760291874d078668f4ff04d78acc0670536ca9))
* removed unused plenary require. Fixes [#1](https://github.com/folke/trouble.nvim/issues/1) ([1ff45e2](https://github.com/folke/trouble.nvim/commit/1ff45e274de32e816b891b1ca12f73f73b58a604))
* replace possible newlines in rendered text ([08d068f](https://github.com/folke/trouble.nvim/commit/08d068fb1668b7f898af721cbc8a1ae72ddf6565))
* restore item indentation ([7c93271](https://github.com/folke/trouble.nvim/commit/7c93271e7a6a147b8f4342f5b377fa863419846f))
* set buftype before filetype ([#67](https://github.com/folke/trouble.nvim/issues/67)) ([169b2ec](https://github.com/folke/trouble.nvim/commit/169b2ec3a4d0cac01f22cc8f7332f1d0a11f1fa4))
* set EndOfBuffer to LspTroubleNormal and hide ~ [#23](https://github.com/folke/trouble.nvim/issues/23) ([7d67f34](https://github.com/folke/trouble.nvim/commit/7d67f34d92b3b52ca63c84f929751d98b3f56b63))
* set nowrap for the trouble window. Fixes [#69](https://github.com/folke/trouble.nvim/issues/69) ([51dd917](https://github.com/folke/trouble.nvim/commit/51dd9175eb506b026189c70f81823dfa77defe86))
* set the filetype lastly so autocmd's can override options from it ([#126](https://github.com/folke/trouble.nvim/issues/126)) ([b5353dd](https://github.com/folke/trouble.nvim/commit/b5353ddcd09bd7e93d6f934149d25792d455a8fb))
* show warning when icons=true but devicons is not installed ([7aabea5](https://github.com/folke/trouble.nvim/commit/7aabea5cca2d51ba5432c988fe84ff9d3644637a))
* support LocationLink ([#94](https://github.com/folke/trouble.nvim/issues/94)) ([7f3761b](https://github.com/folke/trouble.nvim/commit/7f3761b6dbadd682a20bd1ff4cb588985c14c9a0))
* typos ([#55](https://github.com/folke/trouble.nvim/issues/55)) ([059ea2b](https://github.com/folke/trouble.nvim/commit/059ea2b999171f50019291ee776dd496799fdf3a))
* use deprecated vim.lsp.diagnostics for now ([afb300f](https://github.com/folke/trouble.nvim/commit/afb300f18c09f7b474783aa12eb680ea59785b46))
* use new DiagnosticChanged event ([#127](https://github.com/folke/trouble.nvim/issues/127)) ([4d0a711](https://github.com/folke/trouble.nvim/commit/4d0a711e7432eed022611ce385f3a7714e81f63b)), closes [#122](https://github.com/folke/trouble.nvim/issues/122)
* use vim.diagnostic instead of vim.lsp.diagnostic when available ([a2e2e7b](https://github.com/folke/trouble.nvim/commit/a2e2e7b53f389f84477a1a11c086c9a379af702e))
* workspace and document diagnostics were switched around ([1fa8469](https://github.com/folke/trouble.nvim/commit/1fa84691236d16a2d1c12707c1fbc54060c910f7))


### Performance Improvements

* debounce auto refresh when diagnostics get updated ([068476d](https://github.com/folke/trouble.nvim/commit/068476db8576e5b32acf20df040e7fca032cd11d))
* much faster async preview ([2c9b319](https://github.com/folke/trouble.nvim/commit/2c9b3195a7fa8cfc19a368666c9f83fd7a20a482))
* only fetch line when needed. Fixes [#26](https://github.com/folke/trouble.nvim/issues/26) ([52f18fd](https://github.com/folke/trouble.nvim/commit/52f18fd6bea57af54265247a3ec39f19a31adce3))
* only update diagnostics once when window changes ([d965d22](https://github.com/folke/trouble.nvim/commit/d965d22ee37e50be0ab32f6a5987a8cd88206f10))
* prevent nested loading of preview [#2](https://github.com/folke/trouble.nvim/issues/2) ([b20a784](https://github.com/folke/trouble.nvim/commit/b20a7844a035cf6795270db575ad8c4db2a774c9))
* use vim.lsp.util.get_line to get line instad of bufload ([607b1d5](https://github.com/folke/trouble.nvim/commit/607b1d5bbfdbd19242659415746b5e62f5ddfb94))


### Code Refactoring

* removed deprecated commands ([dd89ad9](https://github.com/folke/trouble.nvim/commit/dd89ad9ebb63e131098ff04857f8598eb88d8d79))
* renamed use_lsp_diagnostic_signs to use_diagnostic_signs ([9db77e1](https://github.com/folke/trouble.nvim/commit/9db77e194d848744139673aa246efa00fbcba982))
