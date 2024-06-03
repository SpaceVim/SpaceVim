---@tag telescope.make_entry

---@brief [[
---
--- Each picker has a finder made up of two parts, the results which are the
--- data to be displayed, and the entry_maker. These entry_makers are functions
--- returned from make_entry functions. These will be referred to as
--- entry_makers in the following documentation.
---
--- Every entry maker returns a function that accepts the data to be used for
--- an entry. This function will return an entry table (or nil, meaning skip
--- this entry) which contains the following important keys:
--- - value any: value key can be anything but still required
--- - valid bool (optional): is an optional key because it defaults to true but if the key
---   is set to false it will not be displayed by the picker
--- - ordinal string: is the text that is used for filtering
--- - display string|function: is either a string of the text that is being
---   displayed or a function receiving the entry at a later stage, when the entry
---   is actually being displayed. A function can be useful here if a complex
---   calculation has to be done. `make_entry` can also return a second value -
---   a highlight array which will then apply to the line. Highlight entry in
---   this array has the following signature `{ { start_col, end_col }, hl_group }`
--- - filename string (optional): will be interpreted by the default `<cr>` action as
---   open this file
--- - bufnr number (optional): will be interpreted by the default `<cr>` action as open
---   this buffer
--- - lnum number (optional): lnum value which will be interpreted by the default `<cr>`
---   action as a jump to this line
--- - col number (optional): col value which will be interpreted by the default `<cr>`
---   action as a jump to this column
---
--- For more information on easier displaying, see |telescope.pickers.entry_display|
---
--- TODO: Document something we call `entry_index`
---@brief ]]

local entry_display = require "telescope.pickers.entry_display"
local utils = require "telescope.utils"
local strings = require "plenary.strings"
local Path = require "plenary.path"

local treesitter_type_highlight = {
  ["associated"] = "TSConstant",
  ["constant"] = "TSConstant",
  ["field"] = "TSField",
  ["function"] = "TSFunction",
  ["method"] = "TSMethod",
  ["parameter"] = "TSParameter",
  ["property"] = "TSProperty",
  ["struct"] = "Struct",
  ["var"] = "TSVariableBuiltin",
}

local lsp_type_highlight = {
  ["Class"] = "TelescopeResultsClass",
  ["Constant"] = "TelescopeResultsConstant",
  ["Field"] = "TelescopeResultsField",
  ["Function"] = "TelescopeResultsFunction",
  ["Method"] = "TelescopeResultsMethod",
  ["Property"] = "TelescopeResultsOperator",
  ["Struct"] = "TelescopeResultsStruct",
  ["Variable"] = "TelescopeResultsVariable",
}

local get_filename_fn = function()
  local bufnr_name_cache = {}
  return function(bufnr)
    bufnr = vim.F.if_nil(bufnr, 0)
    local c = bufnr_name_cache[bufnr]
    if c then
      return c
    end

    local n = vim.api.nvim_buf_get_name(bufnr)
    bufnr_name_cache[bufnr] = n
    return n
  end
end

local handle_entry_index = function(opts, t, k)
  local override = ((opts or {}).entry_index or {})[k]
  if not override then
    return
  end

  local val, save = override(t, opts)
  if save then
    rawset(t, k, val)
  end
  return val
end

local make_entry = {}

make_entry.set_default_entry_mt = function(tbl, opts)
  return setmetatable({}, {
    __index = function(t, k)
      local override = handle_entry_index(opts, t, k)
      if override then
        return override
      end

      -- Only hit tbl once
      local val = tbl[k]
      if val then
        rawset(t, k, val)
      end

      return val
    end,
  })
end

do
  local lookup_keys = {
    display = 1,
    ordinal = 1,
    value = 1,
  }

  function make_entry.gen_from_string(opts)
    local mt_string_entry = {
      __index = function(t, k)
        local override = handle_entry_index(opts, t, k)
        if override then
          return override
        end

        return rawget(t, rawget(lookup_keys, k))
      end,
    }

    return function(line)
      return setmetatable({
        line,
      }, mt_string_entry)
    end
  end
