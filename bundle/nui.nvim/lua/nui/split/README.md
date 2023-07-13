# Split

Split is can be used to split your current window or editor.

```lua
local Split = require("nui.split")

local split = Split({
  relative = "editor",
  position = "bottom",
  size = "20%",
})
```

You can manipulate the assocciated buffer and window using the
`split.bufnr` and `split.winid` properties.

## Options

### `ns_id`

**Type:** `number` or `string`

Namespace id (`number`) or name (`string`).

### `relative`

**Type:** `string` or `table`

This option affects how `size` is calculated.

**Examples**

Split current editor screen:

```lua
relative = "editor"
```

Split current window (_default_):

```lua
relative = "win"
```

Split window with specific id:

```lua
relative = {
  type = "win",
  winid = 42,
}
```

### `position`

`position` can be one of: `"top"`, `"right"`, `"bottom"` or `"left"`.

### `size`

`size` can be `number` or `percentage string`.

For `percentage string`, size is calculated according to the option `relative`.

### `enter`

**Type:** `boolean`

If `false`, the split is not entered immediately after mount.

**Examples**

```lua
enter = false
```

### `buf_options`

Table containing buffer options to set for this split.

### `win_options`

Table containing window options to set for this split.

## Methods

[Methods from `nui.popup`](/lua/nui/popup#methods) are also available for `nui.split`.

## Wiki Page

You can find additional documentation/examples/guides/tips-n-tricks in [nui.split wiki page](https://github.com/MunifTanjim/nui.nvim/wiki/nui.split).
