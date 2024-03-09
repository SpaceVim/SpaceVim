--=============================================================================
-- argv.lua --- cmdline to argv
-- Copyright (c) 2016-2022 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local str = require('spacevim.api.data.string')



function M.parser(cmdline)
  local argvs = {}
  local argv = ''
  local escape = false
  local isquote = false

  for _, c in ipairs(str.string2chars(cmdline)) do
    if not escape and not isquote and c == ' '  then
      if #argv > 0 then
        table.insert(argvs, argv)
        argv = ''
      end
    elseif not escape and isquote and c == '"' then
      isquote = false
      table.insert(argvs, argv)
      argv = ''
    elseif not escape and not isquote and c == '"' then
      isquote = true
    elseif not escape and c == '\\' then
      escape = true
    elseif escape and c == '"' then
      argv = argv .. '"'
      escape = false
    elseif escape then
      argv = argv .. '\\' .. c
      escape = false
    else
      argv = argv .. c
    end
  end

  -- is last char is \
  if escape then
    argv = argv .. '\\'
  end

  if argv ~= '' then
    table.insert(argvs, argv)
  end

  return argvs
end


return M