end

do
  local lookup_keys = {
    ordinal = 1,
    value = 1,
    filename = 1,
    cwd = 2,
  }

  function make_entry.gen_from_file(opts)
    opts = opts or {}

    local cwd = utils.path_expand(opts.cwd or vim.loop.cwd())

    local disable_devicons = opts.disable_devicons

    local mt_file_entry = {}

    mt_file_entry.cwd = cwd
    mt_file_entry.display = function(entry)
      local hl_group, icon
      local display = utils.transform_path(opts, entry.value)

      display, hl_group, icon = utils.transform_devicons(entry.value, display, disable_devicons)

      if hl_group then
        return display, { { { 0, #icon }, hl_group } }
      else
        return display
      end
    end

    mt_file_entry.__index = function(t, k)
      local override = handle_entry_index(opts, t, k)
      if override then
        return override
      end

      local raw = rawget(mt_file_entry, k)
      if raw then
        return raw
      end

      if k == "path" then
        local retpath = Path:new({ t.cwd, t.value }):absolute()
        if not vim.loop.fs_access(retpath, "R", nil) then
          retpath = t.value
        end
        return retpath
      end

      return rawget(t, rawget(lookup_keys, k))
    end

    return function(line)
      return setmetatable({ line }, mt_file_entry)
    end
  end
end

do
  local lookup_keys = {
    value = 1,
    ordinal = 1,
  }

  -- Gets called only once to parse everything out for the vimgrep, after that looks up directly.
  local parse_with_col = function(t)
    local _, _, filename, lnum, col, text = string.find(t.value, [[(..-):(%d+):(%d+):(.*)]])

    local ok
    ok, lnum = pcall(tonumber, lnum)
    if not ok then
      lnum = nil
    end

    ok, col = pcall(tonumber, col)
    if not ok then
      col = nil
    end

    t.filename = filename
    t.lnum = lnum
    t.col = col
    t.text = text

    return { filename, lnum, col, text }
  end

  local parse_without_col = function(t)
    local _, _, filename, lnum, text = string.find(t.value, [[(..-):(%d+):(.*)]])

    local ok
    ok, lnum = pcall(tonumber, lnum)
    if not ok then
      lnum = nil
    end

    t.filename = filename
    t.lnum = lnum
    t.col = nil
    t.text = text

    return { filename, lnum, nil, text }
  end

  local parse_only_filename = function(t)
    t.filename = t.value
    t.lnum = nil
    t.col = nil
    t.text = ""

    return { t.filename, nil, nil, "" }
  end

  function make_entry.gen_from_vimgrep(opts)
    opts = opts or {}

    local mt_vimgrep_entry
    local parse = parse_with_col
    if opts.__matches == true then
      parse = parse_only_filename
    elseif opts.__inverted == true then
      parse = parse_without_col
    end

    local disable_devicons = opts.disable_devicons
    local disable_coordinates = opts.disable_coordinates
    local only_sort_text = opts.only_sort_text

    local execute_keys = {
      path = function(t)
        if Path:new(t.filename):is_absolute() then
          return t.filename, false
        else
          return Path:new({ t.cwd, t.filename }):absolute(), false
        end
      end,

      filename = function(t)
        return parse(t)[1], true
      end,

      lnum = function(t)
        return parse(t)[2], true
      end,

      col = function(t)
        return parse(t)[3], true
      end,

      text = function(t)
        return parse(t)[4], true
      end,
    }

    -- For text search only, the ordinal value is actually the text.
    if only_sort_text then
      execute_keys.ordinal = function(t)
        return t.text
      end
    end

    local display_string = "%s%s%s"

    mt_vimgrep_entry = {
      cwd = utils.path_expand(opts.cwd or vim.loop.cwd()),

      display = function(entry)
        local display_filename = utils.transform_path(opts, entry.filename)

        local coordinates = ":"
        if not disable_coordinates then
          if entry.lnum then
            if entry.col then
              coordinates = string.format(":%s:%s:", entry.lnum, entry.col)
            else
              coordinates = string.format(":%s:", entry.lnum)
            end
          end
        end

        local display, hl_group, icon = utils.transform_devicons(
          entry.filename,
          string.format(display_string, display_filename, coordinates, entry.text),
          disable_devicons
        )

        if hl_group then
          return display, { { { 0, #icon }, hl_group } }
        else
          return display
        end
      end,

      __index = function(t, k)
        local override = handle_entry_index(opts, t, k)
        if override then
          return override
        end

        local raw = rawget(mt_vimgrep_entry, k)
        if raw then
          return raw
        end

        local executor = rawget(execute_keys, k)
        if executor then
          local val, save = executor(t)
          if save then
            rawset(t, k, val)
          end
          return val
        end

        return rawget(t, rawget(lookup_keys, k))
      end,
    }

    return function(line)
      return setmetatable({ line }, mt_vimgrep_entry)
    end
  end
end

function make_entry.gen_from_git_stash(opts)
  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 10 },
      opts.show_branch and { width = 15 } or "",
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.value, "TelescopeResultsLineNr" },
      opts.show_branch and { entry.branch_name, "TelescopeResultsIdentifier" } or "",
      entry.commit_info,
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local splitted = utils.max_split(entry, ": ", 2)
    local stash_idx = splitted[1]
    local _, branch_name = string.match(splitted[2], "^([WIP on|On]+) (.+)")
    local commit_info = splitted[3]

    return make_entry.set_default_entry_mt({
      value = stash_idx,
      ordinal = commit_info,
      branch_name = branch_name,
      commit_info = commit_info,
      display = make_display,
    }, opts)
  end
end

function make_entry.gen_from_git_commits(opts)
  opts = opts or {}

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 8 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.value, "TelescopeResultsIdentifier" },
      entry.msg,
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local sha, msg = string.match(entry, "([^ ]+) (.+)")

    if not msg then
      sha = entry
      msg = "<empty commit message>"
    end

    return make_entry.set_default_entry_mt({
      value = sha,
      ordinal = sha .. " " .. msg,
      msg = msg,
      display = make_display,
      current_file = opts.current_file,
    }, opts)
  end
end

function make_entry.gen_from_quickfix(opts)
  opts = opts or {}
  local show_line = vim.F.if_nil(opts.show_line, true)

  local hidden = utils.is_path_hidden(opts)
  local items = {
    { width = vim.F.if_nil(opts.fname_width, 30) },
    { remaining = true },
  }
  if hidden then
    items[1] = { width = 8 }
  end
  if not show_line then
    table.remove(items, 1)
  end

  local displayer = entry_display.create { separator = "▏", items = items }

  local make_display = function(entry)
    local input = {}
    if not hidden then
      table.insert(input, string.format("%s:%d:%d", utils.transform_path(opts, entry.filename), entry.lnum, entry.col))
    else
      table.insert(input, string.format("%4d:%2d", entry.lnum, entry.col))
    end

    if show_line then
      local text = entry.text
      if opts.trim_text then
        text = text:gsub("^%s*(.-)%s*$", "%1")
      end
      text = text:gsub(".* | ", "")
      table.insert(input, text)
    end

    return displayer(input)
  end

  local get_filename = get_filename_fn()
  return function(entry)
    local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))

    return make_entry.set_default_entry_mt({
      value = entry,
      ordinal = (not hidden and filename or "") .. " " .. entry.text,
      display = make_display,

      bufnr = entry.bufnr,
      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
      start = entry.start,
      finish = entry.finish,
    }, opts)
  end
end

function make_entry.gen_from_lsp_symbols(opts)
  opts = opts or {}

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  -- Default we have two columns, symbol and type(unbound)
  -- If path is not hidden then its, filepath, symbol and type(still unbound)
  -- If show_line is also set, type is bound to len 8
  local display_items = {
    { width = opts.symbol_width or 25 },
    { remaining = true },
  }

  local hidden = utils.is_path_hidden(opts)
  if not hidden then
    table.insert(display_items, 1, { width = vim.F.if_nil(opts.fname_width, 30) })
  end

  if opts.show_line then
    -- bound type to len 8 or custom
    table.insert(display_items, #display_items, { width = opts.symbol_type_width or 8 })
  end

  local displayer = entry_display.create {
    separator = " ",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = display_items,
  }
  local type_highlight = vim.F.if_nil(opts.symbol_highlights or lsp_type_highlight)

  local make_display = function(entry)
    local msg

    if opts.show_line then
      msg = vim.trim(vim.F.if_nil(vim.api.nvim_buf_get_lines(bufnr, entry.lnum - 1, entry.lnum, false)[1], ""))
    end

    if hidden then
      return displayer {
        entry.symbol_name,
        { entry.symbol_type:lower(), type_highlight[entry.symbol_type] },
        msg,
      }
    else
      return displayer {
        utils.transform_path(opts, entry.filename),
        entry.symbol_name,
        { entry.symbol_type:lower(), type_highlight[entry.symbol_type] },
        msg,
      }
    end
  end

  local get_filename = get_filename_fn()
  return function(entry)
    local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))
    local symbol_msg = entry.text
    local symbol_type, symbol_name = symbol_msg:match "%[(.+)%]%s+(.*)"
    local ordinal = ""
    if not hidden and filename then
      ordinal = filename .. " "
    end
    ordinal = ordinal .. symbol_name .. " " .. (symbol_type or "unknown")
    return make_entry.set_default_entry_mt({
      value = entry,
      ordinal = ordinal,
      display = make_display,

      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      symbol_name = symbol_name,
      symbol_type = symbol_type,
      start = entry.start,
      finish = entry.finish,
    }, opts)
  end
