# Changelog

## [2.1.10](https://github.com/kylechui/nvim-surround/compare/v2.1.9...v2.1.10) (2024-05-30)


### Bug Fixes

* Default delete should work if `find` key is sane. ([#331](https://github.com/kylechui/nvim-surround/issues/331)) ([6d2be37](https://github.com/kylechui/nvim-surround/commit/6d2be378dbccfed0b4db4abad007bb9ad33342b3))
* Don't translate termcodes twice on input ([#326](https://github.com/kylechui/nvim-surround/issues/326)) ([de828d6](https://github.com/kylechui/nvim-surround/commit/de828d6a98a3617c8f6309ef0235148b698e4ee0))
* Typo in help docs. ([fa5b365](https://github.com/kylechui/nvim-surround/commit/fa5b365e847909df35cea184e13b7b811f346cda))

## [2.1.9](https://github.com/kylechui/nvim-surround/compare/v2.1.8...v2.1.9) (2024-05-29)


### Bug Fixes

* Properly determine if `$` is used in a block surround. ([#328](https://github.com/kylechui/nvim-surround/issues/328)) ([23f4966](https://github.com/kylechui/nvim-surround/commit/23f4966aba1d90d9ea4e06dfe3dd7d07b8420611))

## [2.1.8](https://github.com/kylechui/nvim-surround/compare/v2.1.7...v2.1.8) (2024-05-16)


### Bug Fixes

* replace deprecated `vim.tbl_islist` by native Lua function ([#323](https://github.com/kylechui/nvim-surround/issues/323)) ([38973ca](https://github.com/kylechui/nvim-surround/commit/38973caecd9f77e25227f8bc6cb11a73a0695d1c))

## [2.1.7](https://github.com/kylechui/nvim-surround/compare/v2.1.6...v2.1.7) (2024-04-30)


### Bug Fixes

* Handle multi-byte characters for change/delete. ([#318](https://github.com/kylechui/nvim-surround/issues/318)) ([f929665](https://github.com/kylechui/nvim-surround/commit/f9296652f5b9cf13c15919714e4e7b9349906c26))

## [2.1.6](https://github.com/kylechui/nvim-surround/compare/v2.1.5...v2.1.6) (2024-04-11)


### Bug Fixes

* Mark fields in user_option and user_surround as optional ([#308](https://github.com/kylechui/nvim-surround/issues/308)) ([f7bb9fc](https://github.com/kylechui/nvim-surround/commit/f7bb9fc4d68ad319d94b1d98ed16f279811f5cc8))

## [2.1.5](https://github.com/kylechui/nvim-surround/compare/v2.1.4...v2.1.5) (2024-02-27)


### Bug Fixes

* Add bang to the `g@` normal command. ([#297](https://github.com/kylechui/nvim-surround/issues/297)) ([0c02c52](https://github.com/kylechui/nvim-surround/commit/0c02c52182a9c2a7fa7e122b4037f6408e98434a))
* **dot-repeat:** Clear dot-repeat after indentation ([#306](https://github.com/kylechui/nvim-surround/issues/306)) ([8f2af76](https://github.com/kylechui/nvim-surround/commit/8f2af76134f37058dc4c27a24bc5f86c9cae76dc))
* Visual selection highlight disappearing. ([#312](https://github.com/kylechui/nvim-surround/issues/312)) ([a72a97c](https://github.com/kylechui/nvim-surround/commit/a72a97c8ca697ad0000456a40bb931822fc06eab))

## [2.1.4](https://github.com/kylechui/nvim-surround/compare/v2.1.3...v2.1.4) (2023-12-04)


### Bug Fixes

* Keymap for `change_line`. ([#286](https://github.com/kylechui/nvim-surround/issues/286)) ([bd7bb26](https://github.com/kylechui/nvim-surround/commit/bd7bb26a0d264c886bae7e0a09dd5b56daf46376))

## [2.1.3](https://github.com/kylechui/nvim-surround/compare/v2.1.2...v2.1.3) (2023-11-13)


### Bug Fixes

* Translate char to termcodes when reading input ([#271](https://github.com/kylechui/nvim-surround/issues/271)) ([#273](https://github.com/kylechui/nvim-surround/issues/273)) ([cfa2da7](https://github.com/kylechui/nvim-surround/commit/cfa2da7f469f1e759f2a961bc25fa4ccfe1795c2))

## [2.1.2](https://github.com/kylechui/nvim-surround/compare/v2.1.1...v2.1.2) (2023-10-22)


### Bug Fixes

* Dot-repeat line surrounds. ([#262](https://github.com/kylechui/nvim-surround/issues/262)) ([aa27de7](https://github.com/kylechui/nvim-surround/commit/aa27de7929710e781ac039dabf0ff739218eed65))

## [2.1.1](https://github.com/kylechui/nvim-surround/compare/v2.1.0...v2.1.1) (2023-08-05)


### Bug Fixes

* Respect `move_cursor = false` when dot-repeating. ([#254](https://github.com/kylechui/nvim-surround/issues/254)) ([ec6a721](https://github.com/kylechui/nvim-surround/commit/ec6a7215a5d1707f5bf9d80262f26e13bfacc757))

## [2.1.0](https://github.com/kylechui/nvim-surround/compare/v2.0.5...v2.1.0) (2023-05-28)


### Features

* Implement `change_line` mapping. ([ff9c981](https://github.com/kylechui/nvim-surround/commit/ff9c981202f4bd45dd3c8e6c6aad965d437a7cb8))


### Bug Fixes

* **buffer:** `set_mark` should check for validity of input. ([841f83f](https://github.com/kylechui/nvim-surround/commit/841f83fd458de37c2a5bd63cece1088448529b6c))

## [2.0.5](https://github.com/kylechui/nvim-surround/compare/v2.0.4...v2.0.5) (2023-04-02)


### Bug Fixes

* Don't re-indent single-line surrounds. ([2fca63c](https://github.com/kylechui/nvim-surround/commit/2fca63c88a6b827019ad9d01f20e30b6499e1d45))

## [2.0.4](https://github.com/kylechui/nvim-surround/compare/v2.0.3...v2.0.4) (2023-03-28)


### Bug Fixes

* Whitespace handling when delimiters are on own line. ([#226](https://github.com/kylechui/nvim-surround/issues/226)) ([808fc7d](https://github.com/kylechui/nvim-surround/commit/808fc7d5899d88065ba4a4360f04f76cf9ff94b1))

## [2.0.3](https://github.com/kylechui/nvim-surround/compare/v2.0.2...v2.0.3) (2023-03-27)


### Bug Fixes

* Restore window view after finding nearest selections. ([#227](https://github.com/kylechui/nvim-surround/issues/227)) ([97f7309](https://github.com/kylechui/nvim-surround/commit/97f7309273fde2a81937ab3b8bdeabdf2787283c))

## [2.0.2](https://github.com/kylechui/nvim-surround/compare/v2.0.1...v2.0.2) (2023-03-27)


### Bug Fixes

* Use `vim.treesitter.query.parse()`. ([#228](https://github.com/kylechui/nvim-surround/issues/228)) ([b3abce1](https://github.com/kylechui/nvim-surround/commit/b3abce1d8c4f02d40df9a902ec1e38e0eed51f76))

## [2.0.1](https://github.com/kylechui/nvim-surround/compare/v2.0.0...v2.0.1) (2023-03-21)


### Bug Fixes

* **config:** User-defined surrounds fallback on defaults. ([29929a5](https://github.com/kylechui/nvim-surround/commit/29929a54a88f2764a47f1d19fdc7932eeaa576fb))

## [2.0.0](https://github.com/kylechui/nvim-surround/compare/v1.0.0...v2.0.0) (2023-03-11)

### ⚠ BREAKING CHANGES

- The function `get_char` has been moved from `utils` to `input`.
- The function `get_delimiters` has been moved from `utils` to `config`.
- The `textobject` field for `config.get_selection` has been deprecated; please
  use `motion` instead.
  [See this comment](https://github.com/kylechui/nvim-surround/issues/77#issuecomment-1215932210).
  - To update your functions, prepend 'a' to the `textobject` key, i.e. `(` →
    `a(`
- The highlight group used has been renamed from
  `NvimSurroundHighlightTextObject` to `NvimSurroundHighlight`.
  [See this comment](https://github.com/kylechui/nvim-surround/issues/77#issuecomment-1215932210).
- User defined `invalid_key_behavior` handlers will be activated for control
  characters that don't have defined `surrounds`. In other words, `<C-a>` is now
  a valid input that can be passed to `invalid_key_behavior`.
  [See this comment](https://github.com/kylechui/nvim-surround/issues/77#issuecomment-1438844045).
  - Note: `<C-c>` is still invalid, and terminates the input.
- Smart quotes have been removed. Modifying quotes will now always operate on
  the _immediately_ surrounding pair of quotes.
  [See this comment](https://github.com/kylechui/nvim-surround/issues/77#issuecomment-1309817520).

### Features

- Add `node` field to `config.get_selection`, allowing users to retrieve
  selections based on treesitter nodes.
- Add `indent_lines` field to `setup`, allowing users to configure what
  indentation program should be used for certain line-wise surrounds (if any).
- Add `<Plug>` mappings; decouple mappings.
  ([af10059](https://github.com/kylechui/nvim-surround/commit/af10059b0f1589a485d9e1b0298172bbf60cdb47))
- Add `exclude` key to `config.get_selections`.
  ([e2c22a6](https://github.com/kylechui/nvim-surround/commit/e2c22a62fe001eb7ef3bf088f4e0c439c9f9eefd))
- Implement basic query-matching.
  ([a634889](https://github.com/kylechui/nvim-surround/commit/a634889cb4a02b370f5c5e51c925ef1bc8b1982f))

### Bug Fixes

- `<Plug>(nvim-surround-insert)` mapping.
  ([#176](https://github.com/kylechui/nvim-surround/issues/176))
  ([6b45fbf](https://github.com/kylechui/nvim-surround/commit/6b45fbffdabb2d8cd80d310006c92e59cec8fd74))
- Add indentation when using line mode.
  ([#185](https://github.com/kylechui/nvim-surround/issues/185))
  ([9da7ced](https://github.com/kylechui/nvim-surround/commit/9da7ced872fd7d654f2677b1a11d1f294cfaa66d))
- Add protected call around Tree-sitter module.
  ([d91787d](https://github.com/kylechui/nvim-surround/commit/d91787d5a716623be7cec3be23c06c0856dc21b8))
- Change `reset_cursor` semantics.
  ([a207e3b](https://github.com/kylechui/nvim-surround/commit/a207e3b9906f86ecf48a90d94bb2eb703c141798))
- Change type annotations to `|nil` from `?`.
  ([1ac5abf](https://github.com/kylechui/nvim-surround/commit/1ac5abf6b6c9fdfbf4d793b9bf3a3b0938c6faf3))
- Correctly restore visual selection marks.
  ([#155](https://github.com/kylechui/nvim-surround/issues/155))
  ([c6a1993](https://github.com/kylechui/nvim-surround/commit/c6a1993199237f875f9407eb1c0aa9176117a3ff))
- Failing test cases due to Tree-sitter dependency.
  ([c057fb8](https://github.com/kylechui/nvim-surround/commit/c057fb81f1496a88722e201eeb71bba06d532076))
- Fix catastrophic error that broke everything.
  ([c323fa5](https://github.com/kylechui/nvim-surround/commit/c323fa5c8e84a59ab9aa63e07bdb28cc8c124c2a))
- Fix quote bug, closes
  [#172](https://github.com/kylechui/nvim-surround/issues/172).
  ([58b0a55](https://github.com/kylechui/nvim-surround/commit/58b0a55e8922e17250376045460df178ab7cf1c1))
- Handle special characters for `getchar`.
  ([#170](https://github.com/kylechui/nvim-surround/issues/170))
  ([1f79449](https://github.com/kylechui/nvim-surround/commit/1f79449d14463c6512a6f806f0023301e7a2c713))
- Improper look-behind for quotes.
  ([1d83fec](https://github.com/kylechui/nvim-surround/commit/1d83fecd27c6b4b66cc529930552d205fbecb660))
- Improper table handling for `add`, resolves
  [#191](https://github.com/kylechui/nvim-surround/issues/191).
  ([d51d554](https://github.com/kylechui/nvim-surround/commit/d51d554ae4721a20c892998a76d8a2edf6f75c08))
- Minor bugs.
  ([7f7ca04](https://github.com/kylechui/nvim-surround/commit/7f7ca045648912c03f565e91e2b6ba91e85b9a33))
- Properly handle linewise normal surrounds.
  ([90821ad](https://github.com/kylechui/nvim-surround/commit/90821ad682aac189cd0a38fd83fc96f0cbcc5d29))
- Remove `remap = true` from keymaps.
  ([#219](https://github.com/kylechui/nvim-surround/issues/219))
  ([89c82e7](https://github.com/kylechui/nvim-surround/commit/89c82e7c71a735f7c7d6330ba55a2fffb962d1e1))
- Revert some changes.
  ([ce01942](https://github.com/kylechui/nvim-surround/commit/ce01942a8f5d9e170493a67235568fe294cbb83d))
- Revert to pattern-based function calls by default.
  ([ba19320](https://github.com/kylechui/nvim-surround/commit/ba19320c14b5425c57c02c486c3eff76d7c8769f))
- Support Lua 5.1 instead of only LuaJIT.
  ([#169](https://github.com/kylechui/nvim-surround/issues/169))
  ([fa7648e](https://github.com/kylechui/nvim-surround/commit/fa7648e3ed5ec22f32de06d366cf8b80141998f0))
- Tweak pattern for function calls.
  ([3accef6](https://github.com/kylechui/nvim-surround/commit/3accef664a99839ab1a298b02e495c9bee3cd2a3))
- Update function pattern.
  ([c0835d2](https://github.com/kylechui/nvim-surround/commit/c0835d2a33898b1509e804b7a3ad49737b90d98a))
- Use `line_mode` parameter when possible.
  ([#194](https://github.com/kylechui/nvim-surround/issues/194))
  ([ad56e62](https://github.com/kylechui/nvim-surround/commit/ad56e6234bf42fb7f7e4dccc7752e25abd5ec80e))
- **utils:** Ensure chars is a table in ipairs.
  ([#192](https://github.com/kylechui/nvim-surround/issues/192))
  ([64e2106](https://github.com/kylechui/nvim-surround/commit/64e21061953102b19bbb22e824fbb96054782799))
- Error when `vim.o.selection='exclusive'`.
  ([#158](https://github.com/kylechui/nvim-surround/issues/158))
  ([81f672a](https://github.com/kylechui/nvim-surround/commit/81f672ad6525b5d8cc27bc6ff84636cc12664485))

### Additional Notes

Sorry for the long time in between releases everybody, I thought I could
implement queries support in a sensible way in a short amount of time, but it
quickly became much more to handle than I had thought. Moving forwards, I aim to
make the plugin "more stable" and to improve the user experience:

- Be more consistent with [SemVer releases](https://semver.org/) (i.e. version
  more frequently)
- Improve the automated testing suite
- Improve the documentation (considering automated documentation)
- Improve the customizability of the plugin (it should do what you think it
  does)
  - This is somewhat accomplished in the current release, as more fields can be
    set to `false`, but could still use some work

Thanks again to everyone for using this!
