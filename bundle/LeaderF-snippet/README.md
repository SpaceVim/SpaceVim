# Leaderf-snippet

This plugin takes the advantage of the well-known fuzzy finder [Leaderf](https://github.com/Yggdroot/LeaderF) to provide an intuitive way to input snippets:

![](https://github.com/skywind3000/images/raw/master/p/snippet/snippet1.gif)

Snippet names are hard to remember, therefore, I made a Leaderf extension to help input snippets.

## Feature

- Read snippets from SnipMate or UltiSnips
- Display snippet descriptions in the fuzzy finder.
- Work in both INSERT mode and NORMAL mode.

## Installation

```VimL
" Leaderf-snippet
Plug 'Yggdroot/LeaderF'
Plug 'skywind3000/Leaderf-snippet'
```

A supported snippet engine, [UltiSnips](https://github.com/SirVer/ultisnips) (recommended) or [SnipMate](https://github.com/garbas/vim-snipmate), is required.


## Configuration

```VimL
" maps
inoremap <c-x><c-x> <c-\><c-o>:Leaderf snippet<cr>

" optional: preview
let g:Lf_PreviewResult = get(g:, 'Lf_PreviewResult', {})
let g:Lf_PreviewResult.snippet = 1

```

## Why Leaderf ?

vim-fzf has a `Snippets` command, but it doesn't provide enough information for each snippet and it can't work correctly in INSERT mode:

![](https://github.com/skywind3000/images/raw/master/p/snippet/fzf-snippets.png)

Compare to fzf, Leaderf has a NORMAL mode which allows me to browse my snippets more easily like in a normal vim window:

![](https://github.com/skywind3000/images/raw/master/p/snippet/snippet2.gif)

Browse my snippets with full of details. No worry about forgetting snippets.

## TODO

- [x] snipmate
- [x] ultisnips
- [x] snipmate preview
- [x] ultisnips preview
- [ ] minisnip 

## Credit

- [Leaderf](https://github.com/Yggdroot/LeaderF): An efficient fuzzy finder that helps to locate files, buffers, mrus, gtags, etc. on the fly.

