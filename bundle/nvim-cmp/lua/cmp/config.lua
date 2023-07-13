local mapping = require('cmp.config.mapping')
local cache = require('cmp.utils.cache')
local keymap = require('cmp.utils.keymap')
local misc = require('cmp.utils.misc')
local api = require('cmp.utils.api')

---@class cmp.Config
---@field public g cmp.ConfigSchema
local config = {}

---@type cmp.Cache
config.cache = cache.new()

---@type cmp.ConfigSchema
config.global = require('cmp.config.default')()

---@type table<integer, cmp.ConfigSchema>
config.buffers = {}

---@type table<string, cmp.ConfigSchema>
config.filetypes = {}

---@type table<string, cmp.ConfigSchema>
config.cmdline = {}

---@type cmp.ConfigSchema
config.onetime = {}

---Set configuration for global.
---@param c cmp.ConfigSchema
config.set_global = function(c)
  config.global = config.normalize(misc.merge(c, config.global))
  config.global.revision = config.global.revision or 1
  config.global.revision = config.global.revision + 1
end

---Set configuration for buffer
---@param c cmp.ConfigSchema
---@param bufnr integer
config.set_buffer = function(c, bufnr)
  local revision = (config.buffers[bufnr] or {}).revision or 1
  config.buffers[bufnr] = c or {}
  config.buffers[bufnr].revision = revision + 1
end

---Set configuration for filetype
---@param c cmp.ConfigSchema
---@param filetypes string[]|string
config.set_filetype = function(c, filetypes)
  for _, filetype in ipairs(type(filetypes) == 'table' and filetypes or { filetypes }) do
    local revision = (config.filetypes[filetype] or {}).revision or 1
    config.filetypes[filetype] = c or {}
    config.filetypes[filetype].revision = revision + 1
  end
end

---Set configuration for cmdline
---@param c cmp.ConfigSchema
---@param cmdtypes string|string[]
config.set_cmdline = function(c, cmdtypes)
  for _, cmdtype in ipairs(type(cmdtypes) == 'table' and cmdtypes or { cmdtypes }) do
    local revision = (config.cmdline[cmdtype] or {}).revision or 1
    config.cmdline[cmdtype] = c or {}
    config.cmdline[cmdtype].revision = revision + 1
  end
end

---Set configuration as oneshot completion.
---@param c cmp.ConfigSchema
config.set_onetime = function(c)
  local revision = (config.onetime or {}).revision or 1
  config.onetime = c or {}
  config.onetime.revision = revision + 1
end

---@return cmp.ConfigSchema
config.get = function()
  local global_config = config.global

  -- The config object already has `revision` key.
  if #vim.tbl_keys(config.onetime) > 1 then
    local onetime_config = config.onetime
    return config.cache:ensure({
      'get',
      'onetime',
      global_config.revision or 0,
      onetime_config.revision or 0,
    }, function()
      local c = {}
      c = misc.merge(c, config.normalize(onetime_config))
      c = misc.merge(c, config.normalize(global_config))
      return c
    end)
  elseif api.is_cmdline_mode() then
    local cmdtype = vim.fn.getcmdtype()
    local cmdline_config = config.cmdline[cmdtype] or { revision = 1, sources = {} }
    return config.cache:ensure({
      'get',
      'cmdline',
      global_config.revision or 0,
      cmdtype,
      cmdline_config.revision or 0,
    }, function()
      local c = {}
      c = misc.merge(c, config.normalize(cmdline_config))
      c = misc.merge(c, config.normalize(global_config))
      return c
    end)
  else
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    local buffer_config = config.buffers[bufnr] or { revision = 1 }
    local filetype_config = config.filetypes[filetype] or { revision = 1 }
    return config.cache:ensure({
      'get',
      'default',
      global_config.revision or 0,
      filetype,
      filetype_config.revision or 0,
      bufnr,
      buffer_config.revision or 0,
    }, function()
      local c = {}
      c = misc.merge(config.normalize(c), config.normalize(buffer_config))
      c = misc.merge(config.normalize(c), config.normalize(filetype_config))
      c = misc.merge(config.normalize(c), config.normalize(global_config))
      return c
    end)
  end
end

---Return cmp is enabled or not.
config.enabled = function()
  local enabled = config.get().enabled
  if type(enabled) == 'function' then
    enabled = enabled()
  end
  return enabled and api.is_suitable_mode()
end

---Return source config
---@param name string
---@return cmp.SourceConfig
config.get_source_config = function(name)
  local c = config.get()
  for _, s in ipairs(c.sources) do
    if s.name == name then
      return s
    end
  end
  return nil
end

---Return the current menu is native or not.
config.is_native_menu = function()
  local c = config.get()
  if c.view and c.view.entries then
    return c.view.entries == 'native' or c.view.entries.name == 'native'
  end
  return false
end

---Normalize mapping key
---@param c any
---@return cmp.ConfigSchema
config.normalize = function(c)
  -- make sure c is not 'nil'
  ---@type any
  c = c == nil and {} or c

  -- Normalize mapping.
  if c.mapping then
    local normalized = {}
    for k, v in pairs(c.mapping) do
      normalized[keymap.normalize(k)] = mapping(v, { 'i' })
    end
    c.mapping = normalized
  end

  -- Notice experimental.native_menu.
  if c.experimental and c.experimental.native_menu then
    vim.api.nvim_echo({
      { '[nvim-cmp] ', 'Normal' },
      { 'experimental.native_menu', 'WarningMsg' },
      { ' is deprecated.\n', 'Normal' },
      { '[nvim-cmp] Please use ', 'Normal' },
      { 'view.entries = "native"', 'WarningMsg' },
      { ' instead.', 'Normal' },
    }, true, {})

    c.view = c.view or {}
    c.view.entries = c.view.entries or 'native'
  end

  -- Notice documentation.
  if c.documentation ~= nil then
    vim.api.nvim_echo({
      { '[nvim-cmp] ', 'Normal' },
      { 'documentation', 'WarningMsg' },
      { ' is deprecated.\n', 'Normal' },
      { '[nvim-cmp] Please use ', 'Normal' },
      { 'window.documentation = cmp.config.window.bordered()', 'WarningMsg' },
      { ' instead.', 'Normal' },
    }, true, {})
    c.window = c.window or {}
    c.window.documentation = c.documentation
  end

  -- Notice sources.[n].opts
  if c.sources then
    for _, s in ipairs(c.sources) do
      if s.opts and not s.option then
        s.option = s.opts
        s.opts = nil
        vim.api.nvim_echo({
          { '[nvim-cmp] ', 'Normal' },
          { 'sources[number].opts', 'WarningMsg' },
          { ' is deprecated.\n', 'Normal' },
          { '[nvim-cmp] Please use ', 'Normal' },
          { 'sources[number].option', 'WarningMsg' },
          { ' instead.', 'Normal' },
        }, true, {})
      end
      s.option = s.option or {}
    end
  end

  return c
end

return config
