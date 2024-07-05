--=============================================================================
-- zettelkasten.lua --- init plugin for zk
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
if vim.fn.exists(":ZkNew") == 0 then
    vim.cmd([[command ZkNew :lua require('zettelkasten').zknew({})]])
end

if vim.fn.exists(":ZkBrowse") == 0 then
    vim.cmd([[command ZkBrowse :lua _G.zettelkasten.zkbrowse()]])
end

if vim.fn.exists(":ZkListTemplete") == 0 then
    vim.cmd([[command ZkListTemplete :Telescope zettelkasten_template]])
end

_G.zettelkasten = {
    tagfunc = require("zettelkasten").tagfunc,
    completefunc = require("zettelkasten").completefunc,
    zknew = require("zettelkasten").zknew,
    zkbrowse = function()
        vim.cmd("edit zk://browser")
    end,
}
