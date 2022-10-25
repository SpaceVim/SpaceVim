local from_entry = require "telescope.from_entry"
local Path = require "plenary.path"
local utils = require "telescope.utils"
local putils = require "telescope.previewers.utils"
local Previewer = require "telescope.previewers.previewer"
local conf = require("telescope.config").values

local pfiletype = require "plenary.filetype"
local pscan = require "plenary.scandir"

local buf_delete = utils.buf_delete

local previewers = {}

local ns_previewer = vim.api.nvim_create_namespace "telescope.previewers"

local has_file = 1 == vim.fn.executable "file"

-- TODO(fdschmidt93) switch to Job once file_maker callbacks get cleaned up with plenary async
-- avoids SIGABRT from utils.get_os_command_output due to vim.time in fs_stat cb
local function capture(cmd, raw)
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read "*a")
  f:close()
  if raw then
    return s
  end
  s = string.gsub(s, "^%s+", "")
  s = string.gsub(s, "%s+$", "")
  s = string.gsub(s, "[\n\r]+", " ")
  return s
end

local function defaulter(f, default_opts)
  default_opts = default_opts or {}
  return {
    new = function(opts)
      if conf.preview == false and not opts.preview then
        return false
      end
      opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
      if type(conf.preview) == "table" then
        for k, v in pairs(conf.preview) do
          opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
        end
      end
      return f(opts)
    end,
    __call = function()
      local ok, err = pcall(f(default_opts))
      if not ok then
        error(debug.traceback(err))
      end
    end,
  }
end

-- modified vim.split to incorporate a timer
local function split(s, sep, plain, opts)
  opts = opts or {}
  local t = {}
  for c in vim.gsplit(s, sep, plain) do
    table.insert(t, c)
    if opts.preview.timeout then
      local diff_time = (vim.loop.hrtime() - opts.start_time) / 1e6
      if diff_time > opts.preview.timeout then
        return
      end
    end
  end
  return t
end
local bytes_to_megabytes = math.pow(1024, 2)

local color_hash = {
  ["p"] = "TelescopePreviewPipe",
  ["c"] = "TelescopePreviewCharDev",
  ["d"] = "TelescopePreviewDirectory",
  ["b"] = "TelescopePreviewBlock",
  ["l"] = "TelescopePreviewLink",
  ["s"] = "TelescopePreviewSocket",
  ["."] = "TelescopePreviewNormal",
  ["r"] = "TelescopePreviewRead",
  ["w"] = "TelescopePreviewWrite",
  ["x"] = "TelescopePreviewExecute",
  ["-"] = "TelescopePreviewHyphen",
  ["T"] = "TelescopePreviewSticky",
  ["S"] = "TelescopePreviewSticky",
  [2] = "TelescopePreviewSize",
  [3] = "TelescopePreviewUser",
  [4] = "TelescopePreviewGroup",
  [5] = "TelescopePreviewDate",
}
color_hash[6] = function(line)
  return color_hash[line:sub(1, 1)]
end

local colorize_ls = function(bufnr, data, sections)
  local windows_add = Path.path.sep == "\\" and 2 or 0
  for lnum, line in ipairs(data) do
    local section = sections[lnum]
    for i = 1, section[1].end_index - 1 do -- Highlight permissions
      local c = line:sub(i, i)
      vim.api.nvim_buf_add_highlight(bufnr, ns_previewer, color_hash[c], lnum - 1, i - 1, i)
    end
    for i = 2, #section do -- highlights size, (user, group), date and name
      local hl_group = color_hash[i + (i ~= 2 and windows_add or 0)]
      vim.api.nvim_buf_add_highlight(
        bufnr,
        ns_previewer,
        type(hl_group) == "function" and hl_group(line) or hl_group,
        lnum - 1,
        section[i].start_index - 1,
        section[i].end_index - 1
      )
    end
  end
end

