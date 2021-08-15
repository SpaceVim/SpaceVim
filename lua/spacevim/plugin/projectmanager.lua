--=============================================================================
-- projectmanager.lua --- The lua version of projectmanager..vim
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local logger = require('spacevim.logger').derive('roter')
local sp = require('spacevim')
local sp_file = require('spacevim.api.file')
local sp_json = require('spacevim.api.data.json')

local M = {}

local project_rooter_patterns = {}
local project_rooter_ignores = {}

local function update_rooter_patterns()
    project_rooter_patterns = {}
    for _,v in pairs(sp.eval('g:spacevim_project_rooter_patterns')) do
        if string.match(v, '^!') ~= nil then
            table.insert(project_rooter_patterns, v)
        else
            table.insert(project_rooter_ignores, string.sub(v, 2, -1))
        end
    end
end

local function is_ignored_dir(dir)
    for _,v in pairs(project_rooter_ignores) do
        if string.match(dir, v) ~= nil then return true end
    end
    return false
end

update_rooter_patterns()

local project_paths = {}
local project_cache_path = sp_file.unify_path(sp.eval('g:spacevim_data_dir'), ':p') .. 'SpaceVim/projects.json'

local function cache()
  fn.writefile({sp_json.json_encode(project_paths)}, sp_file.unify_path(project_cache_path, ':p'))
end

local function load_cache()
  if fn.filereadable(project_cache_path) == 1 then
    logger.info('Load projects cache from: ' .. project_cache_path)
    local cache_context = fn.join(fn.readfile(project_cache_path, ''), '')
    if fn.empty(cache_context) == 0 then
      local cache_object = sp_json.json_decode(cache_context)
      if sp_vim.is_dict(cache_object) then
        project_paths = fn.filter(cache_object, '!empty(v:key)')
      end
    end
  else
    logger.info('projects cache file does not exists!')
  end
end

return M
