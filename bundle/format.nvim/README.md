# format.nvim

Asynchronous code formatting plugin based on SpaceVim job api.

## Configuration

```lua
require('format').setup({
  custom_formatters = {
    lua = {
      exe = 'stylua',
      args = {'-'},
      stdin = true
    },
  }
})
```
