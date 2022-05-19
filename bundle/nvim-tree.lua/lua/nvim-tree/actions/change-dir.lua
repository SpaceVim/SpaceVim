local a = vim.api

local log = require "nvim-tree.log"
local utils = require "nvim-tree.utils"
local core = require "nvim-tree.core"

local M = {
  current_tab = a.nvim_get_current_tabpage(),
}

function M.fn(name, with_open)
  if not core.get_explorer() then
    return
  end

  local foldername = name == ".." and vim.fn.fnamemodify(utils.path_remove_trailing(core.get_cwd()), ":h") or name
  local no_cwd_change = vim.fn.expand(foldername) == core.get_cwd()
    or M.options.restrict_above_cwd and foldername < vim.fn.getcwd(-1, -1)
  local new_tab = a.nvim_get_current_tabpage()
  local is_window = (vim.v.event.scope == "window" or vim.v.event.changed_window) and new_tab == M.current_tab
  if no_cwd_change or is_window then
    return
  end
  M.current_tab = new_tab
  M.force_dirchange(foldername, with_open)
end

function M.force_dirchange(foldername, with_open)
  local ps = log.profile_start("change dir %s", foldername)

  if M.options.enable and vim.tbl_isempty(vim.v.event) then
    if M.options.global then
      vim.cmd("cd " .. vim.fn.fnameescape(foldername))
    else
      vim.cmd("lcd " .. vim.fn.fnameescape(foldername))
    end
  end
  core.init(foldername)
  if with_open then
    require("nvim-tree.lib").open()
  else
    require("nvim-tree.renderer").draw()
  end

  log.profile_end(ps, "change dir %s", foldername)
end

function M.setup(options)
  M.options = options.actions.change_dir
end

return M
