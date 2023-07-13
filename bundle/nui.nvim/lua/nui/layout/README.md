# Layout

Layout is a helper component for creating complex layout by automatically
handling the calculation for position and size of other components.

**Example**

```lua
local Layout = require("nui.layout")
local Popup = require("nui.popup")

local top_popup = Popup({ border = "single" })
local bottom_popup = Popup({ border = "double" })

local layout = Layout(
  {
    position = "50%",
    size = {
      width = 80,
      height = 40,
    },
  },
  Layout.Box({
    Layout.Box(top_popup, { size = "40%" }),
    Layout.Box(bottom_popup, { size = "60%" }),
  }, { dir = "col" })
)

layout:mount()
```

_Signature:_ `Layout(options, box)` or `Layout(component, box)`

`component` can be `Popup` or `Split`.

## Options

### `relative`

**Type:** `string` or `table`

This option affects how `position` and `size` are calculated.

**Examples**

Relative to cursor on current window:

```lua
relative = "cursor",
```

Relative to the current editor screen:

```lua
relative = "editor",
```

Relative to the current window (_default_):

```lua
relative = "win",
```

Relative to the window with specific id:

```lua
relative = {
  type = "win",
  winid = 5,
},
```

Relative to the buffer position:

```lua
relative = {
  type = "buf",
  -- zero-indexed
  position = {
    row = 5,
    col = 5,
  },
},
```

---

### `position`

**Type:** `number` or `percentage string` or `table`

Position is calculated from the top-left corner.

If `position` is `number` or `percentage string`, it applies to both `row` and `col`.
Or you can pass a table to set them separately.

For `percentage string`, position is calculated according to the option `relative`.
If `relative` is set to `"buf"` or `"cursor"`, `percentage string` is not allowed.

**Examples**

```lua
position = 50,
```

```lua
position = "50%",
```

```lua
position = {
  row = 30,
  col = 20,
},
```

```lua
position = {
  row = "20%",
  col = "50%",
},
```

---

### `size`

**Type:** `number` or `percentage string` or `table`

Determines the size of the layout.

If `size` is `number` or `percentage string`, it applies to both `width` and `height`.
You can also pass a table to set them separately.

For `percentage string`, `size` is calculated according to the option `relative`.
If `relative` is set to `"buf"` or `"cursor"`, window size is considered.

**Examples**

```lua
size = 50,
```

```lua
size = "50%",
```

```lua
size = {
  width = 80,
  height = 40,
},
```

```lua
size = {
  width = "80%",
  height = "60%",
},
```

## Layout.Box

_Signature:_ `Layout.Box(box, options)`

**Parameters**

| Name      | Type                           | Description                               |
| --------- | ------------------------------ | ----------------------------------------- |
| `box`     | `Layout.Box[]` / nui component | list of `Layout.Box` or any nui component |
| `options` | `table`                        | box options                               |

`options` is a `table` having the following keys:

| Key    | Type                          | Description                                            |
| ------ | ----------------------------- | ------------------------------------------------------ |
| `dir`  | `"col"` / `"row"` (_default_) | arrangement direction, only if `box` is `Layout.Box[]` |
| `grow` | `number`                      | growth factor to fill up the box free space            |
| `size` | `number` / `string` / `table` | optional if `grow` is present                          |

## Methods

### `layout:mount`

_Signature:_ `layout:mount()`

Mounts the layout with all the components.

**Examples**

```lua
layout:mount()
```

### `layout:unmount`

_Signature:_ `layout:unmount()`

Unmounts the layout with all the components.

**Examples**

```lua
layout:unmount()
```

### `layout:hide`

_Signature:_ `layout:hide()`

Hides the layout with all the components. Preserves the buffer (related content, autocmds and keymaps).

### `layout:show`

_Signature:_ `layout:show()`

Shows the hidden layout with all the components.

### `layout:update`

_Signature:_ `layout:update(config, box?)` or `layout:update(box?)`

**Parameters**

`config` is a `table` having the following keys:

| Key        | Type               |
| ---------- | ------------------ |
| `relative` | `string` / `table` |
| `position` | `string` / `table` |
| `size`     | `string` / `table` |

`box` is a `table` returned by `Layout.Box`.

They are the same options used for layout initialization.

## Wiki Page

You can find additional documentation/examples/guides/tips-n-tricks in
[nui.layout wiki page](https://github.com/MunifTanjim/nui.nvim/wiki/nui.layout).
