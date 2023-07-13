local buf_storage = require("nui.utils.buf_storage")
local is_type = require("nui.utils").is_type
local feature = require("nui.utils")._.feature

local autocmd = {
  event = {
    -- after adding a buffer to the buffer list
    BufAdd = "BufAdd",
    -- deleting a buffer from the buffer list
    BufDelete = "BufDelete",
    -- after entering a buffer
    BufEnter = "BufEnter",
    -- after renaming a buffer
    BufFilePost = "BufFilePost",
    -- before renaming a buffer
    BufFilePre = "BufFilePre",
    -- just after buffer becomes hidden
    BufHidden = "BufHidden",
    -- before leaving a buffer
    BufLeave = "BufLeave",
    -- after the 'modified' state of a buffer changes
    BufModifiedSet = "BufModifiedSet",
    -- after creating any buffer
    BufNew = "BufNew",
    -- when creating a buffer for a new file
    BufNewFile = "BufNewFile",
    -- read buffer using command
    BufReadCmd = "BufReadCmd",
    -- after reading a buffer
    BufReadPost = "BufReadPost",
    -- before reading a buffer
    BufReadPre = "BufReadPre",
    -- just before unloading a buffer
    BufUnload = "BufUnload",
    -- after showing a buffer in a window
    BufWinEnter = "BufWinEnter",
    -- just after buffer removed from window
    BufWinLeave = "BufWinLeave",
    -- just before really deleting a buffer
    BufWipeout = "BufWipeout",
    -- write buffer using command
    BufWriteCmd = "BufWriteCmd",
    -- after writing a buffer
    BufWritePost = "BufWritePost",
    -- before writing a buffer
    BufWritePre = "BufWritePre",
    -- info was received about channel
    ChanInfo = "ChanInfo",
    -- channel was opened
    ChanOpen = "ChanOpen",
    -- command undefined
    CmdUndefined = "CmdUndefined",
    -- command line was modified
    CmdlineChanged = "CmdlineChanged",
    -- after entering cmdline mode
    CmdlineEnter = "CmdlineEnter",
    -- before leaving cmdline mode
    CmdlineLeave = "CmdlineLeave",
    -- after entering the cmdline window
    CmdWinEnter = "CmdwinEnter",
    -- before leaving the cmdline window
    CmdWinLeave = "CmdwinLeave",
    -- after loading a colorscheme
    ColorScheme = "ColorScheme",
    -- before loading a colorscheme
    ColorSchemePre = "ColorSchemePre",
    -- after popup menu changed
    CompleteChanged = "CompleteChanged",
    -- after finishing insert complete
    CompleteDone = "CompleteDone",
    -- idem, before clearing info
    CompleteDonePre = "CompleteDonePre",
    -- cursor in same position for a while
    CursorHold = "CursorHold",
    -- idem, in Insert mode
    CursorHoldI = "CursorHoldI",
    -- cursor was moved
    CursorMoved = "CursorMoved",
    -- cursor was moved in Insert mode
    CursorMovedI = "CursorMovedI",
    -- diffs have been updated
    DiffUpdated = "DiffUpdated",
    -- directory changed
    DirChanged = "DirChanged",
    -- after changing the 'encoding' option
    EncodingChanged = "EncodingChanged",
    -- before exiting
    ExitPre = "ExitPre",
    -- append to a file using command
    FileAppendCmd = "FileAppendCmd",
    -- after appending to a file
    FileAppendPost = "FileAppendPost",
    -- before appending to a file
    FileAppendPre = "FileAppendPre",
    -- before first change to read-only file
    FileChangedRO = "FileChangedRO",
    -- after shell command that changed file
    FileChangedShell = "FileChangedShell",
    -- after (not) reloading changed file
    FileChangedShellPost = "FileChangedShellPost",
    -- read from a file using command
    FileReadCmd = "FileReadCmd",
    -- after reading a file
    FileReadPost = "FileReadPost",
    -- before reading a file
    FileReadPre = "FileReadPre",
    -- new file type detected (user defined)
    FileType = "FileType",
    -- write to a file using command
    FileWriteCmd = "FileWriteCmd",
    -- after writing a file
    FileWritePost = "FileWritePost",
    -- before writing a file
    FileWritePre = "FileWritePre",
    -- after reading from a filter
    FilterReadPost = "FilterReadPost",
    -- before reading from a filter
    FilterReadPre = "FilterReadPre",
    -- after writing to a filter
    FilterWritePost = "FilterWritePost",
    -- before writing to a filter
    FilterWritePre = "FilterWritePre",
    -- got the focus
    FocusGained = "FocusGained",
    -- lost the focus to another app
    FocusLost = "FocusLost",
    -- if calling a function which doesn't exist
    FuncUndefined = "FuncUndefined",
    -- after starting the GUI
    GUIEnter = "GUIEnter",
    -- after starting the GUI failed
    GUIFailed = "GUIFailed",
    -- when changing Insert/Replace mode
    InsertChange = "InsertChange",
    -- before inserting a char
    InsertCharPre = "InsertCharPre",
    -- when entering Insert mode
    InsertEnter = "InsertEnter",
    -- just after leaving Insert mode
    InsertLeave = "InsertLeave",
    -- just before leaving Insert mode
    InsertLeavePre = "InsertLeavePre",
    -- just before popup menu is displayed
    MenuPopup = "MenuPopup",
    -- after changing the mode
    ModeChanged = "ModeChanged",
    -- after setting any option
    OptionSet = "OptionSet",
    -- after :make, :grep etc.
    QuickFixCmdPost = "QuickFixCmdPost",
    -- before :make, :grep etc.
    QuickFixCmdPre = "QuickFixCmdPre",
    -- before :quit
    QuitPre = "QuitPre",
    -- upon string reception from a remote vim
    RemoteReply = "RemoteReply",
    -- when the search wraps around the document
    SearchWrapped = "SearchWrapped",
    -- after loading a session file
    SessionLoadPost = "SessionLoadPost",
    -- after ":!cmd"
    ShellCmdPost = "ShellCmdPost",
    -- after ":1,2!cmd", ":w !cmd", ":r !cmd".
    ShellFilterPost = "ShellFilterPost",
    -- after nvim process received a signal
    Signal = "Signal",
    -- sourcing a Vim script using command
    SourceCmd = "SourceCmd",
    -- after sourcing a Vim script
    SourcePost = "SourcePost",
    -- before sourcing a Vim script
    SourcePre = "SourcePre",
    -- spell file missing
    SpellFileMissing = "SpellFileMissing",
    -- after reading from stdin
    StdinReadPost = "StdinReadPost",
    -- before reading from stdin
    StdinReadPre = "StdinReadPre",
    -- found existing swap file
    SwapExists = "SwapExists",
    -- syntax selected
    Syntax = "Syntax",
    -- a tab has closed
    TabClosed = "TabClosed",
    -- after entering a tab page
    TabEnter = "TabEnter",
    -- before leaving a tab page
    TabLeave = "TabLeave",
    -- when creating a new tab
    TabNew = "TabNew",
    -- after entering a new tab
    TabNewEntered = "TabNewEntered",
    -- after changing 'term'
    TermChanged = "TermChanged",
    -- after the process exits
    TermClose = "TermClose",
    -- after entering Terminal mode
    TermEnter = "TermEnter",
    -- after leaving Terminal mode
    TermLeave = "TermLeave",
    -- after opening a terminal buffer
    TermOpen = "TermOpen",
    -- after setting "v:termresponse"
    TermResponse = "TermResponse",
    -- text was modified
    TextChanged = "TextChanged",
    -- text was modified in Insert mode(no popup)
    TextChangedI = "TextChangedI",
    -- text was modified in Insert mode(popup)
    TextChangedP = "TextChangedP",
    -- after a yank or delete was done (y, d, c)
    TextYankPost = "TextYankPost",
    -- after UI attaches
    UIEnter = "UIEnter",
    -- after UI detaches
    UILeave = "UILeave",
    -- user defined autocommand
    User = "User",
    -- whenthe user presses the same key 42 times
    UserGettingBored = "UserGettingBored",
    -- after starting Vim
    VimEnter = "VimEnter",
    -- before exiting Vim
    VimLeave = "VimLeave",
    -- before exiting Vim and writing ShaDa file
    VimLeavePre = "VimLeavePre",
    -- after Vim window was resized
    VimResized = "VimResized",
    -- after Nvim is resumed
    VimResume = "VimResume",
    -- before Nvim is suspended
    VimSuspend = "VimSuspend",
    -- after closing a window
    WinClosed = "WinClosed",
    -- after entering a window
    WinEnter = "WinEnter",
    -- before leaving a window
    WinLeave = "WinLeave",
    -- when entering a new window
    WinNew = "WinNew",
    -- after scrolling a window
    WinScrolled = "WinScrolled",

    -- alias for `BufAdd`
    BufCreate = "BufAdd",
    -- alias for `BufReadPost`
    BufRead = "BufReadPost",
    -- alias for `BufWritePre`
    BufWrite = "BufWritePre",
    -- alias for `EncodingChanged`
    FileEncoding = "EncodingChanged",
  },
  buf = {
    storage = buf_storage.create("nui.utils.autocmd", { _next_handler_id = 1 }),
  },
}

