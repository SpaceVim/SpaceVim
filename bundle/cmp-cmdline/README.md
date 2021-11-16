# cmp-cmdline

nvim-cmp source for vim's cmdline.

# Setup

```lua
require'cmp'.setup.cmdline(':', {
  sources = {
    { name = 'cmdline' }
  }
})
```
