local core = require('cmp.core')
local source = require('cmp.source')
local config = require('cmp.config')
local feedkeys = require('cmp.utils.feedkeys')
local autocmd = require('cmp.utils.autocmd')
local keymap = require('cmp.utils.keymap')
local misc = require('cmp.utils.misc')

local cmp = {}

cmp.core = core.new()

---Expose types
for k, v in pairs(require('cmp.types.cmp')) do
  cmp[k] = v
end
cmp.lsp = require('cmp.types.lsp')
cmp.vim = require('cmp.types.vim')

---Export default config presets.
cmp.config = {}
cmp.config.disable = misc.none
cmp.config.compare = require('cmp.config.compare')
cmp.config.sources = require('cmp.config.sources')

---Expose event
cmp.event = cmp.core.event

---Export mapping
cmp.mapping = require('cmp.config.mapping')

---Register completion sources
---@param name string
---@param s cmp.Source
---@return number
cmp.register_source = function(name, s)
  local src = source.new(name, s)
  cmp.core:register_source(src)
  return src.id
end

---Unregister completion source
---@param id number
cmp.unregister_source = function(id)
  cmp.core:unregister_source(id)
end

---Get current configuration.
---@return cmp.ConfigSchema
cmp.get_config = function()
  return require('cmp.config').get()
end

---Invoke completion manually
cmp.complete = function()
  cmp.core:complete(cmp.core:get_context({ reason = cmp.ContextReason.Manual }))
  return true
end

---Return view is visible or not.
cmp.visible = function()
  return cmp.core.view:visible() or vim.fn.pumvisible() == 1
end

---Get current selected entry or nil
cmp.get_selected_entry = function()
  return cmp.core.view:get_selected_entry()
end

---Get current active entry or nil
cmp.get_active_entry = function()
  return cmp.core.view:get_active_entry()
end

---Close current completion
cmp.close = function()
  if cmp.core.view:visible() then
    local release = cmp.core:suspend()
    cmp.core.view:close()
    cmp.core:reset()
    vim.schedule(release)
    return true
  else
    return false
  end
end

---Abort current completion
cmp.abort = function()
  if cmp.core.view:visible() then
    local release = cmp.core:suspend()
    cmp.core.view:abort()
    vim.schedule(release)
    return true
  else
    return false
  end
end

---Suspend completion.
cmp.suspend = function()
  return cmp.core:suspend()
end

---Select next item if possible
cmp.select_next_item = function(option)
  option = option or {}

  -- Hack: Ignore when executing macro.
  if vim.fn.reg_executing() ~= '' then
    return true
  end

  if cmp.core.view:visible() then
    local release = cmp.core:suspend()
    cmp.core.view:select_next_item(option)
    vim.schedule(release)
    return true
  elseif vim.fn.pumvisible() == 1 then
    if (option.behavior or cmp.SelectBehavior.Insert) == cmp.SelectBehavior.Insert then
      feedkeys.call(keymap.t('<C-n>'), 'n')
    else
      feedkeys.call(keymap.t('<Down>'), 'n')
    end
    return true
  end
  return false
end

---Select prev item if possible
cmp.select_prev_item = function(option)
  option = option or {}

  -- Hack: Ignore when executing macro.
  if vim.fn.reg_executing() ~= '' then
    return true
  end

  if cmp.core.view:visible() then
    local release = cmp.core:suspend()
    cmp.core.view:select_prev_item(option)
    vim.schedule(release)
    return true
  elseif vim.fn.pumvisible() == 1 then
    if (option.behavior or cmp.SelectBehavior.Insert) == cmp.SelectBehavior.Insert then
      feedkeys.call(keymap.t('<C-p>'), 'n')
    else
      feedkeys.call(keymap.t('<Up>'), 'n')
    end
    return true
  end
  return false
end

---Scrolling documentation window if possible
cmp.scroll_docs = function(delta)
  if cmp.core.view:visible() then
    cmp.core.view:scroll_docs(delta)
    return true
  else
    return false
  end
end

