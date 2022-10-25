require "telescope"

local a = vim.api

local async = require "plenary.async"
local await_schedule = async.util.scheduler
local channel = require("plenary.async.control").channel
local popup = require "plenary.popup"

local actions = require "telescope.actions"
local config = require "telescope.config"
local debounce = require "telescope.debounce"
local deprecated = require "telescope.deprecated"
local log = require "telescope.log"
local mappings = require "telescope.mappings"
local state = require "telescope.state"
local utils = require "telescope.utils"

local entry_display = require "telescope.pickers.entry_display"
local p_highlighter = require "telescope.pickers.highlights"
local p_scroller = require "telescope.pickers.scroller"
local p_window = require "telescope.pickers.window"

local EntryManager = require "telescope.entry_manager"
local MultiSelect = require "telescope.pickers.multi"

local truncate = require("plenary.strings").truncate
local strdisplaywidth = require("plenary.strings").strdisplaywidth

local ns_telescope_matching = a.nvim_create_namespace "telescope_matching"
local ns_telescope_prompt = a.nvim_create_namespace "telescope_prompt"
local ns_telescope_prompt_prefix = a.nvim_create_namespace "telescope_prompt_prefix"

local pickers = {}

-- TODO: Add overscroll option for results buffer

---@class Picker
--- Picker is the main UI that shows up to interact w/ your results.
-- Takes a filter & a previewer
local Picker = {}
Picker.__index = Picker

--- Create new picker
function Picker:new(opts)
  opts = opts or {}

  if opts.layout_strategy and opts.get_window_options then
    error "layout_strategy and get_window_options are not compatible keys"
  end

  if vim.fn.win_gettype() == "command" then
    error "Can't open telescope from command-line window. See E11"
  end

  deprecated.options(opts)

  -- We need to clear at the beginning not on close because after close we can still have select:post
  -- etc ...
  require("telescope.actions.mt").clear_all()
  -- TODO(conni2461): This seems like the better solution but it won't clear actions that were never mapped
  -- for _, v in ipairs(keymap_store[prompt_bufnr]) do
  --   pcall(v.clear)
  -- end

  local layout_strategy = vim.F.if_nil(opts.layout_strategy, config.values.layout_strategy)

  local obj = setmetatable({
    prompt_title = vim.F.if_nil(opts.prompt_title, config.values.prompt_title),
    results_title = vim.F.if_nil(opts.results_title, config.values.results_title),
    -- either whats passed in by the user or whats defined by the previewer
    preview_title = opts.preview_title,

    prompt_prefix = vim.F.if_nil(opts.prompt_prefix, config.values.prompt_prefix),
    wrap_results = vim.F.if_nil(opts.wrap_results, config.values.wrap_results),
    selection_caret = vim.F.if_nil(opts.selection_caret, config.values.selection_caret),
    entry_prefix = vim.F.if_nil(opts.entry_prefix, config.values.entry_prefix),
    multi_icon = vim.F.if_nil(opts.multi_icon, config.values.multi_icon),

    initial_mode = vim.F.if_nil(opts.initial_mode, config.values.initial_mode),
    _original_mode = vim.api.nvim_get_mode().mode,
    debounce = vim.F.if_nil(tonumber(opts.debounce), nil),

    _finder_attached = true,
    default_text = opts.default_text,
    get_status_text = vim.F.if_nil(opts.get_status_text, config.values.get_status_text),
    _on_input_filter_cb = opts.on_input_filter_cb or function() end,

    finder = assert(opts.finder, "Finder is required."),
    sorter = opts.sorter or require("telescope.sorters").empty(),

    all_previewers = opts.previewer,
    current_previewer_index = 1,

    default_selection_index = opts.default_selection_index,

    get_selection_window = vim.F.if_nil(opts.get_selection_window, config.values.get_selection_window),

    cwd = opts.cwd,

    _find_id = 0,
    _completion_callbacks = type(opts._completion_callbacks) == "table" and opts._completion_callbacks or {},
    manager = (type(opts.manager) == "table" and getmetatable(opts.manager) == EntryManager) and opts.manager,
    _multi = (type(opts._multi) == "table" and getmetatable(opts._multi) == getmetatable(MultiSelect:new()))
        and opts._multi
      or MultiSelect:new(),

    track = vim.F.if_nil(opts.track, false),
    stats = {},

    attach_mappings = opts.attach_mappings,
    file_ignore_patterns = vim.F.if_nil(opts.file_ignore_patterns, config.values.file_ignore_patterns),

    scroll_strategy = vim.F.if_nil(opts.scroll_strategy, config.values.scroll_strategy),
    sorting_strategy = vim.F.if_nil(opts.sorting_strategy, config.values.sorting_strategy),
    tiebreak = vim.F.if_nil(opts.tiebreak, config.values.tiebreak),
    selection_strategy = vim.F.if_nil(opts.selection_strategy, config.values.selection_strategy),

    push_cursor_on_edit = vim.F.if_nil(opts.push_cursor_on_edit, false),
    push_tagstack_on_edit = vim.F.if_nil(opts.push_tagstack_on_edit, false),

    layout_strategy = layout_strategy,
    layout_config = config.smarter_depth_2_extend(opts.layout_config or {}, config.values.layout_config or {}),

    __cycle_layout_list = vim.F.if_nil(opts.cycle_layout_list, config.values.cycle_layout_list),

    window = {
      winblend = vim.F.if_nil(
        opts.winblend,
        type(opts.window) == "table" and opts.window.winblend or config.values.winblend
      ),
      border = vim.F.if_nil(opts.border, type(opts.window) == "table" and opts.window.border or config.values.border),
      borderchars = vim.F.if_nil(
        opts.borderchars,
        type(opts.window) == "table" and opts.window.borderchars or config.values.borderchars
      ),
    },

    cache_picker = config.resolve_table_opts(opts.cache_picker, vim.deepcopy(config.values.cache_picker)),

    __scrolling_limit = tonumber(vim.F.if_nil(opts.temp__scrolling_limit, 250)),
  }, self)

  obj.get_window_options = opts.get_window_options or p_window.get_window_options

  if obj.all_previewers ~= nil and obj.all_previewers ~= false then
    if obj.all_previewers[1] == nil then
      obj.all_previewers = { obj.all_previewers }
    end
    obj.previewer = obj.all_previewers[1]
    if obj.preview_title == nil then
      obj.preview_title = obj.previewer:title(nil, config.values.dynamic_preview_title)
    else
      obj.fix_preview_title = true
    end
  else
    obj.previewer = false
  end

  local __hide_previewer = opts.__hide_previewer
  if __hide_previewer then
    obj.hidden_previewer = obj.previewer
    obj.previewer = nil
  else
    obj.hidden_previewer = nil
  end

  -- TODO: It's annoying that this is create and everything else is "new"
  obj.scroller = p_scroller.create(obj.scroll_strategy, obj.sorting_strategy)

  obj.highlighter = p_highlighter.new(obj)

  if opts.on_complete then
    for _, on_complete_item in ipairs(opts.on_complete) do
      obj:register_completion_callback(on_complete_item)
    end
  end

  return obj
