local core = require('cmp.core')
local source = require('cmp.source')
local config = require('cmp.config')
local feedkeys = require('cmp.utils.feedkeys')
local autocmd = require('cmp.utils.autocmd')
local keymap = require('cmp.utils.keymap')
local misc = require('cmp.utils.misc')
local async = require('cmp.utils.async')

local cmp = {}

cmp.core = core.new()

---Expose types
for k, v in pairs(require('cmp.types.cmp')) do
  cmp[k] = v
end
cmp.lsp = require('cmp.types.lsp')
cmp.vim = require('cmp.types.vim')

---Expose event
cmp.event = cmp.core.event

---Export mapping for special case
cmp.mapping = require('cmp.config.mapping')

---Export default config presets
cmp.config = {}
cmp.config.disable = misc.none
cmp.config.compare = require('cmp.config.compare')
cmp.config.sources = require('cmp.config.sources')
cmp.config.mapping = require('cmp.config.mapping')
cmp.config.window = require('cmp.config.window')

---Sync asynchronous process.
cmp.sync = function(callback)
  return function(...)
    cmp.core.filter:sync(1000)
    if callback then
      return callback(...)
    end
  end
end

---Suspend completion.
cmp.suspend = function()
  return cmp.core:suspend()
end

---Register completion sources
---@param name string
---@param s cmp.Source
---@return integer
cmp.register_source = function(name, s)
  local src = source.new(name, s)
  cmp.core:register_source(src)
  return src.id
end

---Unregister completion source
---@param id integer
cmp.unregister_source = function(id)
  cmp.core:unregister_source(id)
end

---Get current configuration.
---@return cmp.ConfigSchema
cmp.get_config = function()
  return require('cmp.config').get()
end

---Invoke completion manually
---@param option cmp.CompleteParams
cmp.complete = cmp.sync(function(option)
  option = option or {}
  config.set_onetime(option.config)
  cmp.core:complete(cmp.core:get_context({ reason = option.reason or cmp.ContextReason.Manual }))
  return true
end)

---Complete common string in current entries.
cmp.complete_common_string = cmp.sync(function()
  return cmp.core:complete_common_string()
end)

---Return view is visible or not.
cmp.visible = cmp.sync(function()
  return cmp.core.view:visible() or vim.fn.pumvisible() == 1
end)

---Get current selected entry or nil
cmp.get_selected_entry = cmp.sync(function()
  return cmp.core.view:get_selected_entry()
end)

---Get current active entry or nil
cmp.get_active_entry = cmp.sync(function()
  return cmp.core.view:get_active_entry()
end)

---Get current all entries
cmp.get_entries = cmp.sync(function()
  return cmp.core.view:get_entries()
end)

---Close current completion
cmp.close = cmp.sync(function()
  if cmp.core.view:visible() then
    local release = cmp.core:suspend()
    cmp.core.view:close()
    vim.schedule(release)
    return true
  else
    return false
  end
end)

---Abort current completion
cmp.abort = cmp.sync(function()
  if cmp.core.view:visible() then
    local release = cmp.core:suspend()
    cmp.core.view:abort()
    vim.schedule(release)
    return true
  else
    return false
  end
end)

---Select next item if possible
cmp.select_next_item = cmp.sync(function(option)
  option = option or {}
  option.behavior = option.behavior or cmp.SelectBehavior.Insert
  option.count = option.count or 1

  if cmp.core.view:visible() then
    local release = cmp.core:suspend()
    cmp.core.view:select_next_item(option)
    vim.schedule(release)
    return true
  elseif vim.fn.pumvisible() == 1 then
    if option.behavior == cmp.SelectBehavior.Insert then
      feedkeys.call(keymap.t(string.rep('<C-n>', option.count)), 'in')
    else
      feedkeys.call(keymap.t(string.rep('<Down>', option.count)), 'in')
    end
    return true
  end
  return false
end)

