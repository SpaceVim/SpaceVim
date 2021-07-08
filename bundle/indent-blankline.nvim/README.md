# Indent Blankline

This plugin adds indentation guides to all lines (including empty lines).

It uses Neovims virtual text feature and **no conceal**

This plugin requires Neovim 0.5 or higher. It makes use of Neovim only
features so it will not work in Vim.
There is a legacy version of the plugin that supports Neovim 0.4 under the
branch `version-1`

## Settings

A lot of [Yggdroot/indentLine](https://github.com/Yggdroot/indentLine) options
should work out of the box.

Please see `:help indent_blankline.txt`for more details.

## Install

Use your favourite plugin manager to install.

#### Example with Packer

[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
-- init.lua
require("packer").startup(
    function()
        use "lukas-reineke/indent-blankline.nvim"
    end
)
```

#### Example with Plug

[junegunn/vim-plug](https://github.com/junegunn/vim-plug)

```vim
" init.vim
call plug#begin('~/.vim/plugged')
Plug 'lukas-reineke/indent-blankline.nvim'
call plug#end()
```

## Screenshots

#### Default settings

<img width="900" src="https://i.imgur.com/3gRG5qI.png" alt="Screenshot" />

#### With custom `listchars` and `g:indent_blankline_space_char`

<img width="900" src="https://i.imgur.com/VxCThMu.png" alt="Screenshot" />

#### With custom `g:indent_blankline_char_highlight_list`

<img width="900" src="https://i.imgur.com/E3B0PUb.png" alt="Screenshot" />

#### With custom background highlight

<img width="900" src="https://i.imgur.com/DukMZGk.png" alt="Screenshot" />

#### With context indent highlighted by treesitter

<img width="900" src="https://i.imgur.com/mkyGPZZ.png" alt="Screenshot" />

## Thanks

Special thanks to [Yggdroot/indentLine](https://github.com/Yggdroot/indentLine)
