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
local sp_opt = require('spacevim.opt')
local fn = sp.fn

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
local project_cache_path = sp_file.unify_path(sp_opt.data_dir, ':p') .. 'SpaceVim/projects.json'

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

local function sort_by_opened_time()
  local paths = {}
  for k,v in pairs(project_paths) do table.insert(paths, k) end
  table.sort(paths, compare_time)
  if opt.projects_cache_num > 0 and sp_list.has_index(paths, opt.projects_cache_num) then
    for path in select(paths, opt.projects_cache_num, #paths) do
      table.remove(project_paths, path)
    end
    paths = select(paths, 1, opt._projects_cache_num - 1)
  end
  return paths
end

local function compare_time(d1, d2)
  local proj1 = project_paths[d1] or {}
  local proj1time = proj1['opened_time'] or 0
  local proj2 = project_paths[d2] or {}
  local proj2time = proj2['opened_time'] or 0
  return proj2time - proj1time
end

if sp_opt.enable_projects_cache == 1 then
    load_cache()
end

local function change_dir(dir)
    local bufname = fn.bufname('%')
    if bufname == '' then
        bufname = 'No Name'
    end
    logger.debug('buffer name: ' .. bufname)
    if dir == sp_file.unify_path(fn.getcwd()) then
        logger.debug('same as current directory, no need to change.')
    else
        logger.info('change to root: ' .. dir)
        sp.cmd('cd ' .. sp.fn.fnameescape(sp.fn.fnamemodify(dir, ':p')))
    end
end

local function sort_dirs(dirs)
    table.sort(dirs, compare)
    local dir = dirs[1]
    local bufdir = fn.getbufvar('%', 'rootDir', '')
    if bufdir == dir then
        return ''
    else
        return dir
    end
end

local function compare(d1, d2)
    local _, al =  string.gsub(d1, "/", "")
    local _, bl =  string.gsub(d2, "/", "")
    if opt.project_rooter_outermost == 0 then
        return bl - al
    else
        return al - bl
    end
end

local function find_root_directory()
    local fd = fn.expand('%:p')
    if fn == '' then
        fd = fn.getcwd()
    end

    local dirs = {}
    logger.info('Start to find root for: ' .. sp_file.unify_path(fd))
    for _,pattern in pairs(project_rooter_patterns) do
        local find_path = ''
        if fn.stridx(pattern, '/') ~= -1 then
            if opt.project_rooter_outermost == 1 then
                find_path = sp_file.finddir(pattern, fd, -1)
            else
                find_path = sp_file.finddir(pattern, fd)
            end
        else
            if opt.project_rooter_outermost == 1 then
                find_path = sp_file.findfile(pattern, fd, -1)
            else
                find_path = sp_file.findfile(pattern, fd)
            end
        end
        local path_type = fn.getftype(find_path)
        if ( path_type == 'dir' or path_type == 'file' ) 
            and is_ignored_dir(find_path) == 0 then
            find_path = sp_file.unify_path(find_path, ':p')
            if path_type == 'dir' then
                local dir = sp_file.unify_path(find_path, ':h:h')
            else
                local dir = sp_file.unify_path(find_path, ':h')
            end
            if dir ~= sp_file.unify_path(fn.expand('$HOME')) then
                logger.info('        (' .. pattern .. '):' .. dir)
                table.insert(dirs, dir)
            end
        end
    end
    return sort_dirs(dirs)
end

function M.current_root()
    local bufname = fn.bufname('%')
    if bufname == '[denite]'
        or bufname == 'denite-filter'
        or bufname == '[defx]' then
        return
    end
    if table.concat(opt.project_rooter_patterns, ':') ~= table.concat(project_rooter_patterns, ':') then
        logger.info('project_rooter_patterns option has been change, clear b:rootDir')
        fn.setbufvar('%', 'rootDir', '')
        project_rooter_patterns = opt.project_rooter_patterns
        update_rooter_patterns()
    end
    local rootdir = fn.getbufvar('%', 'rootDir', '')
    if rootdir == '' then
        rootdir = find_root_directory()
        if rootdir == '' then
            rootdir = sp_file.unify_path(fn.getcwd())
        end
        fn.setbufvar('%', 'rootDir', rootdir)
    end
    change_dir(rootdir)
    M.RootchandgeCallback()
    return rootdir
end

return M
