pcall(require, "luacov")

local utils = require("nui.layout.utils")
local h = require("tests.helpers")

local eq = h.eq

describe("nui.layout", function()
  describe("utils", function()
    describe("parse_relative", function()
      local fallback_winid = 17

      it("works for type=buf", function()
        local relative = {
          type = "buf",
          position = { row = 2, col = 4 },
          winid = 42,
        }

        local result = utils.parse_relative(relative, fallback_winid)

        eq(result, {
          relative = "win",
          win = relative.winid,
          bufpos = {
            relative.position.row,
            relative.position.col,
          },
        })
      end)

      it("works for type=cursor", function()
        local relative = {
          type = "cursor",
          winid = 42,
        }

        local result = utils.parse_relative(relative, fallback_winid)

        eq(result, {
          relative = relative.type,
          win = relative.winid,
        })
      end)

      it("works for type=editor", function()
        local relative = {
          type = "editor",
          winid = 42,
        }

        local result = utils.parse_relative(relative, fallback_winid)

        eq(result, {
          relative = relative.type,
          win = relative.winid,
        })
      end)

      it("works for type=win", function()
        local relative = {
          type = "win",
          winid = 42,
        }

        local result = utils.parse_relative(relative, fallback_winid)

        eq(result, {
          relative = relative.type,
          win = relative.winid,
        })
      end)

      it("uses fallback_winid if relative.winid is nil", function()
        local relative = {
          type = "win",
        }

        local result = utils.parse_relative(relative, fallback_winid)

        eq(result, {
          relative = relative.type,
          win = fallback_winid,
        })
      end)
    end)

    describe("get_container_info", function()
      it("works for relative=win", function()
        local result = utils.get_container_info({
          relative = "editor",
        })

        eq(result, {
          relative = "editor",
          size = {
            width = vim.o.columns,
            height = vim.o.lines,
          },
          type = "editor",
        })
      end)

      it("works for relative=cursor", function()
        local winid = vim.api.nvim_get_current_win()

        local result = utils.get_container_info({
          relative = "cursor",
          win = winid,
        })

        eq(result, {
          relative = "cursor",
          size = {
            width = vim.api.nvim_win_get_width(winid),
            height = vim.api.nvim_win_get_height(winid),
          },
          type = "window",
        })
      end)

      it("works for relative=win w/ bufpos", function()
        local winid = vim.api.nvim_get_current_win()

        local result = utils.get_container_info({
          relative = "win",
          win = winid,
          bufpos = { 2, 4 },
        })

        eq(result, {
          relative = "buf",
          size = {
            width = vim.api.nvim_win_get_width(winid),
            height = vim.api.nvim_win_get_height(winid),
          },
          type = "window",
        })
      end)
    end)
  end)
end)
