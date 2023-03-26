--=============================================================================
-- zettelkasten.lua --- init plugin for zk
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
if vim.fn.exists(":ZkNew") == 0 then
    vim.api.nvim_create_user_command("ZkNew", ":lua require('zettelkasten').zknew({})", {})
end

if vim.fn.exists(":ZkBrowse") == 0 then
    vim.cmd([[command ZkBrowse :lua _G.zettelkasten.zkbrowse()]])
end

_G.zettelkasten = {
    tagfunc = require("zettelkasten").tagfunc,
    completefunc = require("zettelkasten").completefunc,
    zknew = require("zettelkasten").zknew,
    zkbrowse = function()
        vim.cmd("edit zk://browser")
    end,
}
