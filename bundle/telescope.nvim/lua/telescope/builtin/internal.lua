local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local Path = require "plenary.path"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local p_window = require "telescope.pickers.window"
local sorters = require "telescope.sorters"
local state = require "telescope.state"
local utils = require "telescope.utils"

local conf = require("telescope.config").values

local filter = vim.tbl_filter

-- Makes sure aliased options are set correctly
local function apply_cwd_only_aliases(opts)
  local has_cwd_only = opts.cwd_only ~= nil
  local has_only_cwd = opts.only_cwd ~= nil

  if has_only_cwd and not has_cwd_only then
    -- Internally, use cwd_only
    opts.cwd_only = opts.only_cwd
    opts.only_cwd = nil
  end

  return opts
end

local internal = {}

internal.builtin = function(opts)
  opts.include_extensions = utils.get_default(opts.include_extensions, false)

  local objs = {}

  for k, v in pairs(require "telescope.builtin") do
    local debug_info = debug.getinfo(v)
    table.insert(objs, {
      filename = string.sub(debug_info.source, 2),
      text = k,
    })
  end

  local title = "Telescope Builtin"

  if opts.include_extensions then
    title = "Telescope Pickers"
    for ext, funcs in pairs(require("telescope").extensions) do
      for func_name, func_obj in pairs(funcs) do
        -- Only include exported functions whose name doesn't begin with an underscore
        if type(func_obj) == "function" and string.sub(func_name, 0, 1) ~= "_" then
          local debug_info = debug.getinfo(func_obj)
          table.insert(objs, {
            filename = string.sub(debug_info.source, 2),
            text = string.format("%s : %s", ext, func_name),
          })
        end
      end
    end
  end

  opts.bufnr = vim.api.nvim_get_current_buf()
  opts.winnr = vim.api.nvim_get_current_win()
  pickers.new(opts, {
    prompt_title = title,
    finder = finders.new_table {
      results = objs,
      entry_maker = function(entry)
        return {
          value = entry,
          text = entry.text,
          display = entry.text,
          ordinal = entry.text,
          filename = entry.filename,
        }
      end,
    },
    previewer = previewers.builtin.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_)
      actions.select_default:replace(function(_)
        local selection = action_state.get_selected_entry()
        if not selection then
          utils.__warn_no_selection "builtin.builtin"
          return
        end

        -- we do this to avoid any surprises
        opts.include_extensions = nil

        if string.match(selection.text, " : ") then
          -- Call appropriate function from extensions
          local split_string = vim.split(selection.text, " : ")
          local ext = split_string[1]
          local func = split_string[2]
          require("telescope").extensions[ext][func](opts)
        else
          -- Call appropriate telescope builtin
          require("telescope.builtin")[selection.text](opts)
        end
      end)
      return true
    end,
  }):find()
end

