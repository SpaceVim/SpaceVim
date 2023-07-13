# Menu

`Menu` is abstraction layer on top of `Popup`.

```lua
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local popup_options = {
  relative = "cursor",
  position = {
    row = 1,
    col = 0,
  },
  border = {
    style = "rounded",
    text = {
      top = "[Choose Item]",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal",
  }
}

local menu = Menu(popup_options, {
  lines = {
    Menu.separator("Group One"),
    Menu.item("Item 1"),
    Menu.item("Item 2"),
    Menu.separator("Group Two", {
      char = "-",
      text_align = "right",
    }),
    Menu.item("Item 3"),
    Menu.item("Item 4"),
  },
  max_width = 20,
  keymap = {
    focus_next = { "j", "<Down>", "<Tab>" },
    focus_prev = { "k", "<Up>", "<S-Tab>" },
    close = { "<Esc>", "<C-c>" },
    submit = { "<CR>", "<Space>" },
  },
  on_close = function()
    print("CLOSED")
  end,
  on_submit = function(item)
    print("SUBMITTED", vim.inspect(item))
  end,
})
```

You can manipulate the assocciated buffer and window using the
`split.bufnr` and `split.winid` properties.

**NOTE**: the first argument accepts options for `nui.popup` component.

## Options

### `lines`

**Type:** `table`

List of menu items.

**`Menu.item(content, data?)`**

`Menu.item` is used to create an item object for the `Menu`.

**Parameters**

| Name      | Type                             |
| --------- | -------------------------------- |
| `content` | `string` / `NuiText` / `NuiLine` |
| `data`    | `table` / `nil`                  |

**Example**

```lua
Menu.item("One") --> { text = "One" }

Menu.item("Two", { id = 2 }) --> { id = 2, text = "Two" }
```

This is what you get as the argument of `on_submit` callback function.
You can include whatever you want in the item object.

**`Menu.separator(content?, options?)`**

`Menu.separator` is used to create a menu item that can't be focused.

**Parameters**

| Name      | Type                                                                               |
| --------- | ---------------------------------------------------------------------------------- |
| `content` | `string` / `NuiText` / `NuiLine` / `nil`                                           |
| `options` | `{ char?: string\|NuiText, text_align?: "'left'"\|"'center'"\|"'right'" }` / `nil` |

You can just use `Menu.item` only and implement `Menu.separator`'s behavior
by providing a custom `should_skip_item` function.

### `prepare_item`

**Type:** `function`

_Signature:_ `prepare_item(item)`

If provided, this function is used for preparing each menu item.

The return value should be a `NuiLine` object or `string` or a list containing either of them.

If return value is `nil`, that node will not be rendered.

### `should_skip_item`

**Type:** `function`

_Signature:_ `should_skip_item(item)`

If provided, this function is used to determine if an item should be
skipped when focusing previous/next item.

The return value should be `boolean`.

By default, items created by `Menu.separator` are skipped.

### `max_height`

**Type:** `number`

Maximum height of the menu.

### `min_height`

**Type:** `number`

Minimum height of the menu.

### `max_width`

**Type:** `number`

Maximum width of the menu.

### `min_width`

**Type:** `number`

Minimum width of the menu.

### `keymap`

**Type:** `table`

Key mappings for the menu.

**Example**

```lua
keymap = {
  close = { "<Esc>", "<C-c>" },
  focus_next = { "j", "<Down>", "<Tab>" },
  focus_prev = { "k", "<Up>", "<S-Tab>" },
  submit = { "<CR>" },
},
```

### `on_change`

**Type:** `function`

_Signature:_ `on_change(item, menu)`

Callback function, called when menu item is focused.

### `on_close`

**Type:** `function`

_Signature:_ `on_close(item, menu)`

Callback function, called when menu is closed.

### `on_submit`

**Type:** `function`

_Signature:_ `on_submit(item)`

Callback function, called when menu is submitted.

## Methods

Methods from `nui.popup` are also available for `nui.menu`.

## Properties

### `menu.tree`

The underlying `NuiTree` object used for rendering the menu. You can use it to
manipulate the menu items on-the-fly and access all the `NuiTree` methods.

## Wiki Page

You can find additional documentation/examples/guides/tips-n-tricks in [nui.menu wiki page](https://github.com/MunifTanjim/nui.nvim/wiki/nui.menu).
