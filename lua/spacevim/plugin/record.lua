--=============================================================================
-- record.lua --- key recorder
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local enabled = false

local keystrokes = {}


-- timeout for remove the first key
local remove_timeout = 3000

-- 需要再什么位置显示
-- 根据按键的长度

local first_col = 15

local recordid = vim.api.nvim_create_namespace('')

local borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'}

local function draw_border(title, width, height)
    local top = borderchars[5] ..
    string.rep(borderchars[1], width) ..
    borderchars[6]
    local mid = borderchars[4] ..
    string.rep(' ', width) ..
    self.borderchars[2]
    local bot = borderchars[8] ..
    string.rep(borderchars[3], width) ..
    borderchars[7]
    top = string_compose(top, 1, title)
    local lines = {top} + string.rep({mid}, height) + {bot}
    return lines
end

local function escape(char)
    return char
end

local function remove_first_key()

end

local function record(char)
    table.insert(keystrokes, escape(char))
    vim.fn.timer_start(remove_first_key, remove_timeout)
end

local function print_key(key)

end

local function get_first_col()
    return 15
end

local function display()
    first_col = get_first_col()
    for _, key in pairs(keystrokes) do
        print_key(key)
    end
end


local function enable()
    -- https://github.com/neovim/neovim/issues/15527
    vim.register_keystroke_callback(record, recordid)
    M.enabled = true
end

local function disable()
    vim.register_keystroke_callback(nil, recordid)
    M.enabled = false
end

function M.toggle()
    if enabled then disable() else enable() end
end


return M
