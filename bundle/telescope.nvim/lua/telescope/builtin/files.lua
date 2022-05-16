local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"
local utils = require "telescope.utils"
local conf = require("telescope.config").values
local log = require "telescope.log"

local Path = require "plenary.path"

local flatten = vim.tbl_flatten
local filter = vim.tbl_filter

local files = {}

local escape_chars = function(string)
  return string.gsub(string, "[%(|%)|\\|%[|%]|%-|%{%}|%?|%+|%*|%^|%$|%.]", {
    ["\\"] = "\\\\",
    ["-"] = "\\-",
    ["("] = "\\(",
    [")"] = "\\)",
    ["["] = "\\[",
    ["]"] = "\\]",
    ["{"] = "\\{",
    ["}"] = "\\}",
    ["?"] = "\\?",
    ["+"] = "\\+",
    ["*"] = "\\*",
    ["^"] = "\\^",
    ["$"] = "\\$",
    ["."] = "\\.",
  })
end

-- Special keys:
--  opts.search_dirs -- list of directory to search in
--  opts.grep_open_files -- boolean to restrict search to open files
files.live_grep = function(opts)
  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  local search_dirs = opts.search_dirs
  local grep_open_files = opts.grep_open_files
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()

  local filelist = {}

  if grep_open_files then
    local bufnrs = filter(function(b)
      if 1 ~= vim.fn.buflisted(b) then
        return false
      end
      return true
    end, vim.api.nvim_list_bufs())
    if not next(bufnrs) then
      return
    end

    for _, bufnr in ipairs(bufnrs) do
      local file = vim.api.nvim_buf_get_name(bufnr)
      table.insert(filelist, Path:new(file):make_relative(opts.cwd))
    end
  elseif search_dirs then
    for i, path in ipairs(search_dirs) do
      search_dirs[i] = vim.fn.expand(path)
    end
  end

  local additional_args = {}
  if opts.additional_args ~= nil and type(opts.additional_args) == "function" then
    additional_args = opts.additional_args(opts)
  end

  if opts.type_filter then
    additional_args[#additional_args + 1] = "--type=" .. opts.type_filter
  end

  if opts.glob_pattern then
    additional_args[#additional_args + 1] = "--glob=" .. opts.glob_pattern
  end

  local live_grepper = finders.new_job(function(prompt)
    -- TODO: Probably could add some options for smart case and whatever else rg offers.

    if not prompt or prompt == "" then
      return nil
    end

    local search_list = {}

    if search_dirs then
      table.insert(search_list, search_dirs)
    end

    if grep_open_files then
      search_list = filelist
    end

    return flatten { vimgrep_arguments, additional_args, "--", prompt, search_list }
  end, opts.entry_maker or make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

  pickers.new(opts, {
    prompt_title = "Live Grep",
    finder = live_grepper,
    previewer = conf.grep_previewer(opts),
    -- TODO: It would be cool to use `--json` output for this
    -- and then we could get the highlight positions directly.
    sorter = sorters.highlighter_only(opts),
  }):find()
end

-- Special keys:
--  opts.search -- the string to search.
--  opts.search_dirs -- list of directory to search in
--  opts.use_regex -- special characters won't be escaped
files.grep_string = function(opts)
  -- TODO: This should probably check your visual selection as well, if you've got one

  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  local search_dirs = opts.search_dirs
  local word = opts.search or vim.fn.expand "<cword>"
  local search = opts.use_regex and word or escape_chars(word)
  local word_match = opts.word_match
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)

  local additional_args = {}
  if opts.additional_args ~= nil and type(opts.additional_args) == "function" then
    additional_args = opts.additional_args(opts)
  end

  local args = flatten {
    vimgrep_arguments,
    additional_args,
    word_match,
    "--",
    search,
  }

  if search_dirs then
    for _, path in ipairs(search_dirs) do
      table.insert(args, vim.fn.expand(path))
    end
  end

  pickers.new(opts, {
    prompt_title = "Find Word (" .. word .. ")",
    finder = finders.new_oneshot_job(args, opts),
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- TODO: Maybe just change this to `find`.
-- TODO: Support `find` and maybe let people do other stuff with it as well.
files.find_files = function(opts)
  local find_command = (function()
    if opts.find_command then
      return opts.find_command
    elseif 1 == vim.fn.executable "fd" then
      return { "fd", "--type", "f" }
    elseif 1 == vim.fn.executable "fdfind" then
      return { "fdfind", "--type", "f" }
    elseif 1 == vim.fn.executable "rg" then
      return { "rg", "--files" }
    elseif 1 == vim.fn.executable "find" and vim.fn.has "win32" == 0 then
      return { "find", ".", "-type", "f" }
    elseif 1 == vim.fn.executable "where" then
      return { "where", "/r", ".", "*" }
    end
  end)()

  if not find_command then
    utils.notify("builtin.find_files", {
      msg = "You need to install either find, fd, or rg",
      level = "ERROR",
    })
    return
  end

  local command = find_command[1]
  local hidden = opts.hidden
  local no_ignore = opts.no_ignore
  local follow = opts.follow
  local search_dirs = opts.search_dirs

  if search_dirs then
    for k, v in pairs(search_dirs) do
      search_dirs[k] = vim.fn.expand(v)
    end
  end

  if command == "fd" or command == "fdfind" or command == "rg" then
    if hidden then
      table.insert(find_command, "--hidden")
    end
    if no_ignore then
      table.insert(find_command, "--no-ignore")
    end
    if follow then
      table.insert(find_command, "-L")
    end
    if search_dirs then
      if command ~= "rg" then
        table.insert(find_command, ".")
      end
      for _, v in pairs(search_dirs) do
        table.insert(find_command, v)
      end
    end
  elseif command == "find" then
    if not hidden then
      table.insert(find_command, { "-not", "-path", "*/.*" })
      find_command = flatten(find_command)
    end
    if no_ignore ~= nil then
      log.warn "The `no_ignore` key is not available for the `find` command in `find_files`."
    end
    if follow then
      table.insert(find_command, 2, "-L")
    end
    if search_dirs then
      table.remove(find_command, 2)
      for _, v in pairs(search_dirs) do
        table.insert(find_command, 2, v)
      end
    end
  elseif command == "where" then
    if hidden ~= nil then
      log.warn "The `hidden` key is not available for the Windows `where` command in `find_files`."
    end
    if no_ignore ~= nil then
      log.warn "The `no_ignore` key is not available for the Windows `where` command in `find_files`."
    end
    if follow ~= nil then
      log.warn "The `follow` key is not available for the Windows `where` command in `find_files`."
    end
    if search_dirs ~= nil then
      log.warn "The `search_dirs` key is not available for the Windows `where` command in `find_files`."
    end
  end

  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  end

  opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

  pickers.new(opts, {
    prompt_title = "Find Files",
    finder = finders.new_oneshot_job(find_command, opts),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

local function prepare_match(entry, kind)
  local entries = {}

  if entry.node then
    table.insert(entries, entry)
  else
    for name, item in pairs(entry) do
      vim.list_extend(entries, prepare_match(item, name))
    end
  end

  return entries
end

--  TODO: finish docs for opts.show_line
files.treesitter = function(opts)
  opts.show_line = utils.get_default(opts.show_line, true)

  local has_nvim_treesitter, _ = pcall(require, "nvim-treesitter")
  if not has_nvim_treesitter then
    utils.notify("builtin.treesitter", {
      msg = "User need to install nvim-treesitter needs to be installed",
      level = "ERROR",
    })
    return
  end

  local parsers = require "nvim-treesitter.parsers"
  if not parsers.has_parser(parsers.get_buf_lang(opts.bufnr)) then
    utils.notify("builtin.treesitter", {
      msg = "No parser for the current buffer",
      level = "ERROR",
    })
    return
  end

  local ts_locals = require "nvim-treesitter.locals"
  local results = {}
  for _, definition in ipairs(ts_locals.get_definitions(opts.bufnr)) do
    local entries = prepare_match(ts_locals.get_local_nodes(definition))
    for _, entry in ipairs(entries) do
      entry.kind = vim.F.if_nil(entry.kind, "")
      table.insert(results, entry)
    end
  end

  if vim.tbl_isempty(results) then
    return
  end

  pickers.new(opts, {
    prompt_title = "Treesitter Symbols",
    finder = finders.new_table {
      results = results,
      entry_maker = opts.entry_maker or make_entry.gen_from_treesitter(opts),
    },
    previewer = conf.grep_previewer(opts),
    sorter = conf.prefilter_sorter {
      tag = "kind",
      sorter = conf.generic_sorter(opts),
    },
  }):find()
end

files.current_buffer_fuzzy_find = function(opts)
  -- All actions are on the current buffer
  local filename = vim.fn.expand(vim.api.nvim_buf_get_name(opts.bufnr))
  local filetype = vim.api.nvim_buf_get_option(opts.bufnr, "filetype")

  local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
  local lines_with_numbers = {}

  for lnum, line in ipairs(lines) do
    table.insert(lines_with_numbers, {
      lnum = lnum,
      bufnr = opts.bufnr,
      filename = filename,
      text = line,
    })
  end

  local ts_ok, ts_parsers = pcall(require, "nvim-treesitter.parsers")
  if ts_ok then
    filetype = ts_parsers.ft_to_lang(filetype)
  end
  local _, ts_configs = pcall(require, "nvim-treesitter.configs")

  local parser_ok, parser = pcall(vim.treesitter.get_parser, opts.bufnr, filetype)
  local query_ok, query = pcall(vim.treesitter.get_query, filetype, "highlights")
  if parser_ok and query_ok and ts_ok and ts_configs.is_enabled("highlight", filetype, opts.bufnr) then
    local root = parser:parse()[1]:root()

    local highlighter = vim.treesitter.highlighter.new(parser)
    local highlighter_query = highlighter:get_query(filetype)

    local line_highlights = setmetatable({}, {
      __index = function(t, k)
        local obj = {}
        rawset(t, k, obj)
        return obj
      end,
    })
    for id, node in query:iter_captures(root, opts.bufnr, 0, -1) do
      local hl = highlighter_query:_get_hl_from_capture(id)
      if hl and type(hl) ~= "number" then
        local row1, col1, row2, col2 = node:range()

        if row1 == row2 then
          local row = row1 + 1

          for index = col1, col2 do
            line_highlights[row][index] = hl
          end
        else
          local row = row1 + 1
          for index = col1, #lines[row] do
            line_highlights[row][index] = hl
          end

          while row < row2 + 1 do
            row = row + 1

            for index = 0, #(lines[row] or {}) do
              line_highlights[row][index] = hl
            end
          end
        end
      end
    end

    opts.line_highlights = line_highlights
  end

  pickers.new(opts, {
    prompt_title = "Current Buffer Fuzzy",
    finder = finders.new_table {
      results = lines_with_numbers,
      entry_maker = opts.entry_maker or make_entry.gen_from_buffer_lines(opts),
    },
    sorter = conf.generic_sorter(opts),
    previewer = conf.grep_previewer(opts),
    attach_mappings = function()
      action_set.select:enhance {
        post = function()
          local selection = action_state.get_selected_entry()
          vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
        end,
      }

      return true
    end,
  }):find()
end

files.tags = function(opts)
  local tagfiles = opts.ctags_file and { opts.ctags_file } or vim.fn.tagfiles()
  if vim.tbl_isempty(tagfiles) then
    utils.notify("builtin.tags", {
      msg = "No tags file found. Create one with ctags -R",
      level = "ERROR",
    })
    return
  end

  local results = {}
  for _, ctags_file in ipairs(tagfiles) do
    for line in Path:new(vim.fn.expand(ctags_file, true)):iter() do
      results[#results + 1] = line
    end
  end

  pickers.new(opts, {
    prompt_title = "Tags",
    finder = finders.new_table {
      results = results,
      entry_maker = opts.entry_maker or make_entry.gen_from_ctags(opts),
    },
    previewer = previewers.ctags.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function()
      action_set.select:enhance {
        post = function()
          local selection = action_state.get_selected_entry()

          if selection.scode then
            -- un-escape / then escape required
            -- special chars for vim.fn.search()
            -- ] ~ *
            local scode = selection.scode:gsub([[\/]], "/"):gsub("[%]~*]", function(x)
              return "\\" .. x
            end)

            vim.cmd "norm! gg"
            vim.fn.search(scode)
            vim.cmd "norm! zz"
          else
            vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
          end
        end,
      }
      return true
    end,
  }):find()
end

files.current_buffer_tags = function(opts)
  return files.tags(vim.tbl_extend("force", {
    prompt_title = "Current Buffer Tags",
    only_current_file = true,
    path_display = "hidden",
  }, opts))
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

return apply_checks(files)
