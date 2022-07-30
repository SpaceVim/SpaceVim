--!/usr/bin/lua


local M = {}

-- load apis

local cmp = require('spacevim.api').import('vim.compatible')

local desc_lookup = {}

local cached_dicts = {}

local winid = -1

local bufnr = -1

local prefix_key_inp = {}

local lmap = {}

local undo_history = {}

function M.has_configuration()
    return desc_lookup ~= nil
end


function M.register_prefix_descriptions(key, dictname)
    
end


-- the flag for guide help mode, the default is false
local guide_help_mode = false

local function create_cache()
    desc_lookup = {}

    cached_dicts = {}
end

local function create_target_dict(key)
    
end


local function build_mpt(mpt)
    
end

local function page_down()
    
end

local function page_undo()
    
end

local function page_up()
    
end


local function winclose()
    
end

local function start_parser(key, dict)
    if key == '[KEYs]' then
        return ''
    end

    if key == ' ' then key = '<Space>' end

    local readmap = cmp.execute('map ' .. key, 'silent')
end


local function handle_submode_mapping(cmd)

    guide_help_mode = false

    updateStatusline()

    if cmd == 'n' then
        page_down()
    elseif cmd == 'p' then
        page_up()
    elseif cmd == 'u' then
        page_undo()
    else
        winclose()
    end
    
end


local function submode_mappings(key)
    handle_submode_mapping(key)
end


local function get_register()
    
end