end

--- Take an index and get a row.
---@note: Rows are 0-indexed, and `index` is 1 indexed (table index)
---@param index number: the index in line_manager
---@return number: the row for the picker to display in
function Picker:get_row(index)
  if self.sorting_strategy == "ascending" then
    return index - 1
  else
    return self.max_results - index
  end
end

--- Take a row and get an index
---@note: Rows are 0-indexed, and `index` is 1 indexed (table index)
---@param row number: The row being displayed
---@return number: The index in line_manager
function Picker:get_index(row)
  if self.sorting_strategy == "ascending" then
    return row + 1
  else
    return self.max_results - row
  end
end

--- Get the row number of the "best" entry
---@return number: the number of the "reset" row
function Picker:get_reset_row()
  if self.sorting_strategy == "ascending" then
    return 0
  else
    return self.max_results - 1
  end
end

--- Check if the picker is no longer in use
---@return boolean|nil: `true` if picker is closed, `nil` otherwise
function Picker:is_done()
  if not self.manager then
    return true
  end
end

--- Clear rows that are after the final remaining entry
---@note: useful when number of remaining results is narrowed down
---@param results_bufnr number: the buffer number of the results buffer
function Picker:clear_extra_rows(results_bufnr)
  if self:is_done() then
    log.trace "Not clearing due to being already complete"
    return
  end

  if not vim.api.nvim_buf_is_valid(results_bufnr) then
    log.debug("Invalid results_bufnr for clearing:", results_bufnr)
    return
  end

  local worst_line, ok, msg
  if self.sorting_strategy == "ascending" then
    local num_results = self.manager:num_results()
    worst_line = self.max_results - num_results

    if worst_line <= 0 then
      return
    end

    ok, msg = pcall(vim.api.nvim_buf_set_lines, results_bufnr, num_results, -1, false, {})
  else
    worst_line = self:get_row(self.manager:num_results())
    if worst_line <= 0 then
      return
    end

    local empty_lines = utils.repeated_table(worst_line, "")
    ok, msg = pcall(vim.api.nvim_buf_set_lines, results_bufnr, 0, worst_line, false, empty_lines)
  end

  if not ok then
    log.debug("Failed to set lines:", msg)
  end

  log.trace("Clearing:", worst_line)
end

--- Highlight the entry corresponding to the given row
---@param results_bufnr number: the buffer number of the results buffer
---@param prompt table: table with information about the prompt buffer
---@param display string: the text corresponding to the given row
---@param row number: the number of the chosen row
function Picker:highlight_one_row(results_bufnr, prompt, display, row)
  if not self.sorter.highlighter then
    return
  end

  local highlights = self.sorter:highlighter(prompt, display)

  if highlights then
    for _, hl in ipairs(highlights) do
      local highlight, start, finish
      if type(hl) == "table" then
        highlight = hl.highlight or "TelescopeMatching"
        start = hl.start
        finish = hl.finish or hl.start
      elseif type(hl) == "number" then
        highlight = "TelescopeMatching"
        start = hl
        finish = hl
      else
        error "Invalid higlighter fn"
      end

      self:_increment "highlights"

      vim.api.nvim_buf_add_highlight(results_bufnr, ns_telescope_matching, highlight, row, start - 1, finish)
    end
  end

  local entry = self.manager:get_entry(self:get_index(row))
  self.highlighter:hi_multiselect(row, self:is_multi_selected(entry))
end

--- Check if the given row number can be selected
---@param row number: the number of the chosen row in the results buffer
---@return boolean
function Picker:can_select_row(row)
  if self.sorting_strategy == "ascending" then
    return row <= self.manager:num_results() and row < self.max_results
  else
    return row >= 0 and row <= self.max_results and row >= self.max_results - self.manager:num_results()
  end
end

--TODO: document what `find_id` is for
function Picker:_next_find_id()
  local find_id = self._find_id + 1
  self._find_id = find_id

  return find_id
end

--- A helper function for creating each of the windows in a picker
---@param bufnr number: the buffer number to be used in the window
---@param popup_opts table: options to pass to `popup.create`
---@param nowrap boolean: is |'wrap'| disabled in the created window
function Picker:_create_window(bufnr, popup_opts, nowrap)
  local what = bufnr or ""
  local win, opts = popup.create(what, popup_opts)

  a.nvim_win_set_option(win, "winblend", self.window.winblend)
  a.nvim_win_set_option(win, "wrap", not nowrap)
  local border_win = opts and opts.border and opts.border.win_id
  if border_win then
    a.nvim_win_set_option(border_win, "winblend", self.window.winblend)
  end
  return win, opts, border_win
end

