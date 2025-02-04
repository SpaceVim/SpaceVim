--=============================================================================
-- config.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================


local M = {}

M.bundle_dir = vim.fn.stdpath('data') .. '/bundle_dir' 

function M.setup(opt)
  M.bundle_dir = opt.bundle_dir or M.bundle_dir
end

return M
