local vim = vim
local Input = require("nui.input")
local NuiText = require("nui.text")
local NuiPopup = require("nui.popup")
local highlights = require("neo-tree.ui.highlights")
local log = require("neo-tree.log")

local M = {}

M.popup_options = function(title, min_width, override_options)
  local min_width = min_width or 30
  local width = string.len(title) + 2

  local nt = require("neo-tree")
  local popup_border_style = nt.config.popup_border_style
  local popup_border_text = NuiText(" " .. title .. " ", highlights.FLOAT_TITLE)
  local col = 0
  -- fix popup position when using multigrid
  local popup_last_col = vim.api.nvim_win_get_position(0)[2] + width + 2
  if popup_last_col >= vim.o.columns then
    col = vim.o.columns - popup_last_col
  end
  local popup_options = {
    ns_id = highlights.ns_id,
    relative = "cursor",
    position = {
      row = 1,
      col = col,
    },
    size = width,
    border = {
      text = {
        top = popup_border_text,
      },
      style = popup_border_style,
      highlight = highlights.FLOAT_BORDER,
    },
    win_options = {
      winhighlight = "Normal:"
        .. highlights.FLOAT_NORMAL
        .. ",FloatBorder:"
        .. highlights.FLOAT_BORDER,
    },
    buf_options = {
      bufhidden = "delete",
      buflisted = false,
      filetype = "neo-tree-popup",
    },
  }

  if popup_border_style == "NC" then
    local blank = NuiText(" ", highlights.TITLE_BAR)
    popup_border_text = NuiText(" " .. title .. " ", highlights.TITLE_BAR)
    popup_options.border = {
      style = { "▕", blank, "▏", "▏", " ", "▔", " ", "▕" },
      highlight = highlights.FLOAT_BORDER,
      text = {
        top = popup_border_text,
        top_align = "left",
      },
    }
  end

  if override_options then
    return vim.tbl_extend("force", popup_options, override_options)
  else
    return popup_options
  end
end

M.alert = function(title, message, size)
  local lines = {}
  local max_line_width = title:len()
  local add_line = function(line)
    if not type(line) == "string" then
      line = tostring(line)
    end
    if line:len() > max_line_width then
      max_line_width = line:len()
    end
    table.insert(lines, line)
  end

  if type(message) == "table" then
    for _, v in ipairs(message) do
      add_line(v)
    end
  else
    add_line(message)
  end

  add_line("")
  add_line(" Press <Escape> or <Enter> to close")

  local win_options = M.popup_options(title, 80)
  win_options.zindex = 60
  win_options.size = {
    width = max_line_width + 4,
    height = #lines + 1,
  }
  local win = NuiPopup(win_options)
  win:mount()

  local success, msg = pcall(vim.api.nvim_buf_set_lines, win.bufnr, 0, 0, false, lines)
  if success then
    win:map("n", "<esc>", function(bufnr)
      win:unmount()
    end, { noremap = true })

    win:map("n", "<enter>", function(bufnr)
      win:unmount()
    end, { noremap = true })

    local event = require("nui.utils.autocmd").event
    win:on({ event.BufLeave, event.BufDelete }, function()
      win:unmount()
    end, { once = true })

    -- why is this necessary?
    vim.api.nvim_set_current_win(win.winid)
  else
    log.error(msg)
    win:unmount()
  end
end

return M
