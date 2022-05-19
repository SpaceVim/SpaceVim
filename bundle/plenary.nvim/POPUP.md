# Popup tracking

[WIP] An implementation of the Popup API from vim in Neovim. Hope to upstream
when complete

## Goals

Provide an API that is compatible with the vim `popup_*` APIs. After
stablization and any required features are merged into Neovim, we can upstream
this and expose the API in vimL to create better compatibility.

## Notices
- **2021-09-19:** we now follow Vim's convention of the first line/column of the screen being indexed 1, so that 0 can be used for centering.
- **2021-08-19:** we now follow Vim's default to `noautocmd` on popup creation. This can be overriden with `vim_options.noautocmd=false`

## List of Neovim Features Required:

- [ ] Key handlers (used for `popup_filter`)
- [ ] scrollbar for floating windows
    - [ ] scrollbar
    - [ ] scrollbarhighlight
    - [ ] thumbhighlight

Optional:

- [ ] Add forced transparency to a floating window.
    - Apparently overrides text?
    - This is for the `mask` feature flag


Unlikely (due to technical difficulties):

- [ ] Add `textprop` wrappers?
    - textprop
    - textpropwin
    - textpropid
- [ ] "close"
    - But this is mostly because I don't know how to use mouse APIs in nvim. If someone knows. please make an issue in the repo, and maybe we can get it sorted out.

Unlikely (due to not sure if people are using):
- [ ] tabpage

## Progress

Suported Features:

- [x] what
    - string
    - list of strings
- [x] popup_create-arguments
    - [x] border
    - [x] borderchars
    - [x] col
    - [x] cursorline
    - [x] highlight
    - [x] line
    - [x] {max,min}{height,width}
    - [?] moved
        - [x] "any"
        - [ ] "word"
        - [ ] "WORD"
        - [ ] "expr"
        - [ ] (list options)
    - [x] padding
    - [?] pos
        - Somewhat implemented. Doesn't work with borders though.
    - [x] posinvert
    - [x] time
    - [x] title
    - [x] wrap
    - [x] zindex

## All known unimplemented vim features at the moment

- firstline
- hidden
- ~ pos
- fixed
- filter
- filtermode
- mapping
- callback
- mouse:
    - mousemoved
    - close
    - drag
    - resize

- (not implemented in vim yet) flip
