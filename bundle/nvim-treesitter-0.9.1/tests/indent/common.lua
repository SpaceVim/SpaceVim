local M = {}

local assert = require "luassert"
local say = require "say"
local scan_dir = require("plenary.scandir").scan_dir
local Path = require "plenary.path"

M.XFAIL = "xfail"

local function same_indent(state, arguments)
  local before = arguments[1]
  local after = arguments[2]

  local ok = true
  local errors = { before = {}, after = {} }
  for line = 1, #before do
    if #string.match(before[line], "^%s*") ~= #string.match(after[line], "^%s*") then
      if before[line] and after[line] then
        -- store the actual indentation length for each line
        errors.before[line] = #string.match(before[line], "^%s*")
        errors.after[line] = #string.match(after[line], "^%s*")
      end
      ok = false
    end
  end

  -- we will always use only a single argument, passing the other one in fmtargs
  arguments.fmtargs = { { errors = errors, other = after } }
  arguments.fmtargs[2] = { errors = errors, other = after }

  return ok
end

local function format_indent(arg, fmtargs)
  if not arg or not fmtargs then
    return
  end
  -- find minimal width if any line is longer
  local width = 40
  for _, line in ipairs(fmtargs.other) do
    width = #line > width and #line or width
  end

  width = width + 3
  local header_fmt = "%8s %2s%-" .. tostring(width + 1) .. "s %s"
  local fmt = "%8s %2s |%-" .. tostring(width) .. "s |%s"

  local output = { header_fmt:format("", "", "Found:", "Expected:") }

  for i, line in ipairs(arg) do
    if fmtargs.errors.before[i] then
      local indents = string.format("%d vs %d", fmtargs.errors.after[i], fmtargs.errors.before[i])
      table.insert(output, fmt:format(indents, "=>", fmtargs.other[i], line))
    else
      table.insert(output, fmt:format("", "", fmtargs.other[i], line))
    end
  end

  return table.concat(output, "\n")
end

say:set_namespace "en"
say:set("assertion.same_indent.positive", "Incorrect indentation\n%s")
say:set("assertion.same_indent.negative", "Incorrect indentation\n%s")
assert:register(
  "assertion",
  "same_indent",
  same_indent,
  "assertion.same_indent.positive",
  "assert.same_indent.negative"
)

-- Custom assertion better suited for indentation diffs
local function compare_indent(before, after, xfail)
  assert:add_formatter(format_indent)
  if xfail then
    io.stdout:write "Warning! Known failure of this test! Please help to fix it! "
    assert.is_not.same_indent(before, after)
  else
    assert.is.same_indent(before, after)
  end
  assert:remove_formatter(format_indent)
end

local function set_buf_indent_opts(opts)
  local optnames = { "tabstop", "shiftwidth", "softtabstop", "expandtab", "filetype" }
  for _, opt in ipairs(optnames) do
    if opts[opt] ~= nil then
      vim.bo[opt] = opts[opt]
    end
  end
end

function M.run_indent_test(file, runner, opts)
  assert.are.same(1, vim.fn.filereadable(file), string.format('File "%s" not readable', file))

  -- load reference file
  vim.cmd(string.format("edit %s", file))
  vim.bo.indentexpr = "nvim_treesitter#indent()"
  local before = vim.api.nvim_buf_get_lines(0, 0, -1, true)

  assert.are.same("nvim_treesitter#indent()", vim.bo.indentexpr)
  set_buf_indent_opts(opts)

  -- perform the test
  runner()

  -- get file content after the test
  local after = vim.api.nvim_buf_get_lines(0, 0, -1, true)

  -- clear any changes to avoid 'No write since last change (add ! to override)'
  vim.cmd "edit!"

  return before, after
end

function M.indent_whole_file(file, opts, xfail)
  local before, after = M.run_indent_test(file, function()
    vim.cmd "silent normal gg=G"
  end, opts)

  compare_indent(before, after, xfail)
end

-- Open a file, use `normal o` to insert a new line and compare results
-- @param file path to the initial file
-- @param spec a table with keys:
--   on_line: line on which `normal o` is executed
--   text: text inserted in the new line
--   indent: expected indent before the inserted text (string or int)
-- @param opts buffer options passed to set_buf_indent_opts
function M.indent_new_line(file, spec, opts, xfail)
  local before, after = M.run_indent_test(file, function()
    -- move to the line and input the new one
    vim.cmd(string.format("normal! %dG", spec.on_line))
    vim.cmd(string.format("normal! o%s", spec.text))
  end, opts)

  local indent = type(spec.indent) == "string" and spec.indent or string.rep(" ", spec.indent)
  table.insert(before, spec.on_line + 1, indent .. spec.text)

  compare_indent(before, after, xfail)

  before, after = M.run_indent_test(file, function()
    -- move to the line and input the new one
    vim.cmd(string.format("normal! %dG$", spec.on_line))
    vim.cmd(string.format(vim.api.nvim_replace_termcodes("normal! a<cr>%s", true, true, true), spec.text))
  end, opts)

  indent = type(spec.indent) == "string" and spec.indent or string.rep(" ", spec.indent)
  table.insert(before, spec.on_line + 1, indent .. spec.text)

  compare_indent(before, after, xfail)
end

local Runner = {}
Runner.__index = Runner

-- Helper to avoid boilerplate when defining tests
-- @param it  the "it" function that busted defines globally in spec files
-- @param base_dir  all other paths will be resolved relative to this directory
-- @param buf_opts  buffer options passed to set_buf_indent_opts
function Runner:new(it, base_dir, buf_opts)
  local runner = {}
  runner.it = it
  runner.base_dir = Path:new(base_dir)
  runner.buf_opts = buf_opts
  return setmetatable(runner, self)
end

function Runner:whole_file(dirs, opts)
  opts = opts or {}
  local expected_failures = opts.expected_failures or {}
  expected_failures = vim.tbl_map(function(f)
    return Path:new(f):make_relative(self.base_dir.filename)
  end, expected_failures)
  dirs = type(dirs) == "table" and dirs or { dirs }
  dirs = vim.tbl_map(function(dir)
    dir = self.base_dir / Path:new(dir)
    assert.is.same(1, vim.fn.isdirectory(dir.filename))
    return dir.filename
  end, dirs)
  local files = vim.tbl_flatten(vim.tbl_map(scan_dir, dirs))
  for _, file in ipairs(files) do
    local relpath = Path:new(file):make_relative(self.base_dir.filename)
    self.it(relpath, function()
      M.indent_whole_file(file, self.buf_opts, vim.tbl_contains(expected_failures, relpath))
    end)
  end
end

function Runner:new_line(file, spec, title, xfail)
  title = title and title or tostring(spec.on_line)
  self.it(string.format("%s[%s]", file, title), function()
    local path = self.base_dir / file
    M.indent_new_line(path.filename, spec, self.buf_opts, xfail)
  end)
end

M.Runner = Runner

return M
