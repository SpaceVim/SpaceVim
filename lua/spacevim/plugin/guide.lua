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

local function merge(dict_t, dict_o)
    
end

function M.populate_dictionary(key, dictname)
    start_parser(key, cached_dicts[key])
end

function M.parse_mappings()
    
end

local function start_parser(key, dict)
    if key == '[KEYs]' then
        return ''
    end

    if key == ' ' then key = '<Space>' end

    local readmap = cmp.execute('map ' .. key, 'silent')

    for _, line in ipairs(cmp.fn.split(readmap, "\n")) do
        local mapd = cmp.fn.maparg(
        cmp.split(
        string.sub(line, 3, string.len(line))
        )[1], string.sub(line, 1, 1), 0, 1)
        if mapd.lhs == "\\" then
            mapd.feedkeyargs = ''
        elseif mapd.noremap == 1 then
            mapd.feedkeyargs = 'nt'
        else
            mapd.feedkeyargs = 'mt'
        end
        if mapd.lhs == '<Plug>.*' or mapd.lhs == '<SNR>.*' then
            goto continue
        end
        mapd.display = format_displaystring(mapd.rhs)
        mapd.lhs = cmp.fn.substitute(mapd.lhs, key, '', '')
        mapd.lhs = cmp.fn.substitute(mapd.lhs, '<Space>', ' ', 'g')
        mapd.lhs = cmp.fn.substitute(mapd.lhs, '<Tab>', '<C-I>', 'g')
        mapd.rhs = cmp.fn.substitute(mapd.rhs, '<SID>', '<SNR>' .. mapd['sid'] .. '_', 'g')
        if mapd.lhs ~= '' and mapd.display ~= 'LeaderGuide.*' then
        end
        ::continue::
    end
end


local function add_map_to_dict(map, level, dict)
    
end

local function format_displaystring(map)
    
end

local function flattenmap(dict, str)
    
end

local function escape_mappings(mapping)
    
end

local function string_to_keys(input)
    
end

local function escape_keys(inp)
    local ret = cmp.fn.substitute(inp, '<', '<lt>', '')
    return cmp.fn.substitute(ret, '|', '<Bar>', '')
end


local function calc_layout()
    
end

local function get_key_number(key)
    if key == '[SPC]' then
        return 32
    elseif key == '<Tab>' then
        return 9
    else
        return cmp.fn.char2nr(key)
    end
end

local function compare_key(i1, i2)
    local a = get_key_number(i1)
    local b = get_key_number(i2)
    if a - b == 32 and a >= 97 and a <= 122 then
        return -1
    elseif b - a == 32 and b >= 97 and b <= 122 then
        return 1

    end
end


local function create_string(layout)
    
end

local function highlight_cursor()
    
end

local function remove_cursor_highlight()
    
end

local function start_buffer()
    
end

local function handle_input(input)
    
end

local function wait_for_input()
    
end


local function build_mpt(mpt)
    
end

local function winopen()
    
end

local function updateStatusline()
    
end

local function close_float_statusline()
    
end

local function guide_help_msg(escape)
    
end

local function toggle_hide_cursor()
    
end

local function winclose()
    
end


local function page_down()
    
end

local function page_undo()
    
end

local function page_up()
    
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

local function mapmaparg(maparg)
    
end


local function get_register()
    
end

function M.start_by_prefix(vis, key)
    
end

function M.start(vis, dict)
    
end

function M.register_displayname(lhs, name)
    
end