internal.resume = function(opts)
  opts = opts or {}
  opts.cache_index = vim.F.if_nil(opts.cache_index, 1)

  local cached_pickers = state.get_global_key "cached_pickers"
  if cached_pickers == nil or vim.tbl_isempty(cached_pickers) then
    utils.notify("builtin.resume", {
      msg = "No cached picker(s).",
      level = "INFO",
    })
    return
  end
  local picker = cached_pickers[opts.cache_index]
  if picker == nil then
    utils.notify("builtin.resume", {
      msg = string.format("Index too large as there are only '%s' pickers cached", #cached_pickers),
      level = "ERROR",
    })
    return
  end
  -- reset layout strategy and get_window_options if default as only one is valid
  -- and otherwise unclear which was actually set
  if picker.layout_strategy == conf.layout_strategy then
    picker.layout_strategy = nil
  end
  if picker.get_window_options == p_window.get_window_options then
    picker.get_window_options = nil
  end
  picker.cache_picker.index = opts.cache_index

  -- avoid partial `opts.cache_picker` at picker creation
  if opts.cache_picker ~= false then
    picker.cache_picker = vim.tbl_extend("keep", opts.cache_picker or {}, picker.cache_picker)
  else
    picker.cache_picker.disabled = true
  end
  opts.cache_picker = nil
  pickers.new(opts, picker):find()
end

internal.pickers = function(opts)
  local cached_pickers = state.get_global_key "cached_pickers"
  if cached_pickers == nil or vim.tbl_isempty(cached_pickers) then
    utils.notify("builtin.pickers", {
      msg = "No cached picker(s).",
      level = "INFO",
    })
    return
  end

  opts = opts or {}

  -- clear cache picker for immediate pickers.new and pass option to resumed picker
  if opts.cache_picker ~= nil then
    opts._cache_picker = opts.cache_picker
    opts.cache_picker = nil
  end

  pickers.new(opts, {
    prompt_title = "Pickers",
    finder = finders.new_table {
      results = cached_pickers,
      entry_maker = make_entry.gen_from_picker(opts),
    },
    previewer = previewers.pickers.new(opts),
    sorter = conf.generic_sorter(opts),
    cache_picker = false,
    attach_mappings = function(_, map)
      actions.select_default:replace(function(prompt_bufnr)
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local selection_index = current_picker:get_index(current_picker:get_selection_row())
        actions.close(prompt_bufnr)
        opts.cache_picker = opts._cache_picker
        opts["cache_index"] = selection_index
        opts["initial_mode"] = cached_pickers[selection_index].initial_mode
        internal.resume(opts)
      end)
      map("i", "<C-x>", actions.remove_selected_picker)
      map("n", "<C-x>", actions.remove_selected_picker)
      return true
    end,
  }):find()
end

internal.planets = function(opts)
  local show_pluto = opts.show_pluto or false

  local sourced_file = require("plenary.debug_utils").sourced_filepath()
  local base_directory = vim.fn.fnamemodify(sourced_file, ":h:h:h:h")

  local globbed_files = vim.fn.globpath(base_directory .. "/data/memes/planets/", "*", true, true)
  local acceptable_files = {}
  for _, v in ipairs(globbed_files) do
    if show_pluto or not v:find "pluto" then
      table.insert(acceptable_files, vim.fn.fnamemodify(v, ":t"))
    end
  end

  pickers.new({
    prompt_title = "Planets",
    finder = finders.new_table {
      results = acceptable_files,
      entry_maker = function(line)
        return {
          ordinal = line,
          display = line,
          filename = base_directory .. "/data/memes/planets/" .. line,
        }
      end,
    },
    previewer = previewers.cat.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.planets"
          return
        end

        actions.close(prompt_bufnr)
        print("Enjoy astronomy! You viewed:", selection.display)
      end)

      return true
    end,
  }):find()
end

internal.symbols = function(opts)
  local initial_mode = vim.fn.mode()
  local files = vim.api.nvim_get_runtime_file("data/telescope-sources/*.json", true)
  local data_path = (function()
    if not opts.symbol_path then
      return Path:new { vim.fn.stdpath "data", "telescope", "symbols" }
    else
      return Path:new { opts.symbol_path }
    end
  end)()
  if data_path:exists() then
    for _, v in ipairs(require("plenary.scandir").scan_dir(data_path:absolute(), { search_pattern = "%.json$" })) do
      table.insert(files, v)
    end
  end

  if #files == 0 then
    utils.notify("builtin.symbols", {
      msg = "No sources found! Check out https://github.com/nvim-telescope/telescope-symbols.nvim "
        .. "for some prebuild symbols or how to create you own symbol source.",
      level = "ERROR",
    })
    return
  end

  local sources = {}
  if opts.sources then
    for _, v in ipairs(files) do
      for _, s in ipairs(opts.sources) do
        if v:find(s) then
          table.insert(sources, v)
        end
      end
    end
  else
    sources = files
  end

  local results = {}
  for _, source in ipairs(sources) do
    local data = vim.json.decode(Path:new(source):read())
    for _, entry in ipairs(data) do
      table.insert(results, entry)
    end
  end

  pickers.new(opts, {
    prompt_title = "Symbols",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry[1] .. " " .. entry[2],
          display = entry[1] .. " " .. entry[2],
        }
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_)
      if initial_mode == "i" then
        actions.select_default:replace(actions.insert_symbol_i)
      else
        actions.select_default:replace(actions.insert_symbol)
      end
      return true
    end,
  }):find()
end

internal.commands = function(opts)
  pickers.new(opts, {
    prompt_title = "Commands",
    finder = finders.new_table {
      results = (function()
        local command_iter = vim.api.nvim_get_commands {}
        local commands = {}

        for _, cmd in pairs(command_iter) do
          table.insert(commands, cmd)
        end

        local need_buf_command = vim.F.if_nil(opts.show_buf_command, true)

        if need_buf_command then
          local buf_command_iter = vim.api.nvim_buf_get_commands(0, {})
          buf_command_iter[true] = nil -- remove the redundant entry
          for _, cmd in pairs(buf_command_iter) do
            table.insert(commands, cmd)
          end
        end
        return commands
      end)(),

      entry_maker = opts.entry_maker or make_entry.gen_from_commands(opts),
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.commands"
          return
        end

        actions.close(prompt_bufnr)
        local val = selection.value
        local cmd = string.format([[:%s ]], val.name)

        if val.nargs == "0" then
          vim.cmd(cmd)
        else
          vim.cmd [[stopinsert]]
          vim.fn.feedkeys(cmd)
        end
      end)

      return true
    end,
  }):find()
