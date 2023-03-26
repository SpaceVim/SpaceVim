--=============================================================================
-- windisk.lua --- windisk plugin in lua
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


local M = {}


local function get_disks()

end

function M.open()
    local disks = get_disks()
    if vim.fn.empty(disks) == 0 then
        vim.cmd('noautocmd vsplit __windisk__')
        vim.cmd('vertical resize 20')
        local disk_buffer_nr = vim.fn.bufnr('%')
        vim.cmd('set ft=SpaceVimWinDiskManager')
        vim.cmd('setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixwidth')
        vim.cmd('setlocal modifiable')
        vim.fn.setline(1, lines)
        vim.cmd('setlocal nomodifiable')
        vim.cmd("nnoremap <buffer><silent> <Cr> :lua require('spacevim.plugin.windisk').open_disk(vim.fn.getline('.'))<cr>")
    end
end

local function diskinfo()
    if vim.fn.executable('wmic') == 0 then
        return {}
    end
    local rst = vim.fn.systemlist('wmic LOGICALDISK LIST BRIEF')
    local disk = {}
    for _,line in pairs(rst) do
    end
end


return M
