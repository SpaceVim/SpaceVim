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

local make_entry = {}

do
  local lookup_keys = {
    display = 1,
    ordinal = 1,
    value = 1,
  }

  local mt_string_entry = {
    __index = function(t, k)
      return rawget(t, rawget(lookup_keys, k))
    end,
  }

  function make_entry.gen_from_string()
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

    local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

    local disable_devicons = opts.disable_devicons

    local mt_file_entry = {}

    mt_file_entry.cwd = cwd
    mt_file_entry.display = function(entry)
      local hl_group
      local display = utils.transform_path(opts, entry.value)

      display, hl_group = utils.transform_devicons(entry.value, display, disable_devicons)

      if hl_group then
        return display, { { { 1, 3 }, hl_group } }
      else
        return display
      end
    end

    mt_file_entry.__index = function(t, k)
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
  local parse = function(t)
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

  --- Special options:
  ---  - disable_coordinates: Don't show the line & row numbers
  ---  - only_sort_text: Only sort via the text. Ignore filename and other items
  function make_entry.gen_from_vimgrep(opts)
    local mt_vimgrep_entry

    opts = opts or {}

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

    local display_string = "%s:%s%s"

    mt_vimgrep_entry = {
      cwd = vim.fn.expand(opts.cwd or vim.loop.cwd()),

      display = function(entry)
        local display_filename = utils.transform_path(opts, entry.filename)

        local coordinates = ""
        if not disable_coordinates then
          coordinates = string.format("%s:%s:", entry.lnum, entry.col)
        end

        local display, hl_group = utils.transform_devicons(
          entry.filename,
          string.format(display_string, display_filename, coordinates, entry.text),
          disable_devicons
        )

        if hl_group then
          return display, { { { 1, 3 }, hl_group } }
        else
          return display
        end
      end,

      __index = function(t, k)
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

    return {
      value = stash_idx,
      ordinal = commit_info,
      branch_name = branch_name,
      commit_info = commit_info,
      display = make_display,
    }
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

    return {
      value = sha,
      ordinal = sha .. " " .. msg,
      msg = msg,
      display = make_display,
      current_file = opts.current_file,
    }
  end
end

function make_entry.gen_from_quickfix(opts)
  opts = opts or {}

  local displayer = entry_display.create {
    separator = "▏",
    items = {
      { width = 8 },
      { width = 0.45 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)

    local line_info = { table.concat({ entry.lnum, entry.col }, ":"), "TelescopeResultsLineNr" }

    if opts.trim_text then
      entry.text = entry.text:gsub("^%s*(.-)%s*$", "%1")
    end

    return displayer {
      line_info,
      entry.text:gsub(".* | ", ""),
      filename,
    }
  end

  return function(entry)
    local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)

    return {
      valid = true,

      value = entry,
      ordinal = (not opts.ignore_filename and filename or "") .. " " .. entry.text,
      display = make_display,

      bufnr = entry.bufnr,
      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
      start = entry.start,
      finish = entry.finish,
    }
  end
end

function make_entry.gen_from_lsp_symbols(opts)
  opts = opts or {}

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  local display_items = {
    { width = opts.symbol_width or 25 }, -- symbol
    { width = opts.symbol_type_width or 8 }, -- symbol type
    { remaining = true }, -- filename{:optional_lnum+col} OR content preview
  }

  if opts.ignore_filename and opts.show_line then
    table.insert(display_items, 2, { width = 6 })
  end

  local displayer = entry_display.create {
    separator = " ",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = display_items,
  }

  local make_display = function(entry)
    local msg

    -- what to show in the last column: filename or symbol information
    if opts.ignore_filename then -- ignore the filename and show line preview instead
      -- TODO: fixme - if ignore_filename is set for workspace, bufnr will be incorrect
      msg = vim.api.nvim_buf_get_lines(bufnr, entry.lnum - 1, entry.lnum, false)[1] or ""
      msg = vim.trim(msg)
    else
      local filename = utils.transform_path(opts, entry.filename)

      if opts.show_line then -- show inline line info
        filename = filename .. " [" .. entry.lnum .. ":" .. entry.col .. "]"
      end
      msg = filename
    end

    local type_highlight = opts.symbol_highlights or lsp_type_highlight
    local display_columns = {
      entry.symbol_name,
      { entry.symbol_type:lower(), type_highlight[entry.symbol_type], type_highlight[entry.symbol_type] },
      msg,
    }

    if opts.ignore_filename and opts.show_line then
      table.insert(display_columns, 2, { entry.lnum .. ":" .. entry.col, "TelescopeResultsLineNr" })
    end

    return displayer(display_columns)
  end

  return function(entry)
    local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)
    local symbol_msg = entry.text
    local symbol_type, symbol_name = symbol_msg:match "%[(.+)%]%s+(.*)"

    local ordinal = ""
    if not opts.ignore_filename and filename then
      ordinal = filename .. " "
    end
    ordinal = ordinal .. symbol_name .. " " .. (symbol_type or "unknown")
    return {
      valid = true,

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
    }
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

  local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

  local make_display = function(entry)
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
    local bufname = entry.info.name ~= "" and entry.info.name or "[No Name]"
    -- if bufname is inside the cwd, trim that part of the string
    bufname = Path:new(bufname):normalize(cwd)

    local hidden = entry.info.hidden == 1 and "h" or "a"
    local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
    local changed = entry.info.changed == 1 and "+" or " "
    local indicator = entry.flag .. hidden .. readonly .. changed
    local line_count = vim.api.nvim_buf_line_count(entry.bufnr)

    return {
      valid = true,

      value = bufname,
      ordinal = entry.bufnr .. " : " .. bufname,
      display = make_display,

      bufnr = entry.bufnr,
      filename = bufname,
      -- account for potentially stale lnum as getbufinfo might not be updated or from resuming buffers picker
      lnum = entry.info.lnum ~= 0 and math.max(math.min(entry.info.lnum, line_count), 1) or 1,
      indicator = indicator,
    }
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

  return function(entry)
    local ts_utils = require "nvim-treesitter.ts_utils"
    local start_row, start_col, end_row, _ = ts_utils.get_node_range(entry.node)
    local node_text = vim.treesitter.get_node_text(entry.node, bufnr)
    return {
      valid = true,

      value = entry.node,
      kind = entry.kind,
      ordinal = node_text .. " " .. (entry.kind or "unknown"),
      display = make_display,

      node_text = node_text,

      filename = vim.api.nvim_buf_get_name(bufnr),
      -- need to add one since the previewer substacts one
      lnum = start_row + 1,
      col = start_col,
      text = node_text,
      start = start_row,
      finish = end_row,
    }
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
    local entry = {
      valid = module_name ~= "",
      value = module_name,
      ordinal = module_name,
    }
    entry.display = make_display(module_name)

    return entry
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
        and {
          value = cmd,
          description = desc,
          ordinal = cmd,
          display = make_display,
          section = section,
          keyword = keyword,
        }
      or nil
  end
end

function make_entry.gen_from_marks(_)
  return function(line)
    local split_value = utils.max_split(line, "%s+", 4)

    local mark_value = split_value[1]
    local cursor_position = vim.fn.getpos("'" .. mark_value)

    return {
      value = line,
      ordinal = line,
      display = line,
      lnum = cursor_position[2],
      col = cursor_position[3],
      start = cursor_position[2],
      filename = vim.api.nvim_buf_get_name(cursor_position[1]),
    }
  end
end

function make_entry.gen_from_registers(_)
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
    return {
      valid = true,
      value = entry,
      ordinal = entry,
      content = vim.fn.getreg(entry),
      display = make_display,
    }
  end
end

function make_entry.gen_from_keymaps(opts)
  local function get_desc(entry)
    if entry.callback and not entry.desc then
      return require("telescope.actions.utils")._get_anon_function_name(entry.callback)
    end
    return vim.F.if_nil(entry.desc, entry.rhs)
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
    return {
      mode = entry.mode,
      lhs = get_lhs(entry),
      desc = get_desc(entry),
      --
      valid = entry ~= "",
      value = entry,
      ordinal = entry.mode .. " " .. get_lhs(entry) .. " " .. get_desc(entry),
      display = make_display,
    }
  end
end

function make_entry.gen_from_highlights()
  local make_display = function(entry)
    local display = entry.value
    return display, { { { 0, #display }, display } }
  end

  return function(entry)
    return {
      value = entry,
      display = make_display,
      ordinal = entry,
    }
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
    return {
      value = entry,
      text = entry.prompt_title,
      ordinal = string.format("%s %s", entry.prompt_title, utils.get_default(entry.default_text, "")),
      display = make_display,
    }
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

    return {
      valid = true,
      ordinal = entry.text,
      display = make_display,
      filename = entry.filename,
      lnum = entry.lnum,
      text = entry.text,
    }
  end
end

function make_entry.gen_from_vimoptions()
  local process_one_opt = function(o)
    local ok, value_origin

    local option = {
      name = "",
      description = "",
      current_value = "",
      default_value = "",
      value_type = "",
      set_by_user = false,
      last_set_from = "",
    }

    local is_global = false
    for _, v in ipairs(o.scope) do
      if v == "global" then
        is_global = true
      end
    end

    if not is_global then
      return
    end

    if is_global then
      option.name = o.full_name

      ok, option.current_value = pcall(vim.api.nvim_get_option, o.full_name)
      if not ok then
        return
      end

      local str_funcname = o.short_desc()
      option.description = assert(loadstring(str_funcname))()
      -- if #option.description > opts.desc_col_length then
      --   opts.desc_col_length = #option.description
      -- end

      if o.defaults ~= nil then
        option.default_value = o.defaults.if_true.vim or o.defaults.if_true.vi
      end

      if type(option.default_value) == "function" then
        option.default_value = "Macro: " .. option.default_value()
      end

      option.value_type = (type(option.current_value) == "boolean" and "bool" or type(option.current_value))

      if option.current_value ~= option.default_value then
        option.set_by_user = true
        value_origin = vim.fn.execute("verbose set " .. o.full_name .. "?")
        if string.match(value_origin, "Last set from") then
          -- TODO: parse file and line number as separate items
          option.last_set_from = value_origin:gsub("^.*Last set from ", "")
        end
      end

      return option
    end
  end

  local displayer = entry_display.create {
    separator = "",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = {
      { width = 25 },
      { width = 12 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.name, "Keyword" },
      { "[" .. entry.value_type .. "]", "Type" },
      utils.display_termcodes(tostring(entry.current_value)),
      entry.description,
    }
  end

  return function(line)
    local entry = process_one_opt(line)
    if not entry then
      return
    end

    entry.valid = true
    entry.display = make_display
    entry.value = line
    entry.ordinal = line.full_name
    -- entry.raw_value = d.raw_value
    -- entry.last_set_from = d.last_set_from

    return entry
  end
end

--- Special options:
---  - only_sort_tags: Only sort via tag name. Ignore filename and other items
function make_entry.gen_from_ctags(opts)
  opts = opts or {}

  local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())
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
    if k == "path" then
      local retpath = Path:new({ t.filename }):absolute()
      if not vim.loop.fs_access(retpath, "R", nil) then
        retpath = t.filename
      end
      return retpath
    end
  end

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

    if opts.only_current_file and file ~= current_file then
      return nil
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
    { width = utils.if_nil(signs, 8, 10) },
    { remaining = true },
  }
  local line_width = vim.F.if_nil(opts.line_width, 0.5)
  if not utils.is_path_hidden(opts) then
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
      "Diagnostic" .. entry.type,
    }

    --TODO(conni2461): I dont like that this is symbol lnum:col | msg | filename
    --                 i want: symbol filename:lnum:col | msg
    --                 or    : symbol lnum:col | msg
    --                 I think this is more natural
    return displayer {
      line_info,
      entry.text,
      filename,
    }
  end

  return function(entry)
    return {
      value = entry,
      ordinal = ("%s %s"):format(not opts.ignore_filename and entry.filename or "", entry.text),
      display = make_display,
      filename = entry.filename,
      type = entry.type,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
    }
  end
end

function make_entry.gen_from_autocommands(_)
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
      { entry.event, "vimAutoEvent" },
      { entry.group, "vimAugroup" },
      { entry.ft_pattern, "vimAutoCmdSfxList" },
      entry.command,
    }
  end

  -- TODO: <action> dump current filtered items to buffer
  return function(entry)
    return {
      event = entry.event,
      group = entry.group,
      ft_pattern = entry.ft_pattern,
      command = entry.command,
      value = string.format("+%d %s", entry.source_lnum, entry.source_file),
      source_file = entry.source_file,
      source_lnum = entry.source_lnum,
      --
      valid = true,
      ordinal = entry.event .. " " .. entry.group .. " " .. entry.ft_pattern .. " " .. entry.command,
      display = make_display,
    }
  end
end

function make_entry.gen_from_commands(_)
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
      entry.definition,
    }
  end

  return function(entry)
    return {
      name = entry.name,
      bang = entry.bang,
      nargs = entry.nargs,
      complete = entry.complete,
      definition = entry.definition,
      --
      value = entry,
      valid = true,
      ordinal = entry.name,
      display = make_display,
    }
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
      entry.value,
    }
  end

  return function(entry)
    if entry == "" then
      return nil
    end
    local mod, file = string.match(entry, "(..).*%s[->%s]?(.+)")

    return {
      value = file,
      status = mod,
      ordinal = entry,
      display = make_display,
      path = Path:new({ opts.cwd, file }):absolute(),
    }
  end
end

return make_entry