---@param callback fun(event: table): nil
---@param bufnr integer
local function to_stored_handler(callback, bufnr)
  local handler_id = autocmd.buf.storage[bufnr]._next_handler_id
  autocmd.buf.storage[bufnr]._next_handler_id = handler_id + 1

  autocmd.buf.storage[bufnr][handler_id] = callback

  local command = string.format(":lua require('nui.utils.autocmd').execute_stored_handler(%s, %s)", bufnr, handler_id)

  return command
end

---@param bufnr integer
---@param handler_id number
function autocmd.execute_stored_handler(bufnr, handler_id)
  local handler = autocmd.buf.storage[bufnr][handler_id]
  if is_type("function", handler) then
    handler()
  end
end

---@param name string
---@param opts { clear?: boolean }
function autocmd.create_group(name, opts)
  if feature.lua_autocmd then
    return vim.api.nvim_create_augroup(name, opts)
  end

  vim.cmd(string.format(
    [[
      augroup %s
        %s
      augroup end
    ]],
    name,
    opts.clear and "autocmd!" or ""
  ))
end

---@param name string
function autocmd.delete_group(name)
  if feature.lua_autocmd then
    return vim.api.nvim_del_augroup_by_name(name)
  end

  vim.cmd(string.format(
    [[
      autocmd! %s
      augroup! %s
    ]],
    name,
    name
  ))
