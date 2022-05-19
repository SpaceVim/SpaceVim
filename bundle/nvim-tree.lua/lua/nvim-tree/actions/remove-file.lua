local a = vim.api
local luv = vim.loop

local utils = require "nvim-tree.utils"
local events = require "nvim-tree.events"

local M = {}

local function close_windows(windows)
  for _, window in ipairs(windows) do
    if a.nvim_win_is_valid(window) then
      a.nvim_win_close(window, true)
    end
  end
end

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
      a.nvim_buf_delete(buf.bufnr, { force = true })
      close_windows(buf.windows)
      return
    end
  end
end

local function remove_dir(cwd)
  local handle = luv.fs_scandir(cwd)
  if type(handle) == "string" then
    return a.nvim_err_writeln(handle)
  end

  while true do
    local name, t = luv.fs_scandir_next(handle)
    if not name then
      break
    end

    local new_cwd = utils.path_join { cwd, name }
    if t == "directory" then
      local success = remove_dir(new_cwd)
      if not success then
        return false
      end
    else
      local success = luv.fs_unlink(new_cwd)
      if not success then
        return false
      end
      clear_buffer(new_cwd)
    end
  end

  return luv.fs_rmdir(cwd)
end

function M.fn(node)
  if node.name == ".." then
    return
  end

  print("Remove " .. node.name .. " ? y/n")
  local ans = utils.get_user_input_char()
  utils.clear_prompt()
  if ans:match "^y" then
    if node.nodes ~= nil and not node.link_to then
      local success = remove_dir(node.absolute_path)
      if not success then
        return a.nvim_err_writeln("Could not remove " .. node.name)
      end
      events._dispatch_folder_removed(node.absolute_path)
    else
      local success = luv.fs_unlink(node.absolute_path)
      if not success then
        return a.nvim_err_writeln("Could not remove " .. node.name)
      end
      events._dispatch_file_removed(node.absolute_path)
      clear_buffer(node.absolute_path)
    end
    require("nvim-tree.actions.reloaders").reload_explorer()
  end
end

return M
