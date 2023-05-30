![GitHub Workflow Status: CI](https://img.shields.io/github/actions/workflow/status/MunifTanjim/nui.nvim/ci.yml?branch=main&label=CI&style=for-the-badge)
[![Coverage](https://img.shields.io/codecov/c/gh/MunifTanjim/nui.nvim/master?style=for-the-badge)](https://codecov.io/gh/MunifTanjim/nui.nvim)
[![Version](https://img.shields.io/luarocks/v/MunifTanjim/nui.nvim?color=%232c3e67&style=for-the-badge)](https://luarocks.org/modules/MunifTanjim/nui.nvim)
![License](https://img.shields.io/github/license/MunifTanjim/nui.nvim?color=%23000080&style=for-the-badge)

# nui.nvim

UI Component Library for Neovim.

## Requirements

- [Neovim 0.5.0](https://github.com/neovim/neovim/releases/tag/v0.5.0)

## Installation

Install the plugins with your preferred plugin manager. For example, with [`vim-plug`](https://github.com/junegunn/vim-plug):

```vim
Plug 'MunifTanjim/nui.nvim'
```

## Blocks

### [NuiText](lua/nui/text)

Quickly add highlighted text on the buffer.

**[Check Detailed Documentation for `nui.text`](lua/nui/text)**

**[Check Wiki Page for `nui.text`](https://github.com/MunifTanjim/nui.nvim/wiki/nui.text)**

### [NuiLine](lua/nui/line)

Quickly add line containing highlighted text chunks on the buffer.

**[Check Detailed Documentation for `nui.line`](lua/nui/line)**

**[Check Wiki Page for `nui.line`](https://github.com/MunifTanjim/nui.nvim/wiki/nui.line)**

### [NuiTree](lua/nui/tree)

Quickly render tree-like structured content on the buffer.

**[Check Detailed Documentation for `nui.tree`](lua/nui/tree)**

**[Check Wiki Page for `nui.tree`](https://github.com/MunifTanjim/nui.nvim/wiki/nui.tree)**

## Components

### [Layout](lua/nui/layout)

![Layout GIF](https://github.com/MunifTanjim/nui.nvim/wiki/media/layout.gif)

```lua
local Popup = require("nui.popup")
local Layout = require("nui.layout")

local popup_one, popup_two = Popup({
  enter = true,
  border = "single",
}), Popup({
  border = "double",
})

local layout = Layout(
  {
    position = "50%",
    size = {
      width = 80,
      height = "60%",
    },
  },
  Layout.Box({
    Layout.Box(popup_one, { size = "40%" }),
    Layout.Box(popup_two, { size = "60%" }),
  }, { dir = "row" })
)

local current_dir = "row"

popup_one:map("n", "r", function()
  if current_dir == "col" then
    layout:update(Layout.Box({
      Layout.Box(popup_one, { size = "40%" }),
      Layout.Box(popup_two, { size = "60%" }),
    }, { dir = "row" }))

    current_dir = "row"
  else
    layout:update(Layout.Box({
      Layout.Box(popup_two, { size = "60%" }),
      Layout.Box(popup_one, { size = "40%" }),
    }, { dir = "col" }))

    current_dir = "col"
  end
end, {})

layout:mount()
```

**[Check Detailed Documentation for `nui.layout`](lua/nui/layout)**

**[Check Wiki Page for `nui.layout`](https://github.com/MunifTanjim/nui.nvim/wiki/nui.layout)**

### [Popup](lua/nui/popup)

![Popup GIF](https://github.com/MunifTanjim/nui.nvim/wiki/media/popup.gif)

```lua
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local popup = Popup({
  enter = true,
  focusable = true,
  border = {
    style = "rounded",
  },
  position = "50%",
  size = {
    width = "80%",
    height = "60%",
  },
})

-- mount/open the component
popup:mount()

-- unmount component when cursor leaves buffer
popup:on(event.BufLeave, function()
  popup:unmount()
end)

-- set content
vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { "Hello World" })
```

**[Check Detailed Documentation for `nui.popup`](lua/nui/popup)**

**[Check Wiki Page for `nui.popup`](https://github.com/MunifTanjim/nui.nvim/wiki/nui.popup)**

### [Input](lua/nui/input)

![Input GIF](https://github.com/MunifTanjim/nui.nvim/wiki/media/input.gif)

```lua
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local input = Input({
  position = "50%",
  size = {
    width = 20,
  },
  border = {
    style = "single",
    text = {
      top = "[Howdy?]",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal,FloatBorder:Normal",
  },
}, {
  prompt = "> ",
  default_value = "Hello",
  on_close = function()
    print("Input Closed!")
  end,
  on_submit = function(value)
    print("Input Submitted: " .. value)
  end,
})

-- mount/open the component
input:mount()

-- unmount component when cursor leaves buffer
input:on(event.BufLeave, function()
  input:unmount()
end)
```

**[Check Detailed Documentation for `nui.input`](lua/nui/input)**

**[Check Wiki Page for `nui.input`](https://github.com/MunifTanjim/nui.nvim/wiki/nui.input)**

### [Menu](lua/nui/menu)

![Menu GIF](https://github.com/MunifTanjim/nui.nvim/wiki/media/menu.gif)

```lua
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local menu = Menu({
  position = "50%",
  size = {
    width = 25,
    height = 5,
  },
  border = {
    style = "single",
    text = {
      top = "[Choose-an-Element]",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal,FloatBorder:Normal",
  },
}, {
  lines = {
    Menu.item("Hydrogen (H)"),
    Menu.item("Carbon (C)"),
    Menu.item("Nitrogen (N)"),
    Menu.separator("Noble-Gases", {
      char = "-",
      text_align = "right",
    }),
    Menu.item("Helium (He)"),
    Menu.item("Neon (Ne)"),
    Menu.item("Argon (Ar)"),
  },
  max_width = 20,
  keymap = {
    focus_next = { "j", "<Down>", "<Tab>" },
    focus_prev = { "k", "<Up>", "<S-Tab>" },
    close = { "<Esc>", "<C-c>" },
    submit = { "<CR>", "<Space>" },
  },
  on_close = function()
    print("Menu Closed!")
  end,
  on_submit = function(item)
    print("Menu Submitted: ", item.text)
  end,
})

-- mount the component
menu:mount()
```

**[Check Detailed Documentation for `nui.menu`](lua/nui/menu)**

**[Check Wiki Page for `nui.menu`](https://github.com/MunifTanjim/nui.nvim/wiki/nui.menu)**

### [Split](lua/nui/split)

![Split GIF](https://github.com/MunifTanjim/nui.nvim/wiki/media/split.gif)

```lua
local Split = require("nui.split")
local event = require("nui.utils.autocmd").event

local split = Split({
  relative = "editor",
  position = "bottom",
  size = "20%",
})

-- mount/open the component
split:mount()

-- unmount component when cursor leaves buffer
split:on(event.BufLeave, function()
  split:unmount()
end)
```

**[Check Detailed Documentation for `nui.split`](lua/nui/split)**

**[Check Wiki Page for `nui.split`](https://github.com/MunifTanjim/nui.nvim/wiki/nui.split)**

## Extendibility

Each of the [blocks](#blocks) and [components](#components) can be extended to add new
methods or change their behaviors.

```lua
local Timer = Popup:extend("Timer")

function Timer:init(popup_options)
  local options = vim.tbl_deep_extend("force", popup_options or {}, {
    border = "double",
    focusable = false,
    position = { row = 0, col = "100%" },
    size = { width = 10, height = 1 },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:SpecialChar",
    },
  })

  Timer.super.init(self, options)
end

function Timer:countdown(time, step, format)
  local function draw_content(text)
    local gap_width = 10 - vim.api.nvim_strwidth(text)
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, {
      string.format(
        "%s%s%s",
        string.rep(" ", math.floor(gap_width / 2)),
        text,
        string.rep(" ", math.ceil(gap_width / 2))
      ),
    })
  end

  self:mount()

  local remaining_time = time

  draw_content(format(remaining_time))

  vim.fn.timer_start(step, function()
    remaining_time = remaining_time - step

    draw_content(format(remaining_time))

    if remaining_time <= 0 then
      self:unmount()
    end
  end, { ["repeat"] = math.ceil(remaining_time / step) })
end

local timer = Timer()

timer:countdown(10000, 1000, function(time)
  return tostring(time / 1000) .. "s"
end)
```

#### `nui.object`

A small object library is bundled with `nui.nvim`. It is, more or less, a clone of the
[`kikito/middleclass`](https://github.com/kikito/middleclass) library.

[Check Wiki Page for `nui.object`](https://github.com/MunifTanjim/nui.nvim/wiki/nui.object)

## License

Licensed under the MIT License. Check the [LICENSE](./LICENSE) file for details.
