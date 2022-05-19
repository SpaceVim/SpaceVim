local a = vim.api

local M = {
  config = {
    is_windows = vim.fn.has "win32" == 1 or vim.fn.has "win32unix" == 1,
    is_macos = vim.fn.has "mac" == 1 or vim.fn.has "macunix" == 1,
    is_unix = vim.fn.has "unix" == 1,
  },
}

local utils = require "nvim-tree.utils"
local events = require "nvim-tree.events"

local function clear_buffer(absolute_path)
  local bufs = vim.fn.getbufinfo { bufloaded = 1, buflisted = 1 }
  for _, buf in pairs(bufs) do
    if buf.name == absolute_path then
      if buf.hidden == 0 and #bufs > 1 then
        local winnr = a.nvim_get_current_win()
        a.nvim_set_current_win(buf.windows[1])
        vim.cmd ":bn"
        a.nvim_set_current_win(winnr)
      end
      vim.api.nvim_buf_delete(buf.bufnr, {})
      return
    end
  end
end

function M.fn(node)
  if node.name == ".." then
    return
  end

  -- configs
  if M.config.is_unix then
    if M.config.trash.cmd == nil then
      M.config.trash.cmd = "trash"
    end
    if M.config.trash.require_confirm == nil then
      M.config.trash.require_confirm = true
    end
  else
    utils.warn "Trash is currently a UNIX only feature!"
    return
  end

  -- trashes a path (file or folder)
  local function trash_path(on_exit)
    vim.fn.jobstart(M.config.trash.cmd .. ' "' .. node.absolute_path .. '"', {
      detach = true,
      on_exit = on_exit,
    })
  end

  local is_confirmed = true

  -- confirmation prompt
  if M.config.trash.require_confirm then
    is_confirmed = false
    print("Trash " .. node.name .. " ? y/n")
    local ans = utils.get_user_input_char()
    if ans:match "^y" then
      is_confirmed = true
    end
    utils.clear_prompt()
  end

  -- trashing
  if is_confirmed then
    if node.nodes ~= nil and not node.link_to then
      trash_path(function()
        events._dispatch_folder_removed(node.absolute_path)
        require("nvim-tree.actions.reloaders").reload_explorer()
      end)
    else
      trash_path(function()
        events._dispatch_file_removed(node.absolute_path)
        clear_buffer(node.absolute_path)
        require("nvim-tree.actions.reloaders").reload_explorer()
      end)
    end
  end
end

function M.setup(opts)
  M.config.trash = opts or {}
end

return M