--- Opens the given picker for the user to interact with
---@note: this is the main function for pickers, as it actually creates the interface for users
function Picker:find()
  self:close_existing_pickers()
  self:reset_selection()

  self.original_win_id = a.nvim_get_current_win()

  -- User autocmd run it before create Telescope window
  vim.api.nvim_exec_autocmds("User TelescopeFindPre", {})

  -- Create three windows:
  -- 1. Prompt window
  -- 2. Options window
  -- 3. Preview window

  local line_count = vim.o.lines - vim.o.cmdheight
  if vim.o.laststatus ~= 0 then
    line_count = line_count - 1
  end

  local popup_opts = self:get_window_options(vim.o.columns, line_count)

  -- `popup.nvim` massaging so people don't have to remember minheight shenanigans
  popup_opts.results.minheight = popup_opts.results.height
  popup_opts.results.highlight = "TelescopeResultsNormal"
  popup_opts.results.borderhighlight = "TelescopeResultsBorder"
  popup_opts.results.titlehighlight = "TelescopeResultsTitle"
  popup_opts.prompt.minheight = popup_opts.prompt.height
  popup_opts.prompt.highlight = "TelescopePromptNormal"
  popup_opts.prompt.borderhighlight = "TelescopePromptBorder"
  popup_opts.prompt.titlehighlight = "TelescopePromptTitle"
  if popup_opts.preview then
    popup_opts.preview.minheight = popup_opts.preview.height
    popup_opts.preview.highlight = "TelescopePreviewNormal"
    popup_opts.preview.borderhighlight = "TelescopePreviewBorder"
    popup_opts.preview.titlehighlight = "TelescopePreviewTitle"
  end

  local results_win, results_opts, results_border_win =
    self:_create_window("", popup_opts.results, not self.wrap_results)

  local results_bufnr = a.nvim_win_get_buf(results_win)
  pcall(a.nvim_buf_set_option, results_bufnr, "tabstop", 1) -- #1834

  self.results_bufnr = results_bufnr
  self.results_win = results_win
  self.results_border = results_opts and results_opts.border

  local preview_win, preview_opts, preview_bufnr, preview_border_win
  if popup_opts.preview then
    preview_win, preview_opts, preview_border_win = self:_create_window("", popup_opts.preview)
    preview_bufnr = a.nvim_win_get_buf(preview_win)
  end
  -- This is needed for updating the title
  local preview_border = preview_opts and preview_opts.border
  self.preview_win = preview_win
  self.preview_border = preview_border

  local prompt_win, prompt_opts, prompt_border_win = self:_create_window("", popup_opts.prompt)
  local prompt_bufnr = a.nvim_win_get_buf(prompt_win)
  pcall(a.nvim_buf_set_option, prompt_bufnr, "tabstop", 1) -- #1834

  self.prompt_bufnr = prompt_bufnr
  self.prompt_win = prompt_win
  self.prompt_border = prompt_opts and prompt_opts.border

  -- Prompt prefix
  local prompt_prefix = self.prompt_prefix
  a.nvim_buf_set_option(prompt_bufnr, "buftype", "prompt")
  vim.fn.prompt_setprompt(prompt_bufnr, prompt_prefix)
  self.prompt_prefix = prompt_prefix
  self:_reset_prefix_color()

  -- TODO: This could be configurable in the future, but I don't know why you would
  -- want to scroll through more than 10,000 items.
  --
  -- This just lets us stop doing stuff after tons of  things.
  self.max_results = self.__scrolling_limit

  vim.api.nvim_buf_set_lines(results_bufnr, 0, self.max_results, false, utils.repeated_table(self.max_results, ""))

  local status_updater = self:get_status_updater(prompt_win, prompt_bufnr)
  local debounced_status = debounce.throttle_leading(status_updater, 50)

  local tx, rx = channel.mpsc()
  self._on_lines = tx.send

  local find_id = self:_next_find_id()

  if self.default_text then
    self:set_prompt(self.default_text)
  end

  if vim.tbl_contains({ "insert", "normal" }, self.initial_mode) then
    local mode = vim.fn.mode()
    local keys
    if self.initial_mode == "normal" then
      -- n: A<ESC> makes sure cursor is at always at end of prompt w/o default_text
      keys = mode ~= "n" and "<ESC>A<ESC>" or "A<ESC>"
    else
      -- always fully retrigger insert mode: required for going from one picker to next
      keys = mode ~= "n" and "<ESC>A" or "A"
    end
    a.nvim_feedkeys(a.nvim_replace_termcodes(keys, true, false, true), "n", true)
  else
    utils.notify(
      "pickers.find",
      { msg = "`initial_mode` should be one of ['normal', 'insert'] but passed " .. self.initial_mode, level = "ERROR" }
    )
  end

  local main_loop = async.void(function()
    self.sorter:_init()

    -- Do filetype last, so that users can register at the last second.
    pcall(a.nvim_buf_set_option, prompt_bufnr, "filetype", "TelescopePrompt")
    pcall(a.nvim_buf_set_option, results_bufnr, "filetype", "TelescopeResults")

    await_schedule()

    while true do
      -- Wait for the next input
      rx.last()
      await_schedule()

      self:_reset_track()

      if not vim.api.nvim_buf_is_valid(prompt_bufnr) then
        log.debug("ON_LINES: Invalid prompt_bufnr", prompt_bufnr)
        return
      end

      local start_time = vim.loop.hrtime()

      local prompt = self:_get_next_filtered_prompt()

      -- TODO: Entry manager should have a "bulk" setter. This can prevent a lot of redraws from display
      if self.cache_picker == false or self.cache_picker.is_cached ~= true then
        self.sorter:_start(prompt)
        self.manager = EntryManager:new(self.max_results, self.entry_adder, self.stats)

        self:_reset_highlights()
        local process_result = self:get_result_processor(find_id, prompt, debounced_status)
        local process_complete = self:get_result_completor(self.results_bufnr, find_id, prompt, status_updater)

        local ok, msg = pcall(function()
          self.finder(prompt, process_result, process_complete)
        end)

        if not ok then
          log.warn("Finder failed with msg: ", msg)
        end

        local diff_time = (vim.loop.hrtime() - start_time) / 1e6
        if self.debounce and diff_time < self.debounce then
          async.util.sleep(self.debounce - diff_time)
        end
      else
        -- TODO(scroll): This can only happen once, I don't like where it is.
        self:_resume_picker()
      end
    end
  end)

  -- Register attach
  vim.api.nvim_buf_attach(prompt_bufnr, false, {
    on_lines = function(...)
      if self._finder_attached then
        find_id = self:_next_find_id()

        status_updater { completed = false }
        self._on_lines(...)
      end
    end,

    on_detach = function()
      self:_detach()
    end,
  })

  vim.api.nvim_create_augroup("PickerInsert", {})
  -- TODO: Use WinLeave as well?
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = prompt_bufnr,
    group = "PickerInsert",
    nested = true,
    once = true,
    callback = function()
      require("telescope.pickers").on_close_prompt(prompt_bufnr)
    end,
  })
  vim.api.nvim_create_autocmd("VimResized", {
    buffer = prompt_bufnr,
    group = "PickerInsert",
    nested = true,
    callback = function()
      require("telescope.pickers").on_resize_window(prompt_bufnr)
    end,
  })

  self.prompt_bufnr = prompt_bufnr

  state.set_status(
    prompt_bufnr,
    setmetatable({
      prompt_bufnr = prompt_bufnr,
      prompt_win = prompt_win,
      prompt_border_win = prompt_border_win,

      results_bufnr = results_bufnr,
      results_win = results_win,
      results_border_win = results_border_win,

      preview_bufnr = preview_bufnr,
      preview_win = preview_win,
      preview_border_win = preview_border_win,
      picker = self,
    }, {
      __mode = "kv",
    })
  )

  mappings.apply_keymap(prompt_bufnr, self.attach_mappings, config.values.mappings)

  tx.send()
  main_loop()