end

function make_entry.gen_from_buffer(opts)
  opts = opts or {}

  local disable_devicons = opts.disable_devicons

  local icon_width = 0
  if not disable_devicons then
    local icon, _ = utils.get_devicons("fname", disable_devicons)
    icon_width = strings.strdisplaywidth(icon)
  end

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = opts.bufnr_width },
      { width = 4 },
      { width = icon_width },
      { remaining = true },
    },
  }

  local cwd = utils.path_expand(opts.cwd or vim.loop.cwd())

  local make_display = function(entry)
    -- bufnr_width + modes + icon + 3 spaces + : + lnum
    opts.__prefix = opts.bufnr_width + 4 + icon_width + 3 + 1 + #tostring(entry.lnum)
    local display_bufname = utils.transform_path(opts, entry.filename)
    local icon, hl_group = utils.get_devicons(entry.filename, disable_devicons)

    return displayer {
      { entry.bufnr, "TelescopeResultsNumber" },
      { entry.indicator, "TelescopeResultsComment" },
      { icon, hl_group },
      display_bufname .. ":" .. entry.lnum,
    }
  end

  return function(entry)
    local filename = entry.info.name ~= "" and entry.info.name or nil
    local bufname = filename and Path:new(filename):normalize(cwd) or "[No Name]"

    local hidden = entry.info.hidden == 1 and "h" or "a"
    local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
    local changed = entry.info.changed == 1 and "+" or " "
    local indicator = entry.flag .. hidden .. readonly .. changed
    local lnum = 1

    -- account for potentially stale lnum as getbufinfo might not be updated or from resuming buffers picker
    if entry.info.lnum ~= 0 then
      -- but make sure the buffer is loaded, otherwise line_count is 0
      if vim.api.nvim_buf_is_loaded(entry.bufnr) then
        local line_count = vim.api.nvim_buf_line_count(entry.bufnr)
        lnum = math.max(math.min(entry.info.lnum, line_count), 1)
      else
        lnum = entry.info.lnum
      end
    end

    return make_entry.set_default_entry_mt({
      value = bufname,
      ordinal = entry.bufnr .. " : " .. bufname,
      display = make_display,
      bufnr = entry.bufnr,
      path = filename,
      filename = bufname,
      lnum = lnum,
      indicator = indicator,
    }, opts)
  end