local search_cb_jump = function(self, bufnr, query)
  if not query then
    return
  end
  vim.api.nvim_buf_call(bufnr, function()
    pcall(vim.fn.matchdelete, self.state.hl_id, self.state.winid)
    vim.cmd "norm! gg"
    vim.fn.search(query, "W")
    vim.cmd "norm! zz"

    self.state.hl_id = vim.fn.matchadd("TelescopePreviewMatch", query)
  end)
end

local search_teardown = function(self)
  if self.state and self.state.hl_id then
    pcall(vim.fn.matchdelete, self.state.hl_id, self.state.hl_win)
    self.state.hl_id = nil
  end
end

local scroll_fn = function(self, direction)
  if not self.state then
    return
  end

  local input = direction > 0 and [[]] or [[]]
  local count = math.abs(direction)

  vim.api.nvim_win_call(self.state.winid, function()
    vim.cmd([[normal! ]] .. count .. input)
  end)
end

previewers.file_maker = function(filepath, bufnr, opts)
  opts = vim.F.if_nil(opts, {})
  -- TODO(conni2461): here shouldn't be any hardcoded magic numbers ...
  opts.preview = vim.F.if_nil(opts.preview, {})
  opts.preview.timeout = vim.F.if_nil(opts.preview.timeout, 250) -- in ms
  opts.preview.filesize_limit = vim.F.if_nil(opts.preview.filesize_limit, 25) -- in mb
  opts.preview.msg_bg_fillchar = vim.F.if_nil(opts.preview.msg_bg_fillchar, "╱") -- in mb
  opts.preview.treesitter = vim.F.if_nil(opts.preview.treesitter, true)
  if opts.use_ft_detect == nil then
    opts.use_ft_detect = true
  end
  opts.ft = opts.use_ft_detect and pfiletype.detect(filepath)
  if opts.bufname ~= filepath then
    if not vim.in_fast_event() then
      filepath = vim.fn.expand(filepath)
    end
    if type(opts.preview.filetype_hook) == "function" then
      if not opts.preview.filetype_hook(filepath, bufnr, opts) then
        return
      end
    end
    vim.loop.fs_stat(filepath, function(_, stat)
      if not stat then
        return
      end
      if stat.type == "directory" then
        pscan.ls_async(filepath, {
          hidden = true,
          group_directories_first = true,
          on_exit = vim.schedule_wrap(function(data, sections)
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
            colorize_ls(bufnr, data, sections)
            if opts.callback then
              opts.callback(bufnr)
            end
          end),
        })
      else
        if opts.preview.check_mime_type == true and has_file and opts.ft == "" then
          -- avoid SIGABRT in buffer previewer happening with utils.get_os_command_output
          local output = capture(string.format([[file --mime-type -b "%s"]], filepath))
          local mime_type = vim.split(output, "/")[1]
          if mime_type ~= "text" and mime_type ~= "inode" then
            if type(opts.preview.mime_hook) == "function" then
              vim.schedule_wrap(opts.preview.mime_hook)(filepath, bufnr, opts)
            else
              vim.schedule_wrap(putils.set_preview_message)(
                bufnr,
                opts.winid,
                "Binary cannot be previewed",
                opts.preview.msg_bg_fillchar
              )
            end
            return
          end
        end

        if opts.preview.filesize_limit then
          local mb_filesize = math.floor(stat.size / bytes_to_megabytes)
          if mb_filesize > opts.preview.filesize_limit then
            if type(opts.preview.filesize_hook) == "function" then
              vim.schedule_wrap(opts.preview.filesize_hook)(filepath, bufnr, opts)
            else
              vim.schedule_wrap(putils.set_preview_message)(
                bufnr,
                opts.winid,
                "File exceeds preview size limit",
                opts.preview.msg_bg_fillchar
              )
            end
            return
          end
        end

        opts.start_time = vim.loop.hrtime()
        Path:new(filepath):_read_async(vim.schedule_wrap(function(data)
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end
          local processed_data = split(data, "[\r]?\n", _, opts)

          if processed_data then
            local ok = pcall(vim.api.nvim_buf_set_lines, bufnr, 0, -1, false, processed_data)
            if not ok then
              return
            end

            if opts.callback then
              opts.callback(bufnr)
            end
            putils.highlighter(bufnr, opts.ft, opts)
          else
            if type(opts.preview.timeout_hook) == "function" then
              vim.schedule_wrap(opts.preview.timeout_hook)(filepath, bufnr, opts)
            else
              vim.schedule_wrap(putils.set_preview_message)(
                bufnr,
                opts.winid,
                "Previewer timed out",
                opts.preview.msg_bg_fillchar
              )
            end
            return
          end
        end))
      end
    end)
  else
    if opts.callback then
      if vim.in_fast_event() then
        vim.schedule(function()
          opts.callback(bufnr)
        end)
      else
        opts.callback(bufnr)
      end
    end
  end
