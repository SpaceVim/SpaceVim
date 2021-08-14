local M = {}
local sp = require('spacevim')
local cmp = require('spacevim.api').import('vim.compatible')
local sp_file = require('spacevim.api').import('file')
local sp_json = require('spacevim.api').import('data.json')
local logger = require('spacevim.logger').derive('a.vim')

local alternate_conf = {}
alternate_conf['_'] = '.project_alt.json'

local cache_path = sp_file.unify_path(sp.eval('g:spacevim_data_dir'), ':p') .. 'SpaceVim/a.json'


local project_config = {}

local function cache()
    fn.writefile({sp_json.json_encode(project_config)}, sp_file.unify_path(cache_path, ':p'))
end

local function load_cache()
    logger.info('Try to load alt cache from:' .. cache_path)
    local cache_context = fn.join(fn.readfile(cache_path, ''), '')
    if cache_context ~= '' then
        project_config = sp_json.json_decode(cache_context)
    end
end

function M.set_config_name(path, name)
    alternate_conf[path] = name
end

function M.alt(request_parse, ...)
   local arg={...}
   local type = 'alternate'
   local alt = nil
   if fn.exists('b:alternate_file_config') ~= 1 then
      local conf_file_path = M.getConfigPath()
      local file = sp_file.unify_path(fn.bufname('%'), '.')
      alt = M.get_alt(file, conf_file_path, request_parse, type)
   end
   if alt ~= nil then
   else
       print('failed to find alternate file!')
   end
end

local function get_project_config(conf_file)
    logger.info('read context from:' .. conf_file)
    local context = fn.join(fn.readfile(conf_file), "\n")
    local conf = sp_json.json_decode(context)
    if type(conf) ~= type({}) then
        conf = {}
    end
    local root = sp_file.unify_path(conf_file, ':p:h')
    return {
        ['root'] = root,
        ['config'] = conf
    }
end

local function parse(alt_config_json)
    logger.info('Start to parse alternate file for:' .. alt_config_json.root)
    project_config[alt_config_json.root] = {}
end

local function get_type_path(a, f, b)
end

local function is_config_changed(conf_path)
    if fn.getftime(conf_path) > fn.getftime(cache_path) then
        logger.info('alt config file('
            .. conf_path
            .. ')')
        return 1
    end
end

function M.get_alt(file, conf_path, request_parse, ...)
    
end

function M.getConfigPath()
    local pwd = fn.getcwd()
    local p = alternate_conf['_']
    if alternate_conf[pwd] ~= nil then
        p = alternate_conf[pwd]
    end
    return sp_file.unify_path(p, ':p')
end


