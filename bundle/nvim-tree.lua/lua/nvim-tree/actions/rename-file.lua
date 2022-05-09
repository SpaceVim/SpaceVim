local a = vim.api
local uv = vim.loop

local lib = require "nvim-tree.lib"
local utils = require "nvim-tree.utils"
local events = require "nvim-tree.events"

local M = {}

function M.fn(with_sub)
  return function(node)
    node = lib.get_last_group_node(node)
    if node.name == ".." then
      return
    end

    local namelen = node.name:len()
    local abs_path = with_sub and node.absolute_path:sub(0, namelen * -1 - 1) or node.absolute_path

    local input_opts = { prompt = "Rename to ", default = abs_path, completion = "file" }

    vim.ui.input(input_opts, function(new_file_path)
      if not new_file_path then
        return
      end

      if utils.file_exists(new_file_path) then
        utils.warn "Cannot rename: file already exists"
        return
      end

      local success = uv.fs_rename(node.absolute_path, new_file_path)
      if not success then
        return a.nvim_err_writeln("Could not rename " .. node.absolute_path .. " to " .. new_file_path)
      end
      utils.clear_prompt()
      a.nvim_out_write(node.absolute_path .. " ➜ " .. new_file_path .. "\n")
      utils.rename_loaded_buffers(node.absolute_path, new_file_path)
      events._dispatch_node_renamed(abs_path, new_file_path)
      require("nvim-tree.actions.reloaders").reload_explorer()
    end)
  end
end

return M
