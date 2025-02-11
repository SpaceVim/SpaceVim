--=============================================================================
-- config.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

local M = {}

M.bundle_dir = vim.fn.stdpath('data') .. '/bundle_dir'
M.raw_plugin_dir = vim.fn.stdpath('data') .. '/bundle_dir/raw_plugin'
M.max_processes = 5
M.base_url = 'https://github.com/'
M.ui = 'notify'
M.clone_depth = '1'
M.enable_priority = false
function M.setup(opt)
  M.bundle_dir = opt.bundle_dir or M.bundle_dir
  M.max_processes = opt.max_processes or M.max_processes
  M.base_url = opt.base_url or M.base_url
  M.ui = opt.ui or M.ui
  M.http_proxy = opt.http_proxy
  M.https_proxy = opt.https_proxy
  M.clone_depth = opt.clone_depth or M.clone_depth
  M.raw_plugin_dir = opt.raw_plugin_dir or M.raw_plugin_dir
  M.enable_priority = opt.enable_priority or M.enable_priority
end

return M