end

function make_entry.gen_from_treesitter(opts)
  opts = opts or {}

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  local display_items = {
    { width = 25 },
    { width = 10 },
    { remaining = true },
  }

  if opts.show_line then
    table.insert(display_items, 2, { width = 6 })
  end

  local displayer = entry_display.create {
    separator = " ",
    items = display_items,
  }

  local type_highlight = opts.symbol_highlights or treesitter_type_highlight

  local make_display = function(entry)
    local msg = vim.api.nvim_buf_get_lines(bufnr, entry.lnum, entry.lnum, false)[1] or ""
    msg = vim.trim(msg)

    local display_columns = {
      entry.text,
      { entry.kind, type_highlight[entry.kind], type_highlight[entry.kind] },
      msg,
    }
    if opts.show_line then
      table.insert(display_columns, 2, { entry.lnum .. ":" .. entry.col, "TelescopeResultsLineNr" })
    end

    return displayer(display_columns)
  end

  local get_filename = get_filename_fn()
  return function(entry)
    local start_row, start_col, end_row, _ = vim.treesitter.get_node_range(entry.node)
    local node_text = vim.treesitter.get_node_text(entry.node, bufnr)
    return make_entry.set_default_entry_mt({
      value = entry.node,
      kind = entry.kind,
      ordinal = node_text .. " " .. (entry.kind or "unknown"),
      display = make_display,

      node_text = node_text,

      filename = get_filename(bufnr),
      -- need to add one since the previewer substacts one
      lnum = start_row + 1,
      col = start_col,
      text = node_text,
      start = start_row,
      finish = end_row,
    }, opts)
  end
