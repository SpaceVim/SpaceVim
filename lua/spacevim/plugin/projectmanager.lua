--=============================================================================
-- projectmanager.lua --- The lua version of projectmanager..vim
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local logger = require('spacevim.logger').derive('project')

local sp_buffer = require('spacevim.api').import('vim.buffer')

-- start debug mode
logger.start_debug()

local sp = require('spacevim')
local sp_file = require('spacevim.api.file')
local sp_json = require('spacevim.api.data.json')
local sp_opt = require('spacevim.opt')
local fn = sp.fn
local layer = require('spacevim.layer')
local project_paths = {}
local project_cache_path = sp_file.unify_path(sp_opt.data_dir, ':p') .. 'SpaceVim/projects.json'
local spacevim_project_rooter_patterns = {}
local project_rooter_patterns = {}
local project_rooter_ignores = {}
local project_callback = {}

local cd = 'cd'
if fn.exists(':tcd') then
  cd = 'tcd'
elseif fn.exists(':lcd') then
  cd = 'lcd'
end

local function update_rooter_patterns()
  project_rooter_patterns = {}
  project_rooter_ignores = {}
  for _, v in pairs(sp_opt.project_rooter_patterns) do
    if string.match(v, '^!') == nil then
      table.insert(project_rooter_patterns, v)
    else
      table.insert(project_rooter_ignores, string.sub(v, 2, -1))
    end
  end
  logger.debug('project rooter patterns:' .. vim.inspect(project_rooter_patterns))
end

local function is_ignored_dir(dir)
  for _, v in pairs(project_rooter_ignores) do
    if string.match(dir, v) ~= nil then
      logger.debug('this is an ignored dir:' .. dir)
      return true
    end
  end
  return false
end
local function cache()
  local path = sp_file.unify_path(project_cache_path, ':p')
  local file = io.open(path, 'w')
  if file then
    if file:write(sp_json.json_encode(project_paths)) == nil then
      logger.debug('failed to write to file:' .. path)
    end
    io.close(file)
  else
    logger.debug('failed to open file:' .. path)
  end
end

local function readfile(path)
  local file = io.open(path, 'r')
  if file then
    local content = file:read('*a')
    io.close(file)
    return content
  end
  return nil
end

