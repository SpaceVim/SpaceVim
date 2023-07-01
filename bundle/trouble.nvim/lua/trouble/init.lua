local View = require("trouble.view")
local config = require("trouble.config")
local colors = require("trouble.colors")
local util = require("trouble.util")

colors.setup()

local Trouble = {}

local view

function Trouble.is_open()
  return view and view:is_valid() or false
end

function Trouble.setup(options)
  if vim.fn.has("nvim-0.7.2") == 0 then
    util.error("Trouble needs Neovim >= 0.7.2")
    return
  end
  config.setup(options)
  util.fix_mode(config.options)
  colors.setup()
end

function Trouble.close()
  if Trouble.is_open() then
    view:close()
  end
end

local function get_opts(...)
  local args = { ... }
  if vim.tbl_islist(args) and #args == 1 and type(args[1]) == "table" then
    args = args[1]
  end
  local opts = {}
  for key, value in pairs(args) do
    if type(key) == "number" then
      local k, v = value:match("^(.*)=(.*)$")
      if k then
        opts[k] = v
      elseif opts.mode then
        util.error("unknown option " .. value)
      else
        opts.mode = value
      end
    else
      opts[key] = value
    end
  end
  opts = opts or {}
  util.fix_mode(opts)
  config.options.cmd_options = opts
  return opts
end

function Trouble.open(...)
  local opts = get_opts(...)
  if opts.mode and (opts.mode ~= config.options.mode) then
    config.options.mode = opts.mode
  end

  if opts.severity and (opts.severity ~=config.options.severity) then
    config.options.severity = opts.severity
  end

  opts.focus = true
  opts.on_open = true

  if Trouble.is_open() then
    Trouble.refresh(opts)
  elseif not opts.auto and vim.tbl_contains(config.options.auto_jump, opts.mode) then
    require("trouble.providers").get(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf(), function(results)
      if #results == 1 then
        util.jump_to_item(opts.win, opts.precmd, results[1])
      elseif #results > 0 then
        view = View.create(opts)
      end
    end, config.options)
  else
    view = View.create(opts)
  end
end

function Trouble.toggle(...)
  local opts = get_opts(...)

  if opts.mode and (opts.mode ~= config.options.mode) then
    config.options.mode = opts.mode
    Trouble.open(...)
    return
  end

  if Trouble.is_open() then
    Trouble.close()
  else
    Trouble.open(...)
  end
end

function Trouble.help()
  local lines = { "# Key Bindings" }
  local height = 1
  for command, key in pairs(config.options.action_keys) do
    if type(key) == "table" then
      key = table.concat(key, " | ")
    end
    table.insert(lines, " * **" .. key .. "** " .. command:gsub("_", " "))
    height = height + 1
  end
  -- help
  vim.lsp.util.open_floating_preview(lines, "markdown", {
    border = "single",
    height = 20,
    offset_y = -2,
    offset_x = 2,
  })
end

local updater = util.debounce(100, function()
  -- buff might have been closed during the debounce
  if not Trouble.is_open() then
    util.debug("refresh: not open anymore")
    return
  end

  util.debug("refresh: auto")
  view:update({ auto = true })
end)

function Trouble.refresh(opts)
  opts = opts or {}

  -- dont do an update if this is an automated refresh from a different provider
  if opts.auto then
    if opts.provider == "diagnostics" and config.options.mode == "document_diagnostics" then
      opts.provider = "document_diagnostics"
    elseif opts.provider == "diagnostics" and config.options.mode == "workspace_diagnostics" then
      opts.provider = "workspace_diagnostics"
    elseif opts.provider == "qf" and config.options.mode == "quickfix" then
      opts.provider = "quickfix"
    elseif opts.provider == "qf" and config.options.mode == "loclist" then
      opts.provider = "loclist"
    end
    if opts.provider ~= config.options.mode then
      return
    end
  end

  if Trouble.is_open() then
    if opts.auto then
      updater()
    else
      util.debug("refresh")
      view:update(opts)
    end
  elseif opts.auto and config.options.auto_open and opts.provider == config.options.mode then
    require("trouble.providers").get(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf(), function(results)
      if #results > 0 then
        Trouble.open(opts)
      end
    end, config.options)
  end
end

function Trouble.action(action)
  if action == "toggle_mode" then
    if config.options.mode == "document_diagnostics" then
      config.options.mode = "workspace_diagnostics"
    elseif config.options.mode == "workspace_diagnostics" then
      config.options.mode = "document_diagnostics"
    end
    action = "refresh"
  end

  if action == 'switch_severity' then
    if config.options.severity == nil then
      config.options.severity = vim.diagnostic.severity.ERROR
    elseif config.options.severity < 4 then
      config.options.severity = config.options.severity + 1
    else
      config.options.severity = nil
    end
    action = "refresh"
  end

  if view and action == "on_win_enter" then
    view:on_win_enter()
  end
  if not Trouble.is_open() then
    return Trouble
  end
  if action == "hover" then
    view:hover()
  end
  if action == "jump" then
    view:jump()
  elseif action == "open_split" then
    view:jump({ precmd = "split" })
  elseif action == "open_vsplit" then
    view:jump({ precmd = "vsplit" })
  elseif action == "open_tab" then
    view:jump({ precmd = "tabe" })
  end
  if action == "jump_close" then
    view:jump()
    Trouble.close()
  end
  if action == "open_folds" then
    Trouble.refresh({ open_folds = true })
  end
  if action == "close_folds" then
    Trouble.refresh({ close_folds = true })
  end
  if action == "toggle_fold" then
    view:toggle_fold()
  end
  if action == "on_enter" then
    view:on_enter()
  end
  if action == "on_leave" then
    view:on_leave()
  end
  if action == "cancel" then
    view:switch_to_parent()
  end
  if action == "next" then
    view:next_item()
    return Trouble
  end
  if action == "previous" then
    view:previous_item()
    return Trouble
  end
  if action == "first" then
    view:first_item()
    return Trouble
  end
  if action == "last" then
    view:last_item()
    return Trouble
  end

  if action == "toggle_preview" then
    config.options.auto_preview = not config.options.auto_preview
    if not config.options.auto_preview then
      view:close_preview()
    else
      action = "preview"
    end
  end
  if action == "auto_preview" and config.options.auto_preview then
    action = "preview"
  end
  if action == "preview" then
    view:preview()
  end

  if Trouble[action] then
    Trouble[action]()
  end
  return Trouble
end

function Trouble.next(opts)
  util.fix_mode(opts)
  if view then
    view:next_item(opts)
  end
end

function Trouble.previous(opts)
  util.fix_mode(opts)
  if view then
    view:previous_item(opts)
  end
end

function Trouble.first(opts)
  util.fix_mode(opts)
  if view then
    view:first_item(opts)
  end
end

function Trouble.last(opts)
  util.fix_mode(opts)
  if view then
    view:last_item(opts)
  end
end

function Trouble.get_items()
  if view ~= nil then
    return view.items
  else
    return {}
  end
end

return Trouble