end

function make_entry.gen_from_packages(opts)
  opts = opts or {}

  local make_display = function(module_name)
    local p_path = package.searchpath(module_name, package.path) or ""
    local display = string.format("%-" .. opts.column_len .. "s : %s", module_name, vim.fn.fnamemodify(p_path, ":~:."))

    return display
  end

  return function(module_name)
    return make_entry.set_default_entry_mt({
      valid = module_name ~= "",
      value = module_name,
      ordinal = module_name,
      display = make_display(module_name),
    }, opts)
  end
end

function make_entry.gen_from_apropos(opts)
  local sections = {}
  if #opts.sections == 1 and opts.sections[1] == "ALL" then
    setmetatable(sections, {
      __index = function()
        return true
      end,
    })
  else
    for _, section in ipairs(opts.sections) do
      sections[section] = true
    end
  end

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 30 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.keyword, "TelescopeResultsFunction" },
      entry.description,
    }
  end

  return function(line)
    local keyword, cmd, section, desc = line:match "^((.-)%s*%(([^)]+)%).-)%s+%-%s+(.*)$"
    -- apropos might return alternatives for the cmd which are split on `,` and breaks everything else
    -- for example on void linux it will return `alacritty, Alacritty` which will later result in
    -- `man 1 alacritty, Alacritty`. So we just take the first one.
    -- doing this outside of regex because of obvious reasons
    cmd = vim.split(cmd, ",")[1]
    return keyword
        and sections[section]
        and make_entry.set_default_entry_mt({
          value = cmd,
          description = desc,
          ordinal = cmd,
          display = make_display,
          section = section,
          keyword = keyword,
        }, opts)
      or nil
  end
end

function make_entry.gen_from_marks(opts)
  return function(item)
    return make_entry.set_default_entry_mt({
      value = item.line,
      ordinal = item.line,
      display = item.line,
      lnum = item.lnum,
      col = item.col,
      start = item.lnum,
      filename = item.filename,
    }, opts)
  end
end