end

previewers.new_buffer_previewer = function(opts)
  opts = opts or {}

  assert(opts.define_preview, "define_preview is a required function")
  assert(not opts.preview_fn, "preview_fn not allowed")

  local opt_setup = opts.setup
  local opt_teardown = opts.teardown

  local old_bufs = {}
  local bufname_table = {}

  local global_state = require "telescope.state"
  local preview_window_id

  local function get_bufnr(self)
    if not self.state then
      return nil
    end
    return self.state.bufnr
  end

  local function set_bufnr(self, value)
    if self.state then
      self.state.bufnr = value
      table.insert(old_bufs, value)
    end
  end

  local function get_bufnr_by_bufname(self, value)
    if not self.state then
      return nil
    end
    return bufname_table[value]
  end

  local function set_bufname(self, value)
    if self.state then
      self.state.bufname = value
      if value then
        bufname_table[value] = get_bufnr(self)
      end
    end
  end

  function opts.setup(self)
    local state = {}
    if opt_setup then
      vim.tbl_deep_extend("force", state, opt_setup(self))
    end
    return state
  end

  function opts.teardown(self)
    if opt_teardown then
      opt_teardown(self)
    end

    local last_nr
    if opts.keep_last_buf then
      last_nr = global_state.get_global_key "last_preview_bufnr"
      -- Push in another buffer so the last one will not be cleaned up
      if preview_window_id then
        local bufnr = vim.api.nvim_create_buf(false, true)
        utils.win_set_buf_noautocmd(preview_window_id, bufnr)
      end
    end

    set_bufnr(self, nil)
    set_bufname(self, nil)

    for _, bufnr in ipairs(old_bufs) do
      if bufnr ~= last_nr then
        buf_delete(bufnr)
      end
    end
    -- enable resuming picker with existing previewer to avoid lookup of deleted bufs
    bufname_table = {}
  end

  function opts.preview_fn(self, entry, status)
    if get_bufnr(self) == nil then
      set_bufnr(self, vim.api.nvim_win_get_buf(status.preview_win))
      preview_window_id = status.preview_win
    end

    if opts.get_buffer_by_name and get_bufnr_by_bufname(self, opts.get_buffer_by_name(self, entry)) then
      self.state.bufname = opts.get_buffer_by_name(self, entry)
      self.state.bufnr = get_bufnr_by_bufname(self, self.state.bufname)
      utils.win_set_buf_noautocmd(status.preview_win, self.state.bufnr)
    else
      local bufnr = vim.api.nvim_create_buf(false, true)
      set_bufnr(self, bufnr)

      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          utils.win_set_buf_noautocmd(status.preview_win, bufnr)
        end
      end)

      vim.api.nvim_win_set_option(status.preview_win, "winhl", "Normal:TelescopePreviewNormal")
      vim.api.nvim_win_set_option(status.preview_win, "signcolumn", "no")
      vim.api.nvim_win_set_option(status.preview_win, "foldlevel", 100)
      vim.api.nvim_win_set_option(status.preview_win, "wrap", false)
      vim.api.nvim_win_set_option(status.preview_win, "scrollbind", false)

      self.state.winid = status.preview_win
      self.state.bufname = nil
    end

    if opts.keep_last_buf then
      global_state.set_global_key("last_preview_bufnr", self.state.bufnr)
    end

    opts.define_preview(self, entry, status)

    vim.schedule(function()
      if not self or not self.state or not self.state.bufnr then
        return
      end

      if vim.api.nvim_buf_is_valid(self.state.bufnr) then
        vim.api.nvim_buf_call(self.state.bufnr, function()
          vim.cmd "do User TelescopePreviewerLoaded"
        end)
      end
    end)

    if opts.get_buffer_by_name then
      set_bufname(self, opts.get_buffer_by_name(self, entry))
    end
  end

  if not opts.scroll_fn then
    opts.scroll_fn = scroll_fn
  end

  return Previewer:new(opts)