end

internal.quickfix = function(opts)
  local qf_identifier = opts.id or vim.F.if_nil(opts.nr, "$")
  local locations = vim.fn.getqflist({ [opts.id and "id" or "nr"] = qf_identifier, items = true }).items

  if vim.tbl_isempty(locations) then
    return
  end

  pickers.new(opts, {
    prompt_title = "Quickfix",
    finder = finders.new_table {
      results = locations,
      entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
    },
    previewer = conf.qflist_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

internal.quickfixhistory = function(opts)
  local qflists = {}
  for i = 1, 10 do -- (n)vim keeps at most 10 quickfix lists in full
    -- qf weirdness: id = 0 gets id of quickfix list nr
    local qflist = vim.fn.getqflist { nr = i, id = 0, title = true, items = true }
    if not vim.tbl_isempty(qflist.items) then
      table.insert(qflists, qflist)
    end
  end
  local entry_maker = opts.make_entry
    or function(entry)
      return {
        value = entry.title or "Untitled",
        ordinal = entry.title or "Untitled",
        display = entry.title or "Untitled",
        nr = entry.nr,
        id = entry.id,
        items = entry.items,
      }
    end
  local qf_entry_maker = make_entry.gen_from_quickfix(opts)
  pickers.new(opts, {
    prompt_title = "Quickfix History",
    finder = finders.new_table {
      results = qflists,
      entry_maker = entry_maker,
    },
    previewer = previewers.new_buffer_previewer {
      title = "Quickfix List Preview",
      dyn_title = function(_, entry)
        return entry.title
      end,

      get_buffer_by_name = function(_, entry)
        return "quickfixlist_" .. tostring(entry.nr)
      end,

      define_preview = function(self, entry)
        if self.state.bufname then
          return
        end
        local entries = vim.tbl_map(function(i)
          return qf_entry_maker(i):display()
        end, entry.items)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, entries)
      end,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_, _)
      action_set.select:replace(function(prompt_bufnr)
        local nr = action_state.get_selected_entry().nr
        actions.close(prompt_bufnr)
        internal.quickfix { nr = nr }
      end)
      return true
    end,
  }):find()
end

internal.loclist = function(opts)
  local locations = vim.fn.getloclist(0)
  local filenames = {}
  for _, value in pairs(locations) do
    local bufnr = value.bufnr
    if filenames[bufnr] == nil then
      filenames[bufnr] = vim.api.nvim_buf_get_name(bufnr)
    end
    value.filename = filenames[bufnr]
  end

  if vim.tbl_isempty(locations) then
    return
  end

  pickers.new(opts, {
    prompt_title = "Loclist",
    finder = finders.new_table {
      results = locations,
      entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
    },
    previewer = conf.qflist_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

internal.oldfiles = function(opts)
  opts = apply_cwd_only_aliases(opts)
  opts.include_current_session = utils.get_default(opts.include_current_session, true)

  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buffer)
  local results = {}

  if opts.include_current_session then
    for _, buffer in ipairs(vim.split(vim.fn.execute ":buffers! t", "\n")) do
      local match = tonumber(string.match(buffer, "%s*(%d+)"))
      local open_by_lsp = string.match(buffer, "line 0$")
      if match and not open_by_lsp then
        local file = vim.api.nvim_buf_get_name(match)
        if vim.loop.fs_stat(file) and match ~= current_buffer then
          table.insert(results, file)
        end
      end
    end
  end

  for _, file in ipairs(vim.v.oldfiles) do
    if vim.loop.fs_stat(file) and not vim.tbl_contains(results, file) and file ~= current_file then
      table.insert(results, file)
    end
  end

  if opts.cwd_only then
    local cwd = vim.loop.cwd()
    cwd = cwd:gsub([[\]], [[\\]])
    results = vim.tbl_filter(function(file)
      return vim.fn.matchstrpos(file, cwd)[2] ~= -1
    end, results)
  end

  pickers.new(opts, {
    prompt_title = "Oldfiles",
    finder = finders.new_table {
      results = results,
      entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
    },
    sorter = conf.file_sorter(opts),
    previewer = conf.file_previewer(opts),
  }):find()
end

internal.command_history = function(opts)
  local history_string = vim.fn.execute "history cmd"
  local history_list = vim.split(history_string, "\n")

  local results = {}
  for i = #history_list, 3, -1 do
    local item = history_list[i]
    local _, finish = string.find(item, "%d+ +")
    table.insert(results, string.sub(item, finish + 1))
  end

  pickers.new(opts, {
    prompt_title = "Command History",
    finder = finders.new_table(results),
    sorter = conf.generic_sorter(opts),

    attach_mappings = function(_, map)
      map("i", "<CR>", actions.set_command_line)
      map("n", "<CR>", actions.set_command_line)
      map("n", "<C-e>", actions.edit_command_line)
      map("i", "<C-e>", actions.edit_command_line)

      -- TODO: Find a way to insert the text... it seems hard.
      -- map('i', '<C-i>', actions.insert_value, { expr = true })

      return true
    end,
  }):find()
end

internal.search_history = function(opts)
  local search_string = vim.fn.execute "history search"
  local search_list = vim.split(search_string, "\n")

  local results = {}
  for i = #search_list, 3, -1 do
    local item = search_list[i]
    local _, finish = string.find(item, "%d+ +")
    table.insert(results, string.sub(item, finish + 1))
  end

  pickers.new(opts, {
    prompt_title = "Search History",
    finder = finders.new_table(results),
    sorter = conf.generic_sorter(opts),

    attach_mappings = function(_, map)
      map("i", "<CR>", actions.set_search_line)
      map("n", "<CR>", actions.set_search_line)
      map("n", "<C-e>", actions.edit_search_line)
      map("i", "<C-e>", actions.edit_search_line)

      -- TODO: Find a way to insert the text... it seems hard.
      -- map('i', '<C-i>', actions.insert_value, { expr = true })

      return true
    end,
  }):find()
end

internal.vim_options = function(opts)
  -- Load vim options.
  local vim_opts = loadfile(Path:new({ utils.data_directory(), "options", "options.lua" }):absolute())().options

  pickers.new(opts, {
    prompt_title = "options",
    finder = finders.new_table {
      results = vim_opts,
      entry_maker = opts.entry_maker or make_entry.gen_from_vimoptions(opts),
    },
    -- TODO: previewer for Vim options
    -- previewer = previewers.help.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function()
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.vim_options"
          return
        end

        local esc = ""
        if vim.fn.mode() == "i" then
          -- TODO: don't make this local
          esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
        end

        -- TODO: Make this actually work.

        -- actions.close(prompt_bufnr)
        -- vim.api.nvim_win_set_var(vim.api.nvim_get_current_win(), "telescope", 1)
        -- print(prompt_bufnr)
        -- print(vim.fn.bufnr())
        -- vim.cmd([[ autocmd BufEnter <buffer> ++nested ++once startinsert!]])
        -- print(vim.fn.winheight(0))

        -- local prompt_winnr = vim.fn.getbufinfo(prompt_bufnr)[1].windows[1]
        -- print(prompt_winnr)

        -- local float_opts = {}
        -- float_opts.relative = "editor"
        -- float_opts.anchor = "sw"
        -- float_opts.focusable = false
        -- float_opts.style = "minimal"
        -- float_opts.row = vim.api.nvim_get_option("lines") - 2 -- TODO: inc `cmdheight` and `laststatus` in this calc
        -- float_opts.col = 2
        -- float_opts.height = 10
        -- float_opts.width = string.len(selection.last_set_from)+15
        -- local buf = vim.api.nvim_create_buf(false, true)
        -- vim.api.nvim_buf_set_lines(buf, 0, 0, false,
        --                           {"default value: abcdef", "last set from: " .. selection.last_set_from})
        -- local status_win = vim.api.nvim_open_win(buf, false, float_opts)
        -- -- vim.api.nvim_win_set_option(status_win, "winblend", 100)
        -- vim.api.nvim_win_set_option(status_win, "winhl", "Normal:PmenuSel")
        -- -- vim.api.nvim_set_current_win(status_win)
        -- vim.cmd[[redraw!]]
        -- vim.cmd("autocmd CmdLineLeave : ++once echom 'beep'")
        vim.api.nvim_feedkeys(string.format("%s:set %s=%s", esc, selection.name, selection.current_value), "m", true)
      end)

      return true
    end,
  }):find()
end

internal.help_tags = function(opts)
  opts.lang = utils.get_default(opts.lang, vim.o.helplang)
  opts.fallback = utils.get_default(opts.fallback, true)
  opts.file_ignore_patterns = {}

  local langs = vim.split(opts.lang, ",", true)
  if opts.fallback and not vim.tbl_contains(langs, "en") then
    table.insert(langs, "en")
  end
  local langs_map = {}
  for _, lang in ipairs(langs) do
    langs_map[lang] = true
  end

  local tag_files = {}
  local function add_tag_file(lang, file)
    if langs_map[lang] then
      if tag_files[lang] then
        table.insert(tag_files[lang], file)
      else
        tag_files[lang] = { file }
      end
    end
  end

  local help_files = {}
  local all_files = vim.api.nvim_get_runtime_file("doc/*", true)
  for _, fullpath in ipairs(all_files) do
    local file = utils.path_tail(fullpath)
    if file == "tags" then
      add_tag_file("en", fullpath)
    elseif file:match "^tags%-..$" then
      local lang = file:sub(-2)
      add_tag_file(lang, fullpath)
    else
      help_files[file] = fullpath
    end
  end

  local tags = {}
  local tags_map = {}
  local delimiter = string.char(9)
  for _, lang in ipairs(langs) do
    for _, file in ipairs(tag_files[lang] or {}) do
      local lines = vim.split(Path:new(file):read(), "\n", true)
      for _, line in ipairs(lines) do
        -- TODO: also ignore tagComment starting with ';'
        if not line:match "^!_TAG_" then
          local fields = vim.split(line, delimiter, true)
          if #fields == 3 and not tags_map[fields[1]] then
            if fields[1] ~= "help-tags" or fields[2] ~= "tags" then
              table.insert(tags, {
                name = fields[1],
                filename = help_files[fields[2]],
                cmd = fields[3],
                lang = lang,
              })
              tags_map[fields[1]] = true
            end
          end
        end
      end
    end
  end

  pickers.new(opts, {
    prompt_title = "Help",
    finder = finders.new_table {
      results = tags,
      entry_maker = function(entry)
        return {
          value = entry.name .. "@" .. entry.lang,
          display = entry.name,
          ordinal = entry.name,
          filename = entry.filename,
          cmd = entry.cmd,
        }
      end,
    },
    previewer = previewers.help.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      action_set.select:replace(function(_, cmd)
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.help_tags"
          return
        end

        actions.close(prompt_bufnr)
        if cmd == "default" or cmd == "horizontal" then
          vim.cmd("help " .. selection.value)
        elseif cmd == "vertical" then
          vim.cmd("vert help " .. selection.value)
        elseif cmd == "tab" then
          vim.cmd("tab help " .. selection.value)
        end
      end)

      return true
    end,
  }):find()
end

internal.man_pages = function(opts)
  opts.sections = utils.get_default(opts.sections, { "1" })
  assert(vim.tbl_islist(opts.sections), "sections should be a list")
  opts.man_cmd = utils.get_lazy_default(opts.man_cmd, function()
    local is_darwin = vim.loop.os_uname().sysname == "Darwin"
    return is_darwin and { "apropos", " " } or { "apropos", "" }
  end)
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_apropos(opts)
  opts.env = { PATH = vim.env.PATH, MANPATH = vim.env.MANPATH }

  pickers.new(opts, {
    prompt_title = "Man",
    finder = finders.new_oneshot_job(opts.man_cmd, opts),
    previewer = previewers.man.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      action_set.select:replace(function(_, cmd)
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.man_pages"
          return
        end

        local args = selection.section .. " " .. selection.value
        actions.close(prompt_bufnr)
        if cmd == "default" or cmd == "horizontal" then
          vim.cmd("Man " .. args)
        elseif cmd == "vertical" then
          vim.cmd("vert Man " .. args)
        elseif cmd == "tab" then
          vim.cmd("tab Man " .. args)
        end
      end)

      return true
    end,
  }):find()
end

internal.reloader = function(opts)
  local package_list = vim.tbl_keys(package.loaded)

  -- filter out packages we don't want and track the longest package name
  local column_len = 0
  for index, module_name in pairs(package_list) do
    if
      type(require(module_name)) ~= "table"
      or module_name:sub(1, 1) == "_"
      or package.searchpath(module_name, package.path) == nil
    then
      table.remove(package_list, index)
    elseif #module_name > column_len then
      column_len = #module_name
    end
  end
  opts.column_len = vim.F.if_nil(opts.column_len, column_len)

  pickers.new(opts, {
    prompt_title = "Packages",
    finder = finders.new_table {
      results = package_list,
      entry_maker = opts.entry_maker or make_entry.gen_from_packages(opts),
    },
    -- previewer = previewers.vim_buffer.new(opts),
    sorter = conf.generic_sorter(opts),

    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.reloader"
          return
        end

        actions.close(prompt_bufnr)
        require("plenary.reload").reload_module(selection.value)
        utils.notify("builtin.reloader", {
          msg = string.format("[%s] - module reloaded", selection.value),
          level = "INFO",
        })
      end)

      return true
    end,
  }):find()
