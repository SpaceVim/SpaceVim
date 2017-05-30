# [Layers](https://spacevim.org/layers) > colorscheme

This layer provides many Vim colorschemes for SpaceVim, the default colorscheme is gruvbox.

To change the colorscheme:
```vim
let g:spacevim_colorscheme = 'onedark'
```

Some colorschemes offer dark and light styles. Most of them are set by changing
Vim background color. SpaceVim support to change the background color with
`g:spacevim_colorscheme_bg`:
```vim
let g:spacevim_colorscheme_bg = 'dark'
```

Among SpaceVim colorschemes supported, there are some that looks like Atom
editor color styles: dark and light.
For Atom dark color scheme use _onedark_ or _neodark_ in `g:spacevim_colorscheme`.
For Atom light color scheme use _one_. vim-one plugin offer _one_ colorscheme and it
supports dark and light styles, but dark style doesn't work well with SpaceVim.
Check [#507](https://github.com/SpaceVim/SpaceVim/issues/507) for further discussion.
