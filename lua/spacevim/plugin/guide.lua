--!/usr/bin/lua


local M = {}

-- load apis

local cmp = require('spacevim.api').import('vim.compatible')
local buffer = require('spacevim.api').import('vim.buffer')

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
    if key == '<Space>' then
        key = ' '
    end
    if desc_lookup == nil then
        create_cache()
    end
    if cmp.fn.strlen(key) == 0 then
        desc_lookup['top'] = dictname
    else
        if desc_lookup[key] == nil then
            desc_lookup[key] = dictname
        end
    end
end


-- the flag for guide help mode, the default is false
local guide_help_mode = false

local function create_cache()
    desc_lookup = {}

    cached_dicts = {}
end

local function create_target_dict(key)
    local toplevel = {}
    local tardict = {}
    local mapdict = {}
    if desc_lookup['top'] ~= nil then
        toplevel = cmp.fn.deepcopy({desc_lookup['top']})
        if toplevel then
            tardict = toplevel
        else
            tardict = toplevel[key] or {}
        end
        mapdict = cached_dicts[key]
        merge(tardict, mapdict)
    elseif desc_lookup[key] ~= nil then
        tardict = cmp.fn.deepcopy({desc_lookup[key]})
        mapdict = cached_dicts[key]
    else
        tardict = cached_dicts[key]
    end
    return tardict


end

local function merge(dict_t, dict_o)
    local target = dict_t
    local other = dict_o
    for k, v in ipairs(target) do
        if vim.fn.type(target[k]) == 4 and vim.fn.has_key(other, k) then
            if vim.fn.type(other[k]) == 4 then
                if vim.fn.has_key(target[k], 'name') then
                    other[k].name = target[k].name
                end
                merge(target[k], other[k])
            elseif vim.fn.type(other[k]) == 3 then
                if vim.g.leaderGuide_flatten == 0 or vim.fn.type(target[k]) == 4 then
                    target[k .. 'm'] = target[k]
                end
                target[k] = other[k]
                if vim.fn.has_key(other, k .. 'm') and vim.fn.type(other[k .. 'm']) == 4 then
                    merge(target[k .. 'm'], other[k .. 'm'])
                end
            end
        end
    end
    vim.fn.extend(target, other, 'keep')
end

function M.populate_dictionary(key, dictname)
    start_parser(key, cached_dicts[key])
end

function M.parse_mappings()
    for k, v in ipairs(cached_dicts) do
        start_parser(k, v)
    end
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
    elseif a >= 97 and a <= 122 and b >= 97 and b <= 122 then
        if a == b then return 0 elseif a > b then return 1 else return -1 end
    elseif a >= 65 and a <= 90 and b >= 65 and b <= 90 then
        if a == b then return 0 elseif a > b then return 1 else return -1 end
    elseif a >= 97 and a <= 122 and b >= 65 and b <= 90 then
        return compare_key(cmp.fn.nr2char(a), cmp.fn.nr2char(b + 32))
    elseif a >= 65 and a <= 90 and b >= 97 and b <= 122 then
        return compare_key(cmp.fn.nr2char(a), cmp.fn.nr2char(b - 32))
    end
    if a == b then return 0 elseif a > b then return 1 else return -1 end
end


local function create_string(layout)

end

local function highlight_cursor()

end

local function remove_cursor_highlight()

end

local function start_buffer()
    local winv = cmp.fn.winsaveview()
    local winnr = cmp.fn.winnr()
    local winres = cmp.fn.winrestcmd()
    local winid = 0
    local bufnr = 0
    winid, bufnr = winopen()
    local layout = calc_layout()
    local text = create_string(layout)
    if vim.g.leaderGuide_max_size then
        layout.win_dim = cmp.fn.min({vim.g.leaderGuide_max_size, layout.win_dim})
    end
    cmp.fn.setbufvar(bufnr, '&modifiable', 1)
    if floating.exists() then
    else
        if vim.g.leaderGuide_vertical then
        else
        end
    end
    if floating.exists() then
    else
    end
    cmp.fn.setbufvar(bufnr, '&modifiable', 0)

    -- radraw!

    wait_for_input()

end

local function handle_input(input)
    winclose()
    if type(input) == 'table' then
        lmap = input
        start_buffer()
    else
        prefix_key_inp = {}
        cmp.fn.feedkeys(vis .. reg .. count, 'ti')

        --- redraw!

        local ok, errors = pcall(vim.fn.execute, input[1])
        if not ok then
            print(vim.v.exception)
        end

    end


end

local function wait_for_input()

end


local function build_mpt(mpt)

    vim.fn.execute('normal! :')

    vim.fn.execute('echohl Comment')

    if type(mpt) == 'string' then
        print(mpt)
    else
    end

    vim.fn.execute('echohl NONE')

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

return M