end

---@param event string|string[]
---@param opts table
---@param bufnr? integer # to store callback if lua autocmd is not available
function autocmd.create(event, opts, bufnr)
  if feature.lua_autocmd then
    return vim.api.nvim_create_autocmd(event, opts)
  end

  event = is_type("table", event) and table.concat(event, ",") or event
  local pattern = is_type("table", opts.pattern) and table.concat(opts.pattern, ",") or opts.pattern
  if opts.buffer then
    pattern = string.format("<buffer=%s>", opts.buffer)
  end

  if opts.callback then
    local buffer = opts.buffer or bufnr
    if not buffer then
      error("[nui.utils.autocmd] missing param: bufnr")
    end
    opts.command = to_stored_handler(opts.callback, buffer)
  end

  vim.cmd(
    string.format(
      "autocmd %s %s %s %s %s %s",
      opts.group or "",
      event,
      pattern,
      opts.once and "++once" or "",
      opts.nested and "++nested" or "",
      opts.command
    )
  )
end

---@param opts table
function autocmd.delete(opts)
  if feature.lua_autocmd then
    for _, item in ipairs(vim.api.nvim_get_autocmds(opts)) do
      if item.id then
        vim.api.nvim_del_autocmd(item.id)
      end
    end

    return
  end

  local event = is_type("table", opts.event) and table.concat(opts.event, ",") or opts.event
  local pattern = is_type("table", opts.pattern) and table.concat(opts.pattern, ",") or opts.pattern
  if opts.buffer then
    pattern = string.format("<buffer=%s>", opts.buffer)
  end

  vim.cmd(string.format("autocmd! %s %s %s", opts.group or "", event or "*", pattern or ""))
end

---@param event string|string[]
---@param opts table
function autocmd.exec(event, opts)
  local events = is_type("table", event) and event or { event }

  if feature.lua_autocmd then
    vim.api.nvim_exec_autocmds(events, {
      group = opts.group,
      pattern = opts.pattern,
      buffer = opts.buffer,
      modeline = opts.modeline,
      data = opts.data,
    })

    return
  end

  for _, event_name in ipairs(events) do
    local command = string.format(
      [[doautocmd %s %s %s %s]],
      opts.modeline == false and "<nomodeline>" or "",
      opts.group or "",
      event_name,
      opts.pattern or ""
    )

    if opts.buffer then
      vim.api.nvim_buf_call(opts.buffer, function()
        vim.cmd(command)
      end)
    else
      vim.cmd(command)
    end
  end
end

-- @deprecated
---@deprecated
---@param event string | string[]
---@param pattern string | string[]
---@param cmd string
---@param options nil | table<"'once'" | "'nested'", boolean>
function autocmd.define(event, pattern, cmd, options)
  local opts = options or {}
  opts.pattern = pattern
  opts.command = cmd
  autocmd.create(event, opts)
end

-- @deprecated
---@deprecated
---@param group_name string
---@param auto_clear boolean
---@param definitions table<"'event'" | "'pattern'" | "'cmd'" | "'options'", any>
function autocmd.define_grouped(group_name, auto_clear, definitions)
  if not is_type("boolean", auto_clear) then
    error("invalid param type: auto_clear, expected boolean")
  end

  autocmd.create_group(group_name, { clear = auto_clear })

  for _, definition in ipairs(definitions) do
    autocmd.define(definition.event, definition.pattern, definition.cmd, definition.options)
  end
end

-- @deprecated
---@deprecated
---@param group_name nil | string
---@param event nil | string | string[]
---@param pattern nil | string | string[]
function autocmd.remove(group_name, event, pattern)
  autocmd.delete({
    event = event,
    group = group_name,
    pattern = pattern,
  })
end

---@param bufnr number
---@param event string | string[]
---@param handler string | function
---@param options nil | table<"'once'" | "'nested'", boolean>
function autocmd.buf.define(bufnr, event, handler, options)
  local opts = options or {}

  opts.buffer = bufnr

  if is_type("function", handler) then
    opts.callback = handler
  else
    opts.command = handler
  end

  autocmd.create(event, opts, bufnr)
end

---@param bufnr number
---@param group_name nil | string
---@param event nil | string | string[]
function autocmd.buf.remove(bufnr, group_name, event)
  autocmd.delete({
    buffer = bufnr,
    event = event,
    group = group_name,
  })
end

return autocmd
