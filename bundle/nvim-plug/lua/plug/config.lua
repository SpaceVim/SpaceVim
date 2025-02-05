--=============================================================================
-- config.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local M = {}

M.bundle_dir = vim.fn.stdpath('data') .. '/bundle_dir'
M.max_processes = 5
M.base_url = 'https://github.com/'
M.ui = 'default'
function M.setup(opt)
  M.bundle_dir = opt.bundle_dir or M.bundle_dir
  M.max_processes = opt.max_processes or M.max_processes
  M.base_url = opt.base_url or M.base_url
  M.ui = opt.ui or M.ui
end

return M
