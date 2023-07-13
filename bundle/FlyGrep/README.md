# FlyGrep.vim
> Asynchronously fly grep in vim

This plugin is automatically detach from [SpaceVim](https://github.com/SpaceVim/SpaceVim/). you can use it without SpaceVim.

![searching project](https://img.spacevim.org/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif)

## Install

for dein.vim

```vim
call dein#add('wsdjeg/FlyGrep.vim')
```

for vim-plug

```vim
Plug 'wsdjeg/FlyGrep.vim'
```

## usage

```
:FlyGrep
```

you also can define custom mapping, for example:

```vim
nnoremap <Space>s/ :FlyGrep<cr>
```

Key Binding |	Description
-----------| -----------
`SPC s /` | Searching in project on the fly with default tools

key binding in FlyGrep buffer:

Key Binding |	Description
-----------| -----------
`<Esc>` | close FlyGrep buffer
`<C-c>` | close FlyGrep buffer
`<Enter>` | open file at the cursor line
`<Tab>` | move cursor line down
`<C-j>` | move cursor line down
`<S-Tab>` | move cursor line up
`<C-k>` | move cursor line up
`<Bs>` | remove last character
`<C-w>` | remove the Word before the cursor
`<C-u>` | remove the Line before the cursor
`<C-k>` | remove the Line after the cursor
`<C-a>`/`<Home>` | Go to the beginning of the line
`<C-e>`/`<End>` | Go to the end of the line

