--=============================================================================
-- toml.lua --- toml lua api
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================


local M = {}

function M.parse(text) -- {{{
  
end
-- }}}

function M.parse_file(filename)
  
end

function M._consume(input, pattern)
  M._skip(input)
  local _end = vim.fn.matchend(input.text, pattern, input.p)
  if _end == -1 then
    M._error(input)
  elseif _end == input.p then
    return ''
  end
  local matched = vim.fn.strpat(input.text, input.p, _end - input.p)
  input.p = _end
  return matched
end


local skip_pattern = '\\C^\\%(\\_s\\+\\|#[^\r\n]*\\)'

function M._skip(input)
  while M._match(input, [[\%(\_s\|#\)]]) do
    input.p = vim.fn.matchend(input.text, skip_pattern, input.p)
  end
end

function M._match(input, pattern)
  return vim.fn.match(input.text, pattern, input.p) ~= -1
end

function M._eof(input)
  return input.p >= input.length
end

function M._error(input)
  local buf = {}
  local offset = 0
  -- @todo !=# string to lua
  while (input.p + offset) < input.length and input.text[input.p + offset] ~= "[\r\n]" do
    table.insert(buf,  input.text[input.p + offset])
    offset = offset + 1
  end

  
end

return M