function make_entry.gen_from_registers(opts)
  local displayer = entry_display.create {
    separator = " ",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = {
      { width = 3 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    local content = entry.content
    return displayer {
      { "[" .. entry.value .. "]", "TelescopeResultsNumber" },
      type(content) == "string" and content:gsub("\n", "\\n") or content,
    }
  end

  return function(entry)
    local contents = vim.fn.getreg(entry, 1)
    return make_entry.set_default_entry_mt({
      value = entry,
      ordinal = string.format("%s %s", entry, contents),
      content = contents,
      display = make_display,
    }, opts)
  end
end

function make_entry.gen_from_keymaps(opts)
  local function get_desc(entry)
    if entry.callback and not entry.desc then
      return require("telescope.actions.utils")._get_anon_function_name(debug.getinfo(entry.callback))
    end
    return vim.F.if_nil(entry.desc, entry.rhs):gsub("\n", "\\n")
  end

  local function get_lhs(entry)
    return utils.display_termcodes(entry.lhs)
  end

  local displayer = require("telescope.pickers.entry_display").create {
    separator = "▏",
    items = {
      { width = 2 },
      { width = opts.width_lhs },
      { remaining = true },
    },
  }
  local make_display = function(entry)
    return displayer {
      entry.mode,
      get_lhs(entry),
      get_desc(entry),
    }
  end

  return function(entry)
    local desc = get_desc(entry)
    local lhs = get_lhs(entry)
    return make_entry.set_default_entry_mt({
      mode = entry.mode,
      lhs = lhs,
      desc = desc,
      valid = entry ~= "",
      value = entry,
      ordinal = entry.mode .. " " .. lhs .. " " .. desc,
      display = make_display,
    }, opts)
  end
end

function make_entry.gen_from_highlights(opts)
  local make_display = function(entry)
    local display = entry.value
    return display, { { { 0, #display }, display } }
  end

  return function(entry)
    return make_entry.set_default_entry_mt({
      value = entry,
      display = make_display,
      ordinal = entry,
    }, opts)
  end
end

function make_entry.gen_from_picker(opts)
  local displayer = entry_display.create {
    separator = " │ ",
    items = {
      { width = 0.5 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      entry.value.prompt_title,
      entry.value.default_text,
    }
  end

  return function(entry)
    return make_entry.set_default_entry_mt({
      value = entry,
      text = entry.prompt_title,
      ordinal = string.format("%s %s", entry.prompt_title, vim.F.if_nil(entry.default_text, "")),
      display = make_display,
    }, opts)
  end
end

function make_entry.gen_from_buffer_lines(opts)
  local displayer = entry_display.create {
    separator = " │ ",
    items = {
      { width = 5 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.lnum, opts.lnum_highlight_group or "TelescopeResultsSpecialComment" },
      {
        entry.text,
        function()
          if not opts.line_highlights then
            return {}
          end

          local line_hl = opts.line_highlights[entry.lnum] or {}
          -- TODO: We could probably squash these together if the are the same...
          --        But I don't think that it's worth it at the moment.
          local result = {}

          for col, hl in pairs(line_hl) do
            table.insert(result, { { col, col + 1 }, hl })
          end

          return result
        end,
      },
    }
  end

  return function(entry)
    if opts.skip_empty_lines and string.match(entry.text, "^$") then
      return
    end

    return make_entry.set_default_entry_mt({
      ordinal = entry.text,
      display = make_display,
      filename = entry.filename,
      lnum = entry.lnum,
      text = entry.text,
    }, opts)
  end
end

function make_entry.gen_from_vimoptions(opts)
  local displayer = entry_display.create {
    separator = "",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = {
      { width = 25 },
      { width = 12 },
      { width = 11 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.value.name, "Keyword" },
      { "[" .. entry.value.type .. "]", "Type" },
      { "[" .. entry.value.scope .. "]", "Identifier" },
      utils.display_termcodes(tostring(entry.value.value)),
    }
  end

  return function(o)
    local entry = {
      display = make_display,
      value = {
        name = o.name,
        value = o.default,
        type = o.type,
        scope = o.scope,
      },
      ordinal = string.format("%s %s %s", o.name, o.type, o.scope),
    }

    local ok, value = pcall(vim.api.nvim_get_option, o.name)
    if ok then
      entry.value.value = value
      entry.ordinal = entry.ordinal .. " " .. utils.display_termcodes(tostring(value))
    else
      entry.ordinal = entry.ordinal .. " " .. utils.display_termcodes(tostring(o.default))
    end

    return make_entry.set_default_entry_mt(entry, opts)
  end
end

function make_entry.gen_from_ctags(opts)
  opts = opts or {}

  local cwd = utils.path_expand(opts.cwd or vim.loop.cwd())
  local current_file = Path:new(vim.api.nvim_buf_get_name(opts.bufnr)):normalize(cwd)

  local display_items = {
    { remaining = true },
  }

  local idx = 1
  local hidden = utils.is_path_hidden(opts)
  if not hidden then
    table.insert(display_items, idx, { width = vim.F.if_nil(opts.fname_width, 30) })
    idx = idx + 1
  end

  if opts.show_line then
    table.insert(display_items, idx, { width = 30 })
  end

  local displayer = entry_display.create {
    separator = " │ ",
    items = display_items,
  }

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)

    local scode
    if opts.show_line then
      scode = entry.scode
    end

    if hidden then
      return displayer {
        entry.tag,
        scode,
      }
    else
      return displayer {
        filename,
        entry.tag,
        scode,
      }
    end
  end

  local mt = {}
  mt.__index = function(t, k)
    local override = handle_entry_index(opts, t, k)
    if override then
      return override
    end

    if k == "path" then
      local retpath = Path:new({ t.filename }):absolute()
      if not vim.loop.fs_access(retpath, "R", nil) then
        retpath = t.filename
      end
      return retpath
    end
  end

  local current_file_cache = {}
  return function(line)
    if line == "" or line:sub(1, 1) == "!" then
      return nil
    end

    local tag, file, scode, lnum
    -- ctags gives us: 'tags\tfile\tsource'
    tag, file, scode = string.match(line, '([^\t]+)\t([^\t]+)\t/^?\t?(.*)/;"\t+.*')
    if not tag then
      -- hasktags gives us: 'tags\tfile\tlnum'
      tag, file, lnum = string.match(line, "([^\t]+)\t([^\t]+)\t(%d+).*")
    end

    if Path.path.sep == "\\" then
      file = string.gsub(file, "/", "\\")
    end

    if opts.only_current_file then
      if current_file_cache[file] == nil then
        current_file_cache[file] = Path:new(file):normalize(cwd) == current_file
      end

      if current_file_cache[file] == false then
        return nil
      end
    end

    local tag_entry = {}
    if opts.only_sort_tags then
      tag_entry.ordinal = tag
    else
      tag_entry.ordinal = file .. ": " .. tag
    end

    tag_entry.display = make_display
    tag_entry.scode = scode
    tag_entry.tag = tag
    tag_entry.filename = file
    tag_entry.col = 1
    tag_entry.lnum = lnum and tonumber(lnum) or 1

    return setmetatable(tag_entry, mt)
  end
end

function make_entry.gen_from_diagnostics(opts)
  opts = opts or {}

  local signs = (function()
    if opts.no_sign then
      return
    end
    local signs = {}
    local type_diagnostic = vim.diagnostic.severity
    for _, severity in ipairs(type_diagnostic) do
      local status, sign = pcall(function()
        -- only the first char is upper all others are lowercalse
        return vim.trim(vim.fn.sign_getdefined("DiagnosticSign" .. severity:lower():gsub("^%l", string.upper))[1].text)
      end)
      if not status then
        sign = severity:sub(1, 1)
      end
      signs[severity] = sign
    end
    return signs
  end)()

  local display_items = {
    { width = signs ~= nil and 10 or 8 },
    { remaining = true },
  }
  local line_width = vim.F.if_nil(opts.line_width, 0.5)
  local hidden = utils.is_path_hidden(opts)
  if not hidden then
    table.insert(display_items, 2, { width = line_width })
  end
  local displayer = entry_display.create {
    separator = "▏",
    items = display_items,
  }

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)

    -- add styling of entries
    local pos = string.format("%4d:%2d", entry.lnum, entry.col)
    local line_info = {
      (signs and signs[entry.type] .. " " or "") .. pos,
      "DiagnosticSign" .. entry.type,
    }

    return displayer {
      line_info,
      entry.text,
      filename,
    }
  end

  return function(entry)
    return make_entry.set_default_entry_mt({
      value = entry,
      ordinal = ("%s %s"):format(not hidden and entry.filename or "", entry.text),
      display = make_display,
      filename = entry.filename,
      type = entry.type,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
    }, opts)
  end
end

function make_entry.gen_from_autocommands(opts)
  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 14 },
      { width = 18 },
      { width = 16 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.value.event, "vimAutoEvent" },
      { entry.value.group_name, "vimAugroup" },
      { entry.value.pattern, "vimAutoCmdSfxList" },
      entry.value.command,
    }
  end

  return function(entry)
    local group_name = vim.F.if_nil(entry.group_name, "<anonymous>")
    local command = entry.command
    if entry.desc and (entry.callback or vim.startswith(command, "<lua: ")) then
      command = entry.desc
    end
    if command == nil or command == "" then
      command = "<lua function>"
    end
    return make_entry.set_default_entry_mt({
      value = {
        event = entry.event,
        group_name = group_name,
        pattern = entry.pattern,
        command = command,
      },
      --
      ordinal = entry.event .. " " .. group_name .. " " .. entry.pattern .. " " .. entry.command,
      display = make_display,
    }, opts)
  end
end

function make_entry.gen_from_commands(opts)
  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 0.2 },
      { width = 4 },
      { width = 4 },
      { width = 11 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    local attrs = ""
    if entry.bang then
      attrs = attrs .. "!"
    end
    if entry.bar then
      attrs = attrs .. "|"
    end
    if entry.register then
      attrs = attrs .. '"'
    end
    return displayer {
      { entry.name, "TelescopeResultsIdentifier" },
      attrs,
      entry.nargs,
      entry.complete or "",
      entry.definition:gsub("\n", " "),
    }
  end

  return function(entry)
    return make_entry.set_default_entry_mt({
      name = entry.name,
      bang = entry.bang,
      nargs = entry.nargs,
      complete = entry.complete,
      definition = entry.definition,
      --
      value = entry,
      ordinal = entry.name,
      display = make_display,
    }, opts)
  end
end

local git_icon_defaults = {
  added = "+",
  changed = "~",
  copied = ">",
  deleted = "-",
  renamed = "➡",
  unmerged = "‡",
  untracked = "?",
}

function make_entry.gen_from_git_status(opts)
  opts = opts or {}

  local col_width = ((opts.git_icons and opts.git_icons.added) and opts.git_icons.added:len() + 2) or 2
  local displayer = entry_display.create {
    separator = "",
    items = {
      { width = col_width },
      { width = col_width },
      { remaining = true },
    },
  }

  local icons = vim.tbl_extend("keep", opts.git_icons or {}, git_icon_defaults)

  local git_abbrev = {
    ["A"] = { icon = icons.added, hl = "TelescopeResultsDiffAdd" },
    ["U"] = { icon = icons.unmerged, hl = "TelescopeResultsDiffAdd" },
    ["M"] = { icon = icons.changed, hl = "TelescopeResultsDiffChange" },
    ["C"] = { icon = icons.copied, hl = "TelescopeResultsDiffChange" },
    ["R"] = { icon = icons.renamed, hl = "TelescopeResultsDiffChange" },
    ["D"] = { icon = icons.deleted, hl = "TelescopeResultsDiffDelete" },
    ["?"] = { icon = icons.untracked, hl = "TelescopeResultsDiffUntracked" },
  }

  local make_display = function(entry)
    local x = string.sub(entry.status, 1, 1)
    local y = string.sub(entry.status, -1)
    local status_x = git_abbrev[x] or {}
    local status_y = git_abbrev[y] or {}

    local empty_space = " "
    return displayer {
      { status_x.icon or empty_space, status_x.hl },
      { status_y.icon or empty_space, status_y.hl },
      utils.transform_path(opts, entry.path),
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local mod, file = entry:match "^(..) (.+)$"
    -- Ignore entries that are the PATH in XY ORIG_PATH PATH
    -- (renamed or copied files)
    if not mod then
      return nil
    end

    return setmetatable({
      value = file,
      status = mod,
      ordinal = entry,
      display = make_display,
      path = Path:new({ opts.cwd, file }):absolute(),
    }, opts)
  end
end

return make_entry