end

internal.buffers = function(opts)
  opts = apply_cwd_only_aliases(opts)
  local bufnrs = filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then
      return false
    end
    -- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
    if opts.show_all_buffers == false and not vim.api.nvim_buf_is_loaded(b) then
      return false
    end
    if opts.ignore_current_buffer and b == vim.api.nvim_get_current_buf() then
      return false
    end
    if opts.cwd_only and not string.find(vim.api.nvim_buf_get_name(b), vim.loop.cwd(), 1, true) then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())
  if not next(bufnrs) then
    return
  end
  if opts.sort_mru then
    table.sort(bufnrs, function(a, b)
      return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end)
  end

  local buffers = {}
  local default_selection_idx = 1
  for _, bufnr in ipairs(bufnrs) do
    local flag = bufnr == vim.fn.bufnr "" and "%" or (bufnr == vim.fn.bufnr "#" and "#" or " ")

    if opts.sort_lastused and not opts.ignore_current_buffer and flag == "#" then
      default_selection_idx = 2
    end

    local element = {
      bufnr = bufnr,
      flag = flag,
      info = vim.fn.getbufinfo(bufnr)[1],
    }

    if opts.sort_lastused and (flag == "#" or flag == "%") then
      local idx = ((buffers[1] ~= nil and buffers[1].flag == "%") and 2 or 1)
      table.insert(buffers, idx, element)
    else
      table.insert(buffers, element)
    end
  end

  if not opts.bufnr_width then
    local max_bufnr = math.max(unpack(bufnrs))
    opts.bufnr_width = #tostring(max_bufnr)
  end

  pickers.new(opts, {
    prompt_title = "Buffers",
    finder = finders.new_table {
      results = buffers,
      entry_maker = opts.entry_maker or make_entry.gen_from_buffer(opts),
    },
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
    default_selection_index = default_selection_idx,
  }):find()
