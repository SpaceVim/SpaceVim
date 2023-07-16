--=============================================================================
-- tasks.lua
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local selected_task = {}

local task_config = {}

local task_viewer_bufnr = -1

local variables = {}

local providers = {}

-- load apis

local file = require('spacevim.api.file')

local function load()
  local global_conf = {}
  local local_conf = {}
  if vim.fn.filereadable(vim.fn.expand('~/.SpaceVim.d/tasks.toml')) == 1 then
    global_conf = vim.api.nvim_eval(
      "SpaceVim#api#data#toml#get().parse_file(expand('~/.SpaceVim.d/tasks.toml'))"
    )
    for _, v in pairs(global_conf) do
      v.isGlobal = true
    end
  end
  if vim.fn.filereadable(vim.fn.expand('.SpaceVim.d/tasks.toml')) == 1 then
    local_conf =
      vim.api.nvim_eval("SpaceVim#api#data#toml#get().parse_file(expand('.SpaceVim.d/tasks.toml'))")
  end
  task_config = vim.fn.extend(global_conf, local_conf)
end

local function init_variables()
  variables.workspaceFolder =
    file.unify_path(require('spacevim.plugin.projectmanager').current_root())
  variables.workspaceFolderBasename = vim.fn.fnamemodify(variables.workspaceFolder, ':t')
  variables.file = file.unify_path(vim.fn.expand('%:p'))
  variables.relativeFile = file.unify_path(vim.fn.expand('%'), ':.')
  variables.relativeFileDirname = file.unify_path(vim.fn.expand('%'), ':h')
  variables.fileBasename = vim.fn.expand('%:t')
  variables.fileBasenameNoExtension = vim.fn.expand('%:t:r')
  variables.fileDirname = file.unify_path(vim.fn.expand('%:p:h'))
  variables.fileExtname = vim.fn.expand('%:e')
  variables.lineNumber = vim.fn.line('.')
  variables.selectedText = ''
  variables.execPath = ''
end

local function select_task(taskName)
  selected_task = task_config[taskName]
end

-- this function require menu api
local function pick()
  
end




