--=============================================================================
-- toml.lua --- toml lua api
-- Copyright (c) 2016-2023 Wang Shidong & Contributors
-- Author: Wang Shidong < wsdjeg@outlook.com >
-- URL: https://spacevim.org
-- License: GPLv3
--=============================================================================

local M = {}

local skip_pattern = '\\C^\\%(\\_s\\+\\|#[^\r\n]*\\)'
local table_name_pattern = [[\%([^ [:tab:]#.[\]=]\+\)]]
local table_key_pattern = table_name_pattern

function M.parse(text)
  local input = {
    text = text,
    p = 0,
    length = vim.fn.strlen(text),
  }
  return M._parse(input)
end

function M.parse_file(filename)
  if vim.fn.filereadable(filename) == 0 then
    error('toml API: No such file ' .. filename)
  end

  local text = table.concat(vim.fn.readfile(filename), '\n')

  return M.parse(vim.fn.iconv(text, 'utf8', vim.o.encoding))
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
  while (input.p + offset) < input.length and input.text[input.p + offset] ~= '[\r\n]' do
    table.insert(buf, input.text[input.p + offset])
    offset = offset + 1
  end
end

function M._parse(input)
  local data = {}
  M._skip(input)
  while M._eof(input) do
    if M._match(input, '[^ [:tab:]#.[\\]]') then
      local key = M._key(input)
      M._equals(input)
      local value = M._value(input)

      M._put_dict(data, key, value)

    elseif M._match(input, '\\[\\[') then
      local key, value = M._array_of_tables(input)

      M._put_array(data, key, value)
    elseif M._match(input, '\\[') then
      local key, value = M._table(input)

      M._put_dict(data, key, value)
    else
      M._error(input)
    end
    M._skip(input)
  end
  return data
end


function M._key(input)
  local s = M._consume(input, table_key_pattern)
  return s
end


function M._equals(input)
  M._consume(input, '=')
  return '='
end

return M
