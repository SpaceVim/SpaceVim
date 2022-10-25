local api = vim.api
local s_config = require("zettelkasten.config")

if vim.fn.exists(":ZkNew") == 0 then
    vim.cmd([[command ZkNew :lua require('zettelkasten').zknew({})]])
end

if vim.fn.exists(":ZkBrowse") == 0 then
    vim.cmd([[command ZkBrowse :lua _G.zettelkasten.zkbrowse()]])
end

_G.zettelkasten = {
    tagfunc = require("zettelkasten").tagfunc,
    completefunc = require("zettelkasten").completefunc,
    zknew = require('zettelkasten').zknew,
    zkbrowse = function()
        vim.cmd("edit zk://browser")
    end,
}