end

previewers.cat = defaulter(function(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.loop.cwd()
  return previewers.new_buffer_previewer {
    title = "File Preview",
    dyn_title = function(_, entry)
      return Path:new(from_entry.path(entry, false, false)):normalize(cwd)
    end,

    get_buffer_by_name = function(_, entry)
      return from_entry.path(entry, false)
    end,

    define_preview = function(self, entry, status)
      local p = from_entry.path(entry, true)
      if p == nil or p == "" then
        return
      end
      conf.buffer_previewer_maker(p, self.state.bufnr, {
        bufname = self.state.bufname,
        winid = self.state.winid,
        preview = opts.preview,
      })
    end,
  }
end, {})

previewers.vimgrep = defaulter(function(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.loop.cwd()

  local jump_to_line = function(self, bufnr, lnum)
    pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns_previewer, 0, -1)
    if lnum and lnum > 0 then
      pcall(vim.api.nvim_buf_add_highlight, bufnr, ns_previewer, "TelescopePreviewLine", lnum - 1, 0, -1)
      pcall(vim.api.nvim_win_set_cursor, self.state.winid, { lnum, 0 })
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd "norm! zz"
      end)
    end
  end

  return previewers.new_buffer_previewer {
    title = "Grep Preview",
    dyn_title = function(_, entry)
      return Path:new(from_entry.path(entry, false, false)):normalize(cwd)
    end,

    get_buffer_by_name = function(_, entry)
      return from_entry.path(entry, false)
    end,

    define_preview = function(self, entry, status)
      -- builtin.buffers: bypass path validation for terminal buffers that don't have appropriate path
      local has_buftype = entry.bufnr and vim.api.nvim_buf_get_option(entry.bufnr, "buftype") ~= "" or false
      local p
      if not has_buftype then
        p = from_entry.path(entry, true)
        if p == nil or p == "" then
          return
        end
      end

      -- Workaround for unnamed buffer when using builtin.buffer
      if entry.bufnr and (p == "[No Name]" or has_buftype) then
        local lines = vim.api.nvim_buf_get_lines(entry.bufnr, 0, -1, false)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        jump_to_line(self, self.state.bufnr, entry.lnum)
      else
        conf.buffer_previewer_maker(p, self.state.bufnr, {
          bufname = self.state.bufname,
          winid = self.state.winid,
          preview = opts.preview,
          callback = function(bufnr)
            jump_to_line(self, bufnr, entry.lnum)
          end,
        })
      end
    end,
  }
end, {})

previewers.qflist = previewers.vimgrep