end

--- A helper function to update picker windows when layout options are changed
function Picker:recalculate_layout()
  local line_count = vim.o.lines - vim.o.cmdheight
  if vim.o.laststatus ~= 0 then
    line_count = line_count - 1
  end

  local popup_opts = self:get_window_options(vim.o.columns, line_count)
  -- `popup.nvim` massaging so people don't have to remember minheight shenanigans
  popup_opts.results.minheight = popup_opts.results.height
  popup_opts.prompt.minheight = popup_opts.prompt.height
  if popup_opts.preview then
    popup_opts.preview.minheight = popup_opts.preview.height
  end

  local status = state.get_status(self.prompt_bufnr)

  local prompt_win = status.prompt_win
  local results_win = status.results_win
  local preview_win = status.preview_win

  local preview_opts, preview_border_win
  if popup_opts.preview then
    if preview_win ~= nil then
      -- Move all popups at the same time
      popup.move(prompt_win, popup_opts.prompt)
      popup.move(results_win, popup_opts.results)
      popup.move(preview_win, popup_opts.preview)
    else
      popup_opts.preview.highlight = "TelescopePreviewNormal"
      popup_opts.preview.borderhighlight = "TelescopePreviewBorder"
      popup_opts.preview.titlehighlight = "TelescopePreviewTitle"
      local preview_bufnr = status.preview_bufnr ~= nil
          and vim.api.nvim_buf_is_valid(status.preview_bufnr)
          and status.preview_bufnr
        or ""
      preview_win, preview_opts, preview_border_win = self:_create_window(preview_bufnr, popup_opts.preview)
      if preview_bufnr == "" then
        preview_bufnr = a.nvim_win_get_buf(preview_win)
      end
      status.preview_win = preview_win
      status.preview_bufnr = preview_bufnr
      status.preview_border_win = preview_border_win
      state.set_status(prompt_win, status)
      self.preview_win = preview_win
      self.preview_border_win = preview_border_win
      self.preview_border = preview_opts and preview_opts.border
      if self.previewer and self.previewer.state and self.previewer.state.winid then
        self.previewer.state.winid = preview_win
      end

      -- Move prompt and results after preview created
      vim.defer_fn(function()
        popup.move(prompt_win, popup_opts.prompt)
        popup.move(results_win, popup_opts.results)
      end, 0)
    end
  elseif preview_win ~= nil then
    popup.move(prompt_win, popup_opts.prompt)
    popup.move(results_win, popup_opts.results)

    -- Remove preview after the prompt and results are moved
    vim.defer_fn(function()
      utils.win_delete("preview_win", preview_win, true)
      utils.win_delete("preview_win", status.preview_border_win, true)
      status.preview_win = nil
      status.preview_border_win = nil
      state.set_status(prompt_win, status)
      self.preview_win = nil
      self.preview_border_win = nil
      self.preview_border = nil
    end, 0)
  else
    popup.move(prompt_win, popup_opts.prompt)
    popup.move(results_win, popup_opts.results)
  end

  -- Temporarily disabled: Draw the screen ASAP. This makes things feel speedier.
  -- vim.cmd [[redraw]]

  -- self.max_results = popup_opts.results.height
end

local update_scroll = function(win, oldinfo, oldcursor, strategy, buf_maxline)
  if strategy == "ascending" then
    vim.api.nvim_win_set_cursor(win, { buf_maxline, 0 })
    vim.api.nvim_win_set_cursor(win, { oldinfo.topline, 0 })
    vim.api.nvim_win_set_cursor(win, oldcursor)
  elseif strategy == "descending" then
    vim.api.nvim_win_set_cursor(win, { 1, 0 })
    vim.api.nvim_win_set_cursor(win, { oldinfo.botline, 0 })
    vim.api.nvim_win_set_cursor(win, oldcursor)
  else
    error(debug.traceback("Unknown sorting strategy: " .. (strategy or "")))
  end
end

--- A wrapper for `Picker:recalculate_layout()` that also handles maintaining cursor position
function Picker:full_layout_update()
  local oldinfo = vim.fn.getwininfo(self.results_win)[1]
  local oldcursor = vim.api.nvim_win_get_cursor(self.results_win)
  self:recalculate_layout()
  self:refresh_previewer()

  -- update scrolled position
  local buf_maxline = #vim.api.nvim_buf_get_lines(self.results_bufnr, 0, -1, false)
  update_scroll(self.results_win, oldinfo, oldcursor, self.sorting_strategy, buf_maxline)
end

-- TODO: update multi-select with the correct tag name when available
--- A simple interface to remove an entry from the results window without
--- closing telescope. This either deletes the current selection or all the
--- selections made using multi-select. It can be used to define actions
--- such as deleting buffers or files.
---
--- Example usage:
--- <code>
--- actions.delete_something = function(prompt_bufnr)
---    local current_picker = action_state.get_current_picker(prompt_bufnr)
---    current_picker:delete_selection(function(selection)
---      -- delete the selection outside of telescope
---    end)
--- end
--- </code>
---
--- Example usage in telescope:
---   - `actions.delete_buffer()`
---@param delete_cb function: called for each selection fn(s) -> bool|nil (true|nil removes the entry from the results)
function Picker:delete_selection(delete_cb)
  vim.validate { delete_cb = { delete_cb, "f" } }
  local original_selection_strategy = self.selection_strategy
  self.selection_strategy = "row"

  local delete_selections = self._multi:get()
  local used_multi_select = true
  if vim.tbl_isempty(delete_selections) then
    table.insert(delete_selections, self:get_selection())
    used_multi_select = false
  end

  local selection_index = {}
  for result_index, result_entry in ipairs(self.finder.results) do
    if vim.tbl_contains(delete_selections, result_entry) then
      table.insert(selection_index, result_index)
    end
  end

  -- Sort in reverse order as removing an entry from the table shifts down the
  -- other elements to close the hole.
  table.sort(selection_index, function(x, y)
    return x > y
  end)
  for _, index in ipairs(selection_index) do
    local delete_cb_return = delete_cb(self.finder.results[index])
    if delete_cb_return == nil or delete_cb_return == true then
      table.remove(self.finder.results, index)
    end
  end

  if used_multi_select then
    self._multi = MultiSelect:new()
  end

  self:refresh()
  vim.defer_fn(function()
    self.selection_strategy = original_selection_strategy
  end, 50)