end

internal.colorscheme = function(opts)
  local before_background = vim.o.background
  local before_color = vim.api.nvim_exec("colorscheme", true)
  local need_restore = true

  local colors = opts.colors or { before_color }
  if not vim.tbl_contains(colors, before_color) then
    table.insert(colors, 1, before_color)
  end

  colors = vim.list_extend(
    colors,
    vim.tbl_filter(function(color)
      return color ~= before_color
    end, vim.fn.getcompletion("", "color"))
  )

  local previewer
  if opts.enable_preview then
    -- define previewer
    local bufnr = vim.api.nvim_get_current_buf()
    local p = vim.api.nvim_buf_get_name(bufnr)

    -- don't need previewer
    if vim.fn.buflisted(bufnr) ~= 1 then
      local deleted = false
      local function del_win(win_id)
        if win_id and vim.api.nvim_win_is_valid(win_id) then
          utils.buf_delete(vim.api.nvim_win_get_buf(win_id))
          pcall(vim.api.nvim_win_close, win_id, true)
        end
      end

      previewer = previewers.new {
        preview_fn = function(_, entry, status)
          if not deleted then
            deleted = true
            del_win(status.preview_win)
            del_win(status.preview_border_win)
          end
          vim.cmd("colorscheme " .. entry.value)
        end,
      }
    else
      -- show current buffer content in previewer
      previewer = previewers.new_buffer_previewer {
        get_buffer_by_name = function()
          return p
        end,
        define_preview = function(self, entry)
          if vim.loop.fs_stat(p) then
            conf.buffer_previewer_maker(p, self.state.bufnr, { bufname = self.state.bufname })
          else
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          end
          vim.cmd("colorscheme " .. entry.value)
        end,
      }
    end
  end

  local picker = pickers.new(opts, {
    prompt_title = "Change Colorscheme",
    finder = finders.new_table {
      results = colors,
    },
    sorter = conf.generic_sorter(opts),
    previewer = previewer,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.colorscheme"
          return
        end

        actions.close(prompt_bufnr)
        need_restore = false
        vim.cmd("colorscheme " .. selection.value)
      end)

      return true
    end,
  })

  if opts.enable_preview then
    -- rewrite picker.close_windows. restore color if needed
    local close_windows = picker.close_windows
    picker.close_windows = function(status)
      close_windows(status)
      if need_restore then
        vim.o.background = before_background
        vim.cmd("colorscheme " .. before_color)
      end
    end
  end

  picker:find()