local function filereadable(fpath)
  local f = io.open(fpath, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function isdirectory(fpath)
  local f, err, code = io.open(fpath, 'r')
  if f ~= nil then
    f:close()
    return false
  end
  return code == 13
end

local function filter_invalid(projects)
  for key, value in pairs(projects) do
    if fn.isdirectory(value.path) == 0 then
      projects[key] = nil
    end
  end
  return projects
end

local function load_cache()
  if filereadable(project_cache_path) then
    logger.info('Load projects cache from: ' .. project_cache_path)
    local cache_context = readfile(project_cache_path)
    if cache_context ~= nil then
      local cache_object = sp_json.json_decode(cache_context)
      if type(cache_object) == 'table' then
        project_paths = filter_invalid(cache_object)
      end
    end
  else
    logger.info('projects cache file does not exists!')
  end
end

local function compare_time(d1, d2)
  local proj1 = project_paths[d1] or {}
  local proj1time = proj1['opened_time'] or 0
  local proj2 = project_paths[d2] or {}
  local proj2time = proj2['opened_time'] or 0
  return proj2time < proj1time
end
local function sort_by_opened_time()
  local paths = {}
  for k, _ in pairs(project_paths) do
    table.insert(paths, k)
  end
  table.sort(paths, compare_time)
  if sp_opt.projects_cache_num > 0 and #paths >= sp_opt.projects_cache_num then
    for i = sp_opt.projects_cache_num, #paths, 1 do
      project_paths[paths[sp_opt.projects_cache_num]] = nil
      table.remove(paths, sp_opt.projects_cache_num)
    end
  end
  return paths
end

local function change_dir(dir)
  if dir == sp_file.unify_path(fn.getcwd()) then
    return false
  else
    sp.cmd(cd .. ' ' .. sp.fn.fnameescape(sp.fn.fnamemodify(dir, ':p')))
    return true
  end
end

local function compare(d1, d2)
  local al = #vim.split(d1, '/')
  local bl = #vim.split(d2, '/')
  -- logger.debug('al is ' .. al)
  -- logger.debug('bl is ' .. bl)
  -- the project_rooter_outermost is 0/false or 1 true
  if sp_opt.project_rooter_outermost == 0
    or sp_opt.project_rooter_outermost == false then
    if bl >= al then
      return false
    else
      return true
    end
  else
    if al > bl then
      return false
    else
      return true
    end
  end
end

local function sort_dirs(dirs)
  table.sort(dirs, compare)
  local dir = dirs[1]
  -- logger.debug(vim.inspect(dirs))
  local bufdir = fn.getbufvar('%', 'rootDir', '')
  if bufdir == dir then
    return ''
  else
    return dir
  end
end

local function find_root_directory()
  local fd = fn.bufname('%')
  if fd == '' then
    -- for empty name buffer, check previous buffer dir
    local previous_bufnr = vim.fn.bufnr('#')
    if previous_bufnr == -1 then
      logger.debug('previous buffer does not exist, use current directory instead!')
    elseif fn.getbufvar('#', 'rootDir', '') == '' then
      logger.debug('previous buffer rootDir is empty, use current directory instead!')
    else
      return fn.getbufvar('#', 'rootDir', '')
    end
    fd = fn.getcwd()
  end
  fd = fn.fnamemodify(fd, ':p')
  logger.debug('start to find root for: ' .. fd)
  local dirs = {}
  for _, pattern in pairs(project_rooter_patterns) do
    local find_path = ''
    if string.sub(pattern, -1) == '/' then
      if sp_opt.project_rooter_outermost == 1 then
        find_path = sp_file.finddir(pattern, fd, -1)
      else
        find_path = sp_file.finddir(pattern, fd)
      end
    else
      if sp_opt.project_rooter_outermost == 1 then
        find_path = sp_file.findfile(pattern, fd, -1)
      else
        find_path = sp_file.findfile(pattern, fd)
      end
    end
    local path_type = fn.getftype(find_path)
    if (path_type == 'dir' or path_type == 'file') and not (is_ignored_dir(find_path)) then
      find_path = sp_file.unify_path(find_path, ':p')
      if path_type == 'dir' then
        find_path = sp_file.unify_path(find_path, ':h:h')
      else
        find_path = sp_file.unify_path(find_path, ':h')
      end
      if find_path ~= sp_file.unify_path(fn.expand('$HOME')) then
        logger.info('        (' .. pattern .. '):' .. find_path)
        table.insert(dirs, find_path)
      else
        logger.info('ignore $HOME directory:' .. find_path)
      end
    end
  end
  return sort_dirs(dirs)
end
local function cache_project(prj)
  project_paths[prj.path] = prj
  sp.cmd('let g:unite_source_menu_menus.Projects.command_candidates = []')
  for _, key in pairs(sort_by_opened_time()) do
    local desc = '['
      .. project_paths[key].name
      .. '] '
      .. project_paths[key].path
      .. ' <'
      .. fn.strftime('%Y-%m-%d %T', project_paths[key].opened_time)
      .. '>'
    local cmd = "call SpaceVim#plugins#projectmanager#open('" .. project_paths[key].path .. "')"
    sp.cmd(
      'call add(g:unite_source_menu_menus.Projects.command_candidates, ["'
        .. desc
        .. '", "'
        .. cmd
        .. '"])'
    )
  end
  if sp_opt.enable_projects_cache then
    cache()
  end
end

-- call add(g:spacevim_project_rooter_patterns, '.SpaceVim.d/')

-- let s:spacevim_project_rooter_patterns = copy(g:spacevim_project_rooter_patterns)
update_rooter_patterns()

if sp_opt.enable_projects_cache == 1 then
  load_cache()
end

sp.cmd([[
let g:unite_source_menu_menus = get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.Projects = {'description': 'Custom mapped keyboard shortcuts                   [SPC] p p'}
let g:unite_source_menu_menus.Projects.command_candidates = get(g:unite_source_menu_menus.Projects,'command_candidates', [])
]])

if sp_opt.project_auto_root == 1 then
  sp.cmd('augroup spacevim_project_rooter')
  sp.cmd('autocmd!')
  sp.cmd('autocmd VimEnter,BufEnter * ++nested call SpaceVim#plugins#projectmanager#current_root()')
  sp.cmd(
    "autocmd BufWritePost * :call setbufvar('%', 'rootDir', '') | call SpaceVim#plugins#projectmanager#current_root()"
  )
  sp.cmd('augroup END')
end
local M = {}

function M.list()
  if layer.isLoaded('unite') then
    sp.cmd('Unite menu:Projects')
  elseif layer.isLoaded('denite') then
    sp.cmd('Denite menu:Projects')
  elseif layer.isLoaded('fzf') then
    sp.cmd('FzfMenu Projects')
  elseif layer.isLoaded('leaderf') then
    sp.cmd("call SpaceVim#layers#leaderf#run_menu('Projects')")
  elseif layer.isLoaded('telescope') then
    sp.cmd('Telescope project')
  else
    logger.warn('fuzzy find layer is needed to find project!')
  end
end

function M.open(project)
  local path = project_paths[project]['path']
  -- local name = project_paths[project]['name']
  sp.cmd('tabnew')
  -- I am not sure we should set the project name here.
  -- sp.cmd('let t:_spacevim_tab_name = "[' .. name .. ']"')
  sp.cmd(cd .. ' ' .. path)
  if sp_opt.filemanager == 'vimfiler' then
    sp.cmd('Startify | VimFiler')
  elseif sp_opt.filemanager == 'nerdtree' then
    sp.cmd('Startify | NERDTree')
  elseif sp_opt.filemanager == 'defx' then
    sp.cmd('Startify | Defx -new')
  elseif sp_opt.filemanager == 'neo-tree' then
    sp.cmd('Startify | NeoTreeFocusToggle')
  end
end

function M.current_name()
  return sp.eval('b:_spacevim_project_name')
end

function M.RootchandgeCallback()
  -- this function only will be called when switch to other project.
  local path = sp_file.unify_path(fn.getcwd(), ':p')
  local name = fn.fnamemodify(path, ':h:t')
  logger.info('switch to project:[' .. name .. ']')
  logger.info('       rootdir is:' .. path)
  local project = {
    ['path'] = path,
    ['name'] = name,
    ['opened_time'] = os.time(),
  }
  if project.path == '' then
    return
  end
  cache_project(project)
  -- let g:_spacevim_project_name = project.name
  -- let b:_spacevim_project_name = g:_spacevim_project_name
  fn.setbufvar('%', '_spacevim_project_name', project.name)
  for _, Callback in pairs(project_callback) do
    logger.debug('     run callback:' .. Callback)
    fn.call(Callback, {})
  end
end

function M.reg_callback(func)
  if type(func) == 'string' then
    if string.match(func, '^function%(') ~= nil then
      table.insert(project_callback, string.sub(func, 11, -3))
    else
      table.insert(project_callback, func)
    end
  else
    logger.warn('type of func is:' .. type(func))
    logger.warn('can not register the project callback: ' .. fn.string(func))
  end
end

function M.kill_project()
  local name = sp.eval('b:_spacevim_project_name')
  if name ~= '' then
    sp_buffer.filter_do({
      ['expr'] = {
        'buflisted(v:val)',
        'getbufvar(v:val, "_spacevim_project_name") == "' .. name .. '"',
      },
      ['do'] = 'bd %d',
    })
  end
end

function M.complete_project(arglead, cmdline, cursorpos)
  local dir = vim.g.spacevim_src_root or '~'
  local result = fn.split(fn.globpath(dir, '*'), '\n')
  local ps = {}
  for _, p in pairs(result) do
    if fn.isdirectory(p) == 1 and fn.isdirectory(p .. sp_file.separator .. '.git') == 1 then
      table.insert(ps, fn.fnamemodify(p, ':t'))
    end
  end
  return fn.join(ps, '\n')
end

function M.OpenProject(p)
  local dir = vim.g.spacevim_src_root or '~'
  local project_root = sp_file.unify_path(dir, ':p') .. p
  if vim.fn.isdirectory(project_root) == 1 then
    sp.cmd('tabnew | cd ' .. project_root .. ' | Startify')
  end
end

function M.current_root()
  local bufname = fn.bufname('%')
  if
    bufname:match('%[denite%]')
    or bufname:match('denite-filter')
    or bufname:match('%[defx%]')
    or bufname:match('^git://') -- this is for git.vim
    or vim.fn.empty(bufname) == 1
    or bufname:match('^neo%-tree') -- this is for neo-tree.nvim
  then
    return fn.getcwd()
  end
  if
    table.concat(sp_opt.project_rooter_patterns, ':')
    ~= table.concat(spacevim_project_rooter_patterns, ':')
  then
    logger.info('project_rooter_patterns option has been change, clear b:rootDir')
    fn.setbufvar('%', 'rootDir', '')
    spacevim_project_rooter_patterns = sp_opt.project_rooter_patterns
    update_rooter_patterns()
  end
  local rootdir = fn.getbufvar('%', 'rootDir', '')
  if rootdir == '' then
    rootdir = find_root_directory()
    if rootdir == nil or rootdir == '' then
      -- for no project
      if vim.g.spacevim_project_non_root == '' then
        rootdir = sp_file.unify_path(fn.getcwd())
      elseif vim.g.spacevim_project_non_root == 'home' and filereadable(bufname) then
        rootdir = sp_file.unify_path(fn.expand('~'))
      elseif vim.g.spacevim_project_non_root == 'current' then
        local dir = sp_file.unify_path(bufname, ':p:h')
        if isdirectory(dir) then
          rootdir = dir
        else
          rootdir = sp_file.unify_path(fn.getcwd())
        end
      else
        -- maybe log error
      end
      change_dir(rootdir)
    else
      -- for project
      if change_dir(rootdir) then
        M.RootchandgeCallback()
      end
    end
    fn.setbufvar('%', 'rootDir', rootdir)
  elseif change_dir(rootdir) then
    M.RootchandgeCallback()
  end
  return rootdir
end

function M.get_project_history() -- {{{
  return project_paths
end
-- }}}

return M
