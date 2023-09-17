--=============================================================================
-- scrollbar.lua --- scrollbar for SpaceVim
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local default_conf = {
  max_size = 10,
  min_size = 3,
  width = 1,
  right_offset = 1,
  excluded_filetypes = {'startify', 'git-commit','leaderf', 'NvimTree', 'tagbar', 'defx', 'neo-tree', 'qf'},
  shape = {
    head = '▲',
    body = '█',
    tail = '▼'
  },
  highlight = {
    head = 'Normal',
    body = 'Normal',
    tail = 'Normal'
  }
}

local scrollbar_bufnr = -1
local scrollbar_winid = -1
local scrollbar_size = -1


function M.show()
  
end

return M
