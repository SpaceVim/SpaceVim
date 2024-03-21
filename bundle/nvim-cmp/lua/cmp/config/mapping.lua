local types = require('cmp.types')
local misc = require('cmp.utils.misc')
local keymap = require('cmp.utils.keymap')

local function merge_keymaps(base, override)
  local normalized_base = {}
  for k, v in pairs(base) do
    normalized_base[keymap.normalize(k)] = v
  end

  local normalized_override = {}
  for k, v in pairs(override) do
    normalized_override[keymap.normalize(k)] = v
  end

  return misc.merge(normalized_base, normalized_override)
end

local mapping = setmetatable({}, {
  __call = function(_, invoke, modes)
    if type(invoke) == 'function' then
      local map = {}
      for _, mode in ipairs(modes or { 'i' }) do
        map[mode] = invoke
      end
      return map
    end
    return invoke
  end,
})

---Mapping preset configuration.
mapping.preset = {}

---Mapping preset insert-mode configuration.
mapping.preset.insert = function(override)
  return merge_keymaps(override or {}, {
    ['<Down>'] = {
      i = mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
    },
    ['<Up>'] = {
      i = mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
    },
    ['<C-n>'] = {
      i = function()
        local cmp = require('cmp')
        if cmp.visible() then
          cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
    },
    ['<C-p>'] = {
      i = function()
        local cmp = require('cmp')
        if cmp.visible() then
          cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
        else
          cmp.complete()
        end
      end,
    },
    ['<C-y>'] = {
      i = mapping.confirm({ select = false }),
    },
    ['<C-e>'] = {
      i = mapping.abort(),
    },
  })
end

---Mapping preset cmdline-mode configuration.
mapping.preset.cmdline = function(override)
  return merge_keymaps(override or {}, {
    ['<C-z>'] = {
      c = function()
        local cmp = require('cmp')
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.complete()
        end
      end,
    },
    ['<Tab>'] = {
      c = function()
        local cmp = require('cmp')
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.complete()
        end
      end,
    },
    ['<S-Tab>'] = {
      c = function()
        local cmp = require('cmp')
        if cmp.visible() then
          cmp.select_prev_item()
        else
          cmp.complete()
        end
      end,
    },
    ['<C-n>'] = {
      c = function(fallback)
        local cmp = require('cmp')
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
    },
    ['<C-p>'] = {
      c = function(fallback)
        local cmp = require('cmp')
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
    },
    ['<C-e>'] = {
      c = mapping.abort(),
    },
    ['<C-y>'] = {
      c = mapping.confirm({ select = false }),
    },
  })
end

---Invoke completion
---@param option? cmp.CompleteParams
mapping.complete = function(option)
  return function(fallback)
    if not require('cmp').complete(option) then
      fallback()
    end
  end
end

---Complete common string.
mapping.complete_common_string = function()
  return function(fallback)
    if not require('cmp').complete_common_string() then
      fallback()
    end
  end
end

---Close current completion menu if it displayed.
mapping.close = function()
  return function(fallback)
    if not require('cmp').close() then
      fallback()
    end
  end
end

---Abort current completion menu if it displayed.
mapping.abort = function()
  return function(fallback)
    if not require('cmp').abort() then
      fallback()
    end
  end
end

---Scroll documentation window.
mapping.scroll_docs = function(delta)
  return function(fallback)
    if not require('cmp').scroll_docs(delta) then
      fallback()
    end
  end
end

--- Opens the documentation window.
mapping.open_docs = function()
  return function(fallback)
    if not require('cmp').open_docs() then
      fallback()
    end
  end
end

--- Close the documentation window.
mapping.close_docs = function()
  return function(fallback)
    if not require('cmp').close_docs() then
      fallback()
    end
  end
end

---Select next completion item.
mapping.select_next_item = function(option)
  return function(fallback)
    if not require('cmp').select_next_item(option) then
      local release = require('cmp').core:suspend()
      fallback()
      vim.schedule(release)
    end
  end
end

---Select prev completion item.
mapping.select_prev_item = function(option)
  return function(fallback)
    if not require('cmp').select_prev_item(option) then
      local release = require('cmp').core:suspend()
      fallback()
      vim.schedule(release)
    end
  end
end

---Confirm selection
mapping.confirm = function(option)
  return function(fallback)
    if not require('cmp').confirm(option) then
      fallback()
    end
  end
end

return mapping
