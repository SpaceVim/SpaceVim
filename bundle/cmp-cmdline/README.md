# cmp-cmdline

nvim-cmp source for vim's cmdline.

# Setup

Completions for `/` search based on current buffer:
```lua
    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })
```

Completions for command mode:
```lua
    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' }
          }
        }
      })
    })
```

For the buffer source to work, [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) is needed.


# Option

### ignore_cmds: string[]
Default: `{ "Man", "!" }`

You can specify ignore command name.

