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

local function get_type_path(a, f, b)
    local begin_len = fn.strlen(a[0])
    local end_len = fn.strlen(a[1])
    return fn.substitute(b, '{}', string.sub(f, begin_len,  (end_len+1) * -1), 'g')
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
    logger.debug(context)
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
    for key, value in pairs(alt_config_json.config) do
        logger.info('start parse key:' .. key)
        local searchpath = key
        if string.match(searchpath, '*') == '*' then
            searchpath = string.gsub(searchpath, '*', '**/*')
        end
        logger.info('run globpath for: '.. searchpath)
        for file in pairs(cmp.globpath('.', searchpath)) do
            file = sp_file.unify_path(file, ':.')
            project_config[alt_config_json.root][file] = {}
            if alt_config_json.config.file ~= nil then
                for type, _ in pairs(alt_config_json.config[file]) do
                    project_config[alt_config_json.root][file][type] = alt_config_json.config[file][type]
                end
            else
                for a_type, _ in pairs(alt_config_json.config[key]) do
                    local begin_end = fn.split(key, '*')
                    if #begin_end == 2 then
                        project_config[alt_config_json.root][file][a_type] =
                        get_type_path(
                            begin_end,
                            file,
                            alt_config_json.config[key][a_type]
                            )
                    end
                end
            end
        end
    end
    logger.info('Paser done, try to cache alternate info')
    cache()
end

local function is_config_changed(conf_path)
    if fn.getftime(conf_path) > fn.getftime(cache_path) then
        logger.info('alt config file('
            .. conf_path
            .. ')')
        return 1
    end
end

function M.get_alt(file, conf_path, request_parse, a_type)
  logger.info('getting alt file for:' .. file)
  logger.info('  >   type: ' .. a_type)
  logger.info('  >  parse: ' .. request_parse)
  logger.info('  > config: ' .. conf_path)
  alt_config_json = get_project_config(conf_path)
  if project_config[alt_config_json.root] == nil
        and is_config_changed(conf_path) == 0
        and request_parse == 0 then
    load_cache()
    if project_config[alt_config_json.root] == nil
          or project_config[alt_config_json.root][file] == nil then
        parse(alt_config_json)
    end
  else
    parse(alt_config_json)
  end
  if project_config[alt_config_json.root] ~= nil
        and project_config[alt_config_json.root][file] ~= nil
        and project_config[alt_config_json.root][file][a_type] ~= nil then
    return project_config[alt_config_json.root][file][a_type]
  else
    return ''
  end
end

function M.getConfigPath()
    local pwd = fn.getcwd()
    local p = alternate_conf['_']
    if alternate_conf[pwd] ~= nil then
        p = alternate_conf[pwd]
    end
    return sp_file.unify_path(p, ':p')
end

return M

