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

function M._skip(input)
  while M._match(input, [[\%(\_s\|#\)]]) do
    input.p = vim.fn.matchend(input.text, skip_pattern, input.p)
  end
end
local regex_prefix = ''
if vim.fn.exists('+regexpengine') == 1 then
  regex_prefix = '\\%#=1\\C^'
else
  regex_prefix = '\\C^'
end

function M._consume(input, pattern)
  M._skip(input)
  local _end = vim.fn.matchend(input.text, regex_prefix .. pattern, input.p)
  if _end == -1 then
    M._error(input)
  elseif _end == input.p then
    return ''
  end
  local matched = vim.fn.strpart(input.text, input.p, _end - input.p)
  input.p = _end
  return matched
end

function M._match(input, pattern)
  return vim.fn.match(input.text, regex_prefix .. pattern, input.p) ~= -1
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
  while not M._eof(input) do
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

function M._value(input)
  M._skip(input)
  if M._match(input, '"\\{3}') then
    return M._multiline_basic_string(input)
  elseif M._match(input, '"\\{1}') then
    return M._basic_string(input)
  elseif M._match(input, "'\\{3}") then
    return M._multiline_literal(input)
  elseif M._match(input, "'\\{1}") then
    return M._literal(input)
  elseif M._match(input, '\\[') then
    return M._array(input)
  elseif M._match(input, '\\%(true\\|false\\)') then
    return M._boolean(input)
  elseif M._match(input, '\\d\\{4}-') then
    return M._datetime(input)
  elseif M._match(input, '[+-]\\?\\%(\\d\\+\\.\\d\\|\\d\\+\\%(\\.\\d\\+\\)\\?[eE]\\)') then
    return M._float(input)
  else
    return M._integer(input)
  end
end

function M._basic_string(input)
  local s = M._consume(input, [["\%(\\"\|[^"]\)*"]])
  s = string.sub(s, 2, #s - 1)
  return M._unescape(s)
end

function M._multiline_basic_string(input)
  local s = M._consume(input, '"\\{3}\\_.\\{-}"\\{3}')
  s = string.sub(s, 4, #s - 3)
  s = vim.fn.substitute(s, '^\n', '', '')
  s = vim.fn.substitute(s, '\\\\' .. '\n' .. '\\_s*', '', 'g')
  return M._unescape(s)
end

function M._literal(input)
  local s = M._consume(input, "'[^']*'")
  return string.sub(s, 2, #s - 1)
end

function M._multiline_literal(input)
  local s = M._consume(input, [['\{3}.\{-}'\{3}]])
  s = string.sub(s, 4, #s - 3)
  s = vim.fn.substitute(s, '^\n', '', '')
  return s
end

function M._integer(input)
  local s = M._consume(input, '[+-]\\?\\d\\+')
  return vim.fn.str2nr(s)
end

function M._float(input)
  if M._match(input, [[[+-]\?[0-9.]\+[eE][+-]\?\d\+]]) then
    return M._exponent(input)
  else
    return M._fractional(input)
  end
end

function M._fractional(input)
  local s = M._consume(input, [[[+-]\?[0-9.]\+]])
  return vim.fn.str2float(s)
end

function M._exponent(input)
  local s = M._consume(input, [[[+-]\?[0-9.]\+[eE][+-]\?\d\+]])
  return vim.fn.str2float(s)
end

function M._boolean(input)
  local s = M._consume(input, [[\%(true\|false\)]])
  if s == 'true' then
    return true
  else
    return false
  end
end

function M._datetime(input)
  local s = M._consume(
    input,
    [[\d\{4}-\d\{2}-\d\{2}T\d\{2}:\d\{2}:\d\{2}\%(Z\|-\?\d\{2}:\d\{2}\|\.\d\+-\d\{2}:\d\{2}\)]]
  )
  return s
end

function M._array(input)
  local ary = {}
  M._consume(input, '\\[')
  M._skip(input)
  while not M._eof(input) and not M._match(input, '\\]') do
    table.insert(ary, M._value(input))
    M._consume(input, ',\\?')
    M._skip(input)
  end
  M._consume(input, '\\]')
  return ary
end

function M._table(input)
  local tbl = {}
  local name = M._consume(
    input,
    '\\[\\s*' .. table_name_pattern .. '\\%(\\s*\\.\\s*' .. table_name_pattern .. '\\)*\\s*\\]'
  )
  name = string.sub(name, 2, #name - 1)
  M._skip(input)
  while not M._eof(input) and not M._match(input, '\\[') do
    local key = M._key(input)
    M._equals(input)
    local value = M._value(input)

    tbl[key] = value
    M._skip(input)
  end
  return name, tbl
end

function M._array_of_tables(input)
  local tbl = {}
  local name = M._consume(
    input,
    '\\[\\[\\s*'
      .. table_name_pattern
      .. '\\%(\\s*\\.\\s*'
      .. table_name_pattern
      .. '\\)*\\s*\\]\\]'
  )
  name = string.sub(name, 3, #name - 2)
  M._skip(input)
  while not M._eof(input) and not M._match(input, '\\[') do
    local key = M._key(input)
    M._equals(input)
    local value = M._value(input)

    tbl[key] = value
    M._skip(input)
  end
  return name, tbl
end

function M._unescape(text)
  text = vim.fn.substitute(text, '\\\\"', '"', 'g')
  text = vim.fn.substitute(text, '\\\\b', '\b', 'g')
  text = vim.fn.substitute(text, '\\\\t', '\t', 'g')
  text = vim.fn.substitute(text, '\\\\n', '\n', 'g')
  text = vim.fn.substitute(text, '\\\\f', '\f', 'g')
  text = vim.fn.substitute(text, '\\\\r', '\r', 'g')
  text = vim.fn.substitute(text, '\\\\/', '/', 'g')
  text = vim.fn.substitute(text, '\\\\\\\\', '\\', 'g')
  text = vim.fn.substitute(text, '\\C\\\\u\\(\\x\\{4}\\)', '\\=s:_nr2char("0x" . submatch(1))', 'g')
  text = vim.fn.substitute(text, '\\C\\U\\(\\x\\{8}\\)', '\\=s:_nr2char("0x" . submatch(1))', 'g')
  return text
end

function M._nr2char(nr)
  return vim.fn.iconv(vim.fn.nr2char(nr), vim.o.encoding, 'utf8')
end

local function is_list(t)
  return vim.tbl_islist(t)
end

local function is_table(t)
  return vim.fn.type(t) == 4
end

local function has_key(t, k)
  if type(t) == 'table' and t[k] ~= nil then
    return true
  else
    return false
  end
end

function M._put_dict(dict, key_name, value)
  local keys = vim.split(key_name, '%.')

  local ref = dict
  local i = 1
  for _, key in ipairs(keys) do
    if i == #keys then
      break
    end
    if has_key(ref, key) and is_table(ref[key]) then
      ref = ref[key]
    elseif has_key(ref, key) and is_list(ref[key]) then
      ref = ref[key][#ref[key]]
    else
      ref[key] = {}
      ref = ref[key]
    end
    i = i + 1
  end

  ref[keys[#keys]] = value
end

function M._put_array(dict, key_name, value)
  local keys = vim.split(key_name, '%.')

  local ref = dict
  local i = 1
  for _, key in ipairs(keys) do
    if i == #keys then
      break
    end
    ref[key] = ref[key] or {}

    if is_list(ref[key]) then
      ref = ref[key][#ref[key]]
    else
      ref = ref[key]
    end
    i = i + 1
  end

  ref[keys[#keys]] = ref[keys[#keys]] or {}

  table.insert(ref[keys[#keys]], value)
end

return M
