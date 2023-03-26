--=============================================================================
-- config.lua --- the config module for zettelkasten
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
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

if vim.g.zettelkasten_template_directory and vim.g.zettelkasten_template_directory ~= '' then
  M.templete_dir = vim.g.zettelkasten_template_directory 
else
  M.templete_dir =  '~/.zettelkasten_template'
end

M.browseformat = "%f - %h [%r Refs] [%b B-Refs] %t"
M.preview_command = "pedit"

M.get = function()
    return nil
end

return M