end

internal.marks = function(opts)
  local marks = vim.api.nvim_exec("marks", true)
  local marks_table = vim.fn.split(marks, "\n")

  -- Pop off the header.
  table.remove(marks_table, 1)

  pickers.new(opts, {
    prompt_title = "Marks",
    finder = finders.new_table {
      results = marks_table,
      entry_maker = opts.entry_maker or make_entry.gen_from_marks(opts),
    },
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
    push_cursor_on_edit = true,
  }):find()
end

internal.registers = function(opts)
  local registers_table = { '"', "_", "#", "=", "_", "/", "*", "+", ":", ".", "%" }

  -- named
  for i = 0, 9 do
    table.insert(registers_table, tostring(i))
  end

  -- alphabetical
  for i = 65, 90 do
    table.insert(registers_table, string.char(i))
  end

  pickers.new(opts, {
    prompt_title = "Registers",
    finder = finders.new_table {
      results = registers_table,
      entry_maker = opts.entry_maker or make_entry.gen_from_registers(opts),
    },
    -- use levenshtein as n-gram doesn't support <2 char matches
    sorter = sorters.get_levenshtein_sorter(),
    attach_mappings = function(_, map)
      actions.select_default:replace(actions.paste_register)
      map("i", "<C-e>", actions.edit_register)

      return true
    end,
  }):find()
