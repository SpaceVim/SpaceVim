local util = require("trouble.util")

local M = {}

M.results = {}

--- Turns a Telescope item into a Trouble item.
local function item_to_result(item)
  local row = (item.lnum or 1) - 1
  local col = (item.col or 1) - 1

  if not item.bufnr then
    local fname = vim.fn.fnamemodify(item.filename, ":p")
    if vim.fn.filereadable(fname) == 0 and item.cwd then
      fname = vim.fn.fnamemodify(item.cwd .. "/" .. item.filename, ":p")
    end
    item.bufnr = vim.fn.bufnr(fname, true)
  end

  local pitem = {
    row = row,
    col = col,
    message = item.text,
    severity = 0,
    range = {
      start = { line = row, character = col },
      ["end"] = { line = row, character = -1 },
    },
  }

  return util.process_item(pitem, item.bufnr)
end

--- Shows all Telescope results in Trouble.
function M.open_with_trouble(prompt_bufnr, _mode)
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local picker = action_state.get_current_picker(prompt_bufnr)
  local manager = picker.manager

  M.results = {}
  for item in manager:iter() do
    table.insert(M.results, item_to_result(item))
  end

  actions.close(prompt_bufnr)
  require("trouble").open("telescope")
end

--- Shows the selected Telescope results in Trouble.
function M.open_selected_with_trouble(prompt_bufnr, _mode)
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local picker = action_state.get_current_picker(prompt_bufnr)

  M.results = {}
  for _, item in ipairs(picker:get_multi_selection()) do
    table.insert(M.results, item_to_result(item))
  end

  actions.close(prompt_bufnr)
  require("trouble").open("telescope")
end

--- Shows the selected Telescope results in Trouble.
--- If no results are currently selected, shows all of them.
function M.smart_open_with_trouble(prompt_bufnr, _mode)
  local action_state = require("telescope.actions.state")
  local picker = action_state.get_current_picker(prompt_bufnr)
  if #picker:get_multi_selection() > 0 then
    M.open_selected_with_trouble(prompt_bufnr, _mode)
  else
    M.open_with_trouble(prompt_bufnr, _mode)
  end
end

function M.telescope(_win, _buf, cb, _options)
  if #M.results == 0 then
    util.warn(
      "No Telescope results found. Open Telescopen and send results to Trouble first. Refer to the documentation for more info."
    )
  end
  cb(M.results)
end

return M