previewers.ctags = defaulter(function(_)
  local determine_jump = function(entry)
    if entry.scode then
      return function(self)
        -- un-escape / then escape required
        -- special chars for vim.fn.search()
        -- ] ~ *
        local scode = entry.scode:gsub([[\/]], "/"):gsub("[%]~*]", function(x)
          return "\\" .. x
        end)

        pcall(vim.fn.matchdelete, self.state.hl_id, self.state.winid)
        vim.cmd "norm! gg"
        vim.fn.search(scode, "W")
        vim.cmd "norm! zz"

        self.state.hl_id = vim.fn.matchadd("TelescopePreviewMatch", scode)
      end
    else
      return function(self, bufnr)
        if self.state.last_set_bufnr then
          pcall(vim.api.nvim_buf_clear_namespace, self.state.last_set_bufnr, ns_previewer, 0, -1)
        end
        pcall(vim.api.nvim_buf_add_highlight, bufnr, ns_previewer, "TelescopePreviewMatch", entry.lnum - 1, 0, -1)
        pcall(vim.api.nvim_win_set_cursor, self.state.winid, { entry.lnum, 0 })
        self.state.last_set_bufnr = bufnr
      end
    end
  end

  return previewers.new_buffer_previewer {
    title = "Tags Preview",
    teardown = function(self)
      if self.state and self.state.hl_id then
        pcall(vim.fn.matchdelete, self.state.hl_id, self.state.hl_win)
        self.state.hl_id = nil
      elseif self.state and self.state.last_set_bufnr and vim.api.nvim_buf_is_valid(self.state.last_set_bufnr) then
        vim.api.nvim_buf_clear_namespace(self.state.last_set_bufnr, ns_previewer, 0, -1)
      end
    end,

    get_buffer_by_name = function(_, entry)
      return entry.filename
    end,

    define_preview = function(self, entry, status)
      conf.buffer_previewer_maker(entry.filename, self.state.bufnr, {
        bufname = self.state.bufname,
        winid = self.state.winid,
        callback = function(bufnr)
          pcall(vim.api.nvim_buf_call, bufnr, function()
            determine_jump(entry)(self, bufnr)
          end)
        end,
      })
    end,
  }
end, {})

previewers.builtin = defaulter(function(_)
  return previewers.new_buffer_previewer {
    title = "Grep Preview",
    teardown = search_teardown,

    get_buffer_by_name = function(_, entry)
      return entry.filename
    end,

    define_preview = function(self, entry, status)
      local module_name = vim.fn.fnamemodify(vim.fn.fnamemodify(entry.filename, ":h"), ":t")
      local text
      if entry.text:sub(1, #module_name) ~= module_name then
        text = module_name .. "." .. entry.text
      else
        text = entry.text:gsub("_", ".", 1)
      end

      conf.buffer_previewer_maker(entry.filename, self.state.bufnr, {
        bufname = self.state.bufname,
        winid = self.state.winid,
        callback = function(bufnr)
          search_cb_jump(self, bufnr, text)
        end,
      })
    end,
  }
end, {})

previewers.help = defaulter(function(_)
  return previewers.new_buffer_previewer {
    title = "Help Preview",
    teardown = search_teardown,

    get_buffer_by_name = function(_, entry)
      return entry.filename
    end,

    define_preview = function(self, entry, status)
      local query = entry.cmd
      query = query:sub(2)
      query = [[\V]] .. query

      conf.buffer_previewer_maker(entry.filename, self.state.bufnr, {
        bufname = self.state.bufname,
        winid = self.state.winid,
        callback = function(bufnr)
          putils.regex_highlighter(bufnr, "help")
          search_cb_jump(self, bufnr, query)
        end,
      })
    end,
  }
end, {})

previewers.man = defaulter(function(opts)
  local pager = utils.get_lazy_default(opts.PAGER, function()
    return vim.fn.executable "col" == 1 and { "col", "-bx" } or { "cat" }
  end)
  return previewers.new_buffer_previewer {
    title = "Man Preview",
    get_buffer_by_name = function(_, entry)
      return entry.value .. "/" .. entry.section
    end,

    define_preview = function(self, entry, status)
      local win_width = vim.api.nvim_win_get_width(self.state.winid)
      putils.job_maker(vim.deepcopy(pager), self.state.bufnr, {
        writer = { "man", entry.section, entry.value },
        env = { ["MANWIDTH"] = win_width, PATH = vim.env.PATH, MANPATH = vim.env.MANPATH },
        value = entry.value .. "/" .. entry.section,
        bufname = self.state.bufname,
      })
      putils.regex_highlighter(self.state.bufnr, "man")
    end,
  }
end)

previewers.git_branch_log = defaulter(function(opts)
  local highlight_buffer = function(bufnr, content)
    for i = 1, #content do
      local line = content[i]
      local _, hstart = line:find "[%*%s|]*"
      if hstart then
        local hend = hstart + 7
        if hend < #line then
          pcall(
            vim.api.nvim_buf_add_highlight,
            bufnr,
            ns_previewer,
            "TelescopeResultsIdentifier",
            i - 1,
            hstart - 1,
            hend
          )
        end
      end
      local _, cstart = line:find "- %("
      if cstart then
        local cend = string.find(line, "%) ")
        if cend then
          pcall(
            vim.api.nvim_buf_add_highlight,
            bufnr,
            ns_previewer,
            "TelescopeResultsConstant",
            i - 1,
            cstart - 1,
            cend
          )
        end
      end
      local dstart, _ = line:find " %(%d"
      if dstart then
        pcall(
          vim.api.nvim_buf_add_highlight,
          bufnr,
          ns_previewer,
          "TelescopeResultsSpecialComment",
          i - 1,
          dstart,
          #line
        )
      end
    end
  end

  return previewers.new_buffer_previewer {
    title = "Git Branch Preview",
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      local cmd = {
        "git",
        "--no-pager",
        "log",
        "--graph",
        "--pretty=format:%h -%d %s (%cr)",
        "--abbrev-commit",
        "--date=relative",
        entry.value,
      }

      putils.job_maker(cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr, content)
          if not content then
            return
          end
          highlight_buffer(bufnr, content)
        end,
      })
    end,
  }
