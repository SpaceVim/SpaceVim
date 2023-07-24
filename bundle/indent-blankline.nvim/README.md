# Indent Blankline

This plugin adds indentation guides to all lines (including empty lines).

It uses Neovim's virtual text feature and **no conceal**

This plugin requires Neovim 0.5 or higher. It makes use of Neovim only
features so it will not work in Vim.
There is a legacy version of the plugin that supports Neovim 0.4 under the
branch `version-1`

## Install

Use your favourite plugin manager to install.

For [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ "lukas-reineke/indent-blankline.nvim" },
```

For [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use "lukas-reineke/indent-blankline.nvim"
```

For [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'lukas-reineke/indent-blankline.nvim'
```

## Setup

To configure indent-blankline, either run the setup function, or set variables manually.
The setup function has a single table as argument, keys of the table match the `:help indent-blankline-variables` without the `indent_blankline_` part.

```lua
require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
}
```

Please see `:help indent_blankline.txt` for more details and all possible values.

A lot of [Yggdroot/indentLine](https://github.com/Yggdroot/indentLine) options should work out of the box.

## Screenshots

All screenshots use [my custom onedark color scheme](https://github.com/lukas-reineke/onedark.nvim).

### Simple

```lua
vim.opt.list = true
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    show_end_of_line = true,
}
```

<img width="900" src="https://i.imgur.com/3gRG5qI.png" alt="Screenshot" />

#### With custom `listchars` and `g:indent_blankline_space_char_blankline`

```lua
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " ",
}
```

<img width="900" src="https://i.imgur.com/VxCThMu.png" alt="Screenshot" />

#### With custom `g:indent_blankline_char_highlight_list`

```lua
vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    space_char_blankline = " ",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
}
```

<img width="900" src="https://i.imgur.com/E3B0PUb.png" alt="Screenshot" />

#### With custom background highlight

```lua
vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]

require("indent_blankline").setup {
    char = "",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
    },
    space_char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
    },
    show_trailing_blankline_indent = false,
}
```

<img width="900" src="https://i.imgur.com/DukMZGk.png" alt="Screenshot" />

#### With context indent highlighted by treesitter

```lua
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
```

<img width="900" src="https://user-images.githubusercontent.com/12900252/188080732-5b7d98b9-3cb8-4789-b28d-67cad0bfbcde.png" alt="Screenshot" />

`show_current_context_start` uses underline, so to achieve the best result you
might need to tweak the underline position. In Kitty terminal for example you
can do that with [modify_font](https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.modify_font)

## Thanks

Special thanks to [Yggdroot/indentLine](https://github.com/Yggdroot/indentLine)