end

function Picker:set_prompt(text)
  self:reset_prompt(text)
end

--- Closes the windows for the prompt, results and preview
---@param status table: table containing information on the picker
--- and associated windows. Generally obtained from `state.get_status`
function Picker.close_windows(status)
  utils.win_delete("results_win", status.results_win, true, true)
  utils.win_delete("preview_win", status.preview_win, true, true)

  utils.win_delete("prompt_border_win", status.prompt_border_win, true, true)
  utils.win_delete("results_border_win", status.results_border_win, true, true)
  utils.win_delete("preview_border_win", status.preview_border_win, true, true)

  -- we cant use win_delete. We first need to close and then delete the buffer
  vim.api.nvim_win_close(status.prompt_win, true)
  utils.buf_delete(status.prompt_bufnr)

  state.clear_status(status.prompt_bufnr)
end

--- Get the entry table of the current selection
---@return table
function Picker:get_selection()
  return self._selection_entry
end

--- Get the row number of the current selection
---@return number
function Picker:get_selection_row()
  if self._selection_row then
    -- If the current row is no longer selectable than reduce it to num_results - 1, so the next selectable row.
    -- This makes selection_strategy `row` work much better if the selected row is no longer part of the output.
    --TODO(conni2461): Maybe this can be moved to scroller. (currently in a hotfix so not viable)
    if self.selection_strategy == "row" then
      local num_results = self.manager:num_results()
      if self.sorting_strategy == "ascending" then
        if self._selection_row >= num_results then
          return num_results - 1
        end
      else
        local max = self.max_results - num_results
        if self._selection_row < max then
          return self.max_results - num_results
        end
      end
    end
    return self._selection_row
  end
  return self.max_results
end

--- Move the current selection by `change` steps
---@param change number
function Picker:move_selection(change)
  self:set_selection(self:get_selection_row() + change)
end

--- Add the entry of the given row to the multi-select object
---@param row number: the number of the chosen row
function Picker:add_selection(row)
  local entry = self.manager:get_entry(self:get_index(row))
  self._multi:add(entry)

  self:update_prefix(entry, row)
  self:get_status_updater(self.prompt_win, self.prompt_bufnr)()
  self.highlighter:hi_multiselect(row, true)
end

--- Remove the entry of the given row to the multi-select object
---@param row number: the number of the chosen row
function Picker:remove_selection(row)
  local entry = self.manager:get_entry(self:get_index(row))
  self._multi:drop(entry)

  self:update_prefix(entry, row)
  self:get_status_updater(self.prompt_win, self.prompt_bufnr)()
  self.highlighter:hi_multiselect(row, false)
end

--- Check if the given row is in the multi-select object
---@param entry table: table with information about the chosen entry
---@return number: the "count" associated to the entry in the multi-select
--- object (if present), `nil` otherwise
function Picker:is_multi_selected(entry)
  return self._multi:is_selected(entry)
end

--- Get a table containing all of the currently selected entries
---@return table: an integer indexed table of selected entries
function Picker:get_multi_selection()
  return self._multi:get()
end

--- Toggle the given row in and out of the multi-select object.
--- Also updates the highlighting for the given entry
---@param row number: the number of the chosen row
function Picker:toggle_selection(row)
  local entry = self.manager:get_entry(self:get_index(row))
  if entry == nil then
    return
  end
  self._multi:toggle(entry)

  self:update_prefix(entry, row)
  self:get_status_updater(self.prompt_win, self.prompt_bufnr)()
  self.highlighter:hi_multiselect(row, self._multi:is_selected(entry))
end

--- Set the current selection to `nil`
---@note: generally used when a picker is first activated with `find()`
function Picker:reset_selection()
  self._selection_entry = nil
  self._selection_row = nil
end

function Picker:_reset_prefix_color(hl_group)
  self._current_prefix_hl_group = hl_group or nil

  if self.prompt_prefix ~= "" then
    vim.api.nvim_buf_add_highlight(
      self.prompt_bufnr,
      ns_telescope_prompt_prefix,
      self._current_prefix_hl_group or "TelescopePromptPrefix",
      0,
      0,
      #self.prompt_prefix
    )
  end
end

