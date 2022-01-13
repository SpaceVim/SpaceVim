# lspkind-nvim

This tiny plugin adds vscode-like pictograms to neovim built-in lsp:

![Screenshot](https://github.com/onsails/lspkind-nvim/raw/images/images/screenshot.png "Screenshot")
<sup>[nvim-compe](https://github.com/hrsh7th/nvim-compe), [vim-vsnip](https://github.com/hrsh7th/vim-vsnip), [vim-vsnip-integ](https://github.com/hrsh7th/vim-vsnip-integ), [jellybeans-nvim](https://github.com/metalelf0/jellybeans-nvim)</sup>

## Configuration

### Option 1: vanilla Neovim LSP

Wherever you configure lsp put the following lua command:

```lua
require('lspkind').init({
    -- enables text annotations
    --
    -- default: true
    with_text = true,

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = ""
    },
})
```

### Option 2: [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

```lua
local lspkind = require('lspkind')
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({with_text = false, maxwidth = 50})
  }
}
```

## Related LSP plugins

[diaglist.nvim](https://github.com/onsails/diaglist.nvim) – live render workspace diagnostics in quickfix with current buf errors on top, buffer diagnostics in loclist
