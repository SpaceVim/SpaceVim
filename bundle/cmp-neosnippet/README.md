# cmp-neosnippet

nvim-cmp source for neosnippet.

# Setup

```lua
require("cmp").setup({
  snippet = {
    expand = function(_)
      -- unused
    end,
  },
  sources = {{name = "neosnippet"}},
})
```
