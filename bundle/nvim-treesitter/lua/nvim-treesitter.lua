local install = require "nvim-treesitter.install"
local utils = require "nvim-treesitter.utils"
local info = require "nvim-treesitter.info"
local configs = require "nvim-treesitter.configs"
local statusline = require "nvim-treesitter.statusline"

-- Registers all query predicates
require "nvim-treesitter.query_predicates"

local M = {}

function M.setup()
  utils.setup_commands("install", install.commands)
  utils.setup_commands("info", info.commands)
  utils.setup_commands("configs", configs.commands)
  configs.init()
end

M.define_modules = configs.define_modules
M.statusline = statusline.statusline

return M
