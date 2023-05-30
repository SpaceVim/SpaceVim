# NuiText

NuiText is an abstraction layer on top of the following native functions:

- `vim.api.nvim_buf_set_text` (check `:h nvim_buf_set_text()`)
- `vim.api.nvim_buf_set_extmark` (check `:h nvim_buf_set_extmark()`)

It helps you set text and add highlight for it on the buffer.

_Signature:_ `NuiText(content, extmark?)`

**Examples**

```lua
local NuiText = require("nui.text")

local text = NuiText("Something Went Wrong!", "Error")

local bufnr, ns_id, linenr_start, byte_start = 0, -1, 1, 0

text:render(bufnr, ns_id, linenr_start, byte_start)
```

## Parameters

### `content`

**Type:** `string` or `table`

Text content or `NuiText` object.

If `NuiText` object is passed, a copy of it is created.

### `extmark`

**Type:** `string` or `table`

Highlight group name or extmark options.

If a `string` is passed, it is used as the highlight group name.

If a `table` is passed it is used as extmark data. It can have the
following keys:

| Key          | Description          |
| ------------ | -------------------- |
| `"hl_group"` | highlight group name |

For more, check `:help nvim_buf_set_extmark()`.

## Methods

### `text:set`

_Signature:_ `text:set(content, extmark?)`

Sets the text content and highlight information.

**Parameters**

| Name      | Type                | Description                             |
| --------- | ------------------- | --------------------------------------- |
| `content` | `string`            | text content                            |
| `extmark` | `string` or `table` | highlight group name or extmark options |

This `extmark` parameter is exactly the same as `NuiText`'s `extmark` parameter.

### `text:content`

_Signature:_ `text:content()`

Returns the text content.

### `text:length`

_Signature:_ `text:length()`

Returns the byte length of the text.

### `text:width`

_Signature:_ `text:width()`

Returns the character length of the text.

### `text:highlight`

_Signature:_ `text:highlight(bufnr, ns_id, linenr, byte_start)`

Applies highlight for the text.

**Parameters**

| Name         | Type     | Description                                        |
| ------------ | -------- | -------------------------------------------------- |
| `bufnr`      | `number` | buffer number                                      |
| `ns_id`      | `number` | namespace id (use `-1` for fallback namespace)     |
| `linenr`     | `number` | line number (1-indexed)                            |
| `byte_start` | `number` | start position of the text on the line (0-indexed) |

### `text:render`

_Signature:_ `text:render(bufnr, ns_id, linenr_start, byte_start, linenr_end?, byte_end?)`

Sets the text on buffer and applies highlight.

**Parameters**

| Name           | Type     | Description                                        |
| -------------- | -------- | -------------------------------------------------- |
| `bufnr`        | `number` | buffer number                                      |
| `ns_id`        | `number` | namespace id (use `-1` for fallback namespace)     |
| `linenr_start` | `number` | start line number (1-indexed)                      |
| `byte_start`   | `number` | start position of the text on the line (0-indexed) |
| `linenr_end`   | `number` | end line number (1-indexed)                        |
| `byte_end`     | `number` | end position of the text on the line (0-indexed)   |

### `text:render_char`

_Signature:_ `text:render_char(bufnr, ns_id, linenr_start, char_start, linenr_end?, char_end?)`

Sets the text on buffer and applies highlight.

This does the thing as `text:render` method, but you can use character count
instead of byte count. It will convert multibyte character count to appropriate
byte count for you.

**Parameters**

| Name           | Type     | Description                                        |
| -------------- | -------- | -------------------------------------------------- |
| `bufnr`        | `number` | buffer number                                      |
| `ns_id`        | `number` | namespace id (use `-1` for fallback namespace)     |
| `linenr_start` | `number` | start line number (1-indexed)                      |
| `char_start`   | `number` | start position of the text on the line (0-indexed) |
| `linenr_end`   | `number` | end line number (1-indexed)                        |
| `char_end`     | `number` | end position of the text on the line (0-indexed)   |

## Wiki Page

You can find additional documentation/examples/guides/tips-n-tricks in [nui.text wiki page](https://github.com/MunifTanjim/nui.nvim/wiki/nui.text).