-- TODO(conni2461): Maybe _ prefix these next two functions
-- TODO(conni2461): Next two functions only work together otherwise color doesn't work
--                  Probably a issue with prompt buffers
--- Change the prefix in the prompt to be `new_prefix` and apply `hl_group`
---@param new_prefix string: the string to be used as the new prefix
---@param hl_group string: the name of the chosen highlight
function Picker:change_prompt_prefix(new_prefix, hl_group)
  if not new_prefix then
    return
  end

  if new_prefix ~= "" then
    vim.fn.prompt_setprompt(self.prompt_bufnr, new_prefix)
  else
    vim.api.nvim_buf_set_text(self.prompt_bufnr, 0, 0, 0, #self.prompt_prefix, {})
    vim.api.nvim_buf_set_option(self.prompt_bufnr, "buftype", "")
  end
  self.prompt_prefix = new_prefix
  self:_reset_prefix_color(hl_group)
end

--- Reset the prompt to the provided `text`
---@param text string
function Picker:reset_prompt(text)
  local prompt_text = self.prompt_prefix .. (text or "")
  vim.api.nvim_buf_set_lines(self.prompt_bufnr, 0, -1, false, { prompt_text })
  self:_reset_prefix_color(self._current_prefix_hl_group)

  if text then
    vim.api.nvim_win_set_cursor(self.prompt_win, { 1, #prompt_text })
  end
end

---@param finder finder: telescope finder (see telescope/finders.lua)
---@param opts table: options to pass when refreshing the picker
---@field new_prefix string|table: either as string or { new_string, hl_group }
---@field reset_prompt bool: whether to reset the prompt
---@field multi MultiSelect: multi-selection to persist upon renewing finder (see telescope/pickers/multi.lua)
function Picker:refresh(finder, opts)
  opts = opts or {}
  if opts.new_prefix then
    local handle = type(opts.new_prefix) == "table" and unpack or function(x)
      return x
    end
    self:change_prompt_prefix(handle(opts.new_prefix), opts.prefix_hl_group)
  end

  if finder then
    self.finder:close()
    self.finder = finder
    self._multi = vim.F.if_nil(opts.multi, MultiSelect:new())
  end

  -- reset already triggers finder loop
  if opts.reset_prompt then
    self:reset_prompt()
  else
    self._on_lines(nil, nil, nil, 0, 1)
  end
end

---Set the selection to the provided `row`
---@param row number
function Picker:set_selection(row)
  if not self.manager then
    return
  end

  row = self.scroller(self.max_results, self.manager:num_results(), row)

  if not self:can_select_row(row) then
    -- If the current selected row exceeds number of currently displayed
    -- elements we have to reset it. Affects sorting_strategy = 'row'.
    if not self:can_select_row(self:get_selection_row()) then
      row = self:get_row(self.manager:num_results())
    else
      log.trace("Cannot select row:", row, self.manager:num_results(), self.max_results)
      return
    end
  end

  local results_bufnr = self.results_bufnr
  if not a.nvim_buf_is_valid(results_bufnr) then
    return
  end

  if row > a.nvim_buf_line_count(results_bufnr) then
    log.debug(
      string.format("Should not be possible to get row this large %s %s", row, a.nvim_buf_line_count(results_bufnr))
    )

    return
  end

  local entry = self.manager:get_entry(self:get_index(row))
  state.set_global_key("selected_entry", entry)

  if not entry then
    -- also refresh previewer when there is no entry selected, so the preview window is cleared
    self._selection_entry = entry
    self:refresh_previewer()
    return
  end

  local old_entry

  -- TODO: Probably should figure out what the rows are that made this happen...
  --        Probably something with setting a row that's too high for this?
  --        Not sure.
  local set_ok, set_errmsg = pcall(function()
    local prompt = self:_get_prompt()

    -- Check if previous selection is still visible
    if self._selection_entry and self.manager:find_entry(self._selection_entry) then
      -- Find old selection, and update prefix and highlights
      old_entry = self._selection_entry
      local old_row = self:get_row(self.manager:find_entry(old_entry))

      self._selection_entry = entry

      if old_row >= 0 then
        self:update_prefix(old_entry, old_row)
        self.highlighter:hi_multiselect(old_row, self:is_multi_selected(old_entry))
      end
    else
      self._selection_entry = entry
    end

    local caret = self:update_prefix(entry, row)

    local display, _ = entry_display.resolve(self, entry)
    display = caret .. display

    -- TODO: You should go back and redraw the highlights for this line from the sorter.
    -- That's the only smart thing to do.
    if not a.nvim_buf_is_valid(results_bufnr) then
      log.debug "Invalid buf somehow..."
      return
    end

    -- don't highlight any whitespace at the end of caret
    self.highlighter:hi_selection(row, caret:match "(.*%S)")
    self.highlighter:hi_sorter(row, prompt, display)

    self.highlighter:hi_multiselect(row, self:is_multi_selected(entry))
  end)

  if not set_ok then
    log.debug(set_errmsg)
    return
  end

  if old_entry == entry and self._selection_row == row then
    return
  end

  -- TODO: Get row & text in the same obj
  self._selection_entry = entry
  self._selection_row = row

  self:refresh_previewer()

  vim.api.nvim_win_set_cursor(self.results_win, { row + 1, 0 })
end

--- Update prefix for entry on a given row
function Picker:update_prefix(entry, row)
  local prefix = function(sel, multi)
    local t
    if sel then
      t = self.selection_caret
    else
      t = self.entry_prefix
    end
    if multi and type(self.multi_icon) == "string" then
      t = truncate(t, strdisplaywidth(t) - strdisplaywidth(self.multi_icon), "") .. self.multi_icon
    end
    return t
  end

  local line = vim.api.nvim_buf_get_lines(self.results_bufnr, row, row + 1, false)[1]
  if not line then
    log.trace(string.format("no line found at row %d in buffer %d", row, self.results_bufnr))
    return
  end

  local old_caret = string.sub(line, 0, #prefix(true)) == prefix(true) and prefix(true)
    or string.sub(line, 0, #prefix(true, true)) == prefix(true, true) and prefix(true, true)
    or string.sub(line, 0, #prefix(false)) == prefix(false) and prefix(false)
    or string.sub(line, 0, #prefix(false, true)) == prefix(false, true) and prefix(false, true)
  if old_caret == false then
    log.warn(string.format("can't identify old caret in line: %s", line))
    return
  end

  local pre = prefix(entry == self._selection_entry, self:is_multi_selected(entry))
  -- Only change the first couple characters, nvim_buf_set_text leaves the existing highlights
  a.nvim_buf_set_text(self.results_bufnr, row, 0, row, #old_caret, { pre })
  return pre
end

--- Refresh the previewer based on the current `status` of the picker
function Picker:refresh_previewer()
  local status = state.get_status(self.prompt_bufnr)
  if self.previewer and status.preview_win and a.nvim_win_is_valid(status.preview_win) then
    self:_increment "previewed"

    self.previewer:preview(self._selection_entry, status)
    if self.preview_border then
      if self.fix_preview_title then
        return
      end

      local new_title = self.previewer:title(self._selection_entry, config.values.dynamic_preview_title)
      if new_title ~= nil and new_title ~= self.preview_title then
        self.preview_title = new_title
        self.preview_border:change_title(new_title)
      end
    end
  end
end

function Picker:cycle_previewers(next)
  local size = #self.all_previewers
  if size == 1 then
    return
  end

  self.current_previewer_index = self.current_previewer_index + next
  if self.current_previewer_index > size then
    self.current_previewer_index = 1
  elseif self.current_previewer_index < 1 then
    self.current_previewer_index = size
  end

  if self.previewer then
    self.previewer = self.all_previewers[self.current_previewer_index]
    self:refresh_previewer()
  elseif self.hidden_previewer then
    self.hidden_previewer = self.all_previewers[self.current_previewer_index]
  end
end

--- Handler for when entries are added by `self.manager`
---@param index number: the index to add the entry at
---@param entry table: the entry that has been added to the manager
---@param insert boolean: whether the entry has been "inserted" or not
function Picker:entry_adder(index, entry, _, insert)
  if not entry then
    return
  end

  local row = self:get_row(index)

  -- If it's less than 0, then we don't need to show it at all.
  if row < 0 then
    log.debug("ON_ENTRY: Weird row", row)
    return
  end

  local display, display_highlights = entry_display.resolve(self, entry)
  if not display then
    log.info("Weird entry", entry)
    return
  end

  -- This is the two spaces to manage the '> ' stuff.
  -- Maybe someday we can use extmarks or floaty text or something to draw this and not insert here.
  -- until then, insert two spaces
  local prefix = self.entry_prefix
  display = prefix .. display

  self:_increment "displayed"

  local offset = insert and 0 or 1
  if not vim.api.nvim_buf_is_valid(self.results_bufnr) then
    log.debug "ON_ENTRY: Invalid buffer"
    return
  end

  -- TODO: Does this every get called?
  -- local line_count = vim.api.nvim_win_get_height(self.results_win)
  local line_count = vim.api.nvim_buf_line_count(self.results_bufnr)
  if row > line_count then
    return
  end

  if insert then
    if self.sorting_strategy == "descending" then
      vim.api.nvim_buf_set_lines(self.results_bufnr, 0, 1, false, {})
    end
  end

  local set_ok, msg = pcall(vim.api.nvim_buf_set_lines, self.results_bufnr, row, row + offset, false, { display })
  if set_ok then
    if display_highlights then
      self.highlighter:hi_display(row, prefix, display_highlights)
    end
    self:update_prefix(entry, row)
    self:highlight_one_row(self.results_bufnr, self:_get_prompt(), display, row)
  end

  if not set_ok then
    log.debug("Failed to set lines...", msg)
  end

  -- This pretty much only fails when people leave newlines in their results.
  --  So we'll clean it up for them if it fails.
  if not set_ok and display:find "\n" then
    display = display:gsub("\n", " | ")
    vim.api.nvim_buf_set_lines(self.results_bufnr, row, row + 1, false, { display })
  end
end

--- Reset tracked information for this picker
function Picker:_reset_track()
  self.stats.processed = 0
  self.stats.displayed = 0
  self.stats.display_fn = 0
  self.stats.previewed = 0
  self.stats.status = 0

  self.stats.filtered = 0
  self.stats.highlights = 0
end

--- Increment the count of the tracked info at `self.stats[key]`
---@param key string
function Picker:_increment(key)
  self.stats[key] = (self.stats[key] or 0) + 1
end

--- Decrement the count of the tracked info at `self.stats[key]`
---@param key string
function Picker:_decrement(key)
  self.stats[key] = (self.stats[key] or 0) - 1
end

-- TODO: Decide how much we want to use this.
--  Would allow for better debugging of items.
function Picker:register_completion_callback(cb)
  table.insert(self._completion_callbacks, cb)
end

function Picker:clear_completion_callbacks()
  self._completion_callbacks = {}
end

function Picker:_on_complete()
  for _, v in ipairs(self._completion_callbacks) do
    pcall(v, self)
  end
end

--- Close all open Telescope pickers
function Picker:close_existing_pickers()
  for _, prompt_bufnr in ipairs(state.get_existing_prompts()) do
    pcall(actions.close, prompt_bufnr)
  end
end

--- Returns a function that sets virtual text for the count indicator
--- e.g. "10/50" as "filtered"/"processed"
---@param prompt_win number
---@param prompt_bufnr number
---@return function
function Picker:get_status_updater(prompt_win, prompt_bufnr)
  return function(opts)
    if self.closed or not vim.api.nvim_buf_is_valid(prompt_bufnr) then
      return
    end

    local current_prompt = self:_get_prompt()
    if not current_prompt then
      return
    end

    if not vim.api.nvim_win_is_valid(prompt_win) then
      return
    end

    local text = self:get_status_text(opts)
    vim.api.nvim_buf_clear_namespace(prompt_bufnr, ns_telescope_prompt, 0, -1)
    vim.api.nvim_buf_set_extmark(prompt_bufnr, ns_telescope_prompt, 0, 0, {
      virt_text = { { text, "TelescopePromptCounter" } },
      virt_text_pos = "right_align",
    })

    self:_increment "status"
  end
end

--- Returns a function that will process an element.
--- Returned function handles updating the "filtered" and "processed" counts
--- as appropriate and runs the sorters score function
---@param find_id number
---@param prompt string
---@param status_updater function
---@return function
function Picker:get_result_processor(find_id, prompt, status_updater)
  local count = 0

  local cb_add = function(score, entry)
    -- may need the prompt for tiebreak
    self.manager:add_entry(self, score, entry, prompt)
    status_updater { completed = false }
  end

  local cb_filter = function(_)
    self:_increment "filtered"
  end

  return function(entry)
    if find_id ~= self._find_id then
      return true
    end

    if not entry or entry.valid == false then
      return
    end

    self:_increment "processed"

    count = count + 1

    -- TODO: Probably should asyncify this / cache this / do something because this probably takes
    -- a ton of time on large results.
    log.trace("Processing result... ", entry)
    for _, v in ipairs(self.file_ignore_patterns or {}) do
      local file = vim.F.if_nil(entry.filename, type(entry.value) == "string" and entry.value) -- false if none is true
      if file then
        if string.find(file, v) then
          log.trace("SKIPPING", entry.value, "because", v)
          self:_decrement "processed"
          return
        end
      end
    end

    self.sorter:score(prompt, entry, cb_add, cb_filter)
  end
end

--- Handles updating the picker after all the entries are scored/processed.
---@param results_bufnr number
---@param find_id number
---@param prompt string
---@param status_updater function
function Picker:get_result_completor(results_bufnr, find_id, prompt, status_updater)
  return vim.schedule_wrap(function()
    if self.closed == true or self:is_done() then
      return
    end

    self:_do_selection(prompt)

    state.set_global_key("current_line", self:_get_prompt())
    status_updater { completed = true }

    self:clear_extra_rows(results_bufnr)
    self.sorter:_finish(prompt)

    self:_on_complete()
  end)
end

function Picker:_do_selection(prompt)
  local selection_strategy = self.selection_strategy or "reset"
  -- TODO: Either: always leave one result or make sure we actually clean up the results when nothing matches
  if selection_strategy == "row" then
    if self._selection_row == nil and self.default_selection_index ~= nil then
      self:set_selection(self:get_row(self.default_selection_index))
    else
      self:set_selection(self:get_selection_row())
    end
  elseif selection_strategy == "follow" then
    if self._selection_row == nil and self.default_selection_index ~= nil then
      self:set_selection(self:get_row(self.default_selection_index))
    else
      local index = self.manager:find_entry(self:get_selection())

      if index then
        local follow_row = self:get_row(index)
        self:set_selection(follow_row)
      else
        self:set_selection(self:get_reset_row())
      end
    end
  elseif selection_strategy == "reset" then
    if self.default_selection_index ~= nil then
      self:set_selection(self:get_row(self.default_selection_index))
    else
      self:set_selection(self:get_reset_row())
    end
  elseif selection_strategy == "closest" then
    if prompt == "" and self.default_selection_index ~= nil then
      self:set_selection(self:get_row(self.default_selection_index))
    else
      self:set_selection(self:get_reset_row())
    end
  elseif selection_strategy == "none" then
    if self._selection_entry then
      local old_entry, old_row = self._selection_entry, self._selection_row
      self:reset_selection() -- required to reset selection before updating prefix
      if old_row >= 0 then
        self:update_prefix(old_entry, old_row)
        self.highlighter:hi_multiselect(old_row, self:is_multi_selected(old_entry))
      end
    end
    return
  else
    error("Unknown selection strategy: " .. selection_strategy)
  end
end

--- Wrapper function for `Picker:new` that incorporates user provided `opts`
--- with the telescope `defaults`
---@param opts table
---@param defaults table
---@return Picker
pickers.new = function(opts, defaults)
  opts = opts or {}
  defaults = defaults or {}
  local result = {}

  for k, v in pairs(opts) do
    assert(type(k) == "string" or type(k) == "number", "Should be string or number, found: " .. type(k))
    result[k] = v
  end

  for k, v in pairs(defaults) do
    if result[k] == nil then
      assert(type(k) == "string", "Should be string, defaults")
      result[k] = v
    else
      -- For attach mappings, we want people to be able to pass in another function
      -- and apply their mappings after we've applied our defaults.
      if k == "attach_mappings" then
        local opt_value = result[k]
        result[k] = function(...)
          v(...)
          return opt_value(...)
        end
      end
    end
  end

  if result["previewer"] == false then
    result["previewer"] = defaults["previewer"]
    result["__hide_previewer"] = true
  elseif type(opts["preview"]) == "table" and opts["preview"]["hide_on_startup"] then
    result["__hide_previewer"] = true
  end

  return Picker:new(result)
end

--- Close the picker which has prompt with buffer number `prompt_bufnr`
---@param prompt_bufnr number
function pickers.on_close_prompt(prompt_bufnr)
  local status = state.get_status(prompt_bufnr)
  local picker = status.picker
  require("telescope.actions.state").get_current_history():reset()

  if type(picker.cache_picker) == "table" then
    local cached_pickers = state.get_global_key "cached_pickers" or {}

    if type(picker.cache_picker.index) == "number" then
      if not vim.tbl_isempty(cached_pickers) then
        table.remove(cached_pickers, picker.cache_picker.index)
      end
    end

    -- if picker was disabled post-hoc (e.g. `cache_picker = false` conclude after deletion)
    if picker.cache_picker.disabled ~= true then
      if picker.cache_picker.limit_entries > 0 then
        -- edge case: starting in normal mode and not having run a search means having no manager instantiated
        if picker.manager then
          picker.manager.linked_states:truncate(picker.cache_picker.limit_entries)
        else
          picker.manager = EntryManager:new(picker.max_results, picker.entry_adder, picker.stats)
        end
      end
      picker.default_text = picker:_get_prompt()
      picker.cache_picker.selection_row = picker._selection_row
      picker.cache_picker.cached_prompt = picker:_get_prompt()
      picker.cache_picker.is_cached = true
      table.insert(cached_pickers, 1, picker)

      -- release pickers
      if picker.cache_picker.num_pickers > 0 then
        while #cached_pickers > picker.cache_picker.num_pickers do
          table.remove(cached_pickers, #cached_pickers)
        end
      end
      state.set_global_key("cached_pickers", cached_pickers)
    end
  end

  if picker.sorter then
    picker.sorter:_destroy()
  end

  if picker.all_previewers then
    for _, v in ipairs(picker.all_previewers) do
      v:teardown()
    end
  end

  if picker.finder then
    picker.finder:close()
  end

  -- so we dont call close_windows multiple times we clear that autocmd
  vim.api.nvim_clear_autocmds {
    group = "PickerInsert",
    event = "BufLeave",
    buffer = prompt_bufnr,
  }
  picker.close_windows(status)
  mappings.clear(prompt_bufnr)
end

function pickers.on_resize_window(prompt_bufnr)
  local status = state.get_status(prompt_bufnr)
  local picker = status.picker

  picker:full_layout_update()
end

--- Get the prompt text without the prompt prefix.
function Picker:_get_prompt()
  return vim.api.nvim_buf_get_lines(self.prompt_bufnr, 0, 1, false)[1]:sub(#self.prompt_prefix + 1)
end

function Picker:_reset_highlights()
  self.highlighter:clear_display()
  vim.api.nvim_buf_clear_namespace(self.results_bufnr, ns_telescope_matching, 0, -1)
end

-- Toggles whether finder is attached to prompt buffer input
function Picker:_toggle_finder_attach()
  self._finder_attached = not self._finder_attached
end

function Picker:_detach()
  self.finder:close()

  -- TODO: Can we add a "cleanup" / "teardown" function that completely removes these.
  -- self.finder = nil
  -- self.previewer = nil
  -- self.sorter = nil
  -- self.manager = nil

  self.closed = true
end

function Picker:_get_next_filtered_prompt()
  local prompt = self:_get_prompt()
  local on_input_result = self._on_input_filter_cb(prompt) or {}

  local new_prompt = on_input_result.prompt
  if new_prompt then
    prompt = new_prompt
  end

  local new_finder = on_input_result.updated_finder
  if new_finder then
    self.finder:close()
    self.finder = new_finder
  end

  return prompt
end

function Picker:_resume_picker()
  -- resume previous picker
  local index = 1
  for entry in self.manager:iter() do
    self:entry_adder(index, entry, _, true)
    index = index + 1
  end
  self.cache_picker.is_cached = false
  -- if text changed, required to set anew to restart finder; otherwise hl and selection
  if self.cache_picker.cached_prompt ~= self.default_text then
    self:set_prompt(self.default_text)
  else
    -- scheduling required to apply highlighting and selection appropriately
    await_schedule(function()
      if self.cache_picker.selection_row ~= nil then
        self:set_selection(self.cache_picker.selection_row)
      end
    end)
  end
end

pickers._Picker = Picker

return pickers