end

-- TODO: make filtering include the mapping and the action
internal.keymaps = function(opts)
  opts.modes = vim.F.if_nil(opts.modes, { "n", "i", "c", "x" })
  opts.show_plug = vim.F.if_nil(opts.show_plug, true)

  local keymap_encountered = {} -- used to make sure no duplicates are inserted into keymaps_table
  local keymaps_table = {}
  local max_len_lhs = 0

  -- helper function to populate keymaps_table and determine max_len_lhs
  local function extract_keymaps(keymaps)
    for _, keymap in pairs(keymaps) do
      local keymap_key = keymap.buffer .. keymap.mode .. keymap.lhs -- should be distinct for every keymap
      if not keymap_encountered[keymap_key] then
        keymap_encountered[keymap_key] = true
        if opts.show_plug or not string.find(keymap.lhs, "<Plug>") then
          table.insert(keymaps_table, keymap)
          max_len_lhs = math.max(max_len_lhs, #utils.display_termcodes(keymap.lhs))
        end
      end
    end
  end

  for _, mode in pairs(opts.modes) do
    local global = vim.api.nvim_get_keymap(mode)
    local buf_local = vim.api.nvim_buf_get_keymap(0, mode)
    extract_keymaps(global)
    extract_keymaps(buf_local)
  end
  opts.width_lhs = max_len_lhs + 1

  pickers.new(opts, {
    prompt_title = "Key Maps",
    finder = finders.new_table {
      results = keymaps_table,
      entry_maker = opts.entry_maker or make_entry.gen_from_keymaps(opts),
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.keymaps"
          return
        end

        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(selection.value.lhs, true, false, true), "t", true)
        return actions.close(prompt_bufnr)
      end)
      return true
    end,
  }):find()
end

internal.filetypes = function(opts)
  local filetypes = vim.fn.getcompletion("", "filetype")

  pickers.new(opts, {
    prompt_title = "Filetypes",
    finder = finders.new_table {
      results = filetypes,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          print "[telescope] Nothing currently selected"
          return
        end

        actions.close(prompt_bufnr)
        vim.cmd("setfiletype " .. selection[1])
      end)
      return true
    end,
  }):find()
end

internal.highlights = function(opts)
  local highlights = vim.fn.getcompletion("", "highlight")

  pickers.new(opts, {
    prompt_title = "Highlights",
    finder = finders.new_table {
      results = highlights,
      entry_maker = opts.entry_maker or make_entry.gen_from_highlights(opts),
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.highlights"
          return
        end

        actions.close(prompt_bufnr)
        vim.cmd("hi " .. selection.value)
      end)
      return true
    end,
    previewer = previewers.highlights.new(opts),
  }):find()
end

