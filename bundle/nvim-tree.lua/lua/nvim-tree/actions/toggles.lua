local view = require "nvim-tree.view"
local filters = require "nvim-tree.explorer.filters"
local renderer = require "nvim-tree.renderer"
local reloaders = require "nvim-tree.actions.reloaders"

local M = {}

function M.custom()
  filters.config.filter_custom = not filters.config.filter_custom
  return reloaders.reload_explorer()
end

function M.git_ignored()
  filters.config.filter_git_ignored = not filters.config.filter_git_ignored
  return reloaders.reload_explorer()
end

function M.dotfiles()
  filters.config.filter_dotfiles = not filters.config.filter_dotfiles
  return reloaders.reload_explorer()
end

function M.help()
  view.toggle_help()
  renderer.draw()
end

return M
