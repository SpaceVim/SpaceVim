local api = vim.api
local s_config = require("zettelkasten.config")

if vim.fn.exists(":ZkNew") == 0 then
    vim.cmd([[command ZkNew :lua _G.zettelkasten.zknew()]])
end

if vim.fn.exists(":ZkBrowse") == 0 then
    vim.cmd([[command ZkBrowse :lua _G.zettelkasten.zkbrowse()]])
end

_G.zettelkasten = {
    tagfunc = require("zettelkasten").tagfunc,
    completefunc = require("zettelkasten").completefunc,
    zknew = function()
        vim.cmd([[new | setlocal filetype=markdown]])
        if s_config.zettel_dir ~= "" then
            vim.cmd("lcd " .. s_config.zettel_dir)
        end

        vim.cmd("normal ggI# New Note")
        require("zettelkasten").set_note_id(vim.api.nvim_get_current_buf())
        vim.cmd("normal $")
    end,
    zkbrowse = function()
        vim.cmd("edit zk://browser")
    end,
}
