local utils = require "nvim-tree.utils"
local a = vim.api

local M = {}

local function get_formatted_lines(node)
  local stats = node.fs_stat
  local fpath = " fullpath: " .. node.absolute_path
  local created_at = " created:  " .. os.date("%x %X", stats.birthtime.sec)
  local modified_at = " modified: " .. os.date("%x %X", stats.mtime.sec)
  local accessed_at = " accessed: " .. os.date("%x %X", stats.atime.sec)
  local size = " size:     " .. utils.format_bytes(stats.size)

  return {
    fpath,
    size,
    accessed_at,
    modified_at,
    created_at,
  }
end

local current_popup = nil

local function setup_window(node)
  local lines = get_formatted_lines(node)

  local max_width = vim.fn.max(vim.tbl_map(function(n)
    return #n
  end, lines))
  local winnr = a.nvim_open_win(0, false, {
    col = 1,
    row = 1,
    relative = "cursor",
    width = max_width + 1,
    height = #lines,
    border = "shadow",
    noautocmd = true,
    style = "minimal",
  })
  current_popup = {
    winnr = winnr,
    file_path = node.absolute_path,
  }
  local bufnr = a.nvim_create_buf(false, true)
  a.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  a.nvim_win_set_buf(winnr, bufnr)
end

function M.close_popup()
  if current_popup ~= nil then
    a.nvim_win_close(current_popup.winnr, { force = true })
    vim.cmd "augroup NvimTreeRemoveFilePopup | au! CursorMoved | augroup END"

    current_popup = nil
  end
end

function M.toggle_file_info(node)
  if node.name == ".." then
    return
  end
  if current_popup ~= nil then
    local is_same_node = current_popup.file_path == node.absolute_path

    M.close_popup()

    if is_same_node then
      return
    end
  end

  setup_window(node)

  vim.cmd [[
    augroup NvimTreeRemoveFilePopup
      au CursorMoved * lua require'nvim-tree.actions.file-popup'.close_popup()
    augroup END
  ]]
end

return M
