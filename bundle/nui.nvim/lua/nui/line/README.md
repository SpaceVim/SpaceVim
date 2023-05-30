# NuiLine

NuiLine is an abstraction layer on top of the following native functions:

- `vim.api.nvim_buf_set_lines` (check `:h nvim_buf_set_lines()`)
- `vim.api.nvim_buf_set_text` (check `:h nvim_buf_set_text()`)
- `vim.api.nvim_buf_add_highlight` (check `:h nvim_buf_add_highlight()`)

It helps you create line on the buffer containing multiple [`NuiText`](../text)s.

_Signature:_ `NuiLine(texts?)`

**Example**

```lua
local NuiLine = require("nui.line")

local line = NuiLine()

line:append("Something Went Wrong!", "Error")

local bufnr, ns_id, linenr_start = 0, -1, 1

line:render(bufnr, ns_id, linenr_start)
```

## Parameters

### `texts`

**Type:** `table[]`

List of `NuiText` objects to set as initial texts.

**Example**

```lua
local text_one = NuiText("One")
local text_two = NuiText("Two")
local line = NuiLine({ text_one, text_two })
```

## Methods

### `line:append`

_Signature:_ `line:append(content, highlight?)`

Adds a chunk of content to the line.

**Parameters**

| Name        | Type                             | Description           |
| ----------- | -------------------------------- | --------------------- |
| `content`   | `string` / `NuiText` / `NuiLine` | content               |
| `highlight` | `string` or `table`              | highlight information |

If `text` is `string`, these parameters are passed to `NuiText`
and a `NuiText` object is returned.

It `content` is a `NuiText`/`NuiLine` object, it is returned unchanged.

### `line:content`

_Signature:_ `line:content()`

Returns the line content.

### `line:highlight`

_Signature:_ `line:highlight(bufnr, ns_id, linenr)`

Applies highlight for the line.

**Parameters**

| Name     | Type     | Description                                    |
| -------- | -------- | ---------------------------------------------- |
| `bufnr`  | `number` | buffer number                                  |
| `ns_id`  | `number` | namespace id (use `-1` for fallback namespace) |
| `linenr` | `number` | line number (1-indexed)                        |

### `line:render`

_Signature:_ `line:render(bufnr, ns_id, linenr_start, linenr_end?)`

Sets the line on buffer and applies highlight.

**Parameters**

| Name           | Type     | Description                                    |
| -------------- | -------- | ---------------------------------------------- |
| `bufnr`        | `number` | buffer number                                  |
| `ns_id`        | `number` | namespace id (use `-1` for fallback namespace) |
| `linenr_start` | `number` | start line number (1-indexed)                  |
| `linenr_end`   | `number` | end line number (1-indexed)                    |

## Wiki Page

You can find additional documentation/examples/guides/tips-n-tricks in [nui.line wiki page](https://github.com/MunifTanjim/nui.nvim/wiki/nui.line).