---Confirm completion
cmp.confirm = function(option, callback)
  option = option or {}
  callback = callback or function() end

  -- Hack: Ignore when executing macro.
  if vim.fn.reg_executing() ~= '' then
    return true
  end

  local e = cmp.core.view:get_selected_entry() or (option.select and cmp.core.view:get_first_entry() or nil)
  if e then
    cmp.core:confirm(e, {
      behavior = option.behavior,
    }, function()
      callback()
      cmp.core:complete(cmp.core:get_context({ reason = cmp.ContextReason.TriggerOnly }))
    end)
    return true
  else
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      feedkeys.call(keymap.t('<C-y>'), 'n')
      return true
    end
    return false
  end
end

---Show status
cmp.status = function()
  local kinds = {}
  kinds.available = {}
  kinds.unavailable = {}
  kinds.installed = {}
  kinds.invalid = {}
  local names = {}
  for _, s in pairs(cmp.core.sources) do
    names[s.name] = true

    if config.get_source_config(s.name) then
      if s:is_available() then
        table.insert(kinds.available, s:get_debug_name())
      else
        table.insert(kinds.unavailable, s:get_debug_name())
      end
    else
      table.insert(kinds.installed, s:get_debug_name())
    end
  end
  for _, s in ipairs(config.get().sources) do
    if not names[s.name] then
      table.insert(kinds.invalid, s.name)
    end
  end

  if #kinds.available > 0 then
    vim.api.nvim_echo({ { '\n', 'Normal' } }, false, {})
    vim.api.nvim_echo({ { '# ready source names\n', 'Special' } }, false, {})
    for _, name in ipairs(kinds.available) do
      vim.api.nvim_echo({ { ('- %s\n'):format(name), 'Normal' } }, false, {})
    end
  end

  if #kinds.unavailable > 0 then
    vim.api.nvim_echo({ { '\n', 'Normal' } }, false, {})
    vim.api.nvim_echo({ { '# unavailable source names\n', 'Comment' } }, false, {})
    for _, name in ipairs(kinds.unavailable) do
      vim.api.nvim_echo({ { ('- %s\n'):format(name), 'Normal' } }, false, {})
    end
  end

  if #kinds.installed > 0 then
    vim.api.nvim_echo({ { '\n', 'Normal' } }, false, {})
    vim.api.nvim_echo({ { '# unused source names\n', 'WarningMsg' } }, false, {})
    for _, name in ipairs(kinds.installed) do
      vim.api.nvim_echo({ { ('- %s\n'):format(name), 'Normal' } }, false, {})
    end
  end

  if #kinds.invalid > 0 then
    vim.api.nvim_echo({ { '\n', 'Normal' } }, false, {})
    vim.api.nvim_echo({ { '# unknown source names\n', 'ErrorMsg' } }, false, {})
    for _, name in ipairs(kinds.invalid) do
      vim.api.nvim_echo({ { ('- %s\n'):format(name), 'Normal' } }, false, {})
    end
  end
end

---@type cmp.Setup
cmp.setup = setmetatable({
  global = function(c)
    config.set_global(c)
  end,
  buffer = function(c)
    config.set_buffer(c, vim.api.nvim_get_current_buf())
  end,
  cmdline = function(type, c)
    config.set_cmdline(c, type)
  end,
}, {
  __call = function(self, c)
    self.global(c)
  end,
})

autocmd.subscribe('InsertEnter', function()
  feedkeys.call('', 'i', function()
    if config.enabled() then
      cmp.core:prepare()
      cmp.core:on_change('InsertEnter')
    end
  end)
end)

autocmd.subscribe('InsertLeave', function()
  cmp.core:reset()
  cmp.core.view:close()
end)

autocmd.subscribe('CmdlineEnter', function()
  if config.enabled() then
    cmp.core:prepare()
    cmp.core:on_change('InsertEnter')
  end
end)

autocmd.subscribe('CmdlineLeave', function()
  cmp.core:reset()
  cmp.core.view:close()
end)

autocmd.subscribe('TextChanged', function()
  if config.enabled() then
    cmp.core:on_change('TextChanged')
  end
end)

autocmd.subscribe('CursorMoved', function()
  if config.enabled() then
    cmp.core:on_moved()
  end
end)

cmp.event:on('confirm_done', function(e)
  cmp.config.compare.recently_used:add_entry(e)
end)

return cmp
