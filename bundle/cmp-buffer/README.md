# cmp-buffer

nvim-cmp source for buffer words.

# Setup

```lua
require'cmp'.setup {
  sources = {
    { name = 'buffer' }
  }
}
```

# Configuration

The below source configuration are available.


### keyword_length (type: number)

_Default:_ `3`

Specify word length to gather.


### keyword_pattern (type: string)

_Default:_ `[[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-.]\w*\)*\)]]`

A vim's regular expression for creating a word list from buffer content.

You can set this to `\k\+` if you want to use the `iskeyword` option for recognizing words.


### get_bufnrs (type: fun(): number[])

_Default:_ `function() return { vim.api.nvim_get_current_buf() } end`

A function that specifies the buffer numbers to complete.

You can use the following pre-defined recipes.

##### All buffers

```lua
get_bufnrs = function()
  return vim.api.nvim_list_bufs()
end
```

##### Visible buffers

```lua
get_bufnrs = function()
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    bufs[vim.api.nvim_win_get_buf(win)] = true
  end
  return vim.tbl_keys(bufs)
end
```
