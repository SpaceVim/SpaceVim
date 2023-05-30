pcall(require, "luacov")

local Input = require("nui.input")
local Text = require("nui.text")
local h = require("tests.helpers")

local eq, feedkeys = h.eq, h.feedkeys

-- Input's functionalities are not testable using headless nvim.
-- Not sure what to do about it.

describe("nui.input", function()
  local parent_winid, parent_bufnr
  local popup_options
  local input

  before_each(function()
    parent_winid = vim.api.nvim_get_current_win()
    parent_bufnr = vim.api.nvim_get_current_buf()

    popup_options = {
      relative = "win",
      position = "50%",
      size = 20,
    }
  end)

  after_each(function()
    if input then
      input:unmount()
      input = nil
    end
  end)

  pending("o.prompt", function()
    it("supports NuiText", function()
      local prompt_text = "> "
      local hl_group = "NuiInputTest"

      input = Input(popup_options, {
        prompt = Text(prompt_text, hl_group),
      })

      input:mount()

      h.assert_buf_lines(input.bufnr, {
        prompt_text,
      })

      h.assert_highlight(input.bufnr, input.ns_id, 1, prompt_text, hl_group)
    end)
  end)

  describe("cursor_position_patch", function()
    local initial_cursor

    local function setup()
      vim.api.nvim_buf_set_lines(parent_bufnr, 0, -1, false, {
        "1 nui.nvim",
        "2 nui.nvim",
        "3 nui.nvim",
      })
      initial_cursor = { 2, 4 }
      vim.api.nvim_win_set_cursor(parent_winid, initial_cursor)
    end

    it("works after submitting from insert mode", function()
      setup()

      local done = false
      input = Input(popup_options, {
        on_submit = function()
          done = true
        end,
      })

      input:mount()

      feedkeys("<cr>", "x")

      vim.fn.wait(1000, function()
        return done
      end)

      eq(done, true)
      eq(vim.api.nvim_win_get_cursor(parent_winid), initial_cursor)
    end)

    it("works after submitting from normal mode", function()
      setup()

      local done = false
      input = Input(popup_options, {
        on_submit = function()
          done = true
        end,
      })

      input:mount()

      feedkeys("<esc><cr>", "x")

      vim.fn.wait(1000, function()
        return done
      end)

      eq(done, true)
      eq(vim.api.nvim_win_get_cursor(parent_winid), initial_cursor)
    end)

    it("works after closing from insert mode", function()
      setup()

      local done = false
      input = Input(popup_options, {
        on_close = function()
          done = true
        end,
      })

      input:mount()

      input:map("i", "<esc>", input.input_props.on_close, { nowait = true, noremap = true })

      feedkeys("i<esc>", "x")

      vim.fn.wait(1000, function()
        return done
      end)

      eq(done, true)
      eq(vim.api.nvim_win_get_cursor(parent_winid), initial_cursor)
    end)

    it("works after closing from normal mode", function()
      setup()

      local done = false
      input = Input(popup_options, {
        on_close = function()
          done = true
        end,
      })

      input:mount()

      input:map("n", "<esc>", input.input_props.on_close, { nowait = true, noremap = true })

      feedkeys("<esc>", "x")

      vim.fn.wait(1000, function()
        return done
      end)

      eq(done, true)
      eq(vim.api.nvim_win_get_cursor(parent_winid), initial_cursor)
    end)
  end)
end)
