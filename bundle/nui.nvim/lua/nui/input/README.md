# Input

Input is an abstraction layer on top of Popup.

It uses prompt buffer (check `:h prompt-buffer`) for its popup window.

```lua
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local popup_options = {
  relative = "cursor",
  position = {
    row = 1,
    col = 0,
  },
  size = 20,
  border = {
    style = "rounded",
    text = {
      top = "[Input]",
      top_align = "left",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal",
  },
}

local input = Input(popup_options, {
  prompt = "> ",
  default_value = "42",
  on_close = function()
    print("Input closed!")
  end,
  on_submit = function(value)
    print("Value submitted: ", value)
  end,
  on_change = function(value)
    print("Value changed: ", value)
  end,
})
```

If you provide the `on_change` function, it'll be run everytime value changes.

Pressing `<CR>` runs the `on_submit` callback function and closes the window.
Pressing `<C-c>` runs the `on_close` callback function and closes the window.

Of course, you can override the default keymaps and add more. For example:

```lua
-- unmount input by pressing `<Esc>` in normal mode
input:map("n", "<Esc>", function()
  input:unmount()
end, { noremap = true })
```

You can manipulate the assocciated buffer and window using the
`split.bufnr` and `split.winid` properties.

**NOTE**: the first argument accepts options for `nui.popup` component.

## Options

### `prompt`

**Type:** `string` or `NuiText`

Prefix in the input.

### `default_value`

**Type:** `string`

Default value placed in the input on mount

### `on_close`

Callback function, called when input is closed.

### `on_submit`

Callback function, called when input value is submitted.

### `on_change`

Callback function, called when input value is changed.

### `disable_cursor_position_patch`

By default, `nui.input` will try to make sure the cursor on parent window is not
moved after input is submitted/closed. If you want to disable this behavior
for some reason, you can set `disable_cursor_position_patch` to `true`.

## Methods

Methods from `nui.popup` are also available for `nui.input`.

## Wiki Page

You can find additional documentation/examples/guides/tips-n-tricks in [nui.input wiki page](https://github.com/MunifTanjim/nui.nvim/wiki/nui.input).
