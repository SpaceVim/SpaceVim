# Notice
Nerd fonts moved some symbols with version 3.0. Version 2.3 is meant for transition, supporting both version 2 and version 3 icons.

Nvim-web-devicons requires version 2.3 or above to work properly. If you are unable to update please use your plugin manager to pin version of nvim-web-dev icons to `nerd-v2-compat` tag.

# Nvim-web-devicons

A `lua` fork of [vim-devicons](https://github.com/ryanoasis/vim-devicons). This plugin provides the same icons _as well as_ colors for each icon.

Light and dark color variants are provided.

## Requirements

- [neovim >=0.7.0](https://github.com/neovim/neovim/wiki/Installing-Neovim)
- [A patched font](https://www.nerdfonts.com/)

## Installation

```vim
Plug 'nvim-tree/nvim-web-devicons'
```

or with [packer.nvim](https://github.com/wbthomason/packer.nvim)

```
use 'nvim-tree/nvim-web-devicons'
```

## Usage

### Variants

Light or dark color variants of the icons depend on `&background`.

These will be updated following `OptionSet` `background` however be advised that the plugin using nvim-web-devicons may have cached the icons.

### Setup

This adds all the highlight groups for the devicons
i.e. it calls `vim.api.nvim_set_hl` for all icons
this might need to be re-called in a `Colorscheme` to re-apply cleared highlights
if the color scheme changes

```lua
require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  }
 };
}
```

### Get Icon

Get the icon for a given file by passing in the `name`, the `extension` and an _optional_ options `table`.
The name is passed in to check for an exact match e.g. `.bashrc` if there is no exact name match the extension
is used. Calls `.setup()` if it hasn't already ran.

```lua
require'nvim-web-devicons'.get_icon(filename, extension, options)
```

The optional `options` argument can used to change how the plugin works the keys include
`default = <boolean>` and `strict = <boolean>`. If the default key is set to true this
function will return a default if there is no matching icon. If the strict key is set
to true this function will lookup icon specifically by filename, and if not found then
specifically by extension, and fallback to default icon if default key is set to true.
e.g.

```lua
require'nvim-web-devicons'.get_icon(filename, extension, { default = true })
```

You can check if the setup function was already called with:
```lua
require'nvim-web-devicons'.has_loaded()
```

### Get icon and color code

`get_icon_color` differs from `get_icon` only in the second return value.
`get_icon_cterm_color` returns cterm color instead of gui color
`get_icon` returns icon and highlight name.
If you want to get color code, you can use this function.
```lua
local icon, color = require'nvim-web-devicons'.get_icon_color("init.lua", "lua")
assert(icon == "")
assert(color == "#51a0cf")
```

### Get all icons

It is possible to get all of the registered icons with the `get_icons()` function:

```lua
require'nvim-web-devicons'.get_icons()
```

This can be useful for debugging purposes or for creating custom highlights for each icon.


### Set an icon

You can override individual icons with the `set_icon({...})` function:

```lua
require("nvim-web-devicons").set_icon {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
}
```

You can override the default icon with the `set_default_icon(icon, color, cterm_color)` function:

```lua
require("nvim-web-devicons").set_default_icon('', '#6d8086', 65)
```

### Getting icons by filetype

You can get the icon and colors associated with a filetype using the `by_filetype` functions:

```lua
require("nvim-web-devicons").get_icon_by_filetype(filetype, opts)
require("nvim-web-devicons").get_icon_colors_by_filetype(filetype, opts)
require("nvim-web-devicons").get_icon_color_by_filetype(filetype, opts)
require("nvim-web-devicons").get_icon_cterm_color_by_filetype(filetype, opts)
```

These functions are the same as their counterparts without the `_by_filetype` suffix, but they take a filetype instead of a name/extension.

You can also use `get_icon_name_by_filetype(filetype)` to get the icon name associated with the filetype.

## Contributing

PRs are always welcome! Please see [CONTRIBUTING](CONTRIBUTING.md)
