local Popup = require("nui.popup")
local NuiLine = require("nui.line")
local utils = require("neo-tree.utils")
local popups = require("neo-tree.ui.popups")
local highlights = require("neo-tree.ui.highlights")
local M = {}

local add_text = function(text, highlight)
  local line = NuiLine()
  line:append(text, highlight)
  return line
end

M.show = function(state)
  local tree_width = vim.api.nvim_win_get_width(state.winid)
  local keys = utils.get_keys(state.resolved_mappings, true)

  local lines = { add_text("") }
  lines[1] = add_text(" Press the corresponding key to execute the command.", "Comment")
  lines[2] = add_text("               Press <Esc> to cancel.", "Comment")
  lines[3] = add_text("")
  local header = NuiLine()
  header:append(string.format(" %14s", "KEY(S)"), highlights.ROOT_NAME)
  header:append("    ", highlights.DIM_TEXT)
  header:append("COMMAND", highlights.ROOT_NAME)
  lines[4] = header
  local max_width = #lines[1]:content()
  for _, key in ipairs(keys) do
    local value = state.resolved_mappings[key]
    local nline = NuiLine()
    nline:append(string.format(" %14s", key), highlights.FILTER_TERM)
    nline:append(" -> ", highlights.DIM_TEXT)
    nline:append(value.text, highlights.NORMAL)
    local line = nline:content()
    if #line > max_width then
      max_width = #line
    end
    table.insert(lines, nline)
  end

  local width = math.min(60, max_width + 1)

  if state.current_position == "right" then
    col = vim.o.columns - tree_width - width - 1
  else
    col = tree_width - 1
  end

  local options = {
    position = {
      row = 2,
      col = col,
    },
    size = {
      width = width,
      height = #keys + 5,
    },
    enter = true,
    focusable = true,
    zindex = 50,
    relative = "editor",
  }
  local options = popups.popup_options("Neotree Help", width, options)
  local popup = Popup(options)
  popup:mount()

  popup:map("n", "<esc>", function()
    popup:unmount()
  end, { noremap = true })

  local event = require("nui.utils.autocmd").event
  popup:on({ event.BufLeave, event.BufDelete }, function()
    popup:unmount()
  end, { once = true })

  for _, key in ipairs(keys) do
    -- map everything except for <escape>
    if string.match(key:lower(), "^<esc") == nil then
      local value = state.resolved_mappings[key]
      popup:map("n", key, function()
        popup:unmount()
        vim.api.nvim_set_current_win(state.winid)
        value.handler()
      end)
    end
  end

  for i, line in ipairs(lines) do
    line:render(popup.bufnr, -1, i)
  end
end

return M
