pcall(require, "luacov")

local Popup = require("nui.popup")
local Text = require("nui.text")
local h = require("tests.helpers")

local eq = h.eq

describe("nui.popup", function()
  local popup_options = {}
  local popup

  before_each(function()
    popup_options = {
      ns_id = vim.api.nvim_create_namespace("NuiTest"),
      position = "50%",
      size = {
        height = 2,
        width = 8,
      },
    }
  end)

  after_each(function()
    if popup then
      popup:unmount()
      popup = nil
    end
  end)

  describe("(#deprecated) border.highlight", function()
    it("works for 'hl_group'", function()
      local hl_group = "NuiPopupTest"

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "rounded",
          highlight = hl_group,
          padding = { 0 },
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      eq(vim.api.nvim_win_get_option(popup.border.winid, "winhighlight"), "FloatBorder:" .. hl_group)
    end)

    it("works for 'FloatBorder:hl_group'", function()
      local hl_group = "NuiPopupTest"

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "rounded",
          highlight = "FloatBorder:" .. hl_group,
          padding = { 0 },
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      eq(vim.api.nvim_win_get_option(popup.border.winid, "winhighlight"), "FloatBorder:" .. hl_group)
    end)
  end)

  describe("border.padding", function()
    local function assert_padding(padding, target_popup)
      local border_char_size = 1

      local popup_win_config = vim.api.nvim_win_get_config(target_popup.winid)
      eq(popup_win_config.win, target_popup.border.winid)
      eq(popup_win_config.row[vim.val_idx], border_char_size + padding.top)
      eq(popup_win_config.col[vim.val_idx], border_char_size + padding.left)

      local border_win_config = vim.api.nvim_win_get_config(target_popup.border.winid)
      eq(border_win_config.width, popup_options.size.width + border_char_size * 2 + padding.right + padding.left)
      eq(border_win_config.height, popup_options.size.height + border_char_size * 2 + padding.top + padding.bottom)
    end

    it("supports list table", function()
      local padding = {
        top = 2,
        right = 2,
        bottom = 1,
        left = 1,
      }

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "rounded",
          padding = { padding.top, padding.right, padding.bottom, padding.left },
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      assert_padding(padding, popup)
    end)

    it("supports partial list table", function()
      local padding = {
        top = 2,
        right = 1,
        bottom = 2,
        left = 1,
      }

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "rounded",
          padding = { padding.top, padding.right },
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      assert_padding(padding, popup)
    end)

    it("supports map table", function()
      local padding = {
        top = 2,
        right = 2,
        bottom = 1,
        left = 1,
      }

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "rounded",
          padding = padding,
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      assert_padding(padding, popup)
    end)
  end)

  describe("border.style", function()
    describe("for complex border", function()
      it("is normalized", function()
        local index_name = {
          "top_left",
          "top",
          "top_right",
          "right",
          "bottom_right",
          "bottom",
          "bottom_left",
          "left",
        }

        local char_map

        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            padding = { 0 },
          },
        })

        popup = Popup(popup_options)
        char_map = popup.border._.char
        eq(char_map, "none")

        popup_options.border.style = "shadow"
        popup = Popup(popup_options)
        char_map = popup.border._.char
        eq(char_map, "shadow")

        popup_options.border.style = "rounded"
        popup = Popup(popup_options)
        char_map = popup.border._.char
        for _, name in ipairs(index_name) do
          eq(type(char_map[name]:content()), "string")
          eq(char_map[name].extmark.hl_group, "FloatBorder")
        end

        popup_options.border.style = h.popup.create_border_style_list()
        popup_options.border.style[1] = { popup_options.border.style[1], "TopLeft" }
        popup_options.border.style[2] = Text(popup_options.border.style[2])
        popup_options.border.style[3] = Text(popup_options.border.style[3], "TopRight")
        popup_options.border.style[6] = { popup_options.border.style[6] }
        popup = Popup(popup_options)
        char_map = popup.border._.char
        for _, name in ipairs(index_name) do
          eq(type(char_map[name]:content()), "string")
          if name == "top_left" then
            eq(char_map[name].extmark.hl_group, "TopLeft")
          elseif name == "top_right" then
            eq(char_map[name].extmark.hl_group, "TopRight")
          else
            eq(char_map[name].extmark.hl_group, "FloatBorder")
          end
        end

        popup_options.border.style = h.popup.create_border_style_map()
        popup_options.border.style.top_left = { popup_options.border.style.top_left, "TopLeft" }
        popup_options.border.style.top = Text(popup_options.border.style.top)
        popup_options.border.style.top_right = Text(popup_options.border.style.top_right, "TopRight")
        popup_options.border.style.bottom = { popup_options.border.style.bottom }
        popup = Popup(popup_options)
        char_map = popup.border._.char
        for _, name in ipairs(index_name) do
          eq(type(char_map[name]:content()), "string")
          if name == "top_left" then
            eq(char_map[name].extmark.hl_group, "TopLeft")
          elseif name == "top_right" then
            eq(char_map[name].extmark.hl_group, "TopRight")
          else
            eq(char_map[name].extmark.hl_group, "FloatBorder")
          end
        end
      end)

      it("supports string name", function()
        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            style = "rounded",
            padding = { 0 },
          },
        })

        popup = Popup(popup_options)

        popup:mount()

        h.assert_buf_lines(popup.border.bufnr, {
          "╭────────╮",
          "│        │",
          "│        │",
          "╰────────╯",
        })
      end)

      it("supports list table", function()
        local style = h.popup.create_border_style_list()

        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            style = style,
            padding = { 0 },
          },
        })

        popup = Popup(popup_options)

        popup:mount()

        h.popup.assert_border_lines(popup_options, popup.border.bufnr)
      end)

      it("supports partial list table", function()
        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            style = { "-" },
            padding = { 0 },
          },
        })

        popup = Popup(popup_options)

        popup:mount()

        popup_options.border.style = { "-", "-", "-", "-", "-", "-", "-", "-" }

        h.popup.assert_border_lines(popup_options, popup.border.bufnr)
      end)

      it("supports map table", function()
        local style = h.popup.create_border_style_map()

        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            style = style,
            padding = { 0 },
          },
        })

        popup = Popup(popup_options)

        popup:mount()

        h.popup.assert_border_lines(popup_options, popup.border.bufnr)
      end)

      it("supports (char, hl_group) tuple in partial list table", function()
        local hl_group = "NuiPopupTest"

        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            style = { { "-", hl_group } },
            padding = { 0 },
          },
        })

        popup = Popup(popup_options)

        popup:mount()

        popup_options.border.style = { "-", "-", "-", "-", "-", "-", "-", "-" }

        h.popup.assert_border_lines(popup_options, popup.border.bufnr)
        h.popup.assert_border_highlight(popup_options, popup.border.bufnr, hl_group, true)
      end)

      it("supports (char, hl_group) tuple in map table", function()
        local hl_group = "NuiPopupTest"
        local style = h.popup.create_border_style_map_with_tuple(hl_group)

        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            style = style,
            padding = { 0 },
          },
        })

        popup = Popup(popup_options)

        popup:mount()

        h.popup.assert_border_lines(popup_options, popup.border.bufnr)
        h.popup.assert_border_highlight(popup_options, popup.border.bufnr, hl_group)
      end)

      it("supports nui.text in map table", function()
        local hl_group = "NuiPopupTest"
        local style = h.popup.create_border_style_map_with_nui_text(hl_group)

        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            style = style,
            padding = { 0 },
          },
        })

        popup = Popup(popup_options)

        popup:mount()

        h.popup.assert_border_lines(popup_options, popup.border.bufnr)
        h.popup.assert_border_highlight(popup_options, popup.border.bufnr, hl_group)
      end)
    end)

    describe("for simple border", function()
      it("supports nui.text as char", function()
        local hl_group = "NuiPopupTest"

        local style = h.popup.create_border_style_list()
        style[2] = Text(style[2], hl_group)
        style[6] = Text(style[6])

        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            style = style,
          },
        })

        popup = Popup(popup_options)

        popup:mount()

        local win_config = vim.api.nvim_win_get_config(popup.winid)

        eq(win_config.border[2], { style[2]:content(), hl_group })
        eq(win_config.border[6], style[6]:content())
      end)

      it("supports (char, hl_group) tuple as char", function()
        local hl_group = "NuiPopupTest"

        local style = h.popup.create_border_style_list()
        style[2] = { style[2], hl_group }
        style[6] = { style[6] }

        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            style = style,
          },
        })

        popup = Popup(popup_options)

        popup:mount()

        local win_config = vim.api.nvim_win_get_config(popup.winid)

        eq(win_config.border[2], { style[2][1], style[2][2] })
        eq(win_config.border[6], style[6][1])
      end)

      it("throws if map table missing keys", function()
        local style = h.popup.create_border_style_map()
        style["top"] = nil

        popup_options = vim.tbl_deep_extend("force", popup_options, {
          border = {
            style = style,
          },
        })

        local ok, err = pcall(Popup, popup_options)
        eq(ok, false)
        eq(type(string.match(err, "missing named border: top")), "string")
      end)
    end)
  end)

  describe("border.text", function()
    it("throws error if borderless", function()
      local text = "popup"

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "none",
          text = {
            top = text,
          },
        },
      })

      local ok, err = pcall(Popup, popup_options)
      eq(ok, false)
      eq(type(string.match(err, "text not supported for style:")), "string")
    end)

    it("throws error if invalid border style", function()
      local text = "popup"

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "__invalid__",
          text = {
            top = text,
          },
        },
      })

      local ok, err = pcall(Popup, popup_options)
      eq(ok, false)
      eq(type(string.match(err, "invalid border style name")), "string")
    end)

    it("supports simple text", function()
      local text = "popup"

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "single",
          text = {
            top = text,
          },
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      h.assert_buf_lines(popup.border.bufnr, {
        "┌─popup──┐",
      }, 1, 1)
      h.assert_highlight(popup.border.bufnr, popup_options.ns_id, 1, text, "FloatTitle")
    end)

    it("supports nui.text", function()
      local text = "popup"
      local hl_group = "NuiPopupTest"

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "single",
          text = {
            top = Text(text),
            bottom = Text(text, hl_group),
          },
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      h.assert_buf_lines(popup.border.bufnr, {
        "┌─popup──┐",
      }, 1, 1)
      h.assert_highlight(popup.border.bufnr, popup_options.ns_id, 1, text, "FloatTitle")

      h.assert_buf_lines(popup.border.bufnr, {
        "└─popup──┘",
      }, 4, 4)
      h.assert_highlight(popup.border.bufnr, popup_options.ns_id, 4, text, hl_group)
    end)
  end)

  describe("method :mount", function()
    it("sets winhighlight correctly", function()
      local hl_group = "NuiPopupTest"
      local winhighlight = "Normal:Normal,FloatBorder:" .. hl_group

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "rounded",
          text = {
            top = "text",
          },
        },
        win_options = {
          winhighlight = winhighlight,
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      eq(vim.api.nvim_win_get_option(popup.border.winid, "winhighlight"), winhighlight)
    end)

    it("does nothing if popup mounted", function()
      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "rounded",
          text = {
            top = "text",
          },
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      local bufnr, winid = popup.border.bufnr, popup.border.winid
      eq(type(bufnr), "number")
      eq(type(winid), "number")

      popup.border:mount()

      eq(bufnr, popup.border.bufnr)
      eq(winid, popup.border.winid)
    end)
  end)

  describe("method :unmount", function()
    it("does nothing if popup not mounted", function()
      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "rounded",
          text = {
            top = "text",
          },
        },
      })

      popup = Popup(popup_options)

      eq(type(popup.border.bufnr), "nil")
      eq(type(popup.border.winid), "nil")

      popup.border:unmount()

      eq(type(popup.border.bufnr), "nil")
      eq(type(popup.border.winid), "nil")
    end)
  end)

  describe("method :set_text", function()
    it("works", function()
      local text_top, text_bottom = "top", "bot"

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "rounded",
          text = {
            top = text_top,
            top_align = "left",
          },
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      h.assert_buf_lines(popup.border.bufnr, {
        "╭top─────╮",
        "│        │",
        "│        │",
        "╰────────╯",
      })

      popup.border:set_text("top", text_top, "center")

      h.assert_buf_lines(popup.border.bufnr, {
        "╭──top───╮",
        "│        │",
        "│        │",
        "╰────────╯",
      })

      popup.border:set_text("top", text_top, "right")

      h.assert_buf_lines(popup.border.bufnr, {
        "╭─────top╮",
        "│        │",
        "│        │",
        "╰────────╯",
      })

      local hl_group = "NuiPopupTest"

      popup.border:set_text("bottom", Text(text_bottom, hl_group))

      h.assert_buf_lines(popup.border.bufnr, {
        "╭─────top╮",
        "│        │",
        "│        │",
        "╰──bot───╯",
      })

      h.assert_highlight(popup.border.bufnr, popup_options.ns_id, 4, text_bottom, hl_group)
    end)

    it("does nothing for simple border", function()
      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = "rounded",
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      eq(type(popup.border.bufnr), "nil")

      popup.border:set_text("top", "text")

      eq(type(popup.border.bufnr), "nil")
    end)
  end)

  describe("method :set_highlight", function()
    it("works for simple border", function()
      local style = h.popup.create_border_style_map()

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = style,
        },
        win_options = {
          winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      eq(popup.border.winid, nil)

      local hl_group = "NuiPopupTest"

      popup.border:set_highlight(hl_group)

      eq(vim.api.nvim_win_get_option(popup.winid, "winhighlight"), "FloatBorder:" .. hl_group .. ",Normal:Normal")
    end)

    it("works for complex border", function()
      local style = h.popup.create_border_style_map()

      local hl_group = "NuiPopupTest"

      popup_options = vim.tbl_deep_extend("force", popup_options, {
        border = {
          style = style,
          padding = { 0 },
        },
        win_options = {
          winhighlight = "Normal:Normal,FloatBorder:" .. hl_group,
        },
      })

      popup = Popup(popup_options)

      popup:mount()

      eq(vim.api.nvim_win_get_option(popup.winid, "winhighlight"), "Normal:Normal,FloatBorder:" .. hl_group)
      eq(vim.api.nvim_win_get_option(popup.border.winid, "winhighlight"), "Normal:Normal,FloatBorder:" .. hl_group)

      local hl_group_override = "NuiPopupTestOverride"

      popup.border:set_highlight(hl_group_override)

      eq(
        vim.api.nvim_win_get_option(popup.winid, "winhighlight"),
        "FloatBorder:" .. hl_group_override .. ",Normal:Normal"
      )
      eq(
        vim.api.nvim_win_get_option(popup.border.winid, "winhighlight"),
        "FloatBorder:" .. hl_group_override .. ",Normal:Normal"
      )
    end)
  end)
end)