---Select prev item if possible
cmp.select_prev_item = cmp.sync(function(option)
  option = option or {}
  option.behavior = option.behavior or cmp.SelectBehavior.Insert
  option.count = option.count or 1

  if cmp.core.view:visible() then
    local release = cmp.core:suspend()
    cmp.core.view:select_prev_item(option)
    vim.schedule(release)
    return true
  elseif vim.fn.pumvisible() == 1 then
    if option.behavior == cmp.SelectBehavior.Insert then
      feedkeys.call(keymap.t(string.rep('<C-p>', option.count)), 'in')
    else
      feedkeys.call(keymap.t(string.rep('<Up>', option.count)), 'in')
    end
    return true
  end
  return false
end)

---Scrolling documentation window if possible
cmp.scroll_docs = cmp.sync(function(delta)
  if cmp.core.view.docs_view:visible() then
    cmp.core.view:scroll_docs(delta)
    return true
  else
    return false
  end
end)

---Whether the documentation window is visible or not.
cmp.visible_docs = cmp.sync(function()
  return cmp.core.view.docs_view:visible()
end)

---Opens the documentation window.
cmp.open_docs = cmp.sync(function()
  if not cmp.visible_docs() then
    cmp.core.view:open_docs()
    return true
  else
    return false
  end
end)

---Closes the documentation window.
cmp.close_docs = cmp.sync(function()
  if cmp.visible_docs() then
    cmp.core.view:close_docs()
    return true
  else
    return false
  end
end)

---Confirm completion
cmp.confirm = cmp.sync(function(option, callback)
  option = option or {}
  option.select = option.select or false
  option.behavior = option.behavior or cmp.get_config().confirmation.default_behavior or cmp.ConfirmBehavior.Insert
  callback = callback or function() end

  if cmp.core.view:visible() then
    local e = cmp.core.view:get_selected_entry()
    if not e and option.select then
      e = cmp.core.view:get_first_entry()
    end
    if e then
      cmp.core:confirm(e, {
        behavior = option.behavior,
      }, function()
        callback()
        cmp.core:complete(cmp.core:get_context({ reason = cmp.ContextReason.TriggerOnly }))
      end)
      return true
    end
  elseif vim.fn.pumvisible() == 1 then
    local index = vim.fn.complete_info({ 'selected' }).selected
    if index == -1 and option.select then
      index = 0
    end
    if index ~= -1 then
      vim.api.nvim_select_popupmenu_item(index, true, true, {})
      return true
    end
  end
  return false
end)

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
  filetype = function(filetype, c)
    config.set_filetype(c, filetype)
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

-- In InsertEnter autocmd, vim will detects mode=normal unexpectedly.
local on_insert_enter = function()
  if config.enabled() then
    cmp.config.compare.scopes:update()
    cmp.config.compare.locality:update()
    cmp.core:prepare()
    cmp.core:on_change('InsertEnter')
  end
end
autocmd.subscribe({ 'CmdlineEnter' }, async.debounce_next_tick(on_insert_enter))
autocmd.subscribe({ 'InsertEnter' }, async.debounce_next_tick_by_keymap(on_insert_enter))

-- async.throttle is needed for performance. The mapping `:<C-u>...<CR>` will fire `CmdlineChanged` for each character.
local on_text_changed = function()
  if config.enabled() then
    cmp.core:on_change('TextChanged')
  end
end
autocmd.subscribe({ 'TextChangedI', 'TextChangedP' }, on_text_changed)
autocmd.subscribe('CmdlineChanged', async.debounce_next_tick(on_text_changed))

autocmd.subscribe('CursorMovedI', function()
  if config.enabled() then
    cmp.core:on_moved()
  else
    cmp.core:reset()
    cmp.core.view:close()
  end
end)

-- If make this asynchronous, the completion menu will not close when the command output is displayed.
autocmd.subscribe({ 'InsertLeave', 'CmdlineLeave' }, function()
  cmp.core:reset()
  cmp.core.view:close()
end)

cmp.event:on('complete_done', function(evt)
  if evt.entry then
    cmp.config.compare.recently_used:add_entry(evt.entry)
  end
  cmp.config.compare.scopes:update()
  cmp.config.compare.locality:update()
end)

cmp.event:on('confirm_done', function(evt)
  if evt.entry then
    cmp.config.compare.recently_used:add_entry(evt.entry)
  end
end)

return cmp
