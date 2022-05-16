local dirname = function(p)
  return vim.fn.fnamemodify(p, ":h")
end

local function get_trace(element, level, msg)
  local function trimTrace(info)
    local index = info.traceback:find "\n%s*%[C]"
    info.traceback = info.traceback:sub(1, index)
    return info
  end
  level = level or 3

  local thisdir = dirname(debug.getinfo(1, "Sl").source, ":h")
  local info = debug.getinfo(level, "Sl")
  while
    info.what == "C"
    or info.short_src:match "luassert[/\\].*%.lua$"
    or (info.source:sub(1, 1) == "@" and thisdir == dirname(info.source))
  do
    level = level + 1
    info = debug.getinfo(level, "Sl")
  end

  info.traceback = debug.traceback("", level)
  info.message = msg

  -- local file = busted.getFile(element)
  local file = false
  return file and file.getTrace(file.name, info) or trimTrace(info)
end

local is_headless = require("plenary.nvim_meta").is_headless

-- We are shadowing print so people can reliably print messages
print = function(...)
  for _, v in ipairs { ... } do
    io.stdout:write(tostring(v))
    io.stdout:write "\t"
  end

  io.stdout:write "\r\n"
end

local mod = {}

local results = {}
local current_description = {}
local current_before_each = {}
local current_after_each = {}

local add_description = function(desc)
  table.insert(current_description, desc)

  return vim.deepcopy(current_description)
end

local pop_description = function()
  current_description[#current_description] = nil
end

local add_new_each = function()
  current_before_each[current_description[#current_description]] = {}
  current_after_each[current_description[#current_description]] = {}
end

local clear_last_each = function()
  current_before_each[current_description[#current_description]] = nil
  current_after_each[current_description[#current_description]] = nil
end

local call_inner = function(desc, func)
  local desc_stack = add_description(desc)
  add_new_each()
  local ok, msg = xpcall(func, function(msg)
    -- debug.traceback
    -- return vim.inspect(get_trace(nil, 3, msg))
    local trace = get_trace(nil, 3, msg)
    return trace.message .. "\n" .. trace.traceback
  end)
  clear_last_each()
  pop_description()

  return ok, msg, desc_stack
end

local color_table = {
  yellow = 33,
  green = 32,
  red = 31,
}

local color_string = function(color, str)
  if not is_headless then
    return str
  end

  return string.format("%s[%sm%s%s[%sm", string.char(27), color_table[color] or 0, str, string.char(27), 0)
end

local SUCCESS = color_string("green", "Success")
local FAIL = color_string("red", "Fail")
local PENDING = color_string("yellow", "Pending")

local HEADER = string.rep("=", 40)

mod.format_results = function(res)
  print ""
  print(color_string("green", "Success: "), #res.pass)
  print(color_string("red", "Failed : "), #res.fail)
  print(color_string("red", "Errors : "), #res.errs)
  print(HEADER)
end

mod.describe = function(desc, func)
  results.pass = results.pass or {}
  results.fail = results.fail or {}
  results.errs = results.errs or {}

  describe = mod.inner_describe
  local ok, msg, desc_stack = call_inner(desc, func)
  describe = mod.describe

  if not ok then
    table.insert(results.errs, {
      descriptions = desc_stack,
      msg = msg,
    })
  end
end

mod.inner_describe = function(desc, func)
  local ok, msg, desc_stack = call_inner(desc, func)

  if not ok then
    table.insert(results.errs, {
      descriptions = desc_stack,
      msg = msg,
    })
  end
end

mod.before_each = function(fn)
  table.insert(current_before_each[current_description[#current_description]], fn)
end

mod.after_each = function(fn)
  table.insert(current_after_each[current_description[#current_description]], fn)
end

mod.clear = function()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
end

local indent = function(msg, spaces)
  if spaces == nil then
    spaces = 4
  end

  local prefix = string.rep(" ", spaces)
  return prefix .. msg:gsub("\n", "\n" .. prefix)
end

local run_each = function(tbl)
  for _, v in pairs(tbl) do
    for _, w in ipairs(v) do
      if type(w) == "function" then
        w()
      end
    end
  end
end

mod.it = function(desc, func)
  run_each(current_before_each)
  local ok, msg, desc_stack = call_inner(desc, func)
  run_each(current_after_each)

  local test_result = {
    descriptions = desc_stack,
    msg = nil,
  }

  -- TODO: We should figure out how to determine whether
  -- and assert failed or whether it was an error...

  local to_insert, printed
  if not ok then
    to_insert = results.fail
    test_result.msg = msg

    print(FAIL, "||", table.concat(test_result.descriptions, " "))
    print(indent(msg, 12))
  else
    to_insert = results.pass
    print(SUCCESS, "||", table.concat(test_result.descriptions, " "))
  end

  table.insert(to_insert, test_result)
end

mod.pending = function(desc, func)
  local curr_stack = vim.deepcopy(current_description)
  table.insert(curr_stack, desc)
  print(PENDING, "||", table.concat(curr_stack, " "))
end

_PlenaryBustedOldAssert = _PlenaryBustedOldAssert or assert

describe = mod.describe
it = mod.it
pending = mod.pending
before_each = mod.before_each
after_each = mod.after_each
clear = mod.clear
assert = require "luassert"

mod.run = function(file)
  print("\n" .. HEADER)
  print("Testing: ", file)

  local ok, msg = pcall(dofile, file)

  if not ok then
    print(HEADER)
    print "FAILED TO LOAD FILE"
    print(color_string("red", msg))
    print(HEADER)
    if is_headless then
      return vim.cmd "2cq"
    else
      return
    end
  end

  -- If nothing runs (empty file without top level describe)
  if not results.pass then
    if is_headless then
      return vim.cmd "0cq"
    else
      return
    end
  end

  mod.format_results(results)

  if #results.errs ~= 0 then
    print("We had an unexpected error: ", vim.inspect(results.errs), vim.inspect(results))
    if is_headless then
      return vim.cmd "2cq"
    end
  elseif #results.fail > 0 then
    print "Tests Failed. Exit: 1"

    if is_headless then
      return vim.cmd "1cq"
    end
  else
    if is_headless then
      return vim.cmd "0cq"
    end
  end
end

return mod
