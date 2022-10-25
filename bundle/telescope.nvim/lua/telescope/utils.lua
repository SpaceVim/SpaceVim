---@tag telescope.utils
---@config { ["module"] = "telescope.utils" }

---@brief [[
--- Utilities for writing telescope pickers
---@brief ]]

local Path = require "plenary.path"
local Job = require "plenary.job"

local log = require "telescope.log"

local truncate = require("plenary.strings").truncate
local get_status = require("telescope.state").get_status

local utils = {}

utils.get_separator = function()
  return Path.path.sep
end

utils.cycle = function(i, n)
  return i % n == 0 and n or i % n
end

utils.get_lazy_default = function(x, defaulter, ...)
  if x == nil then
    return defaulter(...)
  else
    return x
  end
end

utils.repeated_table = function(n, val)
  local empty_lines = {}
  for _ = 1, n do
    table.insert(empty_lines, val)
  end
  return empty_lines
end

utils.filter_symbols = function(results, opts)
  local has_ignore = opts.ignore_symbols ~= nil
  local has_symbols = opts.symbols ~= nil
  local filtered_symbols

  if has_symbols and has_ignore then
    utils.notify("filter_symbols", {
      msg = "Either opts.symbols or opts.ignore_symbols, can't process opposing options at the same time!",
      level = "ERROR",
    })
    return
  elseif not (has_ignore or has_symbols) then
    return results
  elseif has_ignore then
    if type(opts.ignore_symbols) == "string" then
      opts.ignore_symbols = { opts.ignore_symbols }
    end
    if type(opts.ignore_symbols) ~= "table" then
      utils.notify("filter_symbols", {
        msg = "Please pass ignore_symbols as either a string or a list of strings",
        level = "ERROR",
      })
      return
    end

    opts.ignore_symbols = vim.tbl_map(string.lower, opts.ignore_symbols)
    filtered_symbols = vim.tbl_filter(function(item)
      return not vim.tbl_contains(opts.ignore_symbols, string.lower(item.kind))
    end, results)
  elseif has_symbols then
    if type(opts.symbols) == "string" then
      opts.symbols = { opts.symbols }
    end
    if type(opts.symbols) ~= "table" then
      utils.notify("filter_symbols", {
        msg = "Please pass filtering symbols as either a string or a list of strings",
        level = "ERROR",
      })
      return
    end

    opts.symbols = vim.tbl_map(string.lower, opts.symbols)
    filtered_symbols = vim.tbl_filter(function(item)
      return vim.tbl_contains(opts.symbols, string.lower(item.kind))
    end, results)
  end

  -- TODO(conni2461): If you understand this correctly then we sort the results table based on the bufnr
  -- If you ask me this should be its own function, that happens after the filtering part and should be
  -- called in the lsp function directly
  local current_buf = vim.api.nvim_get_current_buf()
  if not vim.tbl_isempty(filtered_symbols) then
    -- filter adequately for workspace symbols
    local filename_to_bufnr = {}
    for _, symbol in ipairs(filtered_symbols) do
      if filename_to_bufnr[symbol.filename] == nil then
        filename_to_bufnr[symbol.filename] = vim.uri_to_bufnr(vim.uri_from_fname(symbol.filename))
      end
      symbol["bufnr"] = filename_to_bufnr[symbol.filename]
    end
    table.sort(filtered_symbols, function(a, b)
      if a.bufnr == b.bufnr then
        return a.lnum < b.lnum
      end
      if a.bufnr == current_buf then
        return true
      end
      if b.bufnr == current_buf then
        return false
      end
      return a.bufnr < b.bufnr
    end)
    return filtered_symbols
  end

  -- print message that filtered_symbols is now empty
  if has_symbols then
    local symbols = table.concat(opts.symbols, ", ")
    utils.notify("filter_symbols", {
      msg = string.format("%s symbol(s) were not part of the query results", symbols),
      level = "WARN",
    })
  elseif has_ignore then
    local symbols = table.concat(opts.ignore_symbols, ", ")
    utils.notify("filter_symbols", {
      msg = string.format("%s ignore_symbol(s) have removed everything from the query result", symbols),
      level = "WARN",
    })
  end
end

