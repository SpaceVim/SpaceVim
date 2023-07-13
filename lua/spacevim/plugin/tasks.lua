--=============================================================================
-- tasks.lua
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local select_task = {}

local task_config = {}

local task_viewer_bufnr = -1

local variables = {}

local providers = {}


local function load()
  local global_conf = {}
  local local_conf = {}
  if vim.fn.filereadable(vim.fn.expand('~/.SpaceVim.d/tasks.toml')) == 1 then
    global_conf = vim.api.nvim_eval("SpaceVim#api#data#toml#get().parse_file(expand('~/.SpaceVim.d/tasks.toml'))")
  end
end