internal.autocommands = function(opts)
  local autocmd_table = {}

  local pattern = {}
  pattern.BUFFER = "<buffer=%d+>"
  pattern.EVENT = "[%a]+"
  pattern.GROUP = "[%a%d_:]+"
  pattern.INDENT = "^%s%s%s%s" -- match indentation of 4 spaces

  local event, group, ft_pat, cmd, source_file, source_lnum
  local current_event, current_group, current_ft

  local inner_loop = function(line)
    -- capture group and event
    group, event = line:match("^(" .. pattern.GROUP .. ")%s+(" .. pattern.EVENT .. ")")
    -- ..or just an event
    if event == nil then
      event = line:match("^(" .. pattern.EVENT .. ")")
    end

    if event then
      group = group or "<anonymous>"
      if event ~= current_event or group ~= current_group then
        current_event = event
        current_group = group
      end
      return
    end

    -- non event/group lines
    ft_pat = line:match(pattern.INDENT .. "(%S+)")
    if ft_pat then
      if ft_pat:match "^%d+" then
        ft_pat = "<buffer=" .. ft_pat .. ">"
      end
      current_ft = ft_pat

      -- is there a command on the same line?
      cmd = line:match(pattern.INDENT .. "%S+%s+(.+)")

      return
    end

    if current_ft and cmd == nil then
      -- trim leading spaces
      cmd = line:gsub("^%s+", "")
      return
    end

    if current_ft and cmd then
      source_file = line:match "Last set from (.*) line %d*$" or line:match "Last set from (.*)$"
      source_lnum = line:match "line (%d*)$" or "1"
      if source_file then
        local autocmd = {}
        autocmd.event = current_event
        autocmd.group = current_group
        autocmd.ft_pattern = current_ft
        autocmd.command = cmd
        autocmd.source_file = source_file
        autocmd.source_lnum = source_lnum
        table.insert(autocmd_table, autocmd)

        cmd = nil
      end
    end
  end

  local cmd_output = vim.fn.execute("verb autocmd *", "silent")
  for line in cmd_output:gmatch "[^\r\n]+" do
    inner_loop(line)
  end

  pickers.new(opts, {
    prompt_title = "autocommands",
    finder = finders.new_table {
      results = autocmd_table,
      entry_maker = opts.entry_maker or make_entry.gen_from_autocommands(opts),
    },
    previewer = previewers.autocommands.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      action_set.select:replace(function(_, type)
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.autocommands"
          return
        end

        actions.close(prompt_bufnr)
        vim.cmd(action_state.select_key_to_edit_key(type) .. " " .. selection.value)
      end)

      return true
    end,
  }):find()
end

internal.spell_suggest = function(opts)
  local cursor_word = vim.fn.expand "<cword>"
  local suggestions = vim.fn.spellsuggest(cursor_word)

  pickers.new(opts, {
    prompt_title = "Spelling Suggestions",
    finder = finders.new_table {
      results = suggestions,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.spell_suggest"
          return
        end

        actions.close(prompt_bufnr)
        vim.cmd("normal! ciw" .. selection[1])
        vim.cmd "stopinsert"
      end)
      return true
    end,
  }):find()
end

internal.tagstack = function(opts)
  opts = opts or {}
  local tagstack = vim.fn.gettagstack().items

  local tags = {}
  for i = #tagstack, 1, -1 do
    local tag = tagstack[i]
    tag.bufnr = tag.from[1]
    if vim.api.nvim_buf_is_valid(tag.bufnr) then
      tags[#tags + 1] = tag
      tag.filename = vim.fn.bufname(tag.bufnr)
      tag.lnum = tag.from[2]
      tag.col = tag.from[3]

      tag.text = vim.api.nvim_buf_get_lines(tag.bufnr, tag.lnum - 1, tag.lnum, false)[1] or ""
    end
  end

  if vim.tbl_isempty(tags) then
    utils.notify("builtin.tagstack", {
      msg = "No tagstack available",
      level = "WARN",
    })
    return
  end

  pickers.new(opts, {
    prompt_title = "TagStack",
    finder = finders.new_table {
      results = tags,
      entry_maker = make_entry.gen_from_quickfix(opts),
    },
    previewer = conf.qflist_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

internal.jumplist = function(opts)
  opts = opts or {}
  local jumplist = vim.fn.getjumplist()[1]

  -- reverse the list
  local sorted_jumplist = {}
  for i = #jumplist, 1, -1 do
    if vim.api.nvim_buf_is_valid(jumplist[i].bufnr) then
      jumplist[i].text = vim.api.nvim_buf_get_lines(jumplist[i].bufnr, jumplist[i].lnum, jumplist[i].lnum + 1, false)[1]
        or ""
      table.insert(sorted_jumplist, jumplist[i])
    end
  end

  pickers.new(opts, {
    prompt_title = "Jumplist",
    finder = finders.new_table {
      results = sorted_jumplist,
      entry_maker = make_entry.gen_from_quickfix(opts),
    },
    previewer = conf.qflist_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

local function apply_checks(mod)
  for k, v in pairs(mod) do
    mod[k] = function(opts)
      opts = opts or {}

      v(opts)
    end
  end

  return mod
end

return apply_checks(internal)
