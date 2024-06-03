local actions = require "telescope.actions"
local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local Path = require "plenary.path"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local p_window = require "telescope.pickers.window"
local state = require "telescope.state"
local utils = require "telescope.utils"

local conf = require("telescope.config").values

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

---@return boolean
local function buf_in_cwd(bufname, cwd)
  if cwd:sub(-1) ~= Path.path.sep then
    cwd = cwd .. Path.path.sep
  end
  local bufname_prefix = bufname:sub(1, #cwd)
  return bufname_prefix == cwd
end

local internal = {}

internal.builtin = function(opts)
  opts.include_extensions = vim.F.if_nil(opts.include_extensions, false)
  opts.use_default_opts = vim.F.if_nil(opts.use_default_opts, false)

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

  table.sort(objs, function(a, b)
    return a.text < b.text
  end)

  opts.bufnr = vim.api.nvim_get_current_buf()
  opts.winnr = vim.api.nvim_get_current_win()
  pickers
    .new(opts, {
      prompt_title = title,
      finder = finders.new_table {
        results = objs,
        entry_maker = function(entry)
          return make_entry.set_default_entry_mt({
            value = entry,
            text = entry.text,
            display = entry.text,
            ordinal = entry.text,
            filename = entry.filename,
          }, opts)
        end,
      },
      previewer = previewers.builtin.new(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(_)
        actions.select_default:replace(function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if not selection then
            utils.__warn_no_selection "builtin.builtin"
            return
          end

          -- we do this to avoid any surprises
          opts.include_extensions = nil

          local picker_opts
          if not opts.use_default_opts then
            picker_opts = opts
          end

          actions.close(prompt_bufnr)
          if string.match(selection.text, " : ") then
            -- Call appropriate function from extensions
            local split_string = vim.split(selection.text, " : ")
            local ext = split_string[1]
            local func = split_string[2]
            require("telescope").extensions[ext][func](picker_opts)
          else
            -- Call appropriate telescope builtin
            require("telescope.builtin")[selection.text](picker_opts)
          end
        end)
        return true
      end,
    })
    :find()
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
  picker.previewer = picker.all_previewers
  if picker.hidden_previewer then
    picker.hidden_previewer = nil
    opts.previewer = vim.F.if_nil(opts.previewer, false)
  end
  opts.resumed_picker = true
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

  pickers
    .new(opts, {
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
          local curr_picker = action_state.get_current_picker(prompt_bufnr)
          local curr_entry = action_state.get_selected_entry()
          if not curr_entry then
            return
          end

          actions.close(prompt_bufnr)

          local selection_index, _ = utils.list_find(function(v)
            if curr_entry.value == v.value then
              return true
            end
            return false
          end, curr_picker.finder.results)

          opts.cache_picker = opts._cache_picker
          opts["cache_index"] = selection_index
          opts["initial_mode"] = cached_pickers[selection_index].initial_mode
          internal.resume(opts)
        end)
        map({ "i", "n" }, "<C-x>", actions.remove_selected_picker)
        return true
      end,
    })
    :find()
end

internal.planets = function(opts)
  local show_pluto = opts.show_pluto or false
  local show_moon = opts.show_moon or false

  local sourced_file = require("plenary.debug_utils").sourced_filepath()
  local base_directory = vim.fn.fnamemodify(sourced_file, ":h:h:h:h")

  local globbed_files = vim.fn.globpath(base_directory .. "/data/memes/planets/", "*", true, true)
  local acceptable_files = {}
  for _, v in ipairs(globbed_files) do
    if (show_pluto or not v:find "pluto") and (show_moon or not v:find "moon") then
      table.insert(acceptable_files, vim.fn.fnamemodify(v, ":t"))
    end
  end

  pickers
    .new(opts, {
      prompt_title = "Planets",
      finder = finders.new_table {
        results = acceptable_files,
        entry_maker = function(line)
          return make_entry.set_default_entry_mt({
            ordinal = line,
            display = line,
            filename = base_directory .. "/data/memes/planets/" .. line,
          }, opts)
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
    })
    :find()
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

  pickers
    .new(opts, {
      prompt_title = "Symbols",
      finder = finders.new_table {
        results = results,
        entry_maker = function(entry)
          return make_entry.set_default_entry_mt({
            value = entry,
            ordinal = entry[1] .. " " .. entry[2],
            display = entry[1] .. " " .. entry[2],
          }, opts)
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
    })
    :find()
end

internal.commands = function(opts)
  pickers
    .new(opts, {
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
            local cr = vim.api.nvim_replace_termcodes("<cr>", true, false, true)
            cmd = cmd .. cr
          end
          vim.cmd [[stopinsert]]
          vim.api.nvim_feedkeys(cmd, "nt", false)
        end)

        return true
      end,
    })
    :find()
end

internal.quickfix = function(opts)
  local qf_identifier = opts.id or vim.F.if_nil(opts.nr, "$")
  local locations = vim.fn.getqflist({ [opts.id and "id" or "nr"] = qf_identifier, items = true }).items

  if vim.tbl_isempty(locations) then
    utils.notify("builtin.quickfix", { msg = "No quickfix items", level = "INFO" })
    return
  end

  pickers
    .new(opts, {
      prompt_title = "Quickfix",
      finder = finders.new_table {
        results = locations,
        entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
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
      return make_entry.set_default_entry_mt({
        value = entry.title or "Untitled",
        ordinal = entry.title or "Untitled",
        display = entry.title or "Untitled",
        nr = entry.nr,
        id = entry.id,
        items = entry.items,
      }, opts)
    end
  local qf_entry_maker = make_entry.gen_from_quickfix(opts)
  pickers
    .new(opts, {
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
    })
    :find()
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
    utils.notify("builtin.loclist", { msg = "No loclist items", level = "INFO" })
    return
  end

  pickers
    .new(opts, {
      prompt_title = "Loclist",
      finder = finders.new_table {
        results = locations,
        entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

internal.oldfiles = function(opts)
  opts = apply_cwd_only_aliases(opts)
  opts.include_current_session = vim.F.if_nil(opts.include_current_session, true)

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
    local file_stat = vim.loop.fs_stat(file)
    if file_stat and file_stat.type == "file" and not vim.tbl_contains(results, file) and file ~= current_file then
      table.insert(results, file)
    end
  end

  if opts.cwd_only or opts.cwd then
    local cwd = opts.cwd_only and vim.loop.cwd() or opts.cwd
    cwd = cwd .. utils.get_separator()
    results = vim.tbl_filter(function(file)
      return buf_in_cwd(file, cwd)
    end, results)
  end

  pickers
    .new(opts, {
      prompt_title = "Oldfiles",
      finder = finders.new_table {
        results = results,
        entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
      },
      sorter = conf.file_sorter(opts),
      previewer = conf.file_previewer(opts),
    })
    :find()
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

  pickers
    .new(opts, {
      prompt_title = "Command History",
      finder = finders.new_table(results),
      sorter = conf.generic_sorter(opts),

      attach_mappings = function(_, map)
        actions.select_default:replace(actions.set_command_line)
        map({ "i", "n" }, "<C-e>", actions.edit_command_line)

        -- TODO: Find a way to insert the text... it seems hard.
        -- map('i', '<C-i>', actions.insert_value, { expr = true })

        return true
      end,
    })
    :find()
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

  pickers
    .new(opts, {
      prompt_title = "Search History",
      finder = finders.new_table(results),
      sorter = conf.generic_sorter(opts),

      attach_mappings = function(_, map)
        actions.select_default:replace(actions.set_search_line)
        map({ "i", "n" }, "<C-e>", actions.edit_search_line)

        -- TODO: Find a way to insert the text... it seems hard.
        -- map('i', '<C-i>', actions.insert_value, { expr = true })

        return true
      end,
    })
    :find()
end

internal.vim_options = function(opts)
  local res = {}
  for _, v in pairs(vim.api.nvim_get_all_options_info()) do
    table.insert(res, v)
  end
  table.sort(res, function(left, right)
    return left.name < right.name
  end)

  pickers
    .new(opts, {
      prompt_title = "options",
      finder = finders.new_table {
        results = res,
        entry_maker = opts.entry_maker or make_entry.gen_from_vimoptions(opts),
      },
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
            esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
          end

          vim.api.nvim_feedkeys(
            string.format("%s:set %s=%s", esc, selection.value.name, selection.value.value),
            "m",
            true
          )
        end)

        return true
      end,
    })
    :find()
end

internal.help_tags = function(opts)
  opts.lang = vim.F.if_nil(opts.lang, vim.o.helplang)
  opts.fallback = vim.F.if_nil(opts.fallback, true)
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

  pickers
    .new(opts, {
      prompt_title = "Help",
      finder = finders.new_table {
        results = tags,
        entry_maker = function(entry)
          return make_entry.set_default_entry_mt({
            value = entry.name .. "@" .. entry.lang,
            display = entry.name,
            ordinal = entry.name,
            filename = entry.filename,
            cmd = entry.cmd,
          }, opts)
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
    })
    :find()
end

internal.man_pages = function(opts)
  opts.sections = vim.F.if_nil(opts.sections, { "1" })
  assert(utils.islist(opts.sections), "sections should be a list")
  opts.man_cmd = utils.get_lazy_default(opts.man_cmd, function()
    local uname = vim.loop.os_uname()
    local sysname = string.lower(uname.sysname)
    if sysname == "darwin" then
      local major_version = tonumber(vim.fn.matchlist(uname.release, [[^\(\d\+\)\..*]])[2]) or 0
      return major_version >= 22 and { "apropos", "." } or { "apropos", " " }
    elseif sysname == "freebsd" then
      return { "apropos", "." }
    else
      return { "apropos", "" }
    end
  end)
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_apropos(opts)
  opts.env = { PATH = vim.env.PATH, MANPATH = vim.env.MANPATH }

  pickers
    .new(opts, {
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
    })
    :find()
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

  pickers
    .new(opts, {
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
    })
    :find()
end

internal.buffers = function(opts)
  opts = apply_cwd_only_aliases(opts)

  local bufnrs = vim.tbl_filter(function(bufnr)
    if 1 ~= vim.fn.buflisted(bufnr) then
      return false
    end
    -- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
    if opts.show_all_buffers == false and not vim.api.nvim_buf_is_loaded(bufnr) then
      return false
    end
    if opts.ignore_current_buffer and bufnr == vim.api.nvim_get_current_buf() then
      return false
    end

    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if opts.cwd_only and not buf_in_cwd(bufname, vim.loop.cwd()) then
      return false
    end
    if not opts.cwd_only and opts.cwd and not buf_in_cwd(bufname, opts.cwd) then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())

  if not next(bufnrs) then
    utils.notify("builtin.buffers", { msg = "No buffers found with the provided options", level = "INFO" })
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

  pickers
    .new(opts, {
      prompt_title = "Buffers",
      finder = finders.new_table {
        results = buffers,
        entry_maker = opts.entry_maker or make_entry.gen_from_buffer(opts),
      },
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      default_selection_index = default_selection_idx,
    })
    :find()
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
      return not vim.tbl_contains(colors, color)
    end, vim.fn.getcompletion("", "color"))
  )

  local previewer
  if opts.enable_preview then
    -- define previewer
    local bufnr = vim.api.nvim_get_current_buf()
    local p = vim.api.nvim_buf_get_name(bufnr)

    -- show current buffer content in previewer
    previewer = previewers.new_buffer_previewer {
      get_buffer_by_name = function()
        return p
      end,
      define_preview = function(self)
        if vim.loop.fs_stat(p) then
          conf.buffer_previewer_maker(p, self.state.bufnr, { bufname = self.state.bufname })
        else
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end
      end,
    }
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
      action_set.shift_selection:enhance {
        post = function()
          local selection = action_state.get_selected_entry()
          if selection == nil then
            utils.__warn_no_selection "builtin.colorscheme"
            return
          end
          need_restore = true
          if opts.enable_preview then
            vim.cmd.colorscheme(selection.value)
          end
        end,
      }
      actions.close:enhance {
        post = function()
          if need_restore then
            vim.cmd.colorscheme(before_color)
          end
        end,
      }
      return true
    end,
    on_complete = {
      function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "builtin.colorscheme"
          return
        end
        need_restore = true
        vim.cmd.colorscheme(selection.value)
      end,
    },
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
  local local_marks = {
    items = vim.fn.getmarklist(opts.bufnr),
    name_func = function(_, line)
      return vim.api.nvim_buf_get_lines(opts.bufnr, line - 1, line, false)[1]
    end,
  }
  local global_marks = {
    items = vim.fn.getmarklist(),
    name_func = function(mark, _)
      -- get buffer name if it is opened, otherwise get file name
      return vim.api.nvim_get_mark(mark, {})[4]
    end,
  }
  local marks_table = {}
  local marks_others = {}
  local bufname = vim.api.nvim_buf_get_name(opts.bufnr)
  for _, cnf in ipairs { local_marks, global_marks } do
    for _, v in ipairs(cnf.items) do
      -- strip the first single quote character
      local mark = string.sub(v.mark, 2, 3)
      local _, lnum, col, _ = unpack(v.pos)
      local name = cnf.name_func(mark, lnum)
      -- same format to :marks command
      local line = string.format("%s %6d %4d %s", mark, lnum, col - 1, name)
      local row = {
        line = line,
        lnum = lnum,
        col = col,
        filename = utils.path_expand(v.file or bufname),
      }
      -- non alphanumeric marks goes to last
      if mark:match "%w" then
        table.insert(marks_table, row)
      else
        table.insert(marks_others, row)
      end
    end
  end
  marks_table = vim.fn.extend(marks_table, marks_others)

  pickers
    .new(opts, {
      prompt_title = "Marks",
      finder = finders.new_table {
        results = marks_table,
        entry_maker = opts.entry_maker or make_entry.gen_from_marks(opts),
      },
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      push_cursor_on_edit = true,
      push_tagstack_on_edit = true,
    })
    :find()
end

internal.registers = function(opts)
  local registers_table = { '"', "-", "#", "=", "/", "*", "+", ":", ".", "%" }

  -- named
  for i = 0, 9 do
    table.insert(registers_table, tostring(i))
  end

  -- alphabetical
  for i = 65, 90 do
    table.insert(registers_table, string.char(i))
  end

  pickers
    .new(opts, {
      prompt_title = "Registers",
      finder = finders.new_table {
        results = registers_table,
        entry_maker = opts.entry_maker or make_entry.gen_from_registers(opts),
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(_, map)
        actions.select_default:replace(actions.paste_register)
        map({ "i", "n" }, "<C-e>", actions.edit_register)

        return true
      end,
    })
    :find()
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

  pickers
    .new(opts, {
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
    })
    :find()
end

internal.filetypes = function(opts)
  local filetypes = vim.fn.getcompletion("", "filetype")

  pickers
    .new(opts, {
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
    })
    :find()
end

internal.highlights = function(opts)
  local highlights = vim.fn.getcompletion("", "highlight")

  pickers
    .new(opts, {
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
    })
    :find()
end

internal.autocommands = function(opts)
  local autocmds = vim.api.nvim_get_autocmds {}
  table.sort(autocmds, function(lhs, rhs)
    return lhs.event < rhs.event
  end)
  pickers
    .new(opts, {
      prompt_title = "autocommands",
      finder = finders.new_table {
        results = autocmds,
        entry_maker = opts.entry_maker or make_entry.gen_from_autocommands(opts),
      },
      previewer = previewers.autocommands.new(opts),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        action_set.select:replace_if(function()
          local selection = action_state.get_selected_entry()
          if selection == nil then
            return false
          end
          local val = selection.value
          local group_name = val.group_name ~= "<anonymous>" and val.group_name or ""
          local output =
            vim.fn.execute("verb autocmd " .. group_name .. " " .. val.event .. " " .. val.pattern, "silent")
          for line in output:gmatch "[^\r\n]+" do
            local source_file = line:match "Last set from (.*) line %d*$" or line:match "Last set from (.*)$"
            if source_file and source_file ~= "Lua" then
              selection.filename = source_file
              local source_lnum = line:match "line (%d*)$" or "1"
              selection.lnum = tonumber(source_lnum)
              selection.col = 1
              return false
            end
          end
          return true
        end, function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          print("You selected autocmd: " .. vim.inspect(selection.value))
        end)

        return true
      end,
    })
    :find()
end

internal.spell_suggest = function(opts)
  local cursor_word = vim.fn.expand "<cword>"
  local suggestions = vim.fn.spellsuggest(cursor_word)

  pickers
    .new(opts, {
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

          action_state.get_current_picker(prompt_bufnr)._original_mode = "i"
          actions.close(prompt_bufnr)
          vim.cmd('normal! "_ciw' .. selection[1])
          vim.cmd "stopinsert"
        end)
        return true
      end,
    })
    :find()
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

  pickers
    .new(opts, {
      prompt_title = "TagStack",
      finder = finders.new_table {
        results = tags,
        entry_maker = make_entry.gen_from_quickfix(opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

internal.jumplist = function(opts)
  opts = opts or {}
  local jumplist = vim.fn.getjumplist()[1]

  -- reverse the list
  local sorted_jumplist = {}
  for i = #jumplist, 1, -1 do
    if vim.api.nvim_buf_is_valid(jumplist[i].bufnr) then
      jumplist[i].text = vim.api.nvim_buf_get_lines(jumplist[i].bufnr, jumplist[i].lnum - 1, jumplist[i].lnum, false)[1]
        or ""
      table.insert(sorted_jumplist, jumplist[i])
    end
  end

  pickers
    .new(opts, {
      prompt_title = "Jumplist",
      finder = finders.new_table {
        results = sorted_jumplist,
        entry_maker = make_entry.gen_from_quickfix(opts),
      },
      previewer = conf.qflist_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
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
