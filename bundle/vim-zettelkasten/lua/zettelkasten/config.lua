--=============================================================================
-- config.lua --- the config module for zettelkasten
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================
local M = {}


if vim.g.zettelkasten_directory and vim.g.zettelkasten_directory ~= '' then
  M.zettel_dir = vim.g.zettelkasten_directory 
else
  M.zettel_dir =  '~/.zettelkasten/'
end

local s_config = {
    notes_path = "",
    preview_command = "pedit",
    browseformat = "%f - %h [%r Refs] [%b B-Refs] %t",
}

M.get = function()
    return s_config
end

M._set = function(new_config)
    s_config = vim.tbl_extend("force", s_config, new_config)
end

return M