end, {})

previewers.git_stash_diff = defaulter(function(opts)
  return previewers.new_buffer_previewer {
    title = "Git Stash Preview",
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, _)
      putils.job_maker({ "git", "--no-pager", "stash", "show", "-p", entry.value }, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            putils.regex_highlighter(bufnr, "diff")
          end
        end,
      })
    end,
  }
end, {})

previewers.git_commit_diff_to_parent = defaulter(function(opts)
  return previewers.new_buffer_previewer {
    title = "Git Diff to Parent Preview",
    teardown = search_teardown,
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      local cmd = { "git", "--no-pager", "diff", entry.value .. "^!" }
      if opts.current_file then
        table.insert(cmd, "--")
        table.insert(cmd, opts.current_file)
      end

      putils.job_maker(cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            search_cb_jump(self, bufnr, opts.current_line)
            putils.regex_highlighter(bufnr, "diff")
          end
        end,
      })
    end,
  }
end, {})

previewers.git_commit_diff_to_head = defaulter(function(opts)
  return previewers.new_buffer_previewer {
    title = "Git Diff to Head Preview",
    teardown = search_teardown,

    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      local cmd = { "git", "--no-pager", "diff", "--cached", entry.value }
      if opts.current_file then
        table.insert(cmd, "--")
        table.insert(cmd, opts.current_file)
      end

      putils.job_maker(cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            search_cb_jump(self, bufnr, opts.current_line)
            putils.regex_highlighter(bufnr, "diff")
          end
        end,
      })
    end,
  }
end, {})

previewers.git_commit_diff_as_was = defaulter(function(opts)
  return previewers.new_buffer_previewer {
    title = "Git Show Preview",
    teardown = search_teardown,

    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      local cmd = { "git", "--no-pager", "show" }
      local cf = opts.current_file and Path:new(opts.current_file):make_relative(opts.cwd)
      local value = cf and (entry.value .. ":" .. cf) or entry.value
      local ft = cf and pfiletype.detect(value) or "diff"
      table.insert(cmd, value)

      putils.job_maker(cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            search_cb_jump(self, bufnr, opts.current_line)
            putils.regex_highlighter(bufnr, ft)
          end
        end,
      })
    end,
  }
end, {})

previewers.git_commit_message = defaulter(function(opts)
  local hl_map = {
    "TelescopeResultsIdentifier",
    "TelescopePreviewUser",
    "TelescopePreviewDate",
  }
  return previewers.new_buffer_previewer {
    title = "Git Message",
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      local cmd = { "git", "--no-pager", "log", "-n 1", entry.value }

      putils.job_maker(cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr, content)
          if not content then
            return
          end
          for k, v in ipairs(hl_map) do
            local _, s = content[k]:find "%s"
            if s then
              vim.api.nvim_buf_add_highlight(bufnr, ns_previewer, v, k - 1, s, #content[k])
            end
          end
        end,
      })
    end,
  }