utils.path_smart = (function()
  local paths = {}
  return function(filepath)
    local final = filepath
    if #paths ~= 0 then
      local dirs = vim.split(filepath, "/")
      local max = 1
      for _, p in pairs(paths) do
        if #p > 0 and p ~= filepath then
          local _dirs = vim.split(p, "/")
          for i = 1, math.min(#dirs, #_dirs) do
            if (dirs[i] ~= _dirs[i]) and i > max then
              max = i
              break
            end
          end
        end
      end
      if #dirs ~= 0 then
        if max == 1 and #dirs >= 2 then
          max = #dirs - 2
        end
        final = ""
        for k, v in pairs(dirs) do
          if k >= max - 1 then
            final = final .. (#final > 0 and "/" or "") .. v
          end
        end
      end
    end
    if not paths[filepath] then
      paths[filepath] = ""
      table.insert(paths, filepath)
    end
    if final and final ~= filepath then
      return "../" .. final
    else
      return filepath
    end
  end
end)()

utils.path_tail = (function()
  local os_sep = utils.get_separator()

  return function(path)
    for i = #path, 1, -1 do
      if path:sub(i, i) == os_sep then
        return path:sub(i + 1, -1)
      end
    end
    return path
  end
end)()

utils.is_path_hidden = function(opts, path_display)
  path_display = path_display or vim.F.if_nil(opts.path_display, require("telescope.config").values.path_display)

  return path_display == nil
    or path_display == "hidden"
    or type(path_display) == "table" and (vim.tbl_contains(path_display, "hidden") or path_display.hidden)
end

local is_uri = function(filename)
  return string.match(filename, "^%w+://") ~= nil
end

local calc_result_length = function(truncate_len)
  local status = get_status(vim.api.nvim_get_current_buf())
  local len = vim.api.nvim_win_get_width(status.results_win) - status.picker.selection_caret:len() - 2
  return type(truncate_len) == "number" and len - truncate_len or len
end

--- Transform path is a util function that formats a path based on path_display
--- found in `opts` or the default value from config.
--- It is meant to be used in make_entry to have a uniform interface for
--- builtins as well as extensions utilizing the same user configuration
--- Note: It is only supported inside `make_entry`/`make_display` the use of
--- this function outside of telescope might yield to undefined behavior and will
--- not be addressed by us
---@param opts table: The opts the users passed into the picker. Might contains a path_display key
---@param path string: The path that should be formated
---@return string: The transformed path ready to be displayed
utils.transform_path = function(opts, path)
  if path == nil then
    return
  end
  if is_uri(path) then
    return path
  end

  local path_display = vim.F.if_nil(opts.path_display, require("telescope.config").values.path_display)

  local transformed_path = path

  if type(path_display) == "function" then
    return path_display(opts, transformed_path)
  elseif utils.is_path_hidden(nil, path_display) then
    return ""
  elseif type(path_display) == "table" then
    if vim.tbl_contains(path_display, "tail") or path_display.tail then
      transformed_path = utils.path_tail(transformed_path)
    elseif vim.tbl_contains(path_display, "smart") or path_display.smart then
      transformed_path = utils.path_smart(transformed_path)
    else
      if not vim.tbl_contains(path_display, "absolute") or path_display.absolute == false then
        local cwd
        if opts.cwd then
          cwd = opts.cwd
          if not vim.in_fast_event() then
            cwd = vim.fn.expand(opts.cwd)
          end
        else
          cwd = vim.loop.cwd()
        end
        transformed_path = Path:new(transformed_path):make_relative(cwd)
      end

      if vim.tbl_contains(path_display, "shorten") or path_display["shorten"] ~= nil then
        if type(path_display["shorten"]) == "table" then
          local shorten = path_display["shorten"]
          transformed_path = Path:new(transformed_path):shorten(shorten.len, shorten.exclude)
        else
          transformed_path = Path:new(transformed_path):shorten(path_display["shorten"])
        end
      end
      if vim.tbl_contains(path_display, "truncate") or path_display.truncate then
        if opts.__length == nil then
          opts.__length = calc_result_length(path_display.truncate)
        end
        if opts.__prefix == nil then
          opts.__prefix = 0
        end
        transformed_path = truncate(transformed_path, opts.__length - opts.__prefix, nil, -1)
      end
    end

    return transformed_path
  else
    log.warn("`path_display` must be either a function or a table.", "See `:help telescope.defaults.path_display.")
    return transformed_path
  end
end

-- local x = utils.make_default_callable(function(opts)
--   return function()
--     print(opts.example, opts.another)
--   end
-- end, { example = 7, another = 5 })

-- x()
-- x.new { example = 3 }()
function utils.make_default_callable(f, default_opts)
  default_opts = default_opts or {}

  return setmetatable({
    new = function(opts)
      opts = vim.tbl_extend("keep", opts, default_opts)
      return f(opts)
    end,
  }, {
    __call = function()
      local ok, err = pcall(f(default_opts))
      if not ok then
        error(debug.traceback(err))
      end
    end,
  })
end

function utils.job_is_running(job_id)
  if job_id == nil then
    return false
  end
  return vim.fn.jobwait({ job_id }, 0)[1] == -1
end

function utils.buf_delete(bufnr)
  if bufnr == nil then
    return
  end

  -- Suppress the buffer deleted message for those with &report<2
  local start_report = vim.o.report
  if start_report < 2 then
    vim.o.report = 2
  end

  if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end

  if start_report < 2 then
    vim.o.report = start_report
  end
end

function utils.win_delete(name, win_id, force, bdelete)
  if win_id == nil or not vim.api.nvim_win_is_valid(win_id) then
    return
  end

  local bufnr = vim.api.nvim_win_get_buf(win_id)
  if bdelete then
    utils.buf_delete(bufnr)
  end

  if not vim.api.nvim_win_is_valid(win_id) then
    return
  end

  if not pcall(vim.api.nvim_win_close, win_id, force) then
    log.trace("Unable to close window: ", name, "/", win_id)
  end
end

function utils.max_split(s, pattern, maxsplit)
  pattern = pattern or " "
  maxsplit = maxsplit or -1

  local t = {}

  local curpos = 0
  while maxsplit ~= 0 and curpos < #s do
    local found, final = string.find(s, pattern, curpos, false)
    if found ~= nil then
      local val = string.sub(s, curpos, found - 1)

      if #val > 0 then
        maxsplit = maxsplit - 1
        table.insert(t, val)
      end

      curpos = final + 1
    else
      table.insert(t, string.sub(s, curpos))
      break
      -- curpos = curpos + 1
    end

    if maxsplit == 0 then
      table.insert(t, string.sub(s, curpos))
    end
  end

  return t
end

function utils.data_directory()
  local sourced_file = require("plenary.debug_utils").sourced_filepath()
  local base_directory = vim.fn.fnamemodify(sourced_file, ":h:h:h")

  return Path:new({ base_directory, "data" }):absolute() .. Path.path.sep
end

function utils.buffer_dir()
  return vim.fn.expand "%:p:h"
end

function utils.display_termcodes(str)
  return str:gsub(string.char(9), "<TAB>"):gsub("", "<C-F>"):gsub(" ", "<Space>")
end

function utils.get_os_command_output(cmd, cwd)
  if type(cmd) ~= "table" then
    utils.notify("get_os_command_output", {
      msg = "cmd has to be a table",
      level = "ERROR",
    })
    return {}
  end
  local command = table.remove(cmd, 1)
  local stderr = {}
  local stdout, ret = Job:new({
    command = command,
    args = cmd,
    cwd = cwd,
    on_stderr = function(_, data)
      table.insert(stderr, data)
    end,
  }):sync()
  return stdout, ret, stderr
end

function utils.win_set_buf_noautocmd(win, buf)
  local save_ei = vim.o.eventignore
  vim.o.eventignore = "all"
  vim.api.nvim_win_set_buf(win, buf)
  vim.o.eventignore = save_ei
end

local load_once = function(f)
  local resolved = nil
  return function(...)
    if resolved == nil then
      resolved = f()
    end

    return resolved(...)
  end
end

utils.transform_devicons = load_once(function()
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")

  if has_devicons then
    if not devicons.has_loaded() then
      devicons.setup()
    end

    return function(filename, display, disable_devicons)
      local conf = require("telescope.config").values
      if disable_devicons or not filename then
        return display
      end

      local icon, icon_highlight = devicons.get_icon(utils.path_tail(filename), nil, { default = true })
      local icon_display = (icon or " ") .. " " .. (display or "")

      if conf.color_devicons then
        return icon_display, icon_highlight
      else
        return icon_display, nil
      end
    end
  else
    return function(_, display, _)
      return display
    end
  end
end)

utils.get_devicons = load_once(function()
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")

  if has_devicons then
    if not devicons.has_loaded() then
      devicons.setup()
    end

    return function(filename, disable_devicons)
      local conf = require("telescope.config").values
      if disable_devicons or not filename then
        return ""
      end

      local icon, icon_highlight = devicons.get_icon(utils.path_tail(filename), nil, { default = true })
      if conf.color_devicons then
        return icon, icon_highlight
      else
        return icon, nil
      end
    end
  else
    return function(_, _)
      return ""
    end
  end
end)

--- Telescope Wrapper around vim.notify
---@param funname string: name of the function that will be
---@param opts table: opts.level string, opts.msg string, opts.once bool
utils.notify = function(funname, opts)
  opts.once = vim.F.if_nil(opts.once, false)
  local level = vim.log.levels[opts.level]
  if not level then
    error("Invalid error level", 2)
  end
  local notify_fn = opts.once and vim.notify_once or vim.notify
  notify_fn(string.format("[telescope.%s]: %s", funname, opts.msg), level, {
    title = "telescope.nvim",
  })
end

utils.__warn_no_selection = function(name)
  utils.notify(name, {
    msg = "Nothing currently selected",
    level = "WARN",
  })
end

return utils
