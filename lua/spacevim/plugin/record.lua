--=============================================================================
-- record.lua --- key recorder
-- Copyright (c) 2016-2019 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

M.enabled = false

local recordid = vim.api.nvim_create_namespace('')

function M.record(char)
    print(char)
end


function M.enable()
    vim.register_keystroke_callback(M.record, recordid)
    M.enabled = true
end

function M.disable()
    vim.register_keystroke_callback(nil, recordid)
    M.enabled = false
end

function M.toggle()
    if M.enabled then M.disable() else M.enable() end
end


return M