end, {})

previewers.git_file_diff = defaulter(function(opts)
  return previewers.new_buffer_previewer {
    title = "Git File Diff Preview",
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      if entry.status and (entry.status == "??" or entry.status == "A ") then
        local p = from_entry.path(entry, true)
        if p == nil or p == "" then
          return
        end
        conf.buffer_previewer_maker(p, self.state.bufnr, {
          bufname = self.state.bufname,
          winid = self.state.winid,
        })
      else
        putils.job_maker({ "git", "--no-pager", "diff", entry.value }, self.state.bufnr, {
          value = entry.value,
          bufname = self.state.bufname,
          cwd = opts.cwd,
          callback = function(bufnr)
            if vim.api.nvim_buf_is_valid(bufnr) then
              putils.regex_highlighter(bufnr, "diff")
            end
          end,
        })
      end
    end,
  }
end, {})

previewers.autocommands = defaulter(function(_)
  return previewers.new_buffer_previewer {
    title = "Autocommands Preview",
    teardown = function(self)
      if self.state and self.state.last_set_bufnr and vim.api.nvim_buf_is_valid(self.state.last_set_bufnr) then
        pcall(vim.api.nvim_buf_clear_namespace, self.state.last_set_bufnr, ns_previewer, 0, -1)
      end
    end,

    get_buffer_by_name = function(_, entry)
      return entry.value.group_name
    end,

    define_preview = function(self, entry, status)
      local results = vim.tbl_filter(function(x)
        return x.value.group_name == entry.value.group_name
      end, status.picker.finder.results)

      if self.state.last_set_bufnr then
        pcall(vim.api.nvim_buf_clear_namespace, self.state.last_set_bufnr, ns_previewer, 0, -1)
      end

      local selected_row = 0
      if self.state.bufname ~= entry.value.group_name then
        local display = {}
        table.insert(display, string.format(" augroup: %s - [ %d entries ]", entry.value.group_name, #results))
        -- TODO: calculate banner width/string in setup()
        -- TODO: get column characters to be the same HL group as border
        table.insert(display, string.rep("─", vim.fn.getwininfo(status.preview_win)[1].width))

        for idx, item in ipairs(results) do
          if item == entry then
            selected_row = idx
          end
          table.insert(
            display,
            string.format("  %-14s▏%-08s %s", item.value.event, item.value.pattern, item.value.command)
          )
        end

        vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "vim")
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, display)
        vim.api.nvim_buf_add_highlight(self.state.bufnr, 0, "TelescopeBorder", 1, 0, -1)
      else
        for idx, item in ipairs(results) do
          if item == entry then
            selected_row = idx
            break
          end
        end
      end

      vim.api.nvim_buf_add_highlight(self.state.bufnr, ns_previewer, "TelescopePreviewLine", selected_row + 1, 0, -1)
      -- set the cursor position after self.state.bufnr is connected to the
      -- preview window (which is scheduled in new_buffer_previewer)
      vim.schedule(function()
        pcall(vim.api.nvim_win_set_cursor, status.preview_win, { selected_row, 0 })
      end)

      self.state.last_set_bufnr = self.state.bufnr
    end,
  }
end, {})

