# Changelog

## [2.5.2](https://github.com/folke/neodev.nvim/compare/v2.5.1...v2.5.2) (2023-03-24)


### Bug Fixes

* parameter type for vim.fn.getline() ([#144](https://github.com/folke/neodev.nvim/issues/144)) ([ab56354](https://github.com/folke/neodev.nvim/commit/ab56354e0e85c3c3f20f770c699fb0038ce7bf42))

## [2.5.1](https://github.com/folke/neodev.nvim/compare/v2.5.0...v2.5.1) (2023-03-12)


### Bug Fixes

* **lua_ls:** plugin name detection of symlinked plugins ([#140](https://github.com/folke/neodev.nvim/issues/140)) ([a60eaee](https://github.com/folke/neodev.nvim/commit/a60eaee19e0c3dcb7e54c64fe9bcfb71420a95c0))

## [2.5.0](https://github.com/folke/neodev.nvim/compare/v2.4.2...v2.5.0) (2023-03-10)


### Features

* **luv:** use the luv addon instead of the deprecated 3rd party ([f06c113](https://github.com/folke/neodev.nvim/commit/f06c11344f76fadf2cd497b9490125dfc02946cb))

## [2.4.2](https://github.com/folke/neodev.nvim/compare/v2.4.1...v2.4.2) (2023-03-08)


### Bug Fixes

* parameter types for searchpair and searchpairpos ([#130](https://github.com/folke/neodev.nvim/issues/130)) ([c87f69c](https://github.com/folke/neodev.nvim/commit/c87f69c856505ea778f6fd883a90397e55c8e59d))

## [2.4.1](https://github.com/folke/neodev.nvim/compare/v2.4.0...v2.4.1) (2023-02-28)


### Bug Fixes

* parameter types for vim.wait and vim.fn.input ([#131](https://github.com/folke/neodev.nvim/issues/131)) ([55d3a74](https://github.com/folke/neodev.nvim/commit/55d3a747af136da527067e9fe59ad0bb938ecd50))

## [2.4.0](https://github.com/folke/neodev.nvim/compare/v2.3.0...v2.4.0) (2023-02-13)


### Features

* added lua_ls luv builtin library. Fixes [#127](https://github.com/folke/neodev.nvim/issues/127) ([8c32d8b](https://github.com/folke/neodev.nvim/commit/8c32d8b4e765de26b27b76f0072e7c12038cde52))

## [2.3.0](https://github.com/folke/neodev.nvim/compare/v2.2.1...v2.3.0) (2023-02-13)


### Features

* **luv:** more luv types ([39bb79b](https://github.com/folke/neodev.nvim/commit/39bb79b688300b0b4672ec83c564d72749482116))

## [2.2.1](https://github.com/folke/neodev.nvim/compare/v2.2.0...v2.2.1) (2023-02-12)


### Bug Fixes

* s/sumneko_lua/lua_ls/ ([#124](https://github.com/folke/neodev.nvim/issues/124)) ([307d0fb](https://github.com/folke/neodev.nvim/commit/307d0fbce02068eebdaa4ef7da279fdb1bfe6d8e))
* sumneko_lua -&gt; lua_ls ([5076ebb](https://github.com/folke/neodev.nvim/commit/5076ebbcbfd0e2164d91ff2073a6f21a561804df))

## [2.2.0](https://github.com/folke/neodev.nvim/compare/v2.1.0...v2.2.0) (2023-02-10)


### Features

* add more luv methods and types ([#122](https://github.com/folke/neodev.nvim/issues/122)) ([fc01efe](https://github.com/folke/neodev.nvim/commit/fc01efe11447a99808b06e362d95a296218fed68))

## [2.1.0](https://github.com/folke/neodev.nvim/compare/v2.0.1...v2.1.0) (2023-02-08)


### Features

* Add `treesitter.query` and `treesitter.language` to stable ([#119](https://github.com/folke/neodev.nvim/issues/119)) ([4b6ade9](https://github.com/folke/neodev.nvim/commit/4b6ade9bb879aad4d1b2e94e82c36957262ead53))
* add class to vim.api and vim.loop ([e27c03b](https://github.com/folke/neodev.nvim/commit/e27c03b3e312c08e2d4aeed2a0f76199a9729529))


### Bug Fixes

* handle cases where `vim.fn.stdpath("config")` does not exist. Fixes [#109](https://github.com/folke/neodev.nvim/issues/109) ([fc20483](https://github.com/folke/neodev.nvim/commit/fc20483383dac11b97df43c83db1bbbd35305172))
* provide a class for vim.api ([#117](https://github.com/folke/neodev.nvim/issues/117)) ([9737bfc](https://github.com/folke/neodev.nvim/commit/9737bfc085cbb8879c19471a65b12fe9bd1ae878))
* revert [#117](https://github.com/folke/neodev.nvim/issues/117) ([dd63031](https://github.com/folke/neodev.nvim/commit/dd630312eb978f554006a020554d64c197887644))
* use integer for buffer, window, etc ([#116](https://github.com/folke/neodev.nvim/issues/116)) ([71e3e0c](https://github.com/folke/neodev.nvim/commit/71e3e0c2239593e29e06ecc725ba346e29d3186a))

## [2.0.1](https://github.com/folke/neodev.nvim/compare/v2.0.0...v2.0.1) (2023-01-15)


### Bug Fixes

* ignore lua directory ([82c8586](https://github.com/folke/neodev.nvim/commit/82c85862e2aaa9c0b63f3176eb8dc513803f2865))
* **lsp:** make sure everything works when lua root not found. Fixes [#108](https://github.com/folke/neodev.nvim/issues/108) ([31cba85](https://github.com/folke/neodev.nvim/commit/31cba8554a8e37ecf240fa2e242f0e43e72ae930))

## [2.0.0](https://github.com/folke/neodev.nvim/compare/v1.0.0...v2.0.0) (2023-01-11)


### ⚠ BREAKING CHANGES

* `config.pathStrict` is now enabled by default. Needs sumneko >= 3.6.0. Much better performance

### Features

* **options:** allow setting an option to its type ([1569664](https://github.com/folke/neodev.nvim/commit/156966470d19a8b095f9ae620720be3fb85a3772))


### Bug Fixes

* simplified and improved plugin/config detection ([a34a9e7](https://github.com/folke/neodev.nvim/commit/a34a9e7e775f1513466940c31285292b7b8375de))


### Performance Improvements

* `config.pathStrict` is now enabled by default. Needs sumneko &gt;= 3.6.0. Much better performance ([5ff32d4](https://github.com/folke/neodev.nvim/commit/5ff32d4d50491f94667733362a52d0fe178e4714))

## 1.0.0 (2023-01-04)


### ⚠ BREAKING CHANGES

* removed config.plugin_library in favor of config.override for easier customization
* rewrite with easier setup and configuration. Backward compatible, but refer to the docs to use the optimized setup

### Features

* added [@meta](https://github.com/meta) to generated emmy-lua files ([97a3399](https://github.com/folke/neodev.nvim/commit/97a33996a1618bdc6647384fd605940c5adce743))
* added [@see](https://github.com/see) for `seealso` from help docs ([1e8a2b4](https://github.com/folke/neodev.nvim/commit/1e8a2b4427a73cf3f0a51f42c52cc367e71f04f5))
* added annotations for vim.filetype, vim.F, vim.fs, vim.health, vim.inspect ([2be3d3f](https://github.com/folke/neodev.nvim/commit/2be3d3ffc17609319090289561842a75dcbf5daf))
* added config.runtime() for new vim.fn parser ([87adbea](https://github.com/folke/neodev.nvim/commit/87adbeafc4d2813447e6a75c8f209cb2d637b178))
* added configuration option to set the runtime_path (slow). Fixes [#29](https://github.com/folke/neodev.nvim/issues/29) ([f7fecb7](https://github.com/folke/neodev.nvim/commit/f7fecb7deda6fe244b6a5b8edfca21128009baf5))
* added docs for options and vim.fn functions ([4eb0e89](https://github.com/folke/neodev.nvim/commit/4eb0e894795251e5381c55ef87e7a0053ad0659c))
* added function to check if a fiven fqname is a lua object ([3d1d469](https://github.com/folke/neodev.nvim/commit/3d1d4698a05be1099162812bf7893fb873f6a297))
* added luv docs ([e38838a](https://github.com/folke/neodev.nvim/commit/e38838a558a5f80d6a9c8ad7d0044c884254463b))
* added missing types ([76e7b48](https://github.com/folke/neodev.nvim/commit/76e7b48122a251b98057cc71823bdc50aa289016))
* added option shortnames to vim.opt, o, go, bo, wo, opt_local, opt_global ([309eca5](https://github.com/folke/neodev.nvim/commit/309eca5584eba48d2b77f3668b3c5db3dee7e838))
* added options ([9ec4a9c](https://github.com/folke/neodev.nvim/commit/9ec4a9c73b102163055d8d4e52edd833f9c22151))
* added overrides for vim.fn.expand and vim.fn.sign_define. Fixes [#72](https://github.com/folke/neodev.nvim/issues/72) ([868db41](https://github.com/folke/neodev.nvim/commit/868db41830bae23c70b4ed044f64f60870bc8f37))
* added overrides for vim.fn.glob ([43f51e9](https://github.com/folke/neodev.nvim/commit/43f51e9b86d1637644f0fbba5e1e11bef4341750))
* added overrides for vim.loop.new_timer() ([d15370e](https://github.com/folke/neodev.nvim/commit/d15370ee520a169bf6224668ccca175489833948))
* added possibility to define [@overload](https://github.com/overload) annotations ([a77f5db](https://github.com/folke/neodev.nvim/commit/a77f5dbfe2e972789c989e2f3909354b482705c0))
* added possibility to override auto generated annotations ([9d6b75b](https://github.com/folke/neodev.nvim/commit/9d6b75ba119cf825fb92830188724e6f0f31e4ed))
* added support for lazy.nvim ([6136979](https://github.com/folke/neodev.nvim/commit/61369790e4205b74f1667587b3dc5867716500eb))
* added support for vim.opt methods. Fixes [#73](https://github.com/folke/neodev.nvim/issues/73) ([9e56a56](https://github.com/folke/neodev.nvim/commit/9e56a56301a297bf8d0c675349c101023a723c22))
* added support for vimdoc code blocks ([6d8ce16](https://github.com/folke/neodev.nvim/commit/6d8ce1602a166c03695aaa976252bcb0fd49a7dc))
* added types for vim.cmd.* ([9962a1d](https://github.com/folke/neodev.nvim/commit/9962a1dd0db41ab6745be2d9e4b3dc70d1aa188c))
* added vim.diagnostic & vim.ui ([58796ba](https://github.com/folke/neodev.nvim/commit/58796ba3f0f7b3ab2197670998555f299cb3f471))
* added vim.treesitter.highlighter ([5ca1178](https://github.com/folke/neodev.nvim/commit/5ca117883f37c64ee15f4d6a8ba8ca9a673bfffe))
* added vim.treesitter.language ([8d2a950](https://github.com/folke/neodev.nvim/commit/8d2a950045450927d8f7652ef26548b28f3137c8))
* added warnings on old-style setup ([17e73ce](https://github.com/folke/neodev.nvim/commit/17e73ce2f9616d5b967e9f3996f3c3b84912ef99))
* added workspace support ([681c0fc](https://github.com/folke/neodev.nvim/commit/681c0fc46c49108ec4da9e190c7bfe0ec1393d83))
* aded experimental option pathStrict. You need the latest sumneko nightly for this ([60f1ec9](https://github.com/folke/neodev.nvim/commit/60f1ec9d73c7f8fb5537050f38b8921698315e55))
* allow config without using lspconfig. Fixes [#83](https://github.com/folke/neodev.nvim/issues/83) ([3b6b644](https://github.com/folke/neodev.nvim/commit/3b6b6442a036729d950f1b92924ac0f5827638ea))
* better type infer ([6b9ae84](https://github.com/folke/neodev.nvim/commit/6b9ae848c4b804a9f9179abcc72ee38e824a2fd8))
* debug log ([fdab800](https://github.com/folke/neodev.nvim/commit/fdab800ea2a9d4a62b67fe87109b937e6d85f5bf))
* docs.fqn ([8f61232](https://github.com/folke/neodev.nvim/commit/8f61232f815e134efdf4cf06e1cd6342f4e369ab))
* enable call snippets ([a267319](https://github.com/folke/neodev.nvim/commit/a26731909a6790ab80a4c7bc0c25b8d7402c35e9))
* enable lua-dev by default for the Neovim runtime directory when needed ([0001b27](https://github.com/folke/neodev.nvim/commit/0001b27ddce0a1cc620d325577cba9f3b48f9cad))
* fix indent of doc comments ([5abb32a](https://github.com/folke/neodev.nvim/commit/5abb32ab07a2e01726095dcc9bf224f874eeac69))
* fixed detection of definitions for vim.keymap ([63bdf08](https://github.com/folke/neodev.nvim/commit/63bdf085b17ff55c938763ca1f6c346af119277c))
* fixed option docs ([fb82dcc](https://github.com/folke/neodev.nvim/commit/fb82dcc58d7839a60a0da008049dc42c663bebae))
* format code blocks as markdown ([e85a190](https://github.com/folke/neodev.nvim/commit/e85a19015ceb8498f6e80cb0094eb2dc45603bde))
* full support of vim.go, wo, bo, o, opt, opt_local, opt_global ([261d29c](https://github.com/folke/neodev.nvim/commit/261d29c44328eb4b703e49ba4a6ae4e5297a96fc))
* generated types for stable (Neovim 0.8.0) ([4366cad](https://github.com/folke/neodev.nvim/commit/4366cada45729a4224cbdf9b34f085b678c64796))
* handle special Lua keywords ([142d456](https://github.com/folke/neodev.nvim/commit/142d456011e0a5df302e5cced535ecaa13be631a))
* hidden option to make sumneko use a different neovim runtime for testing ([d55299f](https://github.com/folke/neodev.nvim/commit/d55299fea0655a416d94cb11badcd342ec54d7f4))
* implemented optional parameters for lua api functions ([ee8e6af](https://github.com/folke/neodev.nvim/commit/ee8e6af506fc94763c59d336258de48b9f500988))
* improved docs.functions ([c3a6a8c](https://github.com/folke/neodev.nvim/commit/c3a6a8c77af8dc04a064fe9b75d68bf3c56e4d4d))
* improved vim.api and vim parsers ([60fce6d](https://github.com/folke/neodev.nvim/commit/60fce6dd0c60376f3a2d2253b314c6088ad067a9))
* initial version ([26bd607](https://github.com/folke/neodev.nvim/commit/26bd607564940dc56575b792d799366a0da56c1f))
* integrate with settings.nvim ([d95e691](https://github.com/folke/neodev.nvim/commit/d95e69166dbbef775140aecd02508db13c3606bb))
* integration with neoconf.nvim ([77e8aec](https://github.com/folke/neodev.nvim/commit/77e8aec83549db4f575aa99cd8e2a88ac85db662))
* keep original formatting when parsing docs ([6cf4af1](https://github.com/folke/neodev.nvim/commit/6cf4af1a026d63e676bddbdf8ad5b3fd726f1218))
* lua-dev is now neodev ([b43d272](https://github.com/folke/neodev.nvim/commit/b43d2726829c0fe2d3950372e13177daaff14ea4))
* lua-dev now properly sets up jsonls for .luarc.json, the sumneko local config files ([fb62007](https://github.com/folke/neodev.nvim/commit/fb620072c444404b2b55e9a0d8ba6d6f9e2dac69))
* lua.txt doc parser ([0e7a16b](https://github.com/folke/neodev.nvim/commit/0e7a16b070c6be725573bc8cc2b0d69694cefc62))
* merge defs of vim._editor in `vim` ([858bcd6](https://github.com/folke/neodev.nvim/commit/858bcd6840fa9578d14915f05fc15ca9b0959517))
* merge in lspconfig options ([1f7ee38](https://github.com/folke/neodev.nvim/commit/1f7ee38d0f4e3972c3768e360979f5670aba2070))
* more luv annotations ([b50621a](https://github.com/folke/neodev.nvim/commit/b50621a868004292372d91a03c88923b36659d99))
* new options parser ([0c65251](https://github.com/folke/neodev.nvim/commit/0c65251ef6f93c795b6d44e339d97670a3500e8b))
* new parser ([42e9c51](https://github.com/folke/neodev.nvim/commit/42e9c5126904d6715ece660224610f3a38e4b8d4))
* new vim functions parser ([4d9ee97](https://github.com/folke/neodev.nvim/commit/4d9ee97048c6b541c363cc99dce24c3e77527631))
* only load missing functions from mpack on nightly. hidden functions ([f0bf928](https://github.com/folke/neodev.nvim/commit/f0bf928719bf1b7eb0ee905e787c29e9a332e25f))
* optionally supply a list of plugins to add to the workspace [#2](https://github.com/folke/neodev.nvim/issues/2) ([1fb6cc8](https://github.com/folke/neodev.nvim/commit/1fb6cc81ca98aab4d46ded1d39dcd29a44e48fcc))
* parse luv return values from docs ([107b7d9](https://github.com/folke/neodev.nvim/commit/107b7d9413b8134a72ea838a624679f5a4e4fdf9))
* proper typing for vim.g, vim.v, vim.b, vim.w and vim.t ([b16231e](https://github.com/folke/neodev.nvim/commit/b16231e7af55be112fcb867fd7b5eddf2993e9da))
* properly configure runtime.path to make require work for plugins (slow). Fixes [#23](https://github.com/folke/neodev.nvim/issues/23) ([274f72b](https://github.com/folke/neodev.nvim/commit/274f72b6bc5c199f6d2d33956f9aa0603d4c3367))
* properly parse optional params like (*opts) ([48cca93](https://github.com/folke/neodev.nvim/commit/48cca93b6d5da62db8da46c6d81b8fde2f4c8914))
* removed config.plugin_library in favor of config.override for easier customization ([46a2eb0](https://github.com/folke/neodev.nvim/commit/46a2eb009062bef889dd05913f92c2c11a57b189))
* replace code regions by markdown lua code blocks ([23df3f4](https://github.com/folke/neodev.nvim/commit/23df3f4f5403dbf24ccc1c8fc998db5298a0d377))
* rewrite with easier setup and configuration. Backward compatible, but refer to the docs to use the optimized setup ([ae74bc9](https://github.com/folke/neodev.nvim/commit/ae74bc9987638da2e122aaaf155d6519f07e6197))
* set correct default option ([e9e1da3](https://github.com/folke/neodev.nvim/commit/e9e1da34d8faa4843fd6d860bc12f552fe2e4a2a))
* snippet option for setup ([#47](https://github.com/folke/neodev.nvim/issues/47)) ([8553f1c](https://github.com/folke/neodev.nvim/commit/8553f1c89aa53d2e9bb94b728bdf3ebd0abb625d))
* types for nightly ([3e97b3e](https://github.com/folke/neodev.nvim/commit/3e97b3e87fae815863a6276e14af734102d28be8))
* types for stable ([499bc32](https://github.com/folke/neodev.nvim/commit/499bc3286050ec5bf2332ee8c6cd726e10e75e6f))
* updated all the docs for Neovim 0.6 ([1933c7e](https://github.com/folke/neodev.nvim/commit/1933c7e014e69484572b7fa1bf73bc51c42f10f4))
* updated docs to 0.7 ([6063731](https://github.com/folke/neodev.nvim/commit/60637315d665652c59a6a4f99a82f2308d11dd8f))
* updated emmy lua files ([5e6caa9](https://github.com/folke/neodev.nvim/commit/5e6caa92b83a07a516d481593344bed1e6eebd6a))
* util.error ([c771c04](https://github.com/folke/neodev.nvim/commit/c771c040cb63cdbd2f01ae8698befb64011bbe93))
* vim.fn functions ([b1e7776](https://github.com/folke/neodev.nvim/commit/b1e7776e4c7adeaa799002cb8ee25fecdc40f444))
* vim.lua for nightly ([cae3dfa](https://github.com/folke/neodev.nvim/commit/cae3dfa0380c9a08a27c947f7de5ee719e087ff2))
* vimdoc parser ([ac2a760](https://github.com/folke/neodev.nvim/commit/ac2a7601c8c5d2160512d74746286ea9f9580a09))
* when param name is string, and unknown type, then use string ([ddb8162](https://github.com/folke/neodev.nvim/commit/ddb816294b62d7ab76ecbe0f26f2bfb8aef4a5e1))


### Bug Fixes

* add correct neovim config directory when pathstrict ([d20c601](https://github.com/folke/neodev.nvim/commit/d20c601836c05039926cbfec0b895a3028af70af))
* add lua directories to workspace.library ([563e365](https://github.com/folke/neodev.nvim/commit/563e365b96ea5848e950e216929c08c69d3f4dda))
* add vim itself to globals ([2c9311b](https://github.com/folke/neodev.nvim/commit/2c9311b5e45b2ad71843e7e9d49ce31f59cca630))
* added .luarc.jsonc validation also to jsonls ([8e2f046](https://github.com/folke/neodev.nvim/commit/8e2f04638f9cb6c297d16c4feef85a6f7615fafb))
* added # for parameter docs ([3c7dfda](https://github.com/folke/neodev.nvim/commit/3c7dfda68549b6152bc0aa3c04f81a87ee9af9f9))
* added support for builtin libraries and meta/3rd libraries ([8d47e3a](https://github.com/folke/neodev.nvim/commit/8d47e3a488eb8a05f6699036f98f8a9a7f41776b))
* added vim.log.levels ([4331626](https://github.com/folke/neodev.nvim/commit/4331626b02f636433b504b9ab6a8c11fb9de4a24))
* alias `buffer` type ([#103](https://github.com/folke/neodev.nvim/issues/103)) ([23b58ff](https://github.com/folke/neodev.nvim/commit/23b58ff4e486d32fe9740dcdec0084ee419e1522))
* append on_new_config instead of replacing it ([cff0972](https://github.com/folke/neodev.nvim/commit/cff09720d23f84fa4ae46005857d7c5d7a1a4844))
* append to existing workspace.library instead of replacing ([b4bc26d](https://github.com/folke/neodev.nvim/commit/b4bc26d91ab17b84e8f15926c18b0c0abea3b690))
* better detection of nvim config and plugins where root-dir is incorrect ([d6212c1](https://github.com/folke/neodev.nvim/commit/d6212c1527bb5fb4dbb593318cd937ad2d4d6eee))
* better method of finding typed directory [#6](https://github.com/folke/neodev.nvim/issues/6) ([2e1a816](https://github.com/folke/neodev.nvim/commit/2e1a81633bab27e2535d1ccf5f47dda0ba49b0ce))
* better package path ([03a44ec](https://github.com/folke/neodev.nvim/commit/03a44ec6a54b0a025a633978e8541584a02e46d9))
* broke require path completion again ([9da602d](https://github.com/folke/neodev.nvim/commit/9da602d023ca1af73ac2ea3813798592c904566d))
* correctly process global_local options ([2815a2a](https://github.com/folke/neodev.nvim/commit/2815a2acb5a0cd9a11aaadb8256af15c7bf7d513))
* docs ([7b96f30](https://github.com/folke/neodev.nvim/commit/7b96f30ca6af998b4e3caa9c3886539e3ae83384))
* **docs:** update sumneko_lua setup example ([#67](https://github.com/folke/neodev.nvim/issues/67)) ([8b2b228](https://github.com/folke/neodev.nvim/commit/8b2b228673a88baa9267cb4a9ceb5862b5ee5df4))
* don't add arena parameters to functions ([99ee7f2](https://github.com/folke/neodev.nvim/commit/99ee7f21e07f9979b8cf14f24ce24d49aca11494))
* don't include lua docs in generated docs. They are correctly set up through `types/vim.lua` ([130b35e](https://github.com/folke/neodev.nvim/commit/130b35e0f671c5729d106a4fe113129cb979e4b1))
* don't skip anything from shared, otherwise builtin lua function docs are missing like notify ([24d8cf9](https://github.com/folke/neodev.nvim/commit/24d8cf99ccdaf8ef370f3f2165538fa296cd8122))
* dont add root_dir to workspace library. Fixes [#21](https://github.com/folke/neodev.nvim/issues/21) ([e958850](https://github.com/folke/neodev.nvim/commit/e9588503e68fa32ac08b83d9cb7e42ec31b8907d))
* fixed lua-dev schema for settings.nvim ([d6900dc](https://github.com/folke/neodev.nvim/commit/d6900dc94a40a3215d1a8debdaaa3036c3df17e5))
* fixed requiring files and require path ([3c18da8](https://github.com/folke/neodev.nvim/commit/3c18da83e7d4e4199857721301b9ec52bd99e487))
* get all the lua docs for internal lua functions ([6b0d9b0](https://github.com/folke/neodev.nvim/commit/6b0d9b0559defd9840402610824aeb9339ef1319))
* improved emmy lua annotations ([4f5a10f](https://github.com/folke/neodev.nvim/commit/4f5a10f192c1fc2b080afc852a85403b1296da8e))
* indentation from docs ([a4e5103](https://github.com/folke/neodev.nvim/commit/a4e5103fd91e9db6d9ac924df3fff94eaca8402a))
* line context ([fbcdd6d](https://github.com/folke/neodev.nvim/commit/fbcdd6da18c124aa0f36a5981302ff29cd644115))
* **luv:** also parse sync return values ([7b495ec](https://github.com/folke/neodev.nvim/commit/7b495ec693ad0bd42268f12f678fdeffa2f62b98))
* make options generation deterministic ([136ec0e](https://github.com/folke/neodev.nvim/commit/136ec0eceaef775147034e35c35ff80ad407b7da))
* more markdown code blocks ([5b620d9](https://github.com/folke/neodev.nvim/commit/5b620d9059d28ff75aadb50b9a2be80ba0b88272))
* more neodev renames ([d23076d](https://github.com/folke/neodev.nvim/commit/d23076d66ab87cf2d2feae7d5ff4f3cf4f0c754d))
* move settings to lua-dev ([c62617e](https://github.com/folke/neodev.nvim/commit/c62617ee4f15e04e0e5a96f3a824a3a1c838df53))
* mpack functions can have multiple docs ([2c2293c](https://github.com/folke/neodev.nvim/commit/2c2293cede37c19ca2cc8349fafaa8a7fe132f7d))
* multi-line comments for parameters ([acfa55b](https://github.com/folke/neodev.nvim/commit/acfa55b291c83e6fa40a006ea824d92d624c11b6))
* new settings.nvim API ([6477ca9](https://github.com/folke/neodev.nvim/commit/6477ca95d081e2b2397a993699c8ff643c632f85))
* options now have proper types ([d9bd9b4](https://github.com/folke/neodev.nvim/commit/d9bd9b488e83939e746b8150f2b684e72bb1275e))
* other way to prevent name change issues ([d3f7002](https://github.com/folke/neodev.nvim/commit/d3f70023d925b0c2e3084bb08a42aad3b2c2f027))
* parse incorrect function signatures with missing {} ([7eb0f15](https://github.com/folke/neodev.nvim/commit/7eb0f15fe8eaef3c4204e12cd3a94e183dd8f843))
* prepend "lua/" to package path ([b24f225](https://github.com/folke/neodev.nvim/commit/b24f22588eab04d604be7816cf5dfe09f96e7245))
* remove duplication of lua/ ([#66](https://github.com/folke/neodev.nvim/issues/66)) ([ec50266](https://github.com/folke/neodev.nvim/commit/ec50266039f0e71178be8c1d22211f48af498efe))
* remove root_dir from library. otherwise rename is broken ([b9b721a](https://github.com/folke/neodev.nvim/commit/b9b721a5bed76374ae7d96a6a211737954e241c7))
* remove vimconfig from workspace library. not needed [#1](https://github.com/folke/neodev.nvim/issues/1) ([0faabb9](https://github.com/folke/neodev.nvim/commit/0faabb95aec5af07f4416a8adb3ff6a218f6a855))
* replace `dict(something)` by `dict`, otherwise sumneko fails to render the hover ([4667d53](https://github.com/folke/neodev.nvim/commit/4667d535e7d811f5003bf57f786a0ce05ce6f516))
* replace invalid param name characters ([e5a553c](https://github.com/folke/neodev.nvim/commit/e5a553c6ffd661ab6f42be3f6992baf42f452445))
* resolve realpath of neovim config ([42eab7e](https://github.com/folke/neodev.nvim/commit/42eab7e0a7950f0322794a580ff10f56d1d15ee7))
* set proper runtime.path for require completion ([7840b31](https://github.com/folke/neodev.nvim/commit/7840b31c020c04076dde9fb9e45a9f653320b3e4))
* sort functions before writing ([72c4e61](https://github.com/folke/neodev.nvim/commit/72c4e61a6d69e9907c271893a0822142fda1facf))
* sort vim.fn functions before writing file ([cc55fd1](https://github.com/folke/neodev.nvim/commit/cc55fd1b8aa7da0d8f75e2fa711095388fc54f0f))
* sumneko library should be a list instead of a dict ([14004d2](https://github.com/folke/neodev.nvim/commit/14004d29ff2d408367b1e6757b0923e67e319325))
* types for stable ([901660d](https://github.com/folke/neodev.nvim/commit/901660d70dfa98f1afe9304bf8e580125f591f12))
* use correct key for special lsp library paths ([f879e53](https://github.com/folke/neodev.nvim/commit/f879e53f9d4efcc0035a3b395a66ac5794954c74))
* use default values for vim.opt ([#87](https://github.com/folke/neodev.nvim/issues/87)) ([66b67cf](https://github.com/folke/neodev.nvim/commit/66b67cf8833a98f5e4f92821e4320be82f160916))
* use existing library on settings.Lua.workspace ([cf3b028](https://github.com/folke/neodev.nvim/commit/cf3b028043e86e0e659568aede9d0c8273800b3e))
* use lazy.plugins() ([c87f3c9](https://github.com/folke/neodev.nvim/commit/c87f3c9ffb256846e2a51f0292537073ca62d4d0))
* workspace.library uses a map ([350b579](https://github.com/folke/neodev.nvim/commit/350b579498a7eeeab33f0ff6496e4fa1d807469a))


### Performance Improvements

* add /lua to plugin directories ([6bf74db](https://github.com/folke/neodev.nvim/commit/6bf74dbe456711d410b905fb5fb4acb87fb4ce0c))
* disable callSnippets for now. Too slow ([616b559](https://github.com/folke/neodev.nvim/commit/616b559dff0307adbe62606f806c2b568a6322d5))
* disable legacy setup mechanism, but still show warning ([82423f5](https://github.com/folke/neodev.nvim/commit/82423f569d51c79733f5599fb11fb8df46b324d6))
* dont use glob to find lua dirs. Check bufs instead. Fixes [#80](https://github.com/folke/neodev.nvim/issues/80) ([97ebf23](https://github.com/folke/neodev.nvim/commit/97ebf23c0d4f5a11f1d68a5abd468751b14980a1))
* remove runtime path again. way too slow ([e151df6](https://github.com/folke/neodev.nvim/commit/e151df68973b3aca4c88f6d602f89574d7d32200))