previewers.highlights = defaulter(function(_)
  return previewers.new_buffer_previewer {
    title = "Highlights Preview",
    teardown = function(self)
      if self.state and self.state.last_set_bufnr and vim.api.nvim_buf_is_valid(self.state.last_set_bufnr) then
        vim.api.nvim_buf_clear_namespace(self.state.last_set_bufnr, ns_previewer, 0, -1)
      end
    end,

    get_buffer_by_name = function()
      return "highlights"
    end,

    define_preview = function(self, entry, status)
      putils.with_preview_window(status, nil, function()
        if not self.state.bufname then
          local output = vim.split(vim.fn.execute "highlight", "\n")
          local hl_groups = {}
          for _, v in ipairs(output) do
            if v ~= "" then
              if v:sub(1, 1) == " " then
                local part_of_old = v:match "%s+(.*)"
                hl_groups[#hl_groups] = hl_groups[#hl_groups] .. part_of_old
              else
                table.insert(hl_groups, v)
              end
            end
          end

          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, hl_groups)
          for k, v in ipairs(hl_groups) do
            local startPos = string.find(v, "xxx", 1, true) - 1
            local endPos = startPos + 3
            local hlgroup = string.match(v, "([^ ]*)%s+.*")
            pcall(vim.api.nvim_buf_add_highlight, self.state.bufnr, 0, hlgroup, k - 1, startPos, endPos)
          end
        end

        pcall(vim.api.nvim_buf_clear_namespace, self.state.bufnr, ns_previewer, 0, -1)
        vim.cmd "norm! gg"
        vim.fn.search(entry.value .. " ")
        local lnum = vim.fn.line "."
        -- That one is actually a match but its better to use it like that then matchadd
        vim.api.nvim_buf_add_highlight(
          self.state.bufnr,
          ns_previewer,
          "TelescopePreviewMatch",
          lnum - 1,
          0,
          #entry.value
        )
      end)
    end,
  }
end, {})

previewers.pickers = defaulter(function(_)
  local ns_telescope_multiselection = vim.api.nvim_create_namespace "telescope_mulitselection"
  local get_row = function(picker, preview_height, index)
    if picker.sorting_strategy == "ascending" then
      return index - 1
    else
      return preview_height - index
    end
  end
  return previewers.new_buffer_previewer {

    dyn_title = function(_, entry)
      if entry.value.default_text and entry.value.default_text ~= "" then
        return string.format("%s ─ %s", entry.value.prompt_title, entry.value.default_text)
      end
      return entry.value.prompt_title
    end,

    get_buffer_by_name = function(_, entry)
      return tostring(entry.value.prompt_bufnr)
    end,

    teardown = function(self)
      if self.state and self.state.last_set_bufnr and vim.api.nvim_buf_is_valid(self.state.last_set_bufnr) then
        vim.api.nvim_buf_clear_namespace(self.state.last_set_bufnr, ns_telescope_multiselection, 0, -1)
      end
    end,

    define_preview = function(self, entry, status)
      putils.with_preview_window(status, nil, function()
        local ns_telescope_entry = vim.api.nvim_create_namespace "telescope_entry"
        local preview_height = vim.api.nvim_win_get_height(status.preview_win)

        if self.state.bufname then
          return
        end

        local picker = entry.value
        -- prefill buffer to be able to set lines individually
        local placeholder = utils.repeated_table(preview_height, "")
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, placeholder)

        for index = 1, math.min(preview_height, picker.manager:num_results()) do
          local row = get_row(picker, preview_height, index)
          local e = picker.manager:get_entry(index)

          local display, display_highlight
          -- if-clause as otherwise function return values improperly unpacked
          if type(e.display) == "function" then
            display, display_highlight = e:display()
          else
            display = e.display
          end

          vim.api.nvim_buf_set_lines(self.state.bufnr, row, row + 1, false, { display })

          if display_highlight ~= nil then
            for _, hl_block in ipairs(display_highlight) do
              vim.api.nvim_buf_add_highlight(
                self.state.bufnr,
                ns_telescope_entry,
                hl_block[2],
                row,
                hl_block[1][1],
                hl_block[1][2]
              )
            end
          end
          if picker._multi:is_selected(e) then
            vim.api.nvim_buf_add_highlight(
              self.state.bufnr,
              ns_telescope_multiselection,
              "TelescopeMultiSelection",
              row,
              0,
              -1
            )
          end
        end
      end)
    end,
  }
end, {})

previewers.display_content = defaulter(function(_)
  return previewers.new_buffer_previewer {
    define_preview = function(self, entry, status)
      putils.with_preview_window(status, nil, function()
        assert(
          type(entry.preview_command) == "function",
          "entry must provide a preview_command function which will put the content into the buffer"
        )
        entry.preview_command(entry, self.state.bufnr)
      end)
    end,
  }
end, {})

return previewers
